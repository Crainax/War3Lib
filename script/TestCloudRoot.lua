-- Run: lua script/TestCloudRoot.lua <CloudScripts root> MlsProbe|Shengjingshi
-- Models KKWE's hidden package/io/debug globals, not platform persistence.
local root, module = assert(arg[1]), assert(arg[2])
assert(module == 'MlsProbe' or module == 'Shengjingshi')
local entry = assert(loadfile(root .. '/main.lua'))
package.path = root .. '/?.lua;' .. root .. '/?/init.lua'
local events, sent, saves = {}, {}, 0
Log = {Info=function() end, Error=function() end}
json = {decode=function(text) assert(text == 'null'); return nil end,
        encode=function() return '{}' end}
function RegisterEvent(name, fn) events[name] = fn end
function MsGetEnvType() return -1 end
function MsGetScriptArchive() return nil end
function MsSaveScriptArchive() saves = saves + 1; error('read test must not save') end
function MsSendMlEvent(_, tag, payload) sent[tag] = payload; return 0 end
package, io, debug = nil, nil, nil
entry()
if module == 'MlsProbe' then
    assert(events.MlsProbePing and events.MlsProbeRead and events.MlsProbeWrite)
    assert(events.MlsProbeGA and events.MlsSize)
    events.MlsProbePing(1, 'MlsProbePing', 'root-entry-check', 0)
    assert(sent.MlsProbePong == 'root-entry-check', 'Ping did not reply')
    events.MlsProbeRead(1, 'MlsProbeRead', '', 0)
    assert(sent.MlsProbeReadResult == '0' and sent.MlsProbeScore == '0')
else
    assert(events.SJSRead and events.SJSOp)
    events.SJSRead(1, 'SJSRead', '2|1', 0)
    assert(sent.SJSBegin and sent.SJSEnd and not sent.SJSError, 'SJS initial read failed')
end
assert(saves == 0 and package == nil)
print('PASS ' .. module .. ': hidden package, nested requires, events, replies; zero archive writes')
