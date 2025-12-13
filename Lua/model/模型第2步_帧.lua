local frames = {
	{['name'] = 'Stand', ['frame'] = '0-30'}, -- 帧
	{ ['name'] = 'Stand 2', ['frame'] = '187-278' }, -- 帧
	{ ['name'] = 'Walk', ['frame'] = '317-337' }, -- 帧
	{ ['name'] = 'Death', ['frame'] = '341-396' }, -- 帧
	{ ['name'] = 'Attack 1', ['frame'] = '480-510' }, -- 帧
	{ ['name'] = 'Attack 2', ['frame'] = '515-545' }, -- 帧
	{ ['name'] = 'Spell 1', ['frame'] = '550-595' }, -- 帧
	{ ['name'] = 'Spell 2', ['frame'] = '600-675' } -- 帧
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
		local previous = 0
		if index > 1 then
			previous = frames[index - 1]['end']
		end
		frame['start'] = math.max(10, math.min(sI, previous + 10))
		frame['end'] = frame['start'] + delta
		print(frame.name .. ':' .. frame.frame .. '------>>' .. frame['start'] .. '-' .. frame['end'])
	end
end

ShowAllFrame()