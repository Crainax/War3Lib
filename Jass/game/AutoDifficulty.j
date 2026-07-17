#ifndef AutoDiffucultyIncluded
#define AutoDiffucultyIncluded

//! zinc
/*
自动选游戏难度
*/
library AutoDifficulty {

	private timer TiAutoDiff = null; //自动选择难度
	private timerdialog TdAutoDiff = null; //自动选择难度
    private boolean isRegister = false; //是否已经注册
    private trigger TrAutoDiff = null; //自动选择难度的回调

    //注册一下自动选游戏难度
    public function RegisterAutoDifficulty (real time,string title,code func) {
        if (isRegister) {
            return;
        }
        isRegister = true;
		TiAutoDiff = CreateTimer();
		TdAutoDiff = CreateTimerDialog(TiAutoDiff);
		TimerDialogDisplay(TdAutoDiff,true);
		TimerDialogSetTitle(TdAutoDiff,title);
		TimerDialogSetSpeed(TdAutoDiff,1.0);

        TrAutoDiff = CreateTrigger();
		TriggerAddCondition(TrAutoDiff, Condition(func));
		TimerStart(TiAutoDiff,time,false,function (){
			timer t = GetExpiredTimer();
			trigger tr = TrAutoDiff;
			timerdialog td = TdAutoDiff;

            if (tr != null) {
                TriggerEvaluate(tr);
            }

			if (TrAutoDiff == tr) {
				DestroyTrigger(tr);
				TrAutoDiff = null;
			}
			if (TiAutoDiff == t) {
				PauseTimer(t);
				DestroyTimer(t);
				TiAutoDiff = null;
			}
			if (TdAutoDiff == td) {
				DestroyTimerDialog(td);
				TdAutoDiff = null;
			}
			if (TiAutoDiff == null && TrAutoDiff == null && TdAutoDiff == null) {
				isRegister = false;
			}
			t = null;
			tr = null;
			td = null;
		});
    }

    //结束自动选游戏难度的运行
    public function EndAutoDifficulty () {
        if (TrAutoDiff != null) {
            DestroyTrigger(TrAutoDiff);
            TrAutoDiff = null;
        }
        if (TiAutoDiff != null) {
			DestroyTimer(TiAutoDiff);
            TiAutoDiff = null;
		}
		if (TdAutoDiff != null) {
			DestroyTimerDialog(TdAutoDiff);
            TdAutoDiff = null;
		}
		isRegister = false;
    }

}

//! endzinc
#endif
