local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local launcher = require("Lua.compile.Launcher")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local taskStartClock = os.clock()
local root, projectPath, we, gamePath

local function printTaskEnd()
	local elapsed = os.clock() - taskStartClock
	local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
	if path.buildString and path.buildString ~= "" then
		print("---任务结束---" .. path.buildString .. elapsedStr)
	else
		print("---任务结束---" .. elapsedStr)
	end
end

if arg[1] ~= nil and arg[1] ~= "" then
	root = arg[1]
else
	error("error: 请输入项目目录")
	return
end
if arg[2] ~= nil and arg[2] ~= "" then
	projectPath = arg[2]
else
	error("error: 请输入地图名称")
	return
end
if arg[3] ~= nil and arg[3] ~= "" then
	we = arg[3]
else
	error("error: 请输入WE路径")
	return
end
if arg[4] ~= nil and arg[4] ~= "" then
	gamePath = arg[4]
end

path.init(root, projectPath, we, gamePath)
tc.ChangeBuildVersion("单元测试")
path.jassCompiler = "both"
path.jassCompilerSelect = "jasshelper"
path.allowVjasscNonAlpha = true

local sur = compiler:StartCompile(path)

if sur then
	w3xlni:StartSLK()

	local map = path.project .. "/" .. path.mapName .. "_slk.w3x"
	local tarMap = path.project .. "/output/" .. path.mapName .. "_slk.w3x"
	copy.CopyBin(map, tarMap)
	os.remove(map)

	launcher.StartWar3AndWaitLog("_slk")
end

printTaskEnd()
