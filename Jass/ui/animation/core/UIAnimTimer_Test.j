#ifndef UTUIAnimTimerIncluded
#define UTUIAnimTimerIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTUIAnimTimer requires UIAnimTimer, BaseAnim, UIImage {
    private uianim reference;
    private uianim retiring;
    private uianim survivor;
    private integer steps = 0;
    private integer previous = 0;
    private integer survivorSteps = 0;
    private integer retiredAt = 0;
    private integer retireCalls = 0;
    private integer expiries = 0;
    private integer finalAlpha;
    private integer frames = 0;
    private integer gameTicks = 0;
    private integer frozenTicks;
    private uiImage probeImage;
    private baseanim animation;
    private boolean active = false;

    private function observe() -> boolean {
        if (!active) { return true; }
        frames += 1;
        previous = steps;
        if (frames == 1) {
            Trace("[UIAnimDraw] pausing");
            PauseGame(true);
        }
        if (frames == 20) {
            Trace("[UIAnimDraw] starting animation");
            frozenTicks = gameTicks;
            reference.reg();
            retiring.reg();
            probeImage = uiImage.create(DzGetGameUI());
            probeImage.setSize(0.04, 0.04).setTexture("ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
            animation = baseanim.create(probeImage.ui);
            animation.addAlpha(255, 32, 25);
            animation.addLife(26, function(baseanim finished) {
                expiries += 1;
                finalAlpha = DzFrameGetAlpha(finished.ui);
                probeImage.destroy();
            });
            survivor.reg();
        }
        if (frames >= 160) {
            active = false;
            reference.unreg();
            retiring.unreg();
            survivor.unreg();
            Trace("[UIAnimDraw] steps=" + I2S(steps) + " survivor=" + I2S(survivorSteps) + " retiredAt=" + I2S(retiredAt) + " expiry=" + I2S(expiries) + " alpha=" + I2S(finalAlpha) + " game=" + I2S(frozenTicks) + "/" + I2S(gameTicks));
            assert.Boolean(frozenTicks > 0 && gameTicks == frozenTicks, "[UIAnimDraw] game timer frozen");
            assert.Boolean(finalAlpha == 32 && expiries == 1 && !probeImage.isExist() && !animation.isExist(), "[UIAnimDraw] completed and destroyed once");
            assert.Boolean(retiredAt > 0 && retireCalls == retiredAt && survivorSteps == steps && steps > retiredAt, "[UIAnimDraw] catch-up unregister preserves other callbacks");
            PauseGame(false);
            DzSetMaxFps(60);
            Trace("[UIAnimDraw] COMPLETE");
        }
        return true;
    }

    function onInit() {
        reference = uianim.create(function() { steps += 1; });
        retiring = uianim.create(function() {
            retireCalls += 1;
            if (steps - previous >= 2) {
                retiredAt = steps;
                retiring.unreg();
            }
        });
        survivor = uianim.create(function() { survivorSteps += 1; });
        hardware.regUpdateEvent(function observe);
        TimerStart(CreateTimer(), 0.1, true, function() { gameTicks += 1; });
        UnitTestAutoTimer(1.0, 2.0, function() {
            DzSetMaxFps(20);
            active = true;
        }, null);
    }
}
//! endzinc
#endif
