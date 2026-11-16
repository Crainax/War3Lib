-- Independent candidate. Only finite test sequencing uses timers; restoration is native.
local M={}
local jass=require 'jass.common'
local japi=require 'jass.japi'
local ffi=require 'ffi'
local native=require 'script.experiments.innerjapi.font_outline'
local cache=require 'script.experiments.innerjapi.font_outline_cache_core'
local font=require 'script.experiments.innerjapi.font_size'
local frames,targets,timers,lines={},{},{},{}
local serial,line=0,0
local sample='|cffff2020夕月心音|r的小小龙虾 Ag8000'
local right,left,thick,probe,steady
local kernel=ffi.load('kernel32')
local game=ffi.cast('unsigned char*',kernel.GetModuleHandleA('Game.dll'))
local auditTrigger
local temporary={}
local logName='War3Lib\\logs\\InnerOutlineCache-'..tonumber(kernel.GetCurrentProcessId())..'-P'..(jass.GetPlayerId(jass.GetLocalPlayer())+1)..'.log'
local function flush(done)
 jass.PreloadGenClear();jass.PreloadGenStart()
 for _,s in ipairs(lines)do jass.Preload(s)end
 if done then jass.Preload('[INNER_OUTLINE_CACHE_DONE] separate cache, draw and lifecycle verified; visual pending')end
 jass.PreloadGenEnd(logName)
end
local function log(s)lines[#lines+1]=s;print('[OutlineCache] '..s)end
local function check(ok,s)assert(ok,s);log('PASS: '..s)end
local function statsLine(label)
 local s=native.stats()
 log(string.format('%s render=%d extra=%d submissions=%d rebuild=%d frame=%d shadow=%d build=%d error=%d active=%d blocks=%d bytes=%d alloc=%d realloc=%d free=%d rawFree=%d',label,s.renders,s.extraDraws,s.submissions,s.rebuilds,s.frameRebuilds,s.shadowUpdates,s.applies,s.errors,s.active,s.liveBlocks,s.liveBytes,s.allocations,s.reallocations,s.releases,s.rawDestroys))
 return s
end
local function checkIdle(before,label)
 local s=statsLine(label)
 local events=(s.rebuilds-before.rebuilds)+(s.frameRebuilds-before.frameRebuilds)+(s.shadowUpdates-before.shadowUpdates)
 check(s.renders>before.renders,label..' rendered frames advanced')
 -- Input/hover can legitimately rebuild text even if our test did not change it.
 check(s.applies-before.applies<=events,label..' no expansion without native invalidation')
 if events==0 then check(s.applies==before.applies,label..' unchanged geometry not regenerated')end
 if events==0 then check(s.allocations==before.allocations and s.reallocations==before.reallocations,label..' zero cache allocation while drawing')end
end
local function nativeUpdate(f,frameLevel)
 local p=ffi.cast('unsigned char*',f)
 if not frameLevel then
  local h=tonumber(ffi.cast('unsigned int*',p+0x204)[0]);assert(h~=0)
  p=ffi.cast('unsigned char*',tonumber(ffi.cast('unsigned int*',ffi.cast('unsigned char*',h)+8)[0]))
 end
 ffi.cast('void (__fastcall *)(void*,void*)',ffi.cast('uintptr_t',game+(frameLevel and 0xAA2D0 or 0xD6650)))(p,nil)
end
local function allValid()
 for _,t in ipairs(targets)do check(native.validate(t[1]),'separate shadow cache and original buffers valid '..t[1])end
 check(native.stats().errors==0,'native error count zero')
 check(native.stats().liveBlocks==#targets,'one separate live cache per outlined TEXT')
end
local function row(template,label)
 local f=japi.CreateFrameByTagName('TEXT','OutlineCache_'..serial,japi.GetGameUI(),template,serial)
 assert(f and f~=0);frames[#frames+1]=f
 japi.FrameSetText(f,label..'  '..sample);japi.FrameSetAbsolutePoint(f,3,0.025,0.56-line*0.022);japi.FrameShow(f,true)
 serial=serial+1;line=line+1;return f
end
local function build()
 japi.LoadToc('ui\\UITextFontInnerStyle.toc')
 right=row('InnerStyleRight','reference');left=row('InnerStyleLeft','reference');native.init(right,left)
 japi.FrameShow(right,false);japi.FrameShow(left,false);line=0
 for i,name in ipairs({'原字体'})do
  for _,r in ipairs({0,0.0005,0.001})do
   local f=row('InnerStyleFont'..(i-1),string.format('%d %s r=%.4f',i-1,name,r))
   if r>0 then native.setStyle(f,{radius=r});targets[#targets+1]={f,r}end
  end
 end
 thick=row('InnerStyleFont0','1 原生恢复 r=0.0020');native.setStyle(thick,{radius=0.002});targets[#targets+1]={thick,0.002}
 check(native.stats().active==#targets,'one registered TEXT per outlined row; no overlay TEXT')
end
local phases={
 {1.5,build},
 {3,function()allValid();collectgarbage('collect');collectgarbage('collect');check(native.stats().luaCallbacks==0,'native-to-Lua callbacks absent');steady=native.stats()end},
 {3,function()
  allValid();checkIdle(steady,'initial idle')
  native.testRebuild(thick);japi.FrameSetText(thick,'1 改文字后 r=0.0020  '..sample)
 end},
 {1,function()
  allValid();check(native.stats().rebuilds>steady.rebuilds,'native rebuild notification observed')
  font.set(thick,'Fonts\\dfst-m3u.ttf',0.014)
  japi.FrameSetAbsolutePoint(thick,3,0.035,0.56-3*0.022)
 end},
 {1,function()
  allValid();native.setStyle(thick,{radius=0.0005})
 end},
 {1,function()
  check(native.validate(thick),'radius change on same TEXT')
  native.setStyle(thick,{radius=0.0005,copies=3});check(cache.inspect(thick).copies==3 and native.validate(thick),'three extra directions generated immediately')
  native.setStyle(thick,{radius=0.0005,copies=16});check(cache.inspect(thick).copies==16 and native.validate(thick),'sixteen extra directions generated immediately')
  native.setStyle(thick,{radius=0,x=0.001,y=-0.001})
  check(native.stats().active==#targets-1,'switch from outline to native directional shadow')
 end},
 {1,function()
  local shadow=require 'script.experiments.innerjapi.font_style'
  local c,x,y=shadow.render_state(thick)
  check(c==0xFF000000 and math.abs(x-0.001)<0.0000001 and math.abs(y+0.001)<0.0000001,'native directional shadow readback')
  native.setStyle(thick,{radius=0.002})
  probe=row('InnerStyleFont0','destructor probe');native.setStyle(probe,{radius=0.001})
 end},
 {1,function()
  check(native.validate(probe),'temporary TEXT has outline')
  steady=native.stats();japi.DestroyFrame(probe);frames[#frames]=nil
  log(string.format('DESTROY before=%d/%d after=%d/%d',steady.destroys,steady.active,native.stats().destroys,native.stats().active))

  collectgarbage('collect')
 end},
 {2,function()
  log(string.format('DESTROY delayed=%d/%d',native.stats().destroys,native.stats().active))
  check(native.stats().destroys==steady.destroys+1 and native.stats().active==#targets,'DestroyFrame automatically unregisters after engine update')
  allValid();local stopped=native.stop();check(stopped.liveBlocks==0 and stopped.liveBytes==0,'all independent cache memory freed before uninstall')
  native.init(right,left)
  for _,t in ipairs(targets)do native.setStyle(t[1],{radius=t[2]})end
 end},
 {2,function()
  allValid();steady=native.stats()
  for _,t in ipairs(targets)do nativeUpdate(t[1],true)end
 end},
 {1,function()
  allValid();check(native.stats().frameRebuilds>=steady.frameRebuilds+#targets,'TEXT-level recreation observed for every outline')
  steady=native.stats();for _,t in ipairs(targets)do nativeUpdate(t[1],false)end
  check(native.stats().shadowUpdates==steady.shadowUpdates+#targets,'shadow-only invalidation observed without glyph rebuild')
  check(native.stats().rebuilds==steady.rebuilds,'shadow-only path bypasses glyph rebuild hook')
  allValid();check(native.stats().applies==steady.applies+#targets,'shadow caches rebuilt in native update, before next draw')
 end},
 {1,function()
  allValid();check(native.stats().applies>=steady.applies+#targets,'shadow-only coordinates restored on next draw')
  for i=1,12 do
   local f=row('InnerStyleFont0','lifecycle stress '..i)
   native.setStyle(f,{radius=0.0005,copies=i%2==0 and 3 or 16});temporary[#temporary+1]=f
  end
 end},
 {1,function()
  check(native.stats().active==#targets+12 and native.stats().liveBlocks==#targets+12,'base and twelve temporary TEXT caches')
  for _,f in ipairs(temporary)do check(native.validate(f),'temporary cache valid');japi.DestroyFrame(f);frames[#frames]=nil end
  temporary={}
 end},
 {2,function()
  allValid();check(native.stats().active==#targets and native.stats().liveBlocks==#targets,'all stress TEXT caches automatically released')
  steady=native.stats();collectgarbage('collect')
 end},
 {60,function()
  allValid();checkIdle(steady,'sixty-second stability');statsLine('STATS')
  local s=native.stats()
  check(s.extraDraws-steady.extraDraws==(s.renders-steady.renders)*8,'exactly eight logical shadow copies per native batch during stable interval')
  check(s.submissions-steady.submissions==s.renders-steady.renders,'one packed submission per native batch during stable interval')
 end}
}
local function run(index)
 if index>#phases then flush(true);return end
 local phase=phases[index];local t=jass.CreateTimer();timers[#timers+1]=t
 jass.TimerStart(t,phase[1],false,function()
  local ok,err=xpcall(function()log('PHASE '..index);phase[2]();flush(false)end,debug.traceback)
  if not ok then log('FAIL: '..tostring(err));flush(false);return end
  run(index+1)
 end)
end
function M.start()
 auditTrigger=jass.CreateTrigger()
 jass.TriggerRegisterPlayerChatEvent(auditTrigger,jass.GetLocalPlayer(),'-outline-check',true)
 jass.TriggerAddAction(auditTrigger,function()
  local ok,e=xpcall(function()statsLine('MANUAL AUDIT');allValid();log('PASS: manual post-interaction geometry audit')end,debug.traceback)
  if not ok then log('FAIL: manual audit '..tostring(e))end
  flush(false)
 end)
 run(1)
end
function M.stop()
 if auditTrigger then jass.DestroyTrigger(auditTrigger);auditTrigger=nil end
 for _,t in ipairs(timers)do jass.PauseTimer(t);jass.DestroyTimer(t)end;timers={}
 for i=#frames,1,-1 do japi.DestroyFrame(frames[i])end
 frames={};native.stop()
end
return M
