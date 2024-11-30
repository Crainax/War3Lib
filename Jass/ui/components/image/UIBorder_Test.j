#ifndef UTUIBorderIncluded
#define UTUIBorderIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIBorder requires UIBorder {

	uiBorder currentBorder = 0;

	function TTestUTUIBorder1 (player p) {
		if (GetLocalPlayer() == p) {
			currentBorder = uiBorder.create(DzGetGameUI())
				.setSize(0.2, 0.05)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0);
			BJDebugMsg("创建了一个基础边框UI");
		}
	}
	function TTestUTUIBorder2 (player p) {}
	function TTestUTUIBorder3 (player p) {}
	function TTestUTUIBorder4 (player p) {}
	function TTestUTUIBorder5 (player p) {}
	function TTestUTUIBorder6 (player p) {}
	function TTestUTUIBorder7 (player p) {}
	function TTestUTUIBorder8 (player p) {}
	function TTestUTUIBorder9 (player p) {}
	function TTestUTUIBorder10 (player p) {}
	function TTestActUTUIBorder1 (string str) {
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

		if (paramS[0] == "size") {
			currentBorder.setSize(paramR[1], paramR[2]);
		} else if (paramS[0] == "point") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIBorder] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIBorder1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIBorder1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIBorder2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIBorder3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIBorder4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIBorder5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIBorder6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIBorder7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIBorder8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIBorder9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIBorder10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
