local lfs = require "lfs"
local fu = require "Lua.utils.FileUtils"
local path = require "Lua.path"
local compileFiles = require "Lua.compile.CompileFiles"
local luaRuntime = require "Lua.compile.LuaRuntime"

local pack = {}

local staticResourceExt = {
    mdx = true,
    mdl = true,
    blp = true,
    tga = true,
    dds = true,
    tif = true,
}

local soundExt = {
    mp3 = true,
    wav = true,
}

local impIgnore = {
    ["(attributes)"] = true,
    ["(listfile)"] = true,
    ["(signature)"] = true,
    ["war3map.j"] = true,
    ["scripts\\war3map.j"] = true,
    ["war3map.doo"] = true,
    ["war3map.imp"] = true,
    ["war3map.mmp"] = true,
    ["war3map.shd"] = true,
    ["war3map.w3c"] = true,
    ["war3map.w3e"] = true,
    ["war3map.w3i"] = true,
    ["war3map.w3r"] = true,
    ["war3map.w3s"] = true,
    ["war3map.wct"] = true,
    ["war3map.wpm"] = true,
    ["war3map.wtg"] = true,
    ["war3map.wts"] = true,
    ["war3mapextra.txt"] = true,
    ["war3mapmap.blp"] = true,
    ["war3mapmisc.txt"] = true,
    ["war3mapskin.txt"] = true,
    ["war3mapunits.doo"] = true,
    ["war3map.txt.ini"] = true,
}

local function normalize(value)
    value = tostring(value or ""):gsub("\\", "/")
    value = value:gsub("/+", "/")
    value = value:gsub("/+$", "")
    return value
end

local function normalizeRel(value)
    value = normalize(value):gsub("^%./", "")
    return (value:match("^%s*(.-)%s*$"))
end

local function normalizeArchive(value)
    return normalizeRel(value):gsub("/", "\\")
end

local function archiveKey(value)
    return normalizeArchive(value):lower()
end

local function ensureDir(dir)
    if not dir or dir == "" or lfs.attributes(dir, "mode") == "directory" then
        return true
    end
    local parent = normalize(dir):match("(.+)/[^/]+$")
    if parent and parent ~= dir and lfs.attributes(parent, "mode") ~= "directory" then
        local ok, err = ensureDir(parent)
        if not ok then
            return false, err
        end
    end
    local ok, err = lfs.mkdir(dir)
    if ok or lfs.attributes(dir, "mode") == "directory" then
        return true
    end
    return false, err
end

local function readFile(filePath, binary)
    local file = io.open(filePath, binary and "rb" or "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

local function writeFile(filePath, content, binary)
    local ok, err = ensureDir(fu.GetDir(filePath))
    if not ok then
        return false, err
    end
    local file, writeErr = io.open(filePath, binary and "wb" or "w")
    if not file then
        return false, "文件写入失败:" .. tostring(filePath) .. " " .. tostring(writeErr)
    end
    file:write(content or "")
    file:close()
    return true
end

local function lniUnquote(raw)
    local fn = load("return \"" .. tostring(raw or "") .. "\"")
    if fn then
        local ok, result = pcall(fn)
        if ok and type(result) == "string" then
            return result
        end
    end
    return tostring(raw or ""):gsub('\\"', '"'):gsub("\\\\", "\\")
end

local function readImpEntries(impPath)
    local content = readFile(impPath) or "import = {\n}\n"
    local entries = {}
    local seen = {}
    for raw in content:gmatch('"(.-)"') do
        local entry = normalizeArchive(lniUnquote(raw))
        local key = entry:lower()
        if entry ~= "" and not seen[key] then
            seen[key] = true
            table.insert(entries, entry)
        end
    end
    return entries, seen, content
end

local function sortEntries(entries)
    table.sort(entries, function(a, b)
        local la = a:lower()
        local lb = b:lower()
        if la == lb then
            return a < b
        end
        return la < lb
    end)
end

local function writeImpEntries(impPath, entries, missing, content)
    if missing and #missing > 0 and content and content ~= "" then
        table.sort(missing, function(a, b)
            return a:lower() < b:lower()
        end)
        local insert = {}
        for _, entry in ipairs(missing) do
            insert[#insert + 1] = ("%q,"):format(entry)
        end
        local newline = content:find("\r\n", 1, true) and "\r\n" or "\n"
        local nextContent, count = content:gsub(newline .. "}%s*$", newline .. table.concat(insert, newline) .. newline .. "}" .. newline, 1)
        if count > 0 then
            return writeFile(impPath, nextContent)
        end
    elseif missing and #missing == 0 then
        return true
    end

    sortEntries(entries)
    local lines = { "import = {" }
    for _, entry in ipairs(entries) do
        table.insert(lines, ("%q,"):format(entry))
    end
    table.insert(lines, "}")
    return writeFile(impPath, table.concat(lines, "\r\n") .. "\r\n")
end

local function addCandidate(candidates, archive, source, replace, kind)
    archive = normalizeArchive(archive)
    source = source and normalize(source) or nil
    if archive == "" or not source or source == "" then
        return
    end
    local key = archive:lower()
    local current = candidates[key]
    if current and not replace then
        return
    end
    candidates[key] = {
        archive = archive,
        source = source,
        replace = replace and true or false,
        kind = kind or "static",
    }
end

local function archiveFromPackageRelative(rel)
    rel = normalizeRel(rel)
    local top, rest = rel:match("^([^/]+)/(.+)$")
    if top == "resource" or top == "sound" or top == "map" then
        return rest
    elseif top == "scripts" then
        return "scripts/" .. rest
    end
    return rel
end

local function fileExt(filePath)
    return tostring(filePath or ""):match("%.([^%.\\/]+)$")
end

local function shouldIncludeDirectoryFile(top, rel)
    local ext = fileExt(rel)
    ext = ext and ext:lower() or ""
    local archive = archiveFromPackageRelative(top .. "/" .. rel)
    local key = archiveKey(archive)
    if impIgnore[key] then
        return false
    end
    if top == "resource" then
        return staticResourceExt[ext] == true
    elseif top == "sound" then
        return soundExt[ext] == true
    elseif top == "map" then
        return archive ~= "path.lua" and archive ~= "plugin_main.lua"
    elseif top == "scripts" then
        return archive ~= "scripts\\war3map.j"
    end
    return false
end

local function scanDirFiles(root, callback)
    if lfs.attributes(root, "mode") ~= "directory" then
        return
    end
    root = normalize(root)
    local prefixLen = #root + 2
    local function walk(dir)
        for name in lfs.dir(dir) do
            if name ~= "." and name ~= ".." then
                local fullPath = normalize(dir .. "/" .. name)
                local mode = lfs.attributes(fullPath, "mode")
                if mode == "directory" then
                    walk(fullPath)
                elseif mode == "file" then
                    callback(fullPath, fullPath:sub(prefixLen))
                end
            end
        end
    end
    walk(root)
end

local function addDirectoryCandidates(candidates)
    for _, top in ipairs({ "resource", "sound", "map", "scripts" }) do
        local root = path.package .. "/" .. top
        scanDirFiles(root, function(fullPath, rel)
            rel = normalizeRel(rel)
            if shouldIncludeDirectoryFile(top, rel) then
                addCandidate(candidates, archiveFromPackageRelative(top .. "/" .. rel), fullPath, false, "static")
            end
        end)
    end
end

local function addCompileResourceCandidates(candidates)
    for _, rel in ipairs(compileFiles.resourceFiles or {}) do
        rel = normalizeRel(rel)
        if rel ~= "" then
            local source = path.package .. "/" .. rel
            if lfs.attributes(source, "mode") ~= "file" then
                local assetSource = path.assets .. "/" .. rel
                if lfs.attributes(assetSource, "mode") == "file" then
                    source = assetSource
                end
            end
            addCandidate(candidates, archiveFromPackageRelative(rel), source, false, "static")
        end
    end
end

local function addLuaCandidates(candidates, generatedDir)
    local files, err = luaRuntime.writePackageFilesTo(generatedDir)
    if not files then
        return false, err
    end
    for _, file in ipairs(files) do
        addCandidate(candidates, file.archive, file.source, true, "lua")
    end
    return true
end

local function candidateList(candidates)
    local list = {}
    for _, item in pairs(candidates) do
        table.insert(list, item)
    end
    table.sort(list, function(a, b)
        return a.archive:lower() < b.archive:lower()
    end)
    return list
end

local function luaString(value)
    return ("%q"):format(tostring(value or ""))
end

local function writeManifest(filePath, manifest)
    local lines = { "return {" }
    lines[#lines + 1] = "  mapPath = " .. luaString(manifest.mapPath) .. ","
    lines[#lines + 1] = "  scriptPath = " .. luaString(manifest.scriptPath) .. ","
    lines[#lines + 1] = "  maxFileCount = " .. tostring(manifest.maxFileCount or 16384) .. ","
    lines[#lines + 1] = "  imports = {"
    for _, entry in ipairs(manifest.imports) do
        lines[#lines + 1] = "    " .. luaString(entry) .. ","
    end
    lines[#lines + 1] = "  },"
    lines[#lines + 1] = "  files = {"
    for _, file in ipairs(manifest.files) do
        lines[#lines + 1] = "    { archive = " .. luaString(file.archive)
            .. ", source = " .. luaString(file.source)
            .. ", replace = " .. tostring(file.replace == true)
            .. ", kind = " .. luaString(file.kind)
            .. " },"
    end
    lines[#lines + 1] = "  },"
    lines[#lines + 1] = "}"
    return writeFile(filePath, table.concat(lines, "\n") .. "\n")
end

local function runCommand(cmd)
    local ok, exitType, exitCode = os.execute(cmd)
    if ok == true or ok == 0 then
        return true
    end
    return exitType == "exit" and exitCode == 0
end

local function toWinPath(value)
    return tostring(value):gsub("/", "\\")
end

local function buildSummary(candidates, missingImports, mergedEntries, files)
    local staticCandidates = 0
    local luaCandidates = 0
    for _, candidate in pairs(candidates) do
        if candidate.kind == "lua" then
            luaCandidates = luaCandidates + 1
        else
            staticCandidates = staticCandidates + 1
        end
    end
    return {
        staticCandidates = staticCandidates,
        luaCandidates = luaCandidates,
        missingImports = missingImports,
        totalImports = #mergedEntries,
        stormFiles = #files,
    }
end

function pack.prepare(targetMap, options)
    options = options or {}
    local generatedDir = options.generatedDir or (path.project .. "/Output/launcher/incremental/generated")
    local manifestPath = options.manifestPath or (path.project .. "/Output/launcher/incremental/manifest.lua")
    local impPath = options.impPath or (path.table.root .. "/imp.ini")
    local candidates = {}

    addCompileResourceCandidates(candidates)
    addDirectoryCandidates(candidates)
    local ok, err = addLuaCandidates(candidates, generatedDir)
    if not ok then
        return false, err
    end

    local entries, originalSeen, impContent = readImpEntries(impPath)
    local mergedSeen = {}
    for _, entry in ipairs(entries) do
        mergedSeen[entry:lower()] = true
    end

    local missingEntries = {}
    for _, candidate in pairs(candidates) do
        local key = candidate.archive:lower()
        if not mergedSeen[key] then
            mergedSeen[key] = true
            table.insert(entries, candidate.archive)
            table.insert(missingEntries, candidate.archive)
        end
    end
    sortEntries(entries)

    local files = {}
    for _, candidate in ipairs(candidateList(candidates)) do
        if candidate.replace or not originalSeen[candidate.archive:lower()] then
            table.insert(files, candidate)
        end
    end

    local summary = buildSummary(candidates, #missingEntries, entries, files)
    if options.dryRun then
        print(string.format(
            "[增量资源][dry-run] 静态候选=%d, Lua候选=%d, 新增imp=%d, Storm文件=%d, 总imp=%d",
            summary.staticCandidates,
            summary.luaCandidates,
            summary.missingImports,
            summary.stormFiles,
            summary.totalImports
        ))
        return true, summary
    end

    ok, err = writeImpEntries(impPath, entries, missingEntries, impContent)
    if not ok then
        return false, err
    end

    ok, err = writeManifest(manifestPath, {
        mapPath = targetMap,
        scriptPath = path.CompileResult,
        maxFileCount = options.maxFileCount or 16384,
        imports = entries,
        files = files,
    })
    if not ok then
        return false, err
    end

    summary.manifestPath = manifestPath
    return true, summary
end

function pack.syncCurrentTableImp(options)
    options = options or {}
    options.dryRun = options.dryRun or false
    local ok, result = pack.prepare(options.targetMap or "", {
        dryRun = options.dryRun,
        generatedDir = options.generatedDir or (path.project .. "/Output/launcher/incremental/generated_full"),
        manifestPath = options.manifestPath or (path.project .. "/Output/launcher/incremental/full_manifest.lua"),
        impPath = options.impPath,
    })
    if ok and result then
        print(string.format(
            "[导入表同步] 静态候选=%d, Lua候选=%d, 新增imp=%d, 总imp=%d",
            result.staticCandidates,
            result.luaCandidates,
            result.missingImports,
            result.totalImports
        ))
    end
    return ok, result
end

function pack.updateMap(targetMap, options)
    options = options or {}
    local ok, summaryOrErr = pack.prepare(targetMap, options)
    if not ok then
        print("[增量资源]准备失败:" .. tostring(summaryOrErr))
        return false
    end

    local summary = summaryOrErr
    local w2lRoot = options.w2lRoot
    local w2lLuaExe = options.w2lLuaExe or (w2lRoot .. "/bin/w3x2lni-lua.exe")
    local stormTask = options.stormTask or (path.libRoot .. "/Lua/tasks/TaskStormIncrementalPack.lua")

    local cmd = string.format(
        'cmd /c ""%s" "%s" "%s" "%s""',
        toWinPath(w2lLuaExe),
        toWinPath(stormTask),
        toWinPath(summary.manifestPath),
        toWinPath(w2lRoot)
    )
    print(cmd)
    if not runCommand(cmd) then
        print("[增量资源]Storm增量打包执行失败")
        return false
    end
    print(string.format(
        "[增量资源]完成: 新增imp=%d, Storm文件=%d, 总imp=%d",
        summary.missingImports,
        summary.stormFiles,
        summary.totalImports
    ))
    return true
end

return pack
