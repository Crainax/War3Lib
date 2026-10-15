#ifndef UTMlsProbeIncluded
#define UTMlsProbeIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTMlsProbe requires MlsProbe, UnitTestFramwork {
    integer stage = 0;
    integer count = 0;
    integer requestId = 0;
    boolean haveCount = false;
    timer watchdog = null;

    function Report(string text) {
        BJDebugMsg("[MlsProbe] " + text);
        DzWriteLog("[MlsProbe] " + text);
    }
    function Send(string tag, string payload, integer nextStage) {
        boolean sent;
        if (stage != 0) { Report("Request pending; wait for response/timeout."); return; }
        stage = nextStage;
        sent = MlsProbeSend(Player(0), tag, payload);
        assert.Boolean(sent, "[MlsProbe] transport accepted " + tag);
        if (!sent) { stage = 0; return; }
        TimerStart(watchdog, 10.0, false, function() {
            assert.Boolean(false, "[MlsProbe] response timeout; check MLS path/console");
            Report("Timeout: restart map before retrying a write (outcome unknown).");
            stage = -1;
        });
    }
    function Read() { Send("MlsProbeRead", "", 2); }
    function Init() {
        Report("Local slot 0 only. s1=ping, s2=save +1, s3=read. Reopen map to verify persistence.");
        UnitTestAutoTimer(3.0, 0.0, function() {
            Send("MlsProbePing", "hello", 1);
        }, null);
    }
    function TTestUTMlsProbe1(player p) {
        if (p == Player(0)) Send("MlsProbePing", "hello", 1);
    }
    function TTestUTMlsProbe2(player p) {
        if (p != Player(0) || stage != 0) return;
        if (!haveCount) { Report("Read baseline first with s3."); return; }
        requestId += 1;
        Send("MlsProbeWrite", I2S(requestId), 3);
    }
    function TTestUTMlsProbe3(player p) {
        if (p == Player(0)) Read();
    }
    function onInit() {
        trigger tr;
        watchdog = CreateTimer();
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbePong", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 1) return;
            PauseTimer(watchdog);
            stage = 0;
            assert.String(DzGetTriggerSyncData(), "hello", "[MlsProbe] event round trip");
            Read();
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeReadResult", true);
        TriggerAddAction(tr, function() {
            string value = DzGetTriggerSyncData();
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 2) return;
            PauseTimer(watchdog);
            stage = 0;
            assert.String(I2S(S2I(value)), value, "[MlsProbe] valid archive integer");
            if (haveCount) assert.Integer(S2I(value), count, "[MlsProbe] same-session readback");
            count = S2I(value);
            haveCount = true;
            Report("Read count=" + value + "; compare with last session's saved count.");
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeWriteResult", true);
        TriggerAddAction(tr, function() {
            integer value = S2I(DzGetTriggerSyncData());
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 3) return;
            PauseTimer(watchdog);
            stage = 0;
            assert.Integer(value, count + 1, "[MlsProbe] save acknowledgement +1");
            count = value;
            Report("Saved count=" + I2S(count) + "; restart map to verify durable readback.");
            Read();
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeError", true);
        DzTriggerRegisterSyncData(tr, "_mlroomfail", true);
        TriggerAddAction(tr, function() {
            PauseTimer(watchdog);
            stage = -1;
            assert.Boolean(false, "[MlsProbe] server error");
            Report(DzGetTriggerSyncData());
        });
        tr = null;
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            if (str == "s1") TTestUTMlsProbe1(GetTriggerPlayer());
            else if (str == "s2") TTestUTMlsProbe2(GetTriggerPlayer());
            else if (str == "s3") TTestUTMlsProbe3(GetTriggerPlayer());
        });
        Init();
    }
}
//! endzinc
#endif
