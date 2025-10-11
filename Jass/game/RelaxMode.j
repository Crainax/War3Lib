#ifndef RelaxModeIncluded
#define RelaxModeIncluded

//! zinc
/*
休闲模式,挂机用
*/
library RelaxMode requires GroupUtils {

    public struct relaxMode [] {
        // 计时器对话框变量
        private static timerdialog relaxTimerDialog = null;

        static method Init() {
            // 使用可用rect区域选取单位加入单位组并隐藏
            timer t;
            t = CreateTimer();

            // 创建计时器对话框并显示
            relaxTimerDialog = CreateTimerDialogBJ(t, "|cffff6600游戏结束|r");
            TimerDialogDisplay(relaxTimerDialog, true);

            TimerStart(t,28800,false,function (){
                // 清理计时器对话框
                TimerDialogDisplay(relaxTimerDialog, false);
                DestroyTimerDialog(relaxTimerDialog);
                relaxTimerDialog = null;

                ForForce(GetPlayersAll(), function () {
                    CustomVictoryBJ( GetEnumPlayer(), true, true );
                });
            });
            t = null;
            t = CreateTimer();
            TimerStart(t,0.1,false,function (){
                group g = GetUnitsInRectAll(GetPlayableMapRect());
                ForGroup(g,function () {
                    ShowUnit(GetEnumUnit(), false);
                });
                DestroyGroup(g);
                g = null;

            });
            t = null;

        }

    }
}

//! endzinc
#endif
