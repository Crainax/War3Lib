inject_code = {}

-- 注入代码表
inject_code.new_table = {}
inject_code.old_table = {}
inject_code.chain_table = {} -- 链式依赖
inject_code.detect_cache = {} -- 结果缓存

local root = fs.ydwe_path():parent_path():remove_filename():remove_filename() / "Component"
if not fs.exists(root) then
	root = fs.ydwe_path()
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
-- 1) wordSet：出现过的"词"（[%w_]+）
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

function inject_code:inject_file(op, path_in_archive)
	op.inject_file(root / "share" / "mpq" / "units" / path_in_archive, path_in_archive)
end

-- 侦测需要注入哪些代码
-- op.input - 脚本的路径，fs.path变量
-- op.option - 选项，table类型，支持成员：
-- 	runtime_version - 表示魔兽版本
-- 返回：一个table，数组形式，包含所有需要注入的文件名（注意不是fs.path）
function inject_code:detect(op)
	-- 添加开始时间记录
	local start_time = os.clock()

	local r = {}
	local s, e = io.load(op.input)
	if not s then
		log.error("Error occured when opening map script.")
		log.error(e)
		return r
	end

	-- 构建缓存键
	local file_time = fs.last_write_time(op.input)
	local file_size = 0
	if fs.exists(op.input) then
		-- YDWE 环境中可能没有 fs.file_size，使用字符串长度作为替代
		file_size = #s
	end
	local file_sig = tostring(file_time) .. ":" .. tostring(file_size)
	local all_table = op.option.runtime_version:is_new() and self.new_table or self.old_table
	local keys_sig = compute_keys_signature(all_table)
	local chain_sig = compute_chain_signature(self.chain_table)
	local version_sig = op.option.runtime_version:is_new() and "new" or "old"
	local cache_key = table.concat({ tostring(op.input), file_sig, keys_sig, chain_sig, version_sig }, "|")

	local cache_entry = self.detect_cache[cache_key]
	if cache_entry then
		-- 命中缓存
		local end_time_cached = os.clock()
		log.trace(string.format("函数检测用时: %.3f 秒 (缓存命中)", end_time_cached - start_time))
		return cache_entry
	end

	-- 修改递归处理依赖文件的函数
	local function process_chain_files(file)
		-- 尝试不同的路径格式来查找依赖
		local file_str = tostring(file)
		local normalized_path = file_str:gsub("\\", "/")

		local deps = self.chain_table[file_str] or self.chain_table[normalized_path]

		if deps then
			for i, chain_file in ipairs(deps) do
				-- 将chain_file转换为fs.path对象
				local chain_path = fs.path(chain_file)

				-- 检查是否已经添加过这个文件（使用规范化的路径进行比较）
				local chain_path_str = tostring(chain_path):gsub("\\", "/")
				local already_exists = false

				for existing_path in pairs(r) do
					local existing_str = tostring(existing_path):gsub("\\", "/")
					if existing_str == chain_path_str then
						already_exists = true
						break
					end
				end

				if not already_exists then
					r[chain_path] = true
					process_chain_files(chain_file)
				end
			end
		end
	end

	-- 计算函数名的最大分段数（按点切分）
	local maxSegments = 1
	for fname in pairs(all_table) do
		local segs = 1
		for _ in fname:gmatch("%.") do segs = segs + 1 end
		if segs > maxSegments then maxSegments = segs end
	end

	-- 单次扫描构建索引
	local wordSet, windowSet = build_identifier_index(s, maxSegments)

	-- 匹配逻辑：
	-- - 含点：用 windowSet 精确命中（等价于 "%f[%w_]A%.B%f[^%w_]" 语义）
	-- - 不含点：用 wordSet 命中（等价于 "%f[%w_]NAME%f[^%w_]" 语义）
	for function_name, file in pairs(all_table) do
		local file_path = fs.path(file)
		-- 检查是否已经添加过这个文件（使用规范化的路径进行比较）
		local file_path_str = tostring(file_path):gsub("\\", "/")
		local already_exists = false

		for existing_path in pairs(r) do
			local existing_str = tostring(existing_path):gsub("\\", "/")
			if existing_str == file_path_str then
				already_exists = true
				break
			end
		end

		if not already_exists then
			local hasDot = function_name:find("%.") ~= nil

			if function_name:sub(1, 4) == "YDWE" then
				-- 简单模式：优先用索引命中，避免全文扫描
				if hasDot then
					if windowSet[function_name] then
						log.trace(string.format("[简单模式]检测到函数 '%s' 文件 '%s'", function_name, tostring(file_path)))
						r[file_path] = true
						process_chain_files(file)
					end
				else
					if wordSet[function_name] then
						log.trace(string.format("[简单模式]检测到函数 '%s' 文件 '%s'", function_name, tostring(file_path)))
						r[file_path] = true
						process_chain_files(file)
					end
				end
			else
				-- 严格模式
				if hasDot then
					if windowSet[function_name] then
						log.trace(string.format("[严格模式]检测到函数 '%s' 文件 '%s'", function_name, tostring(file_path)))
						r[file_path] = true
						process_chain_files(file)
					end
				else
					if wordSet[function_name] then
						log.trace(string.format("[严格模式]检测到函数 '%s' 文件 '%s'", function_name, tostring(file_path)))
						r[file_path] = true
						process_chain_files(file)
					end
				end
			end
		end
	end

	-- 写入缓存
	self.detect_cache[cache_key] = r

	-- 添加结束时间记录和输出
	local end_time = os.clock()
	log.trace(string.format("函数检测用时: %.3f 秒", end_time - start_time))

	return r
end

-- 注入代码到Jass代码文件（最常见的是war3map.j）中
-- op.output - war3map.j的路径，fs.path对象
-- tbl - 所有需要注入代码文件路径，table，table中可以是
-- 		string - 此时为YDWE / "jass" 目录下的对应名称的文件
--		fs.path - 此时取其路径
-- 注：该table必须是数组形式的，哈希表形式的不处理
-- 返回值：0 - 成功；-1 - 出错失败；1 - 什么都没做
function inject_code:do_inject(op, tbl)
	-- 结果
	local result = 1
	if tbl and next(tbl) then
		-- 默认成功
		result = 0
		log.trace("Writing code to " .. op.output:filename():string())

		-- 先读取原文件的所有内容
		local original_content, read_err = io.load(op.output)
		if not original_content then
			result = -1
			log.error("Error occurred when reading original map script")
			log.error(read_err)
			return result
		end

		-- 打开文件供写入（读写模式）
		local map_script_file, e = io.open(op.output, "w+b")
		if map_script_file then
			-- 首先写入宏定义
			map_script_file:write("#define USE_BJ_ANTI_LEAK\n")
			map_script_file:write("#define USE_BJ_OPTIMIZATION\n")
			map_script_file:write("#include <YDTrigger/Import.h>\n")
			map_script_file:write("#include <YDTrigger/YDTrigger.h>\n")
			map_script_file:write("\n")  -- 添加一个空行分隔

			-- 然后写入需要注入的代码
			for path in pairs(tbl) do
				log.trace("Injecting " .. path:string())
				local code_content, e = io.load(path)
				if code_content then
					-- 插入代码到文件
					map_script_file:write(code_content)
					-- 写入换行符
					map_script_file:write("\r\n")
					log.trace("Injection completed")
				else
					result = -1
					log.error("Error occurred when reading code to inject.")
					log.error(e)
				end
			end

			-- 最后写入原始内容
			map_script_file:write(original_content)

			-- 关闭文件
			map_script_file:close()

			log.trace("Macro headers and code injection completed")
		else
			result = -1
			log.error("Error occurred when writing code to map script")
			log.error(e)
		end
	end

	return result
end

function inject_code:compile(op)
	op.output = op.input
	return self:do_inject(op, self:detect(op))
end

-- 扫描注入代码
-- config_dir - 需要扫描的路径
-- 返回值无，修改全局变量inject_code_table_new以及inject_code_table_old
-- inject_code_table_new - 新版（1.24）函数表
-- inject_code_table_old - 旧版函数表
function inject_code:scan(config_dir)
	local counter = 0
	log.trace("Scanning for inject files in " .. config_dir:string())
	local once = {}
	-- 遍历目录
	for full_path in config_dir:list_directory() do
		if fs.is_directory(full_path) then
			-- 递归处理
			counter = counter + self:scan(full_path)
		elseif full_path:extension():string() == ".cfg" then
			-- 插入新表
			local new_table = {}
			local old_table = {}

			-- 如果 self.chain_table 不存在则初始化
			if not self.chain_table then
				self.chain_table = {}
			end

			-- 获取当前cfg文件的目录路径
			local full_path_str = tostring(full_path)
			local base_dir = full_path_str:match("(.+)[/\\]")
			if not base_dir then
				base_dir = "." -- 如果没有找到目录分隔符，使用当前目录
			end

			local current_file = full_path_str:gsub("%.cfg$", ".j")

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
					return result
				elseif normalized_relative:match("^/") then
					return normalized_relative
				else
					-- 如果是普通的相对路径（不以 ../ 或 / 开头），
					-- 则在当前目录下查找
					local result = normalized_base .. normalized_relative
					return result
				end
			end

			-- 解析状态，默认0
			-- 0 - 1.24/1.20通用
			-- 1 - 1.24专用
			-- 2 - 1.20专用
			local state = 0

			-- 循环处理每一行
			for line in io.lines(full_path) do
				-- 插入函数名
				local trimed = line:trim()
				if trimed ~= "" and trimed:sub(1, 1) ~= "#" then
					if trimed == "[general]" then
						state = 0
					elseif trimed == "[new]" then
						state = 1
					elseif trimed == "[old]" then
						state = 2
					elseif trimed == "[chain]" then
						state = 3
						-- 标准化路径格式
						local normalized_current = current_file:gsub("\\", "/")
						self.chain_table[normalized_current] = self.chain_table[normalized_current] or {}
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
							-- 标准化路径格式
							local normalized_current = current_file:gsub("\\", "/")
							table.insert(self.chain_table[normalized_current], abs_path)
						end
					end
				end
			end

			-- 插入全局表中（替换文件扩展名）
			local substitution = full_path
			substitution = substitution:replace_extension(fs.path(".j"))
			local function insert(file, a, b)
				for _, fname in ipairs(a) do
					if b[fname] then
						local unuse = file
						log.warn('注入函数[' .. fname .. ']重复定义')
						if fs.last_write_time(file) > fs.last_write_time(b[fname]) then
							unuse = b[fname]
							b[fname] = file
						end
						if not once[fname] then
							log.warn('注入函数[' .. fname .. ']重复定义')
							log.warn('	生效', b[fname], fs.last_write_time(b[fname]))
							log.warn('	失效', unuse, fs.last_write_time(unuse))
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

	return counter
end

function inject_code:initialize()
	local counter = self:scan(root / "jass")
	log.trace(string.format("Scanned file: %d", counter))
end
