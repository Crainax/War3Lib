local automation = require("Lua.compile.Automation")
local path = require("Lua.path")

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

parseArgs()
path.init(root, projectPath, we, gamePath)

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

local ok = automation.Run({
	launchWar3 = true,
	timeoutSeconds = options.timeoutSeconds,
	threshold = options.threshold,
})
printTaskEnd()
if not ok then
	os.exit(1)
end
