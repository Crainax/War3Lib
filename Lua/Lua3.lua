-- -- 这里主要来测试一些常用功能
-- print(string.format("%0.2f", 0.6333 * math.log(2400) - 2.7735))
-- for k, v in pairs(package.loaded) do
-- 	print(k, v)
-- end
-- print(tonumber("1.02"))
-- 测试一下
local lists = {
	-- 'ABC', -- 内容1
	-- 'BCA', -- 内容1
	-- 'DEF', -- 内容1
	-- 'EDF', -- 内容1
	'AFB', -- 内容1
	'CFA', -- 内容1
	'DEB', -- 内容1
	'EFD', -- 内容1
	'FBC', -- 内容1
	'DEF', -- 内容1
	'EFC', -- 内容1
	'ADC', -- 内容1
	'ADF', -- 内容1
	'AEC', -- 内容1
	'BCE', -- 内容1
	'BCA', -- 内容1
}

-- 传参:4个内容进来
local function panduan(str4)
	local matrix = {{}, {}, {}, {}} -- 储存变量
	local l = {} -- 内置判断首位
	local result = {}
	for i = 1, 4 do
		for j = 1, 3 do
			matrix[i][j] = string.sub(str4[i], j, j) --
		end
	end
	local str = ''
	local times = 0
	for i = 1, 4 do
		for j = 1, 3 do
			local value = matrix[i][j]
			local b = true
			str = str .. value --
			if j == 1 then -- 首位
				if not (l[value]) then -- 首位不重复
					l[value] = true
				else
					b = false
				end
			end
			if b then -- 验证完毕
				result[value] = (result[value] or 0) + 1
				times = times + 1
			end
		end
		str = str .. '\n'
	end
	local match = times == 12
	for key, value in pairs(result) do match = match and tonumber(value) == 2 end
	if match then print('找到解了:\n' .. str) end
end

local function parse(str, list)
	local str1 = string.sub(str, 1, 1)
	local str2 = string.sub(str, 1, 1)
	local str3 = string.sub(str, 1, 1)
	if not (list[str1 .. 'F']) then -- 前提是不能有过初次
		list[str1] = list[str1] + 1
		list[str2] = list[str2] + 1
		list[str3] = list[str3] + 1
		list[str1 .. 'F'] = true
		return true
	end
end

local function next(list)
	return (list.a <= 2) and (list.b <= 2) and (list.c <= 2) and (list.d <= 2) and (list.e <= 2) and (list.f <= 2)
end

local function test()
	for i1, value1 in ipairs(lists) do
		for i2, value2 in ipairs(lists) do --
			if value2 ~= value1 then
				for i3, value3 in ipairs(lists) do --
					if value3 ~= value2 and value3 ~= value1 then
						for i4, value4 in ipairs(lists) do --
							if value4 ~= value3 and value4 ~= value2 and value4 ~= value1 then --
								panduan({value1, value2, value3, value4})
							end
						end
					end
				end
			end
		end
	end

end

test()
-- panduan({'ABC', 'BCA', 'DEF', 'EDF'})

-- CFA
-- DEB
-- EFD
-- BCA

-- EFC
-- DEB
-- ADF
-- BCA

-- CFA
-- DEB
-- ADF
-- BCE
