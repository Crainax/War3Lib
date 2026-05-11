local backuper = require("Lua.tools.Backuper")
local w3x = require("Lua.compile.W3xLni")
local path = require("Lua.path")
local taskStartClock = os.clock()

local root, projectPath, we, gamePath
if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    root = arg[1]
else
    error("error: 请输入项目目录")
    return
end
if arg[2] ~= nil and arg[2] ~= "" then       -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    projectPath = arg[2]               -- 地图的项目目录
else
    error("error: 请输入地图路径")
    return
end
if arg[3] ~= nil and arg[3] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    we = arg[3]                        -- 地图的项目目录
else
    error("error: 请输入WE路径")
    return
end
if arg[4] ~= nil and arg[4] ~= "" then
    gamePath = arg[4]
end

path.init(root, projectPath, we, gamePath) -- 初始化路径
path.initRelease() -- 只打包正式地图

w3x:StartOBJ()
print("OBJ重构建完成!")
print(string.format("---任务结束---[用时%.2f秒]-", os.clock() - taskStartClock))
-- return modules
