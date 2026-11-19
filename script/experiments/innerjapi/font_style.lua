-- Exact-build CTextFrame shadow/outline experiment. No code patch or extra TEXT.
local M={}
local ffi=require 'ffi'
local font=require 'script.experiments.innerjapi.font_size'
local kernel=ffi.load('kernel32') -- declarations and SHA256 gate come from font_size
local game,enable,ready
local function ptr(n) return ffi.cast('unsigned char*',n) end
local function u32(n) return tonumber(ffi.cast('unsigned int*',n)[0]) end
local function real(n) return tonumber(ffi.cast('float*',n)[0]) end
local function frame(f)
    assert(game and type(f)=='number' and f>0,'Invalid frame')
    local p=ptr(f)
    assert(u32(p)==tonumber(ffi.cast('uintptr_t',game+0x95B050)),'Not the pinned CTextFrame vtable')
    return p
end
function M.read(f)
    local p=frame(f)
    return u32(p+0x200),real(p+0x210),real(p+0x214)
end
function M.init(referenceRight,referenceLeft)
    font.init() -- validates Game SHA256; never enables the size patch
    game=ffi.cast('unsigned char*',kernel.GetModuleHandleA('Game.dll'))
    assert(ffi.string(game+0xA93E0,6)==string.char(0x55,0x8b,0xec,0x56,0x8b,0xf1),'Flag function mismatch')
    assert(ffi.string(game+0x17F660,6)==string.char(0x55,0x8b,0xec,0x8b,0x49,0x08),'Shadow function mismatch')
    for _,rva in ipairs({0xE0490,0xE0380,0xE05D0,0xD9180,0xD7E30}) do
        assert(ffi.string(game+rva,3)==string.char(0x55,0x8b,0xec),'Geometry function mismatch')
    end
    local c,x,y=M.read(referenceRight)
    assert(c==0xFF000000 and math.abs(x-0.001)<1e-7 and math.abs(y+0.001)<1e-7,'Right FDF schema mismatch; refusing writes')
    c,x,y=M.read(referenceLeft)
    assert(c==0xFF000000 and math.abs(x+0.001)<1e-7 and math.abs(y+0.001)<1e-7,'Left FDF schema mismatch; refusing writes')
    enable=ffi.cast('void (__fastcall *)(void*,void*,unsigned int)',ffi.cast('uintptr_t',game+0xA93E0))
    ready=true
end
function M.set(f,x,y,color)
    assert(ready and math.abs(x)<=0.01 and math.abs(y)<=0.01,'Probe not ready or offset outside test bounds')
    local p=frame(f)
    ffi.cast('unsigned int*',p+0x200)[0]=color
    ffi.cast('float*',p+0x210)[0]=x
    ffi.cast('float*',p+0x214)[0]=y
    enable(ffi.cast('void*',p),nil,4) -- engine flags and dirty state, not a fabricated redraw
end
function M.render_state(f)
    local p=frame(f)
    local handle=u32(p+0x204)
    assert(handle~=0,'CTextFrame render handle not generated')
    local object=u32(ptr(handle)+8)
    assert(object~=0,'Native rendered string absent')
    local q=ptr(object)
    return u32(q+0x30),real(q+0x34),real(q+0x38)
end
-- Test-only trigger of the engine glyph rebuild; production restoration is native.
function M.test_engine_rebuild(f)
    local h=u32(frame(f)+0x204);assert(h~=0,'Missing render handle')
    local o=u32(ptr(h)+8);assert(o~=0,'Missing rendered string')
    ffi.cast('void (__fastcall *)(void*,void*)',ffi.cast('uintptr_t',game+0xD7E30))(ptr(o),nil)
end
return M
