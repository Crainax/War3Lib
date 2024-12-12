#ifndef UTIconIncluded
#define UTIconIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTIcon requires Icon {

	private icon testIcon1 = 0;
	private boolean isTest1Active = false;
	private boolean isTest3Active = false;
	private boolean isTest4Active = false;

	// 基础图标创建和显示测试
	function TTestUTIcon1 (player p) {
		if (!isTest1Active) {
			testIcon1 = icon.create(DzGetGameUI());
			testIcon1.mainImage.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0);
			testIcon1.setTexture("ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp");
			testIcon1.setSize(0.04, 0.04);
			testIcon1.show(true);
			isTest1Active = true;
			BJDebugMsg("基础图标已创建 - 输入s1可关闭");
		} else {
			testIcon1.destroy();
			testIcon1 = 0;
			isTest1Active = false;
			BJDebugMsg("基础图标已关闭");
		}
	}

	// 角落文字测试
	function TTestUTIcon2 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}
		testIcon1.setCornerText(I2S(GetRandomInt(1, 99)));
		testIcon1.showCornerText(true);
		BJDebugMsg("已更新角落文字 - 再次输入s2随机新数字");
	}

	// 流光效果测试
	function TTestUTIcon3 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		if (!isTest3Active) {
			testIcon1.grow(DzGetGameUI(), growdata[ICONGROW_2]);
			isTest3Active = true;
			BJDebugMsg("流光效果已开启 - 输入s3可关闭");
		} else {
			testIcon1.unGrow();
			isTest3Active = false;
			BJDebugMsg("流光效果已关闭");
		}
	}

	// 暗遮罩测试
	function TTestUTIcon4 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		if (!isTest4Active) {
			testIcon1.setShadow(true);
			isTest4Active = true;
			BJDebugMsg("暗遮罩已开启 - 输入s4可关闭");
		} else {
			testIcon1.setShadow(false);
			isTest4Active = false;
			BJDebugMsg("暗遮罩已关闭");
		}
	}

	// 点击事件测试
	function TTestUTIcon5 (player p) {
		uiBtn btn;
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		btn = testIcon1.getClickBtn();
		btn.onMouseClick(function(){
			BJDebugMsg("图标被点击!");
		});
		BJDebugMsg("点击事件已绑定 - 请点击图标测试");
	}

	// CD显示测试
	function TTestUTIcon6 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		testIcon1.startCooldown(10.0);
		BJDebugMsg("CD显示已开始 - 持续10秒");
	}

	function TTestUTIcon7 (player p) {}
	function TTestUTIcon8 (player p) {}
	function TTestUTIcon9 (player p) {}
	function TTestUTIcon10 (player p) {}
	function TTestActUTIcon1 (string str) {
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
			BJDebugMsg("[Icon] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTIcon1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTIcon1(GetTriggerPlayer());
			else if(str == "s2") TTestUTIcon2(GetTriggerPlayer());
			else if(str == "s3") TTestUTIcon3(GetTriggerPlayer());
			else if(str == "s4") TTestUTIcon4(GetTriggerPlayer());
			else if(str == "s5") TTestUTIcon5(GetTriggerPlayer());
			else if(str == "s6") TTestUTIcon6(GetTriggerPlayer());
			else if(str == "s7") TTestUTIcon7(GetTriggerPlayer());
			else if(str == "s8") TTestUTIcon8(GetTriggerPlayer());
			else if(str == "s9") TTestUTIcon9(GetTriggerPlayer());
			else if(str == "s10") TTestUTIcon10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
