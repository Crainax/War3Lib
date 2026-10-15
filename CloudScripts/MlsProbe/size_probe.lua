--[[
2026-10-16 KKWE 本地实测（log-2026-10-16-01-29-12-P1.log）：
100条 [10位字符串UID,"一二三四五六#2134",999] 紧凑数组：4501字节。
名字UTF-8为23字节，实际编码 unicodeEscaped=false；不是去掉UID后的3201字节。
4095/4096/4097/4501字节均 Set成功、Get完整相等，无截断；本地没有执行4096字节上限。
不能外推线上允许超限，也没有测出本地最大容量。测试不预先拦截超限，以观测插件真实行为。
落盘：魔兽目录/kkapi_local_plugin.ini，[DzAPI]，key前缀
GlobalArchive:local:GAKV-war3lib:mlsprobe:size:v1:（4095、4096、4097、rank100）。
INI 将 # 存为 \#，rank100 文件值4601字节，解转义及接口读回均4501字节。
先写seed再写目标，检查回调及完整读回；无回调只报不确定，不当作成功或明确拒绝。
s7只测编码；s8覆盖独立测试key。此轮只验证同局读回及文件落盘，未专门验证大值跨局读取。
完整联调记录见 Jass/learn/MlsProbe_Test.j 开头注释。
]]
-- Local-only measurement and destructive writes ONLY to dedicated probe keys.
local busy = false
local function report(slot, text)
    Log.Info('[MlsSize] %s', text)
    MsSendMlEvent(slot, 'MlsSizeReport', text)
end
local function rank_payload()
    local rows = {}
    for i = 1, 100 do
        -- Synthetic unique 10-digit UID strings, not real account identifiers.
        rows[i] = { tostring(1000000000 + i), '一二三四五六#2134', 999 }
    end
    return json.encode(rows)
end
local function measure(slot)
    local text = rank_payload()
    local decoded = json.decode(text)
    assert(#decoded == 100 and decoded[100][3] == 999, 'rank decode mismatch')
    report(slot, 'rows=100 uid=10-digit string nameBytes=' .. #'一二三四五六#2134'
        .. ' compactBytes=' .. #text .. ' unicodeEscaped=' .. tostring(text:find('\\u', 1, true) ~= nil))
    report(slot, 'row1=' .. json.encode(decoded[1]))
    return text
end
RegisterEvent('MlsSize', function(id, name, payload, slot)
    if slot < 0 then return end
    if MsGetEnvType() ~= -1 or busy then
        MsSendMlEvent(slot, 'MlsSizeDone', 'blocked: local-only or busy')
        return
    end
    busy = true
    local function finish(text)
        busy = false
        MsSendMlEvent(slot, 'MlsSizeDone', text)
    end
    local ok, err = pcall(function()
        local rank = measure(slot)
        if payload == 'measure' then finish('measurement complete'); return end
        assert(payload == 'boundary', 'unknown command')
        local cases = {
            { '4095', string.rep('A',4095) },
            { '4096', string.rep('B',4096) },
            { '4097', string.rep('C',4097) },
            { 'rank100', rank },
        }
        local function run(index)
            if not cases[index] then finish('boundary sequence complete; inspect each result'); return end
            local label, value = cases[index][1], cases[index][2]
            local key = 'war3lib:mlsprobe:size:v1:' .. label
            local seedDone = false
            local function abort(message) report(slot,message); finish('INCONCLUSIVE'); end
            MsGASet(key, 'seed', function(seed)
                if seedDone then return end
                seedDone = true
                if seed.errnu ~= 0 or not seed.data or seed.data.ok ~= true then abort('seed failed '..label); return end
                local checked = false
                local function verify(status)
                    if checked then return end
                    checked = true
                    local got = false
                    MsGAGet(key, function(msg)
                        if got then return end
                        got = true
                        local actual = msg.data and msg.data.value
                        local outcome = 'UNEXPECTED'
                        if msg.errnu == 0 then
                            if actual == value then outcome = 'EXACT_ROUNDTRIP'
                            elseif actual == 'seed' then outcome = 'SEED_UNCHANGED' end
                        end
                        report(slot, label .. ' bytes=' .. #value .. ' ' .. status .. ' getErr=' .. tostring(msg.errnu)
                            .. ' readBytes=' .. (type(actual)=='string' and #actual or -1) .. ' ' .. outcome)
                        run(index + 1)
                    end)
                    Timer.After(3, function() if not got then got=true; abort('Get timeout '..label) end end)
                end
                local called, tid = pcall(MsGASet, key, value, function(msg)
                    verify('setErr=' .. tostring(msg.errnu) .. ' setOK=' .. tostring(msg.data and msg.data.ok))
                end)
                report(slot, label .. ' Set returned=' .. tostring(tid) .. ' callOK=' .. tostring(called))
                if not called then verify('Set threw') end
                Timer.After(3, function() verify('NO_SET_CALLBACK; acceptance inconclusive') end)
            end)
            Timer.After(3, function() if not seedDone then seedDone=true; abort('seed timeout '..label) end end)
        end
        run(1)
    end)
    if not ok then report(slot, 'ERROR '..tostring(err)); finish('failed') end
end)
