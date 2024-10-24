local path = require "lua.path"
local tc = require "lua.compile.TestControl"

local launcher = {}

---@param suffix string
launcher.StartWar3 = function(suffix)
	suffix = suffix or ''
	local cmdExe, cmdArgs, cmd
	-- local copyCode, msg
	cmdExe = "\"D:/WE/WorldEdit v1.2.9C/bin/YDWEConfig.exe\""
	cmdArgs = "-launchwar3 "
	cmdArgs = cmdArgs .. "-loadfile "
	cmdArgs = cmdArgs .. path.project .. "/" .. path.mapName .. suffix .. ".w3x"
	cmd = string.format('%s %s', cmdExe, cmdArgs)
	print(cmd)
	local _, _, code = os.execute(cmd)
	if code then
		print("[" .. path.state .. "]启动war3成功.")
	else
		print("[" .. path.state .. "]启动war3失败." .. code)
	end
	-- return copyCode, msg
end

return launcher
