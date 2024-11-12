local code = require 'jass.code'
local slk = require 'jass.slk'

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

print('初始化SLK库[技能]')
