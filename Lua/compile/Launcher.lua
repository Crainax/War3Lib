local fu = require "lua.utils.FileUtils"
local path = require "Lua.path"

local launcher = {}

local function normalize(value)
	return tostring(value or ""):gsub("\\", "/"):gsub("/+", "/"):gsub("/+$", "")
end

local function powershellString(value)
	return "'" .. tostring(value or ""):gsub("'", "''") .. "'"
end

local function utf8ToUtf16Le(value)
	local bytes = {}
	for _, code in utf8.codes(tostring(value or "")) do
		if code <= 0xFFFF then
			table.insert(bytes, string.char(code % 256, math.floor(code / 256) % 256))
		else
			code = code - 0x10000
			local high = 0xD800 + math.floor(code / 0x400)
			local low = 0xDC00 + (code % 0x400)
			table.insert(bytes, string.char(high % 256, math.floor(high / 256) % 256))
			table.insert(bytes, string.char(low % 256, math.floor(low / 256) % 256))
		end
	end
	return table.concat(bytes)
end

local function base64Encode(data)
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local result = {}
	for i = 1, #data, 3 do
		local b1 = data:byte(i) or 0
		local b2 = data:byte(i + 1)
		local b3 = data:byte(i + 2)
		local n = b1 * 65536 + (b2 or 0) * 256 + (b3 or 0)
		local c1 = math.floor(n / 262144) % 64
		local c2 = math.floor(n / 4096) % 64
		local c3 = math.floor(n / 64) % 64
		local c4 = n % 64
		table.insert(result, alphabet:sub(c1 + 1, c1 + 1))
		table.insert(result, alphabet:sub(c2 + 1, c2 + 1))
		table.insert(result, b2 and alphabet:sub(c3 + 1, c3 + 1) or "=")
		table.insert(result, b3 and alphabet:sub(c4 + 1, c4 + 1) or "=")
	end
	return table.concat(result)
end

local function powershellCommand(script)
	local wrapped = "$ProgressPreference='SilentlyContinue'; " .. script
	return "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -EncodedCommand " .. base64Encode(utf8ToUtf16Le(wrapped))
end

local function commandSucceeded(ok, exitType, exitCode)
	if ok == true or ok == 0 then
		return true
	end
	return exitType == "exit" and exitCode == 0
end

local function toWinPath(value)
	return tostring(value or ""):gsub("/", "\\")
end

local function openWithAntigravity(filePath)
	local target = filePath:gsub("/", "\\")
	local quotedTarget = '"' .. target:gsub('"', '\\"') .. '"'
	local ps = table.concat({
		"$cmd=(Get-Command antigravity.cmd -ErrorAction SilentlyContinue).Source",
		"if(-not $cmd){$cmd=(Get-Command antigravity -ErrorAction Stop).Source}",
		"Start-Process -FilePath $cmd -ArgumentList @(" .. powershellString(quotedTarget) .. ") -WindowStyle Hidden"
	}, "; ")
	return os.execute(powershellCommand(ps))
end

launcher.OpenWithAntigravity = openWithAntigravity

local function sleepOneSecond()
	os.execute("ping -n 2 127.0.0.1 >nul")
end

local function parseLogDir()
	local initLua = path.project .. "/script/init.lua"
	local content = fu.GetContent(initLua) or ""
	local rel = content:match("package%.log_dir%s*=%s*['\"]([^'\"]+)['\"]")
		or content:match("log%.path%s*=%s*['\"]([^'\"]+)['\"]")
	if not rel or rel == "" then
		return nil
	end
	rel = rel:gsub("\\", "/"):gsub("/+$", "")
	return normalize(path.gamePath .. "/" .. rel)
end

local function snapshotLogFiles(logDir)
	local result = {}
	if not logDir then
		return result
	end
	local ps = table.concat({
		"[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new($false)",
		"$dir=" .. powershellString(logDir:gsub("/", "\\")),
		"if(Test-Path -LiteralPath $dir -PathType Container){",
		"Get-ChildItem -LiteralPath $dir -File | ForEach-Object {",
		"$p=$_.FullName.Replace('\\\\','/')",
		"$t=([DateTimeOffset]$_.LastWriteTime).ToUnixTimeSeconds()",
		"[Console]::Out.WriteLine($p + \"`t\" + $t)",
		"}",
		"}"
	}, "; ")
	local pipe = io.popen(powershellCommand(ps), "r")
	if not pipe then
		return result
	end
	for line in pipe:lines() do
		local fullPath, modified = line:match("^(.-)\t(%d+)$")
		if fullPath then
			result[normalize(fullPath)] = tonumber(modified) or 0
		end
	end
	pipe:close()
	return result
end

local function newestNewLog(logDir, before, startClock)
	local bestPath = nil
	local bestTime = 0
	local bestHasPlayerSuffix = false
	for fullPath, modified in pairs(snapshotLogFiles(logDir)) do
		if (not before[fullPath] or modified > before[fullPath]) and modified >= startClock - 2 then
			local hasPlayerSuffix = fullPath:match("%-P%d+%.log$") ~= nil
			if (hasPlayerSuffix and not bestHasPlayerSuffix) or (hasPlayerSuffix == bestHasPlayerSuffix and modified >= bestTime) then
				bestPath = fullPath
				bestTime = modified
				bestHasPlayerSuffix = hasPlayerSuffix
			end
		end
	end
	return bestPath
end

function launcher.WaitAndOpenNewLog(before, timeoutSeconds, startClock)
	timeoutSeconds = timeoutSeconds or 60
	startClock = startClock or os.time()
	local logDir = parseLogDir()
	if not logDir then
		print("[日志等待]未能解析日志目录,跳过打开日志")
		return false
	end

	for _ = 1, timeoutSeconds do
		local logPath = newestNewLog(logDir, before or {}, startClock)
		if logPath then
			print("[日志等待]发现新日志: " .. logPath)
			openWithAntigravity(logPath)
			return true
		end
		sleepOneSecond()
	end

	print("[日志等待]超时,未发现新日志: " .. logDir)
	return false
end

function launcher.SnapshotLogs()
	return snapshotLogFiles(parseLogDir())
end

function launcher.GetLogDir()
	return parseLogDir()
end

---@param mapPath string
---@param displayName string|nil
function launcher.StartWar3File(mapPath, displayName)
	local cmd = string.format(
		'cmd /c ""%s" -launchwar3 -loadfile "%s""',
		toWinPath(path.we .. "/bin/YDWEConfig.exe"),
		toWinPath(mapPath)
	)
	print(cmd)
	local ok, exitType, exitCode = os.execute(cmd)
	if not commandSucceeded(ok, exitType, exitCode) then
		print("[" .. path.buildVersion .. "]YDWEConfig返回码非0,但可能已成功拉起魔兽: " .. tostring(exitCode or ok))
	end
	print("[" .. path.buildVersion .. "]启动war3成功,运行地图:" .. (displayName or mapPath))
	return true
end

---@param suffix string
launcher.StartWar3 = function(suffix)
	suffix = suffix or ''
	local mapPath = path.project .. "/output/" .. path.mapName .. suffix .. ".w3x"
	return launcher.StartWar3File(mapPath, path.mapName .. suffix .. ".w3x")
end

function launcher.StartWar3AndWaitLog(suffix)
	local before = launcher.SnapshotLogs()
	local startedAt = os.time()
	launcher.StartWar3(suffix)
	launcher.WaitAndOpenNewLog(before, 60, startedAt)
end

function launcher.StartWar3FileAndWaitLog(mapPath, displayName)
	local before = launcher.SnapshotLogs()
	local startedAt = os.time()
	local started = launcher.StartWar3File(mapPath, displayName)
	if started then
		launcher.WaitAndOpenNewLog(before, 60, startedAt)
	end
	return started
end

return launcher
