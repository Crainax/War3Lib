#ifndef ACIncluded
#define ACIncluded

//! zinc

// AC (Action Controller) - 计时器事件总线
//
// 用于管理游戏中的定时触发事件,支持:
// - 一次性定时任务
// - 循环定时任务
// - 带数据绑定的定时任务
//
// 警告: 禁止在异步环境下使用!
//
// @author Crainax
// @version 1.0

#include "Crainax/config/SharedMethod.h" // 结构体共用方法

#define DELTA_TIME 0.1 // 计时器精度
library AC {

    public struct ac {
        static thistype ethis  = 0;                // 当前正在运行的实例引用
        static thistype List [];                   // 任务列表
        static integer size   = 0;                 // 当前任务数量

        private static hashtable table = InitHashtable();  // 存储绑定数据的哈希表
        private static timer t        = null;              // 主计时器
        private static real lastTick = 0;                  // 上次计时器触发的时间

        integer uID;                       // 任务唯一ID
        trigger tr;                        // 绑定的触发器
        real remainTime;                   // 当前剩余时间
        real duration;                     // 初始持续时间
        boolean cycle;                     // 是否循环

        STRUCT_SHARED_METHODS(ac)

        // 实例销毁时的清理工作
        method onDestroy () {
            FlushChildHashtable(table, this);
            DestroyTrigger(tr);
            tr = null;
        }

        // 注销当前任务
        // 会自动清理相关资源
        public method unreg () {
            if (!(isExist())) {
                BJDebugMsg("error in unreg: AC is not exist");
                return;
            }
            if (uID != 0) { //交换数据(以结构体形式)
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
            this.destroy();
        }

        // 将当前注册的所有任务转为字符串形式
        // 主要用于调试
        // @return string 任务列表的字符串表示
        static method toString () -> string {
            string s = "";
            integer i;
            thistype this;
            for (i = 1;i<= size;i += 1) { //不能用isExist,毕竟最后一个还是自己
                this = List[i];
                if (tr == null) {s += "[" + I2S(i) + "]null->";}
                else {s += "[" + I2S(this) + "]"+I2S(GetHandleId(tr))+"->";}
            }
            s += "/";
            return "事件总数[" + I2S(size) + "]:" + s;
        }

        // 注册一个带数据绑定的定时任务
        // @param duration 持续时间,以0.1秒为单位
        // @param b        是否循环执行
        // @param func     要执行的函数
        // @return thistype 返回任务实例
        static method reg (real duration,boolean b,code func) -> thistype {
            thistype this = allocate();
            if (this <= 0) {return this;}

            cycle           = b;
            this.remainTime = duration;  // 转换为实数
            this.duration   = duration;
            tr             = CreateTrigger();
            TriggerAddCondition(tr,Condition(func));
            FlushChildHashtable(table, this);

            if (uID == 0) {
                size       += 1;
                List[size]  = this;
                uID         = size;
            }

            // 开始计时器
            if (t == null) {
                t = CreateTimer();
                TimerStart(t,DELTA_TIME,true,function (){  // 提高精度到0.1秒
                    integer i;
                    thistype this;

                    if (size > 0) {
                        for (1 <= i <= size) {
                            this = List[i];
                            this.remainTime -= DELTA_TIME;  // 减去实际流逝的时间

                            if (this.remainTime <= 0) {  // 时间到
                                if (tr != null) {
                                    ethis = this;
                                    TriggerEvaluate(tr);
                                }
                                if (cycle) {  // 循环任务
                                    this.remainTime = this.duration;  // 重置时间
                                } else {  // 一次性任务
                                    unreg();
                                    i -= 1;
                                }
                            }
                        }
                    }

                    if(size <= 0) {
                        PauseTimer(t);
                        DestroyTimer(t);
                        t = null;
                    }
                });
            }
            return this;
        }

        // 保存整数数据
        // @param key   键
        // @param value 值
        method saveInt (integer key,integer value) -> nothing {
            SaveInteger(table, this, key, value);
        }

        // 获取整数数据
        // @param key 键
        // @return integer 值
        method getInt (integer key) -> integer {
            return LoadInteger(table, this, key);
        }

    }
}
#undef DELTA_TIME

//! endzinc
#endif


