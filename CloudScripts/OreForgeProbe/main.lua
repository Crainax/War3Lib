-- Independent MLS probe; deploy ONLY to a dedicated test map.
-- Proof scope: server-side ledger + seven-attribute results + durable request IDs.
-- No delete/reset/award/seed-upload endpoint. No MsConsumeItem: OFPOre is acquired total.
-- Same-account cross-room concurrency and platform durability are NOT established here.
local cfg = require('ore_config')
local rules = require('ore_forge')
local archives, busy, blocked = {}, {}, {}
local function num(value) return string.format('%.0f', value) end

local function send(slot, event, text)
    assert(#text <= 900, 'reply exceeds MLS event byte limit')
    local result = MsSendMlEvent(slot, event, text)
    Log.Info('[OreForgeProbe] slot=%s event=%s send=%s data=%s', tostring(slot), event, tostring(result), text)
end

local function load(slot)
    if archives[slot] then return archives[slot] end
    local raw = MsGetScriptArchive(slot)
    local root = {}
    if raw ~= nil and raw ~= '' then
        if type(raw) ~= 'string' then error('invalid archive type') end
        root = json.decode(raw)
        if type(root) ~= 'table' then error('corrupt archive; not overwriting') end
    end
    if root[cfg.archive_field] == nil then root[cfg.archive_field] = rules.empty() end
    if not rules.validate(root[cfg.archive_field], cfg) then error('invalid forge archive; not overwriting') end
    archives[slot] = root
    return root
end

local function acquired(slot)
    -- Never accept ore totals or identity from client payloads. No mock fallback.
    local total = MsGetPlayerItem(slot, cfg.ore_key)
    if not rules.integer(total, 0, cfg.max_total) then error('invalid platform ore count') end
    return total
end

local function stone_line(stone)
    return table.concat({stone.request, num(stone.serial), num(stone.tier), num(stone.cost),
        rules.numbers(stone.locks), rules.numbers(stone.attrs)}, '|')
end

local function register(event, handler)
    RegisterEvent(event, function(_, _, payload, slot)
        if not rules.integer(slot, 0, 11) then return end
        if not cfg.allowed_env[MsGetEnvType()] then send(slot, 'OFPError', 'ENV_BLOCKED'); return end
        if busy[slot] then send(slot, 'OFPError', 'BUSY'); return end
        if blocked[slot] then send(slot, 'OFPError', 'OUTCOME_UNKNOWN_RESTART'); return end
        busy[slot] = true
        local ok, err = pcall(handler, slot, payload)
        busy[slot] = nil
        if not ok then
            blocked[slot] = true
            Log.Error('[OreForgeProbe] slot=%s error=%s', tostring(slot), tostring(err))
            send(slot, 'OFPError', 'SERVER_ERROR_RESTART')
        end
    end)
end

register('OFPRead', function(slot, payload)
    if payload ~= '' then send(slot, 'OFPError', 'BAD_REQUEST'); return end
    local state = load(slot)[cfg.archive_field]
    local total = acquired(slot)
    if total < state.spent then send(slot, 'OFPError', 'SOURCE_BELOW_SPENT'); return end
    -- One stone per event: never send the entire archive through a 900-byte event.
    for _, stone in ipairs(state.stones) do send(slot, 'OFPStone', stone_line(stone)) end
    send(slot, 'OFPStatus', table.concat({num(total), num(state.spent), num(total - state.spent), num(#state.stones)}, '|'))
end)

register('OFPForge', function(slot, payload)
    local request, err = rules.parse(payload)
    if not request then send(slot, 'OFPError', err); return end
    local root = load(slot)
    local total = acquired(slot)
    if total < root[cfg.archive_field].spent then send(slot, 'OFPError', 'SOURCE_BELOW_SPENT'); return end
    -- Deep-copy the WHOLE archive to retain unrelated fields and isolate failed writes.
    local candidate = json.decode(json.encode(root))
    local state = candidate[cfg.archive_field]
    local stone, outcome = rules.forge(state, request, total, cfg, math.random)
    if not stone then send(slot, 'OFPError', outcome); return end
    if outcome == 'CREATED' then
        assert(rules.validate(state, cfg), 'invalid candidate')
        local encoded = json.encode(candidate)
        assert(#encoded <= cfg.max_archive_bytes, 'probe archive byte limit')
        local called, result = pcall(MsSaveScriptArchive, slot, encoded, #encoded)
        if not called or result ~= 0 then
            -- Do not retry/re-roll or report the random result on an ambiguous save failure.
            blocked[slot] = true
            Log.Error('[OreForgeProbe] save uncertain slot=%s result=%s', tostring(slot), tostring(result))
            send(slot, 'OFPError', 'SAVE_UNCERTAIN_RESTART')
            return
        end
        archives[slot] = candidate
    end
    -- Saved receipt is the stone itself. Reboot/replay performs NO write and NO RNG draw.
    send(slot, 'OFPResult', outcome .. '|' .. num(state.spent) .. '|' .. num(total - state.spent) .. '|' .. stone_line(stone))
end)

Log.Info('[OreForgeProbe] ready item=%s; cost=1/3/15/50; test environments only; RNG=runtime math.random (quality unverified)', cfg.ore_key)
