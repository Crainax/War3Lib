local flag = {
	['path'] = [[D:\War3Asset\Model\ShangqueDIY\XIaoren_2\text5\5.mdl]],        -- 要处理的文件名
	['output'] = [[D:\War3Asset\Model\Shangquemoxing\20251105\Zhende\A (169).txt]] -- Debug输出的位置
}

-- ====== 配置常量 ======
local EPS = 1e-5  -- 数值归零阈值
local OUTPUT_PREC = 7  -- 输出精度（小数位数）

-- ====== 工具函数 ======
-- 数值归一化：阈值归零、-0修正、格式化输出
local function normalizeNumber(n)
	if type(n) ~= "number" then
		n = tonumber(n)
		if not n then return "0" end
	end
	-- 阈值归零
	if math.abs(n) < EPS then
		return "0"
	end
	-- -0 修正
	if n == 0 then
		return "0"
	end
	-- 格式化输出，去除尾随0
	local formatted = string.format("%." .. OUTPUT_PREC .. "f", n)
	-- 去除尾随0和小数点
	formatted = formatted:gsub("%.?0+$", "")
	return formatted
end

-- 提取花括号内的向量值（用于去重比较）
-- 返回: {x, y, z} 或 {x, y, z, w} 或 nil（如果不是标准格式）
local function extractFirstVector(line)
	-- 匹配 { x, y, z } 或 { x, y, z, w } 格式
	local match = line:match("{%s*([^}]+)%s*}")
	if not match then return nil end

	local values = {}
	-- 改进的正则：匹配数字（包括科学计数法）
	-- 模式：可选负号 + 数字（整数或小数）+ 可选科学计数法部分
	for num in match:gmatch("([%-]?%d+%.?%d*[eE]?[%+%-]?%d*)") do
		local n = tonumber(num)
		if n then
			-- 归一化后再比较
			if math.abs(n) < EPS then
				table.insert(values, 0)
			else
				table.insert(values, n)
			end
		end
	end

	if #values >= 3 then
		return values
	end
	return nil
end

-- 比较两个向量是否完全相同（用于去重）
local function vectorsEqual(v1, v2)
	if not v1 or not v2 then return false end
	if #v1 ~= #v2 then return false end
	for i = 1, #v1 do
		if math.abs(v1[i] - v2[i]) >= EPS then
			return false
		end
	end
	return true
end

-- 规范化花括号内的数字：只处理 { ... } 内的数字，支持 e/E 和 +/- 指数
local function normalizeBraceGroup(line)
	local scientificCount = 0

	-- 替换花括号内的数字（支持科学计数法 e/E 和 +/- 指数）
	local normalized = line:gsub("({[^}]*})", function(braceContent)
		local result = braceContent

		-- 匹配所有数字（包括科学计数法）：可选负号 + 数字 + 可选科学计数法部分
		-- 使用更精确的模式：数字.数字 e/E +/- 数字
		result = result:gsub("([%-]?%d+%.?%d*[eE][%+%-]?%d+|[%-]?%d+%.?%d+)", function(numStr)
			-- 检查是否是科学计数法
			if numStr:match("[eE]") then
				scientificCount = scientificCount + 1
			end
			local num = tonumber(numStr)
			if num then
				return normalizeNumber(num)
			end
			return numStr
		end)

		return result
	end)

	return normalized, scientificCount
end

-- 删除缩放[骨骼]/清理移动[误差0.1]/清理科学计数移动帧/优化旋转中E科学计数帧
local function OptimizeMDL()
	-- 统计信息
	local stats = {
		scalingBlocks = 0,    -- 删除的 Scaling 块数量
		translationBlocks = 0, -- 处理的 Translation 块数量
		translationDeleted = 0, -- 删除的 Translation 块数量（全为0的）
		translationKeyframesRemoved = 0, -- Translation 去重删除的关键帧数量
		rotationBlocks = 0,   -- 处理的 Rotation 块数量
		rotationKeyframesRemoved = 0, -- Rotation 去重删除的关键帧数量
		scientificCountRemoved = 0, -- 清理的科学计数法数量（包含 e/E 和 +/- 指数）
		totalLines = 0        -- 处理的总行数
	}

	local inScaling = false
	local inTran = false -- 是否在Tran的模块内
	local inRotate = false
	local sTran = ""  -- Translation 块累积内容
	local tranDel = true       -- 是否真的删除该移动
	local tranScientificCount = 0 -- Translation 块中的科学计数法数量
	local tranLastVector = nil  -- Translation 上一条保留的关键帧向量（用于去重）
	local tranKeyframeCount = 0  -- Translation 实际保留的关键帧数量
	local rotLastVector = nil  -- Rotation 上一条保留的关键帧向量（用于去重）
	local rotBuffer = ""  -- Rotation 块累积内容
	local rotKeyframeCount = 0  -- Rotation 实际保留的关键帧数量

	print("Processing file: " .. flag.path)
	-- 保持原行为：清空 Debug 输出文件（即使后续不写入）
	do
		local dbg = io.open(flag.output, "w")
		if dbg then dbg:close() end
	end

	-- 打开输入文件
	local fileIn = io.open(flag.path, "r")
	if not fileIn then
		print("Error: Cannot open input file: " .. flag.path)
		return
	end

	-- 就地覆盖写回：先写临时文件，最后替换原文件（Windows 下更安全）
	local tmpPath = flag.path .. ".tmp"
	local fileOut = io.open(tmpPath, "w")
	if not fileOut then
		fileIn:close()
		print("Error: Cannot open temp output file: " .. tmpPath)
		return
	end

	-- 逐行读取并处理
	local line = fileIn:read()
	while line do
		stats.totalLines = stats.totalLines + 1

		-- 删除缩放.[骨骼模型不需要缩放]
		if line:match("Scaling") then
			stats.scalingBlocks = stats.scalingBlocks + 1
			if stats.scalingBlocks % 10 == 0 then
				print(string.format("  Removed %d Scaling blocks...", stats.scalingBlocks))
			end
			inScaling = true
			line = nil
		elseif inScaling then
			if line:match("^%s*}%s*$") then
				inScaling = false
			end
			line = nil
		elseif line:match("Translation") then
			-- 清理移动.[归一化数值/去重关键帧/判断是否全为0删除]
			stats.translationBlocks = stats.translationBlocks + 1
			if stats.translationBlocks % 10 == 0 then
				print(string.format("  Processed %d Translation blocks...", stats.translationBlocks))
			end
			inTran = true
			sTran = line .. '\n'
			tranScientificCount = 0
			tranDel = true  -- 默认删除，如果发现非零值则保留
			tranLastVector = nil  -- 重置上一条向量
			tranKeyframeCount = 0  -- 重置关键帧计数
			line = nil
		elseif inTran then
			local originalLine = line
			local isEndBrace = line:match("^%s*}%s*$")

			-- 如果不是结束花括号，尝试提取向量进行去重判断
			if not isEndBrace then
				local vec = extractFirstVector(line)
				if vec and #vec >= 3 then
					-- 检查是否有非零值
					if vec[1] ~= 0 or vec[2] ~= 0 or vec[3] ~= 0 then
						tranDel = false
					end

					-- 去重：如果与上一条相同，跳过此关键帧
					if tranLastVector and vectorsEqual(vec, tranLastVector) then
						stats.translationKeyframesRemoved = stats.translationKeyframesRemoved + 1
						line = nil
					else
						-- 保留此关键帧，更新上一条向量
						tranLastVector = vec
						tranKeyframeCount = tranKeyframeCount + 1  -- 增加关键帧计数
						-- 规范化这一行
						local normalized, sciCount = normalizeBraceGroup(line)
						tranScientificCount = tranScientificCount + sciCount
						sTran = sTran .. normalized .. '\n'
						line = nil
					end
				else
					-- 非标准格式行（如 DontInterp 等），直接保留
					sTran = sTran .. line .. '\n'
					line = nil
				end
			else
				-- 结束花括号
				if not (tranDel) then
					-- 如果保留，更新块头数字并输出累积内容
					sTran = sTran .. line .. '\n'
					-- 替换块头数字：Translation 数字 { -> Translation 实际数量 {
					sTran = sTran:gsub("(Translation%s+)(%d+)(%s*{)", function(prefix, oldNum, suffix)
						return prefix .. tostring(tranKeyframeCount) .. suffix
					end)
					line = sTran
					stats.scientificCountRemoved = stats.scientificCountRemoved + tranScientificCount
				else
					-- 全为0，删除整个块
					stats.translationDeleted = stats.translationDeleted + 1
					stats.scientificCountRemoved = stats.scientificCountRemoved + tranScientificCount
					line = nil
				end
				inTran = false
				tranDel = true
				tranScientificCount = 0
				tranLastVector = nil
				tranKeyframeCount = 0
			end
		elseif line:match("Rotation") then
			-- 清理旋转[归一化数值/去重关键帧]
			stats.rotationBlocks = stats.rotationBlocks + 1
			if stats.rotationBlocks % 10 == 0 then
				print(string.format("  Processed %d Rotation blocks...", stats.rotationBlocks))
			end
			inRotate = true
			rotBuffer = line .. '\n'
			rotLastVector = nil  -- 重置上一条向量
			rotKeyframeCount = 0  -- 重置关键帧计数
			-- 块头不直接输出，等待块结束时一次性输出（并更新 Rotation N）
			line = nil
		elseif inRotate then
			local originalLine = line
			local isEndBrace = line:match("^%s*}%s*$")

			if isEndBrace then
				-- 结束花括号，更新块头数字并输出
				rotBuffer = rotBuffer .. line .. '\n'
				-- 替换块头数字：Rotation 数字 { -> Rotation 实际数量 {
				rotBuffer = rotBuffer:gsub("(Rotation%s+)(%d+)(%s*{)", function(prefix, oldNum, suffix)
					return prefix .. tostring(rotKeyframeCount) .. suffix
				end)
				line = rotBuffer
				rotBuffer = ""
				inRotate = false
				rotLastVector = nil
				rotKeyframeCount = 0
			else
				-- 尝试提取向量进行去重判断
				local vec = extractFirstVector(line)
				if vec and #vec >= 3 then
					-- 去重：如果与上一条相同，跳过此关键帧
					if rotLastVector and vectorsEqual(vec, rotLastVector) then
						stats.rotationKeyframesRemoved = stats.rotationKeyframesRemoved + 1
						line = nil
					else
						-- 保留此关键帧，更新上一条向量
						rotLastVector = vec
						rotKeyframeCount = rotKeyframeCount + 1  -- 增加关键帧计数
						-- 规范化这一行
						local normalized, sciCount = normalizeBraceGroup(line)
						stats.scientificCountRemoved = stats.scientificCountRemoved + sciCount
						rotBuffer = rotBuffer .. normalized .. '\n'
						line = nil
					end
				else
					-- 非标准格式行（如 DontInterp 等），直接保留
					rotBuffer = rotBuffer .. line .. '\n'
					line = nil
				end
			end
		end

		-- 每处理 10000 行显示一次进度
		if stats.totalLines % 10000 == 0 then
			print(string.format("  Processed %d lines...", stats.totalLines))
		end

		-- 如果处理后的行不为 nil，写入输出文件
		if line then
			fileOut:write(line)
			fileOut:write("\n")
		end

		-- 读取下一行
		line = fileIn:read()
	end

	-- 关闭文件
	fileIn:close()
	fileOut:close()

	-- 替换回原文件
	collectgarbage() -- 尽量确保无残留句柄（Windows 有时需要）
	os.remove(flag.path) -- 忽略返回值：不存在/占用会导致 rename 失败并保留 tmp 以便排查
	local ok, err = os.rename(tmpPath, flag.path)
	if not ok then
		print("Error: Cannot replace original file. Temp kept: " .. tmpPath .. " | err=" .. tostring(err))
		return
	end

	-- 打印统计结果
	print("\n========== Processing Complete ==========")
	print(string.format("Total lines: %d", stats.totalLines))
	print(string.format("Removed Scaling blocks: %d", stats.scalingBlocks))
	print(string.format("Processed Translation blocks: %d", stats.translationBlocks))
	print(string.format("  Deleted (all zeros): %d", stats.translationDeleted))
	print(string.format("  Kept: %d", stats.translationBlocks - stats.translationDeleted))
	print(string.format("  Keyframes removed (dedupe): %d", stats.translationKeyframesRemoved))
	print(string.format("Processed Rotation blocks: %d", stats.rotationBlocks))
	print(string.format("  Keyframes removed (dedupe): %d", stats.rotationKeyframesRemoved))
	print(string.format("Cleaned scientific notation (e/E, +/-): %d instances", stats.scientificCountRemoved))
	print("==============================")

	-- os.execute([[explorer ]] .. flag.output)
end

OptimizeMDL()
print("OptimizeMDL Done")
