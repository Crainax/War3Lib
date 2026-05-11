local compiler = require("lua.compile.compiler")
local path = require("Lua.path")
local tc = require("Lua.compile.TestControl")
local taskStartClock = os.clock()
local root, projectPath, we, gamePath

local function printTaskEnd()
    local elapsed = os.clock() - taskStartClock
    local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
    if path.buildString and path.buildString ~= "" then
        print("---任务结束---" .. path.buildString .. elapsedStr)
    else
        print("---任务结束---" .. elapsedStr)
    end
end

if arg[1] ~= nil and arg[1] ~= "" then
    root = arg[1]
else
    print("error: 请输入项目目录")
    return
end
if arg[2] ~= nil and arg[2] ~= "" then
    projectPath = arg[2]
else
    print("error: 请输入地图路径")
    return
end
if arg[3] ~= nil and arg[3] ~= "" then
    we = arg[3]
else
    print("error: 请输入WE路径")
    return
end
if arg[4] ~= nil and arg[4] ~= "" then
    gamePath = arg[4]
end

path.init(root, projectPath, we, gamePath)
tc.ChangeBuildVersion("单元测试")
path.jassCompiler = "both"
path.jassCompilerSelect = "vjassc"
path.allowVjasscNonAlpha = true
path.vjasscStrict = true

compiler:StartCompile()

printTaskEnd()
