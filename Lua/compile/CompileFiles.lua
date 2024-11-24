-- CompileFiles.lua
-- 用于跟踪和管理编译过程中的所有相关文件
-- 主要在编译和打包过程中使用

local compileFiles = {
    sourceFiles = {},    -- 存储源代码文件路径(如 .j、.lua 等源文件)
    generatedFiles = {}, -- 存储编译过程中生成的临时文件路径(如 CompileStep0-5 等)
    resourceFiles = {},  -- 存储资源文件路径(如 .blp、.mdx 等资源文件)
    utResourceFiles = {}, -- 新增：记录单元测试中创建的资源文件
    lastBuildTime = nil  -- 记录最后一次编译完成的时间戳
}

-- 清理所有文件记录
-- 调用时机：
-- 1. 在开始新的编译任务前 (Compiler:StartCompile 开始时)
-- 2. 需要重置编译状态时
function compileFiles:clear()
    self.sourceFiles = {}
    self.generatedFiles = {}
    self.resourceFiles = {}
    self.utResourceFiles = {} -- 新增：清理时也要清空这个列表
    self.lastBuildTime = nil
end

-- 添加源代码文件
-- 参数: filePath - 文件路径
-- 调用时机：
-- 1. 添加原始的 .j 脚本文件时
-- 2. 添加需要编译的 .lua 文件时
-- 3. 添加其他源代码文件时
function compileFiles:addSourceFile(filePath)
    table.insert(self.sourceFiles, filePath)
end

-- 添加编译过程中生成的文件
-- 参数: filePath - 文件路径
-- 调用时机：
-- 1. 添加 CompileStep0-5 等临时文件时
-- 2. 添加最终编译结果文件时
-- 3. 添加任何编译过程中生成的中间文件时
function compileFiles:addGeneratedFile(filePath)
    table.insert(self.generatedFiles, filePath)
end

-- 添加资源文件
-- 参数: filePath - 文件路径
-- 调用时机：
-- 1. 添加地图使用的模型文件时
-- 2. 添加地图使用的贴图文件时
-- 3. 添加其他资源文件时
-- 注：通常在打包地图时会用到
function compileFiles:addResourceFile(filePath)
    table.insert(self.resourceFiles, filePath)
end

-- 使用示例：
--[[
    -- 在编译开始时
    compileFiles:clear()

    -- 添加源文件
    compileFiles:addSourceFile("path/to/war3map.j")

    -- 添加生成的文件
    compileFiles:addGeneratedFile("path/to/CompileStep1.j")

    -- 添加资源文件
    compileFiles:addResourceFile("path/to/texture.blp")

    -- 编译完成后
    compileFiles.lastBuildTime = os.time()

    -- 在打包时获取所有文件
    for _, file in ipairs(compileFiles.sourceFiles) do
        -- 处理源文件
    end
--]]

return compileFiles