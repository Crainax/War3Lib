#ifndef SyncBusIncluded
#define SyncBusIncluded

//! zinc
/*
同步总线
*/

#define SWITCH_SYNCBUS_LOG 0  //打开日志

#define SYNC_BUS_TICK_SECONDS 0.05
#define SYNC_BUS_LATER_MIN_TICKS 3
#define SYNC_BUS_ENVELOPE_PREFIX "@SB1,"
#define SYNC_BUS_LATER_QUEUE_MAX 8000

#define SYNC_BUS_OOS_MODE_OFF 0       //关闭OOS探针：不消耗随机数，不注册OOS异步检测
#define SYNC_BUS_OOS_MODE_CLASSIC 1   //旧探针：5秒采样，12次一查
#define SYNC_BUS_OOS_MODE_FINE 2      //细粒度探针：0.25秒采样，调试专用，可能放大随机序列差异
#define SYNC_BUS_OOS_MODE SYNC_BUS_OOS_MODE_CLASSIC

#if (SYNC_BUS_OOS_MODE == SYNC_BUS_OOS_MODE_CLASSIC)
#define SYNC_BUS_OOS_SAMPLE_SECONDS 5.0
#define SYNC_BUS_OOS_CHECK_DELAY_SECONDS 0.30
#define SYNC_BUS_OOS_CHECK_INTERVAL 12
#define SYNC_BUS_OOS_SEND_EACH_SAMPLE 0
#define SWITCH_SYNCBUS_OOS_DETECH
#endif

#if (SYNC_BUS_OOS_MODE == SYNC_BUS_OOS_MODE_FINE)
#define SYNC_BUS_OOS_SAMPLE_SECONDS 0.25
#define SYNC_BUS_OOS_CHECK_DELAY_SECONDS 0.30
#define SYNC_BUS_OOS_CHECK_INTERVAL 1
#define SYNC_BUS_OOS_SEND_EACH_SAMPLE 1
#define SWITCH_SYNCBUS_OOS_DETECH
#endif

library SyncBus requires Logger {

	public struct syncBus [] {
		private static trigger busTr = null;
		private static boolean initialized = false;

		// 路由注册
		private static integer regCount = 0;
		private static string  regTags[];
		private static trigger regTrig[];
		private static trigger regLaterTrig[];
		// 防抖：每个已注册路由的剩余冷却时间（tick）
		private static integer debounceRemain[];

		// 延迟路由：发送时写入统一目标 tick，收包后只进入队列。
		// 所有客户端在同一个 SyncBus tick 按发送者/序号排序派发，避免每个业务文件重复创建 timer。
		private static integer syncTick = 0;
		private static integer localSendSeq = 0;
		private static integer laterCount = 0;
		private static integer laterDueTick[];
		private static integer laterSenderPid[];
		private static integer laterSenderSeq[];
		private static integer laterRouteIndex[];
		private static player laterPlayer[];
		private static string laterTag[];
		private static string laterPayload[];


		#ifdef SWITCH_SYNCBUS_OOS_DETECH
		// ===== OOS 探测 =====
		private static integer oosLocalRand = 0;              // 本地滚动随机值
		private static integer oosSeq = 0;                    // 本地探测轮次
		private static integer oosCheckSeq = 0;               // 当前待检查轮次
		private static integer oosRecvSeq[];                  // 按玩家记录最近一次收到的轮次
		private static integer oosRecvValue[];                // 按玩家(1-based ConvertedID)记录最近一次收到的值
		private static boolean oosPlayerNotified[];           // 记录已对某玩家广播过“与其他玩家不同步”提示
		private static integer oosTick = 0;                   // 探测定时器计数器
		#endif

		// 回调上下文（避免哈希表冲突）
		public static player cbPlayer = null;
		public static string cbTag = "";
		public static string cbPayload = "";
		public static integer cbSequence = 0;

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

		private static method findCharFrom(string s, string ch, integer startPos) -> integer {
			integer i; integer len; string c;
			len = StringLength(s);
			if (startPos < 1) { startPos = 1; }
			for (i = startPos; i <= len; i += 1) {
				c = SubStringBJ(s, i, i);
				if (c == ch) {
					c = null;
					return i;
				}
			}
			c = null;
			return 0;
		}

		private static method dispatchWithContext(trigger tg, player p, string tag, string payload, integer sequence) {
			integer oldSequence;
			player oldPlayer;
			string oldTag;
			string oldPayload;
			if (tg == null) { return; }
			oldPlayer = thistype.cbPlayer;
			oldTag = thistype.cbTag;
			oldPayload = thistype.cbPayload;
			oldSequence = thistype.cbSequence;
			thistype.cbPlayer = p;
			thistype.cbTag = tag;
			thistype.cbPayload = payload;
			thistype.cbSequence = sequence;
			TriggerEvaluate(tg);
			thistype.cbPlayer = oldPlayer;
			thistype.cbTag = oldTag;
			thistype.cbPayload = oldPayload;
			thistype.cbSequence = oldSequence;
			oldPlayer = null;
			oldTag = null;
			oldPayload = null;
		}

		private static method removeLaterAt(integer pos) {
			integer last;
			if (pos < 0 || pos >= thistype.laterCount) { return; }
			last = thistype.laterCount - 1;
			if (pos != last) {
				thistype.laterDueTick[pos] = thistype.laterDueTick[last];
				thistype.laterSenderPid[pos] = thistype.laterSenderPid[last];
				thistype.laterSenderSeq[pos] = thistype.laterSenderSeq[last];
				thistype.laterRouteIndex[pos] = thistype.laterRouteIndex[last];
				thistype.laterPlayer[pos] = thistype.laterPlayer[last];
				thistype.laterTag[pos] = thistype.laterTag[last];
				thistype.laterPayload[pos] = thistype.laterPayload[last];
			}
			thistype.laterDueTick[last] = 0;
			thistype.laterSenderPid[last] = 0;
			thistype.laterSenderSeq[last] = 0;
			thistype.laterRouteIndex[last] = -1;
			thistype.laterPlayer[last] = null;
			thistype.laterTag[last] = "";
			thistype.laterPayload[last] = "";
			thistype.laterCount -= 1;
		}

		private static method enqueueLater(integer routeIndex, player p, string tag, string payload, integer dueTick, integer senderSeq) {
			integer pos;
			if (routeIndex < 0 || routeIndex >= thistype.regCount || thistype.regLaterTrig[routeIndex] == null) { return; }
			if (thistype.laterCount >= SYNC_BUS_LATER_QUEUE_MAX) {
				DzWriteLog("[SyncBusLater] queue overflow tag=" + tag + ", pid=" + I2S(GetConvertedPlayerId(p)) + ", seq=" + I2S(senderSeq));
				return;
			}
			pos = thistype.laterCount;
			thistype.laterDueTick[pos] = dueTick;
			thistype.laterSenderPid[pos] = GetConvertedPlayerId(p);
			thistype.laterSenderSeq[pos] = senderSeq;
			thistype.laterRouteIndex[pos] = routeIndex;
			thistype.laterPlayer[pos] = p;
			thistype.laterTag[pos] = tag;
			thistype.laterPayload[pos] = payload;
			thistype.laterCount += 1;
		}

		private static method findNextReadyLater() -> integer {
			integer i;
			integer best;
			best = -1;
			for (i = 0; i < thistype.laterCount; i += 1) {
				if (thistype.laterDueTick[i] <= thistype.syncTick) {
					if (best < 0 ||
						thistype.laterDueTick[i] < thistype.laterDueTick[best] ||
						(thistype.laterDueTick[i] == thistype.laterDueTick[best] && thistype.laterSenderPid[i] < thistype.laterSenderPid[best]) ||
						(thistype.laterDueTick[i] == thistype.laterDueTick[best] && thistype.laterSenderPid[i] == thistype.laterSenderPid[best] && thistype.laterSenderSeq[i] < thistype.laterSenderSeq[best])) {
						best = i;
					}
				}
			}
			return best;
		}

		private static method flushLater() {
			integer pos;
			integer routeIndex;
			integer senderSeq;
			player p;
			string tag;
			string payload;
			trigger tg;
			pos = thistype.findNextReadyLater();
			while (pos >= 0) {
				routeIndex = thistype.laterRouteIndex[pos];
				p = thistype.laterPlayer[pos];
				tag = thistype.laterTag[pos];
				payload = thistype.laterPayload[pos];
				senderSeq = thistype.laterSenderSeq[pos];
				tg = thistype.regLaterTrig[routeIndex];
				thistype.removeLaterAt(pos);
				thistype.dispatchWithContext(tg, p, tag, payload, senderSeq);
				p = null;
				tag = null;
				payload = null;
				tg = null;
				pos = thistype.findNextReadyLater();
			}
		}

		#ifdef SWITCH_SYNCBUS_OOS_DETECH
		private static method checkOOS() {
			integer i; integer j; integer vi; integer vj; integer diffCount; integer sameCount; player pi; string msg; integer seq;
			seq = thistype.oosCheckSeq;

			// 改为"按玩家为单位"的提示：只对"少数派"玩家（与众数不同的玩家）显示提示
			// 额外记录本轮未收到的玩家，方便缩小 OOS 发生时间窗口。
			for (i = 1; i <= MAX_PLAYER_COUNT; i += 1) {
				if (GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER) {
					if (thistype.oosRecvSeq[i] != seq) {
						DzWriteLog("[OOS] 本轮未收到玩家(" + I2S(i) + ") seq=" + I2S(seq) + ", lastSeq=" + I2S(thistype.oosRecvSeq[i]) + ", lastValue=" + I2S(thistype.oosRecvValue[i]));
					} else if (!thistype.oosPlayerNotified[i]) {
						vi = thistype.oosRecvValue[i];
						diffCount = 0;
						sameCount = 0;
						for (j = 1; j <= MAX_PLAYER_COUNT; j += 1) {
							if (j != i && GetPlayerSlotState(ConvertedPlayer(j)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(ConvertedPlayer(j)) == MAP_CONTROL_USER && thistype.oosRecvSeq[j] == seq) {
								vj = thistype.oosRecvValue[j];
								if (vj == vi) {
									sameCount += 1;
								} else {
									diffCount += 1;
								}
							}
						}
						if (diffCount > sameCount) {
							pi = ConvertedPlayer(i);
							msg = GetPlayerName(pi) + "和其他几位玩家之间数据|cffff0000不同步|r,可能是断线重连,游戏崩溃,或者游戏异步,请确认网络状态.";
							DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, msg);
							BJDebugMsg(msg);
							BJDebugMsg(msg);
							DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cffff0000[tips]|r如果该玩家确认是异步,任务管理器关掉魔兽,然后重连可以回到正常游戏中.");
							DisplayImportantTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "|cffff0000[tips]|r其他玩家目前数据是同步的,请放心游戏.");
							DzWriteLog("[OOS] " + msg + " (pid=" + I2S(i) + ", seq=" + I2S(seq) + ", v=" + I2S(vi) + ", same=" + I2S(sameCount) + ", diff=" + I2S(diffCount) + ")");
							thistype.oosPlayerNotified[i] = true;
							pi = null; msg = null;
						}
					}
				}
			}
		}
		#endif

		// 统一发送（单通道 OData）
		public static method DzSyncDataEx(string tag, string payload) {
			string out; player lp; integer lpid; integer targetTick; string lname;
			if (!thistype.initialized) { thistype.onInit(); }
			thistype.localSendSeq += 1;
			targetTick = thistype.syncTick + SYNC_BUS_LATER_MIN_TICKS;
			out = tag + "|" + SYNC_BUS_ENVELOPE_PREFIX + I2S(targetTick) + "," + I2S(thistype.localSendSeq) + "," + payload;
			DzSyncDataImmediately("OD", out);
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

		// 注册延迟路由回调。回调执行时 getPlayer/getTag/getPayload 与即时路由保持同一接口。
		public static method onDataSyncLater(string tag, code cb) {
			integer idx;
			trigger t;
			if (!thistype.initialized) { thistype.onInit(); }
			thistype.getOrCreateTagTrigger(tag);
			idx = thistype.findTagIndex(tag);
			if (idx < 0) { return; }
			t = thistype.regLaterTrig[idx];
			if (t == null) {
				t = CreateTrigger();
				thistype.regLaterTrig[idx] = t;
			}
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
				string s; player p; integer pos; string tag; string payload; string rawPayload;
				integer idx; integer metaPos1; integer metaPos2; integer metaPos3; integer dueTick; integer senderSeq;
				trigger tg; string pName; integer pid; string status;

				s = DzGetTriggerSyncData();
				p = DzGetTriggerSyncPlayer();
				pos = thistype.findChar(s, "|");

				if (pos > 0) {
					tag = SubStringBJ(s, 1, pos - 1);
					rawPayload = SubStringBJ(s, pos + 1, StringLength(s));
					payload = rawPayload;
					dueTick = thistype.syncTick + SYNC_BUS_LATER_MIN_TICKS;
					senderSeq = 0;
					if (StringLength(rawPayload) >= 6 && SubStringBJ(rawPayload, 1, 5) == SYNC_BUS_ENVELOPE_PREFIX) {
						metaPos1 = thistype.findCharFrom(rawPayload, ",", 1);
						metaPos2 = thistype.findCharFrom(rawPayload, ",", metaPos1 + 1);
						metaPos3 = thistype.findCharFrom(rawPayload, ",", metaPos2 + 1);
						if (metaPos1 > 0 && metaPos2 > metaPos1 && metaPos3 > metaPos2) {
							dueTick = S2I(SubStringBJ(rawPayload, metaPos1 + 1, metaPos2 - 1));
							senderSeq = S2I(SubStringBJ(rawPayload, metaPos2 + 1, metaPos3 - 1));
							payload = SubStringBJ(rawPayload, metaPos3 + 1, StringLength(rawPayload));
						}
					}

					// 派发
					idx = thistype.findTagIndex(tag);
					#if SWITCH_SYNCBUS_LOG
					pName = GetPlayerName(p);
					pid = GetConvertedPlayerId(p);
					if (idx >= 0) { status = "ok"; } else { status = "miss"; }
					DzWriteLog("[SyncBus] recv player=" + pName + "(" + I2S(pid) + "), raw=" + s + ", tag=" + tag + ", payload=" + payload + ", idx=" + I2S(idx) + ", dispatch=" + status);
					#endif
					if (idx >= 0) {
						tg = thistype.regTrig[idx];
						#if SWITCH_SYNCBUS_LOG
						DzWriteLog("[SyncBus] dispatch begin tag=" + tag + ", payload=" + payload + ", player=" + pName + "(" + I2S(pid) + "), idx=" + I2S(idx));
						#endif
						thistype.dispatchWithContext(tg, p, tag, payload, senderSeq);
						#if SWITCH_SYNCBUS_LOG
						DzWriteLog("[SyncBus] dispatch end tag=" + tag + ", payload=" + payload + ", player=" + pName + "(" + I2S(pid) + "), idx=" + I2S(idx));
						#endif
						if (thistype.regLaterTrig[idx] != null) {
							thistype.enqueueLater(idx, p, tag, payload, dueTick, senderSeq);
						}
					}
				} else {
					#if SWITCH_SYNCBUS_LOG
					pName = GetPlayerName(p);
					pid = GetConvertedPlayerId(p);
					DzWriteLog("[SyncBus] 接收: player=" + pName + "(" + I2S(pid) + "), raw=" + s + ", error=no '|'" );
					#endif
				}

				tg = null; tag = null; payload = null; rawPayload = null; s = null; p = null; pName = null; status = null;
			});

			// 全局tick：用于防抖冷却
			TimerStart(CreateTimer(),SYNC_BUS_TICK_SECONDS,true,function (){
				integer i;
				thistype.syncTick += 1;
				for (i = 0; i < thistype.regCount; i += 1) {
					if (thistype.debounceRemain[i] > 0) {
						thistype.debounceRemain[i] -= 1;
					}
				}
				thistype.flushLater();
			});

			#ifdef SWITCH_SYNCBUS_OOS_DETECH
			// 按模式刷新本地随机值，并按轮次发送/检查，方便缩小 OOS 时间窗口。
			TimerStart(CreateTimer(),SYNC_BUS_OOS_SAMPLE_SECONDS,true,function (){

				// 更新本地随机值
				thistype.oosSeq += 1;
				thistype.oosLocalRand = GetRandomInt(1,100000);
				DzWriteLog("[OOS] 本地值更新: seq=" + I2S(thistype.oosSeq) + ", v=" + I2S(thistype.oosLocalRand));

				#if (SYNC_BUS_OOS_SEND_EACH_SAMPLE == 1)
				// 发送本地值（路由: OOS）
				thistype.DzSyncDataEx("OOS", I2S(thistype.oosSeq) + ":" + I2S(thistype.oosLocalRand));
				#endif

				// 计数器+1
				thistype.oosTick += 1;

				// 按配置频率延迟检查，留出 DzSyncData 到达时间。
				if (thistype.oosTick >= SYNC_BUS_OOS_CHECK_INTERVAL) {
					thistype.oosTick = 0;
					thistype.oosCheckSeq = thistype.oosSeq;
					#if (SYNC_BUS_OOS_SEND_EACH_SAMPLE == 0)
					// 旧模式只在检查点发包，避免OOS探针自身制造高频随机/同步扰动。
					thistype.DzSyncDataEx("OOS", I2S(thistype.oosSeq) + ":" + I2S(thistype.oosLocalRand));
					#endif
					TimerStart(CreateTimer(),SYNC_BUS_OOS_CHECK_DELAY_SECONDS,false,function (){
						timer expired;
						expired = GetExpiredTimer();
						thistype.checkOOS();
						DestroyTimer(expired);
						expired = null;
					});
				}
			});

			// 注册 OOS 接收路由
			thistype.onDataSync("OOS", function () -> boolean {
				player p; integer pid; string payload; integer pos; integer seq; string value;
				p = thistype.getPlayer();
				pid = GetConvertedPlayerId(p);
				payload = thistype.getPayload();
				pos = thistype.findChar(payload, ":");
				if (pos > 0) {
					seq = S2I(SubStringBJ(payload, 1, pos - 1));
					value = SubStringBJ(payload, pos + 1, StringLength(payload));
				} else {
					seq = 0;
					value = payload;
				}
				thistype.oosRecvSeq[pid] = seq;
				thistype.oosRecvValue[pid] = S2I(value);
				DzWriteLog("[OOS] 收到玩家(" + I2S(pid) + ") seq=" + I2S(seq) + ", 值=" + value);
				p = null; payload = null; value = null;
				return true;
			});

			#endif

		}

		// 回调内读取上下文
		public static method getPlayer() -> player { return thistype.cbPlayer; }
		public static method getTag() -> string { return thistype.cbTag; }
		public static method getPayload() -> string { return thistype.cbPayload; }
		public static method getSequence() -> integer { return thistype.cbSequence; }
	}

}

//! endzinc
#endif
