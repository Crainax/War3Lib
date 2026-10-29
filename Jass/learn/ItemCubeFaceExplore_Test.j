#ifndef UTItemCubeFaceExploreIncluded
#define UTItemCubeFaceExploreIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/ItemCubeFaceExplore.j"

//! zinc
library UTItemCubeFaceExplore requires ItemCubeFaceExplore, UnitTestFramwork {
    private item cube = null;
    private integer iconIndex = 0;
    private string icons[];
    private real centerX;
    private real centerY;
    private real distanceAsync = 1800.0;
    private boolean originalModel = false;
    private boolean topViewAsync = false;

    private function Help() {
        BJDebugMsg("[ItemCubeFaceExplore] 镜头朝向试验：红色cube，保持已确认大小；Stand只有4秒上下浮动。");
        BJDebugMsg("s1重建 / s2切换图标 / s3近距1800 / s4最远3600 / s5原模型对照 / s6单面试验 / s10帮助");
        BJDebugMsg("默认304度俯视；模型Billboarded自动朝向镜头，s7切换俯视角验证。请观察图标正向及侧面；未改Xlimon。");
    }
    private function Focus(player p, real distance) {
        if (GetLocalPlayer() == p) {
            distanceAsync = distance;
            PanCameraToTimed(centerX, centerY, 0.0);
            SetCameraField(CAMERA_FIELD_ROTATION, 90.0, 0.0);
            SetCameraField(CAMERA_FIELD_ROLL, 0.0, 0.0);
            SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.0);
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, distance, 0.0);
            // 对准cube中心，避免镜头盯地面产生额外透视偏斜。
            SetCameraField(CAMERA_FIELD_ZOFFSET, 129.13872 * 0.8, 0.0);
            ClearSelection();
        }
    }
    private function SetModel(boolean original) {
        originalModel = original;
        if (cube == null) { return; }
        if (original) { DzItemSetModel(cube, "crainax_cube.mdx"); }
        else { DzItemSetModel(cube, "crainax_cube_billboard.mdx"); }
        DzItemSetSize(cube, 0.8);
        DzSetWidgetTexture(cube, icons[iconIndex], 1);
    }
    private function Reset(player p) {
        if (cube != null) { RemoveItem(cube); cube = null; }
        centerX = GetRectCenterX(bj_mapInitialPlayableArea);
        centerY = GetRectCenterY(bj_mapInitialPlayableArea);
        cube = CreateItem('ratf', centerX, centerY);
        assert.Boolean(cube != null, "[ItemCubeFaceExplore] cube created");
        SetModel(false);
        Focus(p, distanceAsync);
        Help();
    }
    function onInit() {
        icons[0] = "ReplaceableTextures\\CommandButtons\\BTNPotionGreenSmall.blp";
        icons[1] = "ReplaceableTextures\\CommandButtons\\BTNClawsOfAttack.blp";
        icons[2] = "ReplaceableTextures\\CommandButtons\\BTNCloakOfFlames.blp";
        UnitTestAutoTimer(1.0, 1.0, function() {
            FogEnable(false);
            FogMaskEnable(false);
            Reset(Player(0));
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();
            if (str == "s1") { Reset(p); }
            else if (str == "s2") {
                iconIndex = ModuloInteger(iconIndex + 1, 3);
                DzSetWidgetTexture(cube, icons[iconIndex], 1);
            } else if (str == "s3") { Focus(p, 1800.0); }
            else if (str == "s4") { Focus(p, 3600.0); }
            else if (str == "s5") { SetModel(true); BJDebugMsg("原模型：旋转、多个面。"); }
            else if (str == "s6") { SetModel(false); BJDebugMsg("试验模型：跟随镜头朝向、上下浮动。"); }
            else if (str == "s7") {
                if (GetLocalPlayer() == p) {
                    topViewAsync = !topViewAsync;
                    if (topViewAsync) { SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 275.0, 0.3); }
                    else { SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.3); }
                }
            } else if (str == "s10") { Help(); }
            p = null;
        });
    }
}
//! endzinc
#endif
