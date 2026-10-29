#ifndef UTItemCubeTextureIncluded
#define UTItemCubeTextureIncluded
#undef OriginMapUnitTestMode
// ItemCubeTextureApply 由 .cfg 自动注入模块，避免双重 include。

// TaskCreateUT.lua 生成测试壳后填充。视觉结果由游戏内观察确认。
//! zinc
library UTItemCubeTexture requires ItemCubeTexture, UnitTestFramwork, Logger {
    private item cubes[];
    private unit carrier = null;
    private integer iconIndex = 0;
    private string icons[];
    private string models[];
    private real centerX;
    private real centerY;
    private boolean topViewAsync = false;

    private function Log(string message) {
        BJDebugMsg("[ItemCubeTexture] " + message);
        Trace("[ItemCubeTexture] " + message);
    }
    private function Help() {
        Log("从左到右：绿 / 淡蓝(A) / 紫 / 橙 / 红 / 魔兽原始物品。五色均使用爪子图标方便比较。");
        Log("s1重建；s2只切换A图标；s3拾取A；s4丢下A(不补贴图)；s5手动补A贴图");
        Log("s6重设A模型(不补贴图)；s7将A绕X轴转90度；s8恢复A矩阵；s9俯视/斜视；s10帮助");
        Log("观察六面图标、B/C是否被A影响，以及拾取/丢下后的贴图是否保留。API无返回值，调用不等于视觉通过。");
    }
    private function Focus(player p, real angle) {
        if (GetLocalPlayer() == p) {
            PanCameraToTimed(centerX, centerY, 0.0);
            // Xlimon CameraControl滚轮上限：ViewLevel=18，每级200。
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 3600.0, 0.0);
            SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, angle, 0.0);
            ClearSelection();
            SelectUnit(carrier, true);
        }
    }
    private function Reset(player p) {
        integer i;
        for (0 <= i < 6) {
            if (cubes[i] != null) { RemoveItem(cubes[i]); cubes[i] = null; }
        }
        if (carrier != null) { RemoveUnit(carrier); carrier = null; }
        centerX = GetRectCenterX(bj_mapInitialPlayableArea);
        centerY = GetRectCenterY(bj_mapInitialPlayableArea);
        carrier = CreateUnit(p, 'Hpal', centerX, centerY - 350.0, 90.0);
        SetUnitInvulnerable(carrier, true);
        iconIndex = 0;
        for (0 <= i < 6) {
            cubes[i] = CreateItem('ratf', centerX + (i - 2.5) * 200.0, centerY);
            assert.Boolean(cubes[i] != null, "[ItemCubeTexture] item created " + I2S(i));
            if (i < 5) {
                DzItemSetModel(cubes[i], models[i]);
                // 模型空间缩至80%，保留之前0.8倍率，最终为原模型的0.64。
                DzItemSetSize(cubes[i], 0.8);
                ItemCubeTextureApply(cubes[i], icons[0]);
            }
            // 最后一个ratf保留原始模型及默认大小，作为尺寸对照。
        }
        assert.Integer(GetItemTypeId(cubes[1]), GetItemTypeId(cubes[2]), "[ItemCubeTexture] A/B same item type");
        Focus(p, 304.0);
        Help();
        Log("五色cube为最初显示大小的80%；最右是原始物品。当前视距3600，俯仰角304度，测试Xlimon最远视距。");
    }
    function onInit() {
        models[0] = "crainax_cube_green.mdx";
        models[1] = "crainax_cube_lightblue.mdx";
        models[2] = "crainax_cube_purple.mdx";
        models[3] = "crainax_cube_orange.mdx";
        models[4] = "crainax_cube.mdx";
        icons[0] = "ReplaceableTextures\\CommandButtons\\BTNClawsOfAttack.blp";
        icons[1] = "ReplaceableTextures\\CommandButtons\\BTNCloakOfFlames.blp";
        icons[2] = "ReplaceableTextures\\CommandButtons\\BTNPotionGreenSmall.blp";
        UnitTestAutoTimer(1.0, 1.0, function() {
            Reset(Player(0));
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();
            boolean result;
            if (str == "s1") { Reset(p); }
            else if (str == "s2") {
                iconIndex = ModuloInteger(iconIndex + 1, 3);
                ItemCubeTextureApply(cubes[1], icons[iconIndex]);
                Log("仅A调用换图：" + icons[iconIndex] + "；观察B/C和固定对照是否保持原样。");
            } else if (str == "s3") {
                result = UnitAddItem(carrier, cubes[1]);
                assert.Boolean(result && IsItemOwned(cubes[1]), "[ItemCubeTexture] pickup A");
            } else if (str == "s4") {
                UnitRemoveItem(carrier, cubes[1]);
                SetItemPosition(cubes[1], centerX - 300.0, centerY);
                assert.Boolean(!IsItemOwned(cubes[1]), "[ItemCubeTexture] drop A");
                Log("A已丢下，未重新设置模型/贴图，请观察是否丢失图标；s5可手动补贴图。");
            } else if (str == "s5") {
                ItemCubeTextureApply(cubes[1], icons[iconIndex]);
                Log("已补A贴图。");
            } else if (str == "s6") {
                DzItemSetModel(cubes[1], models[1]);
                Log("仅重设A模型，未补贴图；观察是否需s5重新应用。");
            } else if (str == "s7") {
                DzItemMatRotateX(cubes[1], 90.0);
                Log("A绕X轴追加旋转90度，检查原底面；s8恢复矩阵。");
            } else if (str == "s8") {
                DzItemMatReset(cubes[1]);
                DzItemSetSize(cubes[1], 0.8);
            } else if (str == "s9") {
                if (GetLocalPlayer() == p) {
                    topViewAsync = !topViewAsync;
                    if (topViewAsync) { Focus(p, 275.0); }
                    else { Focus(p, 304.0); }
                }
            } else if (str == "s10") { Help(); }
            p = null;
        });
    }
}
//! endzinc
#endif
