#ifndef UTMouseMenuIncluded
#define UTMouseMenuIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMouseMenu requires MouseMenu {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//menuItem.create
		},null);
	}

	mouseMenu menu = 0;
	function TTestUTMouseMenu1 (player p) {
		menu = mouseMenu.create(DzGetGameUI(),true,0.1);
		menu.onEnter(function(integer index) {
			BJDebugMsg("[进入事件] "+I2S(index));
		});
		menu.onClick(function(integer index) {
			BJDebugMsg("[点击事件] "+I2S(index));
		});
		menu.onLeave(function(integer index) {
			BJDebugMsg("[离开事件] "+I2S(index));
		});
		menu.AddMenuItem("测试1");
		menu.AddMenuItem("测试2");
		menu.AddMenuItem("测试3");
		menu.AddMenuItem("测试4");
		menu.AddMenuItem("测试5");
		menu.menuFrame.setAbsPoint(ANCHOR_CENTER,0.4,0.3);
		menu.show(true);


	}
	function TTestUTMouseMenu2 (player p) {}
	function TTestUTMouseMenu3 (player p) {}
	function TTestUTMouseMenu4 (player p) {}
	function TTestUTMouseMenu5 (player p) {}
	function TTestUTMouseMenu6 (player p) {}
	function TTestUTMouseMenu7 (player p) {}
	function TTestUTMouseMenu8 (player p) {}
	function TTestUTMouseMenu9 (player p) {}
	function TTestUTMouseMenu10 (player p) {}
	function TTestActUTMouseMenu1 (string str) {
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
			BJDebugMsg("[MouseMenu] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMouseMenu1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMouseMenu1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMouseMenu2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMouseMenu3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMouseMenu4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMouseMenu5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMouseMenu6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMouseMenu7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMouseMenu8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMouseMenu9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMouseMenu10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
