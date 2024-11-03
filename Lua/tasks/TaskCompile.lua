local compiler = require("lua.compile.compiler")
local path = require("Lua.path")
local tc = require("Lua.compile.TestControl")
local root, projectPath, we

if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    root = arg[1]
else
    print("error: 请输入项目目录")

    return
end
if arg[2] ~= nil and arg[2] ~= "" then       -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    projectPath = arg[2] -- 地图的项目目录
else
    print("error: 请输入地图路径")
    return
end
if arg[3] ~= nil and arg[3] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    we = arg[3]                        -- 地图的项目目录
else
    print("error: 请输入WE路径")
    return
end

path.init(root, projectPath, we)
compiler:StartCompile() -- 再把后面几个步骤运行一遍

if path.buildString then    -- 打印一下构建版本名称
    print(path.buildString)
end
