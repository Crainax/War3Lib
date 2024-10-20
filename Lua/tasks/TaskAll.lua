local tc = require("lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("lua.compile.W3xLni")
local launcher = require("lua.compile.Launcher")

-- 打开模型测试
if arg[1] == "M" then
	tc.OpenModelTest()
end
local sur = compiler.StartCompile()
if sur then
	w3xlni.StartSLK()
	launcher.StartWar3('_slk')
end
