local fu = require "lua.utils.FileUtils"
local path = require "lua.path"

local modules = {}

-- 根据AllJassH文件情况判断返回是不是处于单元测试状态
-- 有时有蛋疼的需求,就在Alljass.h里面改这个吧:#define NormalUnitTestMode
-- 返回的第2个值就是是不是蛋疼的需求
local function GetState()
	local ut, ut2 = false, false
	fu.ReadFile(path.alljass, function(line)
		if (string.match(line, "^%s*#undef%s*UnitTestMode")) then
			ut = false
		elseif (string.match(line, "^%s*#define%s*UnitTestMode")) then
			ut = true
		elseif (string.match(line, "^%s*#define%s*NormalUnitTestMode")) then
			ut2 = true
		end
		return line
	end)
	return ut and not (ut2)
end

-- 直接初始化是否是单元测试,如果是的话就进行
modules.isUnitTest = GetState()
if modules.isUnitTest then
	path.mapJ    = path.ut.mapJ
	path.mapName = path.ut.mapName
	path.state   = "单元测试"
end

-- 是否是模型测试(直接在这里修改)
modules.modeltest = false

-- 打开模型测试模式
modules.OpenModelTest = function()
	path.scriptJ    = path.model.test.script -- 重载需要编译的文件(script.j)
	path.waveResult = string.gsub(path.scriptJ, "%.j", ".i") -- 这个也要修改.
	path.mapName    = path.model.test.mapName
	path.mapJ       = path.model.test.mapJ
	path.state      = "模型测试"
end

return modules
