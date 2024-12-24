local jass = require 'jass.common'
local console = require 'jass.console'
local log = require 'jass.log'
local g = require 'jass.globals'
-- local debug = require 'jass.debug'
local mt = {}

g.logger_tr = jass.CreateTrigger()
-- debug.handle_ref(g.logger_tr)
jass.TriggerAddCondition(g.logger_tr, jass.Condition(function()
    if g.logger_p == jass.GetLocalPlayer() then
        if g.logger_level == 0 then
            log.trace(g.logger_msg)
            print(g.logger_msg)
        elseif g.logger_level == 1 then
            log.debug(g.logger_msg)
            print(g.logger_msg)
        elseif g.logger_level == 2 then
            log.info(g.logger_msg)
            print(g.logger_msg)
        elseif g.logger_level == 3 then
            log.warn(g.logger_msg)
            print(g.logger_msg)
        elseif g.logger_level == 4 then
            log.error(g.logger_msg)
        end
    end
end))

console.write("[日志系统]初始化成功.")
return mt
