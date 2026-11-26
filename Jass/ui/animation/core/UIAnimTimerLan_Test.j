#ifndef UTUIAnimTimerLanIncluded
#define UTUIAnimTimerLanIncluded
#undef OriginMapUnitTestMode
//! zinc
library UTUIAnimTimerLan requires BaseAnim, UIImage, Hardware, SyncBus {
    private uiImage probeImage = 0;
    private baseanim animation = 0;
    private integer expiries = 0;
    private integer finalAlpha = 0;
    private integer draws = 0;
    private real rawSum = 0.0;
    private boolean measuring = false;
    private integer reports[];
    private integer received[];
    private integer seconds = 0;

    function onInit() {
        hardware.regUpdateEvent(function() -> boolean {
            if (measuring) {
                draws += 1;
                rawSum += I2R(DzGetFPS());
            }
            return true;
        });
        syncBus.onDataSync("UTAnimLan", function() -> boolean {
            integer sender = GetPlayerId(syncBus.getPlayer());
            reports[sender] = S2I(syncBus.getPayload());
            received[sender] += 1;
            return true;
        });
        TimerStart(CreateTimer(), 1.0, true, function() {
            integer pid = GetPlayerId(GetLocalPlayer());
            seconds += 1;
            if (seconds == 1) {
                if (pid == 0) { DzSetMaxFps(20); }
                else { DzSetMaxFps(120); }
            } else if (seconds == 4) {
                measuring = true;
                if (pid == 0) {
                    probeImage = uiImage.create(DzGetGameUI());
                    probeImage.setAbsPoint(4, 0.4, 0.35).setSize(0.04, 0.04).setTexture("ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");
                    animation = baseanim.create(probeImage.ui);
                    animation.addAlpha(255, 32, 50);
                    animation.addLife(51, function(baseanim finished) {
                        expiries += 1;
                        finalAlpha = DzFrameGetAlpha(finished.ui);
                        probeImage.destroy();
                    });
                }
            } else if (seconds == 12) {
                measuring = false;
                Trace("[UIAnimLan] pid=" + I2S(pid) + " draws=" + I2S(draws) + " fps=" + R2S(rawSum / (100.0 * I2R(IMaxBJ(1, draws)))) + " expiry=" + I2S(expiries) + " alpha=" + I2S(finalAlpha));
                if (pid == 0) {
                    assert.Boolean(animation != 0 && probeImage != 0 && !animation.isExist() && !probeImage.isExist() && expiries == 1 && finalAlpha == 32, "[UIAnimLan] P1 finished and destroyed once");
                } else {
                    assert.Boolean(pid == 1 && animation == 0 && probeImage == 0 && expiries == 0, "[UIAnimLan] P2 never created an animation");
                }
                syncBus.DzSyncDataEx("UTAnimLan", I2S(draws));
            } else if (seconds == 20) {
                Trace("[UIAnimLan] received P1=" + I2S(reports[0]) + " P2=" + I2S(reports[1]));
                assert.Boolean(received[0] == 1 && received[1] == 1 && reports[0] > 0 && reports[1] > reports[0] * 1.25, "[UIAnimLan] both reports received with distinct draw rates");
                DzSetMaxFps(60);
                DestroyTimer(GetExpiredTimer());
                Trace("[UIAnimLan] COMPLETE");
            }
        });
    }
}
//! endzinc
#endif
