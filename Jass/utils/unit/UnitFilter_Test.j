#ifndef UTUnitFilterIncluded
#define UTUnitFilterIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode


//! zinc

//自动生成的文件
library UTUnitFilter requires UnitFilter {

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

	function TTestUTUnitFilter1 (player p) {
		// unit uh; unit uo; unit uu; unit ue; unit una; unit unp;
		// destructable dd;
		// real x; real y;
		// object obj;

		// // 在玩家出生点附近创建测试单位
		// x = GetStartLocationX(GetPlayerStartLocation(p));
		// y = GetStartLocationY(GetPlayerStartLocation(p));

		// uh  = CreateUnit(p, 'hpea', x + 000.0, y, 0.0); // 人族：苦工/农民等常见ID
		// uo  = CreateUnit(p, 'opeo', x + 100.0, y, 0.0); // 兽族：苦工
		// uu  = CreateUnit(p, 'uaco', x + 200.0, y, 0.0); // 不死：侍僧
		// ue  = CreateUnit(p, 'ewsp', x + 300.0, y, 0.0); // 精灵：小精灵
		// una = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'hpea', x + 400.0, y, 0.0); // 中立敌对：用人族单位占位
		// unp = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),    'hpea', x + 500.0, y, 0.0); // 中立中立：用人族单位占位
		// obj  = CreateDestructable('DTrc', x + 600.0, y, 270.0, 1.0, 0); // 石头（不可作为unit传入）

		// BJDebugMsg("[UnitFilter] s1 测试开始");
		// if (IsUnitRaceOK(uh))  BJDebugMsg("人族(hpea): true"); else BJDebugMsg("人族(hpea): false");
		// if (IsUnitRaceOK(uo))  BJDebugMsg("兽族(opeo): true"); else BJDebugMsg("兽族(opeo): false");
		// if (IsUnitRaceOK(uu))  BJDebugMsg("不死(uaco): true"); else BJDebugMsg("不死(uaco): false");
		// if (IsUnitRaceOK(ue))  BJDebugMsg("精灵(ewsp): true"); else BJDebugMsg("精灵(ewsp): false");
		// if (IsUnitRaceOK(una)) BJDebugMsg("娜迦/中立敌对(neutral aggressive): true"); else BJDebugMsg("娜迦/中立敌对(neutral aggressive): false");
		// if (IsUnitRaceOK(unp)) BJDebugMsg("中立中立(neutral passive): true"); else BJDebugMsg("中立中立(neutral passive): false");
		// if (IsUnitRaceOK(obj)) BJDebugMsg("obj: true"); else BJDebugMsg("dd: false");
		// if (IsUnitRaceOK(null)) BJDebugMsg("null: true"); else BJDebugMsg("null: false");

		// // 置空句柄
		// uh = null; uo = null; uu = null; ue = null; una = null; unp = null;
		// dd = null;
	}
	function TTestUTUnitFilter2 (player p) {}
	function TTestUTUnitFilter3 (player p) {}
	function TTestUTUnitFilter4 (player p) {}
	function TTestUTUnitFilter5 (player p) {}
	function TTestUTUnitFilter6 (player p) {}
	function TTestUTUnitFilter7 (player p) {}
	function TTestUTUnitFilter8 (player p) {}
	function TTestUTUnitFilter9 (player p) {}
	function TTestUTUnitFilter10 (player p) {}
	function TTestActUTUnitFilter1 (string str) {
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
			BJDebugMsg("[UnitFilter] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitFilter1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitFilter1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitFilter2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitFilter3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitFilter4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitFilter5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitFilter6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitFilter7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitFilter8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitFilter9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitFilter10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
