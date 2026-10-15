-- Offline API contract mocks, not plugin/disk persistence proof.
package.path = 'CloudScripts/MlsProbe/?.lua;' .. package.path
local events, sent, disk, ga, queue = {}, {}, {}, {}, {}
local blobs, serial, saves, saveCode, env, gaError = {}, 0, 0, 0, -1, 0
local nullSentinel = {}
local missingValue = nullSentinel
local function copy(t) local r={} for k,v in pairs(t) do r[k]=v end return r end
Log={Info=function() end, Error=function() end}
json={encode=function(t) serial=serial+1; local s='blob'..serial; blobs[s]=copy(t); return s end,
 decode=function(s) if s=='null' then return nullSentinel end; assert(blobs[s],'corrupt'); return copy(blobs[s]) end}
function RegisterEvent(n,f) events[n]=f end
function MsGetEnvType() return env end
function MsGetScriptArchive(p) return disk[p] end
function MsSaveScriptArchive(p,s,n) assert(#s==n); saves=saves+1; if saveCode==0 then disk[p]=s end; return saveCode end
function MsSendMlEvent(p,t,d) sent[t]=d; return 0 end
local function enqueue(op, data, cb)
 queue[#queue+1]=function() cb({op=op,errnu=gaError,data=data}) end
end
function MsGAGet(k,cb) enqueue('MsGAGet',{value=ga[k] or missingValue},cb) end
function MsGASet(k,v,cb) ga[k]=v; enqueue('MsGASet',{ok=true},cb) end
function MsGAIncrby(k,d,cb) ga[k]=tostring((tonumber(ga[k]) or 0)+d); enqueue('MsGAIncrby',{value=tonumber(ga[k])},cb) end
local function drain() while #queue>0 do table.remove(queue,1)() end end
local function boot() events={}; package.loaded.ga_probe=nil; dofile('CloudScripts/MlsProbe/main.lua') end
local function fire(n,v) sent={}; events[n](1,n,v or '',0); drain(); return sent end
disk[0]=json.encode({war3lib_mls_probe_count=7,other='keep'})
boot()
assert(fire('MlsProbePing','hello').MlsProbePong=='hello')
assert(fire('MlsProbeRead').MlsProbeScore=='0' and saves==0)
assert(fire('MlsProbeWrite','1').MlsProbeWriteResult=='8')
local saved=json.decode(disk[0]); assert(saved.war3lib_mls_probe_score==10 and saved.other=='keep')
assert(fire('MlsProbeWrite','1').MlsProbeWriteResult=='8' and saves==1)
saveCode=1; assert(fire('MlsProbeWrite','2').MlsProbeError)
assert(fire('MlsProbeRead').MlsProbeScore=='10')
saveCode=0; boot(); assert(fire('MlsProbeRead').MlsProbeReadResult=='8')
assert(fire('MlsProbeGA','get').MlsProbeGAResult=='<missing>')
missingValue=nil
assert(fire('MlsProbeGA','get').MlsProbeGAResult=='<missing>')
missingValue=nullSentinel
assert(fire('MlsProbeGA','incr').MlsProbeGAResult=='7')
assert(fire('MlsProbeGA','set').MlsProbeGAResult=='73100')
assert(fire('MlsProbeGA','incr').MlsProbeGAResult=='73107')
boot(); assert(fire('MlsProbeGA','get').MlsProbeGAResult=='73107')
gaError=5; assert(fire('MlsProbeGA','get').MlsProbeGAError)
env=0; assert(fire('MlsProbeWrite','3').MlsProbeError)
env=-1; disk[0]='corrupt'; boot(); assert(fire('MlsProbeWrite','1').MlsProbeError and disk[0]=='corrupt')
print('PASS: two fields, preserved fields, duplicate write, rollback, reload, asynchronous GA Set/Get/Incrby, GA errors, corrupt archive, environment guard')
