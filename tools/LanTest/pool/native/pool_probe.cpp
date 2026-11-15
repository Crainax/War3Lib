#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
static bool samePath(const wchar_t* a,const wchar_t* b){std::wstring x=a,y=b;while(!x.empty()&&(x.back()==L'\\'||x.back()==L'/'))x.pop_back();while(!y.empty()&&(y.back()==L'\\'||y.back()==L'/'))y.pop_back();return !_wcsicmp(x.c_str(),y.c_str());}
#pragma comment(lib,"ws2_32.lib")
#pragma comment(lib,"advapi32.lib")
int wmain(){
 wchar_t expected[MAX_PATH],output[MAX_PATH],udp[16];
 GetEnvironmentVariableW(L"WAR3_POOL_GAME",expected,MAX_PATH);GetEnvironmentVariableW(L"WAR3_POOL_PROBE_OUTPUT",output,MAX_PATH);GetEnvironmentVariableW(L"WAR3_POOL_UDP",udp,16);
 HKEY key;wchar_t actual[MAX_PATH]={0};DWORD n=sizeof(actual);
 bool registry=RegOpenKeyExW(HKEY_CURRENT_USER,L"Software\\Blizzard Entertainment\\Warcraft III",0,KEY_READ|KEY_WRITE,&key)==ERROR_SUCCESS;
 if(registry){registry=RegQueryValueExW(key,L"InstallPath",nullptr,nullptr,(BYTE*)actual,&n)==ERROR_SUCCESS && samePath(actual,expected);RegSetValueExW(key,L"PoolIsolationProbe",0,REG_SZ,(BYTE*)expected,(DWORD)((wcslen(expected)+1)*2));RegCloseKey(key);}
 bool machine=false;
 if(RegOpenKeyExW(HKEY_LOCAL_MACHINE,L"Software\\Blizzard Entertainment\\Warcraft III",0,KEY_READ|KEY_WRITE,&key)==ERROR_SUCCESS){n=sizeof(actual);machine=RegQueryValueExW(key,L"InstallPath",nullptr,nullptr,(BYTE*)actual,&n)==ERROR_SUCCESS && samePath(actual,expected);RegCloseKey(key);}
 WSADATA w;WSAStartup(MAKEWORD(2,2),&w);SOCKET s=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);sockaddr_in a={};a.sin_family=AF_INET;a.sin_port=htons(6112);
 bool bound=bind(s,(sockaddr*)&a,sizeof(a))==0;int size=sizeof(a);getsockname(s,(sockaddr*)&a,&size);bool port=bound && ntohs(a.sin_port)==_wtoi(udp);
 DWORD timeout=1000;setsockopt(s,SOL_SOCKET,SO_RCVTIMEO,(char*)&timeout,sizeof(timeout));
 SOCKET sender=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);sockaddr_in dest=a;dest.sin_addr.s_addr=htonl(INADDR_LOOPBACK);
 char packet[128]={},buffer[256],room[100]={};GetEnvironmentVariableA("WAR3_POOL_ROOM",room,sizeof(room));packet[0]=(char)0xf7;packet[1]=0x30;
 strcpy_s(packet+20,sizeof(packet)-20,"wrong-room");sendto(sender,packet,40,0,(sockaddr*)&dest,sizeof(dest));bool rejected=recvfrom(s,buffer,sizeof(buffer),0,nullptr,nullptr)==SOCKET_ERROR && WSAGetLastError()==WSAEWOULDBLOCK;
 strcpy_s(packet+20,sizeof(packet)-20,room);sendto(sender,packet,120,0,(sockaddr*)&dest,sizeof(dest));bool accepted=recvfrom(s,buffer,sizeof(buffer),0,nullptr,nullptr)==120;
 closesocket(sender);closesocket(s);WSACleanup();
 FILE* f=nullptr;if(!_wfopen_s(&f,output,L"w") && f){fprintf(f,"{\"registry\":%s,\"machineGameKey\":%s,\"port\":%s,\"actualPort\":%u,\"foreignRoomRejected\":%s,\"targetRoomAccepted\":%s}",registry?"true":"false",machine?"true":"false",port?"true":"false",ntohs(a.sin_port),rejected?"true":"false",accepted?"true":"false");fclose(f);}
 return registry&&machine&&port&&rejected&&accepted?0:1;
}
