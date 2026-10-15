-- Dedicated local probe. Do not bind this script to a production map.
-- ScriptArchive is one whole blob per player; preserve unknown fields.
local archives = {}
local requests = {}

local function reply(slot, tag, text)
    local result = MsSendMlEvent(slot, tag, tostring(text))
    Log.Info('[MlsProbe] reply slot=%s tag=%s result=%s', tostring(slot), tag, tostring(result))
end

local function load_archive(slot)
    if archives[slot] then return archives[slot] end
    local raw = MsGetScriptArchive(slot)
    local data = {}
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if not ok or type(decoded) ~= 'table' then
            error('invalid archive; refusing to overwrite')
        end
        data = decoded
    end
    local count = data.war3lib_mls_probe_count
    if count == nil then count = 0 end
    if type(count) ~= 'number' or count < 0 or count % 1 ~= 0 or count > 1000000000 then
        error('invalid probe counter')
    end
    data.war3lib_mls_probe_count = count
    local score = data.war3lib_mls_probe_score or 0
    if type(score) ~= 'number' or score < 0 or score % 1 ~= 0 or score > 1000000000 then
        error('invalid probe score')
    end
    data.war3lib_mls_probe_score = score
    archives[slot] = data
    return data
end

local function register(name, handler)
    RegisterEvent(name, function(id, eventName, payload, slot)
        if slot < 0 then return end
        -- Configured as -1 locally; prevent accidental use on a live map.
        if MsGetEnvType() ~= -1 then
            reply(slot, 'MlsProbeError', 'local environment required')
            return
        end
        local ok, err = pcall(handler, slot, payload)
        if not ok then
            Log.Error('[MlsProbe] %s', tostring(err))
            reply(slot, 'MlsProbeError', 'script error; inspect MLS log')
        end
    end)
end

register('MlsProbePing', function(slot, payload)
    reply(slot, 'MlsProbePong', payload)
end)

register('MlsProbeRead', function(slot)
    local data = load_archive(slot)
    reply(slot, 'MlsProbeDetail', json.encode({count=data.war3lib_mls_probe_count, score=data.war3lib_mls_probe_score}))
    reply(slot, 'MlsProbeScore', data.war3lib_mls_probe_score)
    reply(slot, 'MlsProbeReadResult', data.war3lib_mls_probe_count)
end)

register('MlsProbeWrite', function(slot, payload)
    if type(payload) ~= 'string' or not payload:match('^%d+$') or #payload > 10 then
        error('invalid request ID')
    end
    requests[slot] = requests[slot] or {}
    if requests[slot][payload] then
        reply(slot, 'MlsProbeWriteResult', requests[slot][payload])
        return
    end
    local data = load_archive(slot)
    local before = data.war3lib_mls_probe_count
    local beforeScore = data.war3lib_mls_probe_score
    if before >= 1000000000 or beforeScore > 999999990 then error('counter limit') end
    data.war3lib_mls_probe_count = before + 1
    data.war3lib_mls_probe_score = beforeScore + 10
    local ok, encoded = pcall(json.encode, data)
    if not ok then
        data.war3lib_mls_probe_count = before
        data.war3lib_mls_probe_score = beforeScore
        error(encoded)
    end
    local saved, result = pcall(MsSaveScriptArchive, slot, encoded, #encoded)
    if not saved or result ~= 0 then
        data.war3lib_mls_probe_count = before
        data.war3lib_mls_probe_score = beforeScore
        error('save failed: ' .. tostring(result))
    end
    requests[slot][payload] = before + 1
    reply(slot, 'MlsProbeWriteResult', before + 1)
end)

Log.Info('[MlsProbe] loaded; ping/read do not modify archive; write explicitly saves')
require('ga_probe')
require('size_probe')
