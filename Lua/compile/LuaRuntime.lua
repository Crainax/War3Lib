local lfs = require "lfs"
local fu = require "Lua.utils.FileUtils"
local path = require "Lua.path"

local runtime = {}

local function ensureDir(dir)
    if lfs.attributes(dir, "mode") == "directory" then
        return true
    end
    local parent = dir:match("(.+)/[^/]+$")
    if parent and lfs.attributes(parent, "mode") ~= "directory" then
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

local function readFile(filePath)
    local file = io.open(filePath, "rb")
    if not file then
        return nil
    end
    local content = file:read("*all")
    file:close()
    return content
end

local function writeFile(filePath, content)
    local ok, err = ensureDir(fu.GetDir(filePath))
    if not ok then
        return false, err
    end
    local file, writeErr = io.open(filePath, "wb")
    if not file then
        return false, "文件写入失败:" .. filePath .. " " .. tostring(writeErr)
    end
    file:write(content or "")
    file:close()
    return true
end

local function normalize(value)
    return tostring(value or ""):gsub("\\", "/"):gsub("/+$", "")
end

local function winPath(value)
    return normalize(value):gsub("/", "\\")
end

local function luaString(value)
    value = tostring(value or ""):gsub("\\", "\\\\"):gsub("'", "\\'")
    return "'" .. value .. "'"
end

local function isLocalLuaMode()
    return path.buildVersion == "内测版本" or path.buildVersion == "单元测试"
end

local function snapshot(cleanup, filePath)
    filePath = normalize(filePath)
    if cleanup.snapshots[filePath] then
        return
    end
    cleanup.snapshots[filePath] = {
        existed = lfs.attributes(filePath, "mode") == "file",
        content = readFile(filePath)
    }
end

local function rememberDir(cleanup, dir)
    dir = normalize(dir)
    while dir and dir ~= "" and lfs.attributes(dir, "mode") ~= "directory" do
        cleanup.createdDirs[dir] = true
        dir = dir:match("(.+)/[^/]+$")
    end
end

local function writeTracked(cleanup, filePath, content)
    filePath = normalize(filePath)
    snapshot(cleanup, filePath)
    rememberDir(cleanup, fu.GetDir(filePath))
    return writeFile(filePath, content)
end

local function copyTracked(cleanup, src, dst)
    src = normalize(src)
    dst = normalize(dst)
    snapshot(cleanup, dst)
    rememberDir(cleanup, fu.GetDir(dst))
    local ok, err = ensureDir(fu.GetDir(dst))
    if not ok then
        return false, err
    end
    return fu.copyFile(src, dst)
end

local function removeEmptyDirs(cleanup)
    local dirs = {}
    for dir in pairs(cleanup.createdDirs) do
        table.insert(dirs, dir)
    end
    table.sort(dirs, function(a, b) return #a > #b end)
    for _, dir in ipairs(dirs) do
        pcall(lfs.rmdir, dir)
    end
end

local function restore(cleanup)
    local files = {}
    for filePath in pairs(cleanup.snapshots) do
        table.insert(files, filePath)
    end
    table.sort(files, function(a, b) return #a > #b end)

    for _, filePath in ipairs(files) do
        local info = cleanup.snapshots[filePath]
        if info.existed then
            writeFile(filePath, info.content or "")
        elseif lfs.attributes(filePath, "mode") == "file" then
            pcall(os.remove, filePath)
        end
    end

    removeEmptyDirs(cleanup)
end

local function pluginMainContent()
    return [[local ok, is_local = pcall(require, 'path')

local console = require 'jass.console'
print = console.write

if ok and is_local then
    print('[plugin_main]本地路径')
else
    package.console_enable = false
    print('[plugin_main]地图内路径')
end

print('[plugin_main]初始化:新版')

xpcall(function()
    require 'script'
end, function(msg)
    print(tostring(msg) .. '\n' .. debug.traceback())
end)

local japi = require 'jass.japi'
xpcall(function()
    japi.SetOwner('问号')
end, function()
    print('当前不是内置japi')
end)
]]
end

local function pathLuaContent(localMode)
    local lines = {
        "package.console_enable = false",
        "package.build_version = " .. luaString(path.buildVersion)
    }

    if localMode then
        local projectWin = winPath(path.project) .. "\\"
        table.insert(lines, "package.path = package.path .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "?.lua") .. " .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "?\\init.lua") .. " .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "script\\?.lua") .. " .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "script\\?\\init.lua") .. " .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "script\\core\\?.lua") .. " .. ';'")
        table.insert(lines, "    .. " .. luaString(projectWin .. "script\\core\\?\\init.lua") .. " .. ';'")
        table.insert(lines, "package.local_map_path = " .. luaString(projectWin))
        table.insert(lines, "return true")
    else
        table.insert(lines, "package.path = package.path .. ';'")
        table.insert(lines, "    .. '?.lua;'")
        table.insert(lines, "    .. '?\\\\init.lua;'")
        table.insert(lines, "    .. 'script\\\\?.lua;'")
        table.insert(lines, "    .. 'script\\\\?\\\\init.lua;'")
        table.insert(lines, "    .. 'script\\\\core\\\\?.lua;'")
        table.insert(lines, "    .. 'script\\\\core\\\\?\\\\init.lua;'")
        table.insert(lines, "return false")
    end

    return table.concat(lines, "\n") .. "\n"
end

local function collectLuaFiles(root)
    local files = {}
    if lfs.attributes(root, "mode") ~= "directory" then
        return files
    end
    local rootPrefix = normalize(root) .. "/"
    local function walk(dir)
        for name in lfs.dir(dir) do
            if name ~= "." and name ~= ".." then
                local fullPath = normalize(dir .. "/" .. name)
                local mode = lfs.attributes(fullPath, "mode")
                if mode == "directory" then
                    walk(fullPath)
                elseif mode == "file" and name:lower():match("%.lua$") then
                    table.insert(files, {
                        src = fullPath,
                        rel = fullPath:sub(#rootPrefix + 1)
                    })
                end
            end
        end
    end
    walk(normalize(root))
    table.sort(files, function(a, b) return a.rel < b.rel end)
    return files
end

local function mapDestinationForScript(rel)
    rel = normalize(rel)
    if rel:sub(1, #"depends/") == "depends/" then
        return path.package .. "/map/" .. rel
    end
    return path.package .. "/map/script/" .. rel
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

local function addImportEntries(cleanup, entries, persist)
    local imp = path.table and path.table.root and (path.table.root .. "/imp.ini")
    if not imp or lfs.attributes(imp, "mode") ~= "file" then
        return true
    end

    local content = readFile(imp) or ""
    local seen = {}
    for item in content:gmatch('"(.-)"') do
        seen[lniUnquote(item):gsub("/", "\\"):lower()] = true
    end

    local missing = {}
    for _, entry in ipairs(entries) do
        entry = entry:gsub("/", "\\")
        local key = entry:lower()
        if not seen[key] then
            table.insert(missing, entry)
            seen[key] = true
        end
    end

    if #missing == 0 then
        return true
    end

    table.sort(missing)
    local insert = {}
    for _, entry in ipairs(missing) do
        table.insert(insert, string.format('%q,', entry))
    end

    local newline = content:find("\r\n", 1, true) and "\r\n" or "\n"
    local nextContent, count = content:gsub(newline .. "}%s*$", newline .. table.concat(insert, newline) .. newline .. "}" .. newline, 1)
    if count == 0 then
        return false, "无法更新imp.ini: " .. imp
    end

    if persist then
        return writeFile(imp, nextContent)
    end
    return writeTracked(cleanup, imp, nextContent)
end

function runtime.getPackageFiles()
    local localMode = isLocalLuaMode()
    local mapDir = path.package .. "/map"
    local files = {
        {
            archive = "plugin_main.lua",
            target = mapDir .. "/plugin_main.lua",
            content = pluginMainContent(),
            replace = true,
        },
        {
            archive = "path.lua",
            target = mapDir .. "/path.lua",
            content = pathLuaContent(localMode),
            replace = true,
        },
    }

    if not localMode then
        for _, file in ipairs(collectLuaFiles(path.project .. "/script")) do
            local archive
            if file.rel:sub(1, #"depends/") == "depends/" then
                archive = file.rel
            else
                archive = "script/" .. file.rel
            end
            table.insert(files, {
                archive = archive,
                source = file.src,
                target = mapDestinationForScript(file.rel),
                replace = true,
            })
        end
    end

    return files, localMode
end

function runtime.prepareForPackage(options)
    options = options or {}
    local cleanup = {
        snapshots = {},
        createdDirs = {}
    }
    local packageFiles, localMode = runtime.getPackageFiles()
    local importEntries = {}

    for _, file in ipairs(packageFiles) do
        table.insert(importEntries, file.archive)
        local ok, err
        if file.content ~= nil then
            ok, err = writeTracked(cleanup, file.target, file.content)
        else
            ok, err = copyTracked(cleanup, file.source, file.target)
        end
        if not ok then
            return nil, err
        end
    end

    local ok, err = addImportEntries(cleanup, importEntries, options.persistImp)
    if not ok then
        return nil, err
    end

    print(string.format("[Lua运行时]准备完成: %s, 路径=%s, 控制台=false", path.buildVersion, localMode and "本地" or "地图内"))

    return function()
        restore(cleanup)
        print("[Lua运行时]临时文件已恢复")
    end
end

function runtime.writePackageFilesTo(dir)
    local packageFiles = runtime.getPackageFiles()
    local generated = {}
    for _, file in ipairs(packageFiles) do
        local source = file.source
        if file.content ~= nil then
            source = normalize(dir) .. "/" .. file.archive:gsub("[/\\]", "_")
            local ok, err = writeFile(source, file.content)
            if not ok then
                return nil, err
            end
            table.insert(generated, source)
        end
        file.source = source
    end
    return packageFiles, generated
end

return runtime
