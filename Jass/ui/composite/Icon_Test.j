#ifndef UTIconIncluded
#define UTIconIncluded

/*===========================================================================
* Icon组件单元测试
*
* 功能说明:
* - 测试Icon组件的基本功能
* - 包括创建、显示、角落文字、流光效果、暗遮罩等
* - 提供交互式的测试命令
*
* 测试指令:
* s1 - 创建/销毁基础图标
*  s1a - 从现有UI创建图标
* s2 - 更新角落文字
* s3 - 开启/关闭流光效果
* s4 - 开启/关闭暗遮罩
* s5 - 测试点击事件
* s6 - 测试CD显示(10秒)
* s7 - 显示/隐藏图标
* s8 - 开启自动尺寸
* -destroy - 销毁图标
* -size(x,y) - 设置图标大小,如: -size 0.04 0.04
*
* 使用方法:
* 1. 首先使用s1创建基础图标
* 2. 然后可以使用其他指令测试各项功能
* 3. 完成后使用s1或-destroy销毁图标
*===========================================================================*/

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTIcon requires Icon {

	private icon testIcon1 = 0;
	private boolean isTest1Active = false;
	private boolean isTest3Active = false;
	private boolean isTest4Active = false;
	private boolean isTest7Active = false;

	// 基础图标创建和显示测试
	function TTestUTIcon1 (player p) {
		if (!isTest1Active) {
			testIcon1 = icon.create(DzGetGameUI())
				.setSize(0.07, 0.07) //这
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp")
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0)
				.show(true);

			BJDebugMsg("基础图标已创建 - 输入s1可关闭");
			isTest1Active = true;
		} else {
			testIcon1.destroy();
			testIcon1 = 0;
			isTest1Active = false;
			BJDebugMsg("基础图标已关闭");
		}
	}

	// 添加新的测试函数
	function TTestUTIcon1a (player p) {
		uiImage img = 0;
		if (!isTest1Active) {
			// 从现有UI创建icon
			testIcon1 = icon.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2))
				.setSize(0.08,0.08)
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
				.setTexture("ReplaceableTextures\\CommandButtons\\BTNSorceress.blp");

			isTest1Active = true;
			BJDebugMsg("已从现有UI创建图标 - 输入s1a可关闭");
		} else {
			testIcon1.destroy();
			testIcon1 = 0;
			isTest1Active = false;
			BJDebugMsg("从现有UI创建的图标已关闭");
		}
	}

	// 角落文字测试
	function TTestUTIcon2 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}
		testIcon1.setCornerText(I2S(GetRandomInt(1, 99)));
		testIcon1.showCornerText(true);
		BJDebugMsg("已更新角落文字 - 再次输入s2随机新数字");
	}

	// 流光效果测试
	function TTestUTIcon3 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		if (!isTest3Active) {
			testIcon1.grow(DzGetGameUI(), growdata[ICONGROW_2]);
			isTest3Active = true;
			BJDebugMsg("流光效果已开启 - 输入s3可关闭");
		} else {
			testIcon1.unGrow();
			isTest3Active = false;
			BJDebugMsg("流光效果已关闭");
		}
	}

	// 暗遮罩测试
	function TTestUTIcon4 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		if (!isTest4Active) {
			testIcon1.setShadow(true);
			isTest4Active = true;
			BJDebugMsg("暗遮罩已开启 - 输入s4可关闭");
		} else {
			testIcon1.setShadow(false);
			isTest4Active = false;
			BJDebugMsg("暗遮罩已关闭");
		}
	}

	// 点击事件测试
	function TTestUTIcon5 (player p) {
		uiBtn btn;
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		btn = testIcon1.getClickBtn()
			.spEnter(function(integer frame) {
				integer data = uiHashTable(frame).eventdata.get();
				BJDebugMsg("enter:"+I2S(data));
			})
			.spLeave(function(integer frame) {
				integer data = uiHashTable(frame).eventdata.get();
				BJDebugMsg("leave:"+I2S(data));
			})
			.spClick(function(integer frame) {
				integer data = uiHashTable(frame).eventdata.get();
				BJDebugMsg("click:"+I2S(data));
			})
			.spRightClick(function(integer frame) {
				integer data = uiHashTable(frame).eventdata.get();
				BJDebugMsg("RightClick:"+I2S(data));
			});
		uiHashTable(btn.ui).eventdata.bind(8174);
		BJDebugMsg("事件已绑定 - 请点击图标测试");
	}

	// CD显示测试
	function TTestUTIcon6 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		testIcon1.startCooldown(10.0,0);
		BJDebugMsg("CD显示已开始 - 持续10秒");
	}

	// 显示/隐藏测试(both生效)
	function TTestUTIcon7 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		if (!isTest7Active) {
			testIcon1.show(false);
			isTest7Active = true;
			BJDebugMsg("图标已隐藏 - 输入s7可显示");
		} else {
			testIcon1.show(true);
			isTest7Active = false;
			BJDebugMsg("图标已显示");
		}
	}

	// 大小调整测试(both生效)
	function TTestUTIcon8 (player p) {
		if (!testIcon1.isExist()) {
			BJDebugMsg("请先使用s1创建基础图标");
			return;
		}

		testIcon1.enableResize();
		BJDebugMsg("大小调整已开启");
	}

	function TTestUTIcon9 (player p) {}
	function TTestUTIcon10 (player p) {}
	function TTestActUTIcon1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R

		// 处理destroy命令
		if (str == "destroy") {
			if (testIcon1.isExist()) {
				testIcon1.destroy();
				testIcon1 = 0;
				isTest1Active = false;
				BJDebugMsg("图标已销毁");
			} else {
				BJDebugMsg("没有可销毁的图标");
			}
			p = null;
			return;
		}

		// 解析参数
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

		// 处理size命令
		if (paramS[0] == "size") {
			if (!testIcon1.isExist()) {
				BJDebugMsg("请先使用s1创建基础图标");
				p = null;
				return;
			}

			if (num < 3) {
				BJDebugMsg("参数不足,请使用格式: -size x y");
				BJDebugMsg("例如: -size 0.04 0.04");
				p = null;
				return;
			}

			testIcon1.setSize(paramR[1], paramR[2]);
			BJDebugMsg("图标大小已设置为: " + R2S(paramR[1]) + " x " + R2S(paramR[2]));
			p = null;
			return;
		}

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
			BJDebugMsg("[Icon] 单元测试已加载");
			BJDebugMsg("测试指令:");
			BJDebugMsg("s1 - 创建/销毁基础图标");
			BJDebugMsg(" s1a - 从现有UI创建图标");
			BJDebugMsg("s2 - 更新角落文字");
			BJDebugMsg("s3 - 开启/关闭流光效果");
			BJDebugMsg("s4 - 开启/关闭暗遮罩");
			BJDebugMsg("s5 - 测试点击事件");
			BJDebugMsg("s6 - 测试CD显示(10秒)");
			BJDebugMsg("s7 - 显示/隐藏图标");
			BJDebugMsg("s8 - 开启自动尺寸");
			BJDebugMsg("-destroy - 销毁图标");
			BJDebugMsg("-size(x,y) - 设置图标大小,如: -size 0.04 0.04");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTIcon1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTIcon1(GetTriggerPlayer());
			else if(str == "s1a") TTestUTIcon1a(GetTriggerPlayer());
			else if(str == "s2") TTestUTIcon2(GetTriggerPlayer());
			else if(str == "s3") TTestUTIcon3(GetTriggerPlayer());
			else if(str == "s4") TTestUTIcon4(GetTriggerPlayer());
			else if(str == "s5") TTestUTIcon5(GetTriggerPlayer());
			else if(str == "s6") TTestUTIcon6(GetTriggerPlayer());
			else if(str == "s7") TTestUTIcon7(GetTriggerPlayer());
			else if(str == "s8") TTestUTIcon8(GetTriggerPlayer());
			else if(str == "s9") TTestUTIcon9(GetTriggerPlayer());
			else if(str == "s10") TTestUTIcon10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
