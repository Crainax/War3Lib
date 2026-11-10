#ifndef UTInstantAttackFacingIncluded
#define UTInstantAttackFacingIncluded
#undef OriginMapUnitTestMode
#include "D:/War3/Library/War3Lib/Jass/learn/InstantAttackFacing.j"
//! zinc
// v7: 2英雄 x 3配置 x 2索敌方式 x 3布局 x 3轮=108局。
// config: 0默认克隆 1默认克隆+API转速3 2物编turnRate=3，无运行时转速修改。
// selector: 0引擎自动 1死亡后零秒timer发一次attack。仅一个目标可见，半径800。
// layout: 0同向 1交替180度 2每次90度。保留原生攻击前摇/后摇，不重置冷却。
library UTInstantAttackFacing requires InstantAttackFacing, Logger {
    unit hero = null;
    unit targets[];
    trigger watcher = null;
    timer clock = null;
    timer ticker = null;
    timer nextTimer = null;
    timer releaseTimer = null;
    integer run = 0;
    integer cfg = 0;
    integer selector = 0;
    integer layout = 0;
    integer heroIndex = 0;
    integer rep = 0;
    integer index = 0;
    integer kills = 0;
    integer orders = 0;
    integer timeouts = 0;
    integer totalKills = 0;
    boolean active = false;
    boolean running = false;
    real began = 0.;
    real lastDamage = -1.;
    real maxMove = 0.;
    function Now() -> real { return TimerGetElapsed(clock); }
    function Log(string s) {
        Trace("[FacingChain] run=" + I2S(run) + " cfg=" + I2S(cfg) + " sel=" + I2S(selector) + " layout=" + I2S(layout) + " hero=" + I2S(heroIndex) + " rep=" + I2S(rep) + " n=" + I2S(index) + " t=" + R2S(Now()) + " " + s);
    }
    function Cleanup() {
        integer i;
        active = false;
        PauseTimer(releaseTimer);
        if (watcher != null) { DestroyTrigger(watcher); watcher = null; }
        if (hero != null) { RemoveUnit(hero); hero = null; }
        for (1 <= i <= 12) { if (targets[i] != null) { RemoveUnit(targets[i]); targets[i] = null; } }
    }
    function Release() {
        boolean ok;
        if (!active) { return; }
        index += 1;
        ShowUnit(targets[index],true);
        Log("READY face=" + R2S(GetUnitFacing(hero)) + " sinceDamage=" + R2S(Now()-lastDamage));
        if (index == 1 || selector == 1) {
            orders += 1;
            ok = IssueTargetOrder(hero,"attack",targets[index]);
            Log("ORDER");
            assert.Boolean(ok,"[FacingChain] attack order accepted");
        }
    }
    function Observe() {
        eventid e = GetTriggerEventId();
        unit u = GetTriggerUnit();
        if (!active) { u = null; return; }
        if (e == EVENT_UNIT_ACQUIRED_TARGET) {
            Log("ACQUIRE");
        } else if (index > 0 && u == targets[index]) {
            if (e == EVENT_UNIT_ATTACKED) { Log("ATTACKED face=" + R2S(GetUnitFacing(hero))); }
            else if (e == EVENT_UNIT_DAMAGED && GetEventDamageSource() == hero) {
                Log("DAMAGE gap=" + R2S(Now()-lastDamage) + " amount=" + R2S(GetEventDamage()) + " face=" + R2S(GetUnitFacing(hero)));
                lastDamage = Now();
            } else if (e == EVENT_UNIT_DEATH) {
                kills += 1; totalKills += 1;
                Log("DEATH");
                if (index < 12) { TimerStart(releaseTimer,0.,false,function Release); }
            }
        }
        u = null;
    }
    function NextRun() {
        integer c;
        integer i;
        integer rawcode;
        real angle;
        Cleanup();
        run += 1;
        if (run > 108) {
            running = false; PauseTimer(ticker);
            assert.Integer(run-1,108,"[FacingChain] all conditions completed");
            Trace("[FacingChain] SUITE_DONE version=7 runs=108 kills=" + I2S(totalKills) + " timeouts=" + I2S(timeouts));
            return;
        }
        rep = (run-1)/36;
        c = ModuloInteger(ModuloInteger(run-1,36)+rep*11,36);
        cfg = ModuloInteger(c,3); c = c/3;
        layout = ModuloInteger(c,3); c = c/3;
        selector = ModuloInteger(c,2); heroIndex = c/2;
        index = 0; kills = 0; orders = 0; lastDamage = -1.; maxMove = 0.;
        rawcode = 'HF71'; if (heroIndex == 1) { rawcode = 'HF73'; }
        if (cfg == 2) { rawcode = 'HF72'; if (heroIndex == 1) { rawcode = 'HF74'; } }
        hero = CreateUnit(Player(0),rawcode,0.,0.,0.);
        Log("BORN type=" + I2S(rawcode) + " turn=" + R2S(GetUnitTurnSpeed(hero)));
        if (cfg == 2) { assert.Real(GetUnitTurnSpeed(hero),3.,"[FacingChain] INI turn 3 at creation"); }
        else { assert.Real(GetUnitTurnSpeed(hero),.6,"[FacingChain] default turn .6 at creation"); }
        SuspendHeroXP(hero,true); SetUnitPathing(hero,false);
        SetUnitAcquireRange(hero,1200.);
        SetUnitState(hero,ConvertUnitState(0x51),5.);
        SetUnitState(hero,ConvertUnitState(0x25),.05);
        SetUnitState(hero,ConvertUnitState(0x16),1000.);
        SetUnitState(hero,ConvertUnitState(0x12),1000.);
        if (cfg == 1) { SetUnitTurnSpeed(hero,3.); }
        if (cfg != 0) { assert.Real(GetUnitTurnSpeed(hero),3.,"[FacingChain] effective turn 3"); }
        watcher = CreateTrigger();
        TriggerRegisterUnitEvent(watcher,hero,EVENT_UNIT_ACQUIRED_TARGET);
        for (1 <= i <= 12) {
            angle = 0.;
            if (layout == 1) { angle = I2R(ModuloInteger(i-1,2))*bj_PI; }
            if (layout == 2) { angle = I2R(ModuloInteger(i-1,4))*bj_PI*.5; }
            targets[i] = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'hfoo',800.*Cos(angle),800.*Sin(angle),0.);
            PauseUnit(targets[i],true); SetUnitPathing(targets[i],false);
            SetUnitX(targets[i],800.*Cos(angle)); SetUnitY(targets[i],800.*Sin(angle));
            SetWidgetLife(targets[i],1.); ShowUnit(targets[i],false);
            TriggerRegisterUnitEvent(watcher,targets[i],EVENT_UNIT_ATTACKED);
            TriggerRegisterUnitEvent(watcher,targets[i],EVENT_UNIT_DAMAGED);
            TriggerRegisterUnitEvent(watcher,targets[i],EVENT_UNIT_DEATH);
        }
        TriggerAddAction(watcher,function Observe);
        Log("CONFIG rate=" + R2S(GetUnitState(hero,ConvertUnitState(0x51))) + " interval=" + R2S(GetUnitState(hero,ConvertUnitState(0x25))) + " range=" + R2S(GetUnitState(hero,ConvertUnitState(0x16))) + " prop=" + R2S(GetUnitPropWindow(hero)) + " turn=" + R2S(GetUnitTurnSpeed(hero)) + " point=" + R2S(GetUnitState(hero,ConvertUnitState(0x26))) + " backswing=" + R2S(GetUnitState(hero,ConvertUnitState(0x28))));
        assert.Real(GetUnitState(hero,ConvertUnitState(0x51)),5.,"[FacingChain] rate 5");
        assert.Real(GetUnitState(hero,ConvertUnitState(0x25)),.05,"[FacingChain] base interval .05");
        assert.Real(GetUnitState(hero,ConvertUnitState(0x16)),1000.,"[FacingChain] range 1000");
        assert.Boolean(IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER),"[FacingChain] melee hero");
        active = true; began = Now();
        TimerStart(releaseTimer,.30,false,function Release);
    }
    function Tick() {
        real moved;
        if (!active) { return; }
        moved = SquareRoot(GetUnitX(hero)*GetUnitX(hero)+GetUnitY(hero)*GetUnitY(hero));
        if (moved > maxMove) { maxMove = moved; }
        if (kills == 12 || Now()-began > 12.) {
            if (kills != 12) { timeouts += 1; }
            if (selector == 0) { assert.Integer(orders,1,"[FacingChain] automatic selection only one initial order"); }
            else { assert.Integer(orders,index,"[FacingChain] scripted selection one order per target"); }
            Log("ORDERS count=" + I2S(orders));
            Log("RESULT kills=" + I2S(kills) + " duration=" + R2S(Now()-began) + " maxMove=" + R2S(maxMove));
            assert.Boolean(maxMove < 10.,"[FacingChain] no movement confound");
            active = false;
            TimerStart(nextTimer,.10,false,function NextRun);
        }
    }
    function RunSuite() {
        if (running) { return; }
        Cleanup(); run = 0; timeouts = 0; totalKills = 0; running = true;
        TimerStart(clock,3600.,false,null);
        Trace("[FacingChain] SUITE_BEGIN version=7 runs=108 targets=12 radius=800");
        TimerStart(ticker,.025,true,function Tick);
        NextRun();
    }
    function onInit() {
        clock = CreateTimer(); ticker = CreateTimer(); nextTimer = CreateTimer(); releaseTimer = CreateTimer();
        UnitTestAutoTimer(8.,0.,function(){ RunSuite(); },null);
        UnitTestRegisterChatEvent(function(){ if (GetEventPlayerChatString() == "-suite") { RunSuite(); } });
    }
}
//! endzinc
#endif
