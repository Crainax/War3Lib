local FileUtils = require("lua.utils.FileUtils")
local path = require("lua.path")

local zs = os.rename(path.war3 .. "/dz_w3_plugin.dll", path.war3 .. "/gm_dz_w3_plugin.dll")
if zs then
	os.rename(path.war3 .. "/version.dll", path.war3 .. "/gm_version.dll")
	print("当前状态[无网易插件]")
else
	os.rename(path.war3 .. "/gm_version.dll", path.war3 .. "/version.dll")
	os.rename(path.war3 .. "/gm_dz_w3_plugin.dll", path.war3 .. "/dz_w3_plugin.dll")
	print("当前状态[有网易插件]")
end
