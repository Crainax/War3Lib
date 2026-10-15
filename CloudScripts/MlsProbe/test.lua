-- Offline contract test. Mocks platform APIs; does not prove plugin persistence.
local events, sent, disk = {}, {}, {}
local saveCount, saveCode, env = 0, 0, -1
Log = { Info = function() end, Error = function() end }
json = {
    encode = function(t)
        return tostring(t.war3lib_mls_probe_count) .. ':' .. (t.other or '')
    end,
    decode = function(s)
        local n, other = s:match('^(%d+):(.*)$')
        assert(n, 'corrupt mock archive')
        return { war3lib_mls_probe_count = tonumber(n), other = other }
    end,
}
function RegisterEvent(name, fn) events[name] = fn end
function MsGetEnvType() return env end
function MsGetScriptArchive(slot) return disk[slot] end
function MsSaveScriptArchive(slot, data, length)
    assert(#data == length)
    saveCount = saveCount + 1
    if saveCode == 0 then disk[slot] = data end
    return saveCode
end
function MsSendMlEvent(slot, tag, data)
    sent = { slot = slot, tag = tag, data = data }
    return 0
end
local function boot()
    events = {}
    dofile('CloudScripts/MlsProbe/main.lua')
end
local function fire(name, payload)
    events[name](1, name, payload or '', 0)
    return sent
end
disk[0] = '7:preserved'
boot()
assert(fire('MlsProbePing', 'hello').data == 'hello')
assert(fire('MlsProbeRead').data == '7' and saveCount == 0)
assert(fire('MlsProbeWrite', '1').data == '8')
assert(disk[0] == '8:preserved' and saveCount == 1)
assert(fire('MlsProbeWrite', '1').data == '8' and saveCount == 1)
saveCode = 1
assert(fire('MlsProbeWrite', '2').tag == 'MlsProbeError')
assert(fire('MlsProbeRead').data == '8')
saveCode = 0
boot()
assert(fire('MlsProbeRead').data == '8')
env = 0
assert(fire('MlsProbeWrite', '3').tag == 'MlsProbeError')
env = -1
disk[0] = 'corrupt'
boot()
assert(fire('MlsProbeWrite', '1').tag == 'MlsProbeError')
assert(disk[0] == 'corrupt')
print('PASS: roundtrip, read-only startup, write, duplicate request, save rollback, reload, environment guard, corrupt archive guard')
