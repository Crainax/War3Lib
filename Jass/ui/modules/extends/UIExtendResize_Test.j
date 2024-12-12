#ifndef UTUIExtendResizeIncluded
#define UTUIExtendResizeIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIExtendResize requires UIExtendResize {

	uiImage img = 0;
	function TTestUTUIExtendResize1 (player p) {
		img = uiImage.create(DzGetGameUI())
		// .setSizeFix(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.exReSize(0.035,0.035) //自适应大小
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp");
	}
	uiImage imgs[];
	function TTestUTUIExtendResize2 (player p) {
		uiText txt[];
		integer i,row,column;
		for (1 <= i <= 20) {
			row = ModuloInteger(i - 1,5/*多少个一行*/) + 1;
			column = (i - 1) / 5 + 1;
			// row , column
			imgs[i] = uiImage.create(DzGetGameUI())
				.exReSize(0.035,0.035)
				.exRePoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, row * 0.036, column * -0.036)
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp");
			txt[i] = uiText.create(imgs[i].ui)
				.setAllPoint(imgs[i].ui)
				.setAlign(4)
				.setText(I2S(i)+"号");
		}

	}
	function TTestUTUIExtendResize3 (player p) {}
	function TTestUTUIExtendResize4 (player p) {}
	function TTestUTUIExtendResize5 (player p) {}
	function TTestUTUIExtendResize6 (player p) {}
	function TTestUTUIExtendResize7 (player p) {}
	function TTestUTUIExtendResize8 (player p) {}
	function TTestUTUIExtendResize9 (player p) {}
	function TTestUTUIExtendResize10 (player p) {}
	function TTestActUTUIExtendResize1 (string str) {
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

		if (paramS[0] == "show") {
			BJDebugMsg("resizer:" + resizer.toString());
			BJDebugMsg("rePointer:" + rePointer.toString());
		} else if (paramS[0] == "destroy") {
			if (img.isExist()) {
				img.onDestroy();
				img = 0;
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIExtendResize] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIExtendResize1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (GetLocalPlayer() != GetTriggerPlayer()) {return;}
			if (str == "s1") TTestUTUIExtendResize1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIExtendResize2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIExtendResize3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIExtendResize4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIExtendResize5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIExtendResize6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIExtendResize7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIExtendResize8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIExtendResize9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIExtendResize10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
