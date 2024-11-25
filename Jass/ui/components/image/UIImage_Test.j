#ifndef UTUIImageIncluded
#define UTUIImageIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
 * UIImage组件测试文件
 * 测试命令:
 * s1 - 创建基础图像并测试位置设置
 * s4 - 测试图像销毁功能
 * s5 - 测试工具提示背景图片1
 * s6 - 测试工具提示背景图片2
 * s7 - 测试工具提示背景图片3
 */
library UTUIImage requires UIImage {

	uiImage currentImage = 0;

	// 测试基础图像创建和位置设置
	function TTestUTUIImage1 (player p) {
		if (GetLocalPlayer() == p) {
			currentImage = uiImage.create(DzGetGameUI())
				.setSize(0.04, 0.04)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
				// .texture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp");
				.texture("ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp");
			BJDebugMsg("创建了一个基础图像UI");
		}
	}

	// 测试图像销毁功能
	function TTestUTUIImage4 (player p) {
		if (GetLocalPlayer() == p) {
			if (currentImage != 0) {
				currentImage.destroy();
				BJDebugMsg("销毁了当前图像");
				currentImage = 0;
			} else {
				BJDebugMsg("当前没有可销毁的图像");
			}
		}
	}

	// 测试工具提示背景图片1
	function TTestUTUIImage5 (player p) {
		if (GetLocalPlayer() == p) {
			if (currentImage != 0) {
				currentImage.destroy();
				currentImage = 0;
			}
			currentImage = uiImage.createToolTips(DzGetGameUI())
				.setSize(0.3, 0.4)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
			BJDebugMsg("创建了工具提示背景图片(种类1)");
		}
	}

	// 测试工具提示背景图片2
	function TTestUTUIImage6 (player p) {
		if (GetLocalPlayer() == p) {
			if (currentImage != 0) {
				currentImage.destroy();
				currentImage = 0;
			}
			currentImage = uiImage.createToolTips2(DzGetGameUI())
				.setSize(0.3, 0.4)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
			BJDebugMsg("创建了工具提示背景图片(种类2)");
		}
	}

	function TTestUTUIImage7 (player p) {
	}

	// 将TTestUTUIImage8-10保持为空函数
	function TTestUTUIImage8 (player p) {}
	function TTestUTUIImage9 (player p) {}
	function TTestUTUIImage10 (player p) {}

	function TTestActUTUIImage1 (string str) {
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
			BJDebugMsg("[UIImage] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIImage1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIImage1(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIImage4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIImage5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIImage6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIImage7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIImage8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIImage9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIImage10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
