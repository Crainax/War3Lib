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

    // 地图可配置一个额外的无敌技能ID；用于识别继承自 Avul、但 rawcode 不同的专用无敌层。
    private integer customInvulnerableAbilityId = 0;

    public function SetCustomInvulnerableAbilityId(integer abilityId) {
        customInvulnerableAbilityId = abilityId;
    }

    public function GetCustomInvulnerableAbilityId() -> integer {
        return customInvulnerableAbilityId;
    }

    public function IsUnitInvulnerableEx(unit u) -> boolean {
        if (u == null || GetUnitTypeId(u) == 0) { return false; }
        return GetUnitAbilityLevel(u, 'Avul') > 0
            || GetUnitAbilityLevel(u, 'BHds') > 0
            || (customInvulnerableAbilityId > 0 && GetUnitAbilityLevel(u, customInvulnerableAbilityId) > 0);
    }

    //判断是否是敌方(不带无敌)
    public function IsEnemy (unit u,player p)  -> boolean {
        return IS_VALID_ENEMY_TARGET(p,u) && !IsUnitInvulnerableEx(u);
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
        return GetUnitState(u, UNIT_STATE_LIFE) > .405  && !(IsUnitHidden(u)) && IsUnitAlly(u, p) && DUMMY_UNIT_JUDGE_NOT(u);
        #else
        return GetUnitState(u, UNIT_STATE_LIFE) > .405  && !(IsUnitHidden(u)) && IsUnitAlly(u, p);
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

}

//! endzinc
#endif



