#ifndef UTNewKKIncluded
#define UTNewKKIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/learn/NewKK.j"

//! zinc

//自动生成的文件
library UTNewKK requires NewKK {

	// 全局计数变量用于测试
	private integer globalCounter = 0;

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

	//测试结果是正常的:250000
	function TTestUTNewKK1 (player p) {
		group unitGroup; unit testUnit; integer i; integer unitCount;

		// 重置计数器
		globalCounter = 0;

		// 创建测试单位组和500个单位
		unitGroup = CreateGroup();
		unitCount = 0;

		// 创建500个单位（使用农民作为测试单位）
		for (1 <= i <= 500) {
			testUnit = CreateUnit(Player(0), 'hpea', 0.0 + i * 50.0, 0.0, 270.0);
			GroupAddUnit(unitGroup, testUnit);
			unitCount = unitCount + 1;
			testUnit = null;
		}

		// 对每个单位执行500次内循环
		ForGroup(unitGroup, function () {
			unit currentUnit; integer innerLoop;

			currentUnit = GetEnumUnit();

			// 对每个单位执行500次循环，每次给全局变量+1
			for (1 <= innerLoop <= 500) {
				globalCounter = globalCounter + 1;
			}

			currentUnit = null;
		});

		// 输出结果
		BJDebugMsg("创建的单位数量: " + I2S(unitCount));
		BJDebugMsg("最终计数结果: " + I2S(globalCounter));
		BJDebugMsg("预期结果 (500 * 500): 250000");

		// 清理资源
		DestroyGroup(unitGroup);
		unitGroup = null;
	}

	//测试结果是:7894500 :   上限15789
	function TTestUTNewKK2 (player p) {
		group unitGroup; unit testUnit; integer i; integer unitCount;

		// 重置计数器
		globalCounter = 0;

		// 创建测试单位组和500个单位
		unitGroup = CreateGroup();
		unitCount = 0;

		// 创建500个单位（使用农民作为测试单位）
		for (1 <= i <= 500) {
			testUnit = CreateUnit(Player(0), 'hpea', 0.0 + i * 50.0, 0.0, 270.0);
			GroupAddUnit(unitGroup, testUnit);
			unitCount = unitCount + 1;
			testUnit = null;
		}

		// 对每个单位执行500次内循环
		ForGroup(unitGroup, function () {
			unit currentUnit; integer innerLoop;

			currentUnit = GetEnumUnit();

			// 对每个单位执行20000次循环，每次给全局变量+1
			for (1 <= innerLoop <= 20000) {
				globalCounter = globalCounter + 1;
			}

			currentUnit = null;
		});

		// 输出结果
		BJDebugMsg("创建的单位数量: " + I2S(unitCount));
		BJDebugMsg("最终计数结果: " + I2S(globalCounter));
		BJDebugMsg("预期结果 (500 * 20000): 10000000");

		// 清理资源
		DestroyGroup(unitGroup);
		unitGroup = null;
	}

	//打开后N2测试就是10000000了
	function TTestUTNewKK3 (player p) {
		BJDebugMsg("打开了字节码限制");
		DzUnlockOpCodeLimit(true);
	}
	function TTestUTNewKK4 (player p) {
		integer index;
		integer count = 0;
		for (0 <= index <= 10000000) {
			count = count + 1;
		}
		BJDebugMsg("count: " + I2S(count));
	}

	function TTestUTNewKK5 (player p) {}
	function TTestUTNewKK6 (player p) {}
	function TTestUTNewKK7 (player p) {}
	function TTestUTNewKK8 (player p) {}
	function TTestUTNewKK9 (player p) {}
	function TTestUTNewKK10 (player p) {}
	function TTestActUTNewKK1 (string str) {
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
			BJDebugMsg("[NewKK] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTNewKK1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTNewKK1(GetTriggerPlayer());
			else if(str == "s2") TTestUTNewKK2(GetTriggerPlayer());
			else if(str == "s3") TTestUTNewKK3(GetTriggerPlayer());
			else if(str == "s4") TTestUTNewKK4(GetTriggerPlayer());
			else if(str == "s5") TTestUTNewKK5(GetTriggerPlayer());
			else if(str == "s6") TTestUTNewKK6(GetTriggerPlayer());
			else if(str == "s7") TTestUTNewKK7(GetTriggerPlayer());
			else if(str == "s8") TTestUTNewKK8(GetTriggerPlayer());
			else if(str == "s9") TTestUTNewKK9(GetTriggerPlayer());
			else if(str == "s10") TTestUTNewKK10(GetTriggerPlayer());
		});

		DzUnlockOpCodeLimit(true); //在onInit用也正常
	}

}
//! endzinc

#endif
