-- Only the War3Lib GUI uses this disposable packaging tree.
local path = require 'Lua.path'
local lfs = require 'lfs'
local fu = require 'Lua.utils.FileUtils'
local M = {}
function M.key(engine)
    local base = engine == 'innerjapi' and 'innerjapi-1.49-9' or 'ydlua'
    return base .. '/tests/' .. require('Lua.compile.UnitTestTarget').key(path.project, path.testScenario)
end
local assets = {'callback', 'wenhao_plugin.tga', '(key)'}
local function mkdir(dir)
    if lfs.attributes(dir, 'mode') == 'directory' then return end
    local parent = dir:match('(.+)/[^/]+$')
    if parent then mkdir(parent) end
    assert(lfs.mkdir(dir))
end
local function empty(dir)
    if lfs.attributes(dir, 'mode') ~= 'directory' then return end
    for name in lfs.dir(dir) do
        if name ~= '.' and name ~= '..' then
            local full = dir .. '/' .. name
            assert(lfs.symlinkattributes(full, 'mode') ~= 'link', 'staging must not contain links')
            if lfs.attributes(full, 'mode') == 'directory' then empty(full); assert(lfs.rmdir(full))
            else assert(os.remove(full)) end
        end
    end
end
local function copyTree(src, dst)
    mkdir(dst)
    for name in lfs.dir(src) do
        if name ~= '.' and name ~= '..' then
            local a, b = src .. '/' .. name, dst .. '/' .. name
            if lfs.attributes(a, 'mode') == 'directory' then copyTree(a,b)
            else assert(fu.copyFile(a,b)) end
        end
    end
end
function M.stage(engine)
    assert(path.project == path.libRoot and path.buildVersion == '单元测试')
    assert(engine == 'ydlua' or engine == 'innerjapi')
    local rel = 'Output/launcher/engines/' .. M.key(engine) .. '/staging/UnitTestMap'
    local dst = path.project .. '/' .. rel
    -- Exact generated subtree, never the source UnitTestMap.
    local check = path.project
    for part in rel:gmatch('[^/]+') do
        check = check .. '/' .. part
        assert(lfs.symlinkattributes(check, 'mode') ~= 'link', 'staging must not be a link')
    end
    empty(dst)
    copyTree(path.project .. '/UnitTestMap', dst)
    for _, name in ipairs(assets) do
        for _, sub in ipairs({'map/', 'resource/', ''}) do
            local file = dst .. '/' .. sub .. name
            if lfs.attributes(file, 'mode') == 'file' then assert(os.remove(file)) end
        end
    end
    local imp = dst .. '/table/imp.ini'
    local f = io.open(imp, 'rb')
    if f then
        local text = f:read('*a'); f:close()
        for _, name in ipairs(assets) do
            local escaped = name:gsub('([^%w])', '%%%1')
            text = text:gsub('[ \t]*"' .. escaped .. '"[ \t]*,?[^\r\n]*[\r\n]*', '')
        end
        f = assert(io.open(imp, 'wb')); f:write(text); f:close()
    end
    path.setMapName(rel)
    path.luaEngine = engine
    path.runtimeProfile = M.key(engine)
    print('[Lua引擎]独立打包目录: ' .. dst)
end
function M.files()
    if path.luaEngine ~= 'innerjapi' then return {} end
    assert(path.project == path.libRoot and path.buildVersion == '单元测试')
    local root = path.libRoot .. '/runtime/innerjapi/1.49-9/'
    local result = {}
    for _, name in ipairs(assets) do
        assert(lfs.attributes(root .. name, 'mode') == 'file', '缺少内置运行库: ' .. name)
        result[#result+1] = { archive=name, source=root .. name, target=path.package .. (name == 'wenhao_plugin.tga' and '/resource/' or '/map/') .. name, replace=true }
    end
    return result
end
return M
