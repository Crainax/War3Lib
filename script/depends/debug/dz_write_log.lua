local jass = require 'jass.common'
local g = require 'jass.globals'
local dbg = require 'jass.debug'

g.dzWriteLog_tr = jass.CreateTrigger()
dbg.handle_ref(g.dzWriteLog_tr)
jass.TriggerAddCondition(g.dzWriteLog_tr, jass.Condition(function()
    print(tostring(g.dzWriteLog_msg or ''))
end))

print("DzWriteLog Lua 桥注入成功")

return true
