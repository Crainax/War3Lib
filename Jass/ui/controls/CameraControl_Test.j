#ifndef UTCameraControlIncluded
#define UTCameraControlIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/ui/controls/CameraControl.j"

//! zinc

//自动生成的文件
// 测试命令：
// -cam lock：锁定镜头高度并提示
// -cam unlock：解锁镜头高度并提示
library UTCameraControl requires CameraControl {

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTCameraControl1 (player p) {}
	function TTestUTCameraControl2 (player p) {}
	function TTestUTCameraControl3 (player p) {}
	function TTestUTCameraControl4 (player p) {}
	function TTestUTCameraControl5 (player p) {}
	function TTestUTCameraControl6 (player p) {}
	function TTestUTCameraControl7 (player p) {}
	function TTestUTCameraControl8 (player p) {}
	function TTestUTCameraControl9 (player p) {}
	function TTestUTCameraControl10 (player p) {}
	function TTestActUTCameraControl1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		} else if (paramS[0] == "cam") {
			if (num >= 2) {
				if (paramS[1] == "lock") {
					cameraControl.lockHeight();
					BJDebugMsg("[CameraControl] 已锁定镜头高度");
				} else if (paramS[1] == "unlock") {
					cameraControl.unlockHeight();
					BJDebugMsg("[CameraControl] 已解锁镜头高度");
				}
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[CameraControl] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTCameraControl1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTCameraControl1(GetTriggerPlayer());
			else if(str == "s2") TTestUTCameraControl2(GetTriggerPlayer());
			else if(str == "s3") TTestUTCameraControl3(GetTriggerPlayer());
			else if(str == "s4") TTestUTCameraControl4(GetTriggerPlayer());
			else if(str == "s5") TTestUTCameraControl5(GetTriggerPlayer());
			else if(str == "s6") TTestUTCameraControl6(GetTriggerPlayer());
			else if(str == "s7") TTestUTCameraControl7(GetTriggerPlayer());
			else if(str == "s8") TTestUTCameraControl8(GetTriggerPlayer());
			else if(str == "s9") TTestUTCameraControl9(GetTriggerPlayer());
			else if(str == "s10") TTestUTCameraControl10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
