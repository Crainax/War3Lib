#ifndef HardwareIncluded
#define HardwareIncluded

#include "BlizzardAPI.j"
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
结构体
硬件事件(按/滑/帧事件)
*/
library Hardware requires BzAPI {

	public struct hardware {
		// 注册一个左键事件
		static method regLeftClickEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_LEFT,FRAME_EVENT_KEY_UP,false,func);
		}
		// 注册一个左键按下事件
		static method regLeftDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_LEFT,FRAME_EVENT_KEY_PRESSED,false,func);
		}
		// 注册一个右键按下事件
		static method regRightClickEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_RIGHT,FRAME_EVENT_KEY_UP,false,func);
		}
		// 注册一个滚轮事件
		static method regWheelEvent (code func) {
			if (trWheel == null) {trWheel = CreateTrigger();}
			TriggerAddCondition(trWheel, Condition(func));
		}
		// 注册一个绘制事件
		static method regUpdateEvent (code func) {
			if (trUpdate == null) {trUpdate = CreateTrigger();}
			TriggerAddCondition(trUpdate, Condition(func));
		}
		// 注册一个窗口变化事件
		static method regResizeEvent (code func) {
			if (trResize == null) {trResize = CreateTrigger();}
			TriggerAddCondition(trResize, Condition(func));
		}

		private {
			static trigger trWheel = null;
			static trigger trUpdate = null;
			static trigger trResize = null;
		}
		static method onInit () {
			// 滚轮事件
			DzTriggerRegisterMouseWheelEventByCode(null,false,function (){
				TriggerEvaluate(trWheel);
			});
			// 帧绘制事件
			DzFrameSetUpdateCallbackByCode(function (){
				TriggerEvaluate(trUpdate);
			});
			// 窗口大小变化事件
			DzTriggerRegisterWindowResizeEventByCode(null, false, function (){
				TriggerEvaluate(trResize);
			});
		}
	}
}

//! endzinc
#endif
