local frames = {
	{ ['name'] = 'Stand', ['frame'] = '0-45' },    -- 帧
	{ ['name'] = 'Stand 2', ['frame'] = '620-770' }, -- 帧
	{ ['name'] = 'Walk', ['frame'] = '50-74' },    -- 帧
	{ ['name'] = 'Walk Fast', ['frame'] = '80-100' }, -- 帧
	{ ['name'] = 'Death', ['frame'] = '410-460' }, -- 帧
	{ ['name'] = 'Attack 1', ['frame'] = '185-215' }, -- 帧
	{ ['name'] = 'Attack 2', ['frame'] = '220-250' }, -- 帧
	{ ['name'] = 'Spell 1', ['frame'] = '255-279' }, -- 帧
	{ ['name'] = 'Spell 2', ['frame'] = '285-309' } -- 帧
}

-- 生成所有序列帧
local function ShowAllFrame()
	-- 先排序
	table.sort(frames, function(a, b)
		local av = tonumber(a.frame:match("(%d+)-"))
		local bv = tonumber(b.frame:match("(%d+)-"))
		return av < bv
	end)
	-- 再重新紧凑排列帧
	for index, frame in ipairs(frames) do
		local sI, eI = frame.frame:match("(%d+)-(%d+)")
		sI = tonumber(sI)
		eI = tonumber(eI)
		local delta = eI - sI
		local previousEnd = 0
		if index > 1 then
			previousEnd = frames[index - 1]['end']
		end
		-- 确保新帧从上一个帧结束位置+10开始，避免重合
		frame['start'] = math.max(10, previousEnd + 10)
		frame['end'] = frame['start'] + delta
		print(frame.name .. ':' .. frame.frame .. '------>>' .. frame['start'] .. '-' .. frame['end'])
	end

	print("\n=== 3dmax 中的安全操作顺序 ===")
	-- 构建依赖关系（图）
	local nodes = {}
	for i, frame in ipairs(frames) do
		nodes[i] = { frame = frame, in_degree = 0, next_nodes = {} }
	end
	
	for i, nodeA in ipairs(nodes) do
		local a_t_start = nodeA.frame.start
		local a_t_end = nodeA.frame['end']
		
		for j, nodeB in ipairs(nodes) do
			if i ~= j then
				local b_s_start = tonumber(nodeB.frame.frame:match("(%d+)-"))
				local b_s_end = tonumber(nodeB.frame.frame:match("-(%d+)"))
				-- 重叠条件：A的目标段与B的源段有交集
				if math.max(a_t_start, b_s_start) <= math.min(a_t_end, b_s_end) then
					-- 必须先移动B，空出位置后才能移动A： B -> A
					table.insert(nodeB.next_nodes, nodeA)
					nodeA.in_degree = nodeA.in_degree + 1
				end
			end
		end
	end
	
	local queue = {}
	for i, node in ipairs(nodes) do
		if node.in_degree == 0 then
			table.insert(queue, node)
		end
	end
	
	local function sort_queue()
		table.sort(queue, function(a, b)
			local a_s = tonumber(a.frame.frame:match("(%d+)-"))
			local b_s = tonumber(b.frame.frame:match("(%d+)-"))
			local a_dir = a.frame.start - a_s
			local b_dir = b.frame.start - b_s
			if a_dir > 0 and b_dir > 0 then
				return a_s > b_s
			elseif a_dir < 0 and b_dir < 0 then
				return a_s < b_s
			else
				return a_dir > b_dir 
			end
		end)
	end
	sort_queue()

	local order = {}
	while #queue > 0 do
		local curr = table.remove(queue, 1)
		table.insert(order, curr.frame)
		
		for _, next_node in ipairs(curr.next_nodes) do
			next_node.in_degree = next_node.in_degree - 1
			if next_node.in_degree == 0 then
				table.insert(queue, next_node)
			end
		end
		sort_queue()
	end
	
	if #order < #frames then
		print("警告: 存在动作前后交错引起的循环依赖！无法找到完全安全的操作顺序，请在 3dmax 中分步使用空白帧作中转。")
	else
		for i, f in ipairs(order) do
			local s_start = tonumber(f.frame:match("(%d+)-"))
			local s_end = tonumber(f.frame:match("-(%d+)"))
			local dir_text = (f.start > s_start) and "向右推迟" or "向左提前"
			local min_range = math.min(s_start, f.start)
			local max_range = math.max(s_end, f['end'])
			print("操作区间(" .. min_range .. "-" .. max_range .. ")  " .. i .. ". 移动 [" .. f.name .. "] : " .. f.frame .. " ------>> " .. f.start .. "-" .. f['end'] .. " (" .. dir_text .. ")")
		end
	end


	print("\n=== 结束后可删除的无用帧段 ===")
	local new_ranges = {}
	local max_original_frame = 0
	for _, f in ipairs(frames) do
		table.insert(new_ranges, { start = f.start, ['end'] = f['end'] })
		local s_end = tonumber(f.frame:match("-(%d+)")) or 0
		if s_end > max_original_frame then max_original_frame = s_end end
	end
	
	table.sort(new_ranges, function(a, b) return a.start < b.start end)
	
	local unused = {}
	local current = 0
	for _, r in ipairs(new_ranges) do
		if r.start > current then
			table.insert(unused, { start = current, ['end'] = r.start - 1 })
		end
		current = r['end'] + 1
	end
	
	table.insert(unused, { start = current, is_last = true })
	
	local op_ranges = {}
	for _, f in ipairs(frames) do
		local s_start = tonumber(f.frame:match("(%d+)-"))
		local s_end = tonumber(f.frame:match("-(%d+)")) or 0
		table.insert(op_ranges, { math.min(s_start, f.start), math.max(s_end, f['end']) })
	end
	
	local final_unused = {}
	for _, u in ipairs(unused) do
		local current_pieces = { u }
		for _, op in ipairs(op_ranges) do
			local next_pieces = {}
			for _, p in ipairs(current_pieces) do
				local p_end = p.is_last and math.huge or p['end']
				if op[2] < p.start or op[1] > p_end then
					table.insert(next_pieces, p)
				else
					if p.start < op[1] then
						table.insert(next_pieces, { start = p.start, ['end'] = op[1] - 1 })
					end
					if p_end > op[2] then
						if p.is_last then
							table.insert(next_pieces, { start = op[2] + 1, is_last = true })
						else
							table.insert(next_pieces, { start = op[2] + 1, ['end'] = p['end'] })
						end
					end
				end
			end
			current_pieces = next_pieces
		end
		for _, p in ipairs(current_pieces) do
			table.insert(final_unused, p)
		end
	end

	for _, u in ipairs(final_unused) do
		if u.is_last then
			print("删除区间: " .. u.start .. " - (以及之后的所有帧)")
		else
			print("删除区间: " .. u.start .. "-" .. u['end'])
		end
	end
end

ShowAllFrame()
