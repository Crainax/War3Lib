#ifndef UTUIExtendEventIncluded
#define UTUIExtendEventIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIExtendEvent requires UIExtendEvent {

	uiBtn btn = 0;
	uiImage img = 0;
	function TTestUTUIExtendEvent1 (player p) {
		img = uiImage.create(DzGetGameUI())
			.setSize(0.035,0.035)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.texture("ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp");
		btn = uiBtn.create(DzGetGameUI())
			.setAllPoint(img.ui)
			.onMouseEnter(function() {BJDebugMsg("enter");})
			.onMouseLeave(function() {BJDebugMsg("leave");})
			.onMouseClick(function() {BJDebugMsg("click");})
			.exLeftDown(function(integer frame) {BJDebugMsg("leftDown");})
			.exLeftUp(function(integer frame) {BJDebugMsg("leftUp");});
	}

	function TTestUTUIExtendEvent2 (player p) {
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
	function TTestUTUIExtendEvent3 (player p) {
		if (btn.isExist()) {
			btn.destroy();
			BJDebugMsg("删除了,方便测试离开事件:"+I2S(btn.ui));
		}
	}
	function TTestUTUIExtendEvent4 (player p) {}
	function TTestUTUIExtendEvent5 (player p) {}
	function TTestUTUIExtendEvent6 (player p) {}
	function TTestUTUIExtendEvent7 (player p) {}
	function TTestUTUIExtendEvent8 (player p) {}
	function TTestUTUIExtendEvent9 (player p) {}
	function TTestUTUIExtendEvent10 (player p) {}
	function TTestActUTUIExtendEvent1 (string str) {
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
			BJDebugMsg("[UIExtendEvent] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIExtendEvent1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIExtendEvent1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIExtendEvent2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIExtendEvent3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIExtendEvent4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIExtendEvent5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIExtendEvent6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIExtendEvent7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIExtendEvent8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIExtendEvent9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIExtendEvent10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
