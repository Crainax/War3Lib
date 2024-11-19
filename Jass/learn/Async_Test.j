#ifndef UTAsyncIncluded
#define UTAsyncIncluded

/*
	异步测试
*/

#include "edit/Base/CRBase.j"

library UTAsync initializer onInit requires CRBase 

//-----------------------------
	/*
	测试用函数
	*/
	private function CloseA2 takes integer i returns integer
		call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "CloseA消息:|cffff0000"+I2S(i)+"|r")
		return 100*i
	endfunction

	function OpenB2 takes integer i returns integer
		call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "OpenB消息:|cffff0000"+I2S(i)+"|r")
		return 200*i
	endfunction
//-----------------------------
	/*
	测试用函数
	*/
	private function CloseA takes nothing returns integer
		//call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "CloseA消息:|cffff0000"+I2S(i)+"|r")
		call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "CloseA消息")
		return 100
	endfunction

	function OpenB takes nothing returns integer
		//call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "OpenB消息:|cffff0000"+I2S(i)+"|r")
		call DisplayTextToPlayer(GetLocalPlayer(), 0., 0., "OpenB消息")
		return 200
	endfunction
//-----------------------------
	/*
    单元测试
	*/
	#ifdef TestMode
	

	private function TTestUTAsync1 takes nothing returns nothing
		local integer i = 0
	    //4大调用方法是否会异步
	    //使用错误名字的字符串方法会提示什么
	    //看看编译功能是否会将类名添加进去.
	    if (GetTriggerPlayer() == GetLocalPlayer()) then
	    	//本质是TriggerExecute(触发动作)
	    	//execute方法会掉线,禁止异步

	    	call CloseA2.execute(10)

	    //elseif (GetTriggerPlayer() == GetLocalPlayer()) then
	    	//本质是TriggerCondition(触发条件)
	    	//这个方法可以异步

	    	//set i = OpenB.evaluate(20)
	    endif
	endfunction
	
	private function TTestUTAsync2 takes nothing returns nothing
		local integer i = 0
	    if (GetTriggerPlayer() == GetLocalPlayer()) then
	    	//直接报错 54BD1BBE(v) -原因应该是不能携带参数
	    	//这个（ExecuteFunc）无法异步哦，直接掉线。
	    	//改用平台的DzExecuteFunc 可以异步
	    	call DzExecuteFunc("UTAsync__CloseA")
	    	call DzExecuteFunc("OpenB")
	    	//call DzExecuteFunc
	    endif
	endfunction
	
	private function TTestUTAsync3 takes nothing returns nothing
		local integer i = 0
	    if (GetTriggerPlayer() == GetLocalPlayer()) then
	    	call DzExecuteFunc(CloseA.name)
	    	call DzExecuteFunc(OpenB.name)
	    	//call DzExecuteFunc
	    endif
	endfunction
	
	private function TTestUTAsync4 takes nothing returns nothing
    	call DzExecuteFunc(CloseA.name)
    	call DzExecuteFunc(OpenB.name)
	endfunction
	

	/*
	大测试:字节超限数

	结论1:loop循环余1000测试,到6000就消失了
	结论2:i>7000的话 ,7524还在刷(说明条件是占用很多的) 21000还在刷,但是不超过30000  说明条件占用有影响(如果不涉及骚函数应该不会太严重)
	结论3:
	*/
	private function TTestUTAsync5 takes nothing returns nothing
		//从这里就是开始测试单节字符串极限
		local integer i = 1
		call DisplayTextToPlayer(Player(0), 0., 0., "开冲")
		loop
			//不加exitwhen应该是直接崩溃

			//实验1
			//if (ModuloInteger(i,1000) == 0) then

			//实验2
			if (i>21000) then
				//这条函数也占用很多字节数
				call BJDebugMsg("i"+"="+I2S(i))
			endif
			set i = i +1
		endloop
	endfunction
	

	function T1 takes nothing returns boolean
		call DisplayTextToPlayer(Player(0), 0., 0., "T1")
		return true
	endfunction

	function T2 takes nothing returns boolean
		call DisplayTextToPlayer(Player(0), 0., 0., "T2")
		return true
	endfunction

	function F1 takes nothing returns boolean
		call DisplayTextToPlayer(Player(0), 0., 0., "F1")
		return false
	endfunction

	function F2 takes nothing returns boolean
		call DisplayTextToPlayer(Player(0), 0., 0., "F2")
		return false
	endfunction

	private function TTestUTAsync6 takes nothing returns nothing
		//or 与 and是否有优先级(无括号情况下)
		//or成功后是否后面的判断就不调用了
		//and没成功后后面的判断是否就不调用了
		if (F1() or T1()) then
			//显示F1与T1
			call BJDebugMsg("F1 or T1")
		elseif (T1() or F1() or T2()) then
			//只显示T1 说明在符合1个的时候立马跳过后面的判断  T1() or 就立马结束
			call BJDebugMsg("T1 or sF1 or T1")
		elseif (F1() and F2()) then
			//只显示F1(只判断到 F1() 和 and 就结束了)
			call BJDebugMsg("F1 and F2")
		endif
	endfunction
	
	private function TTestUTAsync7 takes nothing returns nothing
		//引入括号:MDZZ忘记这不是数学公式运算优先级了
		if (F2() or (F1() or T2())) then
			call BJDebugMsg("(F2() or (F1() or T2()))")
		endif
	endfunction
	
	private function TTestUTAsync8 takes nothing returns nothing
	endfunction
	
	private function TTestUTAsync9 takes nothing returns nothing
	    // body...
	endfunction
	
	private function TTestUTAsync10 takes nothing returns nothing
	    // body...
	endfunction
	
	private function TTestActUTAsync1 takes string str returns nothing
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
	
	private function TTestActUTAsync takes nothing returns nothing
	    local string str = GetEventPlayerChatString()
	    local integer i = 1
	
	    if (SubStringBJ(str,1,1+1) == "ss") then
	        call TTestActUTAsync1(SubStringBJ(str,2+1,StringLength(str)))
	        return
	    endif
	
	    if (str == "s1") then
	        call TTestUTAsync1()
	    elseif (str == "s2") then
	        call TTestUTAsync2()
	    elseif (str == "s3") then
	        call TTestUTAsync3()
	    elseif (str == "s4") then
	        call TTestUTAsync4()
	    elseif (str == "s5") then
	        call TTestUTAsync5()
	    elseif (str == "s6") then
	        call TTestUTAsync6()
	    elseif (str == "s7") then
	        call TTestUTAsync7()
	    elseif (str == "s8") then
	        call TTestUTAsync8()
	    elseif (str == "s9") then
	        call TTestUTAsync9()
	    elseif (str == "s10") then
	        call TTestUTAsync10()
	    endif
	
	endfunction
	
	#endif
//-----------------------------
	/*
    初始化异步测试
	*/
	private function onInit takes nothing returns nothing
		local integer i = 1
		loop
		    exitwhen i > 12
		    call CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() )
		    set i = i +1
		endloop
		#ifdef TestMode
		
		call TriggerAddAction(TUnitTest, function TTestActUTAsync)
		
		#endif
	endfunction
endlibrary

#endif 

