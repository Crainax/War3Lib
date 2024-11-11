#ifndef UTLuaIncluded
#define UTLuaIncluded

#include "edit/core/constant/Variable.j"

/*
Lua的教程1
*/
library UTLua initializer onInit requires Variable

	function NewBJ takes string s returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0., 0.,30, s)
	endfunction

	#define BJDebugMsg(s) NewBJ(s)
	//-----------------------------
	/*
	单元测试
	*/
	#ifdef TestMode

	/*
	本质就是在预处理时新建个LUA文件在LNI的Map里面
	加上这个注释还是会继续创建哦!这是个好注入办法
	<?import("abcd.lua")[[
	local CJ = require "jass.common" --引入CJ函数库
	setmetatable(_ENV, {__index = getmetatable(CJ).__index}) --先不用管


	local t = CreateTrigger() --创建一个触发器
	function act() --动作
	DisplayTextToPlayer(Player(0), 0, 0, 'cs1')
	-- 错误后就跳过后面的了,不再运行
	-- 语法错误会崩溃,但是非语法错误会停止运行罢了.
	DisplayTextToPlayer1(Player(0), 0, 0, 'cs2')
	DisplayTextToPlayer(Player(0), 0, 0, 'cs3')
	end
	TriggerRegisterTimerEvent(t, 2, false) --注册事件
	TriggerAddAction(t, act) --添加动作
	]]?>
	*/

	//但是最大的缺点就是无法编译.(最难受的一点,必须得引入框架)
	private function TTestUTLua1 takes nothing returns nothing
		call BJDebugMsg("调用Lua")
		call Cheat("exec-lua:abcd")
		#dzdfsd
	endfunction
	//往外部导了个文件,证明可用,放到Map里就好
	private function TTestUTLua2 takes nothing returns nothing
		call BJDebugMsg("调用Luaabc")
		call Cheat("exec-lua:abc")
	endfunction

	//Lua里无法调用Bj,但是目前我用不上这个功能.
	private function TTestUTLua3 takes nothing returns nothing
		call Cheat("exec-lua:Crainax")
		call BJDebugMsg("调用了自用库")
	endfunction

	private function TTestUTLua4 takes nothing returns nothing
		call EXExecuteScript("require 'Crainax'")
		call BJDebugMsg("调用了自用库2")
	endfunction

	//上述Lua4是无效的
	// 小知识点:require之后,再require就无效了,直接调用就可以了.~~
	// 在不require之前也是用不了的.上面的3与4都可require.
	private function TTestUTLua5 takes nothing returns nothing
		local string s = EXExecuteScript("CRTest.AAA()")
		local string s2 = null
		call BJDebugMsg("s.length" + I2S(StringLength(s))) //直接输出不出东西,获取长度的话是0,并不是所谓的nil`
		call BJDebugMsg("s2.length" + I2S(StringLength(s2))) //直接输出不出东西,获取长度的话是0,并不是所谓的nil`
	endfunction

	//抛出异常
	private function TTestUTLua6 takes nothing returns nothing
		local string result = EXExecuteScript("CRTest.BBB()")
		call BJDebugMsg("result.length" + I2S(StringLength(result))) //直接输出不出东西,获取长度的话是0,并不是所谓的nil`
	endfunction

	private function TTestUTLua7 takes nothing returns nothing
		local string s = EXExecuteScript("CRTest.CCC(100)")
		call BJDebugMsg(s)
	endfunction

	//测试一下
	private function TTestUTLua8 takes nothing returns nothing
		// call EXExecuteScript("print('crtest'.. CRTest)") //CRTest是nil,有毒吧
		local string crtest = EXExecuteScript("CRTest.DDD()")
		call BJDebugMsg("crtest:" + crtest)
	endfunction

	private function TTestUTLua9 takes nothing returns nothing
		// body...
	endfunction

	private function TTestUTLua10 takes nothing returns nothing
		// body...
	endfunction

	private function TTestActUTLua1 takes string str returns nothing
		local player p = GetTriggerPlayer()
		local integer index = GetConvertedPlayerId(p)
		local string s = SubStringBJ(str,1,1)
		local integer iData1 = S2I(SubStringBJ(str,2,StringLength(str)))
		local real rData1 = S2R(SubStringBJ(str,2,StringLength(str)))

		if (s == "a") then

		elseif (s == "b") then

		endif

		set p = null
		set s = null

	endfunction

	private function TTestActUTLua takes nothing returns nothing
		local string str = GetEventPlayerChatString()
		local integer i = 1

		if (SubStringBJ(str,1,1 + 1) == "ss") then
			call TTestActUTLua1(SubStringBJ(str,2 + 1,StringLength(str)))
			return
		endif

		if (str == "s1") then
			call TTestUTLua1()
		elseif (str == "s2") then
			call TTestUTLua2()
		elseif (str == "s3") then
			call TTestUTLua3()
		elseif (str == "s4") then
			call TTestUTLua4()
		elseif (str == "s5") then
			call TTestUTLua5()
		elseif (str == "s6") then
			call TTestUTLua6()
		elseif (str == "s7") then
			call TTestUTLua7()
		elseif (str == "s8") then
			call TTestUTLua8()
		elseif (str == "s9") then
			call TTestUTLua9()
		elseif (str == "s10") then
			call TTestUTLua10()
		endif

	endfunction

	#endif
	//-----------------------------
	/*
	初始化Lua
	*/
	private function onInit takes nothing returns nothing
		call Cheat("exec-lua:Crainax")
		call EXExecuteScript("require \"CRTest\"") //还行,可以用这句话控制在这里调用.这样Wave也能进行Lua的控制了
		// call EXExecuteScript("print('crtest'.. CRTest)") //在这个时候调用会失败,好像不是串行调用的.
		#ifdef TestMode

		call TriggerAddAction(TUnitTest, function TTestActUTLua)

		#endif
	endfunction
endlibrary

#endif
