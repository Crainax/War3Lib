#ifndef CameraIncluded
#define CameraIncluded

#include "Crainax/ui/base/HardwellEvent.j"
//! zinc
/*
鼠标滚轮控制视距
一键切换宽屏模式
made by 裂魂
2018/10/19
*/
library CameraControl requires HardwellEvent{

    integer ViewLevel  = 8;     //初始视野等级
    boolean ResetCam   = false; //开启重置镜头属性标识
    real    WheelSpeed = 0.1;   //镜头变化平滑度
    boolean WideScr    = false; //是否是宽屏
    real    X_ANGLE    = 304;   //默认X轴角度

    public struct cameraControl {
        // 打开滚轮控制镜头高度
        public static method openWheel () {DoNothing();}
    }

    // 滚轮控制镜头
    // 初始化就调用
    function onInit ()  {
        //注册滚轮事件
        hardwellEvent.RegWheelEvent(function (){
            integer delta = DzGetWheelDelta(); //滚轮变化量
            if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应鼠标滚轮
            ResetCam = true; //标记需要重置镜头属性
            if (delta < 0) { //滚轮下滑
                if (ViewLevel < 14) {ViewLevel = ViewLevel + 1;} //视野等级上限
            } else { //滚轮上滑
                if (ViewLevel > 3) {ViewLevel = ViewLevel - 1;} //视野等级下限
            }
            X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)); //记录滚动前的镜头角度
        });
        //注册每帧渲染事件
        hardwellEvent.RegUpdateEvent(function (){
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
