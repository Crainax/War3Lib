#ifndef UnitFilterIncluded
#define UnitFilterIncluded

//! zinc
/*
单位有关
*/


// 基础单位状态检查（生命值、存活状态）
#ifdef DUMMY_UNIT_JUDGE_NOT
#define IS_VALID_UNIT_BASIC(u) ( \
GetUnitState(u, UNIT_STATE_LIFE) > 0.405 && \
IsUnitAliveBJ(u) && \
DUMMY_UNIT_JUDGE_NOT(u) \
)
#else
#define IS_VALID_UNIT_BASIC(u) ( \
GetUnitState(u, UNIT_STATE_LIFE) > 0.405 && \
IsUnitAliveBJ(u) \
)
#endif

// 敌对关系检查（不包含虚拟单位判断）
#define IS_VALID_ENEMY_RELATION(p,u) ( \
!IsUnitType(u, UNIT_TYPE_SLEEPING) && \
!IsUnitType(u, UNIT_TYPE_STRUCTURE) && \
!IsUnitHidden(u) && \
IsUnitEnemy(u, p) && \
IsUnitVisible(u, p) \
)

// 完整的敌方目标检查（合并两部分）
#define IS_VALID_ENEMY_TARGET(p,u) ( \
IS_VALID_UNIT_BASIC(u) && \
IS_VALID_ENEMY_RELATION(p,u) \
)

library UnitFilter {

    //判断是否是敌方(不带无敌)
    public function IsEnemy (unit u,player p)  -> boolean {
        return IS_VALID_ENEMY_TARGET(p,u) && GetUnitAbilityLevel(u, 'Avul') < 1;
    }
    //旧名：IsEnemy2
    //判断是否是敌方(能匹配到无敌单位)
    public function IsEnemyIncludeInvul (unit u,player p)  -> boolean {
        return IS_VALID_ENEMY_TARGET(p,u);
    }

    //判断是否是敌方非魔法免疫单位
    public function IsEnemyMagic (unit u,player p)  -> boolean {
        return !IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) && IsEnemy(u,p) && !IsUnitType(u, UNIT_TYPE_RESISTANT);
    }

    //判断是否是敌方(简化版本,只检查基础状态和敌对关系)
    public function IsEnemyBasic(unit u, player p) -> boolean {
        return IS_VALID_UNIT_BASIC(u) && IsUnitEnemy(u, p);
    }

    //判断是否是友方
    public function IsAlly (unit u,player p)  -> boolean {
        #ifdef DUMMY_UNIT_JUDGE_NOT
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitAlly(u, p) && DUMMY_UNIT_JUDGE_NOT(u);
        #else
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitAlly(u, p);
        #endif
    }

    //判断两个单位是否互为敌人(不带无敌)
    //第一个参数是要受伤/中招的单位,第二个参数是锚定单位(施法者)
    public function IsEnemyUnit(unit target, unit caster) -> boolean {
        return IsEnemy(target,GetOwningPlayer(caster));
    }

    //判断两个单位是否互为队友(不带无敌)
    public function IsAllyUnit(unit target, unit caster) -> boolean {
        return IsAlly(target,GetOwningPlayer(caster));
    }

    //判断两个单位是否互为敌人(简化版本,只检查基础状态和敌对关系)
    public function IsEnemyBasicUnit(unit target, unit caster) -> boolean {
        return IS_VALID_UNIT_BASIC(target) && IsUnitEnemy(target, GetOwningPlayer(caster));
    }

    //判断是否是敌方非魔法免疫单位(双单位参数版)
    public function IsEnemyMagicUnit(unit target, unit caster) -> boolean {
        return IsEnemyMagic(target, GetOwningPlayer(caster));
    }


    // //判断单位是否属于指定常见种族或中立阵营
    // // 人族/兽族/不死/精灵 以及 中立敌对/中立中立
    // // 注意：当传入目标并非单位（例如对可破坏物 'DTrc' 使用 GetSpellTargetUnit()）时，u 可能为 null，返回 false
    // public function IsUnitRaceOK (unit u)  -> boolean {
    //     race r; player o;
    //     if (u == null) return false;

    //     r = GetUnitRace(u);
    //     if (r == RACE_HUMAN) return true;      // 人族
    //     if (r == RACE_ORC) return true;        // 兽族
    //     if (r == RACE_UNDEAD) return true;     // 不死
    //     if (r == RACE_NIGHTELF) return true;   // 精灵

    //     // 娜迦单位在实际地图中多归属中立敌对/中立中立，这里通过中立所属判断覆盖
    //     o = GetOwningPlayer(u);
    //     if (o == Player(PLAYER_NEUTRAL_AGGRESSIVE)) return true; // 中立敌对
    //     if (o == Player(PLAYER_NEUTRAL_PASSIVE))    return true; // 中立中立

    //     return false;
    // }

}

//! endzinc
#endif



