local lfs = require("lfs")
local path = require("Lua.path")
local inject_code = {}

-- 注入代码表
inject_code.new_table = {}
inject_code.old_table = {}
inject_code.chain_table = {} -- 链式依赖
inject_code.detect_cache = {} -- 结果缓存
inject_code.obj_files = {
    ability = {},
    item = {},
    unit = {}
}

local obj_seen = {
    ability = {},
    item = {},
    unit = {}
}

local function reset_obj_files()
    for key in pairs(inject_code.obj_files) do
        inject_code.obj_files[key] = {}
        obj_seen[key] = {}
    end
end

local function add_obj_file(kind, file_path)
    if not obj_seen[kind][file_path] then
        table.insert(inject_code.obj_files[kind], file_path)
        obj_seen[kind][file_path] = true
    end
end

local function build_obj_files_from_result(result)
    reset_obj_files()
    if not result then
        return
    end
    local mapping = {
        ability = ".w3a",
        item = ".w3i",
        unit = ".w3u"
    }
    for file_path in pairs(result) do
        if type(file_path) == "string" then
            local base = file_path:gsub("%.j$", "")
            if base ~= file_path then
                for kind, ext in pairs(mapping) do
                    local candidate = base .. ext
                    local attr = lfs.attributes(candidate)
                    if attr and attr.mode == "file" then
                        add_obj_file(kind, candidate)
                    end
                end
            end
        end
    end
end

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

local function canonicalize_linked_path(file_path)
    local normalized = file_path:gsub("\\", "/")
    local linked_root = (path.project .. "/.linked/"):gsub("\\", "/")
    if normalized:sub(1, #linked_root) ~= linked_root then
        return normalized
    end

    local relative = normalized:sub(#linked_root + 1)
    if relative:find("/", 1, true) then
        return normalized
    end

    local crainax_candidate = linked_root .. "Crainax/" .. relative
    if lfs.attributes(crainax_candidate, "mode") == "file" then
        return crainax_candidate
    end

    return normalized
end

-- 计算函数名集合签名（用于缓存键）
local function compute_keys_signature(name_to_file_table)
    local keys = {}
    for fname in pairs(name_to_file_table or {}) do
        table.insert(keys, fname)
    end
    table.sort(keys)
    local concat = table.concat(keys, "\n")
    local sum = 0
    for i = 1, #concat do
        sum = (sum + concat:byte(i)) % 1000000007
    end
    return tostring(#keys) .. ":" .. tostring(sum)
end

-- 计算链表签名（用于缓存键）
local function compute_chain_signature(chain_table)
    if not chain_table then return "0:0" end
    local items = {}
    for file, deps in pairs(chain_table) do
        local copy = {}
        for i = 1, #deps do copy[i] = deps[i] end
        table.sort(copy)
        table.insert(items, file .. "->" .. table.concat(copy, ","))
    end
    table.sort(items)
    local concat = table.concat(items, "\n")
    local sum = 0
    for i = 1, #concat do
        sum = (sum + concat:byte(i)) % 1000000007
    end
    return tostring(#items) .. ":" .. tostring(sum)
end

-- 构建标识符索引：
-- 返回两个集合：
-- 1) wordSet：出现过的“词”（[%w_]+）
-- 2) windowSet：由点连接的连续词窗口（长度范围[2, maxSegments]）
local function build_identifier_index(s, maxSegments)
    local wordSet = {}
    local windowSet = {}

    local function finalize_sequence(seq)
        local n = #seq
        if n >= 2 then
            local upper = maxSegments
            if not upper or upper > n then upper = n end
            for k = 2, upper do
                for i = 1, n - k + 1 do
                    local name = table.concat(seq, ".", i, i + k - 1)
                    windowSet[name] = true
                end
            end
        end
    end

    for line in s:gmatch("[^\r\n]+") do
        local len = #line
        local pos = 1
        local seq = {}
        local prev = "other" -- other | word | dot
        while pos <= len do
            local a, b = line:find("[%w_]+", pos)
            if a == pos then
                local w = line:sub(a, b)
                wordSet[w] = true
                if prev == "dot" then
                    table.insert(seq, w)
                elseif prev == "word" then
                    finalize_sequence(seq)
                    seq = { w }
                else -- other
                    seq = { w }
                end
                pos = b + 1
                prev = "word"
            else
                local da, db = line:find("%.", pos)
                if da == pos then
                    if prev ~= "word" then
                        finalize_sequence(seq)
                        seq = {}
                    end
                    pos = db + 1
                    prev = "dot"
                else
                    if prev ~= "other" then
                        finalize_sequence(seq)
                        seq = {}
                        prev = "other"
                    end
                    pos = pos + 1
                end
            end
        end
        if prev ~= "other" then
            finalize_sequence(seq)
        end
    end

    return wordSet, windowSet
end

-- 侦测需要注入哪些代码(使用的是string.find方式,所以说注释下也会检测到)
function inject_code:detect(path)
    -- 添加开始时间记录
    local start_time = os.clock()

    local result = {}
    local s, err = read_file(path.inject)
    if not s then
        print("Error occured when opening map script.")
        print(err)
        return result
    end

    -- 构建缓存键
    local attr = lfs.attributes(path.inject)
    local file_sig = (attr and ((attr.modification or 0) .. ":" .. (attr.size or 0))) or "0:0"
    local keys_sig = compute_keys_signature(self.new_table)
    local chain_sig = compute_chain_signature(self.chain_table)
    local cache_key = table.concat({ path.inject, file_sig, keys_sig, chain_sig }, "|")

    local cache_entry = self.detect_cache[cache_key]
    if cache_entry then
        -- 命中缓存
        build_obj_files_from_result(cache_entry)
        local end_time_cached = os.clock()
        print(string.format("函数检测用时: %.3f 秒", end_time_cached - start_time))
        return cache_entry
    end

    -- 递归处理依赖文件
    local function process_chain_files(file)
        if self.chain_table and self.chain_table[file] then
            for _, chain_file in ipairs(self.chain_table[file]) do
                if not result[chain_file] then
                    result[chain_file] = true
                    process_chain_files(chain_file)
                end
            end
        end
    end

    -- 计算函数名的最大分段数（按点切分）
    local maxSegments = 1
    for fname in pairs(self.new_table) do
        local segs = 1
        for _ in fname:gmatch("%.") do segs = segs + 1 end
        if segs > maxSegments then maxSegments = segs end
    end

    -- 单次扫描构建索引
    local wordSet, windowSet = build_identifier_index(s, maxSegments)

    -- 匹配逻辑：
    -- - 含点：用 windowSet 精确命中（等价于 "%f[%w_]A%.B%f[^%w_]" 语义）
    -- - 不含点：用 wordSet 命中（等价于 "%f[%w_]NAME%f[^%w_]" 语义）
    for function_name, file in pairs(self.new_table) do
        if not result[file] then
            local hasDot = function_name:find("%.") ~= nil

            if function_name:sub(1, 4) == "YDWE" then
                -- 简单模式：优先用索引命中，避免全文扫描
                if hasDot then
                    if windowSet[function_name] then
                        -- print(string.format("[简单模式]检测到函数 '%s' 文件 '%s'", function_name, file))
                        result[file] = true
                        process_chain_files(file)
                    end
                else
                    if wordSet[function_name] then
                        -- print(string.format("[简单模式]检测到函数 '%s' 文件 '%s'", function_name, file))
                        result[file] = true
                        process_chain_files(file)
                    end
                end
            else
                -- 严格模式
                if hasDot then
                    if windowSet[function_name] then
                        print(string.format("[严格模式]检测到函数 '%s' 文件 '%s'", function_name, file))
                        result[file] = true
                        process_chain_files(file)
                    end
                else
                    if wordSet[function_name] then
                        print(string.format("[严格模式]检测到函数 '%s' 文件 '%s'", function_name, file))
                        result[file] = true
                        process_chain_files(file)
                    end
                end
            end
        end
    end

    -- 写入缓存
    self.detect_cache[cache_key] = result

    build_obj_files_from_result(result)

    -- 添加结束时间记录和输出
    local end_time = os.clock()
    print(string.format("函数检测用时: %.3f 秒", end_time - start_time))

    return result
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

-- 注入宏头(最后调用)
function inject_code:injectMacro(injectPath)
    -- 首先读取原文件内容
local original_content = read_file(injectPath)
    if not original_content then
        print("Error reading original file content")
        return
    end

    -- 打开文件供写入（覆盖模式）
    local file, err = io.open(injectPath, "w")
    if not file then
        print("Error opening file for writing:", err)
        return
    end

    -- 先写入宏定义
    file:write("#define USE_BJ_ANTI_LEAK\n")
    file:write("#define USE_BJ_OPTIMIZATION\n")
    file:write("#include <YDTrigger/Import.h>\n")   --这条还是要写,在Alljass.h里直接导入就行了,不用搞这么多弯弯绕绕
    file:write("#include <YDTrigger/YDTrigger.h>\n")
    file:write("#include \"config/rewave.h\"\n")
    file:write("\n")  -- 添加一个空行分隔

    -- 写入原始内容
    file:write(original_content)

    -- 关闭文件
    file:close()
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
                local current_file = canonicalize_linked_path(full_path:gsub("%.cfg$", ".j"))

                -- 将相对路径转为绝对路径
                local function resolve_path(relative_path)
                    -- 首先统一路径分隔符为 "/"
                    local normalized_base = base_dir:gsub("\\", "/")
                    local normalized_relative = relative_path:gsub("\\", "/")

                    -- 确保基础路径以 "/" 结尾
                    if not normalized_base:match("/$") then
                        normalized_base = normalized_base .. "/"
                    end


                    -- 如果是以 ../ 开头的相对路径
                    if normalized_relative:match("^%.%.") then
                        local parts = {}

                        -- 分割基础路径
                        for part in normalized_base:gmatch("[^/]+") do
                            table.insert(parts, part)
                        end

                        -- 分割相对路径
                        for part in normalized_relative:gmatch("[^/]+") do
                            if part == ".." then
                                table.remove(parts) -- 移除最后一个目录
                            else
                                table.insert(parts, part)
                            end
                        end

                        -- 重新组合路径
                        local result = table.concat(parts, "/")
                        return canonicalize_linked_path(result)
                    elseif normalized_relative:match("^/") then
                        return canonicalize_linked_path(normalized_relative)
                    else
                        -- 如果是普通的相对路径（不以 ../ 或 / 开头），
                        -- 则在当前目录下查找
                        local result = normalized_base .. normalized_relative
                        return canonicalize_linked_path(result)
                    end
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
                local substitution = canonicalize_linked_path(full_path:gsub("%.cfg$", ".j"))
                local function file_mtime(p)
                    local attr = lfs.attributes(p)
                    if attr then
                        return attr.modification or 0
                    end
                    return 0
                end
                local function insert(file, a, b)
                    local seen = {}
                    for _, fname in ipairs(a) do
                        if not seen[fname] then
                            seen[fname] = true
                            if b[fname] then
                                if b[fname] ~= file then
                                    local unuse = file
                                    if file_mtime(file) > file_mtime(b[fname]) then
                                        unuse = b[fname]
                                        b[fname] = file
                                    end
                                    if not once[fname] then
                                        print('注入函数[' .. fname .. ']重复定义')
                                        print('	生效', b[fname], file_mtime(b[fname]))
                                        print('	失效', unuse, file_mtime(unuse))
                                        once[fname] = true
                                    end
                                end
                            else
                                b[fname] = file
                            end
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
    self.new_table = {}
    self.old_table = {}
    self.chain_table = {}
    self.detect_cache = {}
    reset_obj_files()

    local hasLocalCrainax = false
    if lfs.attributes(path.project .. "/.linked", "mode") == "directory" then
        self:scan(path.project .. "/.linked")
        hasLocalCrainax = true
    elseif lfs.attributes(path.project .. "/Jass", "mode") == "directory" then
        self:scan(path.project .. "/Jass")
    end

    local counter = 0
    if hasLocalCrainax then
        local weJass = path.we .. "/jass"
        if lfs.attributes(weJass, "mode") == "directory" then
            for name in lfs.dir(weJass) do
                if name ~= "." and name ~= ".." and name ~= "Crainax" and name ~= "japi" then
                    local fullPath = weJass .. "/" .. name
                    if lfs.attributes(fullPath, "mode") == "directory" then
                        counter = counter + self:scan(fullPath)
                    end
                end
            end
        end
    else
        counter = self:scan(path.we .. "/jass")
    end

    -- print(("[注入函数]总数量: %d"):format(counter))
end

return inject_code
