local automation = require("Lua.compile.Automation")
local path = require("Lua.path")
local fu = require("Lua.utils.FileUtils")

local taskStartClock = nil
local root, projectPath, we, gamePath
local options = {
	checkAssets = false,
	dryRun = false,
	timeoutSeconds = 60,
	threshold = nil,
	players = nil,
	postJoinDelaySeconds = 3,
	hostLayout = nil,
	clientLayout = nil,
}

local function commandSucceeded(ok, exitType, exitCode)
	if ok == true or ok == 0 then
		return true
	end
	return exitType == "exit" and exitCode == 0
end

local function toWinPath(value)
	return tostring(value or ""):gsub("/", "\\")
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
		error("error: 写入多人测试选择记忆失败: " .. tostring(err))
	end
	file:write("players=", tostring(selection.players), "\n")
	file:close()
end

local function normalizePlayers(value)
	local players = tonumber(value)
	if not players or players < 2 or players > 6 then
		return nil, "无效窗口数量: " .. tostring(value)
	end
	return math.floor(players)
end

local function parseArgs()
	if arg[1] ~= nil and arg[1] ~= "" then
		root = arg[1]
	else
		error("error: missing root path")
	end
	if arg[2] ~= nil and arg[2] ~= "" then
		projectPath = arg[2]
	else
		error("error: missing project path")
	end
	if arg[3] ~= nil and arg[3] ~= "" then
		we = arg[3]
	else
		error("error: missing WE path")
	end
	if arg[4] ~= nil and arg[4] ~= "" and not tostring(arg[4]):match("^%-%-") then
		gamePath = arg[4]
	end

	local i = gamePath and 5 or 4
	while i <= #arg do
		local item = arg[i]
		if item == "--check-assets" then
			options.checkAssets = true
		elseif item == "--dry-run" then
			options.dryRun = true
		elseif item == "--timeout" then
			options.timeoutSeconds = tonumber(arg[i + 1]) or options.timeoutSeconds
			i = i + 1
		elseif item == "--threshold" then
			options.threshold = tonumber(arg[i + 1])
			i = i + 1
		elseif item == "--players" then
			options.players = tonumber(arg[i + 1])
			i = i + 1
		elseif item == "--post-join-delay" then
			options.postJoinDelaySeconds = tonumber(arg[i + 1]) or options.postJoinDelaySeconds
			i = i + 1
		elseif item == "--host-layout" then
			options.hostLayout = arg[i + 1]
			i = i + 1
		elseif item == "--client-layout" then
			options.clientLayout = arg[i + 1]
			i = i + 1
		end
		i = i + 1
	end
end

local function runGui()
	local selectionFile = path.project .. "/Output/multiplayer_test/selection.txt"
	local historyFile = path.project .. "/Output/multiplayer_test/last_selection.txt"
	ensureDir(fu.GetDir(selectionFile))
	os.remove(selectionFile)

	local guiExe = path.libRoot .. "/Lua/gui/runtime/bin/w3x2lni-lua.exe"
	local guiScript = path.libRoot .. "/Lua/gui/multiplayer_test/main.lua"
	if not fu.fileExist(guiExe) then
		error("error: 未找到GUI运行时: " .. guiExe)
	end
	if not fu.fileExist(guiScript) then
		error("error: 未找到多人测试GUI脚本: " .. guiScript)
	end

	local cmd = string.format(
		'cmd /c ""%s" "%s" "%s" "%s""',
		toWinPath(guiExe),
		toWinPath(guiScript),
		toWinPath(selectionFile),
		toWinPath(historyFile)
	)
	print("[MultiPlayerTest]打开GUI: " .. cmd)
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[MultiPlayerTest]GUI异常退出: " .. tostring(exitCode or ok))
		return nil, "gui"
	end
	if not fu.fileExist(selectionFile) then
		return nil, "cancel"
	end
	return readKeyValueFile(selectionFile)
end

local function selectPlayers()
	if options.players then
		local players, err = normalizePlayers(options.players)
		if not players then
			error("error: " .. err)
		end
		return players
	end
	local rawSelection, reason = runGui()
	if not rawSelection then
		return nil, reason or "cancel"
	end
	if rawSelection.status == "cancel" then
		return nil, "cancel"
	end
	local players, err = normalizePlayers(rawSelection.players)
	if not players then
		error("error: " .. err)
	end
	writeSelectionFile(path.project .. "/Output/multiplayer_test/last_selection.txt", { players = players })
	return players
end

local function runAutomation(players, launchWar3)
	local runOptions = {
		launchWar3 = launchWar3,
		dryRun = options.dryRun,
		players = players,
		timeoutSeconds = options.timeoutSeconds,
		threshold = options.threshold,
		postJoinDelaySeconds = options.postJoinDelaySeconds,
		hostLayout = options.hostLayout,
		clientLayout = options.clientLayout,
	}
	return automation.RunMultiPlayerTest(runOptions)
end

parseArgs()
path.init(root, projectPath, we, gamePath)

if options.checkAssets then
	resetTaskClock()
	local ok = automation.CheckAssets({ players = options.players or 2 })
	printTaskEnd()
	if not ok then
		os.exit(1)
	end
	return
end

local players, reason = selectPlayers()
if not players then
	if reason == "cancel" then
		print("[MultiPlayerTest]已取消")
		printTaskEnd()
		return
	end
	error("error: GUI未返回有效选择: " .. tostring(reason or "unknown"))
end

resetTaskClock()
print(string.format("[MultiPlayerTest]选择: players=%d", players))

local assetsOk = automation.CheckAssets({ players = players })
if not assetsOk then
	print("[MultiPlayerTest]缺少模板素材; stop before start")
	printTaskEnd()
	os.exit(1)
end

local ok = runAutomation(players, not options.dryRun)
printTaskEnd()
if not ok then
	os.exit(1)
end
