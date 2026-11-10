--[[
额度测试实测记录（2026-11-10，本地 KKWE，玩家槽位0）：
  日志目录：魔兽目录/War3Lib/日志。
  log-2026-11-10-14-14-41-P1.log：GRANTED -> DUPLICATE -> GRANTED -> DAILY_LIMIT；
    daily=2/2、weekly=2/3、total=2，重复领取未增加计数。
  log-2026-11-10-14-16-18-P1.log：重开 STATUS 仍为2/2、2/3、total=2、mask=3；
    再领编号1返回DUPLICATE，证明本地跨局额度和去重记录保留。
  log-2026-11-10-14-16-45-P1.log：s13推进一天，daily=0、weekly=2、total=2；
    18秒领取成功，weekly=3/3；20秒再次领取返回WEEKLY_LIMIT，daily仍为1/2。
  前三局结束时，INI的 MLS-ScriptArchive-0 / mls_quota_v1 为：
    {daily=1,weekly=3,total=3,offset=1,day=20768,week=2967,mask=1}。
    原count=3、score=20及其他测试字段仍保留；trace/info双日志不代表执行两次。
  已实测：日上限、周上限、同局/跨局重复领取、跨局保留、模拟跨日重置日额度。
  补测 log-2026-11-10-14-19-48-P1.log：week=2967、weekly=3/3，经s13推进到
    week=2968时weekly归零，total仍为3；继续推进到week=2969、offset=16。
  补测 log-2026-11-10-14-20-42-P1.log：重开仍为week=2969、offset=16，
    roomSeconds=9、9、14的三次领取均返回TOO_EARLY；daily=0、weekly=0、total=3、
    mask=0均未改变，确认拒绝不扣额度、不标记已领取，重置状态跨局保留。
  补测后INI最终值：{daily=0,weekly=0,total=3,offset=16,day=20783,week=2969,mask=0}。
  补测已通过：不足15秒拒绝领取、模拟跨周额度重置、重置状态跨局保留。
  精确15秒边界仍仅离线验证；游戏内已分别观察14秒拒绝、此前18秒成功，
    最新一局没有>=15秒再次领取的记录。模拟跨周使用s13，并非等待真实周一。
  补测时长：先s13推进到新的一天使mask=0，退出重开；尽早输入s10，回包须为
    TOO_EARLY且roomSeconds<15；等待>=15秒再输入同一命令。若周额度已满，后一次
    会返回WEEKLY_LIMIT（符合检查顺序）；需要成功对照时先推进到新周且确认额度空闲。
  本地INI落盘不等于正式平台持久化或跨房间并发保证；未进行线上验证。
]]
-- Local-only quota probe, 2026-11-08. No Xlimon dependencies.
-- Uses main.lua's shared whole-archive cache: other probe fields are preserved.
-- s9=status; s10/11/12=claim 1/2/3; s13=advance one TEST day (persistent).
-- 15 room seconds; daily 2, weekly 3. Each successful claim grants one point.
-- UTC+8 midnight daily reset, Monday weekly reset. os.time is local simulation
-- wall time, not client-provided time. This is NOT production trusted-clock proof.
-- Actual room gate uses MsGetRoomGameTime; nextday cannot bypass that gate.
-- Duplicate scope is (test day, claim number), deliberately stable across boots.
-- This tests idempotency, not a production reward entitlement protocol.
-- Persistence: kkapi_local_plugin.ini / MLS-ScriptArchive-0 / mls_quota_v1.
-- Read does not save. Save error restores cache; unknown exceptions halt via main.
-- Manual: before 15s s10 => TOO_EARLY; later s10 => GRANTED, s10 => DUPLICATE;
-- s11 => GRANTED; s12 => DAILY_LIMIT. Reopen: s9 same totals, s10 DUPLICATE.
-- s13 then s10 => GRANTED (unless real week boundary); s11 => WEEKLY_LIMIT.
-- Advance s13 to next week (inspect week), then s10 => GRANTED; total never resets.
-- Offline quota_test covers rollover, reboot, failed save and malformed state.
-- Local plugin cross-session persistence verified below; online concurrency unverified.
return function(register, load_archive, reply)
    local KEY = 'mls_quota_v1'
    local function integer(x) return type(x)=='number' and x>=0 and x%1==0 and x<=1000000000 end
    register('MlsQuota', function(slot, command)
        if command~='status' and command~='nextday' and not command:match('^[123]$') then error('invalid quota command') end
        local root = load_archive(slot)
        local previous = root[KEY]
        local q = {}
        if previous ~= nil then
            if type(previous)~='table' then error('invalid quota archive') end
            for _,k in ipairs({'offset','day','week','daily','weekly','total','mask'}) do
                if not integer(previous[k]) then error('invalid quota '..k) end
                q[k]=previous[k]
            end
            if q.daily>2 or q.weekly>3 or q.mask>7 then error('invalid quota limits') end
        else
            q={offset=0,day=0,week=0,daily=0,weekly=0,total=0,mask=0}
        end
        if command=='nextday' then q.offset=q.offset+1 end
        local now=os.time()
        local day=math.floor((now+8*3600)/86400)+q.offset
        local week=math.floor((day+3)/7) -- Unix epoch was Thursday
        if day<q.day or week<q.week then error('clock moved backwards') end
        if week~=q.week then q.week=week; q.weekly=0 end
        if day~=q.day then q.day=day; q.daily=0; q.mask=0 end
        local seconds=MsGetRoomGameTime()
        if not integer(seconds) then error('invalid room time') end
        local result='STATUS'
        local changed=command=='nextday'
        if changed then result='DAY_ADVANCED'
        elseif command~='status' then
            local bit=2^(tonumber(command)-1)
            if math.floor(q.mask/bit)%2==1 then result='DUPLICATE'
            elseif seconds<15 then result='TOO_EARLY'
            elseif q.daily>=2 then result='DAILY_LIMIT'
            elseif q.weekly>=3 then result='WEEKLY_LIMIT'
            else
                result='GRANTED'; changed=true
                q.mask=q.mask+bit; q.daily=q.daily+1; q.weekly=q.weekly+1; q.total=q.total+1
            end
        end
        if changed then
            root[KEY]=q
            local ok, err=pcall(function()
                local encoded=json.encode(root)
                local code=MsSaveScriptArchive(slot,encoded,#encoded)
                if code~=0 then error('quota save failed: '..tostring(code)) end
            end)
            if not ok then root[KEY]=previous; error(err) end
        end
        reply(slot,'MlsQuotaResult',string.format('%s day=%d week=%d offset=%d daily=%d/2 weekly=%d/3 total=%d mask=%d roomSeconds=%d',result,q.day,q.week,q.offset,q.daily,q.weekly,q.total,q.mask,seconds))
    end)
end
