local fu = require "Lua.utils.FileUtils"
local path = require "Lua.path"

local preslk = {}

local REFERENCE_SECTIONS = {
	Atta = true,
	Attr = true,
	Defe = true,
	For2 = true,
	LiRe = true,
	Life = true,
	Spel = true
}
local REFERENCE_PARENTS = {
	Atta = "Amls",
	Attr = "Amls",
	Defe = "Amls",
	For2 = "Amls",
	LiRe = "Amls",
	Life = "Amls",
	Spel = "AHfs"
}

local TOKEN_MACROS = {
	Atta = { DataA = "VALUE_ATTACK" },
	Attr = { DataA = "VALUE_ATTR" },
	Defe = { DataA = "VALUE_DEFENSE" },
	For2 = { DataA = "VALUE_FORMULA2" },
	LiRe = { DataA = "VALUE_LIFE_REGEN" },
	Life = { DataA = "VALUE_LIFE" },
	Spel = {
		DataA = "VALUE_FORMULA1_STR",
		DataB = "VALUE_FORMULA1_AGI",
		DataC = "VALUE_FORMULA1_INT",
		DataD = "VALUE_FORMULA1_MAIN"
	}
}

local function formatNumber(value)
	local text = string.format("%.6f", value)
	text = text:gsub("(%..-)0+$", "%1")
	text = text:gsub("%.$", "")
	return text
end

local function hasReferenceContent(content)
	for sectionName in pairs(REFERENCE_SECTIONS) do
		if content:find("<" .. sectionName .. ",", 1, true) then
			return true
		end
		if content:find("[" .. sectionName .. "]", 1, true) then
			return true
		end
	end
	return false
end

local function parseSpellDataMacros(spellDataPath)
	local content = fu.GetContent(spellDataPath)
	if not content then
		return nil, "无法读取技能数值文件:" .. tostring(spellDataPath)
	end

	local macros = {}
	for line in content:gmatch("[^\r\n]+") do
		local name, levelText, valueText = line:match("^%s*#define%s+(VALUE_[A-Z0-9_]+)_(%d+)%s+([+-]?%d+%.?%d*)")
		if name and levelText and valueText then
			local family = macros[name]
			if not family then
				family = {}
				macros[name] = family
			end
			family[tonumber(levelText)] = tonumber(valueText)
		end
	end

	return macros
end

local function isReferenceSection(lines, startIndex, sectionName)
	local expectedParent = REFERENCE_PARENTS[sectionName]
	if not expectedParent then
		return false
	end

	local hasExpectedParent = false
	local hasReferenceName = false
	for i = startIndex + 1, #lines do
		local line = lines[i]
		if line:match("^%s*%[[^%]]+%]") then
			break
		end
		if line:match('^%s*_parent%s*=%s*"' .. expectedParent .. '"') then
			hasExpectedParent = true
		end
		if line:match("^%s*Name%s*=") and line:find("参考值", 1, true) then
			hasReferenceName = true
		end
		if hasExpectedParent and hasReferenceName then
			return true
		end
	end
	return false
end

local function splitLines(content)
	local lines = {}
	for line in (content .. "\n"):gmatch("(.-)\n") do
		if line:sub(-1) == "\r" then
			line = line:sub(1, -2)
		end
		lines[#lines + 1] = line
	end
	return lines
end

local function removeReferenceSections(content)
	local lines = splitLines(content)
	local out = {}
	local removedCount = 0
	local i = 1
	while i <= #lines do
		local line = lines[i]
		local sectionName = line:match("^%s*%[([^%]]+)%]")
		if sectionName and REFERENCE_SECTIONS[sectionName] and isReferenceSection(lines, i, sectionName) then
			removedCount = removedCount + 1
			i = i + 1
			while i <= #lines and not lines[i]:match("^%s*%[[^%]]+%]") do
				i = i + 1
			end
		else
			out[#out + 1] = line
			i = i + 1
		end
	end
	return table.concat(out, "\n"), removedCount
end

local function findResidualReferenceToken(content)
	for sectionName in pairs(REFERENCE_SECTIONS) do
		local token = content:match("<" .. sectionName .. ",[^>]->")
		if token then
			return token
		end
	end
	return nil
end

local function expandReferenceTokens(content, macros)
	local replacedCount = 0
	local missing = {}

	local expanded = content:gsub("<([A-Za-z0-9]+),(Data[A-D])(%d+)([^>]*)>", function(sectionName, dataField, levelText, suffix)
		local original = "<" .. sectionName .. "," .. dataField .. levelText .. suffix .. ">"
		local mapping = TOKEN_MACROS[sectionName]
		local macroName = mapping and mapping[dataField]
		if not macroName then
			return original
		end

		local level = tonumber(levelText)
		local family = macros[macroName]
		local value = family and family[level]
		if value == nil then
			missing[#missing + 1] = original .. " -> " .. macroName .. "_" .. tostring(levelText)
			return original
		end

		if suffix:find("%", 1, true) then
			value = value * 100
		end
		replacedCount = replacedCount + 1
		return formatNumber(value)
	end)

	local genericCount = 0
	expanded = expanded:gsub("<Atta,DataA等级>", function()
		genericCount = genericCount + 1
		return "对应等级攻击参考值"
	end)

	if #missing > 0 then
		return nil, "技能公式预处理缺少宏定义:" .. table.concat(missing, ", ")
	end

	return expanded, nil, replacedCount + genericCount
end

local function transformAbility(content, macros)
	local expanded, expandErr, replacedCount = expandReferenceTokens(content, macros)
	if not expanded then
		return nil, expandErr
	end

	local withoutSections, removedCount = removeReferenceSections(expanded)
	local residual = findResidualReferenceToken(withoutSections)
	if residual then
		return nil, "技能公式预处理后仍残留引用:" .. residual
	end

	return withoutSections, nil, replacedCount, removedCount
end

function preslk.prepareAbilityFormula()
	local abilityPath = path.table and path.table.ability
	if not abilityPath or not fu.fileExist(abilityPath) then
		return nil, nil
	end

	local original = fu.GetContent(abilityPath)
	if not original or not hasReferenceContent(original) then
		return nil, nil
	end

	local spellDataPath = path.project .. "/edit/ability/base/SpellData.j"
	if not fu.fileExist(spellDataPath) then
		return nil, "技能公式预处理需要数值源文件:" .. spellDataPath
	end

	local macros, macroErr = parseSpellDataMacros(spellDataPath)
	if not macros then
		return nil, macroErr
	end

	local transformed, transformErr, replacedCount, removedCount = transformAbility(original, macros)
	if not transformed then
		return nil, transformErr
	end

	local ok, writeErr = fu.WriteOver(abilityPath, transformed)
	if not ok then
		return nil, writeErr
	end

	print(string.format("[物编公式预处理] 临时展开 %s，替换%d处，移除%d个参考段。", abilityPath, replacedCount or 0, removedCount or 0))
	local restored = false
	return function()
		if restored then
			return
		end
		restored = true
		local restoreOk, restoreErr = fu.WriteOver(abilityPath, original)
		if restoreOk then
			print("[物编公式预处理] 已恢复原始ability.ini。")
		else
			print("[物编公式预处理] 恢复ability.ini失败:" .. tostring(restoreErr))
		end
	end, nil
end

function preslk.prepare()
	return preslk.prepareAbilityFormula()
end

return preslk
