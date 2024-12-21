#ifndef UTUIButtonIncluded
#define UTUIButtonIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * UIButton组件测试文件
 * 测试命令:
 * s1 - 创建带图像的基础按钮
 * s2 - 测试按钮事件系统
 * s3 - 测试空白按钮（可以与图像组合）
 * s4 - 测试按钮销毁功能
 * s5 - 测试RC按钮（右键点击按钮）
 */
library UTUIButton requires UIButton {

	uiBtn currentBtn = 0;

	// 测试基础按钮创建和位置设置
	function TTestUTUIButton1 (player p) {
		uiImage img;
		if (GetLocalPlayer() == p) {
			img = uiImage.create(DzGetGameUI()).setSize(0.04,0.04)
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
			currentBtn = uiBtn.create(DzGetGameUI())
				.setAllPoint(img.ui);
			BJDebugMsg("创建了一个基础按钮UI");
		}
	}

	// 测试按钮事件系统
	function TTestUTUIButton2 (player p) {
		if (GetLocalPlayer() == p) {
			currentBtn = uiBtn.create(DzGetGameUI())
				.setSize(0.04,0.04)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
				.onMouseEnter(function() { BJDebugMsg("鼠标进入按钮"); })
				.onMouseLeave(function() { BJDebugMsg("鼠标离开按钮"); })
				.onMouseClick(function() { BJDebugMsg("点击按钮"); });
			BJDebugMsg("创建了一个带事件的按钮UI");
		}
	}

	// 测试空白按钮
	function TTestUTUIButton3 (player p) {
		uiBtn blankBtn = uiBtn.createBlank(DzGetGameUI()).setSize(0.04,0.04)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.onMouseEnter(function() { BJDebugMsg("鼠标进入按钮"); })
			.onMouseLeave(function() { BJDebugMsg("鼠标离开按钮"); })
			.onMouseClick(function() { BJDebugMsg("点击按钮"); })
			.onMouseWheel(function (){BJDebugMsg("鼠标滚轮:"+I2S(DzGetTriggerUIEventFrame()));})
			.onMouseDoubleClick(function (){BJDebugMsg("鼠标双击:"+I2S(DzGetTriggerUIEventFrame()));});
		uiImage img = uiImage.create(DzGetGameUI())
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
			.setAllPoint(blankBtn.ui);
		BJDebugMsg("创建了空白按钮UI");
	}

	// 测试按钮销毁功能
	function TTestUTUIButton4 (player p) {
		if (GetLocalPlayer() == p) {
			if (currentBtn != 0) {
				currentBtn.destroy();
				BJDebugMsg("销毁了当前按钮");
				currentBtn = 0;
			} else {
				BJDebugMsg("当前没有可销毁的按钮");
			}
		}
	}

	function TTestUTUIButton5 (player p) {
		if (GetLocalPlayer() == p) {
			currentBtn = uiBtn.createRC(DzGetGameUI())
				.setSize(0.04,0.04)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
				.onMouseEnter(function() { BJDebugMsg("鼠标进入按钮"); })
				.onMouseLeave(function() { BJDebugMsg("鼠标离开按钮"); })
				.onMouseClick(function() { BJDebugMsg("点击按钮"); });
			BJDebugMsg("创建了一个带事件的按钮UI");
		}
	}

	function TTestUTUIButton6 (player p) {
		if (GetLocalPlayer() == p) {
			currentBtn = uiBtn.createMenu(DzGetGameUI())
				.setSize(0.179,0.031)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
				.onMouseEnter(function() { BJDebugMsg("鼠标进入按钮"); })
				.onMouseLeave(function() { BJDebugMsg("鼠标离开按钮"); })
				.onMouseClick(function() { BJDebugMsg("点击按钮"); });
			BJDebugMsg("创建了一个菜单系的按钮UI");
		}
	}
	function TTestUTUIButton7 (player p) {}
	function TTestUTUIButton8 (player p) {}
	function TTestUTUIButton9 (player p) {}
	function TTestUTUIButton10 (player p) {}

	// 处理带参数的测试命令
	function TTestActUTUIButton1 (string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];                              //所有参数S
		integer paramI [];                              //所有参数I
		real    paramR [];                              //所有参数R
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
			// 可以添加带参数的测试功能
		} else if (paramS[0] == "b") {
			// 可以添加带参数的测试功能
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.5秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIButton] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIButton1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIButton1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIButton2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIButton3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIButton4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIButton5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIButton6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIButton7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIButton8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIButton9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIButton10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
