local M={}
local ffi=require 'ffi'
local shadow=require 'script.experiments.innerjapi.font_style'
local core=require 'script.experiments.innerjapi.font_outline_cache_core'
local kernel=ffi.load('kernel32')
function M.init(right,left)shadow.init(right,left);core.install(kernel.GetModuleHandleA('Game.dll'))end
function M.setStyle(frame,style)
 local r=style.radius or 0;assert(type(r)=='number' and r>=0 and r<=0.003)
 local copies=style.copies or 8;assert(copies>=1 and copies<=16 and copies%1==0)
 core.remove(frame)
 -- The native shadow is direction zero. KK duplicates n extra directions at 2pi/(n+1).
 shadow.set(frame,r>0 and r or (style.x or 0),r>0 and 0 or (style.y or 0),style.color or 0xFF000000)
 if r>0 then core.set(frame,copies)end
end
function M.validate(frame)return core.validate(frame)end
function M.stats()return core.stats()end
function M.remove(frame)core.remove(frame)end
function M.testRebuild(frame)shadow.test_engine_rebuild(frame)end
function M.stop()return core.stop()end
return M
