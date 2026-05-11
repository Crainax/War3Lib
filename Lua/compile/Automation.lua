local fu = require("Lua.utils.FileUtils")
local path = require("Lua.path")

local automation = {}

local function commandSucceeded(ok, exitType, exitCode)
	if ok == true or ok == 0 then
		return true
	end
	return exitType == "exit" and exitCode == 0
end

local function toWinPath(value)
	return tostring(value or ""):gsub("/", "\\")
end

local function quote(value)
	return '"' .. toWinPath(value):gsub('"', '\\"') .. '"'
end

local function appendArg(args, name, value)
	if value ~= nil and value ~= "" then
		table.insert(args, name)
		table.insert(args, quote(value))
	end
end

local function pythonExe()
	local venvPython = path.libRoot .. "/Python/.venv/Scripts/python.exe"
	if fu.fileExist(venvPython) then
		return venvPython
	end
	return "python"
end

function automation.Run(options)
	options = options or {}
	local script = path.libRoot .. "/Python/war3auto/main.py"
	local args = {
		quote(pythonExe()),
		quote(script),
	}
	appendArg(args, "--lib-root", path.libRoot)
	appendArg(args, "--project", path.project)
	appendArg(args, "--we", path.we)
	appendArg(args, "--game-path", path.gamePath)
	appendArg(args, "--map-path", options.mapPath)
	if options.checkAssets then
		table.insert(args, "--check-assets")
	end
	if options.dryRun then
		table.insert(args, "--dry-run")
	end
	if options.timeoutSeconds then
		table.insert(args, "--timeout")
		table.insert(args, tostring(options.timeoutSeconds))
	end
	if options.threshold then
		table.insert(args, "--threshold")
		table.insert(args, tostring(options.threshold))
	end

	local cmd = 'cmd /c "' .. table.concat(args, " ") .. '"'
	print("[war3auto] " .. cmd)
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[war3auto] automation failed: " .. tostring(exitCode or ok))
		return false
	end
	return true
end

function automation.CheckAssets()
	return automation.Run({ checkAssets = true })
end

return automation
