local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local fu = require("Lua.utils.FileUtils")
local taskStartClock = os.clock()

local root, projectPath, we, buildVersion, gamePath

local function printTaskEnd()
	local elapsed = os.clock() - taskStartClock
	local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
	if path.buildString and path.buildString ~= "" then
		print("---任务结束---" .. path.buildString .. elapsedStr)
	else
		print("---任务结束---" .. elapsedStr)
	end
end

local function parseBuildVersion(versionArg)
	if versionArg == "VERSION_ALPHA" then
		return "内测版本"
	elseif versionArg == "VERSION_BETA" then
		return "公测版本"
	elseif versionArg == "VERSION_RELEASE" then
		return "正式版本"
	elseif versionArg == "VERSION_UNITTEST" then
		return "单元测试"
	elseif versionArg == "VERSION_MODELTEST" then
		return "模型测试"
	end
	return nil
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
	error("error: 请输入地图路径")
	return
end

if arg[3] ~= nil and arg[3] ~= "" then
	we = arg[3]
else
	error("error: 请输入WE路径")
	return
end

if arg[4] ~= nil then
	buildVersion = parseBuildVersion(arg[4])
end

if not buildVersion then
	error("error: 请输入启动版本:内测版本,公测版本,正式版本,单元测试,模型测试")
	return
end
if arg[5] ~= nil and arg[5] ~= "" then
	gamePath = arg[5]
end

path.init(root, projectPath, we, gamePath)
tc.ChangeBuildVersion(buildVersion)

local checkOk = compiler:StartCompileCheckOnly(path)
if not checkOk then
	print("[Obj缓存]检测失败,停止构建")
	return
end

w3xlni:StartOBJ()

local map = path.project .. "/" .. path.mapName .. ".w3x"
local tarMap = path.project .. "/output/" .. path.mapName .. "_obj.w3x"
local outputDir = fu.GetDir(tarMap)

if not fu.DirExist(outputDir) then
	fu.createDir(outputDir)
end

if not fu.fileExist(map) then
	print("[Obj缓存]构建失败,找不到中间文件: " .. map)
	return
end

local copyOk, copyMsg = copy.CopyBin(map, tarMap)
if copyOk then
	os.remove(map)
	print("[Obj缓存]构建完成: " .. tarMap)
else
	print("[Obj缓存]复制失败: " .. tostring(copyMsg))
	return
end

printTaskEnd()
