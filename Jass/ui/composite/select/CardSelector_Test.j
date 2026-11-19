#ifndef UTCardSelectorIncluded
#define UTCardSelectorIncluded
#undef OriginMapUnitTestMode
//! zinc
//# dependency:resource/ui/cardselector_colors/green/body.blp
library UTCardSelector requires Selector {
    private selectData active[];
    private integer qualityMode[]; // 0=按牌位五色，1..5=统一品质
    private boolean blankCards[];
    private integer calls[];
    private boolean rejectFirst[];
    private boolean protocolBusy = false;
    private integer protocolCalls = 0;
    private selectData protocolData = 0;
    private integer protocolToken = 0;
    private integer protocolBtn2Calls = 0;
    private integer protocolBtn3Calls = 0;
    private selectData failedHead;
    private selectData followingHead;

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

    // G/H 覆盖旧token、非owner、额外字段、无回调、合法按钮与销毁后重复包。
    function TestCardButtonProtocol(player p) {
        selectData sd;
        integer oldToken;
        if (protocolBusy) {return;}
        protocolBusy = true; protocolBtn2Calls = 0; protocolBtn3Calls = 0;
        sd = selectData.create(p, 1);
        oldToken = sd.getSessionToken(); sd.destroy();
        sd = selectData.create(p, 1);
        protocolData = sd; protocolToken = sd.getSessionToken();
        sd.registerBtn2(function() {protocolBtn2Calls += 1;});
        if (GetLocalPlayer() == p) {
            syncBus.DzSyncDataEx("Select", "G," + I2S(sd) + "," + I2S(oldToken));
            syncBus.DzSyncDataEx("Select", "H," + I2S(sd) + "," + I2S(protocolToken));
            syncBus.DzSyncDataEx("Select", "G," + I2S(sd) + ",0" + I2S(protocolToken));
            syncBus.DzSyncDataEx("Select", "G," + I2S(sd) + "," + I2S(protocolToken) + ",2");
        } else {
            syncBus.DzSyncDataEx("Select", "G," + I2S(sd) + "," + I2S(protocolToken));
        }
        UnitTestAutoTimer(1.0, 1.0, function() {
            string packet;
            assert.Integer(protocolBtn2Calls, 0, "按钮2拒绝旧token、非owner及非法编码");
            assert.Integer(protocolBtn3Calls, 0, "未注册的按钮3不执行");
            if (!protocolData.isExist()) {return;}
            if (protocolData.getSessionToken() != protocolToken) {return;}
            protocolData.registerBtn3(function() {
                protocolBtn3Calls += 1;
                GetSelectData().destroy();
            });
            if (GetLocalPlayer() == protocolData.owner) {
                syncBus.DzSyncDataEx("Select", "G," + I2S(protocolData) + "," + I2S(protocolToken));
                packet = "H," + I2S(protocolData) + "," + I2S(protocolToken);
                syncBus.DzSyncDataEx("Select", packet);
                syncBus.DzSyncDataEx("Select", packet);
            }
        }, function() {
            assert.Integer(protocolBtn2Calls, 1, "按钮2合法包执行一次");
            assert.Integer(protocolBtn3Calls, 1, "按钮3销毁会话，重复包不再执行");
            if (protocolData.isExist()) {
                if (protocolData.getSessionToken() == protocolToken) {protocolData.destroy();}
            }
            protocolData = 0; protocolToken = 0; protocolBusy = false;
        });
    }

    private function FinishQueuedTestChoice() {GetSelectData().destroy();}

    // 同步创建三个会话，仅 owner 的表示层排队；取消中间项后直接接续末项。
    function TestCardQueue(player p) {
        selectData head = selectData.create(p, 5);
        selectData middle = selectData.create(p, 5);
        selectData tail = selectData.create(p, 5);
        head.registerClick(function FinishQueuedTestChoice);
        middle.registerClick(function FinishQueuedTestChoice);
        tail.registerClick(function FinishQueuedTestChoice);
        head.cardCanFold = true;
        head.queueCards(); middle.queueCards(); tail.queueCards();
        head.queueCards();
        selector.create(p, tail);
        if (p == GetLocalPlayer()) {
            assert.Boolean(!tail.uiSelector.isExist(), "普通窗口入口不能提前展示等待项");
            assert.Boolean(middle.hasLocalView() && tail.hasLocalView(), "两个等待项均已入队");
            assert.Boolean(head.uiCards.isExist() && !middle.uiCards.isExist() && !tail.uiCards.isExist(), "仅队首展示");
        } else {
            assert.Boolean(!head.hasLocalView() && !middle.hasLocalView() && !tail.hasLocalView(), "非 owner 无本地窗口或排队记录");
        }
        middle.destroy();
        if (p == GetLocalPlayer()) {
            assert.Boolean(head.uiCards.isExist() && tail.hasLocalView() && !tail.uiCards.isExist(), "移除中间项后队首仍在展示");
        }
        head.destroy();
        if (p == GetLocalPlayer()) {
            assert.Boolean(tail.uiCards.isExist(), "跳过已销毁的等待项，接续末项");
        }
        tail.destroy();
    }

    // 模拟两种窗口均失败后的本地状态，走真实的 Z 收包入口。
    private function SendQueueFailure(selectData sd) {
        if (GetLocalPlayer() == sd.owner && sd.uiCards.isExist()) {
            sd.uiCards.destroy();
            sd.uiCards = 0;
            syncBus.DzSyncDataEx("Select", "Z," + I2S(sd) + "," + I2S(sd.getSessionToken()));
        }
    }

    function TestCardQueueFailure(player p) {
        if (protocolBusy) {return;}
        protocolBusy = true; protocolCalls = 0;
        failedHead = selectData.create(p, 5);
        followingHead = selectData.create(p, 5);
        failedHead.registerClick(function() {});
        followingHead.registerClick(function() {});
        followingHead.registerFail(function() {
            protocolCalls += 1;
            assert.Integer(GetSelectData(), followingHead, "失败回调收到原会话");
        });
        SaveInteger(HASH_SELECT, failedHead, 1, 123);
        failedHead.queueCards();
        followingHead.queueCards();
        SendQueueFailure(failedHead);
        UnitTestAutoTimer(1.0, 1.0, function() {
            assert.Boolean(failedHead.isExist(), "未注册失败回调时保留选择数据");
            if (GetLocalPlayer() == failedHead.owner) {
                assert.Boolean(!failedHead.hasLocalView() && followingHead.uiCards.isExist(), "失败队首让位给下一项");
            }
            failedHead.queueCards();
            SendQueueFailure(followingHead);
        }, function() {
            assert.Integer(protocolCalls, 1, "已注册的失败回调在各端执行一次");
            assert.Integer(LoadInteger(HASH_SELECT, failedHead, 1), 123, "重新入队沿用原候选");
            if (GetLocalPlayer() == failedHead.owner) {
                assert.Boolean(failedHead.uiCards.isExist() && !followingHead.hasLocalView(), "重开的会话接续，保留数据的失败回调也能让位");
            } else {
                assert.Boolean(!failedHead.hasLocalView() && !followingHead.hasLocalView(), "非 owner 不参与本地排队");
            }
            failedHead.destroy(); followingHead.destroy();
            protocolBusy = false;
        });
    }

    // buttonCount 包含取消按钮，0~4分别展示无按钮至全部按钮。
    function CreateCardSelectorTest(player p, integer count, boolean reject, integer buttonCount) {
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
            if (blankCards[GetPlayerId(GetSelectDataAsync().owner)]) {CallbackSelectContent(""); return;}
            CallbackSelectContent("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp");
        });
        sd.reflectName(function() {
            if (blankCards[GetPlayerId(GetSelectDataAsync().owner)]) {CallbackSelectContent(""); return;}
            CallbackSelectContent("祝福 " + I2S(GetSelectPosAsync()));
        });
        sd.reflectDescription(function() {
            if (blankCards[GetPlayerId(GetSelectDataAsync().owner)]) {CallbackSelectContent(""); return;}
            CallbackSelectContent("属性提升 +" + I2S(GetSelectPosAsync() * 20) + "|n|n点击选择此项|n|n|cffaaaaaa沿用 selectData 收包|r");
        });
        sd.registerEnter(function() {
            assert.Boolean(false, "CardSelector不应触发selectData enter回调");
        });
        sd.registerLeave(function() {assert.Boolean(false, "CardSelector不应触发selectData leave回调");});
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
        if (buttonCount >= 1) {sd.registerClose(function() {
            selectData data = GetSelectData();
            active[GetPlayerId(data.owner)] = 0;
            data.destroy();
        });}
        sd.btn1Text = "刷新展示";
        if (buttonCount >= 2) {sd.registerBtn1(function() {
            GetSelectData().btn1Text = "刷新完成";
            BJDebugMsg("[CardSelector] btn1同步回调");
        });}
        sd.btn2Text = "按钮二";
        if (buttonCount >= 3) {sd.registerBtn2(function() {
            GetSelectData().btn2Text = "按钮二已点击";
            BJDebugMsg("[CardSelector] btn2同步回调，可重复点击");
        });}
        sd.btn3Text = "移除此按钮";
        if (buttonCount >= 4) {sd.registerBtn3(function() {
            GetSelectData().destroyBtn3();
            BJDebugMsg("[CardSelector] btn3同步回调，剩余按钮重新居中");
        });}
        sd.registerFail(function() {
            selectData data = GetSelectData();
            BJDebugMsg("[CardSelector] 创建失败（数量只支持 1～5）");
            active[GetPlayerId(data.owner)] = 0;
            data.destroy();
        });
        sd.reflectCardQuality(function() {
            integer q = qualityMode[GetPlayerId(GetSelectDataAsync().owner)];
            if (q == 0) {q = GetSelectPosAsync();}
            CallbackSelectContent(I2S(q));
        });
        sd.reflectCardTitle(function() {
            integer pid = GetPlayerId(GetSelectDataAsync().owner);
            integer q = qualityMode[pid];
            if (q == 0) {q = GetSelectPosAsync();}
            if (blankCards[pid]) {CallbackSelectContent("");}
            else if (q == 2) {CallbackSelectContent("精良祝福");}
            else if (q == 3) {CallbackSelectContent("稀有祝福");}
            else if (q == 4) {CallbackSelectContent("史诗祝福");}
            else if (q == 5) {CallbackSelectContent("传说祝福");}
            else {CallbackSelectContent("自然祝福");}
        });
        sd.showCards();
    }

    function CreateLongCardSelectorTest(player p) {
        selectData sd;
        CreateCardSelectorTest(p, 3, false, 2);
        sd = active[GetPlayerId(p)];
        if (!sd.isExist()) {return;}
        sd.reflectDescription(function() {
            integer pos = GetSelectPosAsync();
            integer i;
            integer paragraphs = 4; // 返回字符串的回调必须控制总长度，此处用于检查普通TEXT的长文布局
            string content = "|cffffd84a【开头】|r|n正文左上对齐，2号字体。，2号字体。，2号字体。，2号字体。";
            if (pos == 1) {
                content += "|n|n短正文，普通文本显示。|n|cff66ff66【正文结束】|r";
            } else {
                if (pos == 3) {paragraphs = 8;}
                for (1 <= i <= paragraphs) {
                    content += "|n|n|cff66ccff第 " + I2S(i) + " 段|r：力量 +20，敏捷 +15。这里是较长的说明文字，用于检查中文换行、彩色内容、正文区域点击选择。English 123。";
                }
                content += "|n|n|cff66ff66【正文结束】|r";
            }
            CallbackSelectContent(content);
        });
        sd.refreshCards();
    }

    private function TestCardFooters(player p) {
        integer pid = GetPlayerId(p);
        selectData sd;
        cardSelectorItem firstCard;
        cardSelectorItem emptyCard;
        blankCards[pid] = false; qualityMode[pid] = 0;
        CreateCardSelectorTest(p, 5, false, 1);
        sd = active[pid];
        assert.Boolean(sd.isExist(), "底文演示创建选择数据");
        if (!sd.isExist()) {return;}
        sd.cardCanFold = true;
        sd.btn1Text = "换一批看看";
        sd.registerBtn1(function() {
            selectData data = GetSelectData();
            SaveBoolean(HASH_SELECT, data, 0, !LoadBoolean(HASH_SELECT, data, 0));
        });
        sd.reflectName(function() {
            integer pos = GetSelectPosAsync();
            if (pos == 1) {CallbackSelectContent("守望护腕");}
            else if (pos == 2) {CallbackSelectContent("守望战甲");}
            else if (pos == 3) {CallbackSelectContent("寒冰箭");}
            else if (pos == 4) {CallbackSelectContent("坚韧");}
            else {CallbackSelectContent("旅人之靴");}
        });
        sd.reflectDescription(function() {
            integer pos = GetSelectPosAsync();
            integer i;
            string text = "护甲 +12";
            if (pos == 2) {
                for (1 <= i <= 16) {text += "|n套装效果 " + I2S(i);}
                CallbackSelectContent(text + "|n|cffffd84a【正文末行】|r");
            } else if (pos == 3) {CallbackSelectContent("对目标造成冰霜伤害并降低移动速度。");}
            else if (pos == 4) {CallbackSelectContent("[当前] 生命上限 +100|n|cffff9900[下一级]|r 生命上限 +200");}
            else if (pos == 5) {CallbackSelectContent("移动速度 +15");}
            else {CallbackSelectContent(text);}
        });
        sd.reflectCardFooter(function() {
            integer pos = GetSelectPosAsync();
            boolean alternate = LoadBoolean(HASH_SELECT, GetSelectDataAsync(), 0);
            if ((pos == 1 && !alternate) || (pos == 5 && alternate)) {CallbackSelectContent("|cFF808080守望套装(0/4)|r");}
            else if (pos == 2) {CallbackSelectContent("|cFF808080守望套装(1/4)|r");}
            else if (pos == 3) {CallbackSelectContent("|cFF00B3FF魔法消耗:|r 75");}
            else if (pos == 4) {CallbackSelectContent("|cFF00FF1E等级:|r2/3");}
        });
        sd.refreshCards();
        if (GetLocalPlayer() == p) {
            assert.Boolean(sd.uiCards.isExist(), "底文演示创建五张卡牌");
            if (!sd.uiCards.isExist()) {return;}
            firstCard = sd.uiCards.getItem(1);
            emptyCard = sd.uiCards.getItem(5);
            assert.Boolean(DzFrameIsVisible(firstCard.footer.ui) && !DzFrameIsVisible(emptyCard.footer.ui), "有底文时显示，无返回值时隐藏");
            assert.Boolean(RAbsBJ(firstCard.viewHeight - emptyCard.viewHeight) < 0.0001, "有无底文的卡牌正文高度一致");
        }
    }

    // 每个客户端只校准本地演示，用原有两个正文控件测一行、两行。
    private selectData scrollDemo = 0;
    private integer scrollToken = 0;
    private integer scrollPhase = 0;
    private integer fitLines = 1;

    private function boundaryText() {
        integer pos = GetSelectPosAsync();
        integer rows = fitLines + pos - 1;
        integer i;
        string value = "";
        if (scrollPhase == 1) {
            if (pos == 2) {CallbackSelectContent("样本|n样本");}
            else {CallbackSelectContent("样本");}
            return;
        }
        if (pos == 3) {rows = fitLines * 3;}
        for (1 <= i <= rows) {
            if (i > 1) {value += "|n";}
            if (i == rows) {value += "|cff88ffaa末行 " + I2S(i) + "|r";}
            else {value += "阅读行 " + I2S(i);}
        }
        CallbackSelectContent(value);
    }
    private function checkBoundaries() {
        cardSelectorItem firstCard;
        cardSelectorItem secondCard;
        cardSelectorItem longCard;
        real pitch;
        if (scrollPhase == 0) {return;}
        if (!scrollDemo.isExist() || scrollDemo.getSessionToken() != scrollToken || !scrollDemo.uiCards.isExist()) {
            scrollPhase = 0;
            return;
        }
        firstCard = scrollDemo.uiCards.getItem(1);
        secondCard = scrollDemo.uiCards.getItem(2);
        longCard = scrollDemo.uiCards.getItem(3);
        if (!firstCard.measured() || !secondCard.measured() || !longCard.measured()) {return;}
        if (scrollPhase == 1) {
            pitch = secondCard.textHeight - firstCard.textHeight;
            assert.Boolean(firstCard.textHeight > 0 && pitch > 0, "单TEXT自适应高度及行距可读");
            if (pitch <= 0 || firstCard.textHeight <= 0) {scrollPhase = 0; return;}
            fitLines = IMaxBJ(1, R2I((firstCard.viewHeight + 0.0001 - firstCard.textHeight) / pitch) + 1);
            scrollPhase = 2;
            scrollDemo.refreshCards();
            return;
        }
        assert.Boolean(!firstCard.hasScroll() && firstCard.textHeight <= firstCard.viewHeight + 0.0001, "恰好一屏不显示滑条");
        assert.Boolean(secondCard.hasScroll() && secondCard.textHeight > secondCard.viewHeight, "多一行显示滑条");
        assert.Boolean(longCard.hasScroll(), "长正文显示滑条");
        scrollPhase = 0;
    }
    function onInit() {
        hardware.regUpdateEvent(function checkBoundaries);
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            integer count = 0;
            boolean reject = false;
            integer pid = GetPlayerId(GetTriggerPlayer());
            if (command == "-transparency") {
                qualityMode[pid] = 1;
                blankCards[pid] = false;
                CreateCardSelectorTest(GetTriggerPlayer(), 2, false, 1);
                if (GetLocalPlayer() == GetTriggerPlayer() && active[pid].uiCards.isExist()) {
                    active[pid].uiCards.getItem(1).faceTop.setTexture("ui\\cardselector_colors\\green\\body.blp");
                }
                return;
            }
            if (command == "-footer") {TestCardFooters(GetTriggerPlayer()); return;}
            if (command == "-scroll" || command == "s7") {
                CreateCardSelectorTest(GetTriggerPlayer(), 3, false, 1);
                active[pid].reflectDescription(function boundaryText);
                if (GetLocalPlayer() == GetTriggerPlayer()) {
                    scrollDemo = active[pid]; scrollToken = scrollDemo.getSessionToken(); scrollPhase = 1;
                    scrollDemo.refreshCards();
                }
                return;
            }
            if (command == "-queue") {TestCardQueue(GetTriggerPlayer()); return;}
            if (command == "-queuefail") {TestCardQueueFailure(GetTriggerPlayer()); return;}
            if (command == "-mixed") {qualityMode[pid] = 0; CreateCardSelectorTest(GetTriggerPlayer(), 5, false, 2); return;}
            if (command == "-blank") {
                blankCards[pid] = !blankCards[pid];
                if (active[pid].isExist()) {active[pid].refreshCards();}
                return;
            }
            if (command == "-cycle") {
                qualityMode[pid] = ModuloInteger(qualityMode[pid], 5) + 1;
                if (active[pid].isExist()) {active[pid].refreshCards();}
                return;
            }
            if (SubString(command, 0, 9) == "-quality ") {
                count = S2I(SubString(command, 9, StringLength(command)));
                if (count < 1 || count > 6 || command != "-quality " + I2S(count)) {return;}
                qualityMode[pid] = count;
                CreateCardSelectorTest(GetTriggerPlayer(), 5, false, 2);
                if (GetLocalPlayer() == GetTriggerPlayer() && active[pid].uiCards.isExist()) {
                    if (count == 6) {count = 1;}
                    assert.Integer(active[pid].uiCards.getItem(1).quality, count, "品质映射/越界回退");
                }
                return;
            }
            if (command == "s1") {count = 5;}
            else if (command == "s2") {count = 3; reject = true;}
            else if (command == "s3") {count = 6;}
            else if (command == "s4") {TestCardProtocol(GetTriggerPlayer()); return;}
            else if (command == "s5") {CreateLongCardSelectorTest(GetTriggerPlayer()); return;}
            else if (command == "s6") {TestCardButtonProtocol(GetTriggerPlayer()); return;}
            else if (SubString(command, 0, 9) == "-buttons ") {
                count = S2I(SubString(command, 9, StringLength(command)));
                if (count < 0 || count > 4 || command != "-buttons " + I2S(count)) {return;}
                CreateCardSelectorTest(GetTriggerPlayer(), 3, false, count);
                return;
            }
            else if (SubString(command, 0, 6) == "-card ") {
                count = S2I(SubString(command, 6, StringLength(command)));
                if (count < 1 || count > 5 || command != "-card " + I2S(count)) {
                    if (GetLocalPlayer() == GetTriggerPlayer()) {BJDebugMsg("用法：-card X，X 为 1～5");}
                    return;
                }
            } else {return;}
            CreateCardSelectorTest(GetTriggerPlayer(), count, reject, 2);
        });
		InitTestUIRuler();
        BJDebugMsg("[CardSelector] -transparency：左侧原版绿卡，右侧卡面内部 10% 透明，两侧均使用原版标题。");
        BJDebugMsg("[CardSelector] -footer：五张底文样例。第二张可滚至正文末行；换批切换第一、五张底文。");
        BJDebugMsg("[CardSelector] -scroll 或 s7：左满屏、中多一行、右长文。滚轮可读到末行，点击滑轨位置可选卡。");
        BJDebugMsg("[CardSelector] -mixed：五色同屏；-quality 1~5：单品质；-quality 6：非法品质回退；-cycle：原位换色；-blank：空白/文字切换。");
        BJDebugMsg("[CardSelector] s1：5张；-card X：1～5张；s2：首次拒绝后重选；s3：非法数量；s4：同步包校验；s5：短/长/超长正文。");
        BJDebugMsg("[CardSelector] -buttons 0~4：底部按钮数量；s6：btn2/btn3协议校验。标题隐藏，悬停不得触发业务回调或tooltip。");
    }
}
//! endzinc
#endif
