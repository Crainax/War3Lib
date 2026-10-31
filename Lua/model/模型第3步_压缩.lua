local flag = {
    path = [[D:\War3Asset\Model\ShangqueDIY\lingmeng3\test\1.mdl]],
    keyframeEpsilon = 1e-5, -- DontInterp 各分量误差上限；0 表示只合并完全相同的帧
}

-- 也可运行：lua 模型第3步_压缩.lua "完整路径.mdl" [--epsilon 1e-5]
-- 缩短小数文本不会缩小 MDX 的浮点字段，因此默认保留原数值。
local NORMALIZE_NUMBERS = false
local EPS = 1e-5
local OUTPUT_PREC = 9

local function normalizeNumber(n)
    if math.abs(n) < EPS then return "0" end
    return (string.format("%." .. OUTPUT_PREC .. "f", n):gsub("0+$", ""):gsub("%.$", ""))
end

local function readFile(path)
    local file, err = io.open(path, "rb")
    assert(file, "Cannot read " .. path .. ": " .. tostring(err))
    local data = assert(file:read("*a"))
    assert(file:close())
    return data
end

local function exists(path)
    local file = io.open(path, "rb")
    if not file then return false end
    file:close()
    return true
end

local function uniquePath(path)
    local candidate, index = path, 0
    while exists(candidate) do
        index = index + 1
        candidate = path .. "." .. index
    end
    return candidate
end

-- 词法分析时跳过注释、正确识别字符串；Lua 模式不支持正则的 | 分支。
-- 保留每个 token 的原文位置，只改目标轨道，其他内容逐字保留。
local function tokenize(text)
    local tokens, pos = {}, 1
    if text:sub(1, 3) == "\239\187\191" then pos = 4 end
    while pos <= #text do
        local c, two = text:sub(pos, pos), text:sub(pos, pos + 1)
        local first, last, kind = pos, pos, nil
        if c:match("%s") then
            pos = text:find("%S", pos) or (#text + 1)
        elseif two == "//" then
            pos = text:find("[\r\n]", pos + 2) or (#text + 1)
        elseif two == "/*" then
            local ending = assert(text:find("*/", pos + 2, true), "Unclosed comment")
            pos = ending + 2
        elseif c == '"' then
            last = pos + 1
            while last <= #text and text:sub(last, last) ~= '"' do
                if text:sub(last, last) == "\\" then last = last + 1 end
                last = last + 1
            end
            assert(last <= #text, "Unclosed string")
            kind, pos = "string", last + 1
        elseif c:match("[%a_]") then
            first, last = text:find("[%a_][%w_]*", pos)
            kind, pos = "word", last + 1
        elseif c:match("[%d%+%-%.]") then
            local pattern = "[%+%-]?%d+%.?%d*[eE]?[%+%-]?%d*"
            if c == "." or ((c == "-" or c == "+") and text:sub(pos + 1, pos + 1) == ".") then
                pattern = "[%+%-]?%.%d+[eE]?[%+%-]?%d*"
            end
            first, last = text:find(pattern, pos)
            assert(first == pos, "Invalid number at byte " .. pos)
            kind, pos = "number", last + 1
        elseif c:match("[{},:]") then
            kind, pos = c, pos + 1
        else
            error("Unexpected character at byte " .. pos)
        end
        if kind then
            local raw = text:sub(first, last)
            local token = {kind = kind, raw = raw, first = first, last = last}
            if kind == "number" then
                token.value = assert(tonumber(raw), "Invalid number: " .. raw)
                assert(token.value == token.value and math.abs(token.value) < math.huge, "Non-finite number")
            end
            tokens[#tokens + 1] = token
        end
    end
    return tokens
end

local function parseBlocks(tokens)
    local root = {children = {}, name = "ROOT"}
    local current, blocks = root, {}
    for index, token in ipairs(tokens) do
        if token.kind == "{" then
            local before, nameToken = tokens[index - 1], nil
            if before and before.kind == "word" then
                nameToken = before
            elseif before and (before.kind == "number" or before.kind == "string") then
                local previous = tokens[index - 2]
                if previous and previous.kind == "word" then nameToken = previous end
            end
            local block = {open = index, children = {}, parent = current,
                name = nameToken and nameToken.raw, nameToken = nameToken}
            current.children[#current.children + 1] = block
            blocks[#blocks + 1] = block
            current = block
        elseif token.kind == "}" then
            assert(current ~= root, "Unmatched closing brace")
            current.close = index
            current = current.parent
        end
    end
    assert(current == root, "Unclosed block")
    return blocks
end

local function vector(tokens, block)
    local values, numbers = {}, {}
    for i = block.open + 1, block.close - 1 do
        local token = tokens[i]
        assert(token.kind == "number" or token.kind == ",", "Malformed vector")
        if token.kind == "number" then
            values[#values + 1] = token.value
            numbers[#numbers + 1] = token
        end
    end
    return values, numbers
end

local function equal(a, b, epsilon)
    epsilon = epsilon or 0
    if #a ~= #b then return false end
    for i = 1, #a do
        if math.abs(a[i] - b[i]) > epsilon then return false end
    end
    return true
end

-- 若语句独占一行，连同缩进和换行删除；同一行的其他语句保持不变。
local function statementRange(text, first, last)
    local start = first
    while start > 1 and text:sub(start - 1, start - 1):match("[ \t\r]") do start = start - 1 end
    if start ~= 1 and text:sub(start - 1, start - 1) ~= "\n" then start = first end
    local ending = last + 1
    while ending <= #text and text:sub(ending, ending):match("[ \t\r]") do ending = ending + 1 end
    if text:sub(ending, ending) == "\n" then last = ending end
    return start, last
end

local function optimizeText(text, epsilon)
    local tokens = tokenize(text)
    local blocks = parseBlocks(tokens)
    local intervals, edits = {}, {}
    local stats = {tracks = 0, defaultTracksRemoved = 0, keysRemoved = 0, numericValues = 0}
    for _, block in ipairs(blocks) do
        if block.name == "Interval" and block.parent.name == "Anim" and block.parent.parent.name == "Sequences" then
            local values = vector(tokens, block)
            assert(#values == 2 and values[1] <= values[2], "Invalid animation interval")
            intervals[#intervals + 1] = values
        end
    end
    local function addEdit(first, last, replacement)
        edits[#edits + 1] = {first = first, last = last, text = replacement}
    end
    local function removeStatement(first, last)
        first, last = statementRange(text, first, last)
        addEdit(first, last, "")
    end
    local dimensions = {Translation = 3, Rotation = 4, Scaling = 3}
    local owners = {Bone = true, Helper = true, Attachment = true, Light = true,
        ParticleEmitter = true, ParticleEmitter2 = true, RibbonEmitter = true,
        Camera = true, Target = true, TextureAnim = true}
    for _, block in ipairs(blocks) do
        local dimension = dimensions[block.name]
        local countToken = tokens[block.open - 1]
        if dimension and owners[block.parent.name] and countToken.kind == "number" then
            stats.tracks = stats.tracks + 1
            local rows, interpolation, globalSequence = {}, nil, false
            local depth = 0
            for i = block.open + 1, block.close - 1 do
                local token = tokens[i]
                if token.kind == "{" then depth = depth + 1 end
                if depth == 0 then
                    if token.raw == "DontInterp" or token.raw == "Linear" or token.raw == "Hermite" or token.raw == "Bezier" then
                        assert(not interpolation, "Repeated interpolation mode")
                        interpolation = token.raw
                    elseif token.raw == "GlobalSeqId" then
                        globalSequence = true
                    end
                end
                if token.kind == "}" then depth = depth - 1 end
            end
            for _, child in ipairs(block.children) do
                local colon, timeToken = tokens[child.open - 1], tokens[child.open - 2]
                if colon and colon.kind == ":" and timeToken and timeToken.kind == "number" then
                    local values, numbers = vector(tokens, child)
                    assert(#values == dimension, "Incorrect vector dimension in " .. block.name)
                    assert(timeToken.value >= 0 and timeToken.value % 1 == 0, "Invalid keyframe time")
                    assert(#rows == 0 or rows[#rows].time <= timeToken.value, "Unsorted keyframes")
                    local last = tokens[child.close].last
                    if tokens[child.close + 1] and tokens[child.close + 1].kind == "," then
                        last = tokens[child.close + 1].last
                    end
                    rows[#rows + 1] = {values = values, numbers = numbers, time = timeToken.value,
                        first = timeToken.first, last = last}
                end
            end
            assert(countToken.value == #rows, "Incorrect keyframe count in " .. block.name)
            assert(interpolation, "Missing interpolation mode in " .. block.name)
            -- 切线会改变曲线：Hermite/Bezier 不能只比较关键帧数值。
            if not globalSequence and (interpolation == "DontInterp" or interpolation == "Linear") then
                local default = block.name == "Scaling" and {1, 1, 1} or
                    (block.name == "Translation" and {0, 0, 0} or nil)
                local isDefault = default ~= nil and #rows > 0
                for _, row in ipairs(rows) do
                    if not default or not equal(row.values, default) then isDefault = false end
                end
                if isDefault then
                    removeStatement(block.nameToken.first, tokens[block.close].last)
                    stats.defaultTracksRemoved = stats.defaultTracksRemoved + 1
                    stats.keysRemoved = stats.keysRemoved + #rows
                else
                    local firstBySequence, lastBySequence = {}, {}
                    for index, row in ipairs(rows) do
                        local sequence, matches = 0, 0
                        for j, interval in ipairs(intervals) do
                            if row.time >= interval[1] and row.time <= interval[2] then
                                sequence, matches = j, matches + 1
                            end
                        end
                        -- 无动作信息、区间外或重叠区间的帧一律保留。
                        row.sequence = matches == 1 and sequence or 0
                        if row.sequence ~= 0 then
                            firstBySequence[row.sequence] = firstBySequence[row.sequence] or index
                            lastBySequence[row.sequence] = index
                        end
                    end
                    local kept, previous = 0, nil
                    for index, row in ipairs(rows) do
                        local protected = row.sequence == 0 or firstBySequence[row.sequence] == index or lastBySequence[row.sequence] == index
                        local remove = false
                        if not protected and previous and previous.sequence == row.sequence then
                            if interpolation == "DontInterp" then
                                -- 始终与上一条保留帧比较，避免逐帧误差累积。
                                remove = equal(previous.values, row.values, epsilon)
                            else
                                -- Linear 只移除平坦段内部帧，保留转折前的平台终点。
                                local following = rows[index + 1]
                                remove = following and following.sequence == row.sequence and
                                    equal(previous.values, row.values) and equal(row.values, following.values)
                            end
                        end
                        if remove then
                            removeStatement(row.first, row.last)
                            stats.keysRemoved = stats.keysRemoved + 1
                        else
                            kept, previous = kept + 1, row
                            if NORMALIZE_NUMBERS then
                                for _, number in ipairs(row.numbers) do
                                    local normalized = normalizeNumber(number.value)
                                    if normalized ~= number.raw then
                                        addEdit(number.first, number.last, normalized)
                                        stats.numericValues = stats.numericValues + 1
                                    end
                                end
                            end
                        end
                    end
                    if kept ~= #rows then addEdit(countToken.first, countToken.last, tostring(kept)) end
                end
            end
        end
    end
    table.sort(edits, function(a, b) return a.first < b.first end)
    local parts, cursor = {}, 1
    for _, edit in ipairs(edits) do
        assert(edit.first >= cursor, "Overlapping edits; original file was not changed")
        parts[#parts + 1] = text:sub(cursor, edit.first - 1)
        parts[#parts + 1] = edit.text
        cursor = edit.last + 1
    end
    parts[#parts + 1] = text:sub(cursor)
    return table.concat(parts), stats
end

local function processText(original, options)
    local epsilon = options and options.keyframeEpsilon or flag.keyframeEpsilon
    assert(type(epsilon) == "number" and epsilon >= 0 and epsilon < math.huge,
        "keyframeEpsilon must be a finite non-negative number")
    local optimized, stats = optimizeText(original, epsilon)
    -- 可选数值归一化可能产生新的相同帧；收敛后再写回，重复执行保持稳定。
    local stable = false
    for _ = 1, 3 do
        collectgarbage("collect")
        local nextPass, nextStats = optimizeText(optimized, epsilon)
        if nextPass == optimized then
            stable = true
            break
        end
        optimized = nextPass
        stats.defaultTracksRemoved = stats.defaultTracksRemoved + nextStats.defaultTracksRemoved
        stats.keysRemoved = stats.keysRemoved + nextStats.keysRemoved
        stats.numericValues = stats.numericValues + nextStats.numericValues
    end
    assert(stable, "Optimization did not converge; original file was not changed")
    stats.epsilon = epsilon
    return optimized, stats
end

local function optimizeFile(path)
    assert(path:lower():match("%.mdl$"), "Input must be a text .mdl file")
    local original = readFile(path)
    local optimized, stats = processText(original)
    print(string.format("Tracks: %d; default tracks removed: %d; keys removed: %d; numbers normalized: %d; epsilon: %g",
        stats.tracks, stats.defaultTracksRemoved, stats.keysRemoved, stats.numericValues, flag.keyframeEpsilon))
    if optimized == original then
        print("No changes: " .. path)
        return
    end
    local temporary = uniquePath(path .. ".tmp")
    local file = assert(io.open(temporary, "wb"))
    assert(file:write(optimized))
    assert(file:close())
    assert(readFile(temporary) == optimized, "Temporary file verification failed")
    assert(readFile(path) == original, "Input changed while processing; temporary output kept")
    local backup = uniquePath(path .. ".bak." .. os.date("%Y%m%d_%H%M%S"))
    local moved, moveError = os.rename(path, backup)
    assert(moved, "Cannot back up input; temporary output kept: " .. tostring(moveError))
    local replaced, replaceError = os.rename(temporary, path)
    if not replaced then
        local restored, restoreError = os.rename(backup, path)
        error("Cannot install output: " .. tostring(replaceError) .. "; rollback=" .. tostring(restored) ..
            "; " .. tostring(restoreError) .. "; temporary output: " .. temporary)
    end
    assert(readFile(path) == optimized, "Installed output verification failed; backup: " .. backup)
    print("Backup: " .. backup)
    print("Optimized: " .. path)
end

if ... == "model.compress" then return {processText = processText} end

local path, index = flag.path, 1
while arg and index <= #arg do
    local value = arg[index]
    if value == "--epsilon" then
        index = index + 1
        flag.keyframeEpsilon = assert(tonumber(arg[index]), "--epsilon requires a number")
    elseif value:match("^%-%-epsilon=") then
        flag.keyframeEpsilon = assert(tonumber(value:match("=(.*)$")), "--epsilon requires a number")
    elseif value == "--help" then
        print('lua 模型第3步_压缩.lua "模型.mdl" [--epsilon 1e-5]; --epsilon 0 preserves exact values')
        return
    elseif value:sub(1, 2) == "--" then error("Unknown option: " .. value)
    else path = value end
    index = index + 1
end
assert(type(flag.keyframeEpsilon) == "number" and flag.keyframeEpsilon >= 0 and flag.keyframeEpsilon < math.huge,
    "keyframeEpsilon must be a finite non-negative number")
optimizeFile(path)
