local FileUtils = require("lua.utils.FileUtils")
local path = require("lua.path")

FileUtils.ExecuteFile(path.alljass, function(line)
	if (string.match(line, "^%s*#undef%s*NormalUnitTestMode")) then
		print("当前使用地图[正式地图]")
		return string.gsub(line, "#undef", "#define")
	elseif (string.match(line, "^%s*#define%s*NormalUnitTestMode")) then
		print("当前使用地图[单测地图]")
		return string.gsub(line, "#define", "#undef")
	end
	return line
end)
