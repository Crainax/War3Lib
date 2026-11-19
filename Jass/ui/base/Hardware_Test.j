#ifndef UTHardwareIncluded
#define UTHardwareIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTHardware requires Hardware {
    private integer marker;
    private integer draws = 0;
    private integer ticks = 0;
    private integer resumeAt = 0;
    private integer target = 30;
    private integer sample = 0;
    private integer startTicks;
    private boolean paused = false;
    private real estimate;
    private integer invalid;

    function sampleFps() {
        integer raw;
        if (target > 240) { return; }
        sample += 1;
        if (sample == 1) { DzSetMaxFps(target); }
        if (sample == 120) {
            estimate = 0.0;
            invalid = 0;
            startTicks = ticks;
            Trace("[HardwareDT] start cap=" + I2S(target) + " game=" + I2S(ticks));
        }
        if (sample > 120) {
            raw = DzGetFPS();
            if (raw > 0) { estimate += 100.0 / I2R(raw); }
            else { invalid += 1; }
        }
        if (sample == 300) {
            Trace("[HardwareDT] end cap=" + I2S(target) + " game=" + I2S(ticks) + " est=" + R2SW(estimate, 1, 6) + " invalid=" + I2S(invalid));
            assert.Boolean(invalid == 0 && ((paused && ticks == startTicks) || (!paused && ticks > startTicks)), "[HardwareDT] valid window");
            target *= 2;
            sample = 0;
            if (target > 240 && !paused) {
                paused = true;
                target = 30;
                PauseGame(true);
            } else if (target > 240) {
                PauseGame(false);
                DzSetMaxFps(60);
                Trace("[HardwareFPS] COMPLETE");
            }
        }
    }

    function draw() {
        integer phase;
        draws += 1;
        sampleFps();
        phase = ModuloInteger(draws, 160);
        if (phase > 80) { phase = 160 - phase; }
        DzFrameSetAbsolutePoint(marker, 0, 0.02 + 0.001 * phase, 0.52);
        DzFrameSetText(marker, "|cffffff00DRAW " + I2S(draws) + "   GAME " + I2S(ticks) + "|r");
        if (ModuloInteger(draws, 60) == 0) {
            Trace("[HardwareProbe] draw=" + I2S(draws) + " game=" + I2S(ticks));
        }
        if (resumeAt == draws) {
            PauseGame(false);
            resumeAt = 0;
            Trace("[HardwareProbe] resumed after 300 draws");
        }
    }

    function onInit() {
        UnitTestAutoTimer(0.5, 2.0, function() {
            marker = DzCreateFrameByTagName("TEXT", "HardwareProbe", DzGetGameUI(), "T1", 0);
            DzFrameShow(marker, true);
            hardware.regUpdateEvent(function draw);
            TimerStart(CreateTimer(), 0.1, true, function() { ticks += 1; });
            BJDebugMsg("单人 FPS 自动采样中，请等待 COMPLETE 后再测试 F10 或 s1。");
        }, function() {
            assert.Boolean(marker != 0 && draws > 0, "[HardwareProbe] baseline");
        });
        UnitTestRegisterChatEvent(function() {
            if (GetEventPlayerChatString() == "s1" && target > 240 && draws > 0 && resumeAt == 0) {
                resumeAt = draws + 300;
                Trace("[HardwareProbe] pausing at draw=" + I2S(draws) + " game=" + I2S(ticks));
                PauseGame(true);
            }
        });
    }
}
//! endzinc
#endif
