local flag = {
    path = [[D:\War3Asset\Model\ShangqueDIY\tina\test\1.mdl]],
    converterExe = [[D:\War3\tools\war3mdlx.exe]], -- 仅处理 MDL 时需要
    mergeUnshadedNormals = true,
    dryRun = false,
}

-- Lua 5.3+；支持经典格式 Version 800 的 MDX / MDL。
-- lua 模型第5步_合并顶点.lua "模型.mdx" [--dry-run] [--keep-normals]
-- 按位置、所有 UV、有效骨骼组去重；受光/环境映射材质还必须法线相同。
-- 不减面、不抽动画帧、不跨 Geoset 合并；法线取合并组的第一个原始值。
-- MDX 直接处理并保留其他 chunk 原文；MDL 通过转换器重建文本。
-- 有实际变化才备份为 原路径.bak.时间戳，再替换；无收益时不改文件。

local pack, unpack = string.pack, string.unpack
assert(pack and unpack, "Lua 5.3+ required")

local function u32(data, pos)
    assert(pos >= 1 and pos + 3 <= #data, "Truncated uint32")
    return (unpack("<I4", data, pos))
end

local function parseChunks(data)
    assert(data:sub(1, 4) == "MDLX", "Not an MDX file")
    local chunks, byTag, pos = {}, {}, 5
    while pos <= #data do
        assert(pos + 7 <= #data, "Truncated chunk header")
        local tag, size = data:sub(pos, pos + 3), u32(data, pos + 4)
        assert(pos + 7 + size <= #data, "Truncated chunk: " .. tag)
        local chunk = {tag = tag, data = data:sub(pos + 8, pos + 7 + size)}
        chunks[#chunks + 1] = chunk
        if tag == "VERS" or tag == "GEOS" or tag == "MTLS" then
            assert(not byTag[tag], "Repeated chunk: " .. tag)
            byTag[tag] = chunk
        end
        pos = pos + 8 + size
    end
    assert(byTag.VERS and #byTag.VERS.data == 4 and u32(byTag.VERS.data, 1) == 800,
        "Only classic MDX Version 800 is supported; input was not changed")
    assert(byTag.GEOS and byTag.MTLS, "Missing GEOS/MTLS")
    return chunks, byTag
end

local function encodeChunks(chunks)
    local out = {"MDLX"}
    for _, chunk in ipairs(chunks) do
        out[#out + 1] = chunk.tag .. pack("<I4", #chunk.data) .. chunk.data
    end
    return table.concat(out)
end

local function materialModes(data)
    local modes, pos = {}, 1
    while pos <= #data do
        local size = u32(data, pos)
        local ending = pos + size
        assert(size >= 20 and ending <= #data + 1, "Invalid material size")
        assert(data:sub(pos + 12, pos + 15) == "LAYS", "Unknown material layout")
        local count, cursor = u32(data, pos + 16), pos + 20
        local eligible = count > 0
        for _ = 1, count do
            local layerSize = u32(data, cursor)
            assert(layerSize >= 28 and cursor + layerSize <= ending, "Invalid layer size")
            local flags = u32(data, cursor + 8)
            -- Unshaded=0x1；SphereEnvMap=0x2。每一层都必须满足条件。
            eligible = eligible and (flags & 1) ~= 0 and (flags & 2) == 0
            cursor = cursor + layerSize
        end
        assert(cursor == ending, "Unknown material extension")
        modes[#modes + 1] = eligible
        pos = ending
    end
    return modes
end

local arrayLayout = {{"VRTX", 12}, {"NRMS", 12}, {"PTYP", 4}, {"PCNT", 4},
    {"PVTX", 2}, {"GNDX", 1}, {"MTGC", 4}, {"MATS", 4}}

local function parseGeosets(data)
    local sets, pos = {}, 1
    while pos <= #data do
        local size = u32(data, pos)
        local ending = pos + size
        assert(size >= 4 and ending <= #data + 1, "Invalid geoset size")
        local cursor, arrays = pos + 4, {}
        local function array(tag, stride)
            assert(cursor + 7 < ending and data:sub(cursor, cursor + 3) == tag, "Missing " .. tag)
            local count = u32(data, cursor + 4)
            cursor = cursor + 8
            assert(count <= (ending - cursor) // stride, "Truncated " .. tag)
            local rows = {}
            for i = 1, count do rows[i] = data:sub(cursor + (i-1)*stride, cursor + i*stride - 1) end
            cursor = cursor + count*stride
            return rows
        end
        for _, entry in ipairs(arrayLayout) do arrays[entry[1]] = array(entry[1], entry[2]) end
        local tailStart = cursor
        assert(cursor + 43 < ending, "Truncated geoset metadata")
        local material = u32(data, cursor)
        cursor = cursor + 40
        local extentCount = u32(data, cursor)
        cursor = cursor + 4
        assert(extentCount <= (ending - cursor) // 28, "Truncated sequence extents")
        cursor = cursor + extentCount*28
        local tail = data:sub(tailStart, cursor - 1)
        assert(cursor + 7 < ending and data:sub(cursor, cursor + 3) == "UVAS", "Missing UVAS")
        local uvCount = u32(data, cursor + 4)
        cursor = cursor + 8
        assert(uvCount <= (ending - cursor) // 8, "Invalid UV count")
        local uv = {}
        for i = 1, uvCount do uv[i] = array("UVBS", 8) end
        assert(cursor == ending, "Unknown geoset extension; input was not changed")
        sets[#sets + 1] = {arrays = arrays, tail = tail, uv = uv, material = material}
        pos = ending
    end
    return sets
end

local function encodeGeosets(sets)
    local out = {}
    local function array(tag, rows)
        return tag .. pack("<I4", #rows) .. table.concat(rows)
    end
    for _, set in ipairs(sets) do
        local parts = {}
        for _, entry in ipairs(arrayLayout) do parts[#parts + 1] = array(entry[1], set.arrays[entry[1]]) end
        parts[#parts + 1] = set.tail .. "UVAS" .. pack("<I4", #set.uv)
        for _, uv in ipairs(set.uv) do parts[#parts + 1] = array("UVBS", uv) end
        local body = table.concat(parts)
        out[#out + 1] = pack("<I4", #body + 4) .. body
    end
    return table.concat(out)
end

local function validateSet(set)
    local a, count = set.arrays, #set.arrays.VRTX
    assert(#a.NRMS == count and #a.GNDX == count, "Vertex/normal/group count mismatch")
    assert(count <= 65536, "Vertex count exceeds 16-bit index range")
    for _, uv in ipairs(set.uv) do assert(#uv == count, "UV count mismatch") end
    assert(#a.PTYP == #a.PCNT, "Primitive count mismatch")
    local faceCount = 0
    for i, row in ipairs(a.PTYP) do
        assert(u32(row, 1) == 4, "Only triangle primitives are supported")
        local n = u32(a.PCNT[i], 1)
        assert(n % 3 == 0, "Incomplete triangle")
        faceCount = faceCount + n
    end
    assert(faceCount == #a.PVTX, "Face index count mismatch")
    for _, index in ipairs(a.PVTX) do assert(unpack("<I2", index) < count, "Invalid face vertex index") end
    local groups, cursor = {}, 1
    for _, row in ipairs(a.MTGC) do
        local n, ids = u32(row, 1), {}
        assert(n <= #a.MATS - cursor + 1, "Invalid matrix group size")
        for i = 1, n do ids[i] = u32(a.MATS[cursor], 1); cursor = cursor + 1 end
        table.sort(ids)
        local key = {pack("<I4", n)}
        for _, id in ipairs(ids) do key[#key + 1] = pack("<I4", id) end
        groups[#groups + 1] = table.concat(key)
    end
    assert(cursor == #a.MATS + 1, "Matrix group count mismatch")
    local weights = {}
    for i, row in ipairs(a.GNDX) do weights[i] = assert(groups[row:byte() + 1], "Invalid vertex matrix group") end
    return weights
end

local function optimizeMdx(data, mergeUnshadedNormals)
    local chunks, byTag = parseChunks(data)
    local modes = materialModes(byTag.MTLS.data)
    local original = parseGeosets(byTag.GEOS.data)
    local optimized, report = {}, {before = #data, verticesBefore = 0, verticesAfter = 0, triangles = 0, geosets = {}}
    for index, old in ipairs(original) do
        local weights = validateSet(old)
        assert(old.material < #modes, "Invalid material id")
        local ignoreNormals = mergeUnshadedNormals and modes[old.material + 1]
        local a, kept, mapping, seen = old.arrays, {}, {}, {}
        for i = 1, #a.VRTX do
            local parts = {a.VRTX[i]}
            for _, uv in ipairs(old.uv) do parts[#parts + 1] = uv[i] end
            parts[#parts + 1] = weights[i]
            if not ignoreNormals then parts[#parts + 1] = a.NRMS[i] end
            local key = table.concat(parts)
            local target = seen[key]
            if not target then
                kept[#kept + 1] = i
                target = #kept
                seen[key] = target
            end
            mapping[i] = target
        end
        local arrays, uv = {}, {}
        for tag, rows in pairs(a) do arrays[tag] = rows end
        for _, tag in ipairs({"VRTX", "NRMS", "GNDX"}) do
            arrays[tag] = {}
            for j, source in ipairs(kept) do arrays[tag][j] = a[tag][source] end
        end
        arrays.PVTX = {}
        for j, row in ipairs(a.PVTX) do arrays.PVTX[j] = pack("<I2", mapping[unpack("<I2", row) + 1] - 1) end
        for layer, rows in ipairs(old.uv) do
            uv[layer] = {}
            for j, source in ipairs(kept) do uv[layer][j] = rows[source] end
        end
        optimized[index] = {arrays = arrays, uv = uv, tail = old.tail, material = old.material}
        local r = {before = #a.VRTX, after = #kept, ignoreNormals = not not ignoreNormals, triangles = #a.PVTX // 3}
        report.geosets[index] = r
        report.verticesBefore = report.verticesBefore + r.before
        report.verticesAfter = report.verticesAfter + r.after
        report.triangles = report.triangles + r.triangles
    end
    byTag.GEOS.data = encodeGeosets(optimized)
    local output = encodeChunks(chunks)
    local _, outputChunks = parseChunks(output)
    local checked = parseGeosets(outputChunks.GEOS.data)
    -- 重新解析实际输出，逐个面角校验位置、所有 UV 和有效骨骼组。
    for index, old in ipairs(original) do
        local new, r = checked[index], report.geosets[index]
        local oldWeights, newWeights = validateSet(old), validateSet(new)
        assert(old.tail == new.tail and #old.uv == #new.uv, "Geoset metadata changed")
        for _, tag in ipairs({"PTYP", "PCNT", "MTGC", "MATS"}) do
            assert(table.concat(old.arrays[tag]) == table.concat(new.arrays[tag]), "Topology/skin groups changed")
        end
        assert(#old.arrays.PVTX == #new.arrays.PVTX, "Face count changed")
        for j, row in ipairs(old.arrays.PVTX) do
            local a = unpack("<I2", row) + 1
            local b = unpack("<I2", new.arrays.PVTX[j]) + 1
            assert(old.arrays.VRTX[a] == new.arrays.VRTX[b] and oldWeights[a] == newWeights[b], "Position/skin changed")
            for layer, uv in ipairs(old.uv) do assert(uv[a] == new.uv[layer][b], "UV changed") end
            if not r.ignoreNormals then assert(old.arrays.NRMS[a] == new.arrays.NRMS[b], "Normal changed") end
        end
    end
    -- 所有非 GEOS chunk 必须逐字一致，包含动画、材质、附加点和碰撞。
    local inputChunks = parseChunks(data)
    local finalChunks = parseChunks(output)
    assert(#inputChunks == #finalChunks)
    for i, chunk in ipairs(inputChunks) do
        assert(chunk.tag == finalChunks[i].tag)
        if chunk.tag ~= "GEOS" then assert(chunk.data == finalChunks[i].data, "Non-geoset chunk changed") end
    end
    report.after = #output
    return output, report
end

-- MDL 的文本转换器会把浮点 -0 写成 0。只在已识别的节点动画浮点字段
-- 中允许这一数值等价变化；帧时间、ID、标志、名称等仍必须逐字一致。
local function normalizeNodeSignedZeros(data, isBone)
    local edits, pos = {}, 1
    local dimensions = {KGTR = 3, KGRT = 4, KGSC = 3}
    while pos <= #data do
        local size = u32(data, pos)
        local ending = pos + size
        assert(size >= 96 and ending <= #data + 1, "Invalid node size in MDL verification")
        local cursor = pos + 96
        while cursor < ending do
            assert(cursor + 15 < ending, "Truncated animation track")
            local tag = data:sub(cursor, cursor + 3)
            local dimension = assert(dimensions[tag], "Unknown node track in MDL verification: " .. tag)
            local count, interpolation = u32(data, cursor + 4), u32(data, cursor + 8)
            assert(interpolation <= 3, "Invalid interpolation mode")
            local floats = dimension * (interpolation >= 2 and 3 or 1)
            local stride = 4 + floats * 4
            cursor = cursor + 16
            assert(count <= (ending - cursor) // stride, "Truncated animation keys")
            for _ = 1, count do
                -- 每行开头的 uint32 时间戳不能按浮点解释。
                for offset = cursor + 4, cursor + stride - 1, 4 do
                    if data:sub(offset, offset + 3) == "\0\0\0\128" then edits[#edits + 1] = offset end
                end
                cursor = cursor + stride
            end
        end
        assert(cursor == ending, "Invalid node track layout")
        pos = ending + (isBone and 8 or 0)
        assert(pos <= #data + 1, "Truncated bone metadata")
    end
    local parts, cursor = {}, 1
    for _, offset in ipairs(edits) do
        parts[#parts + 1] = data:sub(cursor, offset - 1)
        parts[#parts + 1] = "\0\0\0\0"
        cursor = offset + 4
    end
    parts[#parts + 1] = data:sub(cursor)
    return table.concat(parts)
end

local function assertMdlRoundTrip(expected, actual)
    if expected == actual then return false end
    local before, after = parseChunks(expected), parseChunks(actual)
    assert(#before == #after, "MDL round-trip changed chunk count; input was not changed")
    local signedZeroChanged = false
    for i, chunk in ipairs(before) do
        local other = after[i]
        assert(chunk.tag == other.tag, "MDL round-trip changed chunk order; input was not changed")
        if chunk.data ~= other.data then
            local valid = false
            if chunk.tag == "BONE" or chunk.tag == "HELP" then
                valid = normalizeNodeSignedZeros(chunk.data, chunk.tag == "BONE") ==
                    normalizeNodeSignedZeros(other.data, chunk.tag == "BONE")
            end
            assert(valid, "MDL round-trip changed " .. chunk.tag .. " data beyond animation signed zero; input was not changed")
            signedZeroChanged = true
        end
    end
    return signedZeroChanged
end

local function exists(path)
    local file = io.open(path, "rb")
    if not file then return false end
    file:close()
    return true
end

local function readAll(path)
    local file = assert(io.open(path, "rb"))
    local data = assert(file:read("*a"))
    assert(file:close())
    return data
end

local function writeAll(path, data)
    local file = assert(io.open(path, "wb"))
    assert(file:write(data)); assert(file:close())
    assert(readAll(path) == data, "Written file verification failed: " .. path)
end

local function uniquePath(path)
    local candidate, i = path, 0
    while exists(candidate) do i = i + 1; candidate = path .. "." .. i end
    return candidate
end

local function replaceWithBackup(path, original, output)
    local temporary = uniquePath(path .. ".tmp")
    writeAll(temporary, output)
    assert(readAll(path) == original, "Input changed while processing; temporary output kept")
    local backup = uniquePath(path .. ".bak." .. os.date("%Y%m%d_%H%M%S"))
    assert(os.rename(path, backup))
    local ok, err = os.rename(temporary, path)
    if not ok then
        local restored, restoreError = os.rename(backup, path)
        error("Cannot install output: " .. tostring(err) .. "; rollback=" .. tostring(restored) .. "; " .. tostring(restoreError) ..
            "; backup: " .. backup .. "; temporary output: " .. temporary)
    end
    assert(readAll(path) == output, "Installed file verification failed; backup: " .. backup)
    print("Backup: " .. backup)
end

local function convert(exe, source, target)
    assert(exists(exe), "Converter not found: " .. exe)
    local function quote(value)
        -- CMD 在引号内仍会展开 %VAR%；拒绝这类路径以免执行错误的命令。
        assert(not value:find('["\r\n%%!]'), "Unsupported shell character in converter path")
        if package.config:sub(1, 1) == "\\" then return '"' .. value .. '"' end
        return "'" .. value:gsub("'", "'\\''") .. "'"
    end
    -- float32 最小值为 2^-149；保留完整小数，避免极小的动画/轴心值往返后归零。
    -- 转换器会去掉尾随零，普通数值不会固定输出 149 位小数。
    local command = quote(exe) .. " -f -p 149 " .. quote(source) .. " " .. quote(target)
    if package.config:sub(1, 1) == "\\" then command = '"' .. command .. '"' end
    local ok, _, code = os.execute(command)
    assert(ok == true and code == 0 and exists(target), "Model conversion failed")
end

-- 1..9 位有效数字中选出可还原相同 float32 的短表示；验证的是位模式，
-- 不是按小数位截断。149 位转换结果只作为临时的精确输入，不直接写回。
local function shortestFloat32(value)
    local bits = pack("<f", value)
    value = unpack("<f", bits)
    assert(value == value and math.abs(value) < math.huge, "Cannot compact a non-finite float32")
    if value == 0 then return bits == "\0\0\0\128" and "-0.0" or "0" end
    local function normalizeExponent(text)
        local mantissa, exponent = text:match("^(.-)[eE]([%+%-]?%d+)$")
        if mantissa then
            mantissa = mantissa:gsub("(%..-)0+$", "%1"):gsub("%.$", "")
            return mantissa .. "e" .. tostring(tonumber(exponent))
        end
        return text
    end
    for digits = 1, 9 do
        local candidate = normalizeExponent(string.format("%." .. digits .. "g", value))
        local ok, restored = pcall(pack, "<f", tonumber(candidate))
        if ok and restored == bits then
            local scientific = normalizeExponent(string.format("%." .. (digits - 1) .. "e", value))
            if #scientific < #candidate and pack("<f", tonumber(scientific)) == bits then candidate = scientific end
            return candidate
        end
    end
    error("Cannot create a round-trippable float32 decimal")
end

local function compactMdlNumbers(text)
    local pos, cursor, parts, cache = 1, 1, {}, {}
    while pos <= #text do
        local c, two = text:sub(pos, pos), text:sub(pos, pos + 1)
        if c:match("%s") then
            pos = text:find("%S", pos) or (#text + 1)
        elseif two == "//" then
            pos = text:find("[\r\n]", pos + 2) or (#text + 1)
        elseif two == "/*" then
            pos = assert(text:find("*/", pos + 2, true), "Unclosed MDL comment") + 2
        elseif c == '"' then
            pos = pos + 1
            while pos <= #text and text:sub(pos, pos) ~= '"' do
                if text:sub(pos, pos) == "\\" then pos = pos + 1 end
                pos = pos + 1
            end
            assert(pos <= #text, "Unclosed MDL string")
            pos = pos + 1
        elseif c:match("[%a_]") then
            local _, ending = text:find("[%a_][%w_]*", pos)
            pos = ending + 1
        elseif c:match("[%d%+%-%.]") then
            local pattern = "[%+%-]?%d+%.?%d*[eE]?[%+%-]?%d*"
            if c == "." or ((c == "-" or c == "+") and text:sub(pos + 1, pos + 1) == ".") then
                pattern = "[%+%-]?%.%d+[eE]?[%+%-]?%d*"
            end
            local first, last = text:find(pattern, pos)
            assert(first == pos, "Invalid MDL number at byte " .. pos)
            local raw = text:sub(first, last)
            -- 整数形式的 ID、帧时间、标志等不参与浮点格式化。
            if raw:find("[%.eE]") then
                local value = assert(tonumber(raw), "Invalid MDL number")
                local bits = pack("<f", value)
                local compact = cache[bits]
                if not compact then compact = shortestFloat32(value); cache[bits] = compact end
                if compact ~= raw then
                    parts[#parts + 1] = text:sub(cursor, first - 1)
                    parts[#parts + 1] = compact
                    cursor = last + 1
                end
            end
            pos = last + 1
        else
            pos = pos + 1
        end
    end
    parts[#parts + 1] = text:sub(cursor)
    return table.concat(parts)
end

local function processFile(path, options)
    local extension = path:lower():match("%.(md[xl])$")
    assert(extension, "Input must be .mdx or .mdl")
    local original = readAll(path)
    local temporaryFiles = {}
    local function temporary(suffix)
        local stem = path .. ".weld." .. os.date("%Y%m%d_%H%M%S")
        local name, index = stem .. suffix, 0
        while exists(name) do index = index + 1; name = stem .. "." .. index .. suffix end
        temporaryFiles[#temporaryFiles + 1] = name
        return name
    end
    local function run()
        local source = original
        if extension == "mdl" then
            -- 转换的是副本，避免转换器意外触碰输入文件。
            local mdl, mdx = temporary(".input.mdl"), temporary(".input.mdx")
            writeAll(mdl, original)
            convert(options.converterExe, mdl, mdx)
            source = readAll(mdx)
        end
        local output, report = optimizeMdx(source, options.mergeUnshadedNormals)
        for i, r in ipairs(report.geosets) do
            print(string.format("Geoset %d: %d -> %d vertices; %s", i, r.before, r.after,
                r.ignoreNormals and "merge normal splits (Unshaded)" or "preserve normals"))
        end
        print(string.format("MDX: %d -> %d bytes; vertices: %d -> %d; triangles: %d",
            report.before, report.after, report.verticesBefore, report.verticesAfter, report.triangles))
        if extension == "mdl" then
            local expectedMdx = output
            local mdl = temporary(".output.mdl")
            if output == source then
                -- 已经合并过的模型也可缩短过长小数，不再重新导出其他文本。
                output = compactMdlNumbers(original)
            else
                local mdx = temporary(".output.mdx")
                writeAll(mdx, output)
                convert(options.converterExe, mdx, mdl)
                output = compactMdlNumbers(readAll(mdl))
            end
            report.mdlBefore, report.mdlAfter = #original, #output
            print(string.format("MDL text: %d -> %d bytes (round-trippable float32 decimals)", #original, #output))
            if output == original then print("No changes: " .. path); return report end
            writeAll(mdl, output)
            local verified = temporary(".verify.mdx")
            convert(options.converterExe, mdl, verified)
            if assertMdlRoundTrip(expectedMdx, readAll(verified)) then
                print("MDL round-trip: animation -0 / 0 differences only (numerically identical)")
            end
        end
        if output == source then print("No changes: " .. path); return report end
        if options.dryRun then print("Dry run: input was not changed"); return report end
        replaceWithBackup(path, original, output)
        print("Optimized: " .. path)
        return report
    end
    local ok, result = pcall(run)
    for _, file in ipairs(temporaryFiles) do os.remove(file) end
    assert(ok, result)
    return result
end

-- 供离线回归测试调用；正常直接运行时不会进入此分支。
if ... == "model.vertex_weld" then
    return {optimizeMdx = optimizeMdx, processFile = processFile, assertMdlRoundTrip = assertMdlRoundTrip,
        shortestFloat32 = shortestFloat32, compactMdlNumbers = compactMdlNumbers}
end

local path = flag.path
for _, value in ipairs(arg or {}) do
    if value == "--dry-run" then flag.dryRun = true
    elseif value == "--keep-normals" then flag.mergeUnshadedNormals = false
    elseif value == "--help" then
        print('lua 模型第5步_合并顶点.lua "模型.mdx|模型.mdl" [--dry-run] [--keep-normals]')
        return
    elseif value:sub(1, 2) == "--" then error("Unknown option: " .. value)
    else path = value end
end
processFile(path, flag)
