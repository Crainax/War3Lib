local flag = {
    path = [[D:\War3Asset\Model\ShangqueDIY\zhinai3\test\1.mdl]], -- 只填这一个模型路径
    converterExe = [[D:\War3\tools\war3mdlx.exe]],
    keyframeEpsilon = 1e-5,
    mergeUnshadedNormals = true,
}

-- Lua 5.3+；输入 MDL 或经典 Version 800 MDX，输出同名 MDL + MDX。
-- lua 一键处理模型.lua "完整模型路径.mdl" [--epsilon 1e-5] [--keep-normals]
-- 先备份已有的两种文件，再在临时副本中依次执行第3、4、5步。
-- 全部处理和往返校验成功才写回；处理中途失败不会改原模型。

local scriptPath = debug.getinfo(1, "S").source:sub(2)
local scriptDirectory = scriptPath:match("^(.*[/\\])") or "./"

local function readMaybe(path)
    local file, message, code = io.open(path, "rb")
    if not file then
        assert(code == 2, "Cannot read " .. path .. ": " .. tostring(message))
        return nil
    end
    local data = assert(file:read("*a"))
    assert(file:close())
    return data
end

local function readAll(path) return assert(readMaybe(path), "File not found: " .. path) end

local function writeAll(path, data)
    local file = assert(io.open(path, "wb"))
    assert(file:write(data)); assert(file:close())
    assert(readAll(path) == data, "Write verification failed: " .. path)
end

local function uniquePath(path)
    local candidate, index = path, 0
    while readMaybe(candidate) ~= nil do index = index + 1; candidate = path .. "." .. index end
    return candidate
end

local function loadStep(number, filename, moduleName)
    local path = scriptDirectory .. filename
    local probe = io.open(path, "rb")
    local source
    if probe then source = assert(probe:read("*a")); assert(probe:close()) end
    if not probe and package.config:sub(1, 1) == "\\" then
        -- 原生 Windows Lua 使用 ANSI 文件 API；控制台却可能输出 UTF-8。
        -- 通过系统 PowerShell 把 UTF-8 文件名转成本地代码页，仅传 ASCII 字节表，
        -- 不修改控制台代码页，也不把路径插入可执行的 PowerShell 表达式。
        local bytes = {}
        for i = 1, #filename do bytes[i] = tostring(filename:byte(i)) end
        local expression = "[string]::Join(',', [Text.Encoding]::Default.GetBytes(" ..
            "[Text.Encoding]::UTF8.GetString([byte[]](" .. table.concat(bytes, ",") .. "))))"
        local command = 'powershell.exe -NoProfile -NonInteractive -Command "' .. expression .. '"'
        local pipe = assert(io.popen(command, "r"))
        local encoded = assert(pipe:read("*a"))
        assert(pipe:close(), "Cannot convert the step-script filename to the Windows code page")
        assert(encoded:match("^[%d,%s]+$"), "Invalid filename encoding result")
        local native = {}
        for value in encoded:gmatch("%d+") do
            local byte = tonumber(value)
            assert(byte <= 255, "Invalid filename byte")
            native[#native + 1] = string.char(byte)
        end
        path = scriptDirectory .. table.concat(native)
        source = readAll(path)
    end
    -- 从字节载入，兼容 io.open 能打开但 C 版 loadfile 不能重开中文路径的环境。
    return assert(load(assert(source, "Cannot read step " .. number), "@" .. path, "t"))(moduleName)
end

local function installOutputs(items)
    -- 检查两个目标都未被外部改动后，才开始写回。
    for _, item in ipairs(items) do
        assert(readMaybe(item.path) == item.original, "Target changed during processing: " .. item.path)
    end
    local ok, err = pcall(function()
        for _, item in ipairs(items) do
            if item.data ~= item.original then
                if item.original then
                    item.hold = uniquePath(item.path .. ".pipeline.hold")
                    assert(os.rename(item.path, item.hold))
                    item.moved = true
                end
                assert(os.rename(item.temporary, item.path))
                item.installed = true
            end
        end
        for _, item in ipairs(items) do assert(readAll(item.path) == item.data, "Output verification failed: " .. item.path) end
    end)
    if not ok then
        local failures = {}
        for i = #items, 1, -1 do
            local item = items[i]
            if item.installed then
                local restored, restoreError = os.rename(item.path, item.temporary)
                if not restored then failures[#failures + 1] = item.path .. ": " .. tostring(restoreError) end
            end
            if item.moved then
                local restored, restoreError = os.rename(item.hold, item.path)
                if not restored then failures[#failures + 1] = item.hold .. ": " .. tostring(restoreError) end
            end
        end
        error("Cannot install model outputs: " .. tostring(err) ..
            (#failures > 0 and ("; rollback errors: " .. table.concat(failures, "; ")) or "; original files restored"))
    end
    for _, item in ipairs(items) do if item.hold then os.remove(item.hold) end end
end

local function processFile(path, options)
    options = options or {}
    local extension = path:lower():match("%.(md[xl])$")
    assert(extension, "Input must be .mdl or .mdx")
    local epsilon = options.keyframeEpsilon
    if epsilon == nil then epsilon = flag.keyframeEpsilon end
    assert(type(epsilon) == "number" and epsilon >= 0 and epsilon < math.huge, "Invalid keyframeEpsilon")
    local converter = options.converterExe or flag.converterExe
    assert(readMaybe(converter), "Converter not found: " .. converter)
    local compress = loadStep(3, "模型第3步_压缩.lua", "model.compress")
    local attachments = loadStep(4, "模型第4步_附加点.lua", "model.attachments")
    local weld = loadStep(5, "模型第5步_合并顶点.lua", "model.vertex_weld")
    local stem = path:sub(1, -5)
    local mdlPath = extension == "mdl" and path or (stem .. ".mdl")
    local mdxPath = extension == "mdx" and path or (stem .. ".mdx")
    local originalMdl, originalMdx = readMaybe(mdlPath), readMaybe(mdxPath)
    assert(extension == "mdl" and originalMdl or extension == "mdx" and originalMdx, "Input file not found")
    local timestamp, backups = os.date("%Y%m%d_%H%M%S"), {}
    -- 在任何处理步骤运行之前，复制并逐字验证备份；原文件此时不移动。
    for _, entry in ipairs({{path = mdlPath, data = originalMdl}, {path = mdxPath, data = originalMdx}}) do
        if entry.data then
            local backup = uniquePath(entry.path .. ".bak." .. timestamp)
            writeAll(backup, entry.data)
            backups[#backups + 1] = backup
            print("Backup: " .. backup)
        end
    end
    local temporaryFiles, temporaryIndex = {}, 0
    local function temporary(suffix)
        local candidate
        repeat
            temporaryIndex = temporaryIndex + 1
            candidate = path .. ".pipeline." .. timestamp .. "." .. temporaryIndex .. suffix
        until readMaybe(candidate) == nil
        temporaryFiles[#temporaryFiles + 1] = candidate
        return candidate
    end
    local function run()
        local workingMdl = temporary(".work.mdl")
        if extension == "mdx" then
            local input = temporary(".input.mdx")
            writeAll(input, originalMdx)
            weld.convert(converter, input, workingMdl)
        else
            writeAll(workingMdl, originalMdl)
        end
        print("[3/5] Compress animation")
        local compressed, compression = compress.processText(readAll(workingMdl), {keyframeEpsilon = epsilon})
        writeAll(workingMdl, compressed)
        print(string.format("Keys removed: %d; epsilon: %g", compression.keysRemoved, epsilon))
        collectgarbage("collect")
        print("[4/5] Add attachments")
        attachments.processFile(workingMdl)
        print("[5/5] Merge vertices and shorten decimals")
        local inputMdx, optimizedMdx = temporary(".input.mdx"), temporary(".optimized.mdx")
        weld.convert(converter, workingMdl, inputMdx)
        local optimized, geometry = weld.optimizeMdx(readAll(inputMdx), options.mergeUnshadedNormals ~= false)
        writeAll(optimizedMdx, optimized)
        local finalMdl, finalMdx = temporary(".final.mdl"), temporary(".final.mdx")
        weld.convert(converter, optimizedMdx, finalMdl)
        local compact = weld.compactMdlNumbers(readAll(finalMdl))
        writeAll(finalMdl, compact)
        weld.convert(converter, finalMdl, finalMdx)
        local binary = readAll(finalMdx)
        weld.assertMdlRoundTrip(optimized, binary)
        installOutputs({
            {path = mdlPath, original = originalMdl, data = compact, temporary = finalMdl},
            {path = mdxPath, original = originalMdx, data = binary, temporary = finalMdx},
        })
        print(string.format("MDL: %s -> %d bytes", originalMdl and #originalMdl or "new", #compact))
        print(string.format("MDX: %s -> %d bytes", originalMdx and #originalMdx or "new", #binary))
        print(string.format("Vertices: %d -> %d; triangles: %d", geometry.verticesBefore, geometry.verticesAfter, geometry.triangles))
        print("Done: " .. mdlPath)
        print("Done: " .. mdxPath)
        return {mdlPath = mdlPath, mdxPath = mdxPath, backups = backups, compression = compression, geometry = geometry}
    end
    local ok, result = pcall(run)
    for _, file in ipairs(temporaryFiles) do os.remove(file) end
    if not ok then error("Model pipeline failed; backups: " .. table.concat(backups, "; ") .. "; " .. tostring(result)) end
    return result
end

if ... == "model.pipeline" then return {processFile = processFile} end

local path, index = flag.path, 1
while arg and index <= #arg do
    local value = arg[index]
    if value == "--epsilon" then
        index = index + 1
        flag.keyframeEpsilon = assert(tonumber(arg[index]), "--epsilon requires a number")
    elseif value:match("^%-%-epsilon=") then
        flag.keyframeEpsilon = assert(tonumber(value:match("=(.*)$")), "--epsilon requires a number")
    elseif value == "--keep-normals" then flag.mergeUnshadedNormals = false
    elseif value == "--help" then
        print('lua 一键处理模型.lua "模型.mdl|模型.mdx" [--epsilon 1e-5] [--keep-normals]')
        return
    elseif value:sub(1, 2) == "--" then error("Unknown option: " .. value)
    else path = value end
    index = index + 1
end
processFile(path, flag)
