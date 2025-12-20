#ifndef EffectUtilsIncluded
#define EffectUtilsIncluded

//! zinc
/*
特效工具库
*/

//骨法闪电链:OBN5

//# dependency:map/splats/lightningdata.slk
//# dependency:resource/Textures/Hero_Oblivion_N5_light1.blp

library EffectUtils requires YDWEJapiEffect {


	// 环绕特效
	public function ShowCircleEffect(real x, real y, real radius, integer count, string s) {
		integer i;

		for (1 <= i <= count) {
			DestroyEffect(AddSpecialEffect(s, YDWECoordinateX(x + radius * CosBJ(i * 360.0 / count)), YDWECoordinateY(y + radius * SinBJ(i * 360.0 / count))));
		}
	}

    // 基础缩放函数：对已有特效应用缩放矩阵
    public function SetEffectScale (effect e, real scale) {
        EXEffectMatScale(e, scale, scale, scale);
    }

    // 立即创建一个缩放后的短暂特效（创建后立刻销毁）
    public function ShowEffectScale (string path, real x, real y,real scale){
        effect e = AddSpecialEffect(path, x, y);
        SetEffectScale(e, scale);
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

    //---------------------------------------------------------------------------------------------------
    /*
        中央计时器管理的短暂特效
        通过队列统一递减存活时间，到期自动 DestroyEffect
    */
    private struct EffectQueue [] {
        private static effect list[];
        private static real   remain[];
        private static integer size = 0;
        private static timer  tickTimer = null;

        // 确保中央计时器已创建并运行
        private static method ensureTimer() {
            if (thistype.tickTimer == null) {
                thistype.tickTimer = CreateTimer();
                TimerStart(thistype.tickTimer, 0.02, true, function () {
                    integer i; integer last;
                    real t;
                    effect e;

                    // 遍历所有特效，按 0.02 秒衰减存活时间
                    for (i = 0; i < thistype.size; i += 1) {
                        t = thistype.remain[i] - 0.02;
                        if (t <= 0.0) {
                            // 时间到，销毁特效并从队列移除（尾部交换法，保持数组紧凑）
                            e = thistype.list[i];
                            DestroyEffect(e);
                            e = null;

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

        // 将一个特效加入队列统一管理
        public static method add(effect e, real time) {
            if (time <= 0.0) {
                // 存活时间非法，直接销毁传入特效
                DestroyEffect(e);
                e = null;
                return;
            }

            thistype.ensureTimer();

            if (thistype.size >= 8190) {
                BJDebugMsg("|cFFFF0000[EffectUtils] EffectQueue 队列已满，无法继续添加特效！|r");
                DestroyEffect(e);
                e = null;
                return;
            }

            thistype.list[thistype.size]   = e;
            thistype.remain[thistype.size] = time;
            thistype.size += 1;
            e = null;
        }
    }

    // 外部接口：创建一个带缩放与动画的短暂特效
    // path: 模型路径
    // x,y : 世界坐标
    // scale: 缩放倍数
    // time: 存活时间（秒），到期自动 DestroyEffect
    public function CreateEffectScaleAnim (string path, real x, real y, real scale,  real time) {
        effect e;

        e = AddSpecialEffect(path, x, y);
        if (e == null) {
            return;
        }

        // 缩放：复用上面的缩放函数逻辑
        SetEffectScale(e, scale);

        // 播放指定动画，附加链接名使用空字符串
        // DzPlayEffectAnimation(e, anim, "");

        // 交给 EffectQueue 统一管理存活时间与销毁
        EffectQueue.add(e, time);

        // 本地引用置空，避免句柄悬挂
        e = null;
    }

    // 外部接口：创建一个带缩放 + 朝向旋转的短暂特效
    // facing: 角度（度），参考 EXEffectMatRotateZ / GetFacing
    public function CreateEffectScaleAnimFacing (string path, real x, real y, real scale, real time, real facing) {
        effect e;

        e = AddSpecialEffect(path, x, y);
        if (e == null) {
            return;
        }

        // 变换矩阵：先重置，再缩放，再旋转（参考 AJZ2Fengbu 的写法）
        EXEffectMatReset(e);
        SetEffectScale(e, scale);
        EXEffectMatRotateZ(e, facing);

        EffectQueue.add(e, time);
        e = null;
    }

}

//! endzinc
#endif
