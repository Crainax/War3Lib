#ifndef UTUIExtendDragIncluded
#define UTUIExtendDragIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIExtendDrag requires UIExtendDrag {

	uiBtn btn = 0;
	uiImage img = 0;

	function TTestUTUIExtendDrag1 (player p) {
		img = uiImage.create(DzGetGameUI())
			.setSize(0.1,0.1)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
		btn = uiBtn.create(img.ui)
			.setAllPoint(img.ui)
			.enableDrag(img.ui,0.1, 0.7, 0.2, 0.5);
		// .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
		uiHashTable(btn.ui).eventdata.bind(8174);
	}
	function TTestUTUIExtendDrag2 (player p) {}
	function TTestUTUIExtendDrag3 (player p) {}
	function TTestUTUIExtendDrag4 (player p) {}
	function TTestUTUIExtendDrag5 (player p) {}
	function TTestUTUIExtendDrag6 (player p) {}
	function TTestUTUIExtendDrag7 (player p) {}
	function TTestUTUIExtendDrag8 (player p) {}
	function TTestUTUIExtendDrag9 (player p) {}
	function TTestUTUIExtendDrag10 (player p) {}
	function TTestActUTUIExtendDrag1 (string str) {
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
			BJDebugMsg("[UIExtendDrag] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIExtendDrag1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIExtendDrag1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIExtendDrag2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIExtendDrag3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIExtendDrag4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIExtendDrag5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIExtendDrag6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIExtendDrag7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIExtendDrag8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIExtendDrag9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIExtendDrag10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
