#ifndef UTSpellIncluded
#define UTSpellIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSpell requires Spell {

	private struct [20000] spell  {
		integer id;
		integer level;
		integer sdId;
	}

	// 添加全局测试单位变量
	private unit testArchmage = null;
	private unit testFootman = null;

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//spell
		},null);
		unitSelect.onSync(function() {
			//结论:EXGetUnitAbility获取百位动态技能
			//DzUnitFindAbility获取正常Handle技能,未学习的技能没有Handle,学习后的Handle不是最大的(代表不是新建的)
			//AInv这个物品栏技能不知道为什么步兵也有
			//删除再新建后,Handle会变
			unit u = unitSelect.argsSync;
			integer index;
			ability a = null,b = null;
			Trace("已选择单位:" + GetUnitName(u));
			b = DzUnitFindAbility(u, 'AHbz');
			Trace(" AHbz: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHab');
			Trace(" AHab: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHwe');
			Trace(" AHwe: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHmt');
			Trace(" AHmt: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AInv');
			Trace(" AInv: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'Adef');
			Trace(" Adef: " + I2S(GetHandleId(b)));
			u = null;
		});
	}

	//测试一下Japi获取的技能
	function TTestUTSpell1 (player p) {
		testArchmage = CreateUnit(p, 'Hamg', 0, 0, 270); // 在(0,0)位置创建大法师
		testFootman = CreateUnit(p, 'hfoo', 200, 0, 270); // 在(200,0)位置创建步兵
		SetHeroLevel(testArchmage, 10, true); // 将大法师升到10级
		Trace("已创建大法师和步兵用于测试");
	}
	function TTestUTSpell2 (player p) {
		if (testFootman != null) {
			UnitRemoveAbility(testFootman, 'Adef'); // 移除防御技能
			Trace("已移除步兵的防御技能");
		} else {
			Trace("错误：请先使用s1创建测试单位");
		}
	}
	function TTestUTSpell3 (player p) {
		if (testFootman != null) {
			UnitAddAbility(testFootman, 'Adef'); // 添加防御技能
			Trace("已给步兵添加防御技能");
		} else {
			Trace("错误：请先使用s1创建测试单位");
		}
	}
	function TTestUTSpell4 (player p) {}
	function TTestUTSpell5 (player p) {}
	function TTestUTSpell6 (player p) {}
	function TTestUTSpell7 (player p) {}
	function TTestUTSpell8 (player p) {}
	function TTestUTSpell9 (player p) {}
	function TTestUTSpell10 (player p) {}
	function TTestActUTSpell1 (string str) {
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
			BJDebugMsg("[Spell] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpell1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpell1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpell2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpell3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpell4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpell5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpell6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpell7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpell8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpell9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpell10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
