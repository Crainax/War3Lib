local frames = {
	{ ['name'] = 'Stand', ['frame'] = '5-45' },     -- 帧
	{ ['name'] = 'Stand 2', ['frame'] = '148-268' }, -- 帧
	{ ['name'] = 'Walk', ['frame'] = '466-490' },   -- 帧
	{ ['name'] = 'Walk Fast', ['frame'] = '493-513' }, -- 帧
	{ ['name'] = 'Death', ['frame'] = '516-566' },  -- 帧
	{ ['name'] = 'Attack 1', ['frame'] = '878-902' }, -- 帧
	{ ['name'] = 'Attack 2', ['frame'] = '903-927' }, -- 帧
	{ ['name'] = 'Spell 1', ['frame'] = '928-958' }, -- 帧
	{ ['name'] = 'Spell 2', ['frame'] = '959-989' } -- 帧
}

-- MS文件生成路径 (可以根据你的情况修改)
local ms_path = [[D:\Program Files\Autodesk\3ds Max 2024\scripts\updateBones.ms]]
local fallback_path = [[D:\War3\Library\War3Lib\Lua\model\updateBones.ms]]

local function GenerateMaxScript()
	-- 1. 先排序
	table.sort(frames, function(a, b)
		local av = tonumber(a.frame:match("(%d+)-"))
		local bv = tonumber(b.frame:match("(%d+)-"))
		return av < bv
	end)
	
	-- 2. 计算目标开始结束帧
	for index, frame in ipairs(frames) do
		local sI, eI = frame.frame:match("(%d+)-(%d+)")
		sI = tonumber(sI)
		eI = tonumber(eI)
		local delta = eI - sI
		local previousEnd = 0
		if index > 1 then
			previousEnd = frames[index - 1]['end']
		end
		-- 紧凑排列，间隔10帧
		frame['start'] = math.max(10, previousEnd + 10)
		frame['end'] = frame['start'] + delta
	end

	-- 3. 构建依赖关系，计算绝对安全的拓扑移动顺序
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
				if math.max(a_t_start, b_s_start) <= math.min(a_t_end, b_s_end) then
					table.insert(nodeB.next_nodes, nodeA)
					nodeA.in_degree = nodeA.in_degree + 1
				end
			end
		end
	end
	
	local queue = {}
	for i, node in ipairs(nodes) do
		if node.in_degree == 0 then table.insert(queue, node) end
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
			if next_node.in_degree == 0 then table.insert(queue, next_node) end
		end
		sort_queue()
	end

	-- 4. 计算需要彻底删除的死角区间 (提出所有带有被覆盖重合的操作区间)
	local op_ranges = {}
	local new_ranges = {}
	for _, f in ipairs(frames) do
		table.insert(new_ranges, { start = f.start, ['end'] = f['end'] })
		local s_start = tonumber(f.frame:match("(%d+)-"))
		local s_end = tonumber(f.frame:match("-(%d+)")) or 0
		table.insert(op_ranges, { math.min(s_start, f.start), math.max(s_end, f['end']) })
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

	-- 5. 拼接 MaxScript 代码
	local ms = {}
	table.insert(ms, "-- 自动由 Lua 脚本生成的一键重排动作帧脚本")
	table.insert(ms, "fn autoRearrangeKeys objs = (")
	table.insert(ms, "    if objs.count == 0 do (")
	table.insert(ms, "        messageBox \"请先选中需要处理帧动作的骨骼或模型物体！\"")
	table.insert(ms, "        return false")
	table.insert(ms, "    )")
	table.insert(ms, "    -- 禁用自动重绘来大幅度提升脚本执行速度")
	table.insert(ms, "    with redraw off (")
	table.insert(ms, "        -- 为避免大范围操作模型数组造成的严重卡死，这里逐个精准提取 transform 动画轨迹")
	table.insert(ms, "        for obj in objs do (")
	table.insert(ms, "            local ctrl = obj.transform.controller")
	table.insert(ms, "            if ctrl != undefined do (")
	table.insert(ms, "                deselectKeys ctrl")
	
	-- 注入安全的操作顺序
	for _, f in ipairs(order) do
		local o_start = tonumber(f.frame:match("(%d+)-"))
		local o_end = tonumber(f.frame:match("-(%d+)"))
		local delta = f.start - o_start
		table.insert(ms, "")
		table.insert(ms, "                -- 移动动作 [" .. f.name .. "] : " .. f.frame .. " -> " .. f.start .. "-" .. f['end'])
		table.insert(ms, "                selectKeys ctrl (interval " .. o_start .. "f " .. o_end .. "f)")
		table.insert(ms, "                moveKeys ctrl (" .. delta .. "f) #selection")
		table.insert(ms, "                deselectKeys ctrl")
	end

	-- 注入死角清除代码
	table.insert(ms, "")
	table.insert(ms, "                -- 删除未操作到的死角杂项帧")
	for _, u in ipairs(final_unused) do
		if u.is_last then
			table.insert(ms, "                -- 注意：清除结尾所有遗留帧")
			table.insert(ms, "                selectKeys ctrl (interval " .. u.start .. "f 99999f)")
			table.insert(ms, "                deleteKeys ctrl #selection")
			table.insert(ms, "                deselectKeys ctrl")
		else
			table.insert(ms, "                selectKeys ctrl (interval " .. u.start .. "f " .. u['end'] .. "f)")
			table.insert(ms, "                deleteKeys ctrl #selection")
			table.insert(ms, "                deselectKeys ctrl")
		end
	end

	table.insert(ms, "            )")
	table.insert(ms, "        )")
	table.insert(ms, "    )")
	table.insert(ms, "    messageBox \"动作帧重排和清理全部完成！\"")
	table.insert(ms, ")")
	table.insert(ms, "")
	table.insert(ms, "-- 传入当前 3dmax 中选中的对象执行")
	table.insert(ms, "autoRearrangeKeys (selection as array)")

	-- 6. 写入文件
	local file, err = io.open(ms_path, "w")
	if file then
		file:write(table.concat(ms, "\n"))
		file:close()
		print("成功生成 maxscript 文件至: " .. ms_path)
	else
		print("原路径创建失败，可能由于 C 盘（或 Program Files）权限不足。尝试创建到本地备用路径...")
		file, err = io.open(fallback_path, "w")
		if file then
			file:write(table.concat(ms, "\n"))
			file:close()
			print("成功生成 maxscript 文件至: " .. fallback_path)
			print("请在 3dmax 中通过菜单栏 [Scripting] -> [Run Script...] 手动选择运行这个文件。")
		else
			print("依然无法创建文件，错误: " .. tostring(err))
		end
	end
end

GenerateMaxScript()
