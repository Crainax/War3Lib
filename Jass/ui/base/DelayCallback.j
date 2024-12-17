#ifndef DelayCallbackIncluded
#define DelayCallbackIncluded

//! zinc
/*
结构体
延迟回调工具
用于在指定帧数后执行回调函数
*/
library DelayCallback requires Hardware {

    public type onDelayCallback extends function(player);


    public struct delayCallback []{
        private static integer delayFrames [];
        private static onDelayCallback callbacks [];
        private static integer delayCount = 0;

        // 注册一个延迟回调，在指定帧数后执行
        static method register(integer frames, onDelayCallback callback) {
            if (frames < 1) frames = 1;
            delayFrames[delayCount] = frames;
            callbacks[delayCount] = callback;
            delayCount += 1;
        }

        static method onInit() {
            // 使用Hardware的帧更新事件
            hardware.regUpdateEvent(function() {
                integer i = 0;
                integer j;

                while (i < delayCount) {
                    delayFrames[i] -= 1;
                    if (delayFrames[i] <= 0) {
                        // 执行回调
                        callbacks[i].evaluate(GetLocalPlayer());

                        // 移除这个回调
                        delayCount -= 1;
                        // 将后面的元素前移
                        j = i;
                        while (j < delayCount) {
                            delayFrames[j] = delayFrames[j + 1];
                            callbacks[j] = callbacks[j + 1];
                            j += 1;
                        }
                        i -= 1; // 因为当前位置现在是新元素，需要重新检查
                    }
                    i += 1;
                }
            });
        }
    }
}
//! endzinc

#endif
