#ifndef UTSyncBusIncluded
#define UTSyncBusIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSyncBus requires SyncBus {

    public struct UTSyncBusState [] {
        public static boolean registered = false;
        public static boolean ut1Fired = false;
        public static string ut1Payload = "";
        public static integer ut1Pid = 0;
        public static integer ut1Count = 0;

        public static integer ut2Count = 0;
    }

    private function RegisterRoutes() {
        if (UTSyncBusState.registered) { return; }
        UTSyncBusState.registered = true;

        // route: ut1
        syncBus.onDataSync("ut1", function () -> boolean {
            player p; string payload;

            p = syncBus.getPlayer();
            payload = syncBus.getPayload();

            UTSyncBusState.ut1Fired = true;
            UTSyncBusState.ut1Payload = payload;
            UTSyncBusState.ut1Pid = GetConvertedPlayerId(p);
            UTSyncBusState.ut1Count += 1;

            p = null; payload = null;
            return true;
        });

        // route: ut2 (register two callbacks to verify fan-out)
        syncBus.onDataSync("ut2", function () -> boolean {
            UTSyncBusState.ut2Count += 1;
            return true;
        });
        syncBus.onDataSync("ut2", function () -> boolean {
            UTSyncBusState.ut2Count += 1;
            return true;
        });
    }

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

	//输入 s1测试   输入一次就行PASS是正常的  输入太多FAIL是正常的不要多次调用
    function TTestUTSyncBus1 (player p) {
        trigger tr; trigger sendTr;

        RegisterRoutes();

        // reset state
        UTSyncBusState.ut1Fired = false;
        UTSyncBusState.ut1Payload = "";
        UTSyncBusState.ut1Pid = 0;
        UTSyncBusState.ut1Count = 0;

        // delay send slightly to avoid registration/send race
        sendTr = CreateTrigger();
        TriggerRegisterTimerEventSingle(sendTr, 0.03);
        TriggerAddCondition(sendTr, Condition(function () -> boolean {
            syncBus.DzSyncDataEx("ut1", "hello");
            syncBus.DzSyncDataEx("ut1", "world");
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        sendTr = null;

        // verify with a longer delay
        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.30);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            boolean ok; string msg;
            ok = (UTSyncBusState.ut1Fired && UTSyncBusState.ut1Count == 2);
            if (ok) {
                msg = "[syncBus][ut1] PASS count=" + I2S(UTSyncBusState.ut1Count) + ", lastPid=" + I2S(UTSyncBusState.ut1Pid) + ", lastPayload='" + UTSyncBusState.ut1Payload + "'";
            } else {
                msg = "[syncBus][ut1] FAIL count=" + I2S(UTSyncBusState.ut1Count) + ", lastPid=" + I2S(UTSyncBusState.ut1Pid) + ", lastPayload='" + UTSyncBusState.ut1Payload + "'";
            }
            BJDebugMsg(msg);
            DestroyTrigger(GetTriggeringTrigger());
            msg = null;
            return true;
        }));
        tr = null; p = null;
    }

	//输入 s2测试   输入一次就行PASS是正常的  输入太多FAIL是正常的不要多次调用
    function TTestUTSyncBus2 (player p) {
        trigger tr; trigger sendTr;

        RegisterRoutes();

        // reset state
        UTSyncBusState.ut2Count = 0;

        // delay send slightly to avoid registration/send race
        sendTr = CreateTrigger();
        TriggerRegisterTimerEventSingle(sendTr, 0.03);
        TriggerAddCondition(sendTr, Condition(function () -> boolean {
            syncBus.DzSyncDataEx("ut2", "x");
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        sendTr = null;

        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.30);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            boolean ok; string msg;
            ok = (UTSyncBusState.ut2Count == 2);
            if (ok) {
                msg = "[syncBus][ut2] PASS callbacks=" + I2S(UTSyncBusState.ut2Count);
            } else {
                msg = "[syncBus][ut2] FAIL callbacks=" + I2S(UTSyncBusState.ut2Count);
            }
            BJDebugMsg(msg);
            DestroyTrigger(GetTriggeringTrigger());
            msg = null;
            return true;
        }));
        tr = null; p = null;
    }
	function TTestUTSyncBus3 (player p) {}
	function TTestUTSyncBus4 (player p) {}
	function TTestUTSyncBus5 (player p) {}
	function TTestUTSyncBus6 (player p) {}
	function TTestUTSyncBus7 (player p) {}
	function TTestUTSyncBus8 (player p) {}
	function TTestUTSyncBus9 (player p) {}
	function TTestUTSyncBus10 (player p) {}
	function TTestActUTSyncBus1 (string str) {
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
            BJDebugMsg("[syncBus] 单元测试已加载");
            // ensure routes are registered very early
            RegisterRoutes();
            Init();
            DestroyTrigger(GetTriggeringTrigger());
        }));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSyncBus1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSyncBus1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSyncBus2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSyncBus3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSyncBus4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSyncBus5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSyncBus6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSyncBus7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSyncBus8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSyncBus9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSyncBus10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
