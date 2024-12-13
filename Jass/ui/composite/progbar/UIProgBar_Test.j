#ifndef UTUIProgBarIncluded
#define UTUIProgBarIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc
/*
* 进度条组件单元测试
*
* @作者: 你的名字
* @时间: 2024-03-xx
* @版本: 1.0.0
*
* 测试命令:
* s1 - 创建一个基础进度条
* s2 - 创建一个测试图像
* -a [参数] - 执行特定测试动作
* -b [参数] - 执行特定测试动作
*/
library UTUIProgBar requires UIProgBar {

	uiProgBar progBar = 0;
	function TTestUTUIProgBar1 (player p) {
		progBar = uiProgBar.create(DzGetGameUI())
			.setScale(2)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
		progBar.uiShade.progAnimate(0,1,3.0,0); // 进度条动画
	}
	function TTestUTUIProgBar2 (player p) {
		uiImage currentImage = uiImage.create(DzGetGameUI())
			.setSize(0.2,0.01)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp");
	}
	function TTestUTUIProgBar3 (player p) {

	}
	function TTestUTUIProgBar4 (player p) {}
	function TTestUTUIProgBar5 (player p) {}
	function TTestUTUIProgBar6 (player p) {}
	function TTestUTUIProgBar7 (player p) {}
	function TTestUTUIProgBar8 (player p) {}
	function TTestUTUIProgBar9 (player p) {}
	function TTestUTUIProgBar10 (player p) {}
	function TTestActUTUIProgBar1 (string str) {
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

	real progress = 0.0;
	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("|cff00ff00[UIProgBar]|r 进度条组件单元测试已加载");
			BJDebugMsg(" - 输入 |cffffcc00s1|r 创建基础进度条");
			BJDebugMsg(" - 输入 |cffffcc00s2|r 创建测试图像");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIProgBar1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIProgBar1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIProgBar2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIProgBar3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIProgBar4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIProgBar5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIProgBar6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIProgBar7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIProgBar8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIProgBar9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIProgBar10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
