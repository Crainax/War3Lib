#ifndef UTUILifeCycleIncluded
#define UTUILifeCycleIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc
/*
 * UI生命周期组件单元测试
 *
 * @作者: 你的名字
 * @时间: 2024-03-xx
 * @版本: 1.0.0
 *
 * 测试命令:
 * s1 - 创建一个测试文本
 * -a - 销毁测试文本
 *
 * 功能说明:
 * 1. 测试UI组件的创建和销毁生命周期
 * 2. 监听并输出UI组件的创建和销毁事件
 */
library UTUILifeCycle requires UILifeCycle {

	uiText txt = 0;
	function TTestUTUILifeCycle1 (player p) {
		txt = uiText.create(DzGetGameUI())
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setAlign(4)
			.setText("随便的内容");
		BJDebugMsg("FrameID：" + I2S(txt.ui));
	}
	function TTestUTUILifeCycle2 (player p) {
		//uiLifeCycle
	}
	function TTestUTUILifeCycle3 (player p) {}
	function TTestUTUILifeCycle4 (player p) {}
	function TTestUTUILifeCycle5 (player p) {}
	function TTestUTUILifeCycle6 (player p) {}
	function TTestUTUILifeCycle7 (player p) {}
	function TTestUTUILifeCycle8 (player p) {}
	function TTestUTUILifeCycle9 (player p) {}
	function TTestUTUILifeCycle10 (player p) {}
	function TTestActUTUILifeCycle1 (string str) {
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
			if (txt.isExist()) {
				txt.destroy();
			}
		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("|cff00ff00[UILifeCycle]|r UI生命周期组件单元测试已加载");
			BJDebugMsg(" - 输入 |cffffcc00s1|r 创建测试文本");
			BJDebugMsg(" - 输入 |cffffcc00-a|r 销毁测试文本");
			BJDebugMsg(" - 系统将自动监听并显示UI的创建和销毁事件");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUILifeCycle1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUILifeCycle1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUILifeCycle2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUILifeCycle3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUILifeCycle4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUILifeCycle5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUILifeCycle6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUILifeCycle7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUILifeCycle8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUILifeCycle9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUILifeCycle10(GetTriggerPlayer());
		});
		uiLifeCycle.registerCreate(function () {
			integer ui     = uiLifeCycle.agrsUI;
			integer typeID = uiLifeCycle.agrsTypeID;
			integer frame  = uiLifeCycle.agrsFrame;
			BJDebugMsg("[UILifeCycle] 创建回调已执行：" + I2S(ui) + " " + I2S(typeID) + " " + I2S(frame));
		});
		uiLifeCycle.registerDestroy(function () {
			integer ui     = uiLifeCycle.agrsUI;
			integer typeID = uiLifeCycle.agrsTypeID;
			integer frame  = uiLifeCycle.agrsFrame;
			BJDebugMsg("[UILifeCycle] 销毁回调已执行：" + I2S(ui) + " " + I2S(typeID) + " " + I2S(frame));
		});
	}

}
//! endzinc

#endif
