local frames = {
	{['name'] = 'Stand', ['frame'] = '0-30'}, -- 帧
	{ ['name'] = 'Stand 2', ['frame'] = '288-450' }, -- 帧
	{ ['name'] = 'Walk', ['frame'] = '763-795' }, -- 帧
	{ ['name'] = 'Death', ['frame'] = '453-490' }, -- 帧
	{ ['name'] = 'Attack 1', ['frame'] = '493-523' }, -- 帧
	{ ['name'] = 'Attack 2', ['frame'] = '526-556' }, -- 帧
	{ ['name'] = 'Spell 1', ['frame'] = '559-583' }, -- 帧
	{ ['name'] = 'Spell 2', ['frame'] = '586-616' } -- 帧
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
end

ShowAllFrame()