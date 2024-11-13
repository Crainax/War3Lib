local jass = require 'jass.common'
local console = require 'jass.console'
local log = require 'jass.log'
local code = require 'jass.code'

local mt = {}

-- 日志级别列表
local LOG_LEVELS = { 'trace', 'debug', 'info', 'warn', 'error' }

-- 生成针对特定玩家的日志函数
for _, level in ipairs(LOG_LEVELS) do
    mt[level] = function(player, msg)
        if player == jass.GetLocalPlayer() then
            log[level](msg)
            console.write(msg)
        end
    end
    code[level:sub(1, 1):upper() .. level:sub(2) .. 'ToPlayer'] = mt[level]
end

-- 生成针对所有玩家的日志函数
for _, level in ipairs(LOG_LEVELS) do
    local funcName = level .. 'All'
    mt[funcName] = function(msg)
        log[level](msg)
        console.write(msg)
    end
    code[level:sub(1, 1):upper() .. level:sub(2)] = mt[funcName]
end

console.write("[日志系统]初始化成功.")
return mt
