#ifndef SyncBusIncluded
#define SyncBusIncluded

//! zinc
/*
同步总线
*/
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
			out = null;
		}

		// 注册路由回调
		public static method onDataSync(string tag, code cb) {
			trigger t;
			if (!thistype.initialized) { thistype.onInit(); }
			t = thistype.getOrCreateTagTrigger(tag);
			TriggerAddAction(t, cb);
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
						TriggerExecute(tg);
					}

					// 清理上下文
					thistype.cbPlayer = null;
					thistype.cbTag = "";
					thistype.cbPayload = "";
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
