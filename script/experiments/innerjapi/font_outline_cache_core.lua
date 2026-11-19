-- Exact-build PIC shadow cache. All engine callbacks target native code, never Lua.
local M={}
local ffi=require 'ffi'
require 'script.experiments.innerjapi.font_size'
local payload=require 'script.experiments.innerjapi.font_outline_cache_bytes'
ffi.cdef[[
void* __stdcall VirtualAlloc(void*,unsigned long,unsigned long,unsigned long);
int __stdcall VirtualFree(void*,unsigned long,unsigned long);
void* __stdcall GetProcessHeap(void);
void* __stdcall HeapAlloc(void*,unsigned long,unsigned long);
void* __stdcall HeapReAlloc(void*,unsigned long,void*,unsigned long);
int __stdcall HeapFree(void*,unsigned long,void*);
void* __stdcall GetProcAddress(void*,const char*);
typedef struct {void* frame;void* object;void* cache;unsigned int capacity,copies,next,updating,ready,epoch;float directions[32];} OutlineCacheSlot;
typedef struct {
 void* game;void* rebuild;void* frameRebuild;void* shadowRebuild;void* destroy;void* rawDestroy;void* requestDestroy;
 void* heap;void* alloc;void* realloc;void* free;
 unsigned int draws,extraDraws,builds,rebuilds,frameRebuilds,shadowUpdates,destroys,rawDestroys;
 unsigned int allocations,reallocations,releases,liveBlocks,liveBytes,peakBytes,errors,lookups,probes;
 unsigned int destroyRequests,nativeDestructors,lastRequestedFrame,lastDestroyedFrame;
 unsigned int submissions;
 unsigned int heads[128];OutlineCacheSlot slots[64];
} OutlineCacheContext;
]]
local k=ffi.load('kernel32')
local context,code,bridge,game,guard
local patches,exports={},{}
local function addr(p)return tonumber(ffi.cast('uintptr_t',p))end
local function ptr(p)return ffi.cast('unsigned char*',p)end
local function word(n)return string.pack('<I4',n%4294967296)end
local function jump(p,op,target,n)return string.char(op)..word(addr(target)-addr(p)-5)..string.rep('\x90',n-5)end
local function write(p,b)
 local old=ffi.new('unsigned long[1]');assert(k.VirtualProtect(p,#b,0x40,old)~=0)
 ffi.copy(p,b,#b);local ignored=ffi.new('unsigned long[1]');assert(k.VirtualProtect(p,#b,old[0],ignored)~=0)
 assert(k.FlushInstructionCache(k.GetCurrentProcess(),p,#b)~=0)
end
local function bind(n,s)return ffi.cast(s,ffi.cast('uintptr_t',code+assert(payload.offsets[n])))end
local function stub(p,n)
 local b='\xba'..word(addr(context))..'\xb8'..word(addr(code+payload.offsets[n]))..'\xff\xe0'
 ffi.copy(p,b,#b);return p
end
function M.install(base)
 assert(not game,'Cache core already installed')
 local g=ptr(base)
 local specs={
  {0xD7E30,'\x55\x8b\xec\x83\xec\x38','rebuild','outline_rebuilt'},
  {0xAA2D0,'\x53\x8b\xdc\x83\xec\x08','frameRebuild','outline_frame_rebuilt'},
  {0xD6650,'\x55\x8b\xec\x83\xec\x24','shadowRebuild','outline_shadow_rebuilt'},
  {0xA92B0,'\x55\x8b\xec\x6a\xff','destroy','outline_destroy'},
  {0xD5910,'\x56\x57\x8b\xf1\xe8\xc7\x1c\x00\x00','rawDestroy','outline_raw_destroy'},
  {0x98F50,'\x55\x8b\xec\x56\x57','requestDestroy','outline_request_destroy'}
 }
 for _,s in ipairs(specs)do assert(ffi.string(g+s[1],#s[2])==s[2],'Unknown native signature '..s[3])end
 assert(ffi.string(g+0xDC510,5)=='\xe8\x5b\x71\x00\x00','Shadow submission call mismatch')
 context=ffi.new('OutlineCacheContext[1]')
 local ok,e=xpcall(function()
  code=ptr(k.VirtualAlloc(nil,#payload.bytes,0x3000,0x04));assert(addr(code)~=0)
  bridge=ptr(k.VirtualAlloc(nil,4096,0x3000,0x04));assert(addr(bridge)~=0)
  ffi.copy(code,payload.bytes,#payload.bytes)
  local old=ffi.new('unsigned long[1]');assert(k.VirtualProtect(code,#payload.bytes,0x20,old)~=0)
  assert(k.FlushInstructionCache(k.GetCurrentProcess(),code,#payload.bytes)~=0)
  context[0].game=g;context[0].heap=k.GetProcessHeap()
  local module=k.GetModuleHandleA('kernel32.dll')
  context[0].alloc=k.GetProcAddress(module,'HeapAlloc');context[0].realloc=k.GetProcAddress(module,'HeapReAlloc');context[0].free=k.GetProcAddress(module,'HeapFree')
  assert(addr(context[0].alloc)~=0 and addr(context[0].realloc)~=0 and addr(context[0].free)~=0,'Heap exports missing')
  assert(tonumber(bind('outline_context_size','unsigned int (__cdecl *)(void)')())==ffi.sizeof('OutlineCacheContext'),'Cache ABI mismatch')
 end,debug.traceback)
 if not ok then
  if bridge and addr(bridge)~=0 then k.VirtualFree(bridge,0,0x8000)end
  if code and addr(code)~=0 then k.VirtualFree(code,0,0x8000)end
  context=nil;code=nil;bridge=nil;error(e)
 end
 for i,s in ipairs(specs)do
  local tr=bridge+(i-1)*64;local entry=g+s[1];ffi.copy(tr,s[2],#s[2])
  if s[3]=='rawDestroy' then ffi.copy(tr+4,jump(tr+4,0xE8,g+0xD75E0,5),5)end
  ffi.copy(tr+#s[2],jump(tr+#s[2],0xE9,entry+#s[2],5),5);context[0][s[3]]=tr
  local hook=stub(bridge+384+(i-1)*32,s[4])
  patches[#patches+1]={p=entry,original=s[2],patched=jump(entry,0xE9,hook,#s[2])}
 end
 -- KK's equivalent location is between original shadow and foreground submission.
 -- Preserve registers/flags; pass frame-local group/batch/color directly to C.
 local body='\x60\x8d\x45\xec\x50\x56\x53\xff\x75\xf0\x57\x68'..word(addr(context))
  ..'\xb8'..word(addr(code+payload.offsets.outline_draw_extra))..'\xff\xd0\x83\xc4\x18\x61'
 local draw='\xb8'..word(addr(g+0xE3670))..'\xff\xd0\x9c\xf7\x47\x70\x00\x00\x00\x80\x74'..string.char(#body)..body..'\x9d\xc3'
 ffi.copy(bridge+768,draw,#draw)
 patches[#patches+1]={p=g+0xDC510,original=ffi.string(g+0xDC510,5),patched=jump(g+0xDC510,0xE8,bridge+768,5)}
 local old=ffi.new('unsigned long[1]')
 assert(k.VirtualProtect(bridge,4096,0x20,old)~=0)
 assert(k.FlushInstructionCache(k.GetCurrentProcess(),bridge,4096)~=0)
 exports.set=bind('outline_set','int (__cdecl *)(void*,void*,unsigned int,float*)')
 exports.remove=bind('outline_remove','void (__cdecl *)(void*,void*)')
 exports.validate=bind('outline_validate','int (__cdecl *)(void*,void*)')
 local installed,err=pcall(function()for _,s in ipairs(patches)do write(s.p,s.patched)end end)
 if not installed then for _,s in ipairs(patches)do pcall(write,s.p,s.original)end;error(err)end
 game=g;guard=ffi.gc(ffi.new('unsigned char[1]'),function()pcall(M.stop)end)
end
function M.set(frame,copies)
 copies=copies or 8;assert(game and copies>=1 and copies<=16 and copies%1==0)
 local angles=ffi.new('float[32]')
 for i=1,copies do local a=i*2*math.pi/(copies+1);angles[(i-1)*2]=math.cos(a);angles[(i-1)*2+1]=math.sin(a)end
 assert(exports.set(context,ptr(frame),copies,angles)==1,'Cache registration failed')
end
function M.remove(frame)if game then exports.remove(context,ptr(frame))end end
function M.validate(frame)return game and exports.validate(context,ptr(frame))==1 end
-- Read-only diagnostics, never used by the restoration/render path.
function M.inspect(frame)
 assert(game)
 for i=0,63 do local s=context[0].slots[i];if addr(s.frame)==frame then return {object=addr(s.object),cache=addr(s.cache),capacity=tonumber(s.capacity),copies=tonumber(s.copies),ready=tonumber(s.ready)}end end
end
function M.stats()
 assert(game);local c=context[0];local s={active=0,luaCallbacks=0}
 for _,n in ipairs({'draws','extraDraws','submissions','builds','rebuilds','frameRebuilds','shadowUpdates','destroys','rawDestroys','allocations','reallocations','releases','liveBlocks','liveBytes','peakBytes','errors','lookups','probes','destroyRequests','nativeDestructors','lastRequestedFrame','lastDestroyedFrame'})do s[n]=tonumber(c[n])end
 for i=0,63 do if addr(c.slots[i].frame)~=0 then s.active=s.active+1 end end
 s.renders=s.draws;s.applies=s.builds;return s
end
function M.stop()
 if not game then return end
 for _,s in ipairs(patches)do assert(ffi.string(s.p,#s.patched)==s.patched,'Cache patch ownership mismatch')end
 for i=0,63 do local f=addr(context[0].slots[i].frame);if f~=0 then M.remove(f)end end
 assert(context[0].liveBytes==0 and context[0].liveBlocks==0,'Cache memory not released')
 for _,s in ipairs(patches)do write(s.p,s.original)end
 if guard then ffi.gc(guard,nil);guard=nil end
 local last=M.stats();game=nil;exports={};patches={}
 assert(k.VirtualFree(bridge,0,0x8000)~=0);assert(k.VirtualFree(code,0,0x8000)~=0)
 context=nil;code=nil;bridge=nil;return last
end
return M
