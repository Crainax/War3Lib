local M = {
    version = 1,
    count = 0
}

-- 一个简单的计数器
function M.increment()
    M.count = M.count + 1
    return M.count
end

-- 打印当前状态
function M.status()
    print(string.format("Version: %d, Count: %d", M.version, M.count))
end

-- 获取一个消息（用于演示热更新后内容变化）
function M.getMessage()
    return "这是原始消息 - Version " .. M.version
end

return M


--[[ -- test_module.lua 的修改版本
local M = {
    version = 2, -- 修改版本号
    count = 0
}

function M.increment()
    M.count = M.count + 1
    return M.count
end

function M.status()
    print(string.format("Version: %d, Count: %d", M.version, M.count))
end

function M.getMessage()
    return "这是更新后的新消息 - Version " .. M.version -- 修改消息
end

-- 添加新函数
function M.new_function()
    return "这是热更新后新增的函数"
end

return M
 ]]
