local tc = require("Lua.compile.TestControl")
local compiler = require("lua.compile.compiler")
local w3xlni = require("lua.compile.W3xLni")
local launcher = require("lua.compile.Launcher")
local path = require("Lua.path")
local copy = require ("Lua.utils.copy")
local root, projectPath, we, buildVersion

if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	root = arg[1]
else
	error("error: 请输入项目目录")
	return
end
if arg[2] ~= nil and arg[2] ~= "" then    -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	projectPath = arg[2]               -- 地图的项目目录
else
	error("error: 请输入地图名称")
	return
end
if arg[3] ~= nil and arg[3] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	we = arg[3]                        -- 地图的项目目录
else
	error("error: 请输入WE路径")
	return
end
if arg[4] ~= nil and (arg[4] == "VERSION_ALPHA" or arg[4] == "VERSION_BETA" or arg[4] == "VERSION_RELEASE" or arg[4] == "VERSION_UNITTEST" or arg[4] == "VERSION_MODELTEST") then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
	if arg[4] == "VERSION_ALPHA" then
		buildVersion = "内测版本"
	elseif arg[4] == "VERSION_BETA" then
		buildVersion = "公测版本"
	elseif arg[4] == "VERSION_RELEASE" then
		buildVersion = "正式版本"
	elseif arg[4] == "VERSION_UNITTEST" then
		buildVersion = "单元测试"
	elseif arg[4] == "VERSION_MODELTEST" then
		buildVersion = "模型测试"
	end
else
	error("error: 请输入启动版本:内测版本,公测版本,正式版本,单元测试,模型测试")
	return
end

path.init(root, projectPath, we) -- 初始化路径
tc.ChangeBuildVersion(buildVersion)

local sur = compiler:StartCompile(path)

if sur then
	w3xlni:StartSLK()
	launcher.StartWar3('_slk')

	local map = path.project .. "/" .. path.mapName .. "_slk.w3x"
	local tarMap = path.project .. "/output/" .. path.mapName .. "_slk.w3x"
	copy.CopyBin(map, tarMap)
	os.remove(map)

end

if path.buildString then -- 输出字符串
	print("---任务结束---" .. path.buildString)
end
