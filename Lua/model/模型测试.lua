local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

-- 初始化路径配置，确保 path.model 可用
do
    local cwd = lfs.currentdir()
    local project = cwd:gsub("\\", "/")
    local root = project
    local libSuffix = "/Library/War3Lib"
    if project:sub(-#libSuffix) == libSuffix then
        root = project:sub(1, #project - #libSuffix)
    else
        local parent = project:match("(.+)/[^/]+$")
        if parent then root = parent end
    end
    path.init(root, project, "edit")
    -- 进入模型测试上下文（脚本仅依赖于 path.model.test.*，此调用可选但更语义化）
    if path.initModelTest then path.initModelTest() end
end

local flag = {
    ['path'] = [[D:\War3Asset\Model\Shangquemoxing\20251117]], -- 要处理的文件夹
    ['mdxTar'] = path.model.test.res, -- 移到这里
    ['type'] = function(name) -- 根据name分format
        -- 暂时不依赖分类，默认生成所有四种类型
        return 'All' -- 返回一个特殊值，触发生成所有类型
    end
}
local prefix = {
    ['Unit'] = '\t\tUnitModel(p,"', -- 前缀
    ['Efx'] = '\t\tEfx("',
    ['Bind'] = '\t\tEfxB("chest","',
    ['Missile'] = '\t\tDanmu("'
}
local suffix = {
    ['Unit'] = '.mdl");', -- 后缀
    ['Efx'] = '.mdl");',
    ['Bind'] = '.mdl");',
    ['Missile'] = '.mdl");'
}

-- 先删除所有旧的模型
function DeleteOldFile()
    fu.ForDir(flag.mdxTar, function(filePath)
        local name, format = fu.GetFile(filePath)
        if not (name:lower() == "war3mapmap") then -- 唯一的一个文件就不删除,其他全删除
            os.remove(filePath)
            print("Deleted file: " .. filePath)
        end
    end, true)
end

-- 复制新的模型和所有关于BLP文件夹,并打开Exploer方便一瞥
function MoveModel(mdlList)
    -- os.execute("explorer " .. string.gsub(flag.mdxTar, "/", "\\"))
    fu.ForDir(flag.path, function(filePath)
        local name, format = fu.GetFile(filePath)
        local subPath = filePath:sub(#flag.path + 1, #filePath) -- 注意这里是前面有个/
        if format:lower() == "blp" or format:lower() == "tga" then
            local output = path.model.test.res .. subPath
            local dir = fu.GetDir(output) -- 对应的文件夹是否存在
            if not (fu.DirExist(dir)) then
                fu.createDir(dir) -- 创建文件夹
                print("Created directory: " .. dir)
            end
            local sur, msg = copy.CopyBin(filePath, output)
            if sur then
                print(output .. ": Move successful!")
            else
                print(output .. ": Move failed! " .. tostring(msg))
            end
        elseif format:lower() == "mdx" then
            local output = flag.mdxTar .. "/" .. name .. "." .. format
            local sur, msg = copy.CopyBin(filePath, output)
            table.insert(mdlList, name)
            if sur then
                print(output .. ": Move successful!")
            else
                print(output .. ": Move failed! " .. tostring(msg))
            end
        end
    end, true)
end

-- 生成测试文件
function GenerateTest(mdxList)
    -- 先把模板拷进ModelTest里
    copy.copyFile(path.model.test.template, path.model.test.editJ)
    fu.ExecuteFile(path.model.test.editJ, function(line)
        if line:match("//replace") then
            local mod = table.remove(mdxList)
            if mod then
                local type = flag.type(mod)
                if type == 'All' then
                    -- 生成所有四种类型的测试代码，参考 ModelTest.j 的格式
                    return prefix['Unit'] .. mod .. suffix['Unit'] .. '\n' ..
                           prefix['Efx'] .. mod .. suffix['Efx'] .. '\n' ..
                           prefix['Bind'] .. mod .. suffix['Bind'] .. '\n' ..
                           prefix['Missile'] .. mod .. suffix['Missile']
                elseif prefix[type] then
                    return prefix[type] .. mod .. suffix[type]
                else
                    -- 默认生成所有四种类型
                    return prefix['Unit'] .. mod .. suffix['Unit'] .. '\n' ..
                           prefix['Efx'] .. mod .. suffix['Efx'] .. '\n' ..
                           prefix['Bind'] .. mod .. suffix['Bind'] .. '\n' ..
                           prefix['Missile'] .. mod .. suffix['Missile']
                end
            end
        end
        return line
    end)

    if #mdxList ~= 0 then
        print("There are " .. #mdxList .. " unresolved models:")
        for index, value in ipairs(mdxList) do
            print(tostring(index) .. ':' .. tostring(value))
        end
    else
        print("All models processed successfully!")
    end
end

local mdxList = {}
DeleteOldFile() -- 删除旧的模型文件
MoveModel(mdxList) -- 移动新的模型文件
GenerateTest(mdxList) -- 生成测试文件
print("File move completed, check ModelTest.j")
