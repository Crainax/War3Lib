#ifndef CameraIncluded
#define CameraIncluded

//! zinc
/*
鼠标滚轮控制视距
一键切换宽屏模式
made by 裂魂
2018/10/19
*/
library CameraControl requires Hardware{

    integer ViewLevel  = 8;     //初始视野等级
    boolean ResetCam   = false; //开启重置镜头属性标识
    real    WheelSpeed = 0.1;   //镜头变化平滑度
    boolean WideScr    = false; //是否是宽屏
    real    X_ANGLE    = 304;   //默认X轴角度
    boolean HeightLocked = false; //镜头高度是否锁定

    public struct cameraControl {
        // 打开滚轮控制镜头高度
        public static method openWheel () {DoNothing();}

        // 锁定镜头高度
        public static method lockHeight () { HeightLocked = true; }

        // 解锁镜头高度
        public static method unlockHeight () { HeightLocked = false; }

        // 查询是否锁定
        public static method isHeightLocked () ->boolean { return HeightLocked; }

        // 初始化镜头（仅对指定玩家生效）
        public static method initCamera (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }

            ResetCam = true;
            ViewLevel = ViewLevel + 5; // 增加1000高度（1000/200=5）
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
            X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
        }

        // 增加镜头高度400（仅对指定玩家生效）
        public static method increaseHeight (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }

            ResetCam = true;
            if (ViewLevel < 16) { // 确保不超过上限（3600-400=3200，3200/200=16）
                ViewLevel = ViewLevel + 2; // 增加400高度（400/200=2）
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
                X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
            }
        }

        // 减少镜头高度400（仅对指定玩家生效）
        public static method decreaseHeight (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }

            ResetCam = true;
            if (ViewLevel > 5) { // 确保不低于下限（600+400=1000，1000/200=5）
                ViewLevel = ViewLevel - 2; // 减少400高度（400/200=2）
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
                X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
            }
        }
    }

    // 滚轮控制镜头
    // 初始化就调用
    function onInit ()  {
        //注册滚轮事件
        hardware.regWheelEvent(function (){
            integer delta = DzGetWheelDelta(); //滚轮变化量
            // 鼠标不在游戏内或焦点在UI控件上则不处理
            if ((!DzIsMouseOverUI()) || DzGetMouseFocus() != 0) {return;}
            ResetCam = true; //标记需要重置镜头属性
            if (!HeightLocked) {
                // 使用 600 ~ 3600 的高度范围（步长 200）
                if (delta < 0) { //滚轮下滑 -> 拉远
                    if (ViewLevel < 18) {ViewLevel = ViewLevel + 1;} //上限 3600/200=18
                } else { //滚轮上滑 -> 拉近
                    if (ViewLevel > 3) {ViewLevel = ViewLevel - 1;} //下限 600/200=3
                }
            } else {
                // 锁定时维持当前高度
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
            }
            X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)); //记录滚动前的镜头角度
        });
        //注册每帧渲染事件
        hardware.regUpdateEvent(function (){
            if (ResetCam) {//重设镜头角度和高度
                SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, X_ANGLE, 0 );
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, WheelSpeed);
                ResetCam = false;
            }
        });
        //注册按下键码为145的按键(ScrollLock)事件
        DzTriggerRegisterKeyEventByCode( null, 145, 1, false, function (){
            WideScr = !WideScr;
            DzEnableWideScreen(WideScr);
        });
    }
}

//! endzinc
#endif
