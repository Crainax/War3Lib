local runtime = require 'jass.runtime'
local console = require 'jass.console'
local log = require 'jass.log'
local japi = require 'jass.japi'
local jass = require 'jass.common'

package.log_dir = 'War3Lib\\日志\\'

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

-- 错误汇报
function runtime.error_handle(msg) base.error_handle(msg) end

-- 修改日志路径
local function basename(path)
	if type(path) ~= 'string' then
		return 'log.log'
	end
	return path:match('[^\\/:]+$') or path
end

local function split_ext(filename)
	local name, ext = filename:match('^(.*)(%.[^%.]*)$')
	if name then
		return name, ext
	end
	return filename, ''
end

local function make_log_instance_id()
	local ok, pid = pcall(function()
		return jass.GetPlayerId(jass.GetLocalPlayer()) + 1
	end)
	if ok and type(pid) == 'number' and pid >= 1 then
		return 'P' .. tostring(pid)
	end
	return 'P0'
end

local log_file = basename(log.path)
local log_name, log_ext = split_ext(log_file)
base.log_instance_id = make_log_instance_id()
if not log_name:match('%-P%d+$') then
	log_name = log_name .. '-' .. base.log_instance_id
end
log.path = package.log_dir .. log_name .. log_ext

-- 重载打印函数
local std_print = print
function print(...)
	log.info(...)
	return std_print(...)
end

-- 错误处理函数
function base.error_handle(msg)
    print("---------------------------------------")
    print(tostring(msg) .. "\n")
    print(debug.traceback())
    print("---------------------------------------")
end

local log_error = log.error
function log.error(...)
	local trc = debug.traceback()
	log_error(...)
	log_error(trc)
	std_print(...)
	std_print(trc)
end

console.enable = package.console_enable == true
if console.enable then
    runtime.debugger = 4279
end
print("当前版本: " .. tostring(package.build_version or "未知版本"))

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
    local hook = require 'jass.hook'
    local display_logger = nil
    local old_display_text = jass.DisplayTextToPlayer
    local old_display_timed = jass.DisplayTimedTextToPlayer

    local function capture_display(toPlayer, message)
        if not display_logger then
            local logger_ok, loaded_logger = pcall(require, 'depends.debug.logger')
            if logger_ok then
                display_logger = loaded_logger
            end
        end
        if display_logger and display_logger.display then
            pcall(display_logger.display, toPlayer, message)
        end
    end

    function hook.DisplayTextToPlayer(toPlayer, x, y, message)
        capture_display(toPlayer, message)
        old_display_text(toPlayer, x, y, message)
    end

    function hook.DisplayTimedTextToPlayer(toPlayer, x, y, duration, message)
        capture_display(toPlayer, message)
        old_display_timed(toPlayer, x, y, duration, message)
    end
end

-- 将句柄等级设置为0(地图中所有的句柄均使用table封装)
runtime.handle_level = 0

-- 关闭等待
runtime.sleep = false

return base
