#ifndef UTCommandButtonExploreIncluded
#define UTCommandButtonExploreIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/CommandButtonExplore.j"

/*
TaskCreateUT.lua 生成测试壳后填充。所有实验只修改本测试创建的 A；B 为同类型对照。
s1/-reset 重建；s2/s3/s4 按钮坐标隐藏移动/攻击/两者；
s5/s6/s7 DzAbilitySetEnable(true,true) 隐藏移动/攻击/两者；
s8 UI 按命令移出屏幕（移动/攻击/停止/巡逻/保持位置）；s9 状态；s10 帮助。
-pos-move/-pos-attack/-pos-both 设置位置后立即同步刷新对应能力（mode=5）。
-disable-move/-disable-attack/-disable-both DzAbilitySetEnable(false,true)（mode=6）。
-enable-refresh 对两种能力执行 DzAbilitySetEnable(true,true) 后同步刷新（mode=7）。
新增方案不自动重选；观察首次效果后用-b/-a检查重选是否改变结果。
-refresh 同步刷新 A 的 Amov/Aatk；-restore 等同重建，避免猜测内部计数与按钮恢复值。
-a/-b 选择 A/B；-move/-attack/-stop/-hold/-patrol 对 A 发脚本命令；
-bmove/-battack 对 B 发脚本命令；-slots 输出当前本地命令栏；-ui-off 恢复 UI。
-remove-move/-remove-attack 移除能力的破坏性对照（先重建，仍只影响测试 A）。
-ui-move/-ui-attack 只移动对应命令 Frame；-clean 删除本玩家夹具并恢复 UI。
每次方案自动重建 A/B/靶子，不叠加上一次实验；只有 -refresh 在当前方案上操作。
观察：A/B切换、多选、快捷键、右键地面/敌人、脚本移动、攻击，以及停止/巡逻/保持。
API 返回 true 和 ability 非空都不代表视觉或行为成功，必须进游戏确认。
不注入当前 KK 声明中不存在的 Blz native；Root/SilenceEx 非本夹具测试范围。
*/
//! zinc
library UTCommandButtonExplore requires CommandButtonExplore, UnitTestFramwork, SpellBtns, Hardware, Logger {
    private unit subjects[];
    private unit controls[];
    private unit targets[];
    private integer modes[];
    private integer masks[];
    // 以下状态仅由本地 UI 回调使用，不能用于同步游戏逻辑。
    private boolean outsideAsync[];
    private boolean uiReady = false;

    private function BoolText(boolean value) -> string {
        if (value) { return "true"; }
        return "false";
    }
    private function Log(player p, string message) {
        DisplayTimedTextToPlayer(p, 0, 0, 20, "[CommandButtonExplore] " + message);
        Trace("[CommandButtonExplore] p=" + I2S(GetPlayerId(p)) + " " + message);
    }
    private function Help(player p) {
        Log(p, "s1重建 | s2位置:移动 | s3位置:攻击 | s4位置:两者");
        Log(p, "s5启用+隐藏:移动 | s6启用+隐藏:攻击 | s7启用+隐藏:两者");
        Log(p, "s8本地UI隐藏五种命令 | s9状态 | s10帮助；每个方案均先重建");
        Log(p, "-a/-b选择对照；-move/-attack/-stop/-hold/-patrol脚本命令；-bmove/-battack对照");
        Log(p, "-refresh刷新数据；-slots本地按钮ID；-ui-move/-ui-attack/-ui-off；-restore重建恢复");
        Log(p, "-remove-move/-remove-attack移除能力对照；-clean清理；按s9比较命令后位置/靶子血量");
        Log(p, "-pos-move/-pos-attack/-pos-both：位置隐藏+自动同步刷新");
        Log(p, "-disable-move/-disable-attack/-disable-both：禁用+隐藏(false,true)，可能同时失去行为能力");
        Log(p, "-enable-refresh：启用+隐藏两者后自动刷新；新方案均重建，不自动重选");
        Log(p, "只操作测试A。B保持原样。返回值成功不等于按钮隐藏或移动/攻击行为成功。");
    }
    private function SelectSubject(player p, boolean control) {
        integer id = GetPlayerId(p);
        unit u = subjects[id];
        if (control) { u = controls[id]; }
        if (u != null && GetLocalPlayer() == p) {
            ClearSelection();
            SelectUnit(u, true);
            PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.25);
        }
        u = null;
    }
    private function Cleanup(player p) {
        integer id = GetPlayerId(p);
        modes[id] = 0;
        masks[id] = 0;
        if (subjects[id] != null) { RemoveUnit(subjects[id]); }
        if (controls[id] != null) { RemoveUnit(controls[id]); }
        if (targets[id] != null) { RemoveUnit(targets[id]); }
        subjects[id] = null;
        controls[id] = null;
        targets[id] = null;
    }
    private function Reset(player p) {
        integer id = GetPlayerId(p);
        real x = GetRectCenterX(bj_mapInitialPlayableArea);
        real y = GetRectCenterY(bj_mapInitialPlayableArea);
        Cleanup(p);
        subjects[id] = CreateUnit(p, 'hfoo', x - 250, y - 150, 0);
        controls[id] = CreateUnit(p, 'hfoo', x - 250, y + 150, 0);
        targets[id] = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'hhou', x + 850, y, 180);
        SetUnitColor(subjects[id], PLAYER_COLOR_RED);
        SetUnitColor(controls[id], PLAYER_COLOR_BLUE);
        SetUnitInvulnerable(subjects[id], true);
        SetUnitInvulnerable(controls[id], true);
        assert.Boolean(subjects[id] != null && controls[id] != null && targets[id] != null, "[CommandButtonExplore] fixtures created");
        assert.Integer(GetUnitTypeId(subjects[id]), GetUnitTypeId(controls[id]), "[CommandButtonExplore] same type A/B");
        SelectSubject(p, false);
        Log(p, "已重建：红色步兵A=实验，蓝色步兵B=对照，东侧农场=攻击靶。当前选择A。");
    }
    private function ApplyPosition(player p, integer abil) {
        boolean result = DzSetUnitAbilityButtonPos(subjects[GetPlayerId(p)], abil, 0, -11);
        Log(p, "DzSetUnitAbilityButtonPos ability=" + I2S(abil) + " result=" + BoolText(result));
    }
    private function ApplyEnable(player p, integer abil, boolean enable) {
        ability a = DzUnitFindAbility(subjects[GetPlayerId(p)], abil);
        Log(p, "DzUnitFindAbility id=" + I2S(abil) + " handle=" + I2S(GetHandleId(a)));
        if (a != null) {
            DzAbilitySetEnable(a, enable, true);
            Log(p, "DzAbilitySetEnable(enable=" + BoolText(enable) + ", hideUI=true) 已调用；此API无返回值");
        } else {
            Log(p, "未找到技能实例，跳过调用；不能据此宣称隐藏成功");
        }
        a = null;
    }
    // 必须从同步聊天事件调用，不能在 UpdateUI 或本地选中分支调用。
    private function RefreshAbilities(player p, integer mask) {
        boolean result;
        unit u = subjects[GetPlayerId(p)];
        if (u == null) { Log(p, "先输入s1创建夹具"); return; }
        if (mask == 1 || mask == 3) {
            result = DzSetUnitAbilityUpdate(u, 'Amov');
            Log(p, "同步刷新Amov=" + BoolText(result));
        }
        if (mask == 2 || mask == 3) {
            result = DzSetUnitAbilityUpdate(u, 'Aatk');
            Log(p, "同步刷新Aatk=" + BoolText(result));
        }
        u = null;
    }
    private function Scenario(player p, integer mode, integer mask) {
        integer id = GetPlayerId(p);
        Reset(p);
        modes[id] = mode;
        masks[id] = mask;
        Log(p, "方案mode=" + I2S(mode) + " mask=" + I2S(mask) + " (1移动/2攻击/3两者/31全部UI命令)");
        if (mode == 1 || mode == 5) {
            if (mask == 1 || mask == 3) { ApplyPosition(p, 'Amov'); }
            if (mask == 2 || mask == 3) { ApplyPosition(p, 'Aatk'); }
            if (mode == 5) {
                Log(p, "位置隐藏后自动同步刷新；mode=5");
                RefreshAbilities(p, mask);
            } else { Log(p, "位置方案未自动刷新，需时输入-refresh"); }
        } else if (mode == 2 || mode == 6 || mode == 7) {
            if (mask == 1 || mask == 3) { ApplyEnable(p, 'Amov', mode != 6); }
            if (mask == 2 || mask == 3) { ApplyEnable(p, 'Aatk', mode != 6); }
            if (mode == 7) {
                Log(p, "启用+隐藏后自动同步刷新；mode=7");
                RefreshAbilities(p, mask);
            } else if (mode == 6) { Log(p, "禁用+隐藏方案，不自动刷新；先观察，再按需-refresh；-restore重建恢复"); }
        } else if (mode == 4) {
            if (mask == 1) { Log(p, "移除Amov result=" + BoolText(UnitRemoveAbility(subjects[id], 'Amov'))); }
            else { Log(p, "移除Aatk result=" + BoolText(UnitRemoveAbility(subjects[id], 'Aatk'))); }
        }
    }
    private function SnapshotUnit(player p, unit u, string label) {
        Log(p, label + " handle=" + I2S(GetHandleId(u)) + " xy=" + R2S(GetUnitX(u)) + "," + R2S(GetUnitY(u)) + " currentOrder=" + I2S(GetUnitCurrentOrder(u)));
        Log(p, label + " AmovLevel=" + I2S(GetUnitAbilityLevel(u, 'Amov')) + " AatkLevel=" + I2S(GetUnitAbilityLevel(u, 'Aatk')) + " speed=" + R2S(GetUnitMoveSpeed(u)));
    }
    private function Snapshot(player p) {
        integer id = GetPlayerId(p);
        if (subjects[id] == null) { Log(p, "先输入s1创建夹具"); return; }
        Log(p, "mode=" + I2S(modes[id]) + " mask=" + I2S(masks[id]));
        SnapshotUnit(p, subjects[id], "A");
        SnapshotUnit(p, controls[id], "B");
        Log(p, "靶子HP=" + R2S(GetWidgetLife(targets[id])) + "；视觉效果请人工观察，-slots查询当前本地命令栏");
    }
    private function DumpSlots(player p) {
        integer row;
        integer col;
        integer frame;
        if (!uiReady || GetLocalPlayer() != p) { return; }
        // 此函数只读取本地UI和输出日志，不改变同步单位状态。
        Log(p, "LOCAL leader=" + I2S(GetHandleId(DzGetSelectedLeaderUnit())));
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                frame = spellBtns.grid[row][col];
                if (frame != 0) {
                    Log(p, "LOCAL row=" + I2S(row) + " col=" + I2S(col) + " ability=" + I2S(KKCommandButtonGetAbilityId(frame)) + " order=" + I2S(KKCommandButtonGetOrderId(frame)) + " outside=" + BoolText(outsideAsync[(row-1)*4+col]));
                }
            }
        }
    }
    private function UpdateUI() {
        integer id = -1;
        integer i;
        integer row;
        integer col;
        integer slot;
        integer order;
        integer mask = 0;
        boolean hide;
        unit u;
        if (!uiReady) { return; }
        u = DzGetSelectedLeaderUnit();
        if (u != null) {
            for (0 <= i < bj_MAX_PLAYERS) {
                if (u == subjects[i] && modes[i] == 3) { id = i; }
            }
        }
        if (id >= 0) { mask = masks[id]; }
        for (1 <= row <= 3) {
            for (1 <= col <= 4) {
                slot = (row-1)*4+col;
                if (spellBtns.grid[row][col] != 0) {
                    order = KKCommandButtonGetOrderId(spellBtns.grid[row][col]);
                    hide = (mask == 1 || mask == 3 || mask == 31) && order == OrderId("move");
                    hide = hide || ((mask == 2 || mask == 3 || mask == 31) && order == OrderId("attack"));
                    hide = hide || (mask == 31 && (order == OrderId("stop") || order == OrderId("patrol") || order == OrderId("holdposition")));
                    if (hide) {
                        // 持续施加位置，观察引擎刷新是否会覆盖；不改变任何单位能力。
                        spellBtns.outside(row, col);
                        outsideAsync[slot] = true;
                    } else if (outsideAsync[slot]) {
                        spellBtns.inside(row, col);
                        outsideAsync[slot] = false;
                    }
                }
            }
        }
        u = null;
    }
    private function ScriptOrder(player p, string command, boolean control) {
        integer id = GetPlayerId(p);
        real x = GetRectCenterX(bj_mapInitialPlayableArea);
        real y = GetRectCenterY(bj_mapInitialPlayableArea);
        boolean result = false;
        unit u = subjects[id];
        if (control) { u = controls[id]; }
        if (u == null) { Log(p, "先输入s1创建夹具"); return; }
        if (command == "move" || command == "patrol") {
            // 相对当前位置向上走，重复测试仍有可观察位移。
            result = IssuePointOrder(u, command, x, GetUnitY(u) + 400);
        } else if (command == "attack") {
            if (GetWidgetLife(targets[id]) <= 0.405) { Log(p, "靶子已死亡，请s1或重选方案重建"); u = null; return; }
            result = IssueTargetOrder(u, command, targets[id]);
        } else { result = IssueImmediateOrder(u, command); }
        Log(p, "script unit=" + I2S(GetHandleId(u)) + " command=" + command + " accepted=" + BoolText(result) + "；稍后s9检查实际行为");
        u = null;
    }
    function TTestActUTCommandButtonExplore1(string str) {
        integer id = GetPlayerId(GetTriggerPlayer());
        player p = GetTriggerPlayer();
        Log(p, "CHAT -" + str);
        if (str == "reset" || str == "restore") { Reset(p); }
        else if (str == "help") { Help(p); }
        else if (str == "a") { SelectSubject(p, false); }
        else if (str == "b") { SelectSubject(p, true); }
        else if (str == "slots") { DumpSlots(p); }
        else if (str == "status") { Snapshot(p); }
        else if (str == "pos-move") { Scenario(p, 5, 1); }
        else if (str == "pos-attack") { Scenario(p, 5, 2); }
        else if (str == "pos-both") { Scenario(p, 5, 3); }
        else if (str == "disable-move") { Scenario(p, 6, 1); }
        else if (str == "disable-attack") { Scenario(p, 6, 2); }
        else if (str == "disable-both") { Scenario(p, 6, 3); }
        else if (str == "enable-refresh") { Scenario(p, 7, 3); }
        else if (str == "ui-move") { Scenario(p, 3, 1); }
        else if (str == "ui-attack") { Scenario(p, 3, 2); }
        else if (str == "ui-off") {
            if (modes[id] == 3) { modes[id] = 0; masks[id] = 0; Log(p, "UI隐藏已关闭，下一帧恢复"); }
            else { Log(p, "当前不是UI方案；能力修改请用-restore重建恢复"); }
        }
        else if (str == "remove-move") { Scenario(p, 4, 1); }
        else if (str == "remove-attack") { Scenario(p, 4, 2); }
        else if (str == "clean") { Cleanup(p); Log(p, "夹具已清理，下一帧恢复UI"); }
        else if (str == "refresh") { RefreshAbilities(p, 3); }
        else if (str == "move" || str == "attack" || str == "stop" || str == "patrol") { ScriptOrder(p, str, false); }
        else if (str == "hold") { ScriptOrder(p, "holdposition", false); }
        else if (str == "bmove") { ScriptOrder(p, "move", true); }
        else if (str == "battack") { ScriptOrder(p, "attack", true); }
        else { Log(p, "未知指令，输入s10查看帮助"); }
        p = null;
    }
    function onInit() {
        UnitTestAutoTimer(1.0, 1.0, function() {
            uiReady = true;
            hardware.regUpdateEvent(function UpdateUI);
            Help(GetLocalPlayer());
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            player p = GetTriggerPlayer();
            if (str == "s1") { Reset(p); }
            else if (str == "s2") { Scenario(p, 1, 1); }
            else if (str == "s3") { Scenario(p, 1, 2); }
            else if (str == "s4") { Scenario(p, 1, 3); }
            else if (str == "s5") { Scenario(p, 2, 1); }
            else if (str == "s6") { Scenario(p, 2, 2); }
            else if (str == "s7") { Scenario(p, 2, 3); }
            else if (str == "s8") { Scenario(p, 3, 31); }
            else if (str == "s9") { Snapshot(p); }
            else if (str == "s10") { Help(p); }
            else if (SubString(str, 0, 1) == "-") { TTestActUTCommandButtonExplore1(SubString(str, 1, StringLength(str))); }
            p = null;
        });
    }
}
//! endzinc
#endif
