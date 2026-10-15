#ifndef UTMlsProbeIncluded
#define UTMlsProbeIncluded
/*
MLS 本地联调记录（2026-10-15～2026-10-16；KKWE；玩家槽位 0）

运行配置：
  KKWE EnableMlScript=1
  MlScriptFolder=D:/War3/Library/War3Lib/CloudScripts/MlsProbe
  魔兽目录/kkapi_local_plugin.ini：[DzAPI] MLS-MsGetEnvType=-1
  编译：War3Lib VERSION_UNITTEST + vjassc，空白单测地图；不依赖 Xlimon。

命令与已验证结果：
  s1：发送 hello，云端原样回传；event round trip PASS，后续版本直接打印 Pong payload。
  s2：玩家 count 加 1、score 加 10，保存后读取；s3：只读玩家字段。
      旧版仅 count=1 的存档兼容补 score=0；保存后 count=2、score=10，重开仍读到 2、10。
      MsGetScriptArchive 返回整段字符串，JSON 是本测试的序列化格式。
      同局读取使用 Lua 缓存，不能单独证明持久化；重开日志 + INI 文件共同证明本地落盘。
  s4：MsGAGet；s5：MsGASet 固定值 73100；s6：MsGAIncrby 加 7。
      独立 key=war3lib:mlsprobe:ga:v1；Set/Get=73100，Incrby/Get=73107，重开仍为 73107。
      跨局验证必须先 s4，不能先 s5 覆盖旧值。启动不写入、不清零全局数据。
  s7：100 人紧凑 JSON，记录格式 [10位字符串UID,"一二三四五六#2134",999]。
      UID=1000000001～1000000100；名字 UTF-8 为 23 字节；中文不转义；实际共 4501 字节。
  s8：4095、4096、4097、4501 字节分别 Set 后 Get，四项均成功且完整字符串相等。
      当前本地插件未在文档的 4096 字节边界拒绝写入；只证明至少支持本次 4501 字节。
      不代表容量无限，不代表线上限制相同；正式设计仍按文档或线上实测约束。

实际存储位置（同一文件，不是 dz_w3_plugin.ini）：
  D:/Program Files (x86)/Warcraft III Frozen Throne/kkapi_local_plugin.ini
  [DzAPI]
  MLS-ScriptArchive-0={"war3lib_mls_probe_count":2,"war3lib_mls_probe_score":10}
  GlobalArchive:local:GAKV-war3lib:mlsprobe:ga:v1=73107
  边界测试 key 前缀：GlobalArchive:local:GAKV-war3lib:mlsprobe:size:v1:
  INI 对名字中的 # 转义为 \#，100 人榜单原始文件值为 4601 字节；接口读回仍为 4501。

日志证据（目录：魔兽目录/War3Lib/日志）：
  log-2026-10-15-23-41-58-P1.log、log-2026-10-15-23-50-12-P1.log：单字段保存及跨局读回。
  log-2026-10-16-00-10-48-P1.log、log-2026-10-16-00-11-32-P1.log：双字段、GA 读写及跨局。
  log-2026-10-16-01-29-12-P1.log：hello 明文、实际 JSON 字节数及四组存储边界。

兼容与验收边界：
  首次 GA 缺失值曾返回 JSON null（userdata: 00000000），不能只用 value==nil 判断。
  ga_probe.lua 已做空值归一化；缺失值分支修复经离线测试，尚未在游戏内重新制造缺失值验证。
  Report 的 trace/info 双份日志来自双日志入口，不表示请求执行两次。
  MsGA* 结果以异步回调和读回为准；请求返回的事务号不等于存储成功。
  未验证：线上平台、多人同步、跨房间并发、不同地图隔离、故障恢复保证。
  超限成功是本地观测，不据此推断其他项目也使用 MLS 或相同后端。
*/
#undef OriginMapUnitTestMode
//! zinc
library UTMlsProbe requires MlsProbe, UnitTestFramwork {
    integer stage = 0;
    integer count = 0;
    integer requestId = 0;
    boolean haveCount = false;
    integer score = 0;
    boolean haveScore = false;
    boolean checkScore = false;
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
        TimerStart(watchdog, 60.0, false, function() {
            assert.Boolean(false, "[MlsProbe] response timeout; check MLS path/console");
            Report("Timeout: restart map before retrying a write (outcome unknown).");
            stage = -1;
        });
    }
    function Read() { Send("MlsProbeRead", "", 2); }
    function Init() {
        Report("s1=ping; s2=player count+1 score+10; s3=player read; s4=GA get; s5=GA set 73100; s6=GA +7.");
        Report("GA key=war3lib:mlsprobe:ga:v1. Reopen then s4 BEFORE s5 to check persistence.");
        Report("s7=100-player JSON byte measurement; s8=4095/4096/4097/rank100 storage boundaries.");
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
            Report("Pong payload=" + DzGetTriggerSyncData());
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
            checkScore = true;
            Report("Saved count=" + I2S(count) + "; restart map to verify durable readback.");
            Read();
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeDetail", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() == Player(0)) Report("Player JSON=" + DzGetTriggerSyncData());
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeScore", true);
        TriggerAddAction(tr, function() {
            string value = DzGetTriggerSyncData();
            if (DzGetTriggerSyncPlayer() != Player(0)) return;
            assert.String(I2S(S2I(value)), value, "[MlsProbe] second field integer");
            if (haveScore) {
                if (checkScore) assert.Integer(S2I(value), score + 10, "[MlsProbe] second field +10");
                else assert.Integer(S2I(value), score, "[MlsProbe] second field unchanged");
            }
            score = S2I(value);
            haveScore = true;
            checkScore = false;
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeGAResult", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 4) return;
            PauseTimer(watchdog);
            stage = 0;
            Report("GA Get value=" + DzGetTriggerSyncData());
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeGACheck", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 4) return;
            assert.Boolean(true, "[MlsProbeGA] cloud verified write then Get");
            Report("GA verified value=" + DzGetTriggerSyncData());
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsSizeReport", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() == Player(0)) Report("SIZE " + DzGetTriggerSyncData());
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsSizeDone", true);
        TriggerAddAction(tr, function() {
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 5) return;
            PauseTimer(watchdog);
            stage = 0;
            Report("SIZE DONE " + DzGetTriggerSyncData());
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "MlsProbeGAError", true);
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
            else if (GetTriggerPlayer() == Player(0)) {
                if (str == "s4") Send("MlsProbeGA", "get", 4);
                else if (str == "s5") Send("MlsProbeGA", "set", 4);
                else if (str == "s6") Send("MlsProbeGA", "incr", 4);
                else if (str == "s7") Send("MlsSize", "measure", 5);
                else if (str == "s8") Send("MlsSize", "boundary", 5);
            }
        });
        Init();
    }
}
//! endzinc
#endif
