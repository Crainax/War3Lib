local fu = require "lua.utils.FileUtils"
local path = require "Lua.path"

local launcher = {}

---@param suffix string
launcher.StartWar3 = function(suffix)
	suffix = suffix or ''
	local cmdExe, cmdArgs, cmd
	-- local copyCode, msg
	cmdExe = fu.PathString(path.we .. "/bin/YDWEConfig.exe")
	cmdArgs = "-launchwar3 "
	cmdArgs = cmdArgs .. "-loadfile "
	cmdArgs = cmdArgs .. path.project .. "/" .. path.mapName .. suffix .. ".w3x"
	cmd = string.format('%s %s', cmdExe, cmdArgs)
	print(cmd)
	local _, _, code = os.execute(cmd)
	if code then
		print("[" .. path.buildVersion .. "]启动war3成功,运行地图:" .. path.mapName .. suffix .. ".w3x")
	else
		print("[" .. path.buildVersion .. "]启动war3失败." .. code)
	end
	-- return copyCode, msg
end

return launcher
