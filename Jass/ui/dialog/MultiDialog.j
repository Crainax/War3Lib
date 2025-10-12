#ifndef MultiDialogIncluded
#define MultiDialogIncluded

//! zinc
/*
MultiDialog - 统一对话框系统
支持简单对话框和翻页对话框，使用单例触发器避免事件泄露
*/
library MultiDialog {

    public hashtable HASH_DIALOG = InitHashtable();

	// 统一对话框结构体
	public struct multiDialog {
		// 共享成员
		private dialog d;
		private player p;
		private integer num;
		private string title;
		private boolean isPageDialog;  // 区分类型

		// AlterDialog 专用
		private OnAlterDialogClick odc1;

		// PageDialog 专用
		private integer current;
		private integer spiltCount;
		private boolean escable;
		private OnPageDialogClick odc2;
		private ValueFiller vf;
		private StringFiller sf;

		// 静态单例触发器系统
		private static trigger playerTriggers[];
		private static boolean initialized = false;

		// 回调参数传递（避免哈希表冲突）
		private static thistype callbackDialog = 0;
		private static button callbackButton = null;

		// 初始化单例触发器系统
		static method onInit() {
			integer i;
			for (1 <= i <= MAX_PLAYER_COUNT) {
                if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
                    MultiDialog.playerTriggers[i] = CreateTrigger();
                    TriggerAddAction(MultiDialog.playerTriggers[i], function () {
                        thistype this;
                        integer i;
                        button clicked;
                        integer nextOrpre;

                        this = MultiDialog.callbackDialog;
                        clicked = GetClickedButtonBJ();
                        nextOrpre = 0;

                        // 根据对话框类型处理点击
                        if (this.isPageDialog) {
                            // PageDialog 逻辑
                            i = 1;
                            while (i <= this.spiltCount + 1) {
                                if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)) {
                                    this.odc2.execute(this.p, this.vf.evaluate(this.p, this.current * this.spiltCount - this.spiltCount + i - 1), this);
                                }
                                i = i + 1;
                            }

                            // 处理翻页按钮
                            if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 11)) {
                                this.odc2.execute(this.p, -1, this);
                            } else if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 12)) {
                                this.prePage();
                                nextOrpre = 1;
                            } else if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 10)) {
                                this.nextPage();
                                nextOrpre = 2;
                            }
                            this.clearButtonData();

                            if (nextOrpre != 0) {
                                DialogClear(this.d);
                                this.show();
                            }
                        } else {
                            // 简单对话框逻辑
                            i = 1;
                            while (i <= this.num) {
                                if (clicked == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)) {
                                    this.odc1.execute(this.p, LoadInteger(HASH_DIALOG, GetHandleId(clicked), 1), this);
                                }
                                i = i + 1;
                            }
                        }

                        DialogDisplay(this.p, this.d, false);
                        clicked = null;
                    });
                }
			}
			MultiDialog.initialized = true;
		}

		// 给对话框绑单位,不能取大于1
		public method bindUnitHandle(unit u, integer i) {
			if (i == 1) {
				BJDebugMsg("error : in the dialog binding 1!");
			}
			SaveUnitHandle(HASH_DIALOG, GetHandleId(this.d), i, u);
		}

		public method getUnitHandle(integer i) -> unit {
			return LoadUnitHandle(HASH_DIALOG, GetHandleId(this.d), i);
		}

		// 给对话框绑整数,不能取大于1
		public method bindInteger(integer input, integer i) {
			if (i == 1) {
				BJDebugMsg("error : in the dialog binding 1!");
			}
			SaveInteger(HASH_DIALOG, GetHandleId(this.d), i, input);
		}

		public method getInteger(integer i) -> integer {
			return LoadInteger(HASH_DIALOG, GetHandleId(this.d), i);
		}

		public method show() {
			if (this.isPageDialog) {
				// 翻页对话框显示逻辑
				integer i;
				integer realI;

				i = this.current * this.spiltCount - this.spiltCount + 1;
				realI = 1;

				while (i <= I3(this.current == this.GetPageCount(), this.num, this.current * this.spiltCount)) {
					realI = realI + 1;
					SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), realI, DialogAddButtonBJ(this.d, this.sf.evaluate(this.p, i)));
					i = i + 1;
				}

				if (this.GetPageCount() > 1) {
					SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 12, DialogAddButtonBJ(this.d, "上一页"));
					SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 10, DialogAddButtonBJ(this.d, "下一页"));
				}

				if (this.escable) {
					SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 11, DialogAddButton(this.d, "退出|cffff6800(Esc)|r", 512));
				}

				DialogSetMessage(this.d, this.title + S3(this.GetPageCount() > 1, "(" + I2S(this.current) + "/" + I2S(this.GetPageCount()) + ")", ""));
			} else {
				// 简单对话框显示逻辑
				DialogSetMessage(this.d, this.title);
			}
			DialogDisplay(this.p, this.d, true);
		}

		public method addButton(string s, integer value, integer hotKey) {
			button bt;

			bt = DialogAddButtonBJ(this.d, s);
			this.num = this.num + 1;
			SaveInteger(HASH_DIALOG, GetHandleId(bt), 1, value);
			SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), this.num, bt);
			bt = null;
		}

		public method addButtonHotKey(string s, integer value, integer hotKey) {
			button bt;

			bt = DialogAddButton(this.d, s, hotKey);
			this.num = this.num + 1;
			SaveInteger(HASH_DIALOG, GetHandleId(bt), 1, value);
			SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), this.num, bt);
			bt = null;
		}

		// PageDialog 专用方法
		public method GetPageCount() -> integer {
			if (ModuloInteger(this.num, this.spiltCount) == 0) {
				return this.num / this.spiltCount;
			} else {
				return this.num / this.spiltCount + 1;
			}
		}

		public method clearButtonData() {
			integer i;

			i = 2;
			while (i <= 11) {
				RemoveSavedHandle(HASH_DIALOG, GetHandleId(this.d), i);
				i = i + 1;
			}
		}

		public method nextPage() {
			this.current = I3(this.GetPageCount() == this.current, 1, this.current + 1);
		}

		public method prePage() {
			this.current = I3(this.current == 1, this.GetPageCount(), this.current - 1);
		}

		public method setEscable(boolean b) {
			this.escable = b;
		}

		public method setSpiltCount(integer num) {
			this.spiltCount = ILimit(num, 1, 8);
		}

		// 简单对话框构造（保留原 AlterDialog 参数）
		public static method createSimple(player p, string title, OnAlterDialogClick odc) -> thistype {
			thistype this;
			integer pid;

			pid = GetConvertedPlayerId(p);
			if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }

			this = thistype.allocate();
			this.d = DialogCreate();
			this.p = p;
			this.num = 0;
			this.odc1 = odc;
			this.title = title;
			this.isPageDialog = false;

			SaveInteger(HASH_DIALOG, GetHandleId(this.d), 1, this);

			// 复用玩家单例触发器
			TriggerRegisterDialogEvent(MultiDialog.playerTriggers[pid], this.d);

			return this;
		}

		// 翻页对话框构造（保留原 PageDialog 参数）
		public static method createPaged(player p, string title, integer total, OnPageDialogClick odc, ValueFiller vf, StringFiller sf) -> thistype {
			thistype this;
			integer pid;

			pid = GetConvertedPlayerId(p);
			if (pid < 1 || pid > MAX_PLAYER_COUNT) { return 0; }

			this = thistype.allocate();
			this.d = DialogCreate();
			this.p = p;
			this.num = total;
			this.odc2 = odc;
			this.vf = vf;
			this.sf = sf;
			this.spiltCount = 8;
			this.title = title;
			this.current = 1;
			this.escable = false;
			this.isPageDialog = true;

			SaveInteger(HASH_DIALOG, GetHandleId(this.d), 1, this);

			// 复用玩家单例触发器
			TriggerRegisterDialogEvent(MultiDialog.playerTriggers[pid], this.d);

			return this;
		}

		public method onDestroy() {
			integer i;

			// 隐藏对话框
			DialogDisplay(this.p, this.d, false);

			// 清理按钮哈希表
			i = 1;
			while (i <= I3(this.isPageDialog, 12, this.num)) {
				FlushChildHashtable(HASH_DIALOG, GetHandleId(LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)));
				i = i + 1;
			}

			// 清理对话框哈希表
			FlushChildHashtable(HASH_DIALOG, GetHandleId(this.d));

			// 清空 dialog（如需复用可移除此行）
			DialogClear(this.d);

			// 清理成员（句柄不置 null，供复用）
			SetDialoging(this.p, false);
			this.p = null;
			this.num = 0;
			this.odc1 = 0;
			this.odc2 = 0;
			this.vf = 0;
			this.sf = 0;
			this.title = null;
		}
	}

}

//! endzinc
#endif
