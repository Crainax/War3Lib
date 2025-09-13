#ifndef UTMallItemIncluded
#define UTMallItemIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

// 我完善了 MallItem_Test.j 的单元测试：
// 初始化阶段注册 VIP1/RhdeKey/RopgKey，并为 RhdeKey、RopgKey 设置科技 'Rhde'、'Ropg'
// onReady 时打印状态、验证科技解锁（若拥有对应商品）
// 进行次数型消费（带回调）与局数型消费（无回调）
// 提供聊天命令：
// -mi 打印当前玩家的商城状态
// -ct <key> <count> 执行次数型消费并打印回调
// -co <key> 执行一次性消费
// -rf <pid> 刷新某玩家缓存

//自动生成的文件
library UTMallItem requires MallItem {

	function DumpState(player p) {
		integer pid = GetPlayerId(p);
		integer n = mallItem.getItemCount();
		integer i = 1;
		string key ;
		boolean has;
		integer cnt;

		BJDebugMsg("[UTMallItem] DumpState pid=" + I2S(pid) + ", items=" + I2S(n));
		for (1 <= i <= n) {
			key = mallItem.getItemKeyByIndex(i);
			has = mallItem.hasByPlayer(Player(pid), key);
			cnt = mallItem.getUseCountByPlayer(Player(pid), key);
			BJDebugMsg("  - [" + I2S(i) + "] key=" + key + ", has=" + I2S(I3(has,1,0)) + ", cnt=" + I2S(cnt));
		}
	}

	function Init () {
		// 注册测试商品（逐个注册）
		mallItem.init("VIP1");
		mallItem.init("RhdeKey");
		mallItem.init("RopgKey");

		// 配置元信息与科技
		mallItem.setMeta("VIP1", "白金VIP", "ReplaceableTextures\\CommandButtons\\BTN.tga", "尊享特权");
		mallItem.setTech("RhdeKey", 'Rhde');
		mallItem.setTech("RopgKey", 'Ropg');

		// 就绪后校验
		mallItem.onReady(function () -> boolean {
			player p0 = Player(0);
			BJDebugMsg("[UTMallItem] onReady reached");
			DumpState(p0);

			if (mallItem.hasByPlayer(Player(0), "RhdeKey")) {
				BJDebugMsg("  Rhde tech count=" + I2S(GetPlayerTechCount(p0, 'Rhde', true)));
			}
			if (mallItem.hasByPlayer(Player(0), "RopgKey")) {
				BJDebugMsg("  Ropg tech count=" + I2S(GetPlayerTechCount(p0, 'Ropg', true)));
			}

			// 次数型消费（带回调）
			mallItem.consumeTimes(p0, "VIP1", 1, function () -> boolean {
				player cbp = mallItem.getCallbackPlayer();
				BJDebugMsg("[UTMallItem] consumeTimes callback player=" + GetPlayerName(cbp));
				BJDebugMsg("  VIP1 after consume cnt=" + I2S(mallItem.getUseCountByPlayer(Player(0), "VIP1")));
				return true;
			});

			// 局数型消费（无回调）
			mallItem.consumeOnce(p0, "VIP1");

			p0 = null;
			return true;
		});

		// 演示定时器
		UnitTestAutoTimer(0.1, 2.0, function() {
			// start: 0.1 秒后
			}, function() {
			// end: 2.0 秒后
		});
	}

	function TTestUTMallItem1 (player p) {
		// mallItem
	}
	function TTestUTMallItem2 (player p) {}
	function TTestUTMallItem3 (player p) {}
	function TTestUTMallItem4 (player p) {}
	function TTestUTMallItem5 (player p) {}
	function TTestUTMallItem6 (player p) {}
	function TTestUTMallItem7 (player p) {}
	function TTestUTMallItem8 (player p) {}
	function TTestUTMallItem9 (player p) {}
	function TTestUTMallItem10 (player p) {}
	function TTestActUTMallItem1 (string str) {
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

		if (paramS[0] == "mi") {
			DumpState(p);
		} else if (paramS[0] == "ct") {
			// ct <key> <count>
			if (num >= 3) {
				mallItem.consumeTimes(p, paramS[1], paramI[2], function () -> boolean {
					player cbp = mallItem.getCallbackPlayer();
					BJDebugMsg("[UTMallItem] chat consumeTimes cb player=" + GetPlayerName(cbp));
					return true;
				});
			} else {
				BJDebugMsg("usage: -ct <key> <count>");
			}
		} else if (paramS[0] == "co") {
			// co <key>
			if (num >= 2) {
				mallItem.consumeOnce(p, paramS[1]);
				BJDebugMsg("[UTMallItem] chat consumeOnce key=" + paramS[1]);
			} else {
				BJDebugMsg("usage: -co <key>");
			}
		} else if (paramS[0] == "rf") {
			// rf <pid0-based>
			if (num >= 2) {
				mallItem.refreshItemsForPlayer(paramI[1]);
				BJDebugMsg("[UTMallItem] refreshed pid=" + I2S(paramI[1]));
			} else {
				BJDebugMsg("usage: -rf <pid>");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[MallItem] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMallItem1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMallItem1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMallItem2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMallItem3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMallItem4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMallItem5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMallItem6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMallItem7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMallItem8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMallItem9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMallItem10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
