local lfs = require("lfs")
local inject_code = {}

-- 注入代码表
inject_code.new_table = {}
inject_code.old_table = {}
inject_code.chain_table = {} -- 链式依赖

-- 辅助函数：获取文件扩展名
local function get_extension(filename)
    return filename:match("^.+(%..+)$") or ""
end

-- 辅助函数：去除字符串两端的空白字符
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- 新增辅助函数：读取文件内容
local function read_file(file_path)
    local file, err = io.open(file_path, "r")
    if not file then
        return nil, err
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- 侦测需要注入哪些代码(使用的是string.find方式,所以说注释下也会检测到)
function inject_code:detect(path)
    -- 添加开始时间记录
    local start_time = os.clock()

    local r = {}
    local s, e = read_file(path.inject)

    -- 递归处理依赖文件
    local function process_chain_files(file)
        if self.chain_table and self.chain_table[file] then
            for _, chain_file in ipairs(self.chain_table[file]) do
                if not r[chain_file] then
                    r[chain_file] = true
                    -- print(file .. " 的依赖文件同时注入: " .. chain_file)
                    -- 递归处理依赖文件的依赖
                    process_chain_files(chain_file)
                end
            end
        end
    end

    if s then
        -- 检查是否有需要注入的函数
        local all_table = self.new_table

        for function_name, file in pairs(all_table) do
            if not r[file] then -- 速度慢但是是全词匹配

                -- 根据函数名是否以YDWE开头选择不同的匹配模式
                if function_name:sub(1, 4) == "YDWE" then -- 简单模式
                    -- print(string.format("[简单模式]开始检测函数 '%s' 文件 '%s'", function_name, file))
                    if not r[file] and s:find(function_name:gsub("%.", "%%.")) then -- 速度很快但是不是全词匹配
                        -- if not r[file] and s:find("[^%w_]" .. function_name:gsub("%.", "%%.") .. "[^%w_]") then -- 速度慢但是是全词匹配
                        r[file] = true
                        process_chain_files(file)  -- 处理依赖文件
                    end
                else -- 严格模式
                    if not r[file] and s:find("[^%w_]" .. function_name:gsub("%.", "%%.") .. "[^%w_]") then -- 速度慢但是是全词匹配
                        r[file] = true
                        process_chain_files(file)  -- 处理依赖文件
                    end
                    --[[ local pattern = "[^%w_]" .. function_name:gsub("%.", "%%.") .. "[^%w_]" -- 严格模式,检查边界
                    print(string.format("[严格模式]开始检测函数 '%s' 文件 '%s'", function_name, file))
                    -- 调试输出
                    for line in s:gmatch("[^\r\n]+") do
                        if line:match(pattern) then
                            print(string.format("检测到函数 '%s' 在行: %s", function_name, line))
                            r[file] = true
                            break
                        end
                    end ]]
                end
            end
        end
    else
        print("Error occured when opening map script.")
        print(e)
    end

    -- 添加结束时间记录和输出
    local end_time = os.clock()
    print(string.format("函数检测用时: %.3f 秒", end_time - start_time))

    return r
end

-- 注入代码到Jass代码文件中
function inject_code:do_inject(path, tbl)
    -- 结果
    local result = 1
    if tbl and next(tbl) then
        -- 默认成功
        result = 0

        -- 首先读取原文件内容
        local original_content = read_file(path.inject)
        if not original_content then
            print("Error reading original file content")
            return -1
        end

        -- 打开文件供写入（覆盖模式）
        local map_script_file, e = io.open(path.inject, "w+b")
        if map_script_file then
            -- 循环处理每个需要注入的文件
            for injectPath in pairs(tbl) do
                local s = "    ...注入:... " .. injectPath
                local code_content = read_file(injectPath)
                if code_content then
                    -- 插入代码文件开头
                    map_script_file:write(code_content)
                    -- 写上一个换行符
                    map_script_file:write("\r\n")
                    -- 成功
                    s = s .. " √"
                    print(s)
                else
                    result = -1
                    s = s .. " ×"
                    print(s)
                end
            end

            -- 写入原始内容
            map_script_file:write(original_content)

            -- 关闭文件
            map_script_file:close()
        else
            result = -1
            print("Error occured when writing code to map script")
            print(e)
        end
    end

    return result
end

-- 编译注入
function inject_code:compile(path, injectPath)
    path.inject = injectPath
    return self:do_inject(path, self:detect(path))
end

-- 扫描注入代码
-- config_dir - 需要扫描的路径
-- 返回值无，修改全局变量inject_code_table_new以及inject_code_table_old
-- inject_code_table_new - 新版（1.24）函数表
-- inject_code_table_old - 旧版函数表
function inject_code:scan(config_dir)
    local counter = 0
    -- print("[注入扫描]" .. config_dir)
    local once = {}
    -- 遍历目录

    for configFile in lfs.dir(config_dir) do
        -- 跳过 "." 和 ".." 目录
        if configFile ~= "." and configFile ~= ".." then
            local full_path = config_dir .. "/" .. configFile
            if lfs.attributes(full_path, "mode") == "directory" then
                -- 递归处理
                counter = counter + self:scan(full_path)
            elseif get_extension(full_path) == ".cfg" then
                -- 插入新表
                local new_table = {}
                local old_table = {}

                -- 如果 self.chain_table 不存在则初始化
                if not self.chain_table then
                    self.chain_table = {}
                end

                -- 获取当前cfg文件的目录路径
                local base_dir = full_path:match("(.*[/\\])")
                local current_file = full_path:gsub("%.cfg$", ".j")

                -- 将相对路径转为绝对路径
                local function resolve_path(relative_path)
                    -- 处理 "../" 的情况
                    local abs_path = base_dir .. relative_path
                    abs_path = abs_path:gsub("[/\\]+", "/")  -- 统一路径分隔符

                    -- 处理 "../" 的情况
                    while abs_path:match("([^/]+)/%.%./") do
                        abs_path = abs_path:gsub("([^/]+)/%.%./", "")
                    end

                    return abs_path
                end

                local state = 0

                -- 循环处理每一行
                for line in io.lines(full_path) do
                    local trimed = trim(line)
                    if trimed ~= "" and trimed:sub(1, 1) ~= "#" then
                        if trimed == "[general]" then
                            state = 0
                        elseif trimed == "[new]" then
                            state = 1
                        elseif trimed == "[old]" then
                            state = 2
                        elseif trimed == "[chain]" then
                            state = 3
                            self.chain_table[current_file] = self.chain_table[current_file] or {}
                        else
                            if state == 0 then
                                table.insert(new_table, trimed)
                                table.insert(old_table, trimed)
                            elseif state == 1 then
                                table.insert(new_table, trimed)
                            elseif state == 2 then
                                table.insert(old_table, trimed)
                            elseif state == 3 then
                                -- 将相对路径转换为绝对路径后存入
                                local abs_path = resolve_path(trimed)
                                table.insert(self.chain_table[current_file], abs_path)
                                -- print(current_file .. " 的依赖文件: " .. abs_path)
                            end
                        end
                    end
                end

                -- 插入全局表中（替换文件扩展名）
                local substitution = full_path:gsub("%.cfg$", ".j")
                local function insert(file, a, b)
                    for _, fname in ipairs(a) do
                        if b[fname] then
                            local unuse = file
                            print('注入函数[' .. fname .. ']重复定义')
                            if lfs.attributes(file, "modification") > lfs.attributes(b[fname], "modification") then
                                unuse = b[fname]
                                b[fname] = file
                            end
                            if not once[fname] then
                                print('注入函数[' .. fname .. ']重复定义')
                                print('	生效', b[fname], lfs.attributes(b[fname], "modification"))
                                print('	失效', unuse, lfs.attributes(unuse, "modification"))
                                once[fname] = true
                            end
                        else
                            b[fname] = file
                        end
                    end
                end
                insert(substitution, old_table, self.old_table)
                insert(substitution, new_table, self.new_table)
                counter = counter + 1
            end
        end
    end
    return counter
end

-- 扫描后表就变成了:  self.new_table[函数名] = 文件路径
-- 例子:
-- self.new_table["DzFrameIsVisible"] = "D:/WE/KKWE_Plugin/jass/Base/DzFrame.j"
function inject_code:initialize()
    local counter = self:scan("D:/WE/KKWE_Plugin/jass")
    -- print(("[注入函数]总数量: %d"):format(counter))
end

return inject_code
