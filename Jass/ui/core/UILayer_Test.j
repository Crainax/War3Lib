#ifndef UTUILayerIncluded
#define UTUILayerIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUILayer requires UILayer {

	uiImage image1 = 0, image2 = 0;
	boolean switchLayer = false;
	function TTestUTUILayer1 (player p) {
		uiText txt = 0;
		image1 = uiImage.create(uilayer.lv[1])
			.setSize(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.01, 0.0)
			.setTexture("ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp");
		txt = uiText.create(image1.ui)
			.setAllPoint(image1.ui)
			.setAlign(4)
			.setText("a");
		image2 = uiImage.create(uilayer.lv[2])
			.setSize(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNStampede.blp");
		txt = uiText.create(image2.ui)
			.setAllPoint(image2.ui)
			.setAlign(4)
			.setText("b");
	}
	function TTestUTUILayer2 (player p) {
		if (switchLayer) {
			switchLayer = false;
			DzFrameSetParent(image1.ui, image2.ui);
			// DzFrameSetParent(image2.ui, uilayer.lv[2]);
			BJDebugMsg("切换了层级:1");
		} else {
			switchLayer = true;
			DzFrameSetParent(image2.ui, image1.ui);
			// DzFrameSetParent(image1.ui, uilayer.lv[2]);
			// DzFrameSetParent(image2.ui, uilayer.lv[1]);
			BJDebugMsg("切换了层级:2");
		}
		BJDebugMsg("Image1的父:"+I2S(DzFrameGetParent(image1.ui)));
		BJDebugMsg("Image2的父:"+I2S(DzFrameGetParent(image2.ui)));
		BJDebugMsg("lv1子数:"+I2S(DzFrameGetChildrenCount(uilayer.lv[1])));
		BJDebugMsg("lv2子数:"+I2S(DzFrameGetChildrenCount(uilayer.lv[2])));
	}
	function TTestUTUILayer3 (player p) {
		if (uilayer.lv[1] != 0) {
			DzDestroyFrame(uilayer.lv[1]);
			uilayer.lv[1] = 0;
		}
	}
	function TTestUTUILayer4 (player p) {
		DzFrameSetParent(image1.ui,DzGetGameUI());
		DzDestroyFrame(uilayer.lv[1]);
		uilayer.lv[1] = 0;
		BJDebugMsg("测试重置换父");
	}
	function TTestUTUILayer5 (player p) {}
	function TTestUTUILayer6 (player p) {}
	function TTestUTUILayer7 (player p) {}
	function TTestUTUILayer8 (player p) {}
	function TTestUTUILayer9 (player p) {}
	function TTestUTUILayer10 (player p) {}
	function TTestActUTUILayer1 (string str) {
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
			DzFrameSetParent(image1.ui, uilayer.lv[paramI[1]]);
			BJDebugMsg("图片a的层级:"+I2S(paramI[1]));
		} else if (paramS[0] == "b") {
			DzFrameSetParent(image2.ui, uilayer.lv[paramI[1]]);
			BJDebugMsg("图片b的层级:"+I2S(paramI[1]));
		} else if (paramS[0] == "destroy") {

			DzDestroyFrame(uilayer.lv[paramI[1]]);
			image1 = 0;
			image2 = 0;
			BJDebugMsg("销毁层级:"+I2S(paramI[1]));
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UILayer] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUILayer1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUILayer1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUILayer2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUILayer3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUILayer4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUILayer5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUILayer6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUILayer7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUILayer8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUILayer9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUILayer10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
