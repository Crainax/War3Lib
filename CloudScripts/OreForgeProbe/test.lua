-- Run from War3Lib root: lua CloudScripts/OreForgeProbe/test.lua
-- Offline behavioral tests: API + JSON-token mocks. NOT real MLS JSON or disk proof.
package.path = 'CloudScripts/OreForgeProbe/?.lua;' .. package.path
local cfg = require('ore_config')
local rules = require('ore_forge')
local events, sent, disk, blobs = {}, {}, {}, {}
local seq, writes, draws, checked = 0, 0, 0, 0
local env, ore, save_mode = -1, 69, 'ok'
local reenter = nil
local function copy(value)
    if type(value) == 'number' then return value + 0.0 end -- model float-valued JSON numbers
    if type(value) ~= 'table' then return value end
    local result = {}
    for k, v in pairs(value) do result[k] = copy(v) end
    return result
end
json = {
    encode = function(t) seq = seq + 1; local key = 'JSON' .. seq; blobs[key] = copy(t); return key end,
    decode = function(key) assert(blobs[key], 'bad JSON'); return copy(blobs[key]) end,
}
Log = {Info = function() end, Error = function() end}
function RegisterEvent(name, fn) events[name] = fn end
function MsGetEnvType() return env end
function MsGetPlayerItem(slot, key) assert(key == 'OFPOre'); assert(slot == 0 or slot == 1); return ore end
function MsGetScriptArchive(slot) return disk[slot] end
function MsSendMlEvent(slot, name, text) sent[name] = text; return 0 end
function MsSaveScriptArchive(slot, text, length)
    assert(length == #text)
    writes = writes + 1
    if reenter then local cb = reenter; reenter = nil; cb() end
    if save_mode == 'ok' or save_mode == 'committed_error' then disk[slot] = text end
    if save_mode == 'throw' then error('network failure') end
    if save_mode ~= 'ok' then return 9 end
    return 0
end
local real_random = math.random
math.random = function(a, b) draws = draws + 1; return real_random(a, b) end
math.randomseed(321) -- ONLY offline harness; NEVER a deployment seed.
local function boot() events = {}; dofile('CloudScripts/OreForgeProbe/main.lua') end
local function fire(name, payload, slot)
    sent = {}
    events[name](1, name, payload or '', slot or 0)
    return sent
end
local function forge(payload, slot) return fire('OFPForge', payload, slot) end
local function read() return fire('OFPRead') end
local function state() return json.decode(disk[0])[cfg.archive_field] end
local function check(name, fn) fn(); checked = checked + 1; print('PASS ' .. checked .. ': ' .. name) end

boot()
check('read uses platform quantity and creates no archive', function()
    assert(read().OFPStatus == '69|0|69|0' and writes == 0)
end)
local requests = {'F1|0|', 'F2|1|1', 'F3|2|1,2', 'F4|3|1,2,3'}
check('four prices, 7 unique attributes, lock membership, preserved unknown fields', function()
    disk[0] = json.encode({other = {keep = 'yes'}}); boot()
    for tier = 0, 3 do
        assert(forge(requests[tier + 1]).OFPResult:match('^CREATED|'))
        assert(rules.validate(state(), cfg))
    end
    assert(state().spent == 69 and #state().stones == 4 and read().OFPStatus == '69|69|0|4')
    assert(json.decode(disk[0]).other.keep == 'yes')
end)
local original = disk[0]
check('same session replay never saves or draws', function()
    local w, d = writes, draws
    assert(forge('F4|3|3,1,2').OFPResult:match('^REPLAY|69|0|'))
    assert(writes == w and draws == d and disk[0] == original)
end)
check('reboot replay all four IDs returns exactly the saved attributes, no charge', function()
    local before = state()
    local w, d = writes, draws
    boot()
    for i, req in ipairs(requests) do
        local result = forge(req).OFPResult
        assert(result:match('^REPLAY|69|0|'))
        local attrs = rules.numbers(before.stones[i].attrs)
        assert(result:sub(-#attrs) == attrs)
    end
    assert(writes == w and draws == d and disk[0] == original)
end)
check('same ID with other locks or price is rejected', function()
    assert(forge('F4|2|1,2').OFPError == 'REQUEST_CONFLICT')
    assert(forge('F4|3|1,2,4').OFPError == 'REQUEST_CONFLICT')
    assert(disk[0] == original)
end)
check('zero balance cannot create new stone', function()
    assert(forge('F5|0|').OFPError == 'NO_ORE' and disk[0] == original)
end)
check('malformed IDs, tiers, repeated/out-of-range locks, extra price rejected', function()
    local w, d = writes, draws
    for _, req in ipairs({'X|2|1,1', 'X|1|40', 'X|1|0', 'X|1|1,', 'X|0|1', 'X|3|1,2',
                         'X|4|', 'X|0||0', 'X|0|;price=0', 'X_Y|0|', string.rep('A',25)..'|0|'}) do
        assert(forge(req).OFPError)
    end
    assert(writes == w and draws == d)
end)
check('platform quantity regression is not clamped into free ore', function()
    ore = 68; assert(read().OFPError == 'SOURCE_BELOW_SPENT')
    assert(forge('F1|0|').OFPError == 'SOURCE_BELOW_SPENT'); ore = 69
end)
check('official environment refused; test environments accepted', function()
    env = 0; assert(read().OFPError == 'ENV_BLOCKED')
    env = 1; assert(read().OFPStatus == '69|69|0|4')
    env = 2; assert(read().OFPStatus); env = -1
end)
check('caller slot isolates player archives', function()
    assert(forge('F1|0|',1).OFPResult:match('^CREATED|1|68|'))
    assert(disk[0] == original)
end)
check('save rejected: no result leaked, block retries, reload old ledger', function()
    ore = 100; save_mode = 'reject'
    assert(forge('Failure|0|').OFPError == 'SAVE_UNCERTAIN_RESTART')
    assert(disk[0] == original)
    assert(forge('Failure|0|').OFPError == 'OUTCOME_UNKNOWN_RESTART')
    save_mode = 'ok'; boot(); assert(read().OFPStatus == '100|69|31|4')
end)
check('save committed but response reports failure: reboot SAME request replays', function()
    save_mode = 'committed_error'
    assert(forge('Unknown|0|').OFPError == 'SAVE_UNCERTAIN_RESTART')
    assert(state().spent == 70)
    local w, d = writes, draws
    save_mode = 'ok'; boot()
    assert(forge('Unknown|0|').OFPResult:match('^REPLAY|70|30|'))
    assert(writes == w and draws == d)
end)
check('save exception blocks in-session retry', function()
    save_mode = 'throw'; assert(forge('Thrown|0|').OFPError == 'SAVE_UNCERTAIN_RESTART')
    assert(state().spent == 70)
    save_mode = 'ok'; boot()
end)
check('same-slot reentrant request blocked during write', function()
    local nested
    reenter = function() nested = forge('Nested|0|').OFPError end
    assert(forge('Outer|0|').OFPResult:match('^CREATED|71|29|'))
    assert(nested == 'BUSY' and not rules.find(state(), 'Nested'))
end)
check('corrupt archive and inconsistent spent never overwritten', function()
    local saved, w = disk[0], writes
    disk[0] = 'corrupt'; boot(); assert(read().OFPError == 'SERVER_ERROR_RESTART' and writes == w)
    disk[0] = saved
    local bad = json.decode(saved); bad[cfg.archive_field].spent = 0
    disk[0] = json.encode(bad); boot(); assert(read().OFPError == 'SERVER_ERROR_RESTART' and writes == w)
    disk[0] = saved; boot()
end)
check('invalid platform count fails closed; no fallback quantity', function()
    ore = -1; assert(read().OFPError == 'SERVER_ERROR_RESTART')
    ore = 100; boot()
end)
check('bag capacity retains receipts; replay works when full', function()
    local s = rules.empty()
    for i = 1, 25 do
        local r = assert(rules.parse('B' .. i .. '|0|'))
        assert(select(2, rules.forge(s,r,100,cfg,math.random)) == 'CREATED')
    end
    assert(rules.validate(s,cfg))
    assert(select(2,rules.forge(s,assert(rules.parse('B26|0|')),100,cfg,math.random)) == 'BAG_FULL')
    assert(select(2,rules.forge(s,assert(rules.parse('B1|0|')),100,cfg,math.random)) == 'REPLAY')
end)
check('all tiers: repeated property checks across random samples', function()
    for tier = 0, 3 do
        for sample = 1, 500 do
            local list = ({'', '39', '38,39', '37,38,39'})[tier+1]
            local s = rules.empty()
            assert(rules.forge(s,assert(rules.parse('R|'..tier..'|'..list)),100,cfg,math.random))
            assert(rules.validate(s,cfg))
        end
    end
end)
math.random = real_random
print('PASS: ' .. checked .. ' offline groups. NOT online platform, real JSON, persistence, concurrency or RNG-quality certification.')
