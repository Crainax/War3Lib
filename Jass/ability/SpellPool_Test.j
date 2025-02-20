#ifndef UTSpellPoolIncluded
#define UTSpellPoolIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSpellPool requires SpellPool {


	unit u1;
	unit u2;
	integer testAbility1 = 'AHbz'; // 暴风雪
	integer testAbility2 = 'AHfs'; // 烈焰风暴
	integer testAbility3 = 'AHwe'; // 水元素
	function Init () {

		UnitTestAutoTimer(0.1, 2.0, function() {
			// 创建两个步兵在(0,0)位置
			u1 = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
			u2 = CreateUnit(Player(0), 'hfoo', 200, 200, 0);

			// 给单位添加测试技能
			UnitAddAbility(u1, testAbility1);
			UnitAddAbility(u1, testAbility2);
			UnitAddAbility(u1, testAbility3);

			UnitAddAbility(u2, testAbility1);
			UnitAddAbility(u2, testAbility2);
			UnitAddAbility(u2, testAbility3);

			BJDebugMsg("测试单位已创建并添加技能");
			}, function() {
			// 2秒后的清理代码
		});

		unitSelect.onSync(function () {
			spellpool_u = unitSelect.argsSync;
		});

		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//spellPool
		},null);
	}

	function TTestUTSpellPool1 (player p) {
		TriggerEvaluate(spellpool_tr);
		BJDebugMsg("调用了测试");
	}
	function TTestUTSpellPool2 (player p) {}
	function TTestUTSpellPool3 (player p) {}
	function TTestUTSpellPool4 (player p) {}
	function TTestUTSpellPool5 (player p) {}
	function TTestUTSpellPool6 (player p) {}
	function TTestUTSpellPool7 (player p) {}
	function TTestUTSpellPool8 (player p) {}
	function TTestUTSpellPool9 (player p) {}
	function TTestUTSpellPool10 (player p) {}
	function TTestActUTSpellPool1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			//YDLua
			Cheat("exec-lua:depends.spellpool");
			BJDebugMsg("[SpellPool] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellPool1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellPool1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellPool2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellPool3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellPool4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellPool5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellPool6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellPool7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellPool8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellPool9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellPool10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
