#pragma once
// x86 initial thread EAX is the program entry. Chain an Initialize call after
// the Windows loader resolves imports, before the original entry executes.
static bool initializeAtEntry(HANDLE process,HANDLE thread,DWORD initialize){
 CONTEXT context={};context.ContextFlags=CONTEXT_INTEGER;
 if(!GetThreadContext(thread,&context))return false;
 unsigned char code[]={0x9c,0x60,0xb8,0,0,0,0,0xff,0xd0,0x61,0x9d,0x68,0,0,0,0,0xc3};
 memcpy(code+3,&initialize,4);memcpy(code+12,&context.Eax,4);
 void* remote=VirtualAllocEx(process,nullptr,sizeof(code),MEM_RESERVE|MEM_COMMIT,PAGE_READWRITE);SIZE_T written=0;
 if(!remote || !WriteProcessMemory(process,remote,code,sizeof(code),&written) || written!=sizeof(code))return false;
 DWORD old;if(!VirtualProtectEx(process,remote,sizeof(code),PAGE_EXECUTE_READ,&old))return false;
 FlushInstructionCache(process,remote,sizeof(code));context.Eax=(DWORD)remote;
 return SetThreadContext(thread,&context)!=FALSE;
}
