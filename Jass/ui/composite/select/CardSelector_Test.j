#ifndef UTCardSelectorIncluded
#define UTCardSelectorIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTCardSelector requires Selector {
    private selectData active[];
    private integer calls[];
    private boolean rejectFirst[];
    private boolean protocolBusy = false;
    private integer protocolCalls = 0;
    private selectData protocolData = 0;
    private integer protocolToken = 0;

    function TestCardProtocol(player p) {
        selectData oldData;
        selectData newData;
        integer oldId;
        integer oldToken;
        integer token;
        if (protocolBusy) {return;}
        protocolBusy = true; protocolCalls = 0;
        oldData = selectData.create(p, 1);
        oldId = oldData; oldToken = oldData.getSessionToken();
        oldData.destroy();
        newData = selectData.create(p, 1);
        token = newData.getSessionToken();
        protocolData = newData; protocolToken = token;
        assert.Integer(newData, oldId, "复用数据 ID");
        assert.Boolean(token != oldToken, "复用 ID 时更换 token");
        newData.registerClick(function() {
            protocolCalls += 1;
            assert.Integer(GetSelectPos(), 1, "仅合法牌位能到达回调");
            GetSelectData().destroy();
        });
        if (GetLocalPlayer() == p) {
            syncBus.DzSyncDataEx("Select", "D," + I2S(newData) + "," + I2S(oldToken) + ",1");
            syncBus.DzSyncDataEx("Select", "D," + I2S(newData) + "," + I2S(token) + ",2");
            syncBus.DzSyncDataEx("Select", "D," + I2S(newData) + "," + I2S(token) + ",01");
        } else {
            // 多人测试时，其他客户端尝试替 owner 选择，必须被拒绝。
            syncBus.DzSyncDataEx("Select", "D," + I2S(newData) + "," + I2S(token) + ",1");
        }
        UnitTestAutoTimer(1.0, 1.0, function() {
            string packet;
            assert.Integer(protocolCalls, 0, "旧 token、越界、非规范编码和非 owner 包全部拒绝");
            if (protocolData.isExist()) {
                if (protocolData.getSessionToken() == protocolToken && GetLocalPlayer() == protocolData.owner) {
                    packet = "D," + I2S(protocolData) + "," + I2S(protocolToken) + ",1";
                    syncBus.DzSyncDataEx("Select", packet);
                    syncBus.DzSyncDataEx("Select", packet);
                }
            }
        }, function() {
            assert.Integer(protocolCalls, 1, "合法包结算一次，重复包被拒绝");
            if (protocolData.isExist()) {
                if (protocolData.getSessionToken() == protocolToken) {protocolData.destroy();}
            }
            protocolData = 0; protocolToken = 0;
            protocolBusy = false;
        });
    }

    function CreateCardSelectorTest(player p, integer count, boolean reject) {
        integer pid = GetPlayerId(p);
        integer i;
        selectData sd = active[pid];
        if (sd.isExist()) {sd.destroy();}
        sd = selectData.create(p, count);
        active[pid] = sd;
        calls[pid] = 0;
        rejectFirst[pid] = reject;
        sd.title = "选择一份祝福";
        for (1 <= i <= count) {SaveInteger(HASH_SELECT, sd, i, 100 + i);}
        sd.reflectIcon(function() {
            CallbackSelectContent("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp");
        });
        sd.reflectName(function() {
            CallbackSelectContent("|cffffd84a祝福 " + I2S(GetSelectPosAsync()) + "|r");
        });
        sd.reflectDescription(function() {
            CallbackSelectContent("属性提升 +" + I2S(GetSelectPosAsync() * 20) + "|n|n点击选择此项|n|n|cffaaaaaa沿用 selectData 收包|r");
        });
        sd.registerEnter(function() {
            BJDebugMsg("[CardSelector 悬停] " + I2S(GetSelectPosAsync()));
        });
        sd.registerClick(function() {
            selectData data = GetSelectData();
            integer pid = GetPlayerId(data.owner);
            integer pos = GetSelectPos();
            calls[pid] += 1;
            assert.Boolean(pos >= 1 && pos <= data.count, "卡牌位置必须为 1..count");
            assert.Integer(LoadInteger(HASH_SELECT, data, pos), 100 + pos, "保留原 HASH_SELECT 数据映射");
            BJDebugMsg("[CardSelector 同步回调] 玩家 " + I2S(pid + 1) + "，选项 " + I2S(pos) + "，次数 " + I2S(calls[pid]));
            if (rejectFirst[pid]) {
                rejectFirst[pid] = false;
                BJDebugMsg("[CardSelector] 本次模拟拒绝，保留数据；可以再次选择。");
                return;
            }
            data.destroy();
            active[pid] = 0;
        });
        sd.registerClose(function() {
            selectData data = GetSelectData();
            active[GetPlayerId(data.owner)] = 0;
            data.destroy();
        });
        sd.btn1Text = "刷新展示";
        sd.registerBtn1(function() {
            GetSelectData().title = "刷新完成，请选择";
        });
        sd.registerFail(function() {
            selectData data = GetSelectData();
            BJDebugMsg("[CardSelector] 创建失败（数量只支持 1～5）");
            active[GetPlayerId(data.owner)] = 0;
            data.destroy();
        });
        sd.showCards();
    }

    function CreateLongCardSelectorTest(player p) {
        selectData sd;
        CreateCardSelectorTest(p, 3, false);
        sd = active[GetPlayerId(p)];
        if (!sd.isExist()) {return;}
        sd.title = "正文自动换行；点击正文、图标或标题均可选择";
        sd.reflectDescription(function() {
            integer pos = GetSelectPosAsync();
            integer i;
            integer paragraphs = 4; // 返回字符串的回调必须控制总长度，此处用于检查普通TEXT的长文布局
            string content = "|cffffd84a【开头】|r|n正文左上对齐，2号字体。";
            if (pos == 1) {
                content += "|n|n短正文，普通文本显示。|n|cff66ff66【正文结束】|r";
            } else {
                if (pos == 3) {paragraphs = 8;}
                for (1 <= i <= paragraphs) {
                    content += "|n|n|cff66ccff第 " + I2S(i) + " 段|r：力量 +20，敏捷 +15。这里是较长的说明文字，用于检查中文换行、彩色内容、正文区域点击选择。English 123。";
                }
                content += "|n|n|cff66ff66【正文结束】普通文本不支持滚轮，请控制正文长度。|r";
            }
            CallbackSelectContent(content);
        });
        sd.refreshCards();
    }

    function onInit() {
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            integer count = 0;
            boolean reject = false;
            if (command == "s1") {count = 5;}
            else if (command == "s2") {count = 3; reject = true;}
            else if (command == "s3") {count = 6;}
            else if (command == "s4") {TestCardProtocol(GetTriggerPlayer()); return;}
            else if (command == "s5") {CreateLongCardSelectorTest(GetTriggerPlayer()); return;}
            else if (SubString(command, 0, 6) == "-card ") {
                count = S2I(SubString(command, 6, StringLength(command)));
                if (count < 1 || count > 5 || command != "-card " + I2S(count)) {
                    if (GetLocalPlayer() == GetTriggerPlayer()) {BJDebugMsg("用法：-card X，X 为 1～5");}
                    return;
                }
            } else {return;}
            CreateCardSelectorTest(GetTriggerPlayer(), count, reject);
        });
		InitTestUIRuler();
        BJDebugMsg("[CardSelector] s1：5张；-card X：1～5张；s2：首次拒绝后重选；s3：非法数量；s4：同步包校验；s5：短/长/超长正文。");
    }
}
//! endzinc
#endif
