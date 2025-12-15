local flag = {
	['path'] = [[D:\War3Asset\Model\ShangqueDIY\aniya\test1\1.mdl]], -- 要处理的文件名
	['output'] = [[D:\War3\Library\War3Lib\Lua\model\output.log]] -- Debug输出的位置
}

-- ====== 配置常量 ======
local ATTACHMENT_NAMES = {
	"Origin Ref",
	"Overhead Ref",
	"Head Ref",
	"Chest Ref",
	"Hand Right Ref",
	"Hand Left Ref"
}

local BONE_PATTERNS = {
	head = { exact = "Bip001 Head", fuzzy = "Head" },
	spine2 = { exact = nil, fuzzy = "Spine2" },
	spine1 = { exact = nil, fuzzy = "Spine1" },
	rhand = { exact = nil, fuzzy = "R Hand" },
	lhand = { exact = nil, fuzzy = "L Hand" }
}

-- ====== 工具函数 ======
-- 提取花括号内的向量值
local function extractVector(line)
	local match = line:match("{%s*([^}]+)%s*}")
	if not match then return nil end

	local values = {}
	for num in match:gmatch("([%-]?%d+%.?%d*[eE]?[%+%-]?%d*)") do
		local n = tonumber(num)
		if n then
			table.insert(values, n)
		end
	end

	if #values >= 3 then
		return values
	end
	return nil
end

-- 提取 ObjectId 数值
local function extractObjectId(line)
	local match = line:match("ObjectId%s+(%d+)")
	if match then
		return tonumber(match)
	end
	return nil
end

-- 提取 Bone 名称
local function extractBoneName(line)
	local match = line:match('Bone%s+"([^"]+)"')
	return match
end

-- 检查是否已存在 Attachment
local function checkExistingAttachment(line)
	for _, name in ipairs(ATTACHMENT_NAMES) do
		if line:match('Attachment%s+"' .. name:gsub("%%", "%%%%"):gsub("%-", "%%-") .. '"') then
			return true, name
		end
	end
	return false, nil
end

-- ====== 主处理函数 ======
local function AddAttachments()
	-- 第一遍扫描：收集信息
	local bones = {}  -- name -> objectId
	local pivotPoints = {}  -- 数组，1-based
	local maxObjectId = -1
	local existingAttachments = {}  -- 已存在的 Attachment 名称
	local boneObjectIds = {
		head = nil,
		spine2 = nil,
		spine1 = nil,
		rhand = nil,
		lhand = nil
	}

	local inBone = false
	local currentBoneName = nil
	local inPivotPoints = false
	local pivotCount = 0
	local lastPivotLine = nil  -- 记录最后一个 PivotPoint 行的原始格式

	print("第一遍扫描：收集骨骼和 PivotPoints 信息...")

	-- 使用 io 库读取文件
	local file = io.open(flag.path, "r")
	if not file then
		error("无法打开文件: " .. flag.path)
	end

	local lineNum = 0
	for line in file:lines() do
		lineNum = lineNum + 1
		-- 收集 Bone ObjectId
		local boneName = extractBoneName(line)
		if boneName then
			inBone = true
			currentBoneName = boneName
		elseif inBone then
			local objId = extractObjectId(line)
			if objId and currentBoneName then
				bones[currentBoneName] = objId
				maxObjectId = math.max(maxObjectId, objId)

				-- 检查是否匹配目标骨骼
				-- Head: 精确优先
				if not boneObjectIds.head and currentBoneName then
					if currentBoneName == BONE_PATTERNS.head.exact then
						boneObjectIds.head = objId
					elseif string.lower(currentBoneName):find(string.lower(BONE_PATTERNS.head.fuzzy), 1, true) then
						boneObjectIds.head = objId
					end
				end

				-- Spine2: 模糊匹配
				if not boneObjectIds.spine2 and currentBoneName then
					if string.lower(currentBoneName):find(string.lower(BONE_PATTERNS.spine2.fuzzy), 1, true) then
						boneObjectIds.spine2 = objId
					end
				end

				-- Spine1: 模糊匹配（作为 Spine2 的备选）
				if not boneObjectIds.spine1 and currentBoneName then
					if string.lower(currentBoneName):find(string.lower(BONE_PATTERNS.spine1.fuzzy), 1, true) then
						boneObjectIds.spine1 = objId
					end
				end

				-- R Hand: 模糊匹配
				if not boneObjectIds.rhand and currentBoneName then
					if string.lower(currentBoneName):find(string.lower(BONE_PATTERNS.rhand.fuzzy), 1, true) then
						boneObjectIds.rhand = objId
					end
				end

				-- L Hand: 模糊匹配
				if not boneObjectIds.lhand and currentBoneName then
					if string.lower(currentBoneName):find(string.lower(BONE_PATTERNS.lhand.fuzzy), 1, true) then
						boneObjectIds.lhand = objId
					end
				end

				inBone = false
				currentBoneName = nil
			elseif line:match("^%s*}%s*$") then
				inBone = false
				currentBoneName = nil
			end
		end

		-- 收集 PivotPoints
		if line:match("PivotPoints%s+%d+%s*{") then
			inPivotPoints = true
			pivotCount = 0
			lastPivotLine = nil
		elseif inPivotPoints then
			if line:match("^%s*}%s*$") then
				inPivotPoints = false
			else
				local vec = extractVector(line)
				if vec then
					pivotCount = pivotCount + 1
					pivotPoints[pivotCount] = vec
					lastPivotLine = line  -- 记录最后一个 PivotPoint 行的原始格式
				end
			end
		end

		-- 检查已存在的 Attachment
		local exists, name = checkExistingAttachment(line)
		if exists and name then
			existingAttachments[name] = true
		end

		-- 更新最大 ObjectId（从所有 ObjectId 行）
		local objId = extractObjectId(line)
		if objId then
			maxObjectId = math.max(maxObjectId, objId)
		end
	end

	file:close()

	-- 确定最终使用的 Spine 骨骼（优先 Spine2，如果没有则用 Spine1）
	local spineBoneId = boneObjectIds.spine2 or boneObjectIds.spine1
	local spineBoneName = boneObjectIds.spine2 and "Spine2" or (boneObjectIds.spine1 and "Spine1" or nil)

	-- 验证找到的骨骼
	print("\n========== 骨骼查找结果 ==========")
	print(string.format("Head: %s", boneObjectIds.head and ("ObjectId " .. boneObjectIds.head) or "未找到"))
	print(string.format("Spine2: %s", boneObjectIds.spine2 and ("ObjectId " .. boneObjectIds.spine2) or "未找到"))
	print(string.format("Spine1: %s", boneObjectIds.spine1 and ("ObjectId " .. boneObjectIds.spine1) or "未找到"))
	if spineBoneId then
		print(string.format("使用骨骼: %s (ObjectId %d)", spineBoneName, spineBoneId))
	end
	print(string.format("R Hand: %s", boneObjectIds.rhand and ("ObjectId " .. boneObjectIds.rhand) or "未找到"))
	print(string.format("L Hand: %s", boneObjectIds.lhand and ("ObjectId " .. boneObjectIds.lhand) or "未找到"))
	print(string.format("最大 ObjectId: %d", maxObjectId))
	print(string.format("PivotPoints 数量: %d", #pivotPoints))

	-- 检查是否所有必需的骨骼都找到了
	if not boneObjectIds.head then
		error("错误：未找到 Head 骨骼！")
	end
	if not spineBoneId then
		error("错误：未找到 Spine2 或 Spine1 骨骼！")
	end
	if not boneObjectIds.rhand then
		error("错误：未找到 R Hand 骨骼！")
	end
	if not boneObjectIds.lhand then
		error("错误：未找到 L Hand 骨骼！")
	end

	-- 检查 PivotPoints 是否足够
	local requiredPivotCount = math.max(
		boneObjectIds.head + 1,
		spineBoneId + 1,
		boneObjectIds.rhand + 1,
		boneObjectIds.lhand + 1
	)
	if #pivotPoints < requiredPivotCount then
		error(string.format("错误：PivotPoints 数量不足！需要至少 %d 个，但只有 %d 个", requiredPivotCount, #pivotPoints))
	end

	-- 检查是否已存在 Attachment
	local needAdd = {}
	for _, name in ipairs(ATTACHMENT_NAMES) do
		if not existingAttachments[name] then
			table.insert(needAdd, name)
		else
			print(string.format("跳过：已存在 Attachment \"%s\"", name))
		end
	end

	if #needAdd == 0 then
		print("\n所有 Attachment 已存在，无需添加。")
		return
	end

	-- 计算新的 ObjectId
	local newObjectIds = {}
	for i = 1, #needAdd do
		newObjectIds[i] = maxObjectId + i
	end

	-- 计算 6 个附加点的坐标
	local attachmentPoints = {}

	-- Origin Ref: { 0, 0, 0 }
	attachmentPoints["Origin Ref"] = { 0, 0, 0 }

	-- Head Ref: 从 PivotPoints 取 Head 的点
	local headPivotIndex = boneObjectIds.head + 1
	local headPoint = pivotPoints[headPivotIndex]
	if not headPoint then
		error(string.format("错误：无法从 PivotPoints 获取 Head 点（索引 %d）", headPivotIndex))
	end
	attachmentPoints["Head Ref"] = { headPoint[1], headPoint[2], headPoint[3] }

	-- Overhead Ref: Head 的 Z + 50
	attachmentPoints["Overhead Ref"] = { headPoint[1], headPoint[2], headPoint[3] + 50 }

	-- Chest Ref: 从 PivotPoints 取 Spine 的点（优先 Spine2，如果没有则用 Spine1）
	local spinePivotIndex = spineBoneId + 1
	local spinePoint = pivotPoints[spinePivotIndex]
	if not spinePoint then
		error(string.format("错误：无法从 PivotPoints 获取 %s 点（索引 %d）", spineBoneName, spinePivotIndex))
	end
	attachmentPoints["Chest Ref"] = { spinePoint[1], spinePoint[2], spinePoint[3] }

	-- Hand Right Ref: 从 PivotPoints 取 R Hand 的点
	local rhandPivotIndex = boneObjectIds.rhand + 1
	local rhandPoint = pivotPoints[rhandPivotIndex]
	if not rhandPoint then
		error(string.format("错误：无法从 PivotPoints 获取 R Hand 点（索引 %d）", rhandPivotIndex))
	end
	attachmentPoints["Hand Right Ref"] = { rhandPoint[1], rhandPoint[2], rhandPoint[3] }

	-- Hand Left Ref: 从 PivotPoints 取 L Hand 的点
	local lhandPivotIndex = boneObjectIds.lhand + 1
	local lhandPoint = pivotPoints[lhandPivotIndex]
	if not lhandPoint then
		error(string.format("错误：无法从 PivotPoints 获取 L Hand 点（索引 %d）", lhandPivotIndex))
	end
	attachmentPoints["Hand Left Ref"] = { lhandPoint[1], lhandPoint[2], lhandPoint[3] }

	-- 打印附加点信息
	print("\n========== 附加点坐标 ==========")
	for _, name in ipairs(ATTACHMENT_NAMES) do
		local pt = attachmentPoints[name]
		if pt then
			print(string.format("%s: { %s, %s, %s }", name, pt[1], pt[2], pt[3]))
		end
	end

	-- 第二遍扫描：写入文件
	print("\n第二遍扫描：写入 Attachment 和更新 PivotPoints...")

	local attachmentInserted = false
	local newPivotCount = #pivotPoints + #needAdd

	-- 生成要插入的 Attachment 块
	local attachmentBlocks = {}
	for i, name in ipairs(needAdd) do
		local objId = newObjectIds[i]
		local block = string.format('Attachment "%s" {\n\tObjectId %d,', name, objId)

		-- 添加 Parent（Origin Ref 和 Overhead Ref 不需要）
		if name == "Head Ref" then
			block = block .. string.format("\n\tParent %d,", boneObjectIds.head)
		elseif name == "Chest Ref" then
			block = block .. string.format("\n\tParent %d,", spineBoneId)
		elseif name == "Hand Right Ref" then
			block = block .. string.format("\n\tParent %d,", boneObjectIds.rhand)
		elseif name == "Hand Left Ref" then
			block = block .. string.format("\n\tParent %d,", boneObjectIds.lhand)
		end

		block = block .. "\n}"
		table.insert(attachmentBlocks, block)
	end

	-- 生成要追加的 PivotPoints 行
	-- 检测原文件最后一个点的格式（是否有逗号）
	local lastPointHasComma = true  -- 默认有逗号
	if lastPivotLine then
		lastPointHasComma = lastPivotLine:match(",%s*$") ~= nil
	end

	local newPivotLines = {}
	for i, name in ipairs(needAdd) do
		local pt = attachmentPoints[name]
		local isLast = (i == #needAdd)
		-- 如果是最后一个点，且原文件最后一个点没有逗号，则新点也不加逗号
		-- 否则所有点都加逗号（包括最后一个）
		if isLast and not lastPointHasComma then
			table.insert(newPivotLines, string.format("\t{ %s, %s, %s }", pt[1], pt[2], pt[3]))
		else
			table.insert(newPivotLines, string.format("\t{ %s, %s, %s },", pt[1], pt[2], pt[3]))
		end
	end

	-- 使用状态机跟踪 PivotPoints 块
	local inPivotBlock = false
	local pivotPointsInserted = false

	-- 使用 io 库读取文件
	local inputFile = io.open(flag.path, "r")
	if not inputFile then
		error("无法打开文件: " .. flag.path)
	end

	-- 读取所有行
	local lines = {}
	for line in inputFile:lines() do
		table.insert(lines, line)
	end
	inputFile:close()

	-- 处理每一行
	local outputLines = {}
	for _, line in ipairs(lines) do
		-- 在 PivotPoints 块之前插入 Attachment 块
		if not attachmentInserted and line:match("PivotPoints%s+%d+%s*{") then
			attachmentInserted = true
			inPivotBlock = true
			-- 插入 Attachment 块（每个块按行拆分）
			for _, block in ipairs(attachmentBlocks) do
				for blockLine in block:gmatch("([^\n]+)") do
					table.insert(outputLines, blockLine)
				end
			end
			-- 更新 PivotPoints 数量
			local updatedLine = line:gsub("PivotPoints%s+%d+", "PivotPoints " .. newPivotCount)
			table.insert(outputLines, updatedLine)
		-- 跟踪 PivotPoints 块状态
		elseif inPivotBlock then
			if line:match("^%s*}%s*$") then
				-- PivotPoints 块结束，在结束前插入新点
				if not pivotPointsInserted then
					pivotPointsInserted = true
					inPivotBlock = false
					-- 插入新的 PivotPoints 行
					for _, pivotLine in ipairs(newPivotLines) do
						table.insert(outputLines, pivotLine)
					end
					table.insert(outputLines, line)
				else
					inPivotBlock = false
					table.insert(outputLines, line)
				end
			else
				table.insert(outputLines, line)
			end
		else
			table.insert(outputLines, line)
		end
	end

	-- 写回文件
	local outputFile = io.open(flag.path, "w")
	if not outputFile then
		error("无法写入文件: " .. flag.path)
	end
	for _, line in ipairs(outputLines) do
		outputFile:write(line, "\n")
	end
	outputFile:close()

	-- 输出日志
	local logContent = string.format([[
========== Attachment 添加完成 ==========
骨骼 ObjectId:
  Head: %d
  %s: %d
  R Hand: %d
  L Hand: %d

最大 ObjectId: %d
新增 ObjectId: %d 到 %d

新增的 Attachment:
]],
		boneObjectIds.head,
		spineBoneName,
		spineBoneId,
		boneObjectIds.rhand,
		boneObjectIds.lhand,
		maxObjectId,
		newObjectIds[1],
		newObjectIds[#newObjectIds]
	)

	for i, name in ipairs(needAdd) do
		local pt = attachmentPoints[name]
		logContent = logContent .. string.format('  "%s": ObjectId %d, 坐标 { %s, %s, %s }\n',
			name, newObjectIds[i], pt[1], pt[2], pt[3])
	end

	logContent = logContent .. string.format("\nPivotPoints 数量: %d -> %d\n", #pivotPoints, newPivotCount)
	logContent = logContent .. "==============================\n"

	-- 使用 io 库写入文件
	local logFile = io.open(flag.output, "w")
	if not logFile then
		error("无法写入日志文件: " .. flag.output)
	end
	logFile:write(logContent)
	logFile:close()
	print(logContent)
end

AddAttachments()
print("AddAttachments Done")

