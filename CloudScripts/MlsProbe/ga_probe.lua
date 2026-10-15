--[[
2026-10-16 本地实测：Set/Get=73100，Incrby(+7)/Get=73107，重开后仍为73107。
落盘：魔兽目录/kkapi_local_plugin.ini，[DzAPI]
GlobalArchive:local:GAKV-war3lib:mlsprobe:ga:v1=73107
证据：War3Lib/日志/log-2026-10-16-00-10-48-P1.log、00-11-32-P1.log。
首次缺失值为 JSON null userdata，而非 nil；下方已兼容，缺失分支修复只做过离线回归。
启动不重置；跨局先 s4 读取，s5 会覆盖测试值。这里只验证单房间本地插件，未验证线上与并发。
完整测试记录及命令见 Jass/learn/MlsProbe_Test.j 开头注释。
]]
-- Dedicated persistent key, never reset on startup. Single-room local probe only.
local KEY = 'war3lib:mlsprobe:ga:v1'
local busy = false
local halted = false
-- Local runtime decodes missing GA values as JSON null (lightuserdata).
local JSON_NULL = json.decode('null')
local function value_or_nil(value)
    if value == JSON_NULL then return nil end
    return value
end
local function send(slot, tag, value)
    MsSendMlEvent(slot, tag, tostring(value))
end
local function fail(slot, message)
    busy = false
    halted = true -- uncertain writes must not be retried automatically
    Log.Error('[MlsProbeGA] %s', message)
    send(slot, 'MlsProbeGAError', message)
end
local function callback(slot, operation, fn)
    return function(msg)
        if halted then return end
        local ok, err = pcall(function()
            if type(msg) ~= 'table' or msg.errnu ~= 0 or type(msg.data) ~= 'table' then
                error(operation .. ' errnu=' .. tostring(msg and msg.errnu))
            end
            Log.Info('[MlsProbeGA] %s reply=%s', operation, json.encode(msg))
            fn(msg.data)
        end)
        if not ok then fail(slot, tostring(err)) end
    end
end
local function get(slot, expected)
    MsGAGet(KEY, callback(slot, 'Get', function(data)
        local value = value_or_nil(data.value)
        if expected ~= nil and tostring(value) ~= tostring(expected) then
            error('readback mismatch expected=' .. tostring(expected) .. ' actual=' .. tostring(value))
        end
        busy = false
        if expected ~= nil then send(slot, 'MlsProbeGACheck', tostring(expected)) end
        send(slot, 'MlsProbeGAResult', value == nil and '<missing>' or value)
    end))
end
RegisterEvent('MlsProbeGA', function(id, eventName, payload, slot)
    if slot < 0 then return end
    if MsGetEnvType() ~= -1 then fail(slot, 'local environment required'); return end
    if busy or halted then send(slot, 'MlsProbeGAError', 'busy or halted; restart before retry'); return end
    busy = true
    local ok, err = pcall(function()
        if payload == 'get' then
            get(slot)
        elseif payload == 'set' then
            -- Only explicit s5 overwrites this dedicated test key.
            MsGASet(KEY, '73100', callback(slot, 'Set', function(data)
                if data.ok ~= true then error('Set not acknowledged') end
                get(slot, '73100')
            end))
        elseif payload == 'incr' then
            MsGAGet(KEY, callback(slot, 'GetBeforeIncr', function(data)
                local value = value_or_nil(data.value)
                local before = value == nil and 0 or tonumber(value)
                if not before or before % 1 ~= 0 or math.abs(before) > 1000000000 then error('invalid counter') end
                MsGAIncrby(KEY, 7, callback(slot, 'Incrby', function(result)
                    if tonumber(result.value) ~= before + 7 then error('Incrby mismatch (single room expected)') end
                    get(slot, before + 7)
                end))
            end))
        else error('unknown operation') end
    end)
    if not ok then fail(slot, tostring(err)) end
end)
Log.Info('[MlsProbeGA] key=%s; startup never writes', KEY)
