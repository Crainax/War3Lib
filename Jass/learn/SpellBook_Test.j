#ifndef UTSpellBookIncluded
#define UTSpellBookIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/learn/SpellBook.j"

//! zinc

//自动生成的文件
library UTSpellBook requires SpellBook {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTSpellBook1 (player p) {
		call DzSetUnitAbilityDataD( gg_unit_Hpal_0000, 'A000', 12.00)
		//魔法书最小技能数量
		call DzSetUnitAbilityDataC( gg_unit_Hpal_0000, 'A000', 12.00)
		//魔法书技能列表
		call DzSetUnitAbilitySpellBookList( gg_unit_Hpal_0000, 'A000', "AHtc,AHfs,AHbn,AHdr,AHpx", true)
		call IncUnitAbilityLevel( gg_unit_Hpal_0000, 'AHtc')
		call DzSetUnitAbilityCost( gg_unit_Hpal_0000, 'AHtc', 3)
		call YDWEDisplayChat( Player(0), 0, ("当前魔法书技能列表:" + DzGetUnitAbilitySpellBookList( gg_unit_Hpal_0000, 'A000')))
	}
	function TTestUTSpellBook2 (player p) {}
	function TTestUTSpellBook3 (player p) {}
	function TTestUTSpellBook4 (player p) {}
	function TTestUTSpellBook5 (player p) {}
	function TTestUTSpellBook6 (player p) {}
	function TTestUTSpellBook7 (player p) {}
	function TTestUTSpellBook8 (player p) {}
	function TTestUTSpellBook9 (player p) {}
	function TTestUTSpellBook10 (player p) {}
	function TTestActUTSpellBook1 (string str) {
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
			BJDebugMsg("[SpellBook] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpellBook1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpellBook1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpellBook2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpellBook3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpellBook4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpellBook5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpellBook6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpellBook7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpellBook8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpellBook9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpellBook10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
