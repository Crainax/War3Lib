#ifndef UTMuseumIncluded
#define UTMuseumIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMuseum requires Museum,Keyboard {

	private boolean utMuseumOpen = false; // F2 开关状态

	// 初始化若干测试用的图鉴 Tab
	function InitTabs() {
		museumData md1; museumData md2;

		// 测试图鉴 A
		md1 = museumData.registerAlbum("测试图鉴A");
		md1.registerClick(function () -> boolean {
			museumData cur;
			cur = museumData.getCallbackData();
			BJDebugMsg("[Museum] 打开: " + cur.name);
			return true;
		});
		md1.registerClose(function () -> boolean {
			museumData cur;
			cur = museumData.getCallbackData();
			BJDebugMsg("[Museum] 关闭: " + cur.name);
			return true;
		});

		// 测试图鉴 B
		md2 = museumData.registerAlbum("测试图鉴B");
		md2.registerClick(function () -> boolean {
			museumData cur;
			cur = museumData.getCallbackData();
			BJDebugMsg("[Museum] 打开: " + cur.name);
			return true;
		});
		md2.registerClose(function () -> boolean {
			museumData cur;
			cur = museumData.getCallbackData();
			BJDebugMsg("[Museum] 关闭: " + cur.name);
			return true;
		});
	}

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);

		// 初始化测试用的图鉴 Tab
		InitTabs();
	}

	function TTestUTMuseum1 (player p) {
		// s1：注册 F2 按键，用于切换博物馆 UI 的开启/关闭
		keyboard.regKeyDownEvent(KEY_F2, function (){
			player lp;
			lp = GetLocalPlayer();

			if (!utMuseumOpen) {
				museumUI.show(lp);
				utMuseumOpen = true;
			} else {
				museumUI.hide(lp);
				utMuseumOpen = false;
			}

			lp = null;
		});
	}
	function TTestUTMuseum2 (player p) {
		// 保留空实现（原来用于 s2：关闭），现在主要通过 F2 切换
	}
	function TTestUTMuseum3 (player p) {}
	function TTestUTMuseum4 (player p) {}
	function TTestUTMuseum5 (player p) {}
	function TTestUTMuseum6 (player p) {}
	function TTestUTMuseum7 (player p) {}
	function TTestUTMuseum8 (player p) {}
	function TTestUTMuseum9 (player p) {}
	function TTestUTMuseum10 (player p) {}
	function TTestActUTMuseum1 (string str) {
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
			BJDebugMsg("[Museum] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMuseum1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMuseum1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMuseum2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMuseum3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMuseum4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMuseum5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMuseum6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMuseum7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMuseum8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMuseum9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMuseum10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
