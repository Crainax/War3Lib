local backuper = require("Lua.tools.Backuper")
local w3x = require("Lua.compile.W3xLni")
local path = require("Lua.path")

local root, projectName, we
if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    root = arg[1]
else
    error("error: 请输入项目目录")
    return
end
if arg[2] ~= nil and arg[2] ~= "" then       -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    projectName = root .. '/Maps/' .. arg[2] -- 地图的项目目录
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

path.init(root, projectName, we) -- 初始化路径
path.initRelease() -- 只打包正式地图

w3x:StartOBJ()
print("OBJ重构建完成!")
-- return modules
