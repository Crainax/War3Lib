#ifndef SyncBusIncluded
#define SyncBusIncluded

//! zinc
/*
同步总线
*/

#define SWITCH_SYNCBUS_LOG 1  //打开日志

library SyncBus {

	public struct syncBus [] {
		private static trigger busTr = null;
		private static boolean initialized = false;

		// 路由注册
		private static integer regCount = 0;
		private static string  regTags[];
		private static trigger regTrig[];

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
			string out;
			out = tag + "|" + payload;
			DzSyncData("OD", out);
			#if SWITCH_SYNCBUS_LOG
			DzWriteLog("[SyncBus] 发送数据: tag=" + tag + ", payload=" + payload);
			#endif
			out = null;
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
				integer idx; trigger tg;

				s = DzGetTriggerSyncData();
				p = DzGetTriggerSyncPlayer();
				pos = thistype.findChar(s, "|");

				#if SWITCH_SYNCBUS_LOG
				DzWriteLog("[SyncBus] 接收原始数据: " + s + ", 玩家=" + GetPlayerName(p));
				#endif

				if (pos > 0) {
					tag = SubStringBJ(s, 1, pos - 1);
					payload = SubStringBJ(s, pos + 1, StringLength(s));

					#if SWITCH_SYNCBUS_LOG
					DzWriteLog("[SyncBus] 解析数据: tag=" + tag + ", payload=" + payload);
					#endif

					// 设置回调上下文
					thistype.cbPlayer = p;
					thistype.cbTag = tag;
					thistype.cbPayload = payload;

					// 派发
					idx = thistype.findTagIndex(tag);
					if (idx >= 0) {
						tg = thistype.regTrig[idx];
						#if SWITCH_SYNCBUS_LOG
						DzWriteLog("[SyncBus] 派发到触发器: tag=" + tag);
						#endif
						TriggerEvaluate(tg);
					} else {
						#if SWITCH_SYNCBUS_LOG
						DzWriteLog("[SyncBus] 警告: 未找到标签对应的触发器: tag=" + tag);
						#endif
					}

					// 清理上下文
					thistype.cbPlayer = null;
					thistype.cbTag = "";
					thistype.cbPayload = "";
				} else {
					#if SWITCH_SYNCBUS_LOG
					DzWriteLog("[SyncBus] 错误: 数据格式无效，未找到分隔符 '|'");
					#endif
				}

				tg = null; tag = null; payload = null; s = null; p = null;
			});
		}

		// 回调内读取上下文
		public static method getPlayer() -> player { return thistype.cbPlayer; }
		public static method getTag() -> string { return thistype.cbTag; }
		public static method getPayload() -> string { return thistype.cbPayload; }
	}

}

//! endzinc
#endif
