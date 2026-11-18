local M = {}
local lfs = require 'lfs'

---@param project string
---@return file*
function M.acquire(project)
    lfs.mkdir(project .. '/Output')
    lfs.mkdir(project .. '/Output/launcher')
    local handle = assert(io.open(project .. '/Output/launcher/.build.lock', 'a+b'))
    if not lfs.lock(handle, 'w', 0, 1) then
        handle:close()
        error('当前构建或清理正在使用输出目录，请等待完成后再启动。')
    end
    return handle
end

---@param project string
---@return string
function M.map_path(project)
    return project .. '/Output/UnitTestMap_slk.w3x'
end

local function identity_path(project)
    return project .. '/Output/launcher/current-map.txt'
end

local function identity(engine, target, version)
    return table.concat({engine, target:gsub('\\', '/'), version}, '\n') .. '\n'
end

---@param project string
---@param engine string
---@param target string
---@param version string
---@return boolean
function M.matches(project, engine, target, version)
    local map_file = io.open(M.map_path(project), 'rb')
    if not map_file then return false end
    map_file:close()
    local file = io.open(identity_path(project), 'rb')
    if not file then return false end
    local content = file:read('*a')
    file:close()
    return content == identity(engine, target, version)
end

---@param project string
function M.invalidate(project)
    os.remove(identity_path(project))
end

---@param project string
---@param engine string
---@param target string
---@param version string
function M.mark(project, engine, target, version)
    local file = assert(io.open(identity_path(project), 'wb'))
    file:write(identity(engine, target, version))
    file:close()
end

return M
