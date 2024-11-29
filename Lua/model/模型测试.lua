local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
    ['path'] = [[D:\模型\模型测试\20221223]], -- 要处理的文件夹
    ['mdxTar'] = path.model.test.res, -- 移到这里
    ['type'] = function(name) -- 根据name分format
        -- if name:match("missile") then
        --     return 'Missile'
        -- elseif name:match("n%d$") or name:match("portrait") then
        --     return 'Unit'
        -- elseif name:match("self") or name:match("target") then
        --     return 'Bind'
        -- else
        --     return 'Efx'
        -- end
        -- return 'Unit' -- 单位
        -- return 'Efx' -- 特效
        -- return 'Bind' -- 绑定特效
        -- if name:match("Flamestrike") then
        --     return 'Efx'
        -- end
        -- return 'Missile' -- 飞弹类特效
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
            print(gbk.toutf8("删除了文件:" .. filePath))
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
                print(gbk.toutf8("创建文件夹:" .. dir))
            end
            local sur, msg = copy.CopyBin(filePath, output)
            if sur then
                print(gbk.toutf8(output .. ":移动成功！"))
            else
                print(gbk.toutf8(output .. ":移动失败！" .. tostring(msg)))
            end
        elseif format:lower() == "mdx" then
            local output = flag.mdxTar .. "/" .. name .. "." .. format
            local sur, msg = copy.CopyBin(filePath, output)
            table.insert(mdlList, name)
            if sur then
                print(gbk.toutf8(output .. ":移动成功！"))
            else
                print(gbk.toutf8(output .. ":移动失败！" .. tostring(msg)))
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
                if prefix[type] then
                    return prefix[type] .. mod .. suffix[type]
                else
                    return prefix['Unit'] .. mod .. suffix['Unit'] .. '' .. -- 都生成下注释
                    prefix['Efx'] .. mod .. suffix['Efx'] .. '' .. -- 都生成下注释
                    prefix['Bind'] .. mod .. suffix['Bind'] .. '' .. -- 都生成下注释
                    prefix['Missile'] .. mod .. suffix['Missile'] -- 都生成下注释
                end
            end
        end
        return line
    end)
    if #mdxList ~= 0 then
        print(gbk.toutf8("还有" .. #mdxList .. "个没有解决的:"))
        for index, value in ipairs(mdxList) do
            print(tostring(index) .. ':' .. tostring(value))
        end
    end
end

local mdxList = {}
DeleteOldFile() -- 删除旧的模型文件
MoveModel(mdxList) -- 移动新的模型文件
GenerateTest(mdxList) -- 生成测试文件
print(gbk.toutf8("移动文件完成，请看ModelTest.j"))
