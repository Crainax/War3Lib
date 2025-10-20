#ifndef UTSyncDelayIncluded
#define UTSyncDelayIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "D:/War3/Library/War3Lib/Jass/learn/SyncDelay.j"

//! zinc

//自动生成的文件
library UTSyncDelay requires SyncDelay {

	unit H [];
	uiText txt = 0;

	function Init () {

		H[1] = CreateUnit(Player(0), 'Edem', 0, 0, 0);
		H[2] = CreateUnit(Player(1), 'Edem', 0, 0, 0);

		syncBus.onDataSync("Portal", function () -> boolean {
			string str; player p; integer index; real x; real y; real distance; real facing; integer i;
			for (1 <= i <= 200) {
				GetRandomInt(0,100);
			}
			str = syncBus.getPayload();
			p = syncBus.getPlayer();
			index = GetConvertedPlayerId(p);
			x = GetRandomReal(-6000,6000);
			y = GetRandomReal(-6000,6000);
			distance = GetRandomReal(100,200);
			facing = GetRandomReal(0,360);
			x = YDWECoordinateX(x + distance *CosBJ(facing));
			y = YDWECoordinateY(y + distance * SinBJ(facing));
			PanCameraToTimedForPlayer(GetOwningPlayer(H[index]),x,y,0.2);
			DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", x, y));
			SetUnitPosition(H[index],x,y);
			DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", x, y));
			str = null; p = null;
			return true;
		});


		TimerStart(CreateTimer(),0.1,true,function (){
			if (GetLocalPlayer() == Player(0)) {
				syncBus.DzSyncDataEx("Portal", ""); //触发数据传送
			}
		});

		TimerStart(CreateTimer(),0.2,true,function (){
			if (GetLocalPlayer() == Player(1)) {
				syncBus.DzSyncDataEx("Portal", ""); //触发数据传送
			}
		});

		TimerStart(CreateTimer(),0.01,true,function (){
			integer i;
			integer a;
			for (1 <= i <= 200) {
				a = GetRandomInt(0,100);
			}
		});

		TimerStart(CreateTimer(),5,true,function (){
			txt.setText(I2S(GetRandomInt(-10000,10000)));
		});

		txt = uiText.create(DzGetGameUI())
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setAlign(1)
			.setText("内容");

		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);
	}

	function TTestUTSyncDelay1 (player p) {



	}
	function TTestUTSyncDelay2 (player p) {}
	function TTestUTSyncDelay3 (player p) {}
	function TTestUTSyncDelay4 (player p) {}
	function TTestUTSyncDelay5 (player p) {}
	function TTestUTSyncDelay6 (player p) {}
	function TTestUTSyncDelay7 (player p) {}
	function TTestUTSyncDelay8 (player p) {}
	function TTestUTSyncDelay9 (player p) {}
	function TTestUTSyncDelay10 (player p) {}
	function TTestActUTSyncDelay1 (string str) {
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

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[SyncDelay] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSyncDelay1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSyncDelay1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSyncDelay2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSyncDelay3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSyncDelay4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSyncDelay5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSyncDelay6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSyncDelay7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSyncDelay8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSyncDelay9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSyncDelay10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
