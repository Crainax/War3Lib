local runtime = require 'jass.runtime'
local console = require 'jass.console'
local log = require 'jass.log'
local japi = require 'jass.japi'

local base = {}

-- base.release = not pcall(require, 'lua.currentpath')

-- 判断JAPI环境状态
base.has_inner_japi = pcall(function()
    -- 实际尝试调用SetOwner来测试是否可用
    japi.SetOwner('测试')
    return true
end)

-- 版本号
base.version = '4.18'

-- 错误处理函数
function base.error_handle(msg)
	print("---------------------------------------")
	print(tostring(msg) .. "\n")
	print(debug.traceback())
	print("---------------------------------------")
end

-- 错误汇报
function runtime.error_handle(msg) base.error_handle(msg) end

-- 修改日志路径
local function split(str, p)
	local rt = {}
	string.gsub(str, '[^' .. p .. ']+', function(w) table.insert(rt, w) end)
	return rt
end
log.path = 'War3Lib\\日志\\' .. split(log.path, '\\')[2]

-- 重载打印函数
local std_print = print
function print(...)
	log.info(...)
	return std_print(...)
end

local log_error = log.error
function log.error(...)
	local trc = debug.traceback()
	log_error(...)
	log_error(trc)
	std_print(...)
	std_print(trc)
end

-- 根据发布状态设置调试选项
-- if base.release then
--     -- 正式版环境
--     console.enable = false
--     print("当前版本: 正式版")
--     -- 设置正式版分包路径
--     package.path = package.path .. [[;Poi\]] .. base.version .. [[\?.lua;scripts\?.lua]]
-- else
    -- 测试版环境
    console.enable = true
    runtime.debugger = 4279
    print("当前版本: 测试版")
-- end

-- 输出JAPI状态
if base.has_inner_japi then
    print("JAPI环境: 内置JAPI模式")
    -- 在内置JAPI环境中重载BJDebugMsg
    local code = require 'jass.code'
    local oldBJDebugMsg = code.BJDebugMsg
    code.BJDebugMsg = function(s)
        oldBJDebugMsg(s)
        print(s)
    end
else
    print("JAPI环境: YDLua")
end

-- 将句柄等级设置为0(地图中所有的句柄均使用table封装)
runtime.handle_level = 0

-- 关闭等待
runtime.sleep = false


return base
