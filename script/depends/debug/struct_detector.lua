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
local udg = require 'jass.globals'
local con = require 'jass.console'
local code = require 'jass.code'

local print = con.write

local mt = {}

code.StructShow = function()
	print('---------struct-start---------')
	if udg.s__guai_size then print('[guai]:' .. tostring(udg.s__guai_size)) end
	if udg.s__hero_size then print('[hero]:' .. tostring(udg.s__hero_size)) end
	if udg.s__spell_size then print('[spell]:' .. tostring(udg.s__spell_size)) end
	if udg.s__items_size then print('[items]:' .. tostring(udg.s__items_size)) end
	if udg.s__book_size then print('[book]:' .. tostring(udg.s__book_size)) end
	if udg.s__majia_size then print('[majia]:' .. tostring(udg.s__majia_size)) end
	if udg.s__summon_size then print('[summon]:' .. tostring(udg.s__summon_size)) end
	if udg.s__fos_size then print('[漂浮文字:fos]:' .. tostring(udg.s__fos_size)) end
	if udg.s__follower_size then print('[漂浮文字:follower]:' .. tostring(udg.s__follower_size)) end
	if udg.s__tt_size then print('[漂浮文字:tt]:' .. tostring(udg.s__tt_size)) end
	if udg.s__uitt_size then print('[漂浮文字:uitt]:' .. tostring(udg.s__uitt_size)) end
	if udg.s__baseanim_size then print('[动画:baseanim]:' .. tostring(udg.s__baseanim_size)) end
	if udg.s__ll_node_size then print('[链表节点]:' .. tostring(udg.s__ll_node_size)) end
	if udg.s__linkedlist_lsize then print('[链表数量]:' .. tostring(udg.s__linkedlist_lsize)) end
	if udg.s__auraitem_size then print('[光环条目]:' .. tostring(udg.s__auraitem_size)) end
	if udg.s__AC_size then print('[AC数量]:' .. tostring(udg.s__AC_size)) end
	if udg.s__AC_size then print('[AC施法]:' .. tostring(udg.s__ACCast_size)) end
	if udg.UIIndex then print('[UI索引]:' .. tostring(udg.UIIndex)) end
	print('---------struct-end---------')
end


print("[结构体检测]初始化成功.")

mt.display = code.MemoryLeakShow
return mt
