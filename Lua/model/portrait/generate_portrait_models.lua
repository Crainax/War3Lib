local flag = {
    templateMdl = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\template.mdl]],
    outputDir = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\output]],
    tempMdlDir = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\output\_tmp_mdl_build]],
    converterExe = [[D:\War3\tools\war3mdlx.exe]],

    modelSuffix = "_portrait",
    variants = { "", "_2" },

    -- h001~h009, h00a~h00p
    baseChars = {
        "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
        "k", "l", "m", "n", "o", "p"
    },

    texturePattern = "Crainax\\u00[%w]_?2?%.blp",
    texturePrefix = "Crainax\\u00",
    texturePrefixEscaped = "Crainax\\\\u00",
    textureExt = ".blp",

    overwrite = true,
    cleanupOutputMdl = true,
    keepTempMdlOnFail = false,
    dryRun = false,
}

local function quotePath(p)
    return '"' .. p .. '"'
end

local function fileExists(path)
    local f = io.open(path, "rb")
    if f then
        f:close()
        return true
    end
    return false
end

local function readAll(path)
    local f, err = io.open(path, "rb")
    if not f then
        return nil, "open failed: " .. tostring(err)
    end
    local content = f:read("*a")
    f:close()
    return content
end

local function writeAll(path, content)
    local f, err = io.open(path, "wb")
    if not f then
        return nil, "open failed: " .. tostring(err)
    end
    f:write(content)
    f:close()
    return true
end

local function ensureDir(path)
    os.execute('mkdir ' .. quotePath(path) .. ' >nul 2>nul')
end

local function removeFile(path)
    os.remove(path)
end

local function exec(cmd)
    local ok, why, code = os.execute(cmd)
    if ok == true then
        return true, 0
    end
    if ok == nil then
        if why == "exit" and code ~= nil then
            return false, tostring(code)
        end
        return false, tostring(why)
    end
    return false, tostring(code)
end

local function buildIdList()
    local ids = {}
    for _, c in ipairs(flag.baseChars) do
        local base = "h00" .. c
        for _, suffix in ipairs(flag.variants) do
            table.insert(ids, base .. suffix)
        end
    end
    return ids
end

local function getTextureCode(id)
    local c = id:match("^h00([0-9a-pA-P])")
    if not c then
        return nil
    end
    return string.lower(c)
end

local function buildPaths(id)
    local stem = id .. flag.modelSuffix
    local mdl = flag.tempMdlDir .. "\\" .. stem .. ".mdl"
    local mdx = flag.outputDir .. "\\" .. stem .. ".mdx"
    return stem, mdl, mdx
end

local function buildTextureName(id, code)
    local prefix = flag.texturePrefix
    local suffix = ""
    if id:match("_2$") then
        -- For "_2" textures, keep literal "\u00x_2" through MDL->MDX parser.
        prefix = flag.texturePrefixEscaped
        suffix = "_2"
    end
    return prefix .. code .. suffix .. flag.textureExt
end

local function main()
    if not fileExists(flag.templateMdl) then
        error("template not found: " .. flag.templateMdl)
    end
    if not fileExists(flag.converterExe) then
        error("converter not found: " .. flag.converterExe)
    end

    ensureDir(flag.outputDir)
    ensureDir(flag.tempMdlDir)

    local template, readErr = readAll(flag.templateMdl)
    if not template then
        error("read template failed: " .. tostring(readErr))
    end

    local ids = buildIdList()
    local okCount = 0
    local failCount = 0

    if flag.cleanupOutputMdl then
        for _, id in ipairs(ids) do
            local stem = id .. flag.modelSuffix
            local oldMdl = flag.outputDir .. "\\" .. stem .. ".mdl"
            if fileExists(oldMdl) then
                removeFile(oldMdl)
            end
        end
    end

    for _, id in ipairs(ids) do
        local code = getTextureCode(id)
        if not code then
            print("[SKIP] invalid id: " .. id)
            failCount = failCount + 1
            goto continue
        end

        local textureName = buildTextureName(id, code)
        local content, replaced = template:gsub(flag.texturePattern, textureName, 1)
        if replaced == 0 then
            print("[FAIL] no texture pattern matched for id: " .. id)
            failCount = failCount + 1
            goto continue
        end

        local stem, mdlPath, mdxPath = buildPaths(id)
        if (not flag.overwrite) and fileExists(mdlPath) then
            print("[SKIP] exists: " .. mdlPath)
            goto continue
        end

        if flag.dryRun then
            print(string.format("[DRY] %s -> %s", id, textureName))
            goto continue
        end

        local wrote, writeErr = writeAll(mdlPath, content)
        if not wrote then
            print("[FAIL] write mdl failed: " .. mdlPath .. " | " .. tostring(writeErr))
            failCount = failCount + 1
            goto continue
        end

        local rawCmd = table.concat({
            quotePath(flag.converterExe),
            "--mdl2x",
            "-f",
            quotePath(mdlPath),
            quotePath(mdxPath)
        }, " ")
        local cmd = 'cmd /c "' .. rawCmd .. '"'
        local runOk, runInfo = exec(cmd)
        if not runOk or (not fileExists(mdxPath)) then
            print("[FAIL] convert failed: " .. stem .. " | " .. tostring(runInfo))
            if (not flag.keepTempMdlOnFail) and fileExists(mdlPath) then
                removeFile(mdlPath)
            end
            failCount = failCount + 1
            goto continue
        end

        if fileExists(mdlPath) then
            removeFile(mdlPath)
        end
        print(string.format("[OK] %s | %s", stem, textureName))
        okCount = okCount + 1

        ::continue::
    end

    if not flag.keepTempMdlOnFail then
        os.execute('rmdir /s /q ' .. quotePath(flag.tempMdlDir) .. ' >nul 2>nul')
    end

    print(string.format("done. ok=%d fail=%d total=%d", okCount, failCount, #ids))
end

main()
