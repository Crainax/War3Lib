#ifndef UTAttenuationBarrierIncluded
#define UTAttenuationBarrierIncluded
#undef OriginMapUnitTestMode
#define EmptyMapUnitTestMode

// 无Xlimon依赖、无自定义物编。自动运行；s1重跑，s2切换逐击日志。
//! zinc
library UTAttenuationBarrier requires AttenuationBarrier, UnitTestFramwork {
    private integer passed = 0;
    private integer failed = 0;
    private integer runId = 0;
    private string firstFailure = "";
    private boolean busy = false;
    private boolean verbose = false;
    private unit many[];
    private unit windowUnit = null;
    private integer startWindow = 0;
    private integer phase = 0;
    private integer ticks = 0;
    private integer initialCount = 0;
    private timer windowTimer = null;

    private function Log(string message) {
        message = "[UTAttenuationBarrier run=" + I2S(runId) + "] " + message;
        BJDebugMsg(message);
        DzWriteLog(message);
    }

    private function Check(boolean ok, string name) {
        assert.Boolean(ok, "[AttenuationBarrier] " + name);
        if (ok) {
            passed += 1;
            DzWriteLog("[UTAttenuationBarrier] PASS " + name);
        } else {
            failed += 1;
            if (firstFailure == "") { firstFailure = name; }
            Log("FAIL " + name);
        }
    }

    private function Near(real actual, real expected, string name) {
        real tolerance = RMaxBJ(0.000001, RAbsBJ(expected) * 0.00001);
        Log(name + " expected=" + R2S(expected) + " actual=" + R2S(actual)
            + " tolerance=" + R2S(tolerance));
        Check(RAbsBJ(actual - expected) <= tolerance, name);
    }

    private function Dispose(unit u) {
        RemoveAttenuationBarrier(u);
        RemoveUnit(u);
    }

    private function TestFormula() {
        unit u = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
        unit v = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
        real total = 0.0;
        real result;
        integer i;
        Log("CASE formula / split / independent targets / invalid input");
        Near(ResolveAttenuationBarrier(u, 123.0), 123.0, "unregistered passthrough");
        Check(!SetAttenuationBarrier(null, 100.0), "null rejected");
        Check(!SetAttenuationBarrier(u, 0.0), "zero threshold rejected");
        Check(!SetAttenuationBarrier(u, -1.0), "negative threshold rejected");
        Check(SetAttenuationBarrier(u, 1000000.0), "register");
        SetAttenuationBarrier(v, 1000000.0);
        Near(ResolveAttenuationBarrier(u, 600000.0), 600000.0, "below threshold");
        Near(ResolveAttenuationBarrier(u, 600000.0), 495445.115, "cross threshold");
        Near(ResolveAttenuationBarrier(v, 600000.0), 600000.0, "other target independent");
        Near(ResolveAttenuationBarrier(u, 0.0), 0.0, "zero damage");
        Near(ResolveAttenuationBarrier(u, -10.0), -10.0, "negative passthrough");
        Near(GetAttenuationBarrierRaw(u), 1200000.0, "nonpositive does not consume");
        ResetAttenuationBarrier(u);
        Near(ResolveAttenuationBarrier(u, 1000000.0), 1000000.0, "exact threshold");
        Near(ResolveAttenuationBarrier(u, 3000000.0), 1000000.0, "threshold then 3T");
        ResetAttenuationBarrier(u);
        Near(ResolveAttenuationBarrier(u, 100000000.0), 10000000.0, "100T single hit");
        ResetAttenuationBarrier(v);
        for (1 <= i <= 100) { total += ResolveAttenuationBarrier(v, 1000000.0); }
        Near(total, 10000000.0, "100 equal segments equal single hit");
        Near(GetAttenuationBarrierRaw(v), 100000000.0, "raw stores input not output");
        SetAttenuationBarrier(v, 1000000.0);
        Near(GetAttenuationBarrierRaw(v), 100000000.0, "repeat set preserves budget");
        result = ResolveAttenuationBarrier(v, 21000000.0);
        Near(result, 1000000.0, "followup sees previous budget");
        Check(!SetAttenuationBarrier(v, -5.0), "invalid update rejected");
        Near(GetAttenuationBarrierThreshold(v), 1000000.0, "invalid update preserves threshold");
        ResetAttenuationBarrier(u);
        SetAttenuationBarrier(u, 100.0);
        Near(ResolveAttenuationBarrier(u, 400.0), 200.0, "small threshold");
        SetAttenuationBarrier(u, 400.0);
        Near(GetAttenuationBarrierRaw(u), 400.0, "threshold update preserves raw");
        Near(ResolveAttenuationBarrier(u, 500.0), 200.0, "updated threshold next increment");
        // 大数后的微小增量：直接F(new)-F(old)在32位real中容易得到0。
        ResetAttenuationBarrier(u);
        SetAttenuationBarrier(u, 1000000.0);
        ResolveAttenuationBarrier(u, 1000000000000.0);
        Near(ResolveAttenuationBarrier(u, 1.0), 0.0005, "large sum then one damage remains positive");
        ResolveAttenuationBarrier(u, 1000000000000.0);
        result = ResolveAttenuationBarrier(u, 1.0);
        Check(result > 0.0 && result < 1.0, "no per-hit floor");
        KillUnit(u);
        Near(GetAttenuationBarrierRaw(u), 0.0, "death resets state synchronously");
        Near(GetAttenuationBarrierThreshold(u), 1000000.0, "death retains configuration");
        Dispose(u);
        Dispose(v);
        u = null;
        v = null;
    }

    private function TestSwapAndMass() {
        integer baseline = GetAttenuationBarrierCount();
        integer hole;
        integer i;
        integer j;
        real result;
        boolean allOK = true;
        Log("CASE 128 units / 1024 hits / swap-remove / reverse map");
        for (1 <= i <= 128) {
            many[i] = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
            if (!SetAttenuationBarrier(many[i], I2R(i) * 100.0)) { allOK = false; }
            result = 0.0;
            for (1 <= j <= 8) { result += ResolveAttenuationBarrier(many[i], I2R(i) * 50.0); }
            if (RAbsBJ(result - I2R(i) * 200.0) > I2R(i) * 0.01) { allOK = false; }
        }
        Check(allOK, "128 independent thresholds and totals");
        Check(GetAttenuationBarrierCount() == baseline + 128, "mass count");
        hole = GetAttenuationBarrierSlot(many[17]);
        Dispose(many[17]);
        many[17] = null;
        Check(GetAttenuationBarrierSlot(many[128]) == hole, "tail reverse map moved into hole");
        Near(GetAttenuationBarrierThreshold(many[128]), 12800.0, "swap threshold");
        Near(GetAttenuationBarrierRaw(many[128]), 51200.0, "swap accumulated input");
        Near(ResolveAttenuationBarrier(many[128], 64000.0), 12800.0, "swap cached roots and continued damage");
        RemoveAttenuationBarrier(many[1]);
        RemoveAttenuationBarrier(many[1]);
        Near(ResolveAttenuationBarrier(many[1], 500.0), 500.0, "removed passthrough / double remove safe");
        SetAttenuationBarrier(many[1], 100.0);
        Near(ResolveAttenuationBarrier(many[1], 400.0), 200.0, "reattach starts fresh");
        for (1 <= i <= 128) {
            if (many[i] != null) { Dispose(many[i]); many[i] = null; }
        }
        Check(GetAttenuationBarrierCount() == baseline, "mass teardown leaves no slots");
    }

    private function WindowStep() {
        integer current = GetAttenuationBarrierWindow();
        ticks += 1;
        if (phase == 0) {
            if (current != startWindow) {
                startWindow = current;
                ticks = 0;
                phase = 1;
                Near(ResolveAttenuationBarrier(windowUnit, 400.0), 200.0, "window initial hit");
                Log("CASE timer begin window=" + I2S(current));
            }
        } else if (phase == 1 && ticks == 20) {
            Check(current == startWindow, "0.20 seconds still same window");
            Near(ResolveAttenuationBarrier(windowUnit, 500.0), 100.0, "same window additional hit");
            phase = 2;
        } else if (phase == 2 && current != startWindow) {
            Near(GetAttenuationBarrierRaw(windowUnit), 0.0, "expired query reads zero without mutation");
            Near(ResolveAttenuationBarrier(windowUnit, 400.0), 200.0, "new window resets lazily");
            Dispose(windowUnit);
            windowUnit = null;
            Check(GetAttenuationBarrierCount() == initialCount, "suite cleanup count");
            PauseTimer(windowTimer);
            busy = false;
            Log("SUMMARY pass=" + I2S(passed) + " fail=" + I2S(failed) + " firstFailure=" + firstFailure);
        }
        if (busy && ticks > 150) {
            Check(false, "window timer timeout");
            Dispose(windowUnit);
            windowUnit = null;
            PauseTimer(windowTimer);
            busy = false;
            Log("SUMMARY timeout pass=" + I2S(passed) + " fail=" + I2S(failed) + " firstFailure=" + firstFailure);
        }
    }

    private function Run() {
        if (busy) { Log("BUSY: wait for current timer case"); return; }
        busy = true;
        runId += 1;
        passed = 0;
        failed = 0;
        firstFailure = "";
        initialCount = GetAttenuationBarrierCount();
        Log("BEGIN p=0.5 interval=0.5; s1=rerun, s2=toggle per-hit file log");
        TestFormula();
        TestSwapAndMass();
        windowUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);
        SetAttenuationBarrier(windowUnit, 100.0);
        startWindow = GetAttenuationBarrierWindow();
        ticks = 0;
        phase = 0;
        TimerStart(windowTimer, 0.01, true, function WindowStep);
    }

    function onInit() {
        windowTimer = CreateTimer();
        UnitTestAutoTimer(0.2, 0.0, function Run, null);
        UnitTestRegisterChatEvent(function() {
            string command = GetEventPlayerChatString();
            if (command == "s1") { Run(); }
            else if (command == "s2") {
                verbose = !verbose;
                SetAttenuationBarrierDebug(verbose);
                if (verbose) { Log("per-hit file log ON (s1 to rerun)"); }
                else { Log("per-hit file log OFF"); }
            }
        });
    }
}
//! endzinc
#endif
