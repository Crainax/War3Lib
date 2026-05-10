local compiler = require("lua.compile.compiler")
local path = require("Lua.path")
local tc = require("Lua.compile.TestControl")
local taskStartClock = os.clock()
local root, projectPath, we, gamePath, jassCompiler

local function printTaskEnd()
    local elapsed = os.clock() - taskStartClock
    local elapsedStr = string.format("[用时%.2f秒]-", elapsed)
    if path.buildString and path.buildString ~= "" then
        print("---任务结束---" .. path.buildString .. elapsedStr)
    else
        print("---任务结束---" .. elapsedStr)
    end
end

local function normalizeCompiler(value)
    value = string.lower(tostring(value or "jasshelper"))
    if value == "vjassc" or value == "both" then
        return value
    end
    return "jasshelper"
end

local function isCompilerArg(value)
    value = string.lower(tostring(value or ""))
    return value == "jasshelper" or value == "vjassc" or value == "both"
end

local function applyCompilerOptions(compilerName)
    compilerName = normalizeCompiler(compilerName)
    if compilerName == "vjassc" then
        path.jassCompiler = "vjassc"
        path.jassCompilerSelect = "vjassc"
        path.vjasscMode = path.vjasscMode or "validate"
        path.vjasscStrict = true
        path.allowVjasscNonAlpha = true
    elseif compilerName == "both" then
        path.jassCompiler = "both"
        path.jassCompilerSelect = "jasshelper"
        path.vjasscMode = path.vjasscMode or "validate"
        path.vjasscStrict = false
    else
        path.jassCompiler = "jasshelper"
        path.jassCompilerSelect = "jasshelper"
        path.vjasscMode = path.vjasscMode or "validate"
        path.vjasscStrict = false
        path.allowVjasscNonAlpha = false
    end
end

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
if arg[4] ~= nil and arg[4] ~= "" then
    if isCompilerArg(arg[4]) then
        jassCompiler = arg[4]
    else
        gamePath = arg[4]
    end
end
if arg[5] ~= nil and arg[5] ~= "" then
    if isCompilerArg(arg[5]) then
        jassCompiler = arg[5]
    else
        print("error: 无效JASS编译器: " .. tostring(arg[5]) .. " (应为 jasshelper、vjassc 或 both)")
        return
    end
end

path.init(root, projectPath, we, gamePath)
tc.GetState()
jassCompiler = normalizeCompiler(jassCompiler)
applyCompilerOptions(jassCompiler)
print("[编译后端]TaskCompile使用: " .. jassCompiler)
compiler:StartCompile() -- 再把后面几个步骤运行一遍

printTaskEnd()
