-- main.lua

-- 重载函数
local function reload_module(module_name)
    print("\n正在重载模块: " .. module_name)
    package.loaded[module_name] = nil
    return require(module_name)
end

-- 打印分隔线
local function print_separator()
    print("\n" .. string.rep("-", 50))
end

-- 开始测试
print("测试开始")
print_separator()

-- 1. 首次加载模块
print("1. 首次加载模块")
local test_module = require("Lua.learn.hotfix.test_module")
test_module.status()
print("消息:", test_module.getMessage())

-- 2. 测试计数器
print_separator()
print("2. 测试计数器")
print("增加计数:", test_module.increment())
print("增加计数:", test_module.increment())
test_module.status()

-- 3. 现在暂停，等待修改 test_module.lua 文件
print_separator()
print("3. 请现在修改 test_module.lua 文件，然后按回车继续...")
io.read()

-- 4. 重载模块
print_separator()
print("4. 重载模块后的状态")
test_module = reload_module("Lua.learn.hotfix.test_module")
test_module.status()
print("消息:", test_module.getMessage())

-- 5. 测试重载后的计数器
print_separator()
print("5. 测试重载后的计数器")
print("增加计数:", test_module.increment())
test_module.status()

print_separator()
print("测试结束")
