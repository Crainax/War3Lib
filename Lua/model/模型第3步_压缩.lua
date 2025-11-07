local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"
local iu = require "lua.image.ImageUtils"

local flag = {
	['path'] = [[D:\War3Asset\Model\Shangquemoxing\20251105\Lamu.mdl]],         -- 要处理的文件名
	['output'] = [[D:\War3Asset\Model\Shangquemoxing\20251105\Zhende\A (169).txt]] -- Debug输出的位置
}

-- 删除缩放[骨骼]/清理移动[误差0.1]/清理科学计数移动帧/优化旋转中E科学计数帧
local function OptimizeMDL()
	-- 统计信息
	local stats = {
		scalingBlocks = 0,        -- 删除的 Scaling 块数量
		translationBlocks = 0,   -- 处理的 Translation 块数量
		translationDeleted = 0,  -- 删除的 Translation 块数量（全为0的）
		rotationBlocks = 0,      -- 处理的 Rotation 块数量
		scientificCountRemoved = 0, -- 清理的科学计数法数量
		totalLines = 0           -- 处理的总行数
	}

	local inScaling = false
	local inTran = false -- 是否在Tran的模块内
	local inRotate = false
	local sTran = ""
	local tranDel = true -- 是否真的删除该移动
	local tranScientificCount = 0 -- Translation 块中的科学计数法数量

	print("Processing file: " .. flag.path)
	fu.WriteOver(flag.output, "")

	fu.ExecuteFile(flag.path, function(line)
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
			-- 清理移动.[忽略掉所有小于0.1的移动,并且判断是不是需要删除该移动(如果全是0,0,0的话就删)]
			stats.translationBlocks = stats.translationBlocks + 1
			if stats.translationBlocks % 10 == 0 then
				print(string.format("  Processed %d Translation blocks...", stats.translationBlocks))
			end
			inTran = true
			sTran = line .. '\n'
			tranScientificCount = 0
			line = nil
		elseif inTran then
			local originalLine = line
			local temp = line:gsub("%-?[0-9%.]+E%-%d+", function(match)
				tranScientificCount = tranScientificCount + 1
				return "0"
			end):gsub("%-?0%.0+%d+", "0")
			local a, b, c = temp:match("{%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*}")
			if a and b and c then
				if tonumber(a) ~= 0 or tonumber(b) ~= 0 or tonumber(c) ~= 0 then
					tranDel = false
				end
			end
			line = nil
			sTran = sTran .. temp .. '\n'
			if temp:match("^%s*}%s*$") then
				if not (tranDel) then -- 如果保留的话就注入
					line = sTran
					stats.scientificCountRemoved = stats.scientificCountRemoved + tranScientificCount
				else
					stats.translationDeleted = stats.translationDeleted + 1
					stats.scientificCountRemoved = stats.scientificCountRemoved + tranScientificCount
				end
				inTran = false
				tranDel = true
				tranScientificCount = 0
			end
		elseif line:match("Rotation") then
			-- 清理旋转[优化里面E极]
			stats.rotationBlocks = stats.rotationBlocks + 1
			if stats.rotationBlocks % 10 == 0 then
				print(string.format("  Processed %d Rotation blocks...", stats.rotationBlocks))
			end
			inRotate = true
		elseif inRotate then
			local originalLine = line
			line = line:gsub("%-?[0-9%.]+E%-%d+", function(match)
				stats.scientificCountRemoved = stats.scientificCountRemoved + 1
				return "0"
			end)
			if line:match("^%s*}%s*$") then
				inRotate = false
			end
		end

		-- 每处理 10000 行显示一次进度
		if stats.totalLines % 10000 == 0 then
			print(string.format("  Processed %d lines...", stats.totalLines))
		end

		return line
	end)

	-- 打印统计结果
	print("\n========== Processing Complete ==========")
	print(string.format("Total lines: %d", stats.totalLines))
	print(string.format("Removed Scaling blocks: %d", stats.scalingBlocks))
	print(string.format("Processed Translation blocks: %d", stats.translationBlocks))
	print(string.format("  Deleted (all zeros): %d", stats.translationDeleted))
	print(string.format("  Kept: %d", stats.translationBlocks - stats.translationDeleted))
	print(string.format("Processed Rotation blocks: %d", stats.rotationBlocks))
	print(string.format("Cleaned scientific notation: %d instances", stats.scientificCountRemoved))
	print("==============================")

	-- os.execute([[explorer ]] .. flag.output)
end

OptimizeMDL()
print("OptimizeMDL Done")
