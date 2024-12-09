#ifndef UTUISimpleEventIncluded
#define UTUISimpleEventIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUISimpleEvent requires UISimpleEvent {

	uiBtn btn = 0;
	uiImage img = 0;
	function TTestUTUISimpleEvent1 (player p) {
		img = uiImage.create(DzGetGameUI())
			.setSize(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.texture("ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp");
		btn = uiBtn.create(DzGetGameUI())
			.setAllPoint(img.ui)
			.spEnter(function(integer frame) {integer data = uiHashTable.eventdata.get(frame);BJDebugMsg("enter:"+I2S(data));})
			.spLeave(function(integer frame) {integer data = uiHashTable.eventdata.get(frame);BJDebugMsg("leave:"+I2S(data));})
			.spClick(function(integer frame) {integer data = uiHashTable.eventdata.get(frame);BJDebugMsg("click:"+I2S(data));})
			.spRightClick(function(integer frame) {integer data = uiHashTable.eventdata.get(frame);BJDebugMsg("RightClick:"+I2S(data));});
		uiHashTable.eventdata.bind(btn.ui,8174);

	}
	function TTestUTUISimpleEvent2 (player p) {
		if (btn.isExist()) {
			btn.destroy();
			BJDebugMsg("删除了,方便测试离开事件:"+I2S(btn.ui));
		}
	}
	function TTestUTUISimpleEvent3 (player p) {}
	function TTestUTUISimpleEvent4 (player p) {}
	function TTestUTUISimpleEvent5 (player p) {}
	function TTestUTUISimpleEvent6 (player p) {}
	function TTestUTUISimpleEvent7 (player p) {}
	function TTestUTUISimpleEvent8 (player p) {}
	function TTestUTUISimpleEvent9 (player p) {}
	function TTestUTUISimpleEvent10 (player p) {}
	function TTestActUTUISimpleEvent1 (string str) {
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
			BJDebugMsg("[UISimpleEvent] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUISimpleEvent1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUISimpleEvent1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUISimpleEvent2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUISimpleEvent3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUISimpleEvent4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUISimpleEvent5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUISimpleEvent6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUISimpleEvent7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUISimpleEvent8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUISimpleEvent9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUISimpleEvent10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
