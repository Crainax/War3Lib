-- Runtime-only font extension: existing InnerJAPI ffi + Windows system APIs.
-- No additional plugin, native registration, executable stub or persistent hook.
local M = {}
local ffi = require 'ffi'
ffi.cdef[[
void* __stdcall GetModuleHandleA(const char*);
unsigned long __stdcall GetModuleFileNameA(void*,char*,unsigned long);
unsigned long __stdcall GetCurrentProcessId(void);
void* __stdcall GetCurrentProcess(void);
int __stdcall VirtualProtect(void*,unsigned long,unsigned long,unsigned long*);
int __stdcall FlushInstructionCache(void*,const void*,unsigned long);
unsigned long __stdcall GetEnvironmentVariableA(const char*,char*,unsigned long);
int __stdcall CreateDirectoryA(const char*,void*);
void* __stdcall CreateFileA(const char*,unsigned long,unsigned long,void*,unsigned long,unsigned long,void*);
int __stdcall WriteFile(void*,const void*,unsigned long,unsigned long*,void*);
int __stdcall CloseHandle(void*);
int __stdcall FlushFileBuffers(void*);
void* __stdcall OpenProcess(unsigned long,int,unsigned long);
int __stdcall DuplicateHandle(void*,void*,void*,void**,unsigned long,int,unsigned long);
long __stdcall BCryptOpenAlgorithmProvider(void**,const unsigned short*,const unsigned short*,unsigned long);
long __stdcall BCryptHash(void*,unsigned char*,unsigned long,const unsigned char*,unsigned long,unsigned char*,unsigned long);
long __stdcall BCryptCloseAlgorithmProvider(void*,unsigned long);
]]
local kernel=ffi.load('kernel32')
local crypto=ffi.load('bcrypt')
local original=string.char(0x83,0xF8,0x20,0x7E,0x07,0xB8,0x20,0,0,0,0xEB,0x1D)
local unlocked=original:sub(1,3)..string.char(0xEB)..original:sub(5)
local sites={0xDA5AD,0xE125E}
local game,limit,guard
local pid=tonumber(kernel.GetCurrentProcessId())
local function record(message)
    kernel.CreateDirectoryA('War3Lib',nil)
    local file=kernel.CreateFileA('War3Lib\\font-lua.log',4,3,nil,4,0x80,nil)
    local written=ffi.new('unsigned long[1]')
    local text=('[pid=%d] %s\r\n'):format(pid,message)
    local ok=kernel.WriteFile(file,text,#text,written,nil)
    kernel.FlushFileBuffers(file);kernel.CloseHandle(file)
    return ok~=0 and tonumber(written[0])==#text
end
M.record=record
local function same(bytes)
    for _,rva in ipairs(sites) do if ffi.string(game+rva,12)~=bytes then return false end end
    return true
end
local function change(target)
    assert(game,'Font module not initialized')
    assert(target==0 or target==32,'Unsupported limit')
    assert(same(limit==0 and unlocked or original),'Font patch ownership conflict')
    if target==limit then return end
    local protections={ffi.new('unsigned long[1]'),ffi.new('unsigned long[1]')}
    assert(kernel.VirtualProtect(game+sites[1],12,0x40,protections[1])~=0,'Protect first clamp failed')
    if kernel.VirtualProtect(game+sites[2],12,0x40,protections[2])==0 then
        local ignored=ffi.new('unsigned long[1]')
        kernel.VirtualProtect(game+sites[1],12,protections[1][0],ignored)
        error('Protect second clamp failed')
    end
    -- Each x86 byte store changes only the conditional branch opcode.
    for _,rva in ipairs(sites) do game[rva+3]=target==0 and 0xEB or 0x7E end
    limit=target
    local success=true
    for i,rva in ipairs(sites) do
        local ignored=ffi.new('unsigned long[1]')
        success=(kernel.VirtualProtect(game+rva,12,protections[i][0],ignored)~=0) and success
        success=(kernel.FlushInstructionCache(kernel.GetCurrentProcess(),game+rva,12)~=0) and success
    end
    assert(success and same(target==0 and unlocked or original),'Font patch verification failed')
end
local function fingerprint(module)
    local path=ffi.new('char[260]')
    assert(kernel.GetModuleFileNameA(module,path,260)>0)
    local file=assert(io.open(ffi.string(path),'rb'))
    local bytes=file:read('a');file:close()
    local algorithm=ffi.new('void*[1]')
    local name=ffi.new('unsigned short[7]',{83,72,65,50,53,54,0})
    assert(crypto.BCryptOpenAlgorithmProvider(algorithm,name,nil,0)>=0,'SHA256 provider unavailable')
    local digest=ffi.new('unsigned char[32]')
    local status=crypto.BCryptHash(algorithm[0],nil,0,bytes,#bytes,digest,32)
    crypto.BCryptCloseAlgorithmProvider(algorithm[0],0)
    assert(status>=0,'Game hash failed')
    local hash=(ffi.string(digest,32):gsub('.',function(c)return ('%02x'):format(c:byte())end))
    assert(hash=='e04d1716603c075eb0c8e1e21cf1093a664adc5249efab396bfa08d7b09d0c3a','Unsupported Game.dll '..hash)
end
function M.init()
    if game then return end
    assert(package.lua_engine=='innerjapi' and ffi.sizeof('void*')==4,'Requires x86 InnerJAPI')
    assert(kernel.GetModuleHandleA('inner_font_size.dll')==ffi.NULL,'Custom font DLL must not be loaded')
    local module=kernel.GetModuleHandleA('Game.dll')
    assert(module~=ffi.NULL,'Game.dll unavailable');fingerprint(module)
    local candidate=ffi.cast('unsigned char*',module)
    for _,rva in ipairs(sites) do assert(ffi.string(candidate+rva,12)==original,'Original clamp blocks do not match') end
    assert(ffi.string(candidate+0x9CE60,6)==string.char(0x55,0x8b,0xec,0x56,0x8b,0xf1),'Font entry does not match')
    game=candidate
    limit=32
    -- Keep this finalizable table in the cached module for the whole Lua VM lifetime.
    -- Hot reload calls restore(), but does not release the VM-exit guard.
    guard=setmetatable({}, {__gc=function()
        local before=limit
        local ok,err=pcall(change,32)
        if ok and same(original) then
            record(('[INNER_FONT_LUA_RESTORED] Lua VM finalizer restored both blocks; previous=%d'):format(before))
        else record('FAIL: Lua VM font restore '..tostring(err)) end
    end})
    M._exit_guard=guard
    assert(record('PASS: pinned Game.dll; original bytes; pure Lua exit guard installed'))
    record(('game_base=%d ydbase=%s kkapi=%s'):format(tonumber(ffi.cast('uintptr_t',game)),tostring(kernel.GetModuleHandleA('ydbase.dll')~=ffi.NULL),tostring(kernel.GetModuleHandleA('kkapi_local_plugin.dll')~=ffi.NULL)))
    -- Optional regression observer: give the named harness a READ-ONLY handle.
    -- Normal map launches have no observer; no external process is started here.
    local observer=ffi.new('char[16]')
    if kernel.GetEnvironmentVariableA('WAR3_INNER_FONT_VERIFY_PID',observer,16)>0 then
        local target=kernel.OpenProcess(0x40,0,assert(tonumber(ffi.string(observer))))
        assert(target~=ffi.NULL,'Observer unavailable')
        local remote=ffi.new('void*[1]')
        local success=kernel.DuplicateHandle(kernel.GetCurrentProcess(),kernel.GetCurrentProcess(),target,remote,0x410,0,0)
        kernel.CloseHandle(target)
        assert(success~=0,'Read-only observer handle unavailable')
        record(('verify_handle=%d'):format(tonumber(ffi.cast('uintptr_t',remote[0]))))
    end
end
function M.enable() change(0) end
function M.restore() if game then change(32) end end
function M.set(frame,path,size)
    assert(game and frame~=0 and type(path)=='string' and size>0 and size<math.huge)
    -- Game expects ECX=frame and THREE stack arguments. EDX is unused.
    -- This luaffi build dereferences pointer cdata when casting to a function.
    -- Scalar uintptr_t cdata holds the function address without dereferencing code bytes.
    local address=ffi.cast('uintptr_t',game+0x9CE60)
    local setter=ffi.cast('void (__fastcall *)(void*,void*,const char*,float,unsigned int)',address)
    setter(ffi.cast('void*',frame),nil,path,size,0)
end
local function u32(address) return tonumber(ffi.cast('unsigned int*',address)[0]) end
function M.measure(frame)
    local address=ffi.cast('unsigned char*',frame)
    local ref=u32(address+0x30);assert(ref~=0)
    local font=u32(ffi.cast('unsigned char*',ref)+0x20);assert(font~=0)
    local ppem=u32(ffi.cast('unsigned char*',font)+0xA4)
    local layout=address+0xB4
    local vtable=ffi.cast('unsigned char*',u32(layout))
    local width=ffi.cast('float (__fastcall *)(void*,void*)',ffi.cast('uintptr_t',u32(vtable+0x18)))(layout,nil)
    local height=ffi.cast('float (__fastcall *)(void*,void*)',ffi.cast('uintptr_t',u32(vtable+0x1C)))(layout,nil)
    return ppem,tonumber(width),tonumber(height)
end
function M.arm_exit()
    assert(limit==0 and same(unlocked),'Exit verification must begin while unlocked')
    record('PASS: exit armed while both clamps remain unlocked')
end
function M.exit_test()
    local value=ffi.new('char[8]')
    local n=kernel.GetEnvironmentVariableA('WAR3_INNER_FONT_LUA_TEST',value,8)
    return n==1 and tonumber(ffi.string(value)) or 0
end
return M
