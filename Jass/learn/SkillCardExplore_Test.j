#ifndef UTSkillCardExploreIncluded
#define UTSkillCardExploreIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/SkillCardExplore.j"

//! zinc
library UTSkillCardExplore requires SkillCardExplore, UnitTestFramwork {
    private item cards[];
    private unit carrier = null;
    private string icons[];
    private integer iconIndex = 0;
    private real centerX;
    private real centerY;
    private real distanceAsync = 1800.0;
    private boolean topViewAsync = false;

    private function Help() {
        BJDebugMsg("[SkillCardExplore] 左A/中B/右C：同一正方形卡牌模型，分别显示不同原生技能图标。scale=1.0。");
        BJDebugMsg("s1重建；s2只切换左A图标；s3近距1800；s4最远3600；s5拾取A；s6丢下A(不补图)；s7切换俯视角；s8补A贴图；s10帮助");
        BJDebugMsg("模型随镜头朝向，Stand只上下轻微浮动。观察图标是否正向、1:1、独立换图，以及光效是否遮挡。未接入Xlimon。");
    }
    private function Focus(player p, real distance) {
        if (GetLocalPlayer() == p) {
            distanceAsync = distance;
            topViewAsync = false;
            PanCameraToTimed(centerX, centerY, 0.0);
            SetCameraField(CAMERA_FIELD_ROTATION, 90.0, 0.0);
            SetCameraField(CAMERA_FIELD_ROLL, 0.0, 0.0);
            SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.0);
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, distance, 0.0);
            SetCameraField(CAMERA_FIELD_ZOFFSET, 69.2734, 0.0);
            ClearSelection();
            SelectUnit(carrier, true);
        }
    }
    private function Reset(player p) {
        integer i;
        for (0 <= i < 3) {
            if (cards[i] != null) { RemoveItem(cards[i]); cards[i] = null; }
        }
        if (carrier != null) { RemoveUnit(carrier); carrier = null; }
        centerX = GetRectCenterX(bj_mapInitialPlayableArea);
        centerY = GetRectCenterY(bj_mapInitialPlayableArea);
        carrier = CreateUnit(p, 'Hpal', centerX, centerY - 350.0, 90.0);
        SetUnitInvulnerable(carrier, true);
        iconIndex = 0;
        for (0 <= i < 3) {
            cards[i] = CreateItem('ratf', centerX + (i - 1) * 220.0, centerY);
            assert.Boolean(cards[i] != null, "[SkillCardExplore] item created " + I2S(i));
            DzItemSetModel(cards[i], "crainax_skill_card.mdx");
            DzItemSetSize(cards[i], 1.0);
            DzSetWidgetTexture(cards[i], icons[i], 1);
        }
        Focus(p, distanceAsync);
        Help();
    }
    function onInit() {
        icons[0] = "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp";
        icons[1] = "ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp";
        icons[2] = "ReplaceableTextures\\CommandButtons\\BTNThunderBolt.blp";
        UnitTestAutoTimer(1.0, 1.0, function() {
            FogEnable(false);
            FogMaskEnable(false);
            Reset(Player(0));
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();
            boolean result;
            if (str == "s1") { Reset(p); }
            else if (str == "s2") {
                iconIndex = ModuloInteger(iconIndex + 1, 3);
                DzSetWidgetTexture(cards[0], icons[iconIndex], 1);
            } else if (str == "s3") { Focus(p, 1800.0); }
            else if (str == "s4") { Focus(p, 3600.0); }
            else if (str == "s5") {
                result = UnitAddItem(carrier, cards[0]);
                assert.Boolean(result && IsItemOwned(cards[0]), "[SkillCardExplore] pickup A");
            } else if (str == "s6") {
                UnitRemoveItem(carrier, cards[0]);
                SetItemPosition(cards[0], centerX - 220.0, centerY);
                assert.Boolean(!IsItemOwned(cards[0]), "[SkillCardExplore] drop A");
            } else if (str == "s7") {
                if (GetLocalPlayer() == p) {
                    topViewAsync = !topViewAsync;
                    if (topViewAsync) { SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 275.0, 0.3); }
                    else { SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.3); }
                }
            } else if (str == "s8") { DzSetWidgetTexture(cards[0], icons[iconIndex], 1); }
            else if (str == "s10") { Help(); }
            p = null;
        });
    }
}
//! endzinc
#endif
