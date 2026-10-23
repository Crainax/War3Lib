#ifndef UTOreForgeProbeIncluded
#define UTOreForgeProbeIncluded
/*
独立原矿打造测试；不接入 Xlimon。云脚本：CloudScripts/OreForgeProbe/main.lua。
平台数量型道具 OFPOre 作为累计获得量；脚本存档字段 war3lib_ore_forge_probe_v1。
不会调用商城消费 API，不写普通服务器存档，不使用随机只读存档。
属性为测试编号 1..39，不代表 Xlimon 真实属性；七种不重复。

测试账号设置 OFPOre=69（1+3+15+50），首次应为 spent=0/count=0。
s1 读取；s2 F1随机花1；s3 F2锁1花3；s4 F3锁1,2花15；s5 F4锁1,2,3花50。
s6 重发F4，应REPLAY且不扣费；s7 同ID不同配方，应REQUEST_CONFLICT。
s8 重复锁定属性，应BAD_LOCKS；s9 新请求F5，余额0时应NO_ORE。
s10 只读核验固定四颗+累计69。重开后 s1/s10/s6，再对照两局全部属性日志。
每条命令等待回包；超时或保存结果未知必须重开，只读核验后重试同ID。
不提供重置/删除/增矿命令；再次运行s2..s5只取回原结果，不是新的洗炼。

【本地实测通过：2026-10-23；复用前先读】
环境：KKWE 本地 MLS 模拟，MsGetEnvType=-1，单账号、玩家槽位0，跨两局。
云脚本目录：D:/War3/Library/War3Lib/CloudScripts/OreForgeProbe。
模拟配置：kkapi_local_plugin.ini / [DzAPI] / MLS-MsGetPlayerItem-OFPOre-0=69。
这是本地模拟数量读取与持久化证据，不是线上商城或线上存档测试通过的声明。

【日志依据】
目录：D:/Program Files (x86)/Warcraft III Frozen Throne/War3Lib/日志/
第一局：log-2026-10-23-23-41-06-P1.log，463条PASS断言、0 FAIL。
  第31行：开局69|1|68|1；第58行：F1跨局REPLAY，累计消耗仍为1。
  第85/112/139行：F2/F3/F4 CREATED，累计消耗4/19/69，余额65/50/0。
  第167行：F4同局REPLAY；第172/267/362行：三种预期拒绝。
  第474/495/516/537行：四条完整STONE；第542行：69|69|0|4。
第二局：log-2026-10-23-23-42-02-P1.log，264条PASS断言、0 FAIL。
  第27/46/65/84行：四条完整STONE；第88行：开局69|69|0|4。
  第222行：F4跨局REPLAY；第227行：NO_ORE；第317行：仍69|69|0|4。
PASS数字是断言输出条数，不是独立测试用例数；trace/info双份业务日志不重复计操作。

【已确认行为】
1. 云脚本通过MsGetPlayerItem读到模拟原矿69；客户端不上传材料余额。
2. 四档价格1/3/15/50，累计消耗1->4->19->69，余额68->65->50->0。
   注意：1点档首次生成在旧轮次log-2026-10-23-23-30-48-P1.log中完成；
   新版第一局从已消耗1开始，s2是取回F1，不能描述为新版又扣了一次1点。
3. F1跨旧/新局、F4同局及跨局重放均返回REPLAY，属性与原记录一致，
   不新增石头、不重复扣费。F4锁定顺序3,1,2与1,2,3视为相同配方。
4. 同请求ID改变配方返回REQUEST_CONFLICT；重复锁定属性返回BAD_LOCKS；
   零余额新请求F5返回NO_ORE。拒绝后读回仍消耗69、余额0、4颗。
5. 四颗石头的请求ID、序号、配方、价格、锁定属性及七属性，在两局间逐项一致：
   F1：成本1，锁定无，属性1,22,8,30,21,17,12。
   F2：成本3，锁定1，属性1,2,22,8,30,21,17。
   F3：成本15，锁定1,2，属性1,2,15,35,31,28,8。
   F4：成本50，锁定1,2,3，属性1,2,3,34,28,21,14。
   每颗均为七种不同编号，范围1..39，全部指定属性存在。
6. 同时核对魔兽目录kkapi_local_plugin.ini内MLS-ScriptArchive-0：
   war3lib_ore_forge_probe_v1.spent=69、stones共4颗，全部属性与两局日志一致；
   原MlsProbe字段count=2、score=10保留。确认的是本地文件落盘与跨局读回。

【实现边界与复用注意】
消费账本、石头和请求凭证保存在同一份脚本存档；商城累计数量仍为69，
本测试没有执行MsConsumeItem。不能将结果表述为商城数量被实际扣到0。
保存成功返回后才向客户端发送属性；保存异常/结果不确定时暂停该槽位，
重开读取后重试原ID，不自动补发新请求。成功请求凭证目前随石头永久保留；
正式业务若允许删除石头，不能一并删除去重凭证。
旧轮次测试端两处无花括号范围循环被编译链错误展开，导致卡住及误报。
现已补齐花括号并核对生成JASS。编译通过不替代检查生成代码和实际运行。

【尚未验证，不得扩大结论】
- 线上平台真实道具数量读取、刷新时机、正式存储返回值与持久化保证。
- 同账号多房间并发消费、旧缓存覆盖、跨房间锁/CAS与账号/地图隔离。
- 真实断线、丢回包、云服务重启及存储故障恢复；离线mock覆盖相关分支，
  正常退出重开与上述故障不是同一种测试，不能据此宣称完整原子事务。
- math.random的初始化、跨房间序列、统计分布及不可预测性；七条合法不代表随机质量合格。
- 多人同步/OOS、25格真实平台满仓、长期请求记录容量和真实业务属性增减。
云端生成用runtime math.random，无客户端种子；严禁以本地mock替代线上证明。
本测试客户端仅接受玩家槽位0的操作；云脚本允许-1/1/2，拒绝正式环境0。
离线18组测试与操作步骤见CloudScripts/OreForgeProbe/README.md；尚未接入Xlimon。
*/
#undef OriginMapUnitTestMode
//! zinc
library UTOreForgeProbe requires OreForgeProbe, UnitTestFramwork {
    private timer watchdog = null;
    private integer stage = 0;
    private integer spent = 0;
    private integer total = 0;
    private integer count = 0;
    private integer readCount = 0;
    private boolean ready = false;
    private string expectedError = "";
    private string pendingId = "";
    private integer pendingTier = 0;
    private string stoneId[];
    private string stoneAttrs[];
    private integer stoneTier[];
    private boolean seen[];

    function Report(string text) {
        BJDebugMsg("[OreForgeProbe] " + text);
        DzWriteLog("[OreForgeProbe] " + text);
    }
    function Field(string text, string delimiter, integer pos) -> string {
        integer i = 0;
        integer start = 0;
        integer part = 0;
        integer size = StringLength(text);
        for (0 <= i < size) {
            if (SubString(text, i, i + 1) == delimiter) {
                if (part == pos) return SubString(text, start, i);
                part += 1;
                start = i + 1;
            }
        }
        if (part == pos) return SubString(text, start, size);
        return "";
    }
    function Price(integer tier) -> integer {
        if (tier == 0) return 1;
        if (tier == 1) return 3;
        if (tier == 2) return 15;
        return 50;
    }
    function CheckAttrs(string list, integer tier) {
        integer i = 0;
        integer j = 0;
        integer value = 0;
        boolean found = false;
        for (0 <= i < 7) {
            value = S2I(Field(list, ",", i));
            assert.Boolean(value >= 1 && value <= 39, "[OFP] attr range");
            for (0 <= j < i) {
                assert.Boolean(Field(list, ",", i) != Field(list, ",", j), "[OFP] no duplicate attrs");
            }
        }
        assert.String(Field(list, ",", 7), "", "[OFP] exactly seven attrs");
        for (1 <= i <= tier) {
            found = false;
            for (0 <= j < 7) { if (S2I(Field(list, ",", j)) == i) found = true; }
            assert.Boolean(found, "[OFP] requested lock present");
        }
    }
    function Send(string eventName, string payload, integer nextStage) {
        boolean accepted = false;
        if (stage != 0) { Report("Busy/unknown outcome: wait, or restart after timeout. Do not use a new request ID."); return; }
        stage = nextStage;
        Report("SEND " + eventName + " " + payload);
        TimerStart(watchdog, 60.0, false, function() {
            stage = -1;
            Report("INCONCLUSIVE TIMEOUT: restart, read archive, then retry SAME request ID.");
        });
        accepted = OreForgeProbeSend(Player(0), eventName, payload);
        if (Player(0) == GetLocalPlayer() && !accepted) Report("Transport returned false; outcome not assumed. Await response/timeout.");
    }
    function Read(integer nextStage) {
        integer i = 0;
        if (stage != 0) return;
        readCount = 0;
        for (1 <= i <= 25) {
            seen[i] = false;
        }
        expectedError = "";
        Send("OFPRead", "", nextStage);
    }
    function Forge(string id, integer tier, string locks, string rejection) {
        if (stage != 0) return;
        if (!ready) { Report("Use s1 first and wait for STATUS."); return; }
        pendingId = id;
        pendingTier = tier;
        expectedError = rejection;
        Send("OFPForge", id + "|" + I2S(tier) + "|" + locks, 2);
    }
    function onInit() {
        trigger tr = null;
        watchdog = CreateTimer();
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "OFPStone", true);
        TriggerAddAction(tr, function() {
            string text = DzGetTriggerSyncData();
            integer serial = S2I(Field(text, "|", 1));
            string attrs = Field(text, "|", 5);
            integer tier = S2I(Field(text, "|", 2));
            if (DzGetTriggerSyncPlayer() != Player(0) || (stage != 1 && stage != 3)) return;
            assert.Boolean(serial >= 1 && serial <= 25, "[OFP] stone serial");
            if (serial < 1 || serial > 25) return;
            assert.Boolean(!seen[serial], "[OFP] unique record in read");
            seen[serial] = true;
            readCount += 1;
            if (stoneAttrs[serial] != null && stoneAttrs[serial] != "") {
                assert.String(attrs, stoneAttrs[serial], "[OFP] saved attrs unchanged");
                assert.String(Field(text, "|", 0), stoneId[serial], "[OFP] saved request unchanged");
            }
            stoneId[serial] = Field(text, "|", 0);
            stoneAttrs[serial] = attrs;
            stoneTier[serial] = tier;
            CheckAttrs(attrs, tier);
            assert.Integer(S2I(Field(text, "|", 3)), Price(tier), "[OFP] saved recipe price");
            Report("STONE " + text);
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "OFPStatus", true);
        TriggerAddAction(tr, function() {
            string text = DzGetTriggerSyncData();
            integer newSpent = S2I(Field(text, "|", 1));
            integer i = 0;
            if (DzGetTriggerSyncPlayer() != Player(0) || (stage != 1 && stage != 3)) return;
            PauseTimer(watchdog);
            total = S2I(Field(text, "|", 0));
            if (ready) assert.Integer(newSpent, spent, "[OFP] ledger unchanged on read");
            spent = newSpent;
            count = S2I(Field(text, "|", 3));
            assert.Integer(readCount, count, "[OFP] all records received");
            assert.Integer(S2I(Field(text, "|", 2)), total - spent, "[OFP] balance");
            ready = true;
            Report("STATUS acquired|spent|balance|count=" + text);
            if (stage == 3) {
                assert.Integer(spent, 69, "[OFP] suite spent=69");
                assert.Integer(count, 4, "[OFP] suite count=4");
                for (1 <= i <= 4) {
                    assert.Boolean(seen[i], "[OFP] fixed suite record present");
                    assert.String(stoneId[i], "F" + I2S(i), "[OFP] suite request identity");
                    assert.Integer(stoneTier[i], i - 1, "[OFP] suite recipe identity");
                }
                Report("VERIFY FINISHED: inspect assertions; compare STONE lines with previous game's log.");
            }
            stage = 0;
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "OFPResult", true);
        TriggerAddAction(tr, function() {
            string text = DzGetTriggerSyncData();
            string outcome = Field(text, "|", 0);
            integer serial = S2I(Field(text, "|", 4));
            integer newSpent = S2I(Field(text, "|", 1));
            string attrs = Field(text, "|", 8);
            if (DzGetTriggerSyncPlayer() != Player(0) || stage != 2) return;
            PauseTimer(watchdog);
            assert.String(expectedError, "", "[OFP] request should succeed");
            assert.Boolean(outcome == "CREATED" || outcome == "REPLAY", "[OFP] result kind");
            assert.String(Field(text, "|", 3), pendingId, "[OFP] request matched");
            assert.Integer(S2I(Field(text, "|", 5)), pendingTier, "[OFP] recipe matched");
            assert.Integer(S2I(Field(text, "|", 6)), Price(pendingTier), "[OFP] server price");
            assert.Boolean(serial >= 1 && serial <= 25, "[OFP] result serial");
            if (serial < 1 || serial > 25) { stage = -1; return; }
            if (outcome == "CREATED") {
                assert.Integer(newSpent, spent + Price(pendingTier), "[OFP] charge once");
                assert.Integer(serial, count + 1, "[OFP] append one stone");
                count += 1;
            } else {
                assert.Integer(newSpent, spent, "[OFP] replay no charge");
                assert.String(attrs, stoneAttrs[serial], "[OFP] replay identical stone");
                assert.String(pendingId, stoneId[serial], "[OFP] replay saved request");
            }
            CheckAttrs(attrs, pendingTier);
            stoneAttrs[serial] = attrs;
            stoneId[serial] = pendingId;
            stoneTier[serial] = pendingTier;
            spent = newSpent;
            assert.Integer(S2I(Field(text, "|", 2)), total - spent, "[OFP] remaining ore");
            Report("RESULT " + text);
            stage = 0;
        });
        tr = CreateTrigger();
        DzTriggerRegisterSyncData(tr, "OFPError", true);
        TriggerAddAction(tr, function() {
            string text = DzGetTriggerSyncData();
            if (DzGetTriggerSyncPlayer() != Player(0)) return;
            PauseTimer(watchdog);
            if (stage == 2 && expectedError != "") {
                assert.String(text, expectedError, "[OFP] expected rejection");
                Report("REJECT " + text);
                if (text == expectedError) { stage = 0; Read(1); }
                else stage = -1;
            } else {
                Report("INCONCLUSIVE cloud error: " + text + "; restart/read before retry.");
                stage = -1;
            }
        });
        tr = null;
        UnitTestRegisterChatEvent(function() {
            string text = GetEventPlayerChatString();
            if (GetTriggerPlayer() != Player(0)) return;
            if (text == "s1") Read(1);
            else if (text == "s2") Forge("F1", 0, "", "");
            else if (text == "s3") Forge("F2", 1, "1", "");
            else if (text == "s4") Forge("F3", 2, "1,2", "");
            else if (text == "s5") Forge("F4", 3, "1,2,3", "");
            else if (text == "s6") {
                if (count < 4) Report("Complete/read F1..F4 before s6.");
                else Forge("F4", 3, "3,1,2", "");
            }
            else if (text == "s7") {
                if (count < 4) Report("Complete/read F1..F4 before s7.");
                else Forge("F4", 2, "1,2", "REQUEST_CONFLICT");
            }
            else if (text == "s8") Forge("BadLocks", 2, "1,1", "BAD_LOCKS");
            else if (text == "s9") {
                if (!ready || total != spent) Report("s9 needs confirmed zero balance. Set test total to69 and finish four crafts.");
                else Forge("F5", 0, "", "NO_ORE");
            }
            else if (text == "s10") Read(3);
        });
        Report("s1 read; s2..s5 cost1/3/15/50; s6 replay; s7 conflict; s8 invalid; s9 zero balance; s10 verify.");
        Report("Set COUNT item OFPOre=69 on dedicated test account. No auto-forging. See CloudScripts/OreForgeProbe/README.md.");
    }
}
//! endzinc
#endif
