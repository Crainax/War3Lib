local message = require 'jass.message'
local code = require 'jass.code'
local jass = require 'jass.common'
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
-- [技能信息]
code.GetAbilityTip = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Tip end
end
-- [技能信息]
code.GetAbilityUbertip = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Ubertip end
end
-- [技能信息]
code.GetAbilityUntip = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Untip end
end
-- [技能信息]
code.GetAbilityUnubertip = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Unubertip end
end
-- [技能信息]
code.GetAbilityArt = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Art end
	return 0
end
-- [技能信息]
code.GetAbilityRng1 = function(id)
	local ability = slk.ability[id]
	if ability then return math.tointeger(tonumber(ability.Rng1)) end -- 不能传小数,我真的是佛了
	return 0
end
-- [技能信息]
code.GetAbilityArea1 = function(id)
	local ability = slk.ability[id]
	if ability then return math.tointeger(tonumber(ability.Area1)) end
	return 0
end
-- [技能信息]
code.GetAbilityCool1 = function(id)
	local ability = slk.ability[id]
	if ability then return ability.Cool1 end -- 直接传字符串
end
-- [技能信息]
code.GetAbilityCost1 = function(id)
	local ability = slk.ability[id]
	if ability then return math.tointeger(tonumber(ability.Cost1)) end
	return 0
end

-- [单位信息]
code.GetUnitSLKPrimary = function(id)
	local unit = slk.unit[id]
	if unit then return unit.Primary end
	return 0
end
-- [单位信息]
code.GetUnitSLKName = function(id)
	local unit = slk.unit[id]
	if unit then return unit.Name end
	return 0
end
-- [单位信息]
code.GetUnitSLKArt = function(id)
	local unit = slk.unit[id]
	if unit then return unit.Art end
	return 0
end

-- [英雄敏捷->背包的映射关系]
code.GetAgiPckNum = function(agi, mRate)
	local rAgi = 0.01 * (100 + mRate) * agi
	return math.floor(0.6333 * math.log(rAgi) - 2.7735)
end

print('初始化SLK库')
