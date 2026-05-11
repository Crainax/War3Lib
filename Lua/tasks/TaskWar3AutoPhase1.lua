local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("Lua.compile.W3xLni")
local launcher = require("Lua.compile.Launcher")
local automation = require("Lua.compile.Automation")
local path = require("Lua.path")
local copy = require("Lua.utils.copy")

local taskStartClock = os.clock()
local root, projectPath, we, gamePath
local options = {
	checkAssets = false,
	dryRun = false,
	timeoutSeconds = 60,
	threshold = nil,
}

local function printTaskEnd()
	local elapsed = os.clock() - taskStartClock
	local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
	if path.buildString and path.buildString ~= "" then
		print("---任务结束---" .. path.buildString .. elapsedStr)
	else
		print("---任务结束---" .. elapsedStr)
	end
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

	local i = 5
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
		end
		i = i + 1
	end
end

local function buildSlkMap()
	local compileOk = compiler:StartCompile(path)
	if not compileOk then
		print("[war3auto] compile failed; stop phase 1 automation")
		return nil
	end

	w3xlni:StartSLK()

	local map = path.project .. "/" .. path.mapName .. "_slk.w3x"
	local targetMap = path.project .. "/output/" .. path.mapName .. "_slk.w3x"
	local copied = copy.CopyBin(map, targetMap)
	if not copied then
		print("[war3auto] failed to copy map: " .. map .. " -> " .. targetMap)
		return nil
	end
	os.remove(map)
	return targetMap
end

parseArgs()
path.init(root, projectPath, we, gamePath)
tc.ChangeBuildVersion("内测版本")

if options.checkAssets then
	local ok = automation.CheckAssets()
	printTaskEnd()
	if not ok then
		os.exit(1)
	end
	return
end

local assetsOk = automation.CheckAssets()
if not assetsOk then
	print("[war3auto] missing template assets; stop before compile/start")
	printTaskEnd()
	os.exit(1)
end

if options.dryRun then
	local ok = automation.Run({
		dryRun = true,
		timeoutSeconds = options.timeoutSeconds,
		threshold = options.threshold,
	})
	printTaskEnd()
	if not ok then
		os.exit(1)
	end
	return
end

local targetMap = buildSlkMap()
if not targetMap then
	printTaskEnd()
	os.exit(1)
end

local started = launcher.StartWar3FileAndWaitLog(targetMap, path.mapName .. "_slk.w3x")
if not started then
	printTaskEnd()
	os.exit(1)
end

local ok = automation.Run({
	mapPath = targetMap,
	timeoutSeconds = options.timeoutSeconds,
	threshold = options.threshold,
})
printTaskEnd()
if not ok then
	os.exit(1)
end
