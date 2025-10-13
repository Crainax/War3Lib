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

		// 映射关系：图标文字 (返回选择项的名称)
		sd.reflectName(function () -> boolean {
			string names[];
			names[1] = "瑞雪";
			names[2] = "苍穹";
			names[3] = "青松";
			names[4] = "星河";
			names[5] = "碧波";
			names[6] = "晨曦";
			names[7] = "锦鲤";
			names[8] = "翠竹";
			names[9] = "飞鹤";
			names[10] = "流云";
			names[11] = "赤焰";
			names[12] = "皓月";
			names[13] = "绿藤";
			names[14] = "玉珠";
			names[15] = "青鸟";
			names[16] = "寒梅";
			names[17] = "金虎";
			names[18] = "紫萱";
			names[19] = "丹霞";
			names[20] = "龙凤";
			CallbackSelectContent(names[GetSelectPosAsync()]);
			return true;
		});

		// 映射关系：图标 (返回选择项的图标路径)
		sd.reflectIcon(function () -> boolean {
			string icons[];
			icons[1] = "ReplaceableTextures\\CommandButtons\\BTNReturnGoods.blp";
			icons[2] = "ReplaceableTextures\\PassiveButtons\\PASBTNGnollCommandAura.blp";
			icons[3] = "ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp";
			icons[4] = "ReplaceableTextures\\PassiveButtons\\PASBTNThorns.blp";
			icons[5] = "ReplaceableTextures\\CommandButtons\\BTNAntiMagicShell.blp";
			icons[6] = "ReplaceableTextures\\PassiveButtons\\PASBTNTrueShot.blp";
			icons[7] = "ReplaceableTextures\\PassiveButtons\\PASBTNDevotion.blp";
			icons[8] = "ReplaceableTextures\\PassiveButtons\\PASBTNBrilliance.blp";
			icons[9] = "ReplaceableTextures\\CommandButtons\\BTNBloodLustOn.blp";
			icons[10] = "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp";
			icons[11] = "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp";
			icons[12] = "ReplaceableTextures\\PassiveButtons\\PASBTNBash.blp";
			icons[13] = "ReplaceableTextures\\CommandButtons\\BTNTheBlackArrowOnOff.blp";
			icons[14] = "ReplaceableTextures\\CommandButtons\\BTNBloodLustOn.blp";
			icons[15] = "ReplaceableTextures\\CommandButtons\\BTNBanish.blp";
			icons[16] = "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp";
			icons[17] = "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp";
			icons[18] = "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp";
			icons[19] = "ReplaceableTextures\\CommandButtons\\BTNCarrionSwarm.blp";
			icons[20] = "ReplaceableTextures\\CommandButtons\\BTNFrostBolt.blp";
			CallbackSelectContent(icons[GetSelectPosAsync()]);
			return true;
		});

		// 注册按钮进入事件
		sd.registerEnter(function () -> boolean {
			selectData sd = GetSelectDataAsync();
			integer pos =  GetSelectPosAsync();
			BJDebugMsg("|cFF00FFFF【进入】|r 鼠标进入选择项" + I2S(sd) + " " + I2S(pos));
			return true;
		});

		// 注册按钮离开事件
		sd.registerLeave(function () -> boolean {
			selectData sd = GetSelectDataAsync();
			integer pos =  GetSelectPosAsync();
			BJDebugMsg("|cFF00FFFF【离开】|r 鼠标离开选择项" + I2S(sd) + " " + I2S(pos));
			return true;
		});

		// 注册按钮点击事件
		sd.registerClick(function () -> boolean {
			selectData sd = GetSelectData();
			integer pos =  GetSelectPos();
			BJDebugMsg("|cFFFFFF00【点击】|r 点击了选择项" + I2S(sd) + " " + I2S(pos));
			sd.destroy();
			return true;
		});

		// 注册关闭事件
		sd.registerClose(function () -> boolean {
			GetSelectData().destroy();
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
