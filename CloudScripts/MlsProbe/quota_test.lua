-- Contract mocks: not plugin persistence proof. Run from repository root.
package.path='CloudScripts/MlsProbe/?.lua;'..package.path
local function copy(x) if type(x)~='table' then return x end local r={} for k,v in pairs(x) do r[k]=copy(v) end return r end
local blobs,events,sent,disk={}, {},{},nil
local serial,seconds,code,env,now=0,0,0,-1,1793548800 -- Monday 2026-11-02 UTC
json={encode=function(x) serial=serial+1; local s='blob'..serial; blobs[s]=copy(x); return s end,decode=function(s) if s=='null' then return nil end return copy(assert(blobs[s])) end}
Log={Info=function()end,Error=function()end}
function RegisterEvent(n,f) events[n]=f end
function MsGetEnvType() return env end
function MsGetRoomGameTime() return seconds end
function MsGetScriptArchive() return disk end
function MsSaveScriptArchive(_,s,n) assert(#s==n); if code==0 then disk=s end return code end
function MsSendMlEvent(_,tag,s) sent[tag]=s; return 0 end
local originalTime=os.time; os.time=function()return now end
local function boot() dofile('CloudScripts/MlsProbe/main.lua') end
local function fire(cmd) sent={};events.MlsQuota(1,'MlsQuota',cmd,0);return sent.MlsQuotaResult or sent.MlsProbeError end
local function expect(cmd,result) local r=fire(cmd);assert(r and r:find(result,1,true),tostring(r)..' expected '..result) end
disk=json.encode({other='keep'})
boot();expect('1','TOO_EARLY');seconds=15
expect('1','GRANTED');local first=disk;expect('1','DUPLICATE');assert(disk==first)
code=1;expect('2','script error');assert(disk==first);code=0
expect('2','GRANTED');expect('3','DAILY_LIMIT')
boot();expect('status','total=2');expect('1','DUPLICATE');expect('3','DAILY_LIMIT')
expect('nextday','DAY_ADVANCED');expect('1','GRANTED');expect('2','WEEKLY_LIMIT')
boot();expect('status','total=3');expect('1','DUPLICATE')
for i=1,6 do expect('nextday','DAY_ADVANCED') end
expect('1','GRANTED');expect('status','total=4')
assert(json.decode(disk).other=='keep')
now=now+86400;expect('status','daily=0/2') -- actual day rollover, not just offset
seconds=14;expect('2','TOO_EARLY');seconds=15
code=1;local before=disk;expect('nextday','script error');assert(disk==before);code=0
boot();expect('status','offset=7')
env=0;expect('1','local environment required');env=-1
local bad=json.decode(disk);bad.mls_quota_v1.daily=-1;disk=json.encode(bad);boot();expect('1','script error')
os.time=originalTime
print('PASS quota: time gate, daily/weekly limits, persistent duplicates, reboot, day/week rollover, save rollback, preserved fields, environment guard, corrupt state')
