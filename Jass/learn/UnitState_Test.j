#ifndef UTUnitStateIncluded
#define UTUnitStateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitState requires UnitState {

	// 测试单位
	private unit myPeasant = null;      // 我方农民
	private unit enemyPeasant = null;   // 敌方农民

	function Init () {
		player p; player enemyP;  // 局部变量声明在前
		//sdfkjsdjklfslkfslkfdl

		// 创建我方农民（玩家1）
		p = Player(0);
		myPeasant = CreateUnit(p, 'hpea', 0.0, 0.0, 270.0);
		p = null;

		// 创建敌方农民（玩家2）
		enemyP = Player(10);
		enemyPeasant = CreateUnit(enemyP, 'hpea', 500.0, 0.0, 270.0);
		enemyP = null;

		BJDebugMsg("[UnitState] 测试单位已创建：我方农民和敌方农民");
	}

	function TTestUTUnitState1 (player p) {
		unit summonedPeasant; player enemyP; integer pid;  // 局部变量声明在前

		if (myPeasant == null || enemyPeasant == null) {
			BJDebugMsg("[UnitState] 错误：测试单位未初始化");
			return;
		}

		pid = GetConvertedPlayerId(p);
		// 获取敌方玩家（如果当前是玩家1，则敌方是玩家2，否则敌方是玩家1）
		if (pid == 1) {
			enemyP = ConvertedPlayer(11);
		} else {
			enemyP = ConvertedPlayer(1);
		}

		// 召唤敌方农民
		summonedPeasant = CreateUnit(enemyP, 'hpea', GetUnitX(myPeasant) + 200.0, GetUnitY(myPeasant), 270.0);

		// 添加沉默技能 'A02o'
		UnitAddAbility(summonedPeasant, 'A02o');
		UnitAddAbility(myPeasant, 'A02o');

		// 对我方农民释放沉默（852075 是沉默技能 ACsi 的 OrderId）
		IssueTargetOrderById(summonedPeasant, 852075, myPeasant);

		BJDebugMsg("[UnitState] 已召唤敌方农民并对我方农民释放沉默");

		// 清理句柄
		summonedPeasant = null;
		enemyP = null;
	}
	function TTestUTUnitState2 (player p) {}
	function TTestUTUnitState3 (player p) {}
	function TTestUTUnitState4 (player p) {}
	function TTestUTUnitState5 (player p) {}
	function TTestUTUnitState6 (player p) {}
	function TTestUTUnitState7 (player p) {}
	function TTestUTUnitState8 (player p) {}
	function TTestUTUnitState9 (player p) {}
	function TTestUTUnitState10 (player p) {}
	function TTestActUTUnitState1 (string str) {
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
			BJDebugMsg("[UnitState] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitState1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitState1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitState2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitState3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitState4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitState5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitState6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitState7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitState8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitState9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitState10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
