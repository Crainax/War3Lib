local compiler = require("lua.compile.compiler")
local path = require("lua.path")
local root, projectName, we

if arg[1] ~= nil and arg[1] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    root = arg[1]
else
    print("error: 请输入项目目录")

    return
end
if arg[2] ~= nil and arg[2] ~= "" then       -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    projectName = root .. '/Maps/' .. arg[2] -- 地图的项目目录
else
    print("error: 请输入地图名称")
    return
end
if arg[3] ~= nil and arg[3] ~= "" then -- 如果调用时传入了参数,则使用传入的参数作为项目目录
    we = arg[3]                        -- 地图的项目目录
else
    print("error: 请输入WE路径")
    return
end

path.init(root, projectName, we)
compiler:StartCompile(path)                         -- 再把后面几个步骤运行一遍
