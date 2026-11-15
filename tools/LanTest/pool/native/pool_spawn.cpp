#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <string>
#include "entry_hook.h"
int wmain(int argc,wchar_t** argv){
 if(argc<4){fwprintf(stderr,L"pool_spawn EXE CWD ARGUMENTS\n");return 2;}
 wchar_t dll[MAX_PATH];if(!GetEnvironmentVariableW(L"WAR3_POOL_DLL",dll,MAX_PATH))return 3;
 std::wstring cmd=L"\""+std::wstring(argv[1])+L"\" "+argv[3];
 STARTUPINFOW si={sizeof(si)};si.dwFlags=STARTF_USESHOWWINDOW;si.wShowWindow=SW_HIDE;PROCESS_INFORMATION pi={};
 HANDLE log=INVALID_HANDLE_VALUE;wchar_t logPath[MAX_PATH];
 if(wcsstr(argv[1],L"ydhost.exe") && GetEnvironmentVariableW(L"WAR3_POOL_HOST_LOG",logPath,MAX_PATH)){
  SECURITY_ATTRIBUTES sa={sizeof(sa),nullptr,TRUE};log=CreateFileW(logPath,GENERIC_WRITE,FILE_SHARE_READ|FILE_SHARE_WRITE,&sa,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,nullptr);
  if(log==INVALID_HANDLE_VALUE)return 6;si.dwFlags|=STARTF_USESTDHANDLES;si.hStdOutput=si.hStdError=log;si.hStdInput=nullptr;
  // Do not leak bootstrap capture pipes into the long-lived host.
  SetHandleInformation(GetStdHandle(STD_OUTPUT_HANDLE),HANDLE_FLAG_INHERIT,0);
  SetHandleInformation(GetStdHandle(STD_ERROR_HANDLE),HANDLE_FLAG_INHERIT,0);
 }
 BOOL created=CreateProcessW(argv[1],&cmd[0],nullptr,nullptr,log!=INVALID_HANDLE_VALUE,CREATE_SUSPENDED,nullptr,argv[2],&si,&pi);
 if(log!=INVALID_HANDLE_VALUE)CloseHandle(log);
 if(!created){fprintf(stderr,"CreateProcess error=%lu\n",GetLastError());return 4;}
 SIZE_T n=(wcslen(dll)+1)*2,written=0;void* remote=VirtualAllocEx(pi.hProcess,nullptr,n,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
 HANDLE thread=nullptr;
 if(remote && WriteProcessMemory(pi.hProcess,remote,dll,n,&written)&&written==n)thread=CreateRemoteThread(pi.hProcess,nullptr,0,(LPTHREAD_START_ROUTINE)LoadLibraryW,remote,0,nullptr);
 DWORD code=0;bool ok=thread && WaitForSingleObject(thread,15000)==WAIT_OBJECT_0 && GetExitCodeThread(thread,&code) && code;
 if(thread)CloseHandle(thread);
 if(ok){HMODULE local=LoadLibraryExW(dll,nullptr,DONT_RESOLVE_DLL_REFERENCES);FARPROC init=local?GetProcAddress(local,"Initialize"):nullptr;ok=init && initializeAtEntry(pi.hProcess,pi.hThread,code+(DWORD)init-(DWORD)local);if(local)FreeLibrary(local);}
 if(!ok){TerminateProcess(pi.hProcess,92);CloseHandle(pi.hThread);CloseHandle(pi.hProcess);fprintf(stderr,"Injection failed\n");return 5;}
 FILETIME createdTime,exited,kernel,user;GetProcessTimes(pi.hProcess,&createdTime,&exited,&kernel,&user);
 ULARGE_INTEGER ticks;ticks.LowPart=createdTime.dwLowDateTime;ticks.HighPart=createdTime.dwHighDateTime;
 unsigned long long utcTicks=(ticks.QuadPart+504911232000000000ULL)/10*10;
 VirtualFreeEx(pi.hProcess,remote,0,MEM_RELEASE);ResumeThread(pi.hThread);
 printf("{\"pid\":%lu,\"creationUtcTicks\":\"%llu\"}\n",pi.dwProcessId,utcTicks);fflush(stdout);CloseHandle(pi.hThread);CloseHandle(pi.hProcess);return 0;
}
