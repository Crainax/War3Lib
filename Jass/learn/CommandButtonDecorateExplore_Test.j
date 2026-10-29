#ifndef UTCommandButtonDecorateExploreIncluded
#define UTCommandButtonDecorateExploreIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/CommandButtonDecorateExplore.j"

/*
V2：只在原生攻击按钮上覆盖 Decoration，不创建技能按钮，不隐藏/移动原生按钮，
不添加模拟技能，不改写点击/命令。红A=实验步兵，蓝B=对照，东侧敌方农场=攻击靶。
s1 重建基线；s2 SetAbilityDecorateIcon(A,'Aatk',...)；
s3 按 attack 命令定位原生按钮，直接绘制其现有 spellBtns.icons[row][col] 装饰层；
s4 同s3但换宝箱图标，验证动态更新；s5 清除装饰（保留单位）；s9/-slots 诊断；s10 帮助。
-a/-b 切换单位；-restore 同s5；-clean 删除夹具。
测试目标：图标覆盖成功、切B正常、切A恢复、点装饰图标仍能下达原生attack命令。
原生提示/快捷键仍是攻击；本测试仅证明覆盖外观，不证明释放其他技能或腾出格子。
*/
//! zinc
library UTCommandButtonDecorateExplore requires CommandButtonDecorateExplore, AbilityDecorate, Hardware, UnitTestFramwork, Logger {
    private unit subjects[];
    private unit controls[];
    private unit targets[];
    private integer modes[];
    private integer attackOrders[];
    // 仅用于本地UI清理，不参与单位数据写入。
    private boolean directSlotAsync[];

    private function Log(player p, string text) {
        DisplayTimedTextToPlayer(p, 0, 0, 20, "[CommandDecorateV2] " + text);
        Trace("[CommandDecorateV2] p=" + I2S(GetPlayerId(p)) + " " + text);
    }
    private function Help(player p) {
        Log(p, "V2只覆盖原生攻击按钮：s1重建 | s2按Aatk装饰API | s3直接装饰攻击槽 | s4换宝箱 | s5清除");
        Log(p, "-a/-b选择红A/蓝B；s9或-slots诊断；s10帮助；-restore清除；-clean清理");
        Log(p, "重点s3：攻击按钮应变暴风雪图标+TEST角标；点击后点东侧农场仍应正常攻击");
    }
    private function ClearDirectUI() {
        integer row;
        integer col;
        integer slot;
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                slot = (row-1)*4+col;
                if (directSlotAsync[slot]) {
                    spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(false);
                    spellBtns.icons[row][col].setCornerText(null);
                    directSlotAsync[slot] = false;
                }
            }
        }
    }
    private function ClearDecor(player p) {
        integer id = GetPlayerId(p);
        modes[id] = 0;
        ClearDirectUI();
        if (subjects[id] != null) {
            SetAbilityDecorateIcon(subjects[id], 'Aatk', null);
            SetAbilityDecorateCornerText(subjects[id], 'Aatk', null);
        }
    }
    private function Cleanup(player p) {
        integer id = GetPlayerId(p);
        ClearDecor(p);
        if (subjects[id] != null) { RemoveUnit(subjects[id]); }
        if (controls[id] != null) { RemoveUnit(controls[id]); }
        if (targets[id] != null) { RemoveUnit(targets[id]); }
        subjects[id] = null;
        controls[id] = null;
        targets[id] = null;
        attackOrders[id] = 0;
    }
    private function SelectFixture(player p, boolean control) {
        unit u = subjects[GetPlayerId(p)];
        if (control) { u = controls[GetPlayerId(p)]; }
        if (u != null && GetLocalPlayer() == p) {
            ClearSelection();
            SelectUnit(u, true);
            PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.2);
        }
        u = null;
    }
    private function Reset(player p) {
        integer id = GetPlayerId(p);
        real x = GetRectCenterX(bj_mapInitialPlayableArea);
        real y = GetRectCenterY(bj_mapInitialPlayableArea);
        Cleanup(p);
        subjects[id] = CreateUnit(p, 'hfoo', x-150, y-150, 0);
        controls[id] = CreateUnit(p, 'hfoo', x-150, y+150, 0);
        targets[id] = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'hhou', x+800, y, 180);
        SetUnitColor(subjects[id], PLAYER_COLOR_RED);
        SetUnitColor(controls[id], PLAYER_COLOR_BLUE);
        assert.Boolean(subjects[id] != null && controls[id] != null && targets[id] != null, "[CommandDecorateV2] fixtures created");
        SelectFixture(p, false);
        Log(p, "基线：红A实验/蓝B对照/东侧农场。没有添加任何测试技能。");
    }
    private function Scenario(player p, integer mode) {
        integer id = GetPlayerId(p);
        if (subjects[id] == null) { Reset(p); }
        ClearDecor(p);
        modes[id] = mode;
        SelectFixture(p, false);
        if (mode == 2) {
            SetAbilityDecorateIcon(subjects[id], 'Aatk', "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp");
            SetAbilityDecorateCornerText(subjects[id], 'Aatk', "TEST");
        }
        Log(p, "mode=" + I2S(mode) + "；2=Aatk装饰API，3=按命令直接覆盖暴风雪，4=直接覆盖宝箱");
    }
    private function UpdateUI() {
        integer i;
        integer mode = 0;
        integer row;
        integer col;
        integer slot;
        boolean decorate;
        unit selected = DzGetSelectedLeaderUnit();
        for (0 <= i < bj_MAX_PLAYERS) {
            if (selected != null && selected == subjects[i]) { mode = modes[i]; }
        }
        // 在 AbilityDecorate 的刷新回调之后注册；绕过默认命令的能力ID识别问题。
        // 只使用已经锚定到原生按钮上的装饰图片，不操作grid按钮的位置/可见性/点击。
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                slot = (row-1)*4+col;
                decorate = false;
                if (spellBtns.grid[row][col] != 0 && (mode == 3 || mode == 4)) {
                    decorate = KKCommandButtonGetOrderId(spellBtns.grid[row][col]) == OrderId("attack");
                }
                if (decorate) {
                    if (mode == 4) {
                        spellBtns.icons[row][col].setTexture("ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp").show(true);
                    } else {
                        spellBtns.icons[row][col].setTexture("ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp").show(true);
                    }
                    spellBtns.icons[row][col].setCornerText("TEST");
                    directSlotAsync[slot] = true;
                } else if (directSlotAsync[slot]) {
                    spellBtns.icons[row][col].setTexture(UI_STRING_PATH_BLANK).show(false);
                    spellBtns.icons[row][col].setCornerText(null);
                    directSlotAsync[slot] = false;
                }
            }
        }
        selected = null;
    }
    private function Dump(player p) {
        integer id = GetPlayerId(p);
        integer row;
        integer col;
        integer frame;
        integer found = 0;
        Log(p, "mode=" + I2S(modes[id]) + " A attack orders=" + I2S(attackOrders[id]));
        if (targets[id] != null) { Log(p, "靶子HP=" + R2S(GetWidgetLife(targets[id]))); }
        if (GetLocalPlayer() != p) { return; }
        Log(p, "LOCAL leader=" + I2S(GetHandleId(DzGetSelectedLeaderUnit())));
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                frame = spellBtns.grid[row][col];
                if (frame != 0 && KKCommandButtonGetOrderId(frame) == OrderId("attack")) {
                    found += 1;
                    Log(p, "LOCAL ATTACK row=" + I2S(row) + " col=" + I2S(col) + " nativeFrame=" + I2S(frame) + " decorFrame=" + I2S(spellBtns.icons[row][col].mainImage.ui));
                    Log(p, "LOCAL LuaAbility=" + I2S(GetCurrentXYAbility(col-1, row-1)) + " KKAbility=" + I2S(KKCommandButtonGetAbilityId(frame)) + " expectedAatk=" + I2S('Aatk') + " order=" + I2S(KKCommandButtonGetOrderId(frame)));
                }
            }
        }
        Log(p, "LOCAL attack slot count=" + I2S(found) + "；绘制是否可见请人工观察");
    }
    private function OnOrder() {
        integer id;
        unit u = GetTriggerUnit();
        for (0 <= id < bj_MAX_PLAYERS) {
            if (u == subjects[id]) {
                if (GetIssuedOrderId() == OrderId("attack")) { attackOrders[id] += 1; }
                Log(Player(id), "ORDER A id=" + I2S(GetIssuedOrderId()) + " name=" + OrderId2String(GetIssuedOrderId()) + " target=" + I2S(GetHandleId(GetOrderTargetUnit())));
            }
        }
        u = null;
    }
    function onInit() {
        trigger events = CreateTrigger();
        TriggerRegisterAnyUnitEventBJ(events, EVENT_PLAYER_UNIT_ISSUED_ORDER);
        TriggerRegisterAnyUnitEventBJ(events, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER);
        TriggerRegisterAnyUnitEventBJ(events, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER);
        TriggerAddAction(events, function OnOrder);
        events = null; // 地图全生命周期的观测监听器
        UnitTestAutoTimer(1, 1, function() {
            hardware.regUpdateEvent(function UpdateUI);
            Help(GetLocalPlayer());
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();
            Log(p, "CHAT " + str);
            if (str == "s1") { Reset(p); }
            else if (str == "s2") { Scenario(p, 2); }
            else if (str == "s3") { Scenario(p, 3); }
            else if (str == "s4") { Scenario(p, 4); }
            else if (str == "s5" || str == "-restore") { ClearDecor(p); Log(p, "已清除A装饰，保留原生按钮和单位"); }
            else if (str == "s9" || str == "-slots") { Dump(p); }
            else if (str == "-a") { SelectFixture(p, false); }
            else if (str == "-b") { SelectFixture(p, true); }
            else if (str == "-clean") { Cleanup(p); }
            else { Help(p); }
            p = null;
        });
    }
}
//! endzinc
#endif
