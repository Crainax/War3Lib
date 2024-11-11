local runtime = require 'jass.runtime'
local console = require 'jass.console'
local log = require 'jass.log'

local base = {}

-- 判断是否是发布版本
-- base.release = not pcall(require, 'lua.currentpath')

-- 版本号
-- base.version = '4.18'

-- 打开控制台
-- if not base.release then
-- 	console.enable = true
-- end

-- 将句柄等级设置为0(地图中所有的句柄均使用table封装)
-- runtime.handle_level = 0

-- 关闭等待
-- runtime.sleep = false

--- 错误处理函数
--- @param msg any 错误信息，可以是任意类型
function base.error_handle(msg)
	print("---------------------------------------")

	-- 将错误信息转换为字符串并打印
	-- tostring() 确保即使是 table 或其他类型也能被正确打印
	-- \n 添加换行符使输出更易读
	print(tostring(msg) .. "\n")

	-- 打印调用堆栈信息
	-- debug.traceback() 会显示:
	-- 1. 错误发生的具体文件和行号
	-- 2. 完整的函数调用链（从触发错误的位置一直到调用的起点）
	-- 3. 每个调用所在的函数名称
	print(debug.traceback())

	print("---------------------------------------")
end

-- 错误汇报(runtime的报错最终包装成)
function runtime.error_handle(msg) base.error_handle(msg) end

-- 测试版本和发布版本的脚本路径
-- if base.release then
-- 	print("正式版分包:Crainax")
-- 	package.path = package.path .. [[;Poi\]] .. base.version .. [[\?.lua;scripts\?.lua]]
-- end

-- if not base.release then
-- 	-- 调试器端口
-- 	print("测试版分包:Crainax")
-- 	runtime.debugger = 4279
-- end

-- 修改日志路径,打印日志到本地
local function split(str, p)
	local rt = {}
	local s = string.gsub(str, '[^]' .. p .. ']+', function(w) table.insert(rt, w) end)
	return rt
end
log.path = '创世轨迹\\日志\\' .. split(log.path, '\\')[2]

-- 重载打印函数,全部都输出到日志里
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

local code = require 'jass.code'
local oldBJDebugMsg = code.BJDebugMsg -- 保存原始函数引用
code.BJDebugMsg = function(s)         -- 创建新函数
	oldBJDebugMsg(s)                  -- 调用原始函数
	print(s)                          -- 添加新功能
end
