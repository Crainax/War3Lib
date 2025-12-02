#ifndef UTUnitUtilsIncluded
#define UTUnitUtilsIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode


//! zinc

//自动生成的文件
library UTUnitUtils requires UnitUtils {

	function Init () {
		// 注册全局单位选中事件，打印当前攻击力与攻击倍数
		trigger selTr;
		integer i;
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//GetUnitAttackInterval
		},null);

		selTr = CreateTrigger();
		for (0 <= i <= 11) {
			TriggerRegisterPlayerUnitEvent(selTr, Player(i), EVENT_PLAYER_UNIT_SELECTED, null);
		}
		TriggerAddCondition(selTr, Condition(function () -> boolean {
			unit u; real atk; real mult;
			u    = GetTriggerUnit();
			atk  = GetUnitAttack(u);
			mult = GetUnitAttackMult(u);
			BJDebugMsg("[UnitUtils] 选中单位攻击=" + R2S(atk) + "  倍数=" + R2S(mult));
			u = null;
			return false;
		}));
		selTr = null;
	}

	function TTestUTUnitUtils1 (player p) {
		integer i;
		unit u;
		real x; real y;
		integer startLoc;

		startLoc = GetPlayerStartLocation(p);
		x = GetStartLocationX(startLoc);
		y = GetStartLocationY(startLoc);

		// 创建 3 个步兵，分别设置不同量级的攻击力（含超过 21 亿的情况）
		for (0 <= i <= 2) {
			u = CreateUnit(p, 'hfoo', x + 150.0 * I2R(i), y, 270.0);
			if (i == 0) {
				SetUnitAttack(u, 500000000.0);      // 5e8，不触发扩展
			} else if (i == 1) {
				SetUnitAttack(u, 250000000.0*10.0);     // 2.5e9，触发扩展
			} else {
				SetUnitAttack(u, 9999999.0  * 19999.0);    // 9.999e10，更大数
			}
			u = null;
		}
	}
	function TTestUTUnitUtils2 (player p) {}
	function TTestUTUnitUtils3 (player p) {}
	function TTestUTUnitUtils4 (player p) {}
	function TTestUTUnitUtils5 (player p) {}
	function TTestUTUnitUtils6 (player p) {}
	function TTestUTUnitUtils7 (player p) {}
	function TTestUTUnitUtils8 (player p) {}
	function TTestUTUnitUtils9 (player p) {}
	function TTestUTUnitUtils10 (player p) {}
	function TTestActUTUnitUtils1 (string str) {
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
			BJDebugMsg("[UnitUtils] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitUtils10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
