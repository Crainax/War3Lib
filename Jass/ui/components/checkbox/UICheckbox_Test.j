#ifndef UTUICheckboxIncluded
#define UTUICheckboxIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
复选框组件单元测试
测试命令:
s1 - 创建复选框(Checkbox)
s2 - 创建单选框(Radio)
*/

library UTUICheckbox requires UICheckbox {

	uiCheckbox uiCheckboxTest = 0;

	function TTestUTUICheckbox1 (player p) {
		if (GetLocalPlayer() != p) {return;}
		if (uiCheckboxTest != null) {uiCheckboxTest.destroy();}
		uiCheckboxTest = uiCheckbox.create(DzGetGameUI())
			.onChecked(function () {
				BJDebugMsg("复选框: 选中状态");})
			.onUnchecked(function () {
				BJDebugMsg("复选框: 取消选中");})
			.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0.0,0.0);
		BJDebugMsg("创建了复选框。");
	}
	function TTestUTUICheckbox2 (player p) {
		if (GetLocalPlayer() != p) {return;}
		if (uiCheckboxTest != null) {uiCheckboxTest.destroy();}
		uiCheckboxTest = uiCheckbox.createR(DzGetGameUI())
			.onChecked(function () {
				BJDebugMsg("单选框: 选中状态");})
			.onUnchecked(function () {
				BJDebugMsg("单选框: 取消选中");})
			.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0.0,0.0);
		BJDebugMsg("创建了单选框。");
	}
	function TTestUTUICheckbox3 (player p) {}
	function TTestUTUICheckbox4 (player p) {}
	function TTestUTUICheckbox5 (player p) {}
	function TTestUTUICheckbox6 (player p) {}
	function TTestUTUICheckbox7 (player p) {}
	function TTestUTUICheckbox8 (player p) {}
	function TTestUTUICheckbox9 (player p) {}
	function TTestUTUICheckbox10 (player p) {}
	function TTestActUTUICheckbox1 (string str) {
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
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("----------复选框组件测试----------");
			BJDebugMsg("s1 - 创建复选框(Checkbox)");
			BJDebugMsg("s2 - 创建单选框(Radio)");
			BJDebugMsg("点击可切换选中状态");
			BJDebugMsg("--------------------------------");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUICheckbox1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUICheckbox1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUICheckbox2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUICheckbox3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUICheckbox4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUICheckbox5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUICheckbox6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUICheckbox7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUICheckbox8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUICheckbox9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUICheckbox10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
