#ifndef UTSelectorIncluded
#define UTSelectorIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSelector requires Selector {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			InitTestUIRuler();
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//selector.create()
		},null);
	}

	function TTestUTSelector1 (player p) {
		selectData sd; selector sel; integer i;

		// 创建selectData，设置5个选择项
		sd = selectData.create(13);
		if (sd == 0) {
			BJDebugMsg("|cFFFF0000【测试】|r selectData创建失败");
			return;
		}

		// 设置标题和按钮文字
		sd.title = "测试选择器";
		sd.btn1Text = "刷新";

		// 映射关系：数据ID (返回选择项的ID)
		sd.reflectData(function () -> boolean {
			integer index = 1;
			BJDebugMsg("|cFF00FF00【数据ID】|r 选择项 " + I2S(index) + " 的数据ID: " + I2S(index * 100));
			return true;
		});

		// 映射关系：图标文字 (返回选择项的名称)
		sd.reflectName(function () -> boolean {
			integer index = 1;
			string names[];
			names[0] = "武器";
			names[1] = "护甲";
			names[2] = "饰品";
			names[3] = "消耗品";
			names[4] = "材料";
			if (index >= 1 && index <= 5) {
				BJDebugMsg("|cFF00FF00【图标文字】|r 选择项 " + I2S(index) + " 的名称: " + names[index - 1]);
			}
			return true;
		});

		// 映射关系：图标 (返回选择项的图标路径)
		sd.reflectIcon(function () -> boolean {
			integer index = 1;
			string icons[];
			icons[0] = "ReplaceableTextures\\CommandButtons\\BTNReturnGoods.blp";
			icons[1] = "ReplaceableTextures\\PassiveButtons\\PASBTNGnollCommandAura.blp";
			icons[2] = "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp";
			icons[3] = "ReplaceableTextures\\PassiveButtons\\PASBTNThorns.blp";
			icons[4] = "ReplaceableTextures\\CommandButtons\\BTNAntiMagicShell.blp";
			if (index >= 1 && index <= 5) {
				BJDebugMsg("|cFF00FF00【图标】|r 选择项 " + I2S(index) + " 的图标: " + icons[index - 1]);
			}
			return true;
		});

		// 注册按钮进入事件
		sd.registerEnter(function () -> boolean {
			BJDebugMsg("|cFF00FFFF【进入】|r 鼠标进入选择项");
			return true;
		});

		// 注册按钮离开事件
		sd.registerLeave(function () -> boolean {
			BJDebugMsg("|cFF00FFFF【离开】|r 鼠标离开选择项");
			return true;
		});

		// 注册按钮点击事件
		sd.registerClick(function () -> boolean {
			BJDebugMsg("|cFFFFFF00【点击】|r 点击了选择项");
			return true;
		});

		// 注册关闭事件
		sd.registerClose(function () -> boolean {
			GetCurrentSelectData().destroy();
			return true;
		});

		// 注册按钮1事件
		sd.registerBtn1(function () -> boolean {
			BJDebugMsg("|cFF00FF00【刷新】|r 点击了刷新按钮");
			return true;
		});

		// 创建selector实例
		sel = selector.create(p, sd);

		BJDebugMsg("|cFF00FF00【测试】|r 选择器创建成功！");
		BJDebugMsg("|cFF00FF00【测试】|r 玩家: " + GetPlayerName(p));
		BJDebugMsg("|cFF00FF00【测试】|r 选择项数量: 5");

		// 清理局部变量
		p = null;
	}
	function TTestUTSelector2 (player p) {}
	function TTestUTSelector3 (player p) {}
	function TTestUTSelector4 (player p) {}
	function TTestUTSelector5 (player p) {}
	function TTestUTSelector6 (player p) {}
	function TTestUTSelector7 (player p) {}
	function TTestUTSelector8 (player p) {}
	function TTestUTSelector9 (player p) {}
	function TTestUTSelector10 (player p) {}
	function TTestActUTSelector1 (string str) {
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
			BJDebugMsg("[Selector] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSelector1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSelector1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSelector2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSelector3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSelector4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSelector5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSelector6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSelector7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSelector8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSelector9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSelector10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
