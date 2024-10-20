local pos1 = { 1.0, 12 }
local pos2 = { 0.733, 18 }

local function cal()
    print(pos2[1])
    local k = (pos2[2] - pos1[2]) / (pos2[1] - pos1[1])
    local b = pos1[2] - k * pos1[1]
    return k, b
end

local k, b = cal()
print('函数式:y=' .. k .. 'x+' .. b)
