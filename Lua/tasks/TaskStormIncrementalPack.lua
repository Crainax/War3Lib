local function fail(msg)
    print("[Storm增量]失败: " .. tostring(msg))
    os.exit(1)
end

local manifestPath = arg[1]
local w2lRoot = arg[2]

if manifestPath == nil or manifestPath == "" then
    fail("缺少manifest路径参数")
end
if w2lRoot == nil or w2lRoot == "" then
    fail("缺少w3x2lni根路径参数")
end

w2lRoot = w2lRoot:gsub("\\", "/"):gsub("/+$", "")
package.path = w2lRoot .. "/script/?.lua;" .. w2lRoot .. "/script/?/init.lua;" .. package.path
package.cpath = w2lRoot .. "/bin/?.dll;" .. package.cpath

local fs = require("bee.filesystem")
local stormlib = require("ffi.stormlib")

local manifestFn, manifestErr = loadfile(manifestPath)
if not manifestFn then
    fail("无法读取manifest: " .. tostring(manifestErr))
end
local manifest = manifestFn()
if type(manifest) ~= "table" then
    fail("manifest格式错误")
end

local function readBinary(filePath)
    local file, err = io.open(filePath, "rb")
    if not file then
        return nil, err
    end
    local content = file:read("*a")
    file:close()
    return content
end

local function archiveName(value)
    return tostring(value or ""):gsub("/", "\\")
end

local function packU32(value)
    value = tonumber(value) or 0
    local b1 = value % 256
    local b2 = math.floor(value / 256) % 256
    local b3 = math.floor(value / 65536) % 256
    local b4 = math.floor(value / 16777216) % 256
    return string.char(b1, b2, b3, b4)
end

local function buildImp(imports)
    local chunks = { packU32(1) .. packU32(#imports) }
    for _, name in ipairs(imports) do
        chunks[#chunks + 1] = tostring(name or "") .. "\0"
    end
    return table.concat(chunks, "\r")
end

local mapPath = manifest.mapPath
if mapPath == nil or mapPath == "" then
    fail("manifest缺少mapPath")
end
if not manifest.scriptPath or manifest.scriptPath == "" then
    fail("manifest缺少scriptPath")
end

local archive = stormlib.open(fs.path(mapPath), false, manifest.maxFileCount or 16384)
if not archive then
    fail("无法打开地图文件: " .. tostring(mapPath))
end

local scriptContent, scriptErr = readBinary(manifest.scriptPath)
if not scriptContent then
    archive:close()
    fail("无法读取脚本文件: " .. tostring(scriptErr))
end

if not archive:save_file("war3map.j", scriptContent) then
    archive:close()
    fail("写入 war3map.j 失败")
end
local scriptWrites = 1
if archive:has_file("scripts\\war3map.j") then
    if not archive:save_file("scripts\\war3map.j", scriptContent) then
        archive:close()
        fail("写入 scripts\\\\war3map.j 失败")
    end
    scriptWrites = scriptWrites + 1
end

local added = 0
local replaced = 0
local skipped = 0
for _, item in ipairs(manifest.files or {}) do
    local name = archiveName(item.archive)
    if name ~= "" then
        local shouldWrite = item.replace == true or not archive:has_file(name)
        if shouldWrite then
            local content, err = readBinary(item.source)
            if not content then
                archive:close()
                fail("无法读取导入文件: " .. tostring(item.source) .. " (" .. tostring(err) .. ")")
            end
            if not archive:save_file(name, content) then
                archive:close()
                fail("写入导入文件失败: " .. name)
            end
            if item.replace == true then
                replaced = replaced + 1
            else
                added = added + 1
            end
        else
            skipped = skipped + 1
        end
    end
end

local impContent = buildImp(manifest.imports or {})
if not archive:save_file("war3map.imp", impContent) then
    archive:close()
    fail("写入 war3map.imp 失败")
end

archive:close()
print(string.format("[Storm增量]完成: script=%d, added=%d, replaced=%d, skipped=%d, imports=%d", scriptWrites, added, replaced, skipped, #(manifest.imports or {})))
