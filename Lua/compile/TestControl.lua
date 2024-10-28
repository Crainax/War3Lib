local fu = require "Lua.utils.FileUtils"
local path = require("Lua.path")
local tc = {}

--- @alias BuildVersion "单元测试"|"正式版本"|"模型测试"|"内测版本"|"公测版本"
--- @param version BuildVersion
---修改当前的构建版本
tc.ChangeBuildVersion = function(version)
	fu.ExecuteFile(path.alljass, function(line)
		if string.match(line, "^%s*#[ud]efine%s+CURRENT_BUILD_VERSION") then
			-- 修改为单元测试版本
			if version == "单元测试" then
				path.initUnitTest()
				return "#define CURRENT_BUILD_VERSION VERSION_UNITTEST"
			elseif version == "模型测试" then
				path.initModelTest()
				return "#define CURRENT_BUILD_VERSION VERSION_MODELTEST"
			elseif version == "内测版本" then
				path.initAlpha()
				return "#define CURRENT_BUILD_VERSION VERSION_ALPHA"
			elseif version == "公测版本" then
				path.initBeta()
				return "#define CURRENT_BUILD_VERSION VERSION_BETA"
			elseif version == "正式版本" then
				path.initRelease()
				return "#define CURRENT_BUILD_VERSION VERSION_RELEASE"
			end
		end
		return line
	end)
end

-- 根据AllJassH文件情况判断返回是不是处于单元测试状态
tc.GetState = function()
	fu.ReadFile(path.alljass, function(line)
		if string.match(line, "^%s*#define%s+CURRENT_BUILD_VERSION%s+VERSION_ALPHA") then
			path.initAlpha()
		elseif string.match(line, "^%s*#define%s+CURRENT_BUILD_VERSION%s+VERSION_BETA") then
			path.initBeta()
		elseif string.match(line, "^%s*#define%s+CURRENT_BUILD_VERSION%s+VERSION_RELEASE") then
			path.initRelease()
		elseif string.match(line, "^%s*#define%s+CURRENT_BUILD_VERSION%s+VERSION_UNITTEST") then
			path.initUnitTest()
		elseif string.match(line, "^%s*#define%s+CURRENT_BUILD_VERSION%s+VERSION_MODELTEST") then
			path.initModelTest()
		end

		return line
	end)
end

-- path = require("Lua.path")
-- path.init("D:/War3", "D:/War3/Maps/PhantomOrbit", "D:/WE/KKWE_Plugin")
-- print("开始测试:" .. path.alljass)
-- tc.ChangeBuildVersion("单元测试")

return tc
