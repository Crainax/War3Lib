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

        // 防抖测试状态
        public static integer utDebounceCount = 0;
        public static boolean utDebounceFirstSent = false;
        public static boolean utDebounceSecondSent = false;
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

        // route: utDebounce (防抖测试)
        syncBus.onDataSync("utDebounce", function () -> boolean {
            UTSyncBusState.utDebounceCount += 1;
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
	//输入 s3测试   测试防抖功能：第一次发送成功，第二次在冷却期内被阻止
    function TTestUTSyncBus3 (player p) {
        trigger tr; trigger sendTr;

        RegisterRoutes();

        // reset state
        UTSyncBusState.utDebounceCount = 0;
        UTSyncBusState.utDebounceFirstSent = false;
        UTSyncBusState.utDebounceSecondSent = false;

        // delay send slightly to avoid registration/send race
        sendTr = CreateTrigger();
        TriggerRegisterTimerEventSingle(sendTr, 0.03);
        TriggerAddCondition(sendTr, Condition(function () -> boolean {
            // 第一次发送应该成功
            UTSyncBusState.utDebounceFirstSent = syncBus.DzSyncDataExDebounce("utDebounce", "first", 10);
            // 立即第二次发送应该被阻止（冷却期10个tick = 0.5秒）
            UTSyncBusState.utDebounceSecondSent = syncBus.DzSyncDataExDebounce("utDebounce", "second", 10);
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        sendTr = null;

        // verify with a longer delay
        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.30);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            boolean ok; string msg;
            // 应该只有第一次发送成功，第二次被阻止
            ok = (UTSyncBusState.utDebounceFirstSent && !UTSyncBusState.utDebounceSecondSent && UTSyncBusState.utDebounceCount == 1);
            if (ok) {
                msg = "[syncBus][utDebounce] PASS firstSent=" + B2S(UTSyncBusState.utDebounceFirstSent) + ", secondSent=" + B2S(UTSyncBusState.utDebounceSecondSent) + ", count=" + I2S(UTSyncBusState.utDebounceCount);
            } else {
                msg = "[syncBus][utDebounce] FAIL firstSent=" + B2S(UTSyncBusState.utDebounceFirstSent) + ", secondSent=" + B2S(UTSyncBusState.utDebounceSecondSent) + ", count=" + I2S(UTSyncBusState.utDebounceCount);
            }
            BJDebugMsg(msg);
            DestroyTrigger(GetTriggeringTrigger());
            msg = null;
            return true;
        }));
        tr = null; p = null;
    }
	//输入 s4测试   测试防抖功能：冷却期结束后可以再次发送
    function TTestUTSyncBus4 (player p) {
        trigger tr; trigger sendTr1; trigger sendTr2;

        RegisterRoutes();

        // reset state
        UTSyncBusState.utDebounceCount = 0;
        UTSyncBusState.utDebounceFirstSent = false;
        UTSyncBusState.utDebounceSecondSent = false;

        // 第一次发送
        sendTr1 = CreateTrigger();
        TriggerRegisterTimerEventSingle(sendTr1, 0.03);
        TriggerAddCondition(sendTr1, Condition(function () -> boolean {
            UTSyncBusState.utDebounceFirstSent = syncBus.DzSyncDataExDebounce("utDebounce", "first", 5);
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        sendTr1 = null;

        // 等待冷却期结束后第二次发送
        sendTr2 = CreateTrigger();
        TriggerRegisterTimerEventSingle(sendTr2, 0.35); // 5个tick * 0.05秒 = 0.25秒，再加一点缓冲
        TriggerAddCondition(sendTr2, Condition(function () -> boolean {
            UTSyncBusState.utDebounceSecondSent = syncBus.DzSyncDataExDebounce("utDebounce", "second", 5);
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        sendTr2 = null;

        // verify with a longer delay
        tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr, 0.60);
        TriggerAddCondition(tr, Condition(function () -> boolean {
            boolean ok; string msg;
            // 两次发送都应该成功
            ok = (UTSyncBusState.utDebounceFirstSent && UTSyncBusState.utDebounceSecondSent && UTSyncBusState.utDebounceCount == 2);
            if (ok) {
                msg = "[syncBus][utDebounce-delay] PASS firstSent=" + B2S(UTSyncBusState.utDebounceFirstSent) + ", secondSent=" + B2S(UTSyncBusState.utDebounceSecondSent) + ", count=" + I2S(UTSyncBusState.utDebounceCount);
            } else {
                msg = "[syncBus][utDebounce-delay] FAIL firstSent=" + B2S(UTSyncBusState.utDebounceFirstSent) + ", secondSent=" + B2S(UTSyncBusState.utDebounceSecondSent) + ", count=" + I2S(UTSyncBusState.utDebounceCount);
            }
            BJDebugMsg(msg);
            DestroyTrigger(GetTriggeringTrigger());
            msg = null;
            return true;
        }));
        tr = null; p = null;
    }
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
