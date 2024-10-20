local path = require "lua.path"
local fu = require "lua.utils.FileUtils"
local copy = require "lua.compile.Copy"
local tc = require "lua.compile.TestControl"

-- 库
local utr = {}

-- 不复制的列表
local ncList = {
	"Art", -- 防内联
	"Missileart_1", -- 防内联
	"file", -- 防内联
}

-- local reBLP = [["UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"]]
local reBLP = [["UI\\Widgets\\EscMenu\\Human\\editbox-background.blp"]]

-- 将地图里的war3map用到的物遍移到单元测试里面
utr.ReplaceTable = function()
	local result = fu.GetContent(path.ut.mapJ)
	local units = {}
	local items = {}
	local abilities = {}
	for w in result:gmatch("'([hHuUnN][0-9a-zA-Z]+)'") do units[w] = true end
	for w in result:gmatch("'([iI][0-9a-zA-Z]+)'") do items[w] = true end
	for w in result:gmatch("'([aAsS][0-9a-zA-Z]+)'") do abilities[w] = true end
	fu.WriteOver(path.ut.table.unit, "")
	fu.WriteOver(path.ut.table.item, "")
	fu.WriteOver(path.ut.table.ability, "")
	local tran = false -- 转移判断位

	-- 单位物编的转移
	fu.ReadFile(path.table.unit, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if units[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.unit, line .. "\n")
		end
	end)

	-- 物品物编的转移
	fu.ReadFile(path.table.item, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if items[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.item, line .. "\n")
		end
	end)

	-- 技能物编的转移
	fu.ReadFile(path.table.ability, function(line)
		local id = line:match("%[([0-9a-zA-Z]+)%]")
		if id then
			-- 名字定义行,决定这个ID的所有东西是否转移到单元测试那边
			if abilities[id] then
				-- 匹配到了同名物编
				tran = true
			else
				-- 未匹配到,跳过
				tran = false
			end
		end

		-- 复制过去,但是几个子项目不复制.
		if tran then
			for _, value in ipairs(ncList) do if line:match("^%s*" .. value) then return end end
			fu.WriteLast(path.ut.table.ability, line .. "\n")
		end
	end)

	copy.CopyFile(path.table.upgrade, path.ut.table.upgrade)
	copy.CopyFile(path.table.buff, path.ut.table.buff)
	copy.CopyFile(path.table.misc, path.ut.table.misc)
end

-- 清除临时物编
utr.RemoveTable = function()
	os.remove(path.ut.table.item)
	os.remove(path.ut.table.unit)
	os.remove(path.ut.table.ability)
	os.remove(path.ut.table.upgrade)
	os.remove(path.ut.table.buff)
	os.remove(path.ut.table.misc)
	fu.ForDir(path.project .. '/UnitTestMap/map', function(fileName)
		if fileName:sub(#fileName - 2, #fileName):lower() == 'lua' then os.remove(fileName) end
	end)
end

-- 替代特效与图标
utr.ReplaceMapJ = function()
	local block = true
	fu.ExecuteFile(path.ut.mapJ, function(line)
		if line:match("//blpend") then
			block = true
		elseif line:match("//blp") then
			block = false
		end
		if block then
			local result = line:match('[,=]%s*(".*%.blp")')
			if result then line = line:gsub('".*%.blp"', reBLP) end
			if line:match('[,=]%s*(".*%.tga")') then line = line:gsub('".*%.tga"', reBLP) end
		end
		return line
	end)
end

-- 移所有LUA过去
utr.MoveLuaFile = function()
	fu.ForDir(path.project .. '/OriginMap/map', function(fileName)
		local name, format = fu.GetFile(fileName)
		if tostring(format):lower() == 'lua' then copy.CopyFile(fileName, path.project .. '/UnitTestMap/map/' .. name .. "." .. format) end
	end)
end

-- 替换物编
-- utr.ReplaceTable()

-- 替代特效与图标
-- utr.ReplaceMapJ()

-- 清除临时物编
-- utr.RemoveTable()

-- 转移所有lua文件过去
-- utr.MoveLuaFile()

return utr

