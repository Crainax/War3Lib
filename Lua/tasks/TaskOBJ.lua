local backuper = require("Lua.tools.Backuper")
local w3x = require("Lua.compile.W3xLni")
local path = require("Lua.path")
local taskStartClock = os.clock()

local function argOrEnv(index, name)
    if arg[index] ~= nil and arg[index] ~= "" then
        return arg[index]
    end
    return os.getenv(name)
end

local root, projectPath, we, gamePath
root = argOrEnv(1, "WAR3_TASK_ROOT")
if root == nil or root == "" then
    error("error: 请输入项目目录")
    return
end
projectPath = argOrEnv(2, "WAR3_TASK_PROJECT")
if projectPath == nil or projectPath == "" then
    error("error: 请输入地图路径")
    return
end
we = argOrEnv(3, "WAR3_TASK_WE")
if we == nil or we == "" then
    error("error: 请输入WE路径")
    return
end
gamePath = argOrEnv(4, "WAR3_TASK_GAME")

path.init(root, projectPath, we, gamePath) -- 初始化路径
path.initRelease() -- 只打包正式地图

w3x:StartOBJ()
print("OBJ重构建完成!")
print(string.format("---任务结束---[用时%.2f秒]-", os.clock() - taskStartClock))
-- return modules
