inject_code = {}

-- 注入代码表
inject_code.new_table = {}
inject_code.old_table = {}
inject_code.chain_table = {} -- 链式依赖

local root = fs.ydwe_path():parent_path():remove_filename():remove_filename() / "Component"
if not fs.exists(root) then
	root = fs.ydwe_path()
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
	local r = {}
	local s, e = io.load(op.input)

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

	if s then
		local all_table = op.option.runtime_version:is_new() and self.new_table or self.old_table

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
				if function_name:sub(1, 4) == "YDWE" then
					if s:find(function_name:gsub("%.", "%%.")) then
						r[file_path] = true
						process_chain_files(file)
					end
				else
					if s:find("[^%w_]" .. function_name:gsub("%.", "%%.") .. "[^%w_]") then
						r[file_path] = true
						process_chain_files(file)
					end
				end
			end
		end
	else
		log.error("Error occured when opening map script.")
		log.error(e)
	end
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
			-- 先写入需要注入的代码
			for path in pairs(tbl) do
				log.trace("Injecting " .. path:string())
				local code_content, e = io.load(path)
				if code_content then
					-- 插入代码到文件开头
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

			-- 写入原始内容
			map_script_file:write(original_content)

			-- 关闭文件
			map_script_file:close()
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
				base_dir = "."  -- 如果没有找到目录分隔符，使用当前目录
			end

			local current_file = full_path_str:gsub("%.cfg$", ".j")

			-- 将相对路径转为绝对路径
			local function resolve_path(relative_path)
				-- 添加调试日志

				local abs_path = base_dir .. "/" .. relative_path
				abs_path = abs_path:gsub("[/\\]+", "/")


				-- 处理 "../" 的情况
				while abs_path:match("([^/]+)/%.%./") do
					local before = abs_path
					abs_path = abs_path:gsub("([^/]+)/%.%./", "")
				end

				return abs_path
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
