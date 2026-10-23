-- Pure business rules. IDs 1..39 are probe-only numeric attributes, NOT ItemData IDs.
local M = {}
M.prices = {[0] = 1, [1] = 3, [2] = 15, [3] = 50}

local function integer(n, lo, hi)
    return type(n) == 'number' and n == n and n % 1 == 0 and n >= lo and n <= hi
end
M.integer = integer

-- JSON decoders may return integral floats (3.0); receipt signatures must be canonical.
function M.numbers(values)
    local out = {}
    for i, value in ipairs(values) do out[i] = string.format('%.0f', value) end
    return table.concat(out, ',')
end

local function signature(tier, locks)
    return string.format('%.0f:', tier) .. M.numbers(locks)
end

local function dense(t, max)
    if type(t) ~= 'table' then return false end
    local count = 0
    for k in pairs(t) do
        if not integer(k, 1, max) then return false end
        count = count + 1
    end
    if count > max then return false end
    for i = 1, count do if t[i] == nil then return false end end
    return true
end

local function attrs(t, size, sorted)
    if not dense(t, size) or #t ~= size then return false end
    local seen = {}
    for i, n in ipairs(t) do
        if not integer(n, 1, 39) or seen[n] then return false end
        if sorted and i > 1 and t[i - 1] >= n then return false end
        seen[n] = true
    end
    return true
end

local function request_id(s)
    return type(s) == 'string' and #s >= 1 and #s <= 24 and s:match('^[A-Za-z0-9]+$') ~= nil
end

function M.parse(payload)
    if type(payload) ~= 'string' or #payload > 100 then return nil, 'BAD_REQUEST' end
    local id, tier, list = payload:match('^([A-Za-z0-9]+)|([0-3])|([0-9,]*)$')
    if not request_id(id) then return nil, 'BAD_REQUEST' end
    tier = tonumber(tier)
    local locks = {}
    if list ~= '' then
        for part in (list .. ','):gmatch('(.-),') do
            if not part:match('^[0-9]+$') or #part > 2 then return nil, 'BAD_LOCKS' end
            locks[#locks + 1] = tonumber(part)
        end
    end
    if not attrs(locks, tier, false) then return nil, 'BAD_LOCKS' end
    table.sort(locks)
    return {id = id, tier = tier, locks = locks, signature = signature(tier, locks)}
end

function M.empty()
    return {version = 1, spent = 0, stones = {}}
end

function M.validate(state, cfg)
    if type(state) ~= 'table' or state.version ~= 1 or
       not integer(state.spent, 0, cfg.max_total) or not dense(state.stones, cfg.max_stones) then
        return false
    end
    local sum, ids = 0, {}
    for i, stone in ipairs(state.stones) do
        if type(stone) ~= 'table' or stone.serial ~= i or not request_id(stone.request) or ids[stone.request] or
           not integer(stone.tier, 0, 3) or stone.cost ~= M.prices[stone.tier] or
           not attrs(stone.locks, stone.tier, true) or not attrs(stone.attrs, 7, false) then return false end
        local found = {}
        for _, n in ipairs(stone.attrs) do found[n] = true end
        for _, n in ipairs(stone.locks) do if not found[n] then return false end end
        ids[stone.request] = true
        sum = sum + stone.cost
    end
    return sum == state.spent
end

function M.find(state, id)
    for _, stone in ipairs(state.stones) do
        if stone.request == id then return stone end
    end
end

-- Caller passes an isolated candidate state; original archive must not be mutated before save.
function M.forge(state, request, total, cfg, random)
    local old = M.find(state, request.id)
    if old then
        if signature(old.tier, old.locks) ~= request.signature then return nil, 'REQUEST_CONFLICT' end
        return old, 'REPLAY'
    end
    if #state.stones >= cfg.max_stones then return nil, 'BAG_FULL' end
    local cost = M.prices[request.tier]
    if total - state.spent < cost then return nil, 'NO_ORE' end
    local selected, pool, seen = {}, {}, {}
    for _, n in ipairs(request.locks) do selected[#selected + 1] = n; seen[n] = true end
    for n = 1, 39 do if not seen[n] then pool[#pool + 1] = n end end
    while #selected < 7 do
        local pos = random(1, #pool)
        if not integer(pos, 1, #pool) then error('invalid server RNG result') end
        selected[#selected + 1] = pool[pos]
        pool[pos] = pool[#pool]
        pool[#pool] = nil
    end
    local stone = {serial = #state.stones + 1, request = request.id, tier = request.tier,
                   cost = cost, locks = request.locks, attrs = selected}
    state.spent = state.spent + cost
    state.stones[#state.stones + 1] = stone
    return stone, 'CREATED'
end
return M
