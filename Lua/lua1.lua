local bit32 = require("bit32")

local function StringHash(s)
	if not s then
		return 0
	end

	local seed1 = 0x7FED7FED
	local seed2 = 0xEEEEEEEE

	-- 魔兽原生中会将输入转成大写
	s = string.upper(s)

	for i = 1, #s do
		local c = string.byte(s, i)

		-- 注意确保中间结果都在 32 位范围内
		seed1 = bit32.band(seed1, 0xFFFFFFFF)
		seed2 = bit32.band(seed2, 0xFFFFFFFF)

		local temp = bit32.bxor(seed1, c)
		seed1 = temp + bit32.lshift(seed1, 26) + bit32.lshift(seed1, 16) - seed1
		seed1 = bit32.band(seed1 + seed2, 0xFFFFFFFF)

		seed2 = c + bit32.bxor(seed2, bit32.rshift(seed1, 5) + bit32.lshift(seed1, 2))
		seed2 = bit32.band(seed2, 0xFFFFFFFF)
	end

	-- 函数最后会返回有符号整型，但往往直接取 31 位无符号即可
	return bit32.band(seed1, 0x7FFFFFFF)
end

-- 测试
print(StringHash("GJ")) -- 1345957883
