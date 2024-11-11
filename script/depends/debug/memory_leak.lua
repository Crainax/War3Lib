--[=[
    泄露检测
        mod by 火凌之凤
               神奇海螺Raiden

    version : 1.22
    date : 2021/4/16
	log:
		1.22 - 开关不再影响控制台开启关闭

    usage:
    	将此文件导入地图,修改路径为最外面 将下面代码中的test修改为在你地图里的文件名
    	新建触发器
    		事件 游戏逝去1秒
    		动作 - 自定义代码
		        一般:
		            call Cheat("exec-lua:test")
		        内置:
		            call AbilityId("exec-lua:test")

    	不懂啥是内置的就采用一般的方案

]=] -- 开始
local wantPrintInGame = true
local dbg = require 'jass.debug'
local jass = require 'jass.common'
local con = require 'jass.console'
local code = require 'jass.code'
local type_list = {
	['+loc'] = '点',
	['+EIP'] = '特效I',
	['+EIm'] = '特效II',
	['+EIf'] = '特效III',
	['+tmr'] = '计时器',
	['item'] = '物品',
	['+w3u'] = '单位',
	['+grp'] = '单位组',
	['+dlb'] = '按钮',
	['+dlg'] = '对话框',
	['+w3d'] = '可破坏物',
	['+rev'] = '事件',
	['alvt'] = '事件',
	['bevt'] = '事件',
	['devt'] = '事件',
	['gevt'] = '事件',
	['gfvt'] = '事件',
	['pcvt'] = '事件',
	['pevt'] = '事件',
	['psvt'] = '事件',
	['tmet'] = '事件',
	['tmvt'] = '事件',
	['uevt'] = '事件',
	['wdvt'] = '事件',
	['+flt'] = '过滤器',
	['+fgm'] = '可见度修正器',
	['+frc'] = '玩家组',
	['ghth'] = '哈希表',
	['+mdb'] = '多面板',
	['+ply'] = '玩家',
	['+rct'] = '矩形区域',
	['+agr'] = '范围',
	['+snd'] = '声音',
	['+tid'] = '计时器窗口',
	['+trg'] = '触发器',
	['+tac'] = '触发器动作',
	['tcnd'] = '触发器条件',
	['ipol'] = '物品池',
	['+mbi'] = '多面板项目',
	['gcch'] = '缓存', --

}

local print = con.write

local function echo(str)
	jass.DisplayTimedTextToPlayer(jass.GetLocalPlayer(), 0, 0, 60.00, str)
end

local mt = {}

local saved = nil
local delta = {}
function code.MemoryLeakShow()
	-- 统计句柄数量
	local count = {}
	local sum = 0
	for id = 0x100001, 0x100000 + dbg.handlemax() do
		local handle = dbg.handledef(id)
		if handle and handle.type then
			local name = type_list[handle.type] or handle.type -- '其他对象'
			count[name] = (count[name] or 0) + 1
			sum = sum + 1
		end
	end

	table.sort(count)

	-- 计算计数偏移
	if saved then
		for k, v in pairs(count) do
			delta[k] = v - (saved[k] or 0)
			saved[k] = v
		end
	else
		saved = {}
		for k, v in pairs(count) do
			delta[k] = 0
			saved[k] = v
		end
	end

	if wantPrintInGame then
		echo('--------------start------------')
		local msg = ''
		local step = 0
		local green = {r = 40, g = 255, b = 10}
		local yellow = {r = 255, g = 220, b = 20}
		local red = {r = 255, g = 30, b = 25}
		for k, v in pairs(count) do
			v = v or 0
			if string.len(msg) > 0 then msg = msg .. ', ' end
			-- 颜色进度, 数值越接近X越红, 反之则越绿
			local p = math.min(v / 50000, 1)
			local color = {}
			if p < 0.5 then
				p = p / 0.5
				color.r = math.ceil(green.r + (yellow.r - green.r) * p)
				color.g = math.ceil(green.g + (yellow.g - green.g) * p)
				color.b = math.ceil(green.b + (yellow.b - green.b) * p)
			else
				p = p / 0.5 - 1
				color.r = math.ceil(yellow.r + (red.r - yellow.r) * p)
				color.g = math.ceil(yellow.g + (red.g - yellow.g) * p)
				color.b = math.ceil(yellow.b + (red.b - yellow.b) * p)
			end
			local rgb = string.format('%02x%02x%02x', color.r, color.g, color.b)
			msg = msg .. string.format('%s: |cff%s%s|r', k, rgb, v)
			-- 展示计数偏移
			if delta[k] ~= 0 then
				local prefix = ''
				if delta[k] > 0 then
					prefix = 'ff0000+'
				else
					prefix = '00ff00-'
				end
				msg = msg .. string.format('(|cff%s%d|r)', prefix, math.abs(delta[k]))
			end
			-- 每隔X个数据, 输出一行
			step = step + 1
			if step >= 3 then
				echo(msg)
				step = 0
				msg = ''
			end
		end
		-- 尾部数据(数量不满X, 多出来的)
		if step > 0 then echo(msg) end
		echo('统计数量: ' .. sum .. ', 底层获取数量: ' .. dbg.handlecount())
		echo('历史最大句柄: '.. dbg.handlemax())
		echo('--------------end------------')
	else
		print('--------------start------------')
		for k, v in pairs(count) do print(k .. ': ' .. v) end
		print('统计数量: ', sum, ', 底层获取数量: ', dbg.handlecount())
		print('历史最大句柄: ', dbg.handlemax())
		print('--------------end------------')
	end
end



print("[内存泄露]初始化成功.")

mt.display = code.MemoryLeakShow
return mt
