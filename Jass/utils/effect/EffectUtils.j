#ifndef EffectUtilsIncluded
#define EffectUtilsIncluded

//! zinc
/*
特效工具库
*/
library EffectUtils {

    public function ShowEffectScale (string path, real x, real y,real scale){
        effect e = AddSpecialEffect(path, x, y);
        DzSetEffectScale(e, scale);
        DestroyEffect(e);
        e = null;
    }


    //---------------------------------------------------------------------------------------------------
    /*
        短暂的闪电效果
    */
    // 使用中央计时器 + 数组遍历 + 尾部交换法管理所有闪电效果
    private struct LightningQueue [] {
        private static lightning list[];
        private static real      remain[];
        private static integer   size = 0;
        private static timer     tickTimer = null;

        // 确保中央计时器已创建并运行
        private static method ensureTimer() {
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer last;
                    real t;
                    lightning l;

                    // 遍历所有闪电效果，按 0.02 秒衰减存活时间
                    for (i = 0; i < thistype.size; i += 1) {
                        t = thistype.remain[i] - 0.02;
                        if (t <= 0.0) {
                            // 时间到，销毁闪电并从队列移除（尾部交换法，保持数组紧凑）
                            l = thistype.list[i];
                            DestroyLightning(l);
                            l = null;

                            last = thistype.size - 1;
                            if (i != last) {
                                thistype.list[i]   = thistype.list[last];
                                thistype.remain[i] = thistype.remain[last];
                            }
                            thistype.list[last]   = null;
                            thistype.remain[last] = 0.0;
                            thistype.size -= 1;
                            i -= 1;
                        } else {
                            thistype.remain[i] = t;
                        }
                    }

                    // 队列为空时，停止并释放计时器，方便下次懒加载
                    if (thistype.size <= 0 && thistype.tickTimer != null) {
                        PauseTimer(thistype.tickTimer);
                        DestroyTimer(thistype.tickTimer);
                        thistype.tickTimer = null;
                    }
                });
            }
        }

        // 新增一个闪电效果
        public static method add(real x1, real y1, real x2, real y2, real time, string lType) {
            lightning l;

            if (time <= 0.0) { return; }

            thistype.ensureTimer();

            if (thistype.size >= 8190) {
                BJDebugMsg("|cFFFF0000[EffectUtils] LightningQueue 队列已满，无法继续添加闪电效果！|r");
                return;
            }

            l = AddLightning(lType, true, x1, y1, x2, y2);
            thistype.list[thistype.size]   = l;
            thistype.remain[thistype.size] = time;
            thistype.size += 1;
            l = null;
        }
    }

    // 外部接口：创建一个短暂的闪电效果
    public function CreateLightningXY(real x1, real y1, real x2, real y2, real time, string lType) {
        LightningQueue.add(x1, y1, x2, y2, time, lType);
    }

    public function CreateLightning(unit u1, unit u2, real time, string lType) {
        CreateLightningXY(GetUnitX(u1), GetUnitY(u1), GetUnitX(u2), GetUnitY(u2), time, lType);
    }

}

//! endzinc
#endif
