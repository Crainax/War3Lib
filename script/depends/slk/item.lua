local code = require 'jass.code'
local slk = require 'jass.slk'

-- [物品信息]
code.GetItemGoldCost = function(id)
    local item = slk.item[id]
    if item then return item.goldcost end
    return 0
end
-- [物品信息]
code.GetItemGemCost = function(id)
    local item = slk.item[id]
    if item then return item.lumbercost end
    return 0
end
-- [物品信息]
code.GetItemSLKPrio = function(id)
    local item = slk.item[id]
    if item then return math.tointeger(item.prio) end
    return 0
end
-- [物品信息]
code.GetItemSLKName = function(id)
    local item = slk.item[id]
    if item then return item.Name end
end
-- [物品信息]
code.GetItemSLKArt = function(id)
    local item = slk.item[id]
    if item then return item.Art end
end
-- [物品信息]
code.GetItemSLKUbertip = function(id)
    local item = slk.item[id]
    if item then return item.Ubertip end
end
-- [物品信息]
code.GetItemSLKUsable = function(id)
    local item = slk.item[id]
    if item then return item.usable == '1' end
    return true
end
-- [物品信息]
code.GetItemSLKSellable = function(id)
    local item = slk.item[id]
    if item then return item.pawnable == '1' end
    return true
end
-- [物品信息]
code.GetItemSLKDroppable = function(id)
    local item = slk.item[id]
    if item then return item.droppable == '1' end
    return true
end

print('初始化SLK库[物品]')
