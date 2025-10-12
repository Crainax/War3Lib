#ifndef DialogsIncluded
#define DialogsIncluded
//! zinc

library Dialogs {


	public hashtable HASH_DIALOG = InitHashtable();

	public type OnAlterDialogClick extends function(player, integer, AlterDialog);
	public type OnPageDialogClick extends function(player, integer, PageDialog);
	public type ValueFiller extends function(player, integer) -> integer;
	public type StringFiller extends function(player, integer) -> string;

	//判断一个玩家是否正在对话框状态
	boolean BDialoging[];

	// 是否正在对话框
	public function IsDialoging(player p) -> boolean {
		return BDialoging[GetConvertedPlayerId(p)];
	}

	public function SetDialoging(player p, boolean yes) {
		BDialoging[GetConvertedPlayerId(p)] = yes;
	}


	// 多项对话框
	public struct AlterDialog {
		private trigger click;
		private triggeraction clickAction;
		private dialog d;
		private player p;
		private integer num;
		private string title;
		private OnAlterDialogClick odc;


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
			DialogSetMessage(this.d, this.title);
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

		public static method create(player p, string title, OnAlterDialogClick odc) -> thistype {
			thistype this = thistype.allocate();

			this.click = CreateTrigger();
			this.d = DialogCreate();
			this.p = p;
			this.num = 0;
			this.odc = odc;
			this.title = title;
			SaveInteger(HASH_DIALOG, GetHandleId(this.d), 1, this);
			TriggerRegisterDialogEvent(this.click, this.d);
			this.clickAction = TriggerAddAction(this.click, function () {
				thistype this;
				integer i;

				this = LoadInteger(HASH_DIALOG, GetHandleId(GetClickedDialogBJ()), 1);
				i = 1;

				while (i <= this.num) {
					if (GetClickedButtonBJ() == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)) {
						this.odc.execute(this.p, LoadInteger(HASH_DIALOG, GetHandleId(GetClickedButtonBJ()), 1), this);
					}
					i = i + 1;
				}
				DialogDisplay(this.p, this.d, false);
			});
			return this;
		}

		public method onDestroy() {
			integer i;

			i = 1;
			while (i <= this.num) {
				FlushChildHashtable(HASH_DIALOG, GetHandleId(LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)));
				i = i + 1;
			}
			FlushChildHashtable(HASH_DIALOG, GetHandleId(this.d));

			// 先移除 triggeraction 防止泄露
			if (this.clickAction != null) {
				TriggerRemoveAction(this.click, this.clickAction);
				this.clickAction = null;
			}
			DestroyTrigger(this.click);
			this.click = null;

			DialogDisplay(this.p, this.d, false);
			DialogClear(this.d);
			DialogDestroy(this.d);
			SetDialoging(this.p, false);
			this.p = null;
			this.num = 0;
			this.odc = 0;
			this.title = null;
		}
	}

	// 翻页对话框
	// -1是退出
	public struct PageDialog {
		private trigger click;
		private triggeraction clickAction;
		private dialog d;
		private player p;
		private integer num;
		private integer current;
		private integer spiltCount;
		private string title;
		private boolean escable;
		private OnPageDialogClick odc;
		private ValueFiller vf;
		private StringFiller sf;

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

		public method show() {
			integer i;
			integer realI;

			i = this.current * this.spiltCount - this.spiltCount + 1;
			realI = 1;

		if (this.current == this.GetPageCount()) {
			while (i <= this.num) {
				realI = realI + 1;
				SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), realI, DialogAddButtonBJ(this.d, this.sf.evaluate(this.p, i)));
				i = i + 1;
			}
		} else {
			while (i <= this.current * this.spiltCount) {
				realI = realI + 1;
				SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), realI, DialogAddButtonBJ(this.d, this.sf.evaluate(this.p, i)));
				i = i + 1;
			}
		}

			if (this.GetPageCount() > 1) {
				SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 12, DialogAddButtonBJ(this.d, "上一页"));
				SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 10, DialogAddButtonBJ(this.d, "下一页"));
			}

			if (this.escable) {
				SaveButtonHandle(HASH_DIALOG, GetHandleId(this.d), 11, DialogAddButton(this.d, "退出|cffff6800(Esc)|r", 512));
			}

		if (this.GetPageCount() > 1) {
			DialogSetMessage(this.d, this.title + "(" + I2S(this.current) + "/" + I2S(this.GetPageCount()) + ")");
		} else {
			DialogSetMessage(this.d, this.title);
		}
			DialogDisplay(this.p, this.d, true);
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

		public method nextPage() {
			if (this.GetPageCount() == this.current) {
				this.current = 1;
			} else {
				this.current = this.current + 1;
			}
		}

		public method prePage() {
			if (this.current == 1) {
				this.current = this.GetPageCount();
			} else {
				this.current = this.current - 1;
			}
		}

		public method setEscable(boolean b) {
			this.escable = b;
		}

		public method setSpiltCount(integer num) {
			if (num < 1) {
				this.spiltCount = 1;
			} else if (num > 8) {
				this.spiltCount = 8;
			} else {
				this.spiltCount = num;
			}
		}

		public static method create(player p, string title, integer total, OnPageDialogClick odc, ValueFiller vf, StringFiller sf) -> thistype {
			thistype this = thistype.allocate();

			this.click = CreateTrigger();
			this.d = DialogCreate();
			this.p = p;
			this.num = total;
			this.odc = odc;
			this.vf = vf;
			this.sf = sf;
			this.spiltCount = 8;
			this.title = title;
			this.current = 1;
			this.escable = false;
			SaveInteger(HASH_DIALOG, GetHandleId(this.d), 1, this);
			TriggerRegisterDialogEvent(this.click, this.d);
			this.clickAction = TriggerAddAction(this.click, function () {
				thistype this;
				integer i;
				integer nextOrpre;

				this = LoadInteger(HASH_DIALOG, GetHandleId(GetClickedDialogBJ()), 1);
				i = 1;
				nextOrpre = 0;

				while (i <= this.spiltCount + 1) {
					if (GetClickedButtonBJ() == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)) {
						this.odc.execute(this.p, this.vf.evaluate(this.p, this.current * this.spiltCount - this.spiltCount + i - 1), this);
					}
					i = i + 1;
				}
				DialogDisplay(this.p, this.d, false);

				if (GetClickedButtonBJ() == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 11)) {
					this.odc.execute(this.p, -1, this);
				} else if (GetClickedButtonBJ() == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 12)) {
					this.prePage();
					nextOrpre = 1;
				} else if (GetClickedButtonBJ() == LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), 10)) {
					this.nextPage();
					nextOrpre = 2;
				}
				this.clearButtonData();

				if (nextOrpre != 0) {
					DialogClear(this.d);
					this.show();
				}
			});
			return this;
		}

		public method onDestroy() {
			integer i;

			i = 1;
			while (i <= 11) {
				FlushChildHashtable(HASH_DIALOG, GetHandleId(LoadButtonHandle(HASH_DIALOG, GetHandleId(this.d), i)));
				i = i + 1;
			}
			FlushChildHashtable(HASH_DIALOG, GetHandleId(this.d));

			// 先移除 triggeraction 防止泄露
			if (this.clickAction != null) {
				TriggerRemoveAction(this.click, this.clickAction);
				this.clickAction = null;
			}
			DestroyTrigger(this.click);
			this.click = null;

			DialogDisplay(this.p, this.d, false);
			DialogClear(this.d);
			DialogDestroy(this.d);
			SetDialoging(this.p, false);
			this.p = null;
			this.num = 0;
			this.d = null;
			this.odc = 0;
			this.spiltCount = 0;
			this.current = 0;
			this.vf = 0;
			this.sf = 0;
			this.title = null;
		}
	}
}

//! endzinc
#endif
