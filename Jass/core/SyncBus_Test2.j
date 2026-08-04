#ifndef UTSyncBusStressIncluded
#define UTSyncBusStressIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
SyncBus.onDataSyncLater 双端压力测试。

运行方式：
1. 双开并让玩家 1、玩家 2 都进入游戏；测试会在载入 1 秒后自动开始。
2. s1：手动开始/重新开始；s2：立即输出状态；s3：停止发包，等待 3 秒排空后断言。
3. 对齐两端日志中的 [SyncBusStress]。重点检查 FINAL 的 missing、duplicate、payloadReverse、busReverse 和 rngDigest。

注意：怪物和所有 timer 都在同步路径创建。只有两个 DzSyncDataEx 调用位于各自玩家的
GetLocalPlayer() 分支，避免把本地 CreateUnit 造成的必然异步混进 SyncBus 结论。
*/

#define SYNCBUS_STRESS_TAG "SBStress"
#define SYNCBUS_STRESS_END_TAG "SBStressEnd"
#define SYNCBUS_STRESS_RANDOM_TIMER_COUNT 4
#define SYNCBUS_STRESS_RANDOM_BURN_PER_TICK 64
#define SYNCBUS_STRESS_LATER_RANDOM_BURN 256
#define SYNCBUS_STRESS_MONSTER_COUNT 192
#define SYNCBUS_STRESS_GROUP_PICKS_PER_TICK 1
#define SYNCBUS_STRESS_INTERVAL 0.01
#define SYNCBUS_STRESS_GROUP_INTERVAL 0.05
#define SYNCBUS_STRESS_REPORT_INTERVAL 5.00
#define SYNCBUS_STRESS_DRAIN_SECONDS 3.00
#define SYNCBUS_STRESS_DIGEST_MOD 50000017

library UTSyncBusStress requires SyncBus {

    private boolean stressRegistered = false;
    private boolean stressRunning = false;
    private boolean stressDraining = false;
    private boolean stressHadPlayer1 = false;
    private boolean stressHadPlayer2 = false;
    private integer stressRun = 0;
    private integer reportCount = 0;

    // localSent 只在对应 GetLocalPlayer 分支写入，故有意保持为本地状态；不得用于同步逻辑。
    private integer localSent[];
    private integer recvTotal[];
    private integer recvUnique[];
    private integer recvMax[];
    private integer recvDuplicate[];
    private integer payloadReverse[];
    private integer payloadGapEvent[];
    private integer lastPayloadArrival[];
    private integer lastBusSequence[];
    private integer busReverse[];
    private integer lastSenderDigest[];
    private integer expectedFinal[];
    private integer endMarkerBusSequence[];
    private boolean endMarkerReceived[];
    private integer endMarkerDuplicate[];
    private integer malformedCount = 0;
    private integer senderMismatchCount = 0;
    private integer laterCallbackCount = 0;
    private integer pureRandomCallbackCount = 0;
    private integer groupCallbackCount = 0;
    private integer rngDigest = 1;

    private timer randomTimers[];
    private timer senderTimer1 = null;
    private timer senderTimer2 = null;
    private timer groupTimer = null;
    private timer reportTimer = null;
    private timer drainTimer = null;
    private group monsterGroup = null;
    private hashtable seenPackets = InitHashtable();

    private function LocalPid() -> integer {
        return GetConvertedPlayerId(GetLocalPlayer());
    }

    private function Log(string message) {
        DzWriteLog("[SyncBusStress][local=" + I2S(LocalPid()) + "][run=" + I2S(stressRun) + "] " + message);
    }

    private function FindCharFrom(string value, string target, integer from) -> integer {
        integer i;
        for (i = from; i < StringLength(value); i += 1) {
            if (SubString(value, i, i + 1) == target) {
                return i;
            }
        }
        return -1;
    }

    private function IsOnlineUserSlot(integer pid) -> boolean {
        player p;
        boolean result;
        p = ConvertedPlayer(pid);
        result = GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(p) == MAP_CONTROL_USER;
        p = null;
        return result;
    }

    private function BurnRandom(integer count, integer salt) {
        integer i;
        integer value;
        for (i = 0; i < count; i += 1) {
            value = GetRandomInt(1, 1000000);
            // 先限制 digest 上界，确保乘 33 不发生整数溢出；顺序变化会反映到最终 digest。
            rngDigest = ModuloInteger(rngDigest * 33 + value + salt, SYNCBUS_STRESS_DIGEST_MOD);
        }
    }

    private function MissingCount(integer pid) -> integer {
        return recvMax[pid] - recvUnique[pid];
    }

    private function LogAnomaly(string kind, integer count, string detail) {
        if (count <= 20 || ModuloInteger(count, 100) == 0) {
            Log("ANOMALY " + kind + " count=" + I2S(count) + " " + detail);
        }
    }

    private function ResetCounters() {
        integer pid;
        for (pid = 1; pid <= 2; pid += 1) {
            localSent[pid] = 0;
            recvTotal[pid] = 0;
            recvUnique[pid] = 0;
            recvMax[pid] = 0;
            recvDuplicate[pid] = 0;
            payloadReverse[pid] = 0;
            payloadGapEvent[pid] = 0;
            lastPayloadArrival[pid] = 0;
            lastBusSequence[pid] = 0;
            busReverse[pid] = 0;
            lastSenderDigest[pid] = 0;
            expectedFinal[pid] = 0;
            endMarkerBusSequence[pid] = 0;
            endMarkerReceived[pid] = false;
            endMarkerDuplicate[pid] = 0;
            FlushChildHashtable(seenPackets, pid);
        }
        malformedCount = 0;
        senderMismatchCount = 0;
        laterCallbackCount = 0;
        pureRandomCallbackCount = 0;
        groupCallbackCount = 0;
        reportCount = 0;
        rngDigest = 1;
    }

    private function SummaryText(string stage) -> string {
        return stage
            + " sentLocalP1=" + I2S(localSent[1])
            + " sentLocalP2=" + I2S(localSent[2])
            + " recvP1=" + I2S(recvUnique[1]) + "/max" + I2S(recvMax[1])
            + " recvP2=" + I2S(recvUnique[2]) + "/max" + I2S(recvMax[2])
            + " missingP1=" + I2S(MissingCount(1))
            + " missingP2=" + I2S(MissingCount(2))
            + " expectedFinalP1=" + I2S(expectedFinal[1])
            + " expectedFinalP2=" + I2S(expectedFinal[2])
            + " endMarkerP1=" + B2S(endMarkerReceived[1])
            + " endMarkerP2=" + B2S(endMarkerReceived[2])
            + " duplicateP1=" + I2S(recvDuplicate[1])
            + " duplicateP2=" + I2S(recvDuplicate[2])
            + " payloadReverseP1=" + I2S(payloadReverse[1])
            + " payloadReverseP2=" + I2S(payloadReverse[2])
            + " busReverseP1=" + I2S(busReverse[1])
            + " busReverseP2=" + I2S(busReverse[2])
            + " malformed=" + I2S(malformedCount)
            + " senderMismatch=" + I2S(senderMismatchCount)
            + " laterCallbacks=" + I2S(laterCallbackCount)
            + " rngDigest=" + I2S(rngDigest)
            + " senderDigestP1=" + I2S(lastSenderDigest[1])
            + " senderDigestP2=" + I2S(lastSenderDigest[2]);
    }

    private function LogSummary(string stage, boolean showScreen) {
        string message;
        message = SummaryText(stage);
        Log(message);
        if (showScreen) {
            BJDebugMsg("[SyncBusStress] " + message);
        }
        message = null;
    }

    private function HandleLaterPacket() {
        player sender;
        string payload;
        integer actualPid;
        integer declaredPid;
        integer payloadSequence;
        integer senderDigest;
        integer busSequence;
        integer split1;
        integer split2;
        boolean duplicate;

        sender = syncBus.getPlayer();
        payload = syncBus.getPayload();
        actualPid = GetConvertedPlayerId(sender);
        busSequence = syncBus.getSequence();
        split1 = FindCharFrom(payload, ":", 0);
        split2 = FindCharFrom(payload, ":", split1 + 1);

        if (actualPid < 1 || actualPid > 2 || split1 <= 0 || split2 <= split1 + 1) {
            malformedCount += 1;
            LogAnomaly("malformed", malformedCount,
                "actualPid=" + I2S(actualPid) + " busSeq=" + I2S(busSequence) + " payload='" + payload + "'");
        } else {
            declaredPid = S2I(SubString(payload, 0, split1));
            payloadSequence = S2I(SubString(payload, split1 + 1, split2));
            senderDigest = S2I(SubString(payload, split2 + 1, StringLength(payload)));

            if (declaredPid != actualPid) {
                senderMismatchCount += 1;
                LogAnomaly("senderMismatch", senderMismatchCount,
                    "declaredPid=" + I2S(declaredPid) + " actualPid=" + I2S(actualPid)
                    + " payloadSeq=" + I2S(payloadSequence));
            }

            if (payloadSequence <= 0) {
                malformedCount += 1;
                LogAnomaly("badPayloadSequence", malformedCount,
                    "pid=" + I2S(actualPid) + " payloadSeq=" + I2S(payloadSequence));
            } else {
                recvTotal[actualPid] += 1;
                duplicate = LoadBoolean(seenPackets, actualPid, payloadSequence);
                if (duplicate) {
                    recvDuplicate[actualPid] += 1;
                    LogAnomaly("duplicate", recvDuplicate[actualPid],
                        "pid=" + I2S(actualPid) + " payloadSeq=" + I2S(payloadSequence)
                        + " busSeq=" + I2S(busSequence));
                } else {
                    SaveBoolean(seenPackets, actualPid, payloadSequence, true);
                    recvUnique[actualPid] += 1;
                    if (payloadSequence < lastPayloadArrival[actualPid]) {
                        payloadReverse[actualPid] += 1;
                        LogAnomaly("payloadReverse", payloadReverse[actualPid],
                            "pid=" + I2S(actualPid) + " previous=" + I2S(lastPayloadArrival[actualPid])
                            + " current=" + I2S(payloadSequence) + " busSeq=" + I2S(busSequence));
                    } else if (payloadSequence > lastPayloadArrival[actualPid] + 1 && lastPayloadArrival[actualPid] > 0) {
                        payloadGapEvent[actualPid] += 1;
                        LogAnomaly("payloadGapPending", payloadGapEvent[actualPid],
                            "pid=" + I2S(actualPid) + " previous=" + I2S(lastPayloadArrival[actualPid])
                            + " current=" + I2S(payloadSequence));
                    }
                    lastPayloadArrival[actualPid] = payloadSequence;
                    if (payloadSequence > recvMax[actualPid]) {
                        recvMax[actualPid] = payloadSequence;
                    }
                }

                if (busSequence > 0 && lastBusSequence[actualPid] > 0 && busSequence <= lastBusSequence[actualPid]) {
                    busReverse[actualPid] += 1;
                    LogAnomaly("busReverse", busReverse[actualPid],
                        "pid=" + I2S(actualPid) + " previous=" + I2S(lastBusSequence[actualPid])
                        + " current=" + I2S(busSequence) + " payloadSeq=" + I2S(payloadSequence));
                }
                if (busSequence > lastBusSequence[actualPid]) {
                    lastBusSequence[actualPid] = busSequence;
                }
                lastSenderDigest[actualPid] = senderDigest;

                // 每包固定消耗大量随机数；salt 让乱序即使不丢包也会反映到 rngDigest。
                BurnRandom(SYNCBUS_STRESS_LATER_RANDOM_BURN, actualPid * 100000 + payloadSequence);
                laterCallbackCount += 1;
            }
        }

        sender = null;
        payload = null;
    }

    private function HandleEndMarker() {
        player sender;
        string payload;
        integer actualPid;
        integer declaredPid;
        integer finalSequence;
        integer senderDigest;
        integer busSequence;
        integer split1;
        integer split2;

        sender = syncBus.getPlayer();
        payload = syncBus.getPayload();
        actualPid = GetConvertedPlayerId(sender);
        busSequence = syncBus.getSequence();
        split1 = FindCharFrom(payload, ":", 0);
        split2 = FindCharFrom(payload, ":", split1 + 1);
        if (actualPid < 1 || actualPid > 2 || split1 <= 0 || split2 <= split1 + 1) {
            malformedCount += 1;
            LogAnomaly("malformedEndMarker", malformedCount,
                "actualPid=" + I2S(actualPid) + " busSeq=" + I2S(busSequence) + " payload='" + payload + "'");
        } else {
            declaredPid = S2I(SubString(payload, 0, split1));
            finalSequence = S2I(SubString(payload, split1 + 1, split2));
            senderDigest = S2I(SubString(payload, split2 + 1, StringLength(payload)));
            if (declaredPid != actualPid || finalSequence <= 0) {
                malformedCount += 1;
                LogAnomaly("badEndMarker", malformedCount,
                    "declaredPid=" + I2S(declaredPid) + " actualPid=" + I2S(actualPid)
                    + " finalSequence=" + I2S(finalSequence));
            } else {
                if (endMarkerReceived[actualPid]) {
                    endMarkerDuplicate[actualPid] += 1;
                    LogAnomaly("duplicateEndMarker", endMarkerDuplicate[actualPid],
                        "pid=" + I2S(actualPid) + " oldExpected=" + I2S(expectedFinal[actualPid])
                        + " newExpected=" + I2S(finalSequence));
                }
                endMarkerReceived[actualPid] = true;
                expectedFinal[actualPid] = finalSequence;
                endMarkerBusSequence[actualPid] = busSequence;
                lastSenderDigest[actualPid] = senderDigest;
                Log("END_MARKER pid=" + I2S(actualPid) + " expectedFinal=" + I2S(finalSequence)
                    + " busSeq=" + I2S(busSequence) + " currentUnique=" + I2S(recvUnique[actualPid])
                    + " currentMax=" + I2S(recvMax[actualPid]));
            }
        }
        sender = null;
        payload = null;
    }

    private function RegisterStressRoute() {
        if (stressRegistered) { return; }
        stressRegistered = true;
        syncBus.onDataSyncLater(SYNCBUS_STRESS_TAG, function () -> boolean {
            HandleLaterPacket();
            return true;
        });
        syncBus.onDataSyncLater(SYNCBUS_STRESS_END_TAG, function () -> boolean {
            HandleEndMarker();
            return true;
        });
    }

    private function CreateStressMonsters() {
        integer i;
        real minX;
        real maxX;
        real minY;
        real maxY;
        unit u;

        monsterGroup = CreateGroup();
        minX = GetRectMinX(GetPlayableMapRect()) + 256.0;
        maxX = GetRectMaxX(GetPlayableMapRect()) - 256.0;
        minY = GetRectMinY(GetPlayableMapRect()) + 256.0;
        maxY = GetRectMaxY(GetPlayableMapRect()) - 256.0;
        for (i = 0; i < SYNCBUS_STRESS_MONSTER_COUNT; i += 1) {
            u = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'hfoo',
                GetRandomReal(minX, maxX), GetRandomReal(minY, maxY), GetRandomReal(0.0, 360.0));
            if (u != null) {
                PauseUnit(u, true);
                SetUnitInvulnerable(u, true);
                SetUnitPathing(u, false);
                GroupAddUnit(monsterGroup, u);
            }
        }
        u = null;
    }

    private function DestroyStressMonsters() {
        unit u;
        if (monsterGroup == null) { return; }
        u = FirstOfGroup(monsterGroup);
        while (u != null) {
            GroupRemoveUnit(monsterGroup, u);
            RemoveUnit(u);
            u = FirstOfGroup(monsterGroup);
        }
        DestroyGroup(monsterGroup);
        monsterGroup = null;
        u = null;
    }

    private function DestroyStressTimers() {
        integer i;
        for (i = 0; i < SYNCBUS_STRESS_RANDOM_TIMER_COUNT; i += 1) {
            if (randomTimers[i] != null) {
                DestroyTimer(randomTimers[i]);
                randomTimers[i] = null;
            }
        }
        if (senderTimer1 != null) {
            DestroyTimer(senderTimer1);
            senderTimer1 = null;
        }
        if (senderTimer2 != null) {
            DestroyTimer(senderTimer2);
            senderTimer2 = null;
        }
        if (groupTimer != null) {
            DestroyTimer(groupTimer);
            groupTimer = null;
        }
        if (reportTimer != null) {
            DestroyTimer(reportTimer);
            reportTimer = null;
        }
    }

    private function FinalizeStress() {
        boolean lossPass;
        boolean orderPass;
        boolean coveragePass;
        string result;

        stressDraining = false;
        coveragePass = stressHadPlayer1 && stressHadPlayer2 && recvMax[1] > 0 && recvMax[2] > 0;
        lossPass = endMarkerReceived[1] && endMarkerReceived[2]
            && recvUnique[1] == expectedFinal[1] && recvUnique[2] == expectedFinal[2]
            && recvMax[1] == expectedFinal[1] && recvMax[2] == expectedFinal[2]
            && recvDuplicate[1] == 0 && recvDuplicate[2] == 0
            && endMarkerDuplicate[1] == 0 && endMarkerDuplicate[2] == 0
            && malformedCount == 0 && senderMismatchCount == 0;
        orderPass = payloadReverse[1] == 0 && payloadReverse[2] == 0
            && busReverse[1] == 0 && busReverse[2] == 0;
        result = S3(coveragePass && lossPass && orderPass, "PASS", "FAIL");
        LogSummary("FINAL=" + result, true);
        Log("FINAL_DETAIL coverage=" + B2S(coveragePass)
            + " loss=" + B2S(lossPass) + " order=" + B2S(orderPass)
            + " pureRandomCallbacks=" + I2S(pureRandomCallbackCount)
            + " groupCallbacks=" + I2S(groupCallbackCount));
        assert.Boolean(coveragePass, "SyncBusStress 双端玩家 1/2 均实际参与");
        assert.Boolean(lossPass, "SyncBusStress onDataSyncLater 无丢包/重包/坏包");
        assert.Boolean(orderPass, "SyncBusStress onDataSyncLater 按发送者序号稳定派发");
        result = null;
    }

    private function StopStress() {
        if (!stressRunning) {
            Log("STOP ignored: not running");
            return;
        }
        stressRunning = false;
        stressDraining = true;
        DestroyStressTimers();
        // 尾包连续丢失无法靠 recvMax 推断，因此每个本地发送者再发一个最终水位包。
        if (GetLocalPlayer() == Player(0)) {
            syncBus.DzSyncDataEx(SYNCBUS_STRESS_END_TAG,
                "1:" + I2S(localSent[1]) + ":" + I2S(rngDigest));
        }
        if (GetLocalPlayer() == Player(1)) {
            syncBus.DzSyncDataEx(SYNCBUS_STRESS_END_TAG,
                "2:" + I2S(localSent[2]) + ":" + I2S(rngDigest));
        }
        DestroyStressMonsters();
        LogSummary("STOP_DRAIN_BEGIN", true);
        drainTimer = CreateTimer();
        TimerStart(drainTimer, SYNCBUS_STRESS_DRAIN_SECONDS, false, function () {
            timer expired;
            expired = GetExpiredTimer();
            drainTimer = null;
            DestroyTimer(expired);
            FinalizeStress();
            expired = null;
        });
    }

    private function StartStress() {
        integer i;
        if (stressRunning) {
            LogSummary("START ignored: already running", true);
            return;
        }
        if (stressDraining) {
            Log("START ignored: waiting for drain");
            BJDebugMsg("[SyncBusStress] 正在等待排空，请稍后再输入 s1");
            return;
        }

        RegisterStressRoute();
        stressRun += 1;
        ResetCounters();
        stressHadPlayer1 = IsOnlineUserSlot(1);
        stressHadPlayer2 = IsOnlineUserSlot(2);
        stressRunning = true;
        CreateStressMonsters();

        // 四个同步 0.01 秒 timer：纯 GetRandomInt 压力，不经过 SyncBus。
        for (i = 0; i < SYNCBUS_STRESS_RANDOM_TIMER_COUNT; i += 1) {
            randomTimers[i] = CreateTimer();
            TimerStart(randomTimers[i], SYNCBUS_STRESS_INTERVAL, true, function () {
                if (stressRunning) {
                    BurnRandom(SYNCBUS_STRESS_RANDOM_BURN_PER_TICK, 700001);
                    pureRandomCallbackCount += 1;
                }
            });
        }

        // 两个 timer 在所有客户端同步创建；只有对应本机玩家进入本地发送分支。
        senderTimer1 = CreateTimer();
        TimerStart(senderTimer1, SYNCBUS_STRESS_INTERVAL, true, function () {
            if (stressRunning && GetLocalPlayer() == Player(0)) {
                localSent[1] += 1;
                syncBus.DzSyncDataEx(SYNCBUS_STRESS_TAG,
                    "1:" + I2S(localSent[1]) + ":" + I2S(rngDigest));
            }
        });

        senderTimer2 = CreateTimer();
        TimerStart(senderTimer2, SYNCBUS_STRESS_INTERVAL, true, function () {
            if (stressRunning && GetLocalPlayer() == Player(1)) {
                localSent[2] += 1;
                syncBus.DzSyncDataEx(SYNCBUS_STRESS_TAG,
                    "2:" + I2S(localSent[2]) + ":" + I2S(rngDigest));
            }
        });

        // 同步单位组压力：怪物只创建一次；这里只反复随机抽取以消耗随机序列，不移动单位。
        groupTimer = CreateTimer();
        TimerStart(groupTimer, SYNCBUS_STRESS_GROUP_INTERVAL, true, function () {
            integer i;
            unit u;
            if (stressRunning && monsterGroup != null) {
                for (i = 0; i < SYNCBUS_STRESS_GROUP_PICKS_PER_TICK; i += 1) {
                    u = GroupPickRandomUnit(monsterGroup);
                }
                groupCallbackCount += 1;
            }
            u = null;
        });

        reportTimer = CreateTimer();
        TimerStart(reportTimer, SYNCBUS_STRESS_REPORT_INTERVAL, true, function () {
            if (stressRunning) {
                reportCount += 1;
                LogSummary("RUNNING report=" + I2S(reportCount), false);
            }
        });

        Log("START config interval=" + R2S(SYNCBUS_STRESS_INTERVAL)
            + " randomTimers=" + I2S(SYNCBUS_STRESS_RANDOM_TIMER_COUNT)
            + " randomBurnPerTimerTick=" + I2S(SYNCBUS_STRESS_RANDOM_BURN_PER_TICK)
            + " laterBurnPerPacket=" + I2S(SYNCBUS_STRESS_LATER_RANDOM_BURN)
            + " monsters=" + I2S(SYNCBUS_STRESS_MONSTER_COUNT)
            + " groupInterval=" + R2S(SYNCBUS_STRESS_GROUP_INTERVAL)
            + " groupPicksPerTick=" + I2S(SYNCBUS_STRESS_GROUP_PICKS_PER_TICK)
            + " onlineP1=" + B2S(stressHadPlayer1) + " onlineP2=" + B2S(stressHadPlayer2));
        BJDebugMsg("[SyncBusStress] 压测已自动开始：s2 状态，s3 停止并在 3 秒后断言");
        if (!stressHadPlayer1 || !stressHadPlayer2) {
            BJDebugMsg("[SyncBusStress] 警告：玩家 1/2 未全部在线，本轮 FINAL coverage 将失败");
        }
    }

    function onInit() {
        trigger startTrigger;
        RegisterStressRoute();
        UnitTestRegisterChatEvent(function () {
            string command;
            command = GetEventPlayerChatString();
            if (command == "s1") {
                StartStress();
            } else if (command == "s2") {
                LogSummary("MANUAL_STATUS", true);
            } else if (command == "s3") {
                StopStress();
            }
            command = null;
        });

        // 专用测试目标加载后自动开始，便于双开直接观察。
        startTrigger = CreateTrigger();
        TriggerRegisterTimerEventSingle(startTrigger, 1.00);
        TriggerAddCondition(startTrigger, Condition(function () -> boolean {
            StartStress();
            DestroyTrigger(GetTriggeringTrigger());
            return true;
        }));
        startTrigger = null;

		DzUnlockOpCodeLimit(true);
    }
}

//! endzinc

#undef SYNCBUS_STRESS_TAG
#undef SYNCBUS_STRESS_END_TAG
#undef SYNCBUS_STRESS_RANDOM_TIMER_COUNT
#undef SYNCBUS_STRESS_RANDOM_BURN_PER_TICK
#undef SYNCBUS_STRESS_LATER_RANDOM_BURN
#undef SYNCBUS_STRESS_MONSTER_COUNT
#undef SYNCBUS_STRESS_GROUP_PICKS_PER_TICK
#undef SYNCBUS_STRESS_INTERVAL
#undef SYNCBUS_STRESS_GROUP_INTERVAL
#undef SYNCBUS_STRESS_REPORT_INTERVAL
#undef SYNCBUS_STRESS_DRAIN_SECONDS
#undef SYNCBUS_STRESS_DIGEST_MOD

#endif
