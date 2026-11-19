#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>
#include <windows.h>
#include <stdio.h>
#include <string>
#include <vector>
#include "entry_hook.h"
#pragma comment(lib,"advapi32.lib")
#pragma comment(lib,"ws2_32.lib")
static wchar_t hive[256], game[MAX_PATH], dllPath[MAX_PATH], evidence[MAX_PATH];
static int udpPort, tcpPort;
static bool host=false, selftest=false;
static char room[128];
static HKEY privateRoot=nullptr;
static std::wstring machineGameKey(HKEY key,LPCWSTR sub){
 std::wstring full;
 if(key==HKEY_LOCAL_MACHINE)full=L"\\REGISTRY\\MACHINE";
 else if(key==HKEY_CURRENT_USER)full=L"\\REGISTRY\\CURRENTUSER";
 else {
  typedef LONG(WINAPI* Query)(HANDLE,int,PVOID,ULONG,PULONG);
  auto query=(Query)GetProcAddress(GetModuleHandleW(L"ntdll.dll"),"NtQueryKey");BYTE buffer[4096];ULONG size=0;
  if(!query || query(key,3,buffer,sizeof(buffer),&size)<0)return L"";
  DWORD bytes=*(DWORD*)buffer;if(bytes>sizeof(buffer)-4)return L"";full.assign((wchar_t*)(buffer+4),bytes/2);
 }
 if(sub && *sub){full+=L"\\";full+=sub;}
 std::wstring lower=full;for(auto& c:lower)c=(wchar_t)towlower(c);
 if(lower.compare(0,15,L"\\registry\\user\\")==0){size_t end=lower.find(L'\\',15);if(end!=std::wstring::npos){full=L"\\REGISTRY\\CURRENTUSER"+full.substr(end);lower=L"\\registry\\currentuser"+lower.substr(end);}}
 for(auto prefix:{L"\\registry\\machine\\software\\blizzard entertainment\\warcraft iii",L"\\registry\\machine\\software\\wow6432node\\blizzard entertainment\\warcraft iii",L"\\registry\\currentuser\\software\\blizzard entertainment\\warcraft iii"}){
  size_t n=wcslen(prefix);if(lower.compare(0,n,prefix)==0 && (lower.size()==n || lower[n]==L'\\'))return L"Software\\Blizzard Entertainment\\Warcraft III"+full.substr(n);
 }
 return L"";
}
static std::wstring wide(LPCSTR s){if(!s)return L"";int n=MultiByteToWideChar(CP_ACP,0,s,-1,nullptr,0);std::wstring r(n,L'\0');MultiByteToWideChar(CP_ACP,0,s,-1,&r[0],n);r.resize(n-1);return r;}
static LSTATUS WINAPI openW(HKEY k,LPCWSTR sub,DWORD options,REGSAM access,PHKEY out){auto path=machineGameKey(k,sub);return path.empty()?RegOpenKeyExW(k,sub,options,access,out):RegOpenKeyExW(privateRoot,path.c_str(),options,access,out);}
static LSTATUS WINAPI openA(HKEY k,LPCSTR sub,DWORD options,REGSAM access,PHKEY out){auto path=machineGameKey(k,wide(sub).c_str());return path.empty()?RegOpenKeyExA(k,sub,options,access,out):RegOpenKeyExW(privateRoot,path.c_str(),options,access,out);}
static LSTATUS WINAPI createW(HKEY k,LPCWSTR sub,DWORD reserved,LPWSTR cls,DWORD options,REGSAM access,LPSECURITY_ATTRIBUTES sa,PHKEY out,LPDWORD disposition){auto path=machineGameKey(k,sub);return path.empty()?RegCreateKeyExW(k,sub,reserved,cls,options,access,sa,out,disposition):RegCreateKeyExW(privateRoot,path.c_str(),reserved,cls,options,access,sa,out,disposition);}
static LSTATUS WINAPI createA(HKEY k,LPCSTR sub,DWORD reserved,LPSTR cls,DWORD options,REGSAM access,LPSECURITY_ATTRIBUTES sa,PHKEY out,LPDWORD disposition){auto path=machineGameKey(k,wide(sub).c_str());return path.empty()?RegCreateKeyExA(k,sub,reserved,cls,options,access,sa,out,disposition):RegCreateKeyExW(privateRoot,path.c_str(),reserved,nullptr,options,access,sa,out,disposition);}
static void note(const char* text) {
 FILE* f=nullptr; if(evidence[0] && !_wfopen_s(&f,evidence,L"a") && f){fprintf(f,"%lu %lu %s\n",GetCurrentProcessId(),GetTickCount(),text);fclose(f);}
}
static void noteWide(LPCWSTR text){char buffer[4096];WideCharToMultiByte(CP_UTF8,0,text,-1,buffer,sizeof(buffer),nullptr,nullptr);note(buffer);}
extern "C" __declspec(dllexport) void Initialize();
static bool inject(HANDLE process,HANDLE mainThread) {
 // Chain immediately before YDWE's suspended-thread loader, without starting a
 // remote thread (which initializes Warcraft before YDWE can install its loader).
 SIZE_T bytes=(wcslen(dllPath)+1)*sizeof(wchar_t),written=0;
 void* remote=VirtualAllocEx(process,nullptr,bytes,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
 if(!remote || !WriteProcessMemory(process,remote,dllPath,bytes,&written)||written!=bytes)return false;
 CONTEXT context={};context.ContextFlags=CONTEXT_CONTROL;if(!GetThreadContext(mainThread,&context))return false;
 unsigned char code[]={0x68,0,0,0,0,0x9c,0x60,0x68,0,0,0,0,0xb8,0,0,0,0,0xff,0xd0,0x61,0x9d,0xc3};
 DWORD load=(DWORD)LoadLibraryW;memcpy(code+1,&context.Eip,4);memcpy(code+8,&remote,4);memcpy(code+13,&load,4);
 void* stub=VirtualAllocEx(process,nullptr,sizeof(code),MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
 if(!stub || !WriteProcessMemory(process,stub,code,sizeof(code),&written)||written!=sizeof(code))return false;
 DWORD old;if(!VirtualProtectEx(process,stub,sizeof(code),PAGE_EXECUTE_READ,&old))return false;
 FlushInstructionCache(process,stub,sizeof(code));context.Eip=(DWORD)stub;return SetThreadContext(mainThread,&context)!=FALSE;
}
static PROCESS_INFORMATION pending={};
static decltype(&ResumeThread) nextResume=ResumeThread;
static DWORD WINAPI resume(HANDLE thread){
 if(thread==pending.hThread){
  if(!inject(pending.hProcess,thread)){TerminateProcess(pending.hProcess,91);note("CHILD_INJECTION_FAILED");SetLastError(ERROR_DLL_INIT_FAILED);return (DWORD)-1;}
  note("CHILD_ISOLATION_SCHEDULED");pending={};
 }
 return nextResume(thread);
}
static decltype(&CreateProcessW) nextCreate=CreateProcessW;
static BOOL WINAPI createProcess(LPCWSTR app,LPWSTR cmd,LPSECURITY_ATTRIBUTES pa,LPSECURITY_ATTRIBUTES ta,BOOL inherit,DWORD flags,LPVOID env,LPCWSTR cwd,LPSTARTUPINFOW si,LPPROCESS_INFORMATION pi){
 std::wstring command=app?app:(cmd?cmd:L"");
 for(auto& c:command)c=(wchar_t)towlower(c);
 if(command.find(L"war3.exe")==std::wstring::npos)return nextCreate(app,cmd,pa,ta,inherit,flags,env,cwd,si,pi);
 std::wstring executable;
 if(app)executable=app;
 else if(cmd && cmd[0]==L'"'){const wchar_t* end=wcschr(cmd+1,L'"');if(end)executable.assign(cmd+1,(size_t)(end-cmd-1));}
 else if(cmd)executable.assign(cmd,wcscspn(cmd,L" \t"));
 std::wstring expected=std::wstring(game)+L"\\war3.exe";
 if(_wcsicmp(executable.c_str(),expected.c_str())){note("FOREIGN_GAME_PATH_REFUSED");SetLastError(ERROR_ACCESS_DENIED);return FALSE;}
 BOOL result=nextCreate(app,cmd,pa,ta,inherit,flags|CREATE_SUSPENDED,env,game,si,pi);
 if(!result)return result;
 pending=*pi;
 if(!(flags&CREATE_SUSPENDED))resume(pi->hThread);
 return TRUE;
}
static decltype(&bind) nextBind=bind;
static decltype(&sendto) nextSend=sendto;
static decltype(&connect) nextConnect=connect;
static decltype(&recvfrom) nextRecv=recvfrom;
static int WSAAPI isolatedRecv(SOCKET s,char* data,int capacity,int flags,sockaddr* from,int* size){
 int n=nextRecv(s,data,capacity,flags,from,size);
 if(!host && room[0] && n>=21 && (unsigned char)data[0]==0xf7 && (unsigned char)data[1]==0x30){
  const char* end=(const char*)memchr(data+20,0,n-20);
  if(!end || (size_t)(end-data-20)!=strlen(room) || memcmp(data+20,room,strlen(room))){note("FOREIGN_ROOM_DISCARDED");WSASetLastError(WSAEWOULDBLOCK);return SOCKET_ERROR;}
  note("TARGET_ROOM_RECEIVED");
 }
 return n;
}
static int WSAAPI isolatedBind(SOCKET s,const sockaddr* addr,int size){
 note("BIND_CALLED");
 if(addr && size>=sizeof(sockaddr_in) && addr->sa_family==AF_INET){
  sockaddr_in a=*(const sockaddr_in*)addr;int type=0,len=sizeof(type);getsockopt(s,SOL_SOCKET,SO_TYPE,(char*)&type,&len);
  char detail[100];sprintf_s(detail,"BIND type=%d port=%d target=%d",type,ntohs(a.sin_port),udpPort);note(detail);
  if(type==SOCK_DGRAM && ntohs(a.sin_port)==6112){a.sin_port=htons((u_short)udpPort);BOOL reuse=TRUE;setsockopt(s,SOL_SOCKET,SO_REUSEADDR,(char*)&reuse,sizeof(reuse));note("UDP_BIND_ISOLATED");return nextBind(s,(sockaddr*)&a,sizeof(a));}
  if(host && type==SOCK_STREAM){a.sin_port=htons((u_short)tcpPort);note("HOST_BIND_ISOLATED");return nextBind(s,(sockaddr*)&a,sizeof(a));}
 }
 return nextBind(s,addr,size);
}
static int WSAAPI isolatedSend(SOCKET s,const char* data,int len,int flags,const sockaddr* dest,int size){
 if(dest && size>=sizeof(sockaddr_in) && dest->sa_family==AF_INET){
  sockaddr_in a=*(const sockaddr_in*)dest;
  if(ntohs(a.sin_port)==6112){
   a.sin_port=htons((u_short)udpPort);
   if(host && len>=6 && (unsigned char)data[0]==0xf7 && (unsigned char)data[1]==0x30){
    std::vector<char> packet(data,data+len);packet[len-2]=(char)(tcpPort&255);packet[len-1]=(char)(tcpPort>>8);
    return nextSend(s,packet.data(),len,flags,(sockaddr*)&a,sizeof(a));
   }
   return nextSend(s,data,len,flags,(sockaddr*)&a,sizeof(a));
  }
 }
 return nextSend(s,data,len,flags,dest,size);
}
static int WSAAPI isolatedConnect(SOCKET s,const sockaddr* dest,int size){
 if(!host && dest && size>=sizeof(sockaddr_in) && dest->sa_family==AF_INET){
  int port=ntohs(((const sockaddr_in*)dest)->sin_port);
  // Tests only connect to their fixed room port. Fail closed on another LAN room.
  if(port!=tcpPort){note("FOREIGN_CONNECT_REFUSED");WSASetLastError(WSAEACCES);return SOCKET_ERROR;}
  note("TARGET_CONNECT_ALLOWED");
 }
 return nextConnect(s,dest,size);
}
static void* patch(HMODULE module,const char* symbol,WORD ordinal,void* replacement){
 if(!module)return nullptr;BYTE* base=(BYTE*)module;
 auto nt=(IMAGE_NT_HEADERS*)(base+((IMAGE_DOS_HEADER*)base)->e_lfanew);
 DWORD rva=nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;if(!rva)return nullptr;
 for(auto d=(IMAGE_IMPORT_DESCRIPTOR*)(base+rva);d->Name;++d){
  if(!d->OriginalFirstThunk)continue;
  const char* lib=(char*)(base+d->Name);
  bool socketLib=!_stricmp(lib,"ws2_32.dll")||!_stricmp(lib,"wsock32.dll");
  auto names=(IMAGE_THUNK_DATA*)(base+d->OriginalFirstThunk);auto slots=(IMAGE_THUNK_DATA*)(base+d->FirstThunk);
  for(;names->u1.AddressOfData;++names,++slots){
   bool match=IMAGE_SNAP_BY_ORDINAL(names->u1.Ordinal)?(ordinal && socketLib && IMAGE_ORDINAL(names->u1.Ordinal)==ordinal):!strcmp((char*)((IMAGE_IMPORT_BY_NAME*)(base+names->u1.AddressOfData))->Name,symbol);
   if(!match)continue;void* old=(void*)slots->u1.Function;if(old==replacement)return nullptr;
   DWORD protection;if(!VirtualProtect(&slots->u1.Function,sizeof(void*),PAGE_READWRITE,&protection))return nullptr;
   InterlockedExchange((LONG*)&slots->u1.Function,(LONG)replacement);DWORD unused;VirtualProtect(&slots->u1.Function,sizeof(void*),protection,&unused);return old;
  }
 }
 return nullptr;
}
static void installNetwork(HMODULE target){
 if(void* p=patch(target,"bind",2,(void*)isolatedBind)){nextBind=(decltype(nextBind))p;note("BIND_PATCHED");}
 if(void* p=patch(target,"sendto",20,(void*)isolatedSend))nextSend=(decltype(nextSend))p;
 if(void* p=patch(target,"connect",4,(void*)isolatedConnect))nextConnect=(decltype(nextConnect))p;
 if(void* p=patch(target,"recvfrom",17,(void*)isolatedRecv))nextRecv=(decltype(nextRecv))p;
 note("NETWORK_HOOK_READY");
}
static DWORD WINAPI delayedNetwork(LPVOID module){
 Sleep(750);installNetwork((HMODULE)module);
 return 0;
}
static LONG networkScheduled=0;
extern "C" __declspec(dllexport) void Initialize(){
 if(!udpPort)return;
 for(auto module:{GetModuleHandleW(nullptr),GetModuleHandleW(L"ydbase.dll"),GetModuleHandleW(L"Game.dll"),GetModuleHandleW(L"Storm.dll")}){
  patch(module,"RegOpenKeyExW",0,(void*)openW);patch(module,"RegOpenKeyExA",0,(void*)openA);
  patch(module,"RegCreateKeyExW",0,(void*)createW);patch(module,"RegCreateKeyExA",0,(void*)createA);
 }
 for(auto module:{GetModuleHandleW(nullptr),GetModuleHandleW(L"ydbase.dll")}){
  if(void* p=patch(module,"CreateProcessW",0,(void*)createProcess)){nextCreate=(decltype(nextCreate))p;note("CHILD_HOOK_READY");}
  if(void* p=patch(module,"ResumeThread",0,(void*)resume))nextResume=(decltype(nextResume))p;
 }
 HMODULE target=(host||selftest)?GetModuleHandleW(nullptr):GetModuleHandleW(L"Game.dll");
 if(target && !host && !selftest){
  noteWide(GetCommandLineW());
  for(auto moduleName:{L"Game.dll",L"Storm.dll",L"yd_loader.dll",L"zz_pool_context.dll"}){HMODULE module=GetModuleHandleW(moduleName);if(module){wchar_t modulePath[MAX_PATH];GetModuleFileNameW(module,modulePath,MAX_PATH);noteWide(modulePath);}}
 }
 if(!target){note("NETWORK_HOOK_DEFERRED");return;}
 if(host||selftest){installNetwork(target);return;}
 if(InterlockedCompareExchange(&networkScheduled,1,0)==0){HANDLE thread=CreateThread(nullptr,0,delayedNetwork,target,0,nullptr);if(thread)CloseHandle(thread);else note("NETWORK_THREAD_FAILED");}
}
extern "C" __declspec(dllexport) const char* PluginName(){return "pool_context";}
BOOL WINAPI DllMain(HINSTANCE instance,DWORD reason,LPVOID){
 if(reason!=DLL_PROCESS_ATTACH)return TRUE;
 DisableThreadLibraryCalls(instance);
 if(!GetEnvironmentVariableW(L"WAR3_POOL_HIVE",hive,256))return TRUE;
 GetEnvironmentVariableW(L"WAR3_POOL_GAME",game,MAX_PATH);GetEnvironmentVariableW(L"WAR3_POOL_EVIDENCE",evidence,MAX_PATH);
 GetEnvironmentVariableW(L"WAR3_POOL_DLL",dllPath,MAX_PATH);
 GetEnvironmentVariableA("WAR3_POOL_ROOM",room,sizeof(room));
 wchar_t port[16]={0};GetEnvironmentVariableW(L"WAR3_POOL_UDP",port,16);udpPort=_wtoi(port);tcpPort=udpPort+1;
 wchar_t exe[MAX_PATH];GetModuleFileNameW(nullptr,exe,MAX_PATH);host=wcsstr(exe,L"ydhost.exe")!=nullptr;
 char exeText[MAX_PATH*3];WideCharToMultiByte(CP_UTF8,0,exe,-1,exeText,sizeof(exeText),nullptr,nullptr);note(exeText);
 // Slot-specific evidence is inherited from the owning launch. CIM represents
 // creation time at microsecond precision, so use the same UTC tick rounding.
 FILETIME birth, exited, kernel, user;
 if(GetProcessTimes(GetCurrentProcess(), &birth, &exited, &kernel, &user)){
  ULARGE_INTEGER time;time.LowPart=birth.dwLowDateTime;time.HighPart=birth.dwHighDateTime;
  char identity[MAX_PATH*3+80];
  snprintf(identity,sizeof(identity),"POOL_IDENTITY_V1 %llu %s",(time.QuadPart+504911232000000000ULL)/10*10,exeText);
  note(identity);
 }
 selftest=wcsstr(exe,L"pool_probe.exe")!=nullptr;
 if(RegOpenKeyExW(HKEY_CURRENT_USER,hive,0,KEY_ALL_ACCESS,&privateRoot)!=ERROR_SUCCESS)return FALSE;
 note("REGISTRY_ISOLATED");
 HMODULE pinned;GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS|GET_MODULE_HANDLE_EX_FLAG_PIN,(LPCWSTR)&Initialize,&pinned);
 Initialize();return TRUE;
}
