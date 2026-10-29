local M = {}
local current, currentName
local prefix = 'script.experiments.innerjapi.cases.'
local function checkName(name)
    assert(type(name) == 'string' and name:sub(1, #prefix) == prefix, '只能加载实验cases模块')
end
function M.stop()
    if current then
        -- Keep ownership if cleanup fails; never start another case on top of it.
        current.stop()
        current = nil
    end
end
function M.start(name)
    checkName(name)
    M.stop()
    local module = require(name)
    assert(type(module) == 'table' and type(module.start) == 'function' and type(module.stop) == 'function',
        '实验模块必须提供start和stop')
    current, currentName = module, name
    local ok, err = xpcall(module.start, debug.traceback)
    if not ok then
        local clean, cleanupErr = pcall(M.stop)
        error(err .. (clean and '' or ('\n清理失败: ' .. tostring(cleanupErr))))
    end
    print('[InnerJapi实验]启动: ' .. name)
    return module
end
function M.reload()
    assert(currentName, '还没有选择实验')
    local name = currentName
    M.stop()
    -- Deliberately keep dependencies and engine modules cached.
    package.loaded[name] = nil
    return M.start(name)
end
return M
