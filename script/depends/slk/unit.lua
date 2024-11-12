local code = require 'jass.code'
local slk = require 'jass.slk'

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

print('初始化SLK库[单位]')
