local jass = require 'jass.common'
local gb = require 'jass.globals'
local japi = require 'jass.japi'
local bn = require 'jass.bignum'
local storm = require 'jass.storm'
local slk = require 'jass.slk'
local hook = require 'jass.hook'
local msg = require 'jass.message'
local log = require 'jass.log'

-- 用于测试一些东西的库,正式版可删掉.
CRTest = {}

-- 测试库是否正常
function CRTest.AAA() print("hahaha") end -- 没返回的话就是返回null
-- 抛出一个错误
function CRTest.BBB()
	print(123) -- 这个打印nil
	return nil
end
-- 返回一个数值
function CRTest.CCC(args)
	print(type(args) .. args) -- number 100
	return tonumber(args) * 1010000 -- 输入100返回101000000
end
-- 返回表看看
function CRTest.DDD()
	print(CRTest) -- 这玩意有值,但是传不过去的
	print(tostring(CRTest)) -- 但是这样就能传~~~~
	return tostring(CRTest)
end

-- 显示所有全局变量
function CRTest.ShowAllGB()
	for key, value in pairs(gb) do
		print(tostring(key) .. ':' .. tostring(value))
	end
end

-- 显示所有JAPI函数
function CRTest.ShowAllJapi()
	for key, value in pairs(japi) do
		print(tostring(key) .. ':' .. tostring(value))
	end
end

-- 显示所有bignum库的函数
function CRTest.ShowAllBN()
	for key, value in pairs(bn) do
		print(tostring(key) .. ':' .. tostring(value))
	end
end

-- 显示所有废弃库storm的函数(2个结果:save,load)
function CRTest.ShowAllStorm()
	for key, value in pairs(storm) do
		print(tostring(key) .. ':' .. tostring(value))
	end
end

-- 自增自定义值
function CRTest.IncGB()
	gb.ITest = gb.ITest + 1
	print("自增后:" .. gb.ITest)
end

-- 初始化Code变量传递(目前无法使用在jass里定义的,但是不在jass里定义TM又过不了编译)
function CRTest.InitCode()
	local timer = jass.CreateTimer()
	local i = 0
	jass.TimerStart(timer, 0.1, true, function()
		i = i + 1
		print("闭包使用" .. i) -- 这句没问题,没法通过中介code类型变量来返回到jass层
	end)
end

-- 测试一下Hook库
function hook.CreateUnit(pid, uid, x, y, face, realCreateUnit)
	print(type(x)) -- 类型userdata
	print(type(realCreateUnit)) -- 类型function
	return realCreateUnit(pid, uid, x, y, face)
end

-- 测试一下SLK的库
function CRTest.SLKTest1()
	for key, value in pairs(slk.ability) do
		print(tostring(key) .. ':' .. tostring(value))
	end
	print('--------------------------------')
	for key, value in pairs(slk.ability.AHbz) do
		print(tostring(key) .. ':' .. tostring(value))
	end
end

-- 测试一下报错(直接崩溃型)
function CRTest.JassError()
	-- 	CRTest.lua:95: Call jass function crash.<Player>

	-- stack traceback:
	--         Crainax.lua:30: in field 'error_handle'
	--         Crainax.lua:35: in function <Crainax.lua:35>
	--         [C]: in field 'Player'
	--         CRTest.lua:95: in field 'JassError'
	--         [string "return (CRTest.JassError())"]:1: in main chunk
	jass.Player(-1)
end

-- 测试一下报错(未初始化型)
function CRTest.JassError2()
	gb.ITest2 = gb.ITest2 + 1;
	print(gb.ITest2)
end

-- 测试一下报错(未初始化型)
function CRTest.JassError3()
	gb.ITest2 = gb.ITest2 + 1;
	print(gb.ITest2)
end

-- 测试一下报错(无限循环型)->证明魔兽LUA引擎是单线程.
function CRTest.JassError3()
	while true do
		print(123)
	end
end

msg.order_enable_debug = true

-- 显示所有Msg库的函数
function CRTest.ShowAllMsg()
	for key, v in pairs(msg) do
		if type(v) == "table" then
			for k, nv in pairs(v) do
				print(tostring(k) .. ':' .. tostring(nv))
			end
		elseif type(v) == "function" then
			print("v[" .. key .. ']' .. tostring(v()))
		end
		print(tostring(key) .. ':' .. tostring(v))
	end
end
-- button:function: 514BC838
-- mouse:function: 514BC742
-- order_enable_debug:function: 514BCD60
-- order_point:function: 514BCC07
-- selection:function: 514BC8FB
-- keyboard:table: 162B3C60
-- order_target:function: 514BCCA4
-- order_immediate:function: 514BCB91

-- 日志功能(并测试一下LUA的随机数是否正常)
-- trace、debug、info、warn、error、fatal

local function split(str, p)
	local rt = {}
	local s = string.gsub(str, '[^]' .. p .. ']+', function(w) table.insert(rt, w) end)
	return rt
end

log.path = '创世轨迹\\日志\\' .. split(log.path, '\\')[2]
-- 重载打印函数,全部都输出到日志里
local std_print = print
function print(...)
	log.info(...)
	return std_print(...)
end

local log_error = log.error
function log.error(...)
	local trc = debug.traceback()
	log_error(...)
	log_error(trc)
	std_print(...)
	std_print(trc)
end

function CRTest.LogTest()
	log.error('你是什么牛马')
	log.info('他是什么牛马')
end

-- 显示所有Msg库的函数(默认路径在)
function CRTest.ShowAllLog()
	for key, v in pairs(log) do
		print(tostring(key) .. ':' .. tostring(v) .. ",type:" .. type(v))
	end
end

-- 测试一下控制台的输入
function CRTest.InputTest()
	local console = require 'jass.console'
	print("测试开始")
	jass.TimerStart(jass.CreateTimer(), 0.1, true, function()
		-- 检查CMD窗口中的用户输入,如果用户有提交了的输入,则回调函数(按回车键提交输入).否则不做任何动作
		console.read(function(str) jass.DisplayTextToPlayer(jass.Player(0), 0, 0, "你在控制台输入了" .. str) end)
	end)
end
