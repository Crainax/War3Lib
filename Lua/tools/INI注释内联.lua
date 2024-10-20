local fileUtils = require("lua.utils.FileUtils")
local path = require("lua.path")

-- local filePath = "D:/War3/Maps/PhantomOrbit/lua/utils/FileUtils.lua"
local filePath = "D:/War3/Maps/PhantomOrbit/OriginMap/table/unit.ini"

local common
fileUtils.ExecuteFile(filePath, function(line)
	if string.match(line, "^%s*%-%-") then
		common = line
	else
		if common then
			line = line .. " " .. common
			common = nil
		end
		return line
	end
end)
print("结束了")
