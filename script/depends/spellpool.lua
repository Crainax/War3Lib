local msg = require 'jass.message'
local jass = require 'jass.common'
local g = require 'jass.globals'
local debug = require 'jass.debug'

g.spellpool_tr = jass.CreateTrigger()
debug.handle_ref(g.spellpool_tr)
jass.TriggerAddCondition(g.spellpool_tr, jass.Condition(function()
    --todo
    print(jass.GetUnitName(g.spellpool_u) .. "(" .. g.spellpool_u .. ")")
    for i = 0, 3 do
        for j = 0, 2 do
            local ability, order = msg.button(i, j)
            if ability and ability ~= 0 then
                print("第" .. j .. "行第" .. i .. "列:", jass.GetObjectName(ability), order)
            else
                print("第" .. j .. "行第" .. i .. "列:", ability, order)
            end
        end
    end
end))



print("开始测试技能相关内容")
msg.order_enable_debug(true)
