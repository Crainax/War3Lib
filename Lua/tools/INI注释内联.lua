--[[
    INI注释内联处理工具
    功能: 将INI文件中独立的注释行合并到下一个非注释行的末尾

    处理前:
    -- 这是一个注释
    name=战士

    处理后:
    name=战士 -- 这是一个注释

    用途: 主要用于处理魔兽地图的配置文件,使配置项和其说明保持在同一行
]]

local fileUtils = require("lua.utils.FileUtils")
local path = require("lua.path")

-- local filePath = "D:/War3/Maps/PhantomOrbit/lua/utils/FileUtils.lua"
local filePath = "D:/War3/Maps/PhantomOrbit/OriginMap/table/unit.ini"

-- 用于暂存上一个注释行
local common
fileUtils.ExecuteFile(filePath, function(line)
	-- 如果当前行是注释行(以--开头),则暂存该注释
	if string.match(line, "^%s*%-%-") then
		common = line
	else
		-- 如果当前行不是注释行,且存在暂存的注释
		-- 则将注释追加到当前行末尾,并清空暂存
		if common then
			line = line .. " " .. common
			common = nil
		end
		return line
	end
end)
print("结束了")
