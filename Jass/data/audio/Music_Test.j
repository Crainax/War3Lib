#ifndef UTMusicIncluded
#define UTMusicIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTMusic requires Music {

	private hashtable udg_hash = InitHashtable();

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start
			}, function() {
			//end
		});
		UnitTestAutoTimer(bj_PI, 2.0, function() {
			//assert.Boolean(true, "测试1");
			//music[1001]
			//music[13]
		},null);
		// YDUserDataSet(itemcode, 'esaz', "LL", integer, 23000);
	}

	// 测试1：旧方法（有内存泄露）- 在同一位置快速播放10次
	function TTestUTMusic1 (player p) {
	}

	// 测试2：新方法 - 使用堆叠音效在同一位置快速播放10次
	function TTestUTMusic2 (player p) {
		integer i;
		real x = 0.0;
		real y = 0.0;

		BJDebugMsg("=== 测试2：新方法 playXYStacked - 同一位置快速播放10次 ===");
		for (1 <= i <= 10) {
			music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", x, y);
		}
		BJDebugMsg("已在(0, 0)播放10次音效（新方法，无内存泄露）");
	}

	// 测试3：新方法 - 在不同位置快速播放
	function TTestUTMusic3 (player p) {
		integer i;
		real x; real y;

		BJDebugMsg("=== 测试3：新方法 - 在圆形路径上播放20次 ===");
		for (1 <= i <= 20) {
			x = 500.0 * Cos(i * 18.0 * bj_DEGTORAD);
			y = 500.0 * Sin(i * 18.0 * bj_DEGTORAD);
			music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", x, y);
		}
		BJDebugMsg("已在圆形路径上播放20次音效");
	}

	// 测试4：压力测试 - 新方法1000次（模拟高频调用）
	function TTestUTMusic4 (player p) {
		timer t; real x; real y; integer count;

		BJDebugMsg("=== 测试4：压力测试 - 每0.01秒播放一次，持续10秒（1000次）===");

		t = CreateTimer();
		count = 0;

		TimerStart(t, 0.01, true, function() {
			timer tt; integer hid; integer cnt; real rx; real ry;

			tt = GetExpiredTimer();
			hid = GetHandleId(tt);
			cnt = LoadInteger(udg_hash, hid, 0);

			if (cnt >= 1000) {
				PauseTimer(tt);
				FlushChildHashtable(udg_hash, hid);
				DestroyTimer(tt);
				BJDebugMsg("压力测试完成：已播放1000次音效");
				tt = null;
				return;
			}

			// 在随机位置播放
			rx = GetRandomReal(-1000.0, 1000.0);
			ry = GetRandomReal(-1000.0, 1000.0);
			music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", rx, ry);

			SaveInteger(udg_hash, hid, 0, cnt + 1);
			tt = null;
		});

		SaveInteger(udg_hash, GetHandleId(t), 0, 0);
		t = null;
	}

	// 测试5：对比测试 - 同时播放vs顺序播放
	function TTestUTMusic5 (player p) {
		BJDebugMsg("=== 测试5：5个音效几乎同时播放（测试堆叠效果）===");
		music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		BJDebugMsg("应该听到5个音效叠加播放的效果");
	}
	//打印内存泄露情况
	function TTestUTMusic6 (player p) {
		MemoryLeakShow();
		//YDLua
	}

	// 测试7：极限堆叠测试 - 瞬间播放30次（超过池大小）
	function TTestUTMusic7 (player p) {
		integer i;

		BJDebugMsg("=== 测试7：极限堆叠测试 - 瞬间播放30次（超过池大小20）===");
		for (1 <= i <= 30) {
			music.playXYStacked("Abilities\\Spells\\Items\\ResourceItems\\BundleOfLumber.wav", 0.0, 0.0);
		}
		BJDebugMsg("已播放30次（池大小只有20，前10次会被打断重用）");
	}
	function TTestUTMusic8 (player p) {}
	function TTestUTMusic9 (player p) {}
	function TTestUTMusic10 (player p) {}
	function TTestActUTMusic1 (string str) {
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
			BJDebugMsg("[Music] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMusic1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMusic1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMusic2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMusic3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMusic4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMusic5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMusic6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMusic7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMusic8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMusic9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMusic10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
