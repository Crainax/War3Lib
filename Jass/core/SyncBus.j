#ifndef SyncBusIncluded
#define SyncBusIncluded

//! zinc
/*
同步总线
*/

#define SWITCH_SYNCBUS_LOG 1  //打开日志
#define SWITCH_SYNCBUS_OOS_DETECH  //打开OOS探测日志

library SyncBus {

	public struct syncBus [] {
		private static trigger busTr = null;
		private static boolean initialized = false;

		// 路由注册
		private static integer regCount = 0;
		private static string  regTags[];
		private static trigger regTrig[];
		// 防抖：每个已注册路由的剩余冷却时间（tick）
		private static integer debounceRemain[];


		#ifdef SWITCH_SYNCBUS_OOS_DETECH
		// ===== OOS 探测 =====
		private static integer oosLocalRand = 0;              // 本地每5秒滚动随机值
		private static integer oosRecvValue[];                // 按玩家(1-based ConvertedID)记录最近一次收到的值
		private static boolean oosPlayerNotified[];           // 记录已对某玩家广播过“与其他玩家不同步”提示
		private static integer oosTick = 0;                   // 5秒定时器计数器
		#endif

		// 回调上下文（避免哈希表冲突）
		public static player cbPlayer = null;
		public static string cbTag = "";
		public static string cbPayload = "";

		private static method findTagIndex(string tag) -> integer {
			integer i;
			for (i = 0; i < thistype.regCount; i += 1) {
				if (thistype.regTags[i] == tag) { return i; }
			}
			return -1;
		}

		private static method getOrCreateTagTrigger(string tag) -> trigger {
			integer idx; trigger t;
			idx = thistype.findTagIndex(tag);
			if (idx >= 0) { return thistype.regTrig[idx]; }
			t = CreateTrigger();
			thistype.regTags[thistype.regCount] = tag;
			thistype.regTrig[thistype.regCount] = t;
			thistype.regCount += 1;
			return t;
		}

		private static method findChar(string s, string ch) -> integer {
			integer i; integer len; string c;
			len = StringLength(s);
			for (i = 1; i <= len; i += 1) {
				c = SubStringBJ(s, i, i);
				if (c == ch) { return i; }
			}
			c = null;
			return 0;
		}

		// 统一发送（单通道 OData）
		public static method DzSyncDataEx(string tag, string payload) {
			string out; player lp; integer lpid; string lname;
			out = tag + "|" + payload;
			DzSyncData("OD", out);
			#if SWITCH_SYNCBUS_LOG
			lp = GetLocalPlayer();
			lpid = GetConvertedPlayerId(lp);
			lname = GetPlayerName(lp);
			DzWriteLog("[SyncBus] 发送: tag=" + tag + ", payload=" + payload + ", local=" + lname + "(" + I2S(lpid) + ")");
			#endif
			out = null; lp = null; lname = null;
		}

		// 防抖发送：相同功能接口，基于每路由冷却（tick）
		public static method DzSyncDataExDebounce(string tag, string payload, integer cooldownTicks) -> boolean {
			integer idx;
			// 确保路由索引存在
			idx = thistype.findTagIndex(tag);
			if (idx < 0) {
				thistype.getOrCreateTagTrigger(tag);
				idx = thistype.findTagIndex(tag);
			}
			// 若仍找不到，放弃（极端情况）
			if (idx < 0) { return false; }
			// 冷却中则不发送
			if (thistype.debounceRemain[idx] > 0) { return false; }
			// 发送并设置冷却
			thistype.DzSyncDataEx(tag, payload);
			thistype.debounceRemain[idx] = cooldownTicks;
			return true;
		}

		// 注册路由回调
		public static method onDataSync(string tag, code cb) {
			trigger t;
			if (!thistype.initialized) { thistype.onInit(); }
			t = thistype.getOrCreateTagTrigger(tag);
			TriggerAddCondition(t, Condition(cb));
			t = null;
		}

		// 总线初始化：唯一 OD 触发器
		static method onInit() {
			if (thistype.initialized) { return; }
			thistype.initialized = true;

			thistype.busTr = CreateTrigger();
			DzTriggerRegisterSyncData(thistype.busTr, "OD", false);
			TriggerAddAction(thistype.busTr, function () {
				string s; player p; integer pos; string tag; string payload;
				integer idx; trigger tg; string pName; integer pid; string status;

				s = DzGetTriggerSyncData();
				p = DzGetTriggerSyncPlayer();
				pos = thistype.findChar(s, "|");

				if (pos > 0) {
					tag = SubStringBJ(s, 1, pos - 1);
					payload = SubStringBJ(s, pos + 1, StringLength(s));

					// 设置回调上下文
					thistype.cbPlayer = p;
					thistype.cbTag = tag;
					thistype.cbPayload = payload;

					// 派发
					idx = thistype.findTagIndex(tag);
					if (idx >= 0) {
						tg = thistype.regTrig[idx];
						TriggerEvaluate(tg);
					}

					#if SWITCH_SYNCBUS_LOG
					pName = GetPlayerName(p);
					pid = GetConvertedPlayerId(p);
					if (idx >= 0) { status = "ok"; } else { status = "miss"; }
					DzWriteLog("[SyncBus] 接收: player=" + pName + "(" + I2S(pid) + "), raw=" + s + ", tag=" + tag + ", payload=" + payload + ", dispatch=" + status);
					#endif

					// 清理上下文
					thistype.cbPlayer = null;
					thistype.cbTag = "";
					thistype.cbPayload = "";
				} else {
					#if SWITCH_SYNCBUS_LOG
					pName = GetPlayerName(p);
					pid = GetConvertedPlayerId(p);
					DzWriteLog("[SyncBus] 接收: player=" + pName + "(" + I2S(pid) + "), raw=" + s + ", error=no '|'" );
					#endif
				}

				tg = null; tag = null; payload = null; s = null; p = null; pName = null; status = null;
			});

			// 全局tick：用于防抖冷却
			TimerStart(CreateTimer(),0.05,true,function (){
				integer i;
				for (i = 0; i < thistype.regCount; i += 1) {
					if (thistype.debounceRemain[i] > 0) {
						thistype.debounceRemain[i] -= 1;
					}
				}
			});

			#ifdef SWITCH_SYNCBUS_OOS_DETECH
			// 每5秒刷新本地随机值，每12次（60秒）进行OOS检查和发送
			TimerStart(CreateTimer(),5.0,true,function (){
				integer i; integer j; integer vi; integer vj; integer diffCount; integer sameCount; player pi; player pj;  string msg;

				// 更新本地随机值
				thistype.oosLocalRand = GetRandomInt(1,100000);
				DzWriteLog("[OOS] 本地5s随机值更新: "+ I2S(thistype.oosLocalRand));

				// 计数器+1
				thistype.oosTick += 1;

				// 每12次（60秒）执行一次检查和发送
				if (thistype.oosTick >= 12) {
					thistype.oosTick = 0;

					// 改为"按玩家为单位"的提示：只对"少数派"玩家（与众数不同的玩家）显示提示
					// 逻辑：对于每个玩家，统计"相同值玩家数"和"不同值玩家数"
					// 如果"不同值玩家数" > "相同值玩家数"，说明该玩家是少数派，应该提示
					for (i = 1; i <= MAX_PLAYER_COUNT; i += 1) {
						// 只处理在线玩家
						if (GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER) {
							vi = thistype.oosRecvValue[i];
							if (vi != 0 && !thistype.oosPlayerNotified[i]) {
								diffCount = 0;  // 与玩家 i 值不同的玩家数
								sameCount = 0;  // 与玩家 i 值相同的其他玩家数（不包括自己）
								for (j = 1; j <= MAX_PLAYER_COUNT; j += 1) {
									if (j != i && GetPlayerSlotState(ConvertedPlayer(j)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(ConvertedPlayer(j)) == MAP_CONTROL_USER) {
										vj = thistype.oosRecvValue[j];
										if (vj != 0) {
											if (vj == vi) {
												sameCount += 1;
											} else {
												diffCount += 1;
											}
										}
									}
								}
								// 如果"不同值玩家数" > "相同值玩家数"，说明该玩家是少数派，应该提示
								if (diffCount > sameCount) {
									pi = ConvertedPlayer(i);
									msg = GetPlayerName(pi) + "和其他几位玩家之间数据|cffff0000不同步|r,可能是断线重连,游戏崩溃,或者游戏异步,请确认网络状态.";
									BJDebugMsg(msg);
									BJDebugMsg(msg);
									BJDebugMsg(msg);
									BJDebugMsg("|cffff0000[tips]|r如果该玩家确认是异步,任务管理器关掉魔兽,然后重连可以回到正常游戏中.");
									BJDebugMsg("|cffff0000[tips]|r其他玩家目前数据是同步的,请放心游戏.");
									DzWriteLog("[OOS] " + msg + " (pid=" + I2S(i) + ", v=" + I2S(vi) + ", same=" + I2S(sameCount) + ", diff=" + I2S(diffCount) + ")");
									thistype.oosPlayerNotified[i] = true;
									pi = null; msg = null;
								}
							}
						}
					}

					// 发送本地值（路由: OOS）
					thistype.DzSyncDataEx("OOS", I2S(thistype.oosLocalRand));
				}
			});

			// 注册 OOS 接收路由
			thistype.onDataSync("OOS", function () -> boolean {
				player p; integer pid; string payload;
				p = thistype.getPlayer();
				pid = GetConvertedPlayerId(p);
				payload = thistype.getPayload();
				thistype.oosRecvValue[pid] = S2I(payload);
				DzWriteLog("[OOS] 收到玩家(" + I2S(pid) + ") 值=" + payload);
				p = null; payload = null;
				return true;
			});

			#endif

		}

		// 回调内读取上下文
		public static method getPlayer() -> player { return thistype.cbPlayer; }
		public static method getTag() -> string { return thistype.cbTag; }
		public static method getPayload() -> string { return thistype.cbPayload; }
	}

}

//! endzinc
#endif
