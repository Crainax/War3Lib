local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local launcher = require("Lua.compile.Launcher")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local fu = require("Lua.utils.FileUtils")
local taskStartClock = os.clock()

local root, projectPath, we, buildVersion

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

local function ensureObjCache()
	local cacheMap = path.project .. "/output/" .. path.mapName .. "_obj.w3x"
	if fu.fileExist(cacheMap) then
		return true
	end

	print("[Obj快启]检测到缓存缺失,开始自动构建: " .. cacheMap)
	local checkOk = compiler:StartCompileCheckOnly(path)
	if not checkOk then
		print("[Obj快启]自动构建缓存失败(检测阶段失败)")
		return false
	end

	w3xlni:StartOBJ()
	local map = path.project .. "/" .. path.mapName .. ".w3x"
	local outputDir = path.project .. "/output"
	if not fu.DirExist(outputDir) then
		fu.createDir(outputDir)
	end
	if not fu.fileExist(map) then
		print("[Obj快启]自动构建缓存失败,找不到中间文件: " .. map)
		return false
	end

	local copyOk, copyMsg = copy.CopyBin(map, cacheMap)
	if not copyOk then
		print("[Obj快启]自动构建缓存失败,复制错误: " .. tostring(copyMsg))
		return false
	end

	os.remove(map)
	print("[Obj快启]自动构建缓存完成: " .. cacheMap)
	return true
end

local function replaceMapScriptWithStorm()
	local cacheMap = path.project .. "/output/" .. path.mapName .. "_obj.w3x"
	local w2lRoot = path.toolRoot .. "/w3x2lni"
	local w2lLuaExe = w2lRoot .. "/bin/w3x2lni-lua.exe"
	local stormTask = path.libRoot .. "/Lua/tasks/TaskStormReplaceWar3MapJ.lua"
	local function toWinPath(v)
		return tostring(v):gsub("/", "\\")
	end

	if not fu.fileExist(w2lLuaExe) then
		print("[Obj快启]未找到w3x2lni-lua.exe: " .. w2lLuaExe)
		return false
	end
	if not fu.fileExist(stormTask) then
		print("[Obj快启]未找到Storm替换脚本: " .. stormTask)
		return false
	end
	if not fu.fileExist(cacheMap) then
		print("[Obj快启]未找到Obj缓存地图: " .. cacheMap)
		return false
	end
	if not fu.fileExist(path.CompileResult) then
		print("[Obj快启]未找到编译输出脚本: " .. path.CompileResult)
		return false
	end

	local cmd = string.format(
		'cmd /c ""%s" "%s" "%s" "%s" "%s""',
		toWinPath(w2lLuaExe),
		toWinPath(stormTask),
		toWinPath(cacheMap),
		toWinPath(path.CompileResult),
		toWinPath(w2lRoot)
	)
	print(cmd)
	local exSuc = os.execute(cmd)
	if not exSuc then
		print("[Obj快启]Storm替换执行失败")
		return false
	end
	return true
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

path.init(root, projectPath, we)
tc.ChangeBuildVersion(buildVersion)

local compileOk = compiler:StartCompile(path)
if not compileOk then
	print("[Obj快启]完整编译失败,停止启动")
	return
end

if not ensureObjCache() then
	return
end

if not replaceMapScriptWithStorm() then
	return
end

launcher.StartWar3('_obj')

printTaskEnd()
