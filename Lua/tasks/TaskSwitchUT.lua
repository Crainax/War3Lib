local FileUtils = require("lua.utils.FileUtils")
local path = require("lua.path")

FileUtils.ExecuteFile(path.alljass, function(line)
	if (string.match(line, "^%s*#undef%s*UnitTestMode")) then
		print("当前状态[测试环境]")
        return string.gsub(line,"#undef","#define")
	elseif (string.match(line, "^%s*#define%s*UnitTestMode")) then
		print("当前状态[正式环境]")
        return string.gsub(line,"#define","#undef")
	end
	return line
end)
