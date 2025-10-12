#ifndef MultiDialogIncluded
#define MultiDialogIncluded

//! zinc
/*
multiDialog - 统一对话框系统
支持简单对话框和翻页对话框，使用单例触发器避免事件泄露
*/
library MultiDialog {

    public hashtable HASH_DIALOG = InitHashtable();

	public type OnAlterDialogClick extends function(player, integer, AlterDialog);
	public type OnPageDialogClick extends function(player, integer, PageDialog);
	public type ValueFiller extends function(player, integer) -> integer;
	public type StringFiller extends function(player, integer) -> string;



	// 统一对话框结构体
	public struct multiDialog []{
		// 每玩家状态（使用结构体索引作为玩家索引：1..MAX_PLAYER_COUNT）
		private static dialog playerDialogs[];
		private static trigger playerTriggers [];
		private static boolean initialized = false;

		// 共享成员（按玩家索引存储状态）
		private static player p[];
		private static integer num[];
		private static string title[];
		private static boolean isPageDialog[];

		// AlterDialog 专用
		private static OnAlterDialogClick odc1[];

		// PageDialog 专用
		private static integer current[];
		private static integer spiltCount[];
		private static boolean escable[];
		private static OnPageDialogClick odc2[];
		private static ValueFiller vf[];
		private static StringFiller sf[];

		// 初始化单例触发器系统
		static method onInit() {
			integer i;
			for (1 <= i <= MAX_PLAYER_COUNT) {
				if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
					// 为玩家创建常驻对话框与触发器，并注册事件
					multiDialog.playerDialogs[i] = DialogCreate();
					SaveInteger(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[i]), 1, i);
					multiDialog.playerTriggers[i] = CreateTrigger();
					TriggerRegisterDialogEvent(multiDialog.playerTriggers[i], multiDialog.playerDialogs[i]);
					TriggerAddAction(multiDialog.playerTriggers[i], function () {
						integer pid;
						integer i;
						button clicked;
						integer nextOrpre;
						dialog dlg;
						thistype inst;

						// 从被点击的对话框得到玩家索引
						dlg = GetClickedDialogBJ();
						pid = LoadInteger(HASH_DIALOG, GetHandleId(dlg), 1);
						inst = pid;
						clicked = GetClickedButtonBJ();
						nextOrpre = 0;

						// 根据对话框类型处理点击
						if (multiDialog.isPageDialog[pid]) {
							// PageDialog 逻辑
							i = 1;
							while (i <= multiDialog.spiltCount[pid] + 1) {
								if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i)) {
									multiDialog.odc2[pid].execute(multiDialog.p[pid], multiDialog.vf[pid].evaluate(multiDialog.p[pid], multiDialog.current[pid] * multiDialog.spiltCount[pid] - multiDialog.spiltCount[pid] + i - 1), inst);
								}
								i = i + 1;
							}

							// 处理翻页按钮
							if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), 11)) {
								multiDialog.odc2[pid].execute(multiDialog.p[pid], -1, inst);
							} else if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), 12)) {
								inst.prePage();
								nextOrpre = 1;
							} else if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), 10)) {
								inst.nextPage();
								nextOrpre = 2;
							}
							inst.clearButtonData();

							if (nextOrpre != 0) {
								DialogClear(multiDialog.playerDialogs[pid]);
								inst.show();
							}
						} else {
							// 简单对话框逻辑
							i = 1;
							while (i <= multiDialog.num[pid]) {
								if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i)) {
									multiDialog.odc1[pid].execute(multiDialog.p[pid], LoadInteger(HASH_DIALOG, GetHandleId(clicked), 1), inst);
								}
								i = i + 1;
							}
						}

						DialogDisplay(multiDialog.p[pid], multiDialog.playerDialogs[pid], false);
						clicked = null;
						dlg = null;
					});
				}
			}
			multiDialog.initialized = true;
		}

		// 给对话框绑单位,不能取大于1
		public method bindUnitHandle(unit u, integer i) {
			integer pid;
			pid = this;
			if (i == 1) {
				BJDebugMsg("error : in the dialog binding 1!");
			}
			SaveUnitHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i, u);
		}

		public method getUnitHandle(integer i) -> unit {
			integer pid;
			pid = this;
			return LoadUnitHandle(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i);
		}

		// 给对话框绑整数,不能取大于1
		public method bindInteger(integer input, integer i) {
			integer pid;
			pid = this;
			if (i == 1) {
				BJDebugMsg("error : in the dialog binding 1!");
			}
			SaveInteger(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i, input);
		}

		public method getInteger(integer i) -> integer {
			integer pid;
			pid = this;
			return LoadInteger(HASH_DIALOG, GetHandleId(multiDialog.playerDialogs[pid]), i);
		}

		public method show() {
			integer pid;
			integer i;
			integer realI;
			dialog d;

			pid = this;
			d = multiDialog.playerDialogs[pid];

			if (multiDialog.isPageDialog[pid]) {
				// 翻页对话框显示逻辑
				i = multiDialog.current[pid] * multiDialog.spiltCount[pid] - multiDialog.spiltCount[pid] + 1;
				realI = 1;

				while (i <= I3(multiDialog.current[pid] == this.GetPageCount(), multiDialog.num[pid], multiDialog.current[pid] * multiDialog.spiltCount[pid])) {
					realI = realI + 1;
					SaveButtonHandle(HASH_DIALOG, GetHandleId(d), realI, DialogAddButtonBJ(d, multiDialog.sf[pid].evaluate(multiDialog.p[pid], i)));
					i = i + 1;
				}

				if (this.GetPageCount() > 1) {
					SaveButtonHandle(HASH_DIALOG, GetHandleId(d), 12, DialogAddButtonBJ(d, "上一页"));
					SaveButtonHandle(HASH_DIALOG, GetHandleId(d), 10, DialogAddButtonBJ(d, "下一页"));
				}

				if (multiDialog.escable[pid]) {
					SaveButtonHandle(HASH_DIALOG, GetHandleId(d), 11, DialogAddButton(d, "退出|cffff6800(Esc)|r", 512));
				}

				DialogSetMessage(d, multiDialog.title[pid] + S3(this.GetPageCount() > 1, "(" + I2S(multiDialog.current[pid]) + "/" + I2S(this.GetPageCount()) + ")", ""));
			} else {
				// 简单对话框显示逻辑
				DialogSetMessage(d, multiDialog.title[pid]);
			}
			DialogDisplay(multiDialog.p[pid], d, true);
			d = null;
		}

		public method addButton(string s, integer value, integer hotKey) {
			integer pid;
			button bt;
			dialog d;

			pid = this;
			d = multiDialog.playerDialogs[pid];
			bt = DialogAddButtonBJ(d, s);
			multiDialog.num[pid] = multiDialog.num[pid] + 1;
			SaveInteger(HASH_DIALOG, GetHandleId(bt), 1, value);
			SaveButtonHandle(HASH_DIALOG, GetHandleId(d), multiDialog.num[pid], bt);
			bt = null;
			d = null;
		}

		public method addButtonHotKey(string s, integer value, integer hotKey) {
			integer pid;
			button bt;
			dialog d;

			pid = this;
			d = multiDialog.playerDialogs[pid];
			bt = DialogAddButton(d, s, hotKey);
			multiDialog.num[pid] = multiDialog.num[pid] + 1;
			SaveInteger(HASH_DIALOG, GetHandleId(bt), 1, value);
			SaveButtonHandle(HASH_DIALOG, GetHandleId(d), multiDialog.num[pid], bt);
			bt = null;
			d = null;
		}

		// PageDialog 专用方法
		public method GetPageCount() -> integer {
			integer pid;
			pid = this;
			if (ModuloInteger(multiDialog.num[pid], multiDialog.spiltCount[pid]) == 0) {
				return multiDialog.num[pid] / multiDialog.spiltCount[pid];
			} else {
				return multiDialog.num[pid] / multiDialog.spiltCount[pid] + 1;
			}
		}

		public method clearButtonData() {
			integer pid;
			integer i;
			dialog d;

			pid = this;
			d = multiDialog.playerDialogs[pid];
			i = 2;
			while (i <= 11) {
				RemoveSavedHandle(HASH_DIALOG, GetHandleId(d), i);
				i = i + 1;
			}
			d = null;
		}

		public method nextPage() {
			integer pid;
			pid = this;
			multiDialog.current[pid] = I3(this.GetPageCount() == multiDialog.current[pid], 1, multiDialog.current[pid] + 1);
		}

		public method prePage() {
			integer pid;
			pid = this;
			multiDialog.current[pid] = I3(multiDialog.current[pid] == 1, this.GetPageCount(), multiDialog.current[pid] - 1);
		}

		public method setEscable(boolean b) {
			integer pid;
			pid = this;
			multiDialog.escable[pid] = b;
		}

		public method setSpiltCount(integer num) {
			integer pid;
			pid = this;
			multiDialog.spiltCount[pid] = ILimit(num, 1, 8);
		}

		// 简单对话框构造（保留原 AlterDialog 参数）
		public static method createSimple(player p, string title, OnAlterDialogClick odc) -> integer {
			integer pid;

			pid = GetConvertedPlayerId(p);
			if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }

			// 复用该玩家的常驻对话框
			multiDialog.p[pid] = p;
			multiDialog.num[pid] = 0;
			multiDialog.odc1[pid] = odc;
			multiDialog.title[pid] = title;
			multiDialog.isPageDialog[pid] = false;

			return pid;
		}

		// 翻页对话框构造（保留原 PageDialog 参数）
		public static method createPaged(player p, string title, integer total, OnPageDialogClick odc, ValueFiller vf, StringFiller sf) -> integer {
			integer pid;

			pid = GetConvertedPlayerId(p);
			if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }

			// 复用该玩家的常驻对话框
			multiDialog.p[pid] = p;
			multiDialog.num[pid] = total;
			multiDialog.odc2[pid] = odc;
			multiDialog.vf[pid] = vf;
			multiDialog.sf[pid] = sf;
			multiDialog.spiltCount[pid] = 8;
			multiDialog.title[pid] = title;
			multiDialog.current[pid] = 1;
			multiDialog.escable[pid] = false;
			multiDialog.isPageDialog[pid] = true;

			return pid;
		}

		// 清理对话框（不销毁，仅重置状态供下次复用）
		public method clear() {
			integer pid;
			integer i;
			dialog d;

			pid = this;
			d = multiDialog.playerDialogs[pid];

			// 隐藏对话框
			DialogDisplay(multiDialog.p[pid], d, false);

			// 清理按钮哈希表
			i = 1;
			while (i <= I3(multiDialog.isPageDialog[pid], 12, multiDialog.num[pid])) {
				FlushChildHashtable(HASH_DIALOG, GetHandleId(LoadButtonHandle(HASH_DIALOG, GetHandleId(d), i)));
				i = i + 1;
			}

			// 清理对话框哈希表（但不清理 key=1 的实例索引）
			i = 2;
			while (i <= 12) {
				RemoveSavedHandle(HASH_DIALOG, GetHandleId(d), i);
				i = i + 1;
			}

			// 清空 dialog 内容
			DialogClear(d);

			// 重置成员状态
			SetDialoging(multiDialog.p[pid], false);
			multiDialog.p[pid] = null;
			multiDialog.num[pid] = 0;
			multiDialog.odc1[pid] = 0;
			multiDialog.odc2[pid] = 0;
			multiDialog.vf[pid] = 0;
			multiDialog.sf[pid] = 0;
			multiDialog.title[pid] = null;
			multiDialog.isPageDialog[pid] = false;

			d = null;
		}
	}

}

//! endzinc
#endif
