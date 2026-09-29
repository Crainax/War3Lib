#ifndef UTDzSetUnitIDExploreIncluded
#define UTDzSetUnitIDExploreIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/DzSetUnitIDExplore.j"
//! zinc
// TaskCreateUT-generated harness. Always brace control statements: inspect emitted JASS too.
library UTDzSetUnitIDExplore requires DzSetUnitIDExplore, Logger {
    private unit units[];
    private integer handles[];
    private trigger watches[];
    private integer deaths[];
    private integer hits[];
    private integer playerDeaths = 0;
    private integer run = 0;
    private integer mode = 0;
    private integer ticks = 0;
    private integer failures = 0;
    private integer turn = 0;
    private integer suite = 0;
    private timer clock = null;
    private timer nextTest = null;
    private player owner = null;
    private real x = 0.;
    private real y = 0.;
    private boolean ready = false;
    private unit dummy = null;

    private function Notice(string s) { BJDebugMsg("[DzSetID] " + s); }
    private function Log(string s) { Trace("[DzSetID] run=" + I2S(run) + " mode=" + I2S(mode) + " tick=" + I2S(ticks) + " " + s); }
    private function Bit(boolean b) -> integer { if (b) { return 1; } return 0; }
    private function Alive(unit u) -> boolean { return u != null && GetUnitTypeId(u) != 0 && !IsUnitType(u, UNIT_TYPE_DEAD) && GetWidgetLife(u) > .405; }
    private function Check(boolean ok, string s) {
        if (!ok) { failures += 1; assert.Boolean(false, "[DzSetID] " + s); }
        Log("CHECK ok=" + I2S(Bit(ok)) + " " + s);
    }
    private function Snapshot(integer i, string tag) {
        unit u = units[i];
        Log(tag + " slot=" + I2S(i) + " handle=" + I2S(GetHandleId(u)) + " original=" + I2S(handles[i]) + " type=" + I2S(GetUnitTypeId(u)));
        if (GetUnitTypeId(u) != 0) {
            Log("STATE slot=" + I2S(i) + " name=" + GetUnitName(u) + " alive=" + I2S(Bit(Alive(u))) + " owner=" + I2S(GetPlayerId(GetOwningPlayer(u))) + " hp=" + R2S(GetWidgetLife(u)) + "/" + R2S(GetUnitState(u, UNIT_STATE_MAX_LIFE)) + " mp=" + R2S(GetUnitState(u, UNIT_STATE_MANA)) + "/" + R2S(GetUnitState(u, UNIT_STATE_MAX_MANA)));
            Log("ENGINE slot=" + I2S(i) + " attackBase=" + R2S(GetUnitState(u, ConvertUnitState(0x12))) + " armor=" + R2S(GetUnitState(u, ConvertUnitState(0x20))) + " speed=" + R2S(GetUnitMoveSpeed(u)) + " range=" + R2S(GetUnitState(u, ConvertUnitState(0x16))) + " xy=" + R2S(GetUnitX(u)) + "," + R2S(GetUnitY(u)));
            Log("ATTACK slot=" + I2S(i) + " interval=" + R2S(GetUnitState(u, ConvertUnitState(0x25))) + " dice=" + R2S(GetUnitState(u, ConvertUnitState(0x10))) + " sides=" + R2S(GetUnitState(u, ConvertUnitState(0x11))) + " rangedFlag=" + I2S(Bit(IsUnitType(u, UNIT_TYPE_RANGED_ATTACKER))));
            Log("EXTRA slot=" + I2S(i) + " data=" + I2S(GetUnitUserData(u)) + " paused=" + I2S(Bit(IsUnitPaused(u))) + " hidden=" + I2S(Bit(IsUnitHidden(u))) + " defend=" + I2S(GetUnitAbilityLevel(u, 'Adef')) + " heal=" + I2S(GetUnitAbilityLevel(u, 'Ahea')) + " berserk=" + I2S(GetUnitAbilityLevel(u, 'Absk')) + " buff=" + I2S(GetUnitAbilityLevel(u, 'Bbsk')) + " deaths=" + I2S(deaths[i]) + " hits=" + I2S(hits[i]));
            if (GetUnitAbilityLevel(u, 'Absk') > 0) { Log("COOLDOWN slot=" + I2S(i) + " berserk=" + R2S(DzGetUnitAbilityCool(u, 'Absk'))); }
        }
        u = null;
    }
    private function AllSnapshots(string tag) {
        integer i;
        for (1 <= i <= 3) { Snapshot(i, tag); }
    }
    private function Cleanup() {
        integer i;
        PauseTimer(clock);
        ready = false;
        for (1 <= i <= 3) {
            if (watches[i] != null) { DestroyTrigger(watches[i]); }
            watches[i] = null;
            if (units[i] != null && GetUnitTypeId(units[i]) != 0) { RemoveUnit(units[i]); }
            units[i] = null;
        }
        if (dummy != null) { RemoveUnit(dummy); }
        dummy = null;
        mode = 0;
    }
    private function Setup(integer m, player p) {
        integer i;
        Cleanup();
        run += 1; mode = m; ticks = 0; failures = 0; turn = 0; playerDeaths = 0;
        owner = p;
        x = GetStartLocationX(GetPlayerStartLocation(p));
        y = GetStartLocationY(GetPlayerStartLocation(p)) + 400.;
        for (1 <= i <= 3) {
            if (i == 3) { units[i] = CreateUnit(p, 'hmpr', x + (i - 2) * 500., y, 270.); }
            else { units[i] = CreateUnit(p, 'hfoo', x + (i - 2) * 500., y, 270.); }
            handles[i] = GetHandleId(units[i]); deaths[i] = 0; hits[i] = 0;
            if (i == 3) { IssueImmediateOrder(units[i], "healoff"); }
            watches[i] = CreateTrigger();
            TriggerRegisterUnitEvent(watches[i], units[i], EVENT_UNIT_DEATH);
            TriggerRegisterUnitEvent(watches[i], units[i], EVENT_UNIT_DAMAGED);
            TriggerAddAction(watches[i], function() {
                integer j;
                for (1 <= j <= 3) {
                    if (GetTriggerUnit() == units[j]) {
                        if (GetTriggerEventId() == EVENT_UNIT_DEATH) { deaths[j] += 1; Log("DEATH slot=" + I2S(j) + " n=" + I2S(deaths[j]) + " killer=" + I2S(GetHandleId(GetKillingUnit()))); }
                        else { hits[j] += 1; Log("DAMAGE slot=" + I2S(j) + " amount=" + R2S(GetEventDamage()) + " source=" + I2S(GetHandleId(GetEventDamageSource()))); }
                    }
                }
            });
        }
        PanCameraToTimedForPlayer(p, x, y, 0.);
        Log("BEGIN v1 left=A(hfoo) middle=experiment right=B(hmpr)");
        Notice("开始 s" + I2S(m) + "：左=原始步兵，中=实验单位，右=原始牧师。等待阶段提示。");
        AllSnapshots("BASELINE");
    }
    private function Change(integer id) {
        Log("SET_ID_BEGIN target=" + I2S(id));
        DzSetUnitID(units[2], id);
        Log("SET_ID_RETURNED");
        Snapshot(2, "RAW_AFTER_SET_ID");
        Check(GetHandleId(units[2]) == handles[2], "same unit handle");
        Check(GetUnitTypeId(units[2]) == id, "requested type reflected by getter");
        Check(GetUnitTypeId(units[1]) == 'hfoo' && GetUnitTypeId(units[3]) == 'hmpr', "control types unchanged");
    }
    private function Revive() {
        if (Alive(units[2])) { Log("REVIVE_SKIPPED already alive after preceding operation"); return; }
        Log("REVIVE_BEGIN");
        DzReviveUnit(units[2], owner, 120., 30., x, y);
        Log("REVIVE_RETURNED");
        Snapshot(2, "RAW_AFTER_REVIVE");
        Check(Alive(units[2]), "revived alive");
        Check(GetHandleId(units[2]) == handles[2], "revival same handle");
    }
    private function End() {
        PauseTimer(clock); ready = true;
        AllSnapshots("FINAL");
        Log("END failures=" + I2S(failures) + " playerDeaths=" + I2S(playerDeaths));
        Notice("END s" + I2S(mode) + "，失败断言=" + I2S(failures) + "。单位保留供比较；-status记录，-stop清理。");
        if (suite > 0) {
            if (failures > 0) { suite = 0; Notice("自动测试停止，请提供日志；类型断言失败不等于所有API效果都无效。"); }
            else if (suite == 4) { suite = 0; Notice("基础整套完成。复活组合 s5/s6/s7 请分别手动启动。"); }
            else {
                suite += 1;
                TimerStart(nextTest, 3., false, function() { Start(suite, owner); });
            }
        }
    }
    private function Step() {
        ticks += 1;
        if (mode == 1 || mode == 3 || mode == 4 || mode == 5) {
            if (mode == 3 && ticks == 5) {
                Check(GetUnitAbilityLevel(units[2], 'Bbsk') > 0, "fixture berserk active");
                Log("fixture cooldownSet=" + I2S(Bit(DzSetUnitAbilityCool(units[2], 'Absk', 20., 30.))));
                PauseUnit(units[2], true);
                Snapshot(2, "CUSTOM_BEFORE_CHANGE");
            }
            if (ticks == 20) { Notice("正在将中间单位改为牧师；不补设模型、属性或技能。"); Change('hmpr'); }
            if (ticks == 21) { Snapshot(2, "NEXT_TICK"); }
            if (ticks == 30) { AllSnapshots("ONE_SECOND_LATER"); }
            if (mode == 1) {
                if (ticks == 40) { Log("moveOrder=" + I2S(Bit(IssuePointOrder(units[2], "move", x, y - 250.)))); Notice("中间单位正在尝试向下移动，请观察模型、头像和按钮。"); }
                if (ticks == 80) { Check(RAbsBJ(GetUnitY(units[2]) - y) > 20., "movement without repairs"); End(); }
            } else if (mode == 3 && ticks == 50) { End(); }
            else if (mode == 4 || mode == 5) {
                if (ticks == 40) {
                    if (mode == 4) { Notice("伤害致死：检查原监听是否仍触发。"); UnitDamageTarget(units[1], units[2], 100000., false, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS); }
                    else { Notice("路线一：活体改类型后，执行死亡。"); KillUnit(units[2]); }
                    Snapshot(2, "AFTER_DEATH");
                    Check(deaths[2] == 1 && playerDeaths == 1, "both death listeners exactly once");
                    if (mode == 4) { Check(hits[2] > 0, "existing damage listener fired"); }
                }
                if (mode == 4 && ticks == 50) { End(); }
                if (mode == 5 && ticks == 70) { Revive(); }
                if (mode == 5 && ticks == 80) { Check(GetUnitTypeId(units[2]) == 'hmpr', "type B retained after revival"); End(); }
            }
        } else if (mode == 2) {
            if (ModuloInteger(ticks, 20) == 0) {
                turn += 1;
                if (ModuloInteger(turn, 2) == 1) { Change('hmpr'); }
                else { Change('hfoo'); }
                if (ModuloInteger(turn, 5) == 0) { Notice("往返切换进度：" + I2S(turn) + "/20次。"); }
                if (failures > 0 || turn == 20) { End(); }
            }
        } else if (mode == 6 || mode == 7) {
            if (ticks == 20) { Notice("先杀死原始步兵。"); KillUnit(units[2]); Snapshot(2, "DEAD_A"); }
            if (ticks == 50) {
                if (mode == 6) { Notice("路线二：在尸体上修改类型。"); Change('hmpr'); }
                else { Notice("路线三：先复活步兵。"); Revive(); }
            }
            if (ticks == 51) { Snapshot(2, "NEXT_TICK"); }
            if (ticks == 70) {
                if (mode == 6) { Revive(); }
                else { Change('hmpr'); }
            }
            if (ticks == 80) { Snapshot(2, "COMBINATION_FINAL"); Check(Alive(units[2]), "combination final alive"); Check(GetUnitTypeId(units[2]) == 'hmpr', "combination final type B"); End(); }
        }
    }
    private function Start(integer m, player p) {
        Setup(m, p);
        if (m == 3) {
            SetUnitUserData(units[2], 24680);
            SetUnitState(units[2], UNIT_STATE_LIFE, 123.);
            SetUnitState(units[2], UNIT_STATE_MAX_MANA, 333.);
            SetUnitState(units[2], UNIT_STATE_MANA, 77.);
            SetUnitState(units[2], ConvertUnitState(0x12), 1234.);
            SetUnitState(units[2], ConvertUnitState(0x20), 33.);
            SetUnitMoveSpeed(units[2], 150.);
            SetUnitVertexColor(units[2], 255, 80, 80, 255);
            SetUnitScale(units[2], 1.5, 1.5, 1.5);
            UnitAddAbility(units[2], 'Absk');
            Log("fixture cast=" + I2S(Bit(IssueImmediateOrder(units[2], "berserk"))));
        }
        if (m == 8) {
            dummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'hfoo', x + 300., y - 350., 90.);
            PauseUnit(dummy, true); SetUnitInvulnerable(dummy, true);
            ready = true;
            Notice("手动：-b改牧师，-a改步兵，-move移动，-attack攻击右下无敌靶，-heal尝试治疗左侧步兵；也可直接选单位操作。");
        } else { TimerStart(clock, .1, true, function Step); }
    }
    private function Chat() {
        string s = GetEventPlayerChatString();
        integer n = 0;
        if (s == "-all") { PauseTimer(nextTest); suite = 1; Start(1, GetTriggerPlayer()); return; }
        if (s == "-stop") { suite = 0; PauseTimer(nextTest); Cleanup(); Notice("已停止并清理。"); return; }
        if (s == "-help") { Notice("s1基础8秒；s2往返40秒；s3状态5秒；s4伤害死亡5秒；-all顺序跑以上。s5活改→死→复活，s6死→改→复活，s7死→复活→改，各8秒；s8手动。-status记录。"); return; }
        if (SubString(s, 0, 1) == "s") {
            n = S2I(SubString(s, 1, StringLength(s)));
            if (n >= 1 && n <= 8) { PauseTimer(nextTest); suite = 0; Start(n, GetTriggerPlayer()); }
            return;
        }
        if (mode == 0) { return; }
        if (s == "-status") { AllSnapshots("MANUAL_STATUS"); return; }
        if (!ready || suite > 0) { Notice("自动测试中，请等待END后再操作。"); return; }
        if (s == "-a") { Change('hfoo'); }
        else if (s == "-b") { Change('hmpr'); }
        else if (s == "-kill") { KillUnit(units[2]); Snapshot(2, "MANUAL_DEATH"); }
        else if (s == "-revive" && !Alive(units[2])) { Revive(); }
        else if (s == "-move") { Log("moveOrder=" + I2S(Bit(IssuePointOrder(units[2], "move", x, y - 250.)))); }
        else if (s == "-attack" && dummy != null) { Log("attackOrder=" + I2S(Bit(IssueTargetOrder(units[2], "attack", dummy)))); }
        else if (s == "-heal") {
            SetUnitState(units[1], UNIT_STATE_LIFE, 100.);
            Log("healOrder=" + I2S(Bit(IssueTargetOrder(units[2], "heal", units[1]))));
        }
    }
    function onInit() {
        integer i;
        trigger t = CreateTrigger();
        clock = CreateTimer(); nextTest = CreateTimer();
        for (0 <= i < bj_MAX_PLAYER_SLOTS) { TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_DEATH, null); }
        TriggerAddAction(t, function() { if (GetTriggerUnit() == units[2] && units[2] != null) { playerDeaths += 1; Log("PLAYER_DEATH n=" + I2S(playerDeaths)); } });
        t = null;
        UnitTestRegisterChatEvent(function Chat);
        UnitTestAutoTimer(.5, 1., function() { Notice("v1 已加载。先输入 s1 看三单位对照，或 -all 跑基础整套。-help查看命令。左右对照单位不要操作。"); }, null);
    }
}
//! endzinc
#endif
