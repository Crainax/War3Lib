local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local launcher = require("Lua.compile.Launcher")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local fu = require("Lua.utils.FileUtils")

local taskStartClock = nil

local versions = {
	{ value = "VERSION_ALPHA", label = "内测版本" },
	{ value = "VERSION_BETA", label = "公测版本" },
	{ value = "VERSION_UNITTEST", label = "单元测试" },
	{ value = "VERSION_RELEASE", label = "正式版本" },
}

local launchModes = {
	{ value = "normal", label = "正常" },
	{ value = "direct", label = "直启" },
	{ value = "fast", label = "快启" },
	{ value = "slow", label = "慢启" },
}

local compilers = {
	{ value = "jasshelper", label = "jasshelper" },
	{ value = "vjassc", label = "vjassc" },
	{ value = "compare", label = "vjassc对比" },
}

local versionLabels = {}
local validVersions = {}
for _, item in ipairs(versions) do
	versionLabels[item.value] = item.label
	validVersions[item.value] = true
end

local validActions = { start = true, compile = true }
local validLaunchModes = {}
for _, item in ipairs(launchModes) do
	validLaunchModes[item.value] = true
end
local validCompilers = {}
for _, item in ipairs(compilers) do
	validCompilers[item.value] = true
end

local root, projectPath, we, gamePath
local options = {
	dryRun = false,
	selection = nil,
}

local function commandSucceeded(ok, exitType, exitCode)
	if ok == true or ok == 0 then
		return true
	end
	return exitType == "exit" and exitCode == 0
end

local function toWinPath(value)
	return tostring(value):gsub("/", "\\")
end

local function printTaskEnd()
	local elapsed = taskStartClock and (os.clock() - taskStartClock) or 0
	local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
	if path.buildString and path.buildString ~= "" then
		print("---任务结束---" .. path.buildString .. elapsedStr)
	else
		print("---任务结束---" .. elapsedStr)
	end
end

local function resetTaskClock()
	taskStartClock = os.clock()
end

local function ensureDir(dir)
	if not fu.DirExist(dir) then
		fu.createDir(dir)
	end
end

local function forceCopyBin(src, dst)
	ensureDir(fu.GetDir(dst))
	local ok, msg = copy.CopyBin(src, dst)
	if not ok then
		print("[启动]复制失败: " .. tostring(src) .. " -> " .. tostring(dst) .. " (" .. tostring(msg) .. ")")
	end
	return ok
end

local function parseInlineSelection(value)
	local result = {}
	for key, val in tostring(value or ""):gmatch("([%w_]+)=([^;,]+)") do
		result[key] = val
	end
	return result
end

local function readSelectionFile(filePath)
	local result = {}
	fu.ReadFile(filePath, function(line)
		local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
		if key then
			result[key] = value
		end
	end)
	return result
end

local function writeSelectionFile(filePath, selection)
	ensureDir(fu.GetDir(filePath))
	local file, err = io.open(filePath, "w")
	if not file then
		error("error: 写入启动选择记忆失败: " .. tostring(err))
	end
	file:write("action=", selection.action, "\n")
	file:write("version=", selection.version, "\n")
	file:write("launchMode=", selection.launchMode, "\n")
	file:write("compiler=", selection.compiler, "\n")
	file:close()
end

local function normalizeSelection(selection)
	selection = selection or {}
	if selection.status == "cancel" then
		return nil, "cancel"
	end
	selection.action = selection.action or "start"
	selection.version = selection.version or "VERSION_ALPHA"
	selection.launchMode = selection.launchMode or "normal"
	selection.compiler = selection.compiler or "jasshelper"

	if not validActions[selection.action] then
		return nil, "无效任务类型: " .. tostring(selection.action)
	end
	if not validVersions[selection.version] then
		return nil, "无效版本: " .. tostring(selection.version)
	end
	if not validLaunchModes[selection.launchMode] then
		return nil, "无效启动方式: " .. tostring(selection.launchMode)
	end
	if not validCompilers[selection.compiler] then
		return nil, "无效编译器: " .. tostring(selection.compiler)
	end
	return selection
end

local function parseArgs()
	if arg[1] ~= nil and arg[1] ~= "" then
		root = arg[1]
	else
		error("error: 请输入项目目录")
	end
	if arg[2] ~= nil and arg[2] ~= "" then
		projectPath = arg[2]
	else
		error("error: 请输入地图路径")
	end
	if arg[3] ~= nil and arg[3] ~= "" then
		we = arg[3]
	else
		error("error: 请输入WE路径")
	end

	local i = 4
	while i <= #arg do
		local item = arg[i]
		if item == "--dry-run" then
			options.dryRun = true
		elseif item == "--selection" then
			options.selection = parseInlineSelection(arg[i + 1])
			i = i + 1
		elseif item:match("^%-%-selection=") then
			options.selection = parseInlineSelection(item:match("^%-%-selection=(.*)$"))
		elseif item ~= nil and item ~= "" and not item:match("^%-%-") and not gamePath then
			gamePath = item
		end
		i = i + 1
	end
end

local function initPathOnly(version)
	path.init(root, projectPath, we, gamePath)
	if version == "VERSION_ALPHA" then
		path.initAlpha()
	elseif version == "VERSION_BETA" then
		path.initBeta()
	elseif version == "VERSION_RELEASE" then
		path.initRelease()
	elseif version == "VERSION_UNITTEST" then
		path.initUnitTest()
	end
end

local function initBuildVersion(version)
	path.init(root, projectPath, we, gamePath)
	tc.ChangeBuildVersion(versionLabels[version])
end

local function applyCompilerOptions(compilerName)
	if compilerName == "jasshelper" then
		path.jassCompiler = "jasshelper"
		path.jassCompilerSelect = "jasshelper"
		path.vjasscMode = "validate"
		path.vjasscStrict = false
		path.allowVjasscNonAlpha = false
	elseif compilerName == "vjassc" then
		path.jassCompiler = "vjassc"
		path.jassCompilerSelect = "vjassc"
		path.vjasscMode = "validate"
		path.vjasscStrict = true
		path.allowVjasscNonAlpha = true
	else
		path.jassCompiler = "both"
		path.jassCompilerSelect = "jasshelper"
		path.vjasscMode = "full-validation"
		path.vjasscStrict = false
		path.allowVjasscNonAlpha = true
	end
end

local function slkSlot(version)
	return path.project .. "/Output/launcher/slk/" .. version .. "/" .. path.mapName .. "_slk.w3x"
end

local function objCacheSlot(version)
	return path.project .. "/Output/launcher/obj-cache/" .. version .. "/" .. path.mapName .. "_obj.w3x"
end

local function slotDisplay(version, suffix)
	return version .. "/" .. path.mapName .. suffix .. ".w3x"
end

local function copyPackagedSlkToSlots(version)
	local map = path.project .. "/" .. path.mapName .. "_slk.w3x"
	local legacyMap = path.project .. "/output/" .. path.mapName .. "_slk.w3x"
	if not fu.fileExist(map) then
		print("[正常启动]打包失败,找不到中间文件: " .. map)
		return false
	end
	if not forceCopyBin(map, legacyMap) then
		return false
	end
	os.remove(map)
	local slot = slkSlot(version)
	if not forceCopyBin(legacyMap, slot) then
		return false
	end
	print("[正常启动]版本专属地图: " .. slot)
	return true, slot
end

local function runCompile(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	print(string.format("[矩阵启动]仅编译: %s / %s", versionLabels[selection.version], selection.compiler))
	return compiler:StartCompile(path)
end

local function runNormalStart(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	print(string.format("[矩阵启动]正常启动: %s / %s", versionLabels[selection.version], selection.compiler))
	local compileOk = compiler:StartCompile(path)
	if not compileOk then
		print("[正常启动]完整编译失败,停止启动")
		return false
	end
	os.remove(path.project .. "/" .. path.mapName .. "_slk.w3x")
	w3xlni:StartSLK()
	local ok, slot = copyPackagedSlkToSlots(selection.version)
	if not ok then
		return false
	end
	return launcher.StartWar3FileAndWaitLog(slot, slotDisplay(selection.version, "_slk"))
end

local function runDirectStart(selection)
	initPathOnly(selection.version)
	local slot = slkSlot(selection.version)
	if not fu.fileExist(slot) then
		print("[直启]未找到版本专属地图: " .. slot)
		print("[直启]请先用同版本的正常启动生成一次版本专属SLK地图")
		return false
	end
	print(string.format("[矩阵启动]直启: %s / %s", versionLabels[selection.version], slot))
	return launcher.StartWar3FileAndWaitLog(slot, slotDisplay(selection.version, "_slk"))
end

local function rebuildObjCache(version)
	os.remove(path.project .. "/" .. path.mapName .. ".w3x")
	local checkOk = compiler:StartCompileCheckOnly(path)
	if not checkOk then
		print("[Obj慢启]检测失败,停止构建缓存")
		return false
	end

	w3xlni:StartOBJ()
	local map = path.project .. "/" .. path.mapName .. ".w3x"
	local cacheMap = objCacheSlot(version)
	if not fu.fileExist(map) then
		print("[Obj慢启]构建缓存失败,找不到中间文件: " .. map)
		return false
	end
	if not forceCopyBin(map, cacheMap) then
		return false
	end
	os.remove(map)
	print("[Obj慢启]版本专属缓存完成: " .. cacheMap)
	return true
end

local function ensureObjCache(version)
	local cacheMap = objCacheSlot(version)
	if fu.fileExist(cacheMap) then
		return true
	end
	print("[Obj快启]检测到版本专属缓存缺失,开始自动构建: " .. cacheMap)
	return rebuildObjCache(version)
end

local function replaceMapScriptWithStorm(cacheMap)
	local w2lRoot = path.toolRoot .. "/w3x2lni"
	local w2lLuaExe = w2lRoot .. "/bin/w3x2lni-lua.exe"
	local stormTask = path.libRoot .. "/Lua/tasks/TaskStormReplaceWar3MapJ.lua"

	if not fu.fileExist(w2lLuaExe) then
		print("[Obj启动]未找到w3x2lni-lua.exe: " .. w2lLuaExe)
		return false
	end
	if not fu.fileExist(stormTask) then
		print("[Obj启动]未找到Storm替换脚本: " .. stormTask)
		return false
	end
	if not fu.fileExist(cacheMap) then
		print("[Obj启动]未找到版本专属Obj缓存地图: " .. cacheMap)
		return false
	end
	if not fu.fileExist(path.CompileResult) then
		print("[Obj启动]未找到编译输出脚本: " .. path.CompileResult)
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
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[Obj启动]Storm替换执行失败")
		return false
	end
	return true
end

local function runObjStart(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	print(string.format("[矩阵启动]%s: %s / %s", selection.launchMode == "fast" and "快启" or "慢启", versionLabels[selection.version], selection.compiler))

	if selection.launchMode == "slow" and not rebuildObjCache(selection.version) then
		return false
	end

	local compileOk = compiler:StartCompile(path)
	if not compileOk then
		print("[Obj启动]完整编译失败,停止启动")
		return false
	end

	if selection.launchMode == "fast" and not ensureObjCache(selection.version) then
		return false
	end

	local cacheMap = objCacheSlot(selection.version)
	if not replaceMapScriptWithStorm(cacheMap) then
		return false
	end
	return launcher.StartWar3FileAndWaitLog(cacheMap, slotDisplay(selection.version, "_obj"))
end

local function runSelection(selection)
	if selection.action == "compile" then
		return runCompile(selection)
	end
	if selection.launchMode == "normal" then
		return runNormalStart(selection)
	elseif selection.launchMode == "direct" then
		return runDirectStart(selection)
	elseif selection.launchMode == "fast" or selection.launchMode == "slow" then
		return runObjStart(selection)
	end
	print("[矩阵启动]未支持的启动方式: " .. tostring(selection.launchMode))
	return false
end

local function runDryRun()
	path.init(root, projectPath, we, gamePath)
	print("[矩阵启动][dry-run]启动组合路径预览")
	for _, version in ipairs(versions) do
		initPathOnly(version.value)
		for _, mode in ipairs(launchModes) do
			for _, compilerItem in ipairs(compilers) do
				applyCompilerOptions(compilerItem.value)
				print(string.format(
					"start version=%s launchMode=%s compiler=%s map=%s slk=%s obj=%s jassCompiler=%s select=%s vjasscMode=%s strict=%s allowNonAlpha=%s",
					version.value,
					mode.value,
					compilerItem.value,
					path.mapName,
					slkSlot(version.value),
					objCacheSlot(version.value),
					path.jassCompiler,
					path.jassCompilerSelect,
					path.vjasscMode,
					tostring(path.vjasscStrict),
					tostring(path.allowVjasscNonAlpha)
				))
			end
		end
	end
	print("[矩阵启动][dry-run]仅编译组合路径预览")
	for _, version in ipairs(versions) do
		initPathOnly(version.value)
		for _, compilerItem in ipairs(compilers) do
			applyCompilerOptions(compilerItem.value)
			print(string.format(
				"compile version=%s compiler=%s map=%s jassCompiler=%s select=%s vjasscMode=%s strict=%s allowNonAlpha=%s",
				version.value,
				compilerItem.value,
				path.mapName,
				path.jassCompiler,
				path.jassCompilerSelect,
				path.vjasscMode,
				tostring(path.vjasscStrict),
				tostring(path.allowVjasscNonAlpha)
			))
		end
	end
end

local function runGui()
	path.init(root, projectPath, we, gamePath)
	local selectionFile = path.project .. "/Output/launcher/selection.txt"
	local historyFile = path.project .. "/Output/launcher/last_selection.txt"
	ensureDir(fu.GetDir(selectionFile))
	os.remove(selectionFile)

	local guiExe = path.libRoot .. "/Lua/gui/runtime/bin/w3x2lni-lua.exe"
	local guiScript = path.libRoot .. "/Lua/gui/launcher/main.lua"
	if not fu.fileExist(guiExe) then
		error("error: 未找到GUI运行时: " .. guiExe)
	end
	if not fu.fileExist(guiScript) then
		error("error: 未找到GUI脚本: " .. guiScript)
	end

	local cmd = string.format(
		'cmd /c ""%s" "%s" "%s" "%s""',
		toWinPath(guiExe),
		toWinPath(guiScript),
		toWinPath(selectionFile),
		toWinPath(historyFile)
	)
	print("[矩阵启动]打开GUI: " .. cmd)
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[矩阵启动]GUI异常退出: " .. tostring(exitCode or ok))
		return nil, "gui"
	end
	if not fu.fileExist(selectionFile) then
		return nil, "cancel"
	end
	return readSelectionFile(selectionFile)
end

parseArgs()

if options.dryRun then
	resetTaskClock()
	runDryRun()
	printTaskEnd()
	return
end

local rawSelection, reason
if options.selection then
	rawSelection = options.selection
else
	rawSelection, reason = runGui()
end

if not rawSelection then
	if reason == "cancel" then
		print("[矩阵启动]已取消")
		printTaskEnd()
		return
	end
	error("error: GUI未返回有效选择: " .. tostring(reason or "unknown"))
end

local selection, err = normalizeSelection(rawSelection)
if not selection then
	if err == "cancel" then
		print("[矩阵启动]已取消")
		printTaskEnd()
		return
	end
	error("error: " .. tostring(err or reason or "未获取到启动选择"))
end

path.init(root, projectPath, we, gamePath)
writeSelectionFile(path.project .. "/Output/launcher/last_selection.txt", selection)
resetTaskClock()

print(string.format(
	"[矩阵启动]选择: action=%s version=%s launchMode=%s compiler=%s",
	selection.action,
	selection.version,
	selection.launchMode,
	selection.compiler
))

local ok = runSelection(selection)
printTaskEnd()
if not ok then
	os.exit(1)
end
