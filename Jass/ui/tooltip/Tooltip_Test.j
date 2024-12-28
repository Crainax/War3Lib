#ifndef UTTooltipIncluded
#define UTTooltipIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTTooltip requires Tooltip {

	function Init () {
		UnitTestAutoTimer(1.0, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(1.0, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//tooltip.create
		},null);
	}

	tooltip ts = 0;
	function TTestUTTooltip1 (player p) {
		if (ts != 0) {
			ts.destroy();ts = 0;
		} else {
			ts = tooltip.create()
				.layoutTitle("测试1")
				.setAbsPoint(ANCHOR_CENTER,0.4,0.3);
		}
	}
	function TTestUTTooltip2 (player p) {
		if (ts != 0) {
			ts.destroy();ts = 0;
		} else {
			ts = tooltip.create()
				.layoutTitleDesc("测试标题","测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描\n测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述")
				.setAbsPoint(ANCHOR_BOTTOM,0.4,0.3);
		}
	}
	function TTestUTTooltip3 (player p) {}
	function TTestUTTooltip4 (player p) {}
	function TTestUTTooltip5 (player p) {}
	function TTestUTTooltip6 (player p) {}
	function TTestUTTooltip7 (player p) {}
	function TTestUTTooltip8 (player p) {}
	function TTestUTTooltip9 (player p) {}
	function TTestUTTooltip10 (player p) {}
	function TTestActUTTooltip1 (string str) {
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

		if (paramS[0] == "width") {
			if (ts != 0 && num >= 2) {
				ts.setWidth(paramR[1]);
			}
		} else if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Tooltip] 单元测试已加载");
			BJDebugMsg("输入 s1/s2 创建提示框, -width number 设置宽度");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTTooltip1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTTooltip1(GetTriggerPlayer());
			else if(str == "s2") TTestUTTooltip2(GetTriggerPlayer());
			else if(str == "s3") TTestUTTooltip3(GetTriggerPlayer());
			else if(str == "s4") TTestUTTooltip4(GetTriggerPlayer());
			else if(str == "s5") TTestUTTooltip5(GetTriggerPlayer());
			else if(str == "s6") TTestUTTooltip6(GetTriggerPlayer());
			else if(str == "s7") TTestUTTooltip7(GetTriggerPlayer());
			else if(str == "s8") TTestUTTooltip8(GetTriggerPlayer());
			else if(str == "s9") TTestUTTooltip9(GetTriggerPlayer());
			else if(str == "s10") TTestUTTooltip10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
