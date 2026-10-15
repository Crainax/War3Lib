-- Offline boundary-control test. Encoder below is a test double, not MLS json.
local events, reports, deferred, disk = {}, {}, {}, {}
local rankRows, enforce = nil, true
json={encode=function(t)
 local function enc(v)
  if type(v)=='string' then return '"'..v..'"' end
  if type(v)=='number' then return tostring(v) end
  local parts={} for i,x in ipairs(v) do parts[i]=enc(x) end
  return '['..table.concat(parts,',')..']'
 end
 if #t==100 then rankRows=t end
 return enc(t)
end, decode=function() return rankRows end}
Log={Info=function() end}
Timer={After=function(_,f) deferred[#deferred+1]=f end}
function RegisterEvent(n,f) events[n]=f end
function MsGetEnvType() return -1 end
function MsSendMlEvent(_,tag,text) reports[#reports+1]=tag..' '..text end
function MsGASet(k,v,cb)
 deferred[#deferred+1]=function()
  if enforce and #v>4096 then cb({errnu=10,data={ok=false}})
  else disk[k]=v; cb({errnu=0,data={ok=true}}) end
 end
 return 123
end
function MsGAGet(k,cb) cb({errnu=0,data={value=disk[k]}}) end
local function run(limit)
 enforce=limit; reports={}; deferred={}; dofile('CloudScripts/MlsProbe/size_probe.lua')
 events.MlsSize(1,'MlsSize','boundary',0)
 while #deferred>0 do table.remove(deferred,1)() end
 local text=table.concat(reports,'\n')
 assert(text:find('compactBytes=4501',1,true))
 assert(text:find('4096 bytes=4096 setErr=0 setOK=true getErr=0 readBytes=4096 EXACT_ROUNDTRIP',1,true))
 if limit then assert(text:find('readBytes=4 SEED_UNCHANGED',1,true))
 else assert(text:find('readBytes=4501 EXACT_ROUNDTRIP',1,true)) end
 assert(text:find('boundary sequence complete',1,true))
end
run(true); run(false)
print('PASS: compact reference encoding=4501 bytes; boundaries report rejection or permissive local behavior without assuming either')
