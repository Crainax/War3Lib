local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local launcher = require("Lua.compile.Launcher")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")
local fu = require("Lua.utils.FileUtils")
local lfs = require("lfs")

local taskStartClock = nil

local versions = {
	{ value = "VERSION_ALPHA", label = "内测版本" },
	{ value = "VERSION_BETA", label = "公测版本" },
	{ value = "VERSION_UNITTEST", label = "单元测试" },
	{ value = "VERSION_RELEASE", label = "正式版本" },
}

local actions = {
	{ value = "start", label = "全量启动" },
	{ value = "incremental", label = "增量启动" },
	{ value = "compile", label = "仅编译" },
	{ value = "legacy", label = "老地图启动" },
}

local compilers = {
	{ value = "jasshelper", label = "jasshelper" },
	{ value = "vjassc",     label = "vjassc" },
}

local versionLabels = {}
local validVersions = {}
for _, item in ipairs(versions) do
	versionLabels[item.value] = item.label
	validVersions[item.value] = true
end

local actionLabels = {}
local validActions = {}
for _, item in ipairs(actions) do
	actionLabels[item.value] = item.label
	validActions[item.value] = true
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

local function normalizePath(value)
	local normalized = tostring(value or ""):gsub("\\", "/")
	normalized = normalized:gsub("/+$", "")
	return normalized
end

local function relPath(root, fullPath)
	root = normalizePath(root) .. "/"
	fullPath = normalizePath(fullPath)
	return fullPath:sub(#root + 1)
end

local function removeFile(filePath)
	if not fu.fileExist(filePath) then
		return true
	end
	local ok, msg = fu.DeleteFile(filePath)
	if not ok then
		print("[启动脚本同步]删除旧文件失败: " .. tostring(filePath) .. " (" .. tostring(msg) .. ")")
	end
	return ok
end

local function syncWar3LibDepends()
	local srcRoot = normalizePath(path.libRoot .. "/script/depends")
	local dstRoot = normalizePath(path.project .. "/script/depends")
	if srcRoot == dstRoot then
		print("[启动脚本同步]源和目标相同,跳过: " .. srcRoot)
		return true
	end
	if lfs.attributes(srcRoot, "mode") ~= "directory" then
		print("[启动脚本同步]源目录不存在: " .. srcRoot)
		return false
	end

	ensureDir(dstRoot)

	local sourceFiles = {}
	local copied = 0
	local removed = 0

	fu.ForDir(srcRoot, function(srcFile)
		local rel = relPath(srcRoot, srcFile)
		local dstFile = dstRoot .. "/" .. rel
		sourceFiles[rel] = true
		if not forceCopyBin(srcFile, dstFile) then
			error("[启动脚本同步]复制失败: " .. tostring(srcFile) .. " -> " .. tostring(dstFile))
		end
		copied = copied + 1
	end, true)

	local staleDirs = {}
	if lfs.attributes(dstRoot, "mode") == "directory" then
		fu.ForDir(dstRoot, function(dstFile)
			local rel = relPath(dstRoot, dstFile)
			if not sourceFiles[rel] and removeFile(dstFile) then
				removed = removed + 1
			end
		end, true)
		fu.EachDir(dstRoot, function(dir)
			if normalizePath(dir) ~= dstRoot then
				table.insert(staleDirs, normalizePath(dir))
			end
		end)
	end

	table.sort(staleDirs, function(a, b) return #a > #b end)
	for _, dir in ipairs(staleDirs) do
		pcall(lfs.rmdir, dir)
	end

	print(string.format("[启动脚本同步]depends已同步: %s -> %s, 文件=%d, 删除旧文件=%d", srcRoot, dstRoot, copied, removed))
	return true
end

local function parseInlineSelection(value)
	local result = {}
	for key, val in tostring(value or ""):gmatch("([%w_]+)=([^;,]+)") do
		result[key] = val
	end
	return result
end

local function readKeyValueFile(filePath)
	local result = {}
	if not filePath or filePath == "" or not fu.fileExist(filePath) then
		return result
	end
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
	file:write("compiler=", selection.compiler, "\n")
	file:close()
end

local function normalizeAction(selection)
	local action = selection.action
	local oldLaunchMode = selection.launchMode
	if action == "compile" then
		return "compile"
	elseif action == "incremental" then
		return "incremental"
	elseif action == "legacy" or oldLaunchMode == "direct" then
		return "legacy"
	elseif oldLaunchMode == "fast" or oldLaunchMode == "slow" then
		return "incremental"
	end
	return "start"
end

local function normalizeCompiler(compilerName)
	if compilerName == "vjassc" then
		return "vjassc"
	end
	return "jasshelper"
end

local function normalizeSelection(selection)
	selection = selection or {}
	if selection.status == "cancel" then
		return nil, "cancel"
	end

	selection.action = normalizeAction(selection)
	selection.version = selection.version or "VERSION_ALPHA"
	selection.compiler = normalizeCompiler(selection.compiler)

	if not validActions[selection.action] then
		return nil, "无效启动动作: " .. tostring(selection.action)
	end
	if not validVersions[selection.version] then
		return nil, "无效版本: " .. tostring(selection.version)
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
	if compilerName == "vjassc" then
		path.jassCompiler = "vjassc"
		path.jassCompilerSelect = "vjassc"
		path.vjasscMode = "validate"
		path.vjasscStrict = true
		path.allowVjasscNonAlpha = true
	else
		path.jassCompiler = "jasshelper"
		path.jassCompilerSelect = "jasshelper"
		path.vjasscMode = "validate"
		path.vjasscStrict = false
		path.allowVjasscNonAlpha = false
	end
end

local function slkSlot(version)
	return path.project .. "/Output/launcher/slk/" .. version .. "/" .. path.mapName .. "_slk.w3x"
end

local function slotDisplay(version, suffix)
	return version .. "/" .. path.mapName .. suffix .. ".w3x"
end

local function versionStateFile()
	return path.project .. "/Output/launcher/version_state.txt"
end

local function currentTimestamp()
	return os.date("%Y-%m-%d-%H-%M-%S")
end

local function stateKey(version, name)
	return version .. "_" .. name
end

local function writeVersionState(filePath, state)
	ensureDir(fu.GetDir(filePath))
	local file, err = io.open(filePath, "w")
	if not file then
		error("error: 写入版本启动时间失败: " .. tostring(err))
	end
	for _, version in ipairs(versions) do
		local full = state[stateKey(version.value, "full")]
		local modified = state[stateKey(version.value, "modified")]
		if full and full ~= "" then
			file:write(stateKey(version.value, "full"), "=", full, "\n")
		end
		if modified and modified ~= "" then
			file:write(stateKey(version.value, "modified"), "=", modified, "\n")
		end
	end
	file:close()
end

local function updateVersionState(version, updateFull, updateModified)
	local filePath = versionStateFile()
	local state = readKeyValueFile(filePath)
	local now = currentTimestamp()
	if updateFull then
		state[stateKey(version, "full")] = now
	end
	if updateModified then
		state[stateKey(version, "modified")] = now
	end
	writeVersionState(filePath, state)
end

local function copyPackagedSlkToSlots(version)
	local map = path.project .. "/" .. path.mapName .. "_slk.w3x"
	local legacyMap = path.project .. "/output/" .. path.mapName .. "_slk.w3x"
	if not fu.fileExist(map) then
		print("[全量启动]打包失败,找不到中间文件: " .. map)
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
	print("[全量启动]版本专属地图: " .. slot)
	return true, slot
end

local function replaceMapScriptWithStorm(targetMap)
	local w2lRoot = path.toolRoot .. "/w3x2lni"
	local w2lLuaExe = w2lRoot .. "/bin/w3x2lni-lua.exe"
	local stormTask = path.libRoot .. "/Lua/tasks/TaskStormReplaceWar3MapJ.lua"

	if not fu.fileExist(w2lLuaExe) then
		print("[增量启动]未找到w3x2lni-lua.exe: " .. w2lLuaExe)
		return false
	end
	if not fu.fileExist(stormTask) then
		print("[增量启动]未找到Storm替换脚本: " .. stormTask)
		return false
	end
	if not fu.fileExist(targetMap) then
		print("[增量启动]未找到版本专属SLK地图: " .. targetMap)
		return false
	end
	if not fu.fileExist(path.CompileResult) then
		print("[增量启动]未找到编译输出脚本: " .. path.CompileResult)
		return false
	end

	local cmd = string.format(
		'cmd /c ""%s" "%s" "%s" "%s" "%s""',
		toWinPath(w2lLuaExe),
		toWinPath(stormTask),
		toWinPath(targetMap),
		toWinPath(path.CompileResult),
		toWinPath(w2lRoot)
	)
	print(cmd)
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[增量启动]Storm替换执行失败")
		return false
	end
	return true
end

local function runCompile(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	print(string.format("[矩阵启动]仅编译: %s / %s", versionLabels[selection.version], selection.compiler))
	return compiler:StartCompile(path)
end

local function runStart(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	if not syncWar3LibDepends() then
		return false
	end
	print(string.format("[矩阵启动]全量启动: %s / %s", versionLabels[selection.version], selection.compiler))
	local compileOk = compiler:StartCompile(path)
	if not compileOk then
		print("[全量启动]完整编译失败,停止启动")
		return false
	end
	os.remove(path.project .. "/" .. path.mapName .. "_slk.w3x")
	w3xlni:StartSLK()
	local ok, slot = copyPackagedSlkToSlots(selection.version)
	if not ok then
		return false
	end
	local started = launcher.StartWar3FileAndWaitLog(slot, slotDisplay(selection.version, "_slk"))
	if started then
		updateVersionState(selection.version, true, true)
	end
	return started
end

local function runIncrementalStart(selection)
	initBuildVersion(selection.version)
	applyCompilerOptions(selection.compiler)
	if not syncWar3LibDepends() then
		return false
	end
	local slot = slkSlot(selection.version)
	if not fu.fileExist(slot) then
		print("[增量启动]未找到版本专属SLK地图: " .. slot)
		print("[增量启动]请先用同版本的“启动地图”生成一次版本专属SLK地图")
		return false
	end

	print(string.format("[矩阵启动]增量启动: %s / %s", versionLabels[selection.version], selection.compiler))
	local compileOk = compiler:StartCompile(path)
	if not compileOk then
		print("[增量启动]完整编译失败,停止启动")
		return false
	end
	if not replaceMapScriptWithStorm(slot) then
		return false
	end
	local started = launcher.StartWar3FileAndWaitLog(slot, slotDisplay(selection.version, "_slk"))
	if started then
		updateVersionState(selection.version, false, true)
	end
	return started
end

local function runLegacyStart(selection)
	initPathOnly(selection.version)
	if not syncWar3LibDepends() then
		return false
	end
	local slot = slkSlot(selection.version)
	if not fu.fileExist(slot) then
		print("[老地图启动]未找到版本专属SLK地图: " .. slot)
		print("[老地图启动]请先用同版本的“启动地图”生成一次版本专属SLK地图")
		return false
	end
	print(string.format("[矩阵启动]老地图启动: %s / %s", versionLabels[selection.version], slot))
	return launcher.StartWar3FileAndWaitLog(slot, slotDisplay(selection.version, "_slk"))
end

local function runSelection(selection)
	if selection.action == "compile" then
		return runCompile(selection)
	elseif selection.action == "incremental" then
		return runIncrementalStart(selection)
	elseif selection.action == "legacy" then
		return runLegacyStart(selection)
	end
	return runStart(selection)
end

local function runDryRun()
	path.init(root, projectPath, we, gamePath)
	print("[矩阵启动][dry-run]组合路径预览")
	for _, version in ipairs(versions) do
		initPathOnly(version.value)
		for _, compilerItem in ipairs(compilers) do
			applyCompilerOptions(compilerItem.value)
			print(string.format(
				"action=start version=%s compiler=%s map=%s slk=%s jassCompiler=%s select=%s vjasscMode=%s strict=%s allowNonAlpha=%s",
				version.value,
				compilerItem.value,
				path.mapName,
				slkSlot(version.value),
				path.jassCompiler,
				path.jassCompilerSelect,
				path.vjasscMode,
				tostring(path.vjasscStrict),
				tostring(path.allowVjasscNonAlpha)
			))
			print(string.format(
				"action=incremental version=%s compiler=%s map=%s slk=%s jass=%s jassCompiler=%s select=%s vjasscMode=%s strict=%s allowNonAlpha=%s",
				version.value,
				compilerItem.value,
				path.mapName,
				slkSlot(version.value),
				path.CompileResult,
				path.jassCompiler,
				path.jassCompilerSelect,
				path.vjasscMode,
				tostring(path.vjasscStrict),
				tostring(path.allowVjasscNonAlpha)
			))
			print(string.format(
				"action=compile version=%s compiler=%s map=%s jassCompiler=%s select=%s vjasscMode=%s strict=%s allowNonAlpha=%s",
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
		print(string.format(
			"action=legacy version=%s compiler=none map=%s slk=%s",
			version.value,
			path.mapName,
			slkSlot(version.value)
		))
	end
end

local function runGui()
	path.init(root, projectPath, we, gamePath)
	local selectionFile = path.project .. "/Output/launcher/selection.txt"
	local historyFile = path.project .. "/Output/launcher/last_selection.txt"
	local stateFile = versionStateFile()
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
		'cmd /c ""%s" "%s" "%s" "%s" "%s""',
		toWinPath(guiExe),
		toWinPath(guiScript),
		toWinPath(selectionFile),
		toWinPath(historyFile),
		toWinPath(stateFile)
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
	return readKeyValueFile(selectionFile)
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
	"[矩阵启动]选择: action=%s version=%s compiler=%s",
	selection.action,
	selection.version,
	selection.compiler
))

local ok = runSelection(selection)
printTaskEnd()
if not ok then
	os.exit(1)
end
