local flag = {
    templateMdl = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\template.mdl]],
    outputDir = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\output]],
    tempMdlDir = [[D:\War3Asset\Asset\Xlimon_Achieve\NewMap\PortraitModel\output\_tmp_mdl_build]],
    converterExe = [[D:\War3\tools\war3mdlx.exe]],

    -- 输出文件名: string.format(modelNamePattern, i) .. variant .. modelSuffix
    -- 例: modelNamePattern="shop%d", i=1, variant="", modelSuffix="_portrait" => shop1_portrait
    modelNamePattern = "shop%d",
    indexStart = 1,
    indexEnd = 20,
    modelSuffix = "_portrait",
    variants = { "" },

    -- 每个序号(i)对应的纹理码，按 indexStart..indexEnd 顺序读取
    -- 当前配置: 1~20 => Crainax\shop1.blp ~ Crainax\shop20.blp
    textureNamePattern = "Crainax\\shop%d.blp",

    -- 模板内用于匹配并替换的贴图路径模式
    texturePattern = "Crainax\\[%w_]+%.blp",

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

local function buildEntryList()
    local entries = {}
    for i = flag.indexStart, flag.indexEnd do
        local base = string.format(flag.modelNamePattern, i)
        local textureName = string.format(flag.textureNamePattern, i)
        for _, suffix in ipairs(flag.variants) do
            table.insert(entries, {
                id = base .. suffix,
                textureName = textureName
            })
        end
    end
    return entries
end

local function buildPaths(id)
    local stem = id .. flag.modelSuffix
    local mdl = flag.tempMdlDir .. "\\" .. stem .. ".mdl"
    local mdx = flag.outputDir .. "\\" .. stem .. ".mdx"
    return stem, mdl, mdx
end

local function buildTextureName(entry)
    return entry.textureName
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

    local entries = buildEntryList()
    local okCount = 0
    local failCount = 0

    if flag.cleanupOutputMdl then
        for _, entry in ipairs(entries) do
            local id = entry.id
            local stem = id .. flag.modelSuffix
            local oldMdl = flag.outputDir .. "\\" .. stem .. ".mdl"
            if fileExists(oldMdl) then
                removeFile(oldMdl)
            end
        end
    end

    for _, entry in ipairs(entries) do
        local id = entry.id
        local textureName = buildTextureName(entry)
        if not textureName then
            print("[SKIP] missing texture name for id: " .. id)
            failCount = failCount + 1
            goto continue
        end

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

    print(string.format("done. ok=%d fail=%d total=%d", okCount, failCount, #entries))
end

-- 修改说明:
-- 1) 改 modelNamePattern/indexStart/indexEnd 可以批量改输出名和范围:
--    例如 modelNamePattern="npc_%03d", indexStart=101, indexEnd=120 -> npc_101_portrait ~ npc_120_portrait
-- 2) 改 modelSuffix 可以改文件尾缀:
--    例如 modelSuffix="_icon" -> shop1_icon.mdl
-- 3) 改 variants 可生成同序号的额外变体:
--    例如 variants={"", "_2"} -> shop1_portrait / shop1_2_portrait
-- 4) 改 textureNamePattern 可以直接定义贴图路径规则:
--    例如 textureNamePattern="Crainax\\shop%d.blp", indexStart=1,indexEnd=20
--    会依次替换为 Crainax\shop1.blp ~ Crainax\shop20.blp
-- 5) 如果模板里贴图写法不同，按实际内容调整 texturePattern。
main()
