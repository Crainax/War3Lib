#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题
#include "Crainax/core/table/Hash_UnitDefine.j"
#include "Crainax/core/table/Hash_BIDefine.j"

//! zinc
/*
单位有关的增强功能
*/
library UnitUtils requires BigInteger,MathUtils {

    public struct unitAttrObserver [] {

        public static unit argsU = null;
        public static trigger attackIntervalCB = null;

        //攻击间隔的观察者事件注册
        public static method registerAttackInterval (code func) {
            if (attackIntervalCB == null) {
                attackIntervalCB = CreateTrigger();
            }
            TriggerAddCondition(attackIntervalCB, Condition(func));
        }

    }

    //=====================
    // 攻击扩展工具函数
    //=====================

    // 获取单位攻击增幅（real）
    private function GetUnitAttackUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位攻击减幅（real）
    private function GetUnitAttackDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取单位攻击固定加成（非 BigInteger 路径，real）
    private function GetUnitAttackBonusReal(unit u) -> real {
        integer uid; real bonus;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL);
        } else {
            bonus = 0.0;
        }
        return bonus;
    }

    // 获取当前单位攻击总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitAttackFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitAttackUpRate(u);
        down = GetUnitAttackDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位“基础攻击”（不含增减幅与定值）
    // 注意：此函数不做任何写入操作，基础攻击的初始化放在 Set/Add 等写入函数中完成，避免 OOS 风险
    public function GetUnitBaseAttack(unit u) -> real {
        player p; real base; real cur; real factor;
        integer uid;

        if (u == null) { return 0.0; }

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            base = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK);
            p = null;
            return base;
        }

        uid = GetHandleId(u);

        // 若已缓存基础攻击，则直接返回
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL)) {
            return LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL);
        }

        // 未初始化时，仅根据当前总攻击（引擎状态 + 缩放倍数）计算并返回，但不写入哈希表
        cur = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
        } else {
            factor = 1.0;
        }
        base = cur * factor;

        return base;
    }

    // 计算单位当前“最终攻击”（基础 * 总倍率 + 定值）
    private function CalcUnitFinalAttackReal(unit u) -> real {
        real base; real rate; real bonus; player p;

        if (u == null) { return 0.0; }

        base = GetUnitBaseAttack(u);
        rate = GetUnitAttackFinalPercent(u);

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            bonus = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK_BONUS);
            p = null;
        } else {
            bonus = GetUnitAttackBonusReal(u);
        }

        return base * rate + bonus;
    }

    // 非 BigInteger 单位：按 10^n 规则写入引擎攻击与扩展倍数
    private function ApplyAttackScaling(unit u, real attack) -> nothing {
        real value; integer uid; integer n; integer i; real factor;

        if (u == null) { return; }

        uid = GetHandleId(u);
        value = attack;

        // 保护下限，避免引擎攻击小于 0
        if (value < 0.0) {
            value = 0.0;
        }
        n = 0;

        // 大于 10 亿才开始缩放，避免不必要的精度损失
        if (value > 1000000000.0) {
            while (value > 1000000000.0 && n < 30) {
                value = value / 10.0;
                n = n + 1;
            }
        }

        if (n > 0) {
            factor = 1.0;
            i = 0;
            while (i < n) {
                factor = factor * 10.0;
                i = i + 1;
            }
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP, n);
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR, factor);
        } else {
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_EXP);
            }
            if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
                RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
            }
        }

        SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE), value);
    }

    // 将 BigInteger 中的最终攻击值同步到引擎攻击值与 10^n 扩展键
    private function SyncBigIntAttackToEngine(unit u) -> nothing {
        real total;
        if (u == null) { return; }

        total = CalcUnitFinalAttackReal(u);

        if (total <= 0.0) {
            ApplyAttackScaling(u, 0.0);
            return;
        }

        ApplyAttackScaling(u, total);
    }

    //重新计算单位当前攻击（应用增减幅与定值）
    private function RecalcUnitAttack(unit u) -> nothing {
        real total; integer uid; real cur; real factor; real base;
        if (u == null) { return; }

        // 懒初始化普通单位的基础攻击缓存（避免在 Get 函数中写入，防 OOS）
        if (!IsUnitBigInteger(u)) {
            uid = GetHandleId(u);
            if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL)) {
                cur = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));
                if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
                    factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
                } else {
                    factor = 1.0;
                }
                base = cur * factor;
                SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, base);
            }
        }

        total = CalcUnitFinalAttackReal(u);

        if (IsUnitBigInteger(u)) {
            // BigInteger 单位统一通过 SyncBigIntAttackToEngine 写回
            SyncBigIntAttackToEngine(u);
        } else {
            ApplyAttackScaling(u, total);
        }
    }

    //获取单位的攻击力/防御/生命/魔法值
    // 普通单位：从引擎状态 + 10^n 扩展倍数还原（已经包含增减幅与定值）
    // BigInteger 单位：返回 CalcUnitFinalAttackReal 计算出的最终攻击
    public function GetUnitAttack(unit u) -> real {
        real base; integer uid; real factor;

        if (IsUnitBigInteger(u)) {
            return CalcUnitFinalAttackReal(u);
        }

        uid = GetHandleId(u);
        base = GetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE));

        // 如果存在攻击扩展倍数，则还原为真实攻击力
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            factor = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
            return base * factor;
        }

        return base;
    }

    //=====================
    // [异度] 暴击真伤 / 格挡扩展工具函数
    //=====================

    // 获取单位暴击真伤增幅（real）
    private function GetUnitCritTrueUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位暴击真伤减幅（real）
    private function GetUnitCritTrueDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取当前单位暴击真伤总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitCritTruePercent(unit u) -> real {
        real up; real down;
        if (u == null) { return 1.0; }
        up = GetUnitCritTrueUpRate(u);
        down = GetUnitCritTrueDownRate(u);
        return (1.0 + up) * (1.0 - down);
    }

    // 获取单位暴击真伤（基础 BigInteger * 总倍率）
    public function GetUnitCritTrue(unit u) -> real {
        player p; real base;
        if (u == null) { return 0.0; }
        p = GetOwningPlayer(u);
        base = bigInteger.toReal(p, HASH_KEY_BIGINT_CRIT_TRUE);
        p = null;
        return base * GetUnitCritTruePercent(u);
    }

    // 增加单位暴击真伤基础值（支持超过 21 亿）
    public function AddUnitCritTrue(unit u, real value) -> nothing {
        player p;
        if (u == null || value == 0.0) { return; }
        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_CRIT_TRUE, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_CRIT_TRUE, -value);
        }
        p = null;
    }

    // 增加暴击真伤增幅（value 为小数，如 0.2 表示 +20%）
    public function AddUnitCritTrueUpPercent(unit u, real value) -> nothing {
        integer uid; real up;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        up = GetUnitCritTrueUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_UP_RATE, up);
    }

    // 增加暴击真伤减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitCritTrueDownPercent(unit u, real value) -> nothing {
        integer uid; real down;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        down = GetUnitCritTrueDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_CRIT_TRUE_DOWN_RATE, down);
    }

    // 获取单位格挡伤害（支持超过 21 亿）
    public function GetUnitBlock(unit u) -> real {
        player p; real value;
        if (u == null) { return 0.0; }
        p = GetOwningPlayer(u);
        value = bigInteger.toReal(p, HASH_KEY_BIGINT_BLOCK);
        p = null;
        return value;
    }

    // 增加单位格挡伤害（支持超过 21 亿）
    public function AddUnitBlock(unit u, real value) -> nothing {
        player p;
        if (u == null || value == 0.0) { return; }
        p = GetOwningPlayer(u);
        if (value > 0.0) {
            bigInteger.addReal(p, HASH_KEY_BIGINT_BLOCK, value);
        } else {
            bigInteger.subReal(p, HASH_KEY_BIGINT_BLOCK, -value);
        }
        p = null;
    }

    //=====================
    // 防御扩展工具函数
    //=====================

    // 获取单位防御增幅（real）
    private function GetUnitDefenseUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位防御减幅（real）
    private function GetUnitDefenseDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取单位防御固定加成（integer）
    private function GetUnitDefenseBonusInteger(unit u) -> integer {
        integer uid; integer bonus;
        if (u == null) { return 0; }
        uid = GetHandleId(u);
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER)) {
            bonus = LoadInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER);
        } else {
            bonus = 0;
        }
        return bonus;
    }

    // 获取当前单位防御总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitDefenseFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitDefenseUpRate(u);
        down = GetUnitDefenseDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位"基础防御"（不含增减幅与定值）
    public function GetUnitBaseDefense(unit u) -> integer {
        integer uid; integer base; integer cur;

        if (u == null) { return 0; }

        uid = GetHandleId(u);

        // 若已缓存基础防御，则直接返回
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER)) {
            return LoadInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER);
        }

        // 未初始化时，仅根据当前总防御计算并返回，但不写入哈希表
        cur = R2I(GetUnitState(u, ConvertUnitState(UNIT_STATE_ARMOR)));
        base = cur;

        return base;
    }

    // 计算单位当前"最终防御"（基础 * 总倍率 + 定值）
    private function CalcUnitFinalDefenseInteger(unit u) -> integer {
        integer base; real rate; integer bonus;

        if (u == null) { return 0; }

        base = GetUnitBaseDefense(u);
        rate = GetUnitDefenseFinalPercent(u);
        bonus = GetUnitDefenseBonusInteger(u);

        return R2I(I2R(base) * rate) + bonus;
    }

    //重新计算单位当前防御（应用增减幅与定值）
    private function RecalcUnitDefense(unit u) -> nothing {
        integer total; integer uid; integer cur; integer base;
        if (u == null) { return; }

        // 懒初始化单位的基础防御缓存
        uid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER)) {
            cur = R2I(GetUnitState(u, ConvertUnitState(UNIT_STATE_ARMOR)));
            base = cur;
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER, base);
        }

        total = CalcUnitFinalDefenseInteger(u);
        SetUnitState(u, ConvertUnitState(UNIT_STATE_ARMOR), I2R(total));
    }

    public function GetUnitDefense(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR)));
    }

    //=====================
    // 魔抗（Resist）扩展工具函数
    //=====================

    // 获取单位魔抗减伤 Up（0~1，使用 RealAdd 归一叠加）
    private function GetUnitResistUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_RESIST_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位魔抗易伤 Down（线性累加）
    private function GetUnitResistDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_RESIST_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 重置单位魔抗减伤 Up（直接归 0）
    public function ResetUnitResistUp(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_UP_RATE)) {
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_UP_RATE);
        }
    }

    // 重置单位魔抗易伤 Down（直接归 0）
    public function ResetUnitResistDown(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_DOWN_RATE)) {
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_RESIST_DOWN_RATE);
        }
    }

    // 增加魔抗减伤 Up（0~1，使用 RealAdd 归一叠加，永远不会到 1）
    public function AddUnitResistUp(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitResistUpRate(u);
        up = RealAdd(up, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_RESIST_UP_RATE, up);
    }

    // 增加魔抗易伤 Down（线性加法累加）
    public function AddUnitResistDown(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitResistDownRate(u);
        down = down + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_RESIST_DOWN_RATE, down);
    }

    // 获取魔抗最终结果：
    //  - Up 的两次 0.5 过程：RealAdd(0.5, 0.5) = 0.75
    //  - Down 的两次 0.6 过程：0.6 + 0.6 = 1.2
    //  - Final 计算公式：(1 - up) * (1.0 + down)
    public function GetUnitResistFinal(unit u) -> real {
        real up; real down; real final;

        if (u == null) { return 0.0; }

        up = GetUnitResistUpRate(u);
        down = GetUnitResistDownRate(u);

        final = (1.0 - up) * (1.0 + down);
        return final;
    }

    //=====================
    // 眩晕抗性 / 免疫
    //=====================

    // 获取眩晕抗性（RealAdd 归一叠加，0~1）
    public function GetUnitStunResist(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STUN_RESIST_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_STUN_RESIST_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 增加眩晕抗性（RealAdd 叠加）
    public function AddUnitStunResistUp(unit u, real value) -> nothing {
        integer uid; real up;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        up = GetUnitStunResist(u);
        up = RealAdd(up, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_STUN_RESIST_UP_RATE, up);
    }

    // 重置眩晕抗性
    public function ResetUnitStunResistUp(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_STUN_RESIST_UP_RATE)) {
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_STUN_RESIST_UP_RATE);
        }
    }

    // 设置眩晕免疫
    public function SetUnitStunImmune(unit u, boolean flag) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (flag) {
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_STUN_IMMUNE, 1);
        } else {
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_IMMUNE)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_IMMUNE);
            }
        }
    }

    // 查询眩晕免疫
    public function IsUnitStunImmune(unit u) -> boolean {
        integer uid;
        if (u == null) { return false; }
        uid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_IMMUNE)) {
            return false;
        }
        return LoadInteger(HASH_UNIT, uid, KEY_UNIT_STUN_IMMUNE) != 0;
    }

    // 设置眩晕CD禁用（flag=true 表示禁用CD，无限眩晕）
    public function SetUnitStunCdDisabled(unit u, boolean flag) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (flag) {
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_STUN_CD_DISABLED, 1);
        } else {
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_CD_DISABLED)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_CD_DISABLED);
            }
        }
    }

    // 查询眩晕CD是否禁用
    public function IsUnitStunCdDisabled(unit u) -> boolean {
        integer uid;
        if (u == null) { return false; }
        uid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_STUN_CD_DISABLED)) {
            return false;
        }
        return LoadInteger(HASH_UNIT, uid, KEY_UNIT_STUN_CD_DISABLED) != 0;
    }

    //=====================
    // 吸怪抗性 / 免疫
    //=====================

    // 获取吸怪抗性（0~1，RealAdd 归一叠加）
    public function GetUnitAttractResist(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTRACT_RESIST_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTRACT_RESIST_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 增加吸怪抗性（RealAdd 叠加，永远小于 1）
    public function AddUnitAttractResistUp(unit u, real value) -> nothing {
        integer uid; real up;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        up = GetUnitAttractResist(u);
        up = RealAdd(up, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTRACT_RESIST_UP_RATE, up);
    }

    // 重置吸怪抗性
    public function ResetUnitAttractResistUp(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTRACT_RESIST_UP_RATE)) {
            RemoveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTRACT_RESIST_UP_RATE);
        }
    }

    // 设置吸怪免疫
    public function SetUnitAttractImmune(unit u, boolean flag) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (flag) {
            SaveInteger(HASH_UNIT, uid, KEY_UNIT_ATTRACT_IMMUNE, 1);
        } else {
            if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTRACT_IMMUNE)) {
                RemoveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTRACT_IMMUNE);
            }
        }
    }

    // 查询吸怪免疫
    public function IsUnitAttractImmune(unit u) -> boolean {
        integer uid;
        if (u == null) { return false; }
        uid = GetHandleId(u);
        if (!HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_ATTRACT_IMMUNE)) {
            return false;
        }
        return LoadInteger(HASH_UNIT, uid, KEY_UNIT_ATTRACT_IMMUNE) != 0;
    }


    //=====================
    // 生命值扩展工具函数
    //=====================

    // 获取单位生命值增幅（real）
    private function GetUnitHPUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位生命值减幅（real）
    private function GetUnitHPDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取单位生命值固定加成（real）
    private function GetUnitHPBonusReal(unit u) -> real {
        integer uid; real bonus;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_BONUS_REAL);
        } else {
            bonus = 0.0;
        }
        return bonus;
    }

    // 获取当前单位生命值总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitHPFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitHPUpRate(u);
        down = GetUnitHPDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位"基础生命值"（不含增减幅与定值）
    public function GetUnitBaseHP(unit u) -> real {
        integer uid; real base; real cur;

        if (u == null) { return 0.0; }

        uid = GetHandleId(u);

        // 若已缓存基础生命值，则直接返回
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL)) {
            return LoadReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL);
        }

        // 未初始化时，仅根据当前总生命值计算并返回，但不写入哈希表
        cur = GetUnitState(u, UNIT_STATE_MAX_LIFE);
        base = cur;

        return base;
    }

    // 计算单位当前"最终生命值"（基础 * 总倍率 + 定值）
    private function CalcUnitFinalHPReal(unit u) -> real {
        real base; real rate; real bonus;

        if (u == null) { return 0.0; }

        base = GetUnitBaseHP(u);
        rate = GetUnitHPFinalPercent(u);
        bonus = GetUnitHPBonusReal(u);

        return base * rate + bonus;
    }

    //重新计算单位当前生命值（应用增减幅与定值）
    private function RecalcUnitHP(unit u) -> nothing {
        real total; integer uid; real cur; real base;
        if (u == null) { return; }

        // 懒初始化单位的基础生命值缓存
        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL)) {
            cur = GetUnitState(u, UNIT_STATE_MAX_LIFE);
            base = cur;
            SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL, base);
        }

        total = CalcUnitFinalHPReal(u);
        SetUnitState(u, UNIT_STATE_MAX_LIFE, RMaxBJ(total, 2.0));
    }

    public function GetUnitHP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }

    //=====================
    // 魔法值扩展工具函数
    //=====================

    // 获取单位魔法值增幅（real）
    private function GetUnitMPUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位魔法值减幅（real）
    private function GetUnitMPDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }

    // 获取单位魔法值固定加成（real）
    private function GetUnitMPBonusReal(unit u) -> real {
        integer uid; real bonus;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL);
        } else {
            bonus = 0.0;
        }
        return bonus;
    }

    // 获取当前单位魔法值总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitMPFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitMPUpRate(u);
        down = GetUnitMPDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位"基础魔法值"（不含增减幅与定值）
    public function GetUnitBaseMP(unit u) -> real {
        integer uid; real base; real cur;

        if (u == null) { return 0.0; }

        uid = GetHandleId(u);

        // 若已缓存基础魔法值，则直接返回
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL)) {
            return LoadReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL);
        }

        // 未初始化时，仅根据当前总魔法值计算并返回，但不写入哈希表
        cur = GetUnitState(u, UNIT_STATE_MAX_MANA);
        base = cur;

        return base;
    }

    // 计算单位当前"最终魔法值"（基础 * 总倍率 + 定值）
    private function CalcUnitFinalMPReal(unit u) -> real {
        real base; real rate; real bonus;

        if (u == null) { return 0.0; }

        base = GetUnitBaseMP(u);
        rate = GetUnitMPFinalPercent(u);
        bonus = GetUnitMPBonusReal(u);

        return base * rate + bonus;
    }

    //重新计算单位当前魔法值（应用增减幅与定值）
    private function RecalcUnitMP(unit u) -> nothing {
        real total; integer uid; real cur; real base;
        if (u == null) { return; }

        // 懒初始化单位的基础魔法值缓存
        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL)) {
            cur = GetUnitState(u, UNIT_STATE_MAX_MANA);
            base = cur;
            SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL, base);
        }

        total = CalcUnitFinalMPReal(u);
        SetUnitState(u, UNIT_STATE_MAX_MANA, total);
    }

    public function GetUnitMP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_MANA);
    }

    // 获取当前单位攻击力的扩展倍数（10 的 n 次方，使用 real 存储）
    //  - 当未使用扩展（即攻击力未超过 10 亿时），直接返回 0.0
    //  - 当返回值 > 0 时，表示真实攻击力 = 引擎攻击值 * 返回值
    public function GetUnitAttackMult(unit u) -> real {
        integer uid;

        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR)) {
            return 0.0;
        }

        return LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_SCALE_FACTOR);
    }

    //设置攻击力（支持超过 21 亿；BigInteger 单位走大整数链路）
    public function SetUnitAttack(unit u, real attack) -> nothing {
        real value; integer uid; player p;

        if (IsUnitBigInteger(u)) {
            if (u == null) { return; }
            p = GetOwningPlayer(u);
            bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
            bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
            if (attack > 0.0) {
                bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, attack);
            }
            p = null;
            SyncBigIntAttackToEngine(u);
            return;
        }

        if (u == null) { return; }

        uid = GetHandleId(u);
        value = attack;

        // 普通单位：直接设置基础攻击，并按照当前增减幅/定值重算最终攻击
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, value);
        RecalcUnitAttack(u);
    }

    //增加攻击力（支持超过 21 亿；BigInteger 单位使用大整数 add/sub 逻辑）
    public function AddUnitAttack(unit u, real attack) -> nothing {
        player p; real delta; real debt; real cur; real dec; real over; real remain; real base; integer uid;

        if (IsUnitBigInteger(u)) {
            if (u == null) { return; }
            if (attack == 0.0) { return; }

            p = GetOwningPlayer(u);
            delta = attack;

            if (delta > 0.0) {
                // 加攻击：优先偿还欠款
                debt = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK_CACHE);
                if (debt > 0.0) {
                    if (delta <= debt) {
                        bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK_CACHE, delta);
                    } else {
                        remain = delta - debt;
                        bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK_CACHE);
                        bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, remain);
                    }
                } else {
                    bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK, delta);
                }
            } else {
                // 减攻击：可能产生欠款
                dec = -delta;
                cur = bigInteger.toReal(p, HASH_KEY_BIGINT_ATTACK);
                if (cur >= dec) {
                    bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK, dec);
                } else {
                    over = dec - cur;
                    bigInteger.reset(p, HASH_KEY_BIGINT_ATTACK);
                    bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK_CACHE, over);
                }
            }

            p = null;
            SyncBigIntAttackToEngine(u);
            return;
        }

        if (u == null || attack == 0.0) { return; }

        // 普通单位：修改基础攻击，然后用增减幅/定值重算
        uid = GetHandleId(u);
        base = GetUnitBaseAttack(u);
        base = base + attack;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BASE_REAL, base);
        RecalcUnitAttack(u);
    }

    // 增加攻击增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitAttackUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitAttackUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_UP_RATE, up);

        RecalcUnitAttack(u);
    }

    // 增加攻击减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitAttackDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitAttackDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_DOWN_RATE, down);

        RecalcUnitAttack(u);
    }

    // 增加固定攻击值（不受增减幅影响）
    public function AddUnitAttackBonus(unit u, real value) -> nothing {
        integer uid; real bonus; player p;

        if (u == null || value == 0.0) { return; }

        if (IsUnitBigInteger(u)) {
            p = GetOwningPlayer(u);
            if (value > 0.0) {
                bigInteger.addReal(p, HASH_KEY_BIGINT_ATTACK_BONUS, value);
            } else {
                bigInteger.subReal(p, HASH_KEY_BIGINT_ATTACK_BONUS, -value);
            }
            p = null;
        } else {
            uid = GetHandleId(u);
            bonus = GetUnitAttackBonusReal(u);
            bonus = bonus + value;
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_BONUS_REAL, bonus);
        }

        RecalcUnitAttack(u);
    }

    //设置防御
    public function SetUnitDefense(unit u, real defense) -> nothing {
        integer value; integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        value = R2I(defense);
        // 直接设置基础防御，并按照当前增减幅/定值重算最终防御
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER, value);
        RecalcUnitDefense(u);
    }
    //增加防御（只加基础值）
    public function AddUnitDefense(unit u, real defense) -> nothing {
        integer base; integer uid;
        if (u == null || defense == 0.0) { return; }
        uid = GetHandleId(u);
        base = GetUnitBaseDefense(u);
        base = base + R2I(defense);
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BASE_INTEGER, base);
        RecalcUnitDefense(u);
    }

    // 增加防御增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitDefenseUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitDefenseUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_UP_RATE, up);

        RecalcUnitDefense(u);
    }

    // 增加防御减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitDefenseDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitDefenseDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_DEFENSE_DOWN_RATE, down);

        RecalcUnitDefense(u);
    }

    // 增加固定防御值（不受增减幅影响）
    public function AddUnitDefenseBonus(unit u, integer value) -> nothing {
        integer uid; integer bonus;

        if (u == null || value == 0) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitDefenseBonusInteger(u);
        bonus = bonus + value;
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_DEFENSE_BONUS_INTEGER, bonus);

        RecalcUnitDefense(u);
    }

    //修改生命最大值
    public function SetUnitHP(unit u, real hp) -> nothing {
        real value; integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        value = hp;
        // 直接设置基础生命值，并按照当前增减幅/定值重算最终生命值
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL, value);
        RecalcUnitHP(u);
    }
    //增加生命最大值（只加基础值）
    public function AddUnitHP(unit u,real hp ) {
        real base; integer uid;
        if (u == null || hp == 0.0) { return; }
        uid = GetHandleId(u);
        base = GetUnitBaseHP(u);
        base = base + hp;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_BASE_REAL, base);
        RecalcUnitHP(u);
        if (hp > 0) {SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+hp);}
    }

    // 增加生命值增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitHPUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitHPUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_UP_RATE, up);

        RecalcUnitHP(u);
    }

    // 增加生命值减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitHPDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitHPDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_DOWN_RATE, down);

        RecalcUnitHP(u);
    }

    // 增加固定生命值（不受增减幅影响）
    public function AddUnitHPBonus(unit u, real value) -> nothing {
        integer uid; real bonus;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitHPBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_HP_BONUS_REAL, bonus);

        RecalcUnitHP(u);
    }
    //回血(定值)
    public function RegenUnitHP(unit u, real volume) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitHPPercent(unit u, real rate) -> nothing {
        SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate);
    }

    //设置魔法最大值
    public function SetUnitMP(unit u, real mp) -> nothing {
        real value; integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        value = mp;
        // 直接设置基础魔法值，并按照当前增减幅/定值重算最终魔法值
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL, value);
        RecalcUnitMP(u);
    }
    //增加魔法最大值（只加基础值）
    public function AddUnitMP(unit u,real mp ) {
        real base; integer uid;
        if (u == null || mp == 0.0) { return; }
        uid = GetHandleId(u);
        base = GetUnitBaseMP(u);
        base = base + mp;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_BASE_REAL, base);
        RecalcUnitMP(u);
        if (mp > 0) {SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+mp);}
    }

    // 增加魔法值增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitMPUpPercent(unit u, real value) -> nothing {
        integer uid; real up;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        up = GetUnitMPUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_UP_RATE, up);

        RecalcUnitMP(u);
    }

    // 增加魔法值减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitMPDownPercent(unit u, real value) -> nothing {
        integer uid; real down;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        down = GetUnitMPDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_DOWN_RATE, down);

        RecalcUnitMP(u);
    }

    // 增加固定魔法值（不受增减幅影响）
    public function AddUnitMPBonus(unit u, real value) -> nothing {
        integer uid; real bonus;

        if (u == null || value == 0.0) { return; }

        uid = GetHandleId(u);
        bonus = GetUnitMPBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MP_BONUS_REAL, bonus);

        RecalcUnitMP(u);
    }



    //回蓝(定值)
    public function RegenUnitMP(unit u, real volume) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+volume);
    }
    //回蓝(百分比)
    public function RegenUnitMPPercent(unit u, real rate) -> nothing {
        SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate);
    }

    //=====================
    // 移速扩展工具函数
    //=====================

    // 获取单位移速增幅（real）
    private function GetUnitSpeedUpRate(unit u) -> real {
        integer uid; real up;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_UP_RATE)) {
            up = LoadReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_UP_RATE);
        } else {
            up = 0.0;
        }
        return up;
    }

    // 获取单位移速减幅（real）
    public function GetUnitSpeedDownRate(unit u) -> real {
        integer uid; real down;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_DOWN_RATE)) {
            down = LoadReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_DOWN_RATE);
        } else {
            down = 0.0;
        }
        return down;
    }


    // 获取单位移速固定加成（real）
    private function GetUnitSpeedBonusReal(unit u) -> real {
        integer uid; real bonus;
        if (u == null) { return 0.0; }
        uid = GetHandleId(u);
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BONUS_REAL)) {
            bonus = LoadReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BONUS_REAL);
        } else {
            bonus = 0.0;
        }
        return bonus;
    }

    // 获取当前单位移速总倍率：(1 + up) * (1 - down)，默认 1.0
    public function GetUnitSpeedFinalPercent(unit u) -> real {
        real up; real down; real rate;
        if (u == null) { return 1.0; }
        up = GetUnitSpeedUpRate(u);
        down = GetUnitSpeedDownRate(u);
        rate = (1.0 + up) * (1.0 - down);
        return rate;
    }

    // 获取单位"基础移速"（不含增减幅与定值）
    public function GetUnitBaseSpeed(unit u) -> real {
        integer uid; real base; real cur;

        if (u == null) { return 0.0; }

        uid = GetHandleId(u);

        // 若已缓存基础移速，则直接返回
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL)) {
            return LoadReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL);
        }

        // 未初始化时，仅根据当前移速计算并返回，但不写入哈希表
        cur = GetUnitMoveSpeed(u);
        base = cur;

        return base;
    }

    // 计算单位当前"最终移速"（基础 * 总倍率 + 定值）
    private function CalcUnitFinalSpeedReal(unit u) -> real {
        real base; real rate; real bonus;

        if (u == null) { return 0.0; }

        base = GetUnitBaseSpeed(u);
        rate = GetUnitSpeedFinalPercent(u);
        bonus = GetUnitSpeedBonusReal(u);

        return base * rate + bonus;
    }

    // 获取移速
    public function GetUnitSpeed (unit u)  -> integer {
        integer uid; real total;
        if (u == null) { return 0; }
        uid = GetHandleId(u);

        // 纯读取：突破522与0的移速的 Hook 优先读缓存
        if (HaveSavedInteger(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED)) {
            return LoadInteger(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED);
        }

        // 若存在移速扩展数据：仅计算，不写入（避免读函数写入导致 OOS）
        if (HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL) ||
            HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_UP_RATE) ||
            HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_DOWN_RATE) ||
            HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BONUS_REAL)) {
            total = CalcUnitFinalSpeedReal(u);
            total = RMaxBJ(total, 0.0);
            return R2I(total);
        }

        return R2I(GetUnitMoveSpeed(u));
    }

    // 重新计算单位当前移速（应用增减幅与定值，并写入 KEY_UNIT_MOVE_SPEED 供 Hook 读取）
    private function RecalcUnitSpeed(unit u) -> nothing {
        real total; integer uid; real cur; real base; integer value;
        if (u == null) { return; }

        // 懒初始化单位的基础移速缓存
        uid = GetHandleId(u);
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL)) {
            cur = GetUnitMoveSpeed(u);
            base = cur;
            SaveReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL, base);
        }

        total = CalcUnitFinalSpeedReal(u);
        total = RMaxBJ(total, 0.0);
        value = R2I(total);

        // 突破 522/0 的 Hook：把最终值缓存到 KEY_UNIT_MOVE_SPEED
        SaveInteger(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED, value);
        SetUnitMoveSpeed(u, value);
    }

    // 增加移速基础值（会吃到增减幅：最终移速 = (base + delta) * percent + bonus）
    public function AddUnitSpeedBase(unit u, real speed) -> nothing {
        integer uid; real base;
        if (u == null || speed == 0.0) { return; }
        uid = GetHandleId(u);
        base = GetUnitBaseSpeed(u);
        base = base + speed;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BASE_REAL, base);
        RecalcUnitSpeed(u);
    }

    // 增加移速增幅（百分比形式，value 为小数，如 0.2 表示 +20%）
    public function AddUnitSpeedUpPercent(unit u, real value) -> nothing {
        integer uid; real up;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        up = GetUnitSpeedUpRate(u);
        up = up + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_UP_RATE, up);
        RecalcUnitSpeed(u);
    }

    // 增加移速减幅（value 为小数，如 0.3 表示 -30%）
    public function AddUnitSpeedDownPercent(unit u, real value) -> nothing {
        integer uid; real down;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        down = GetUnitSpeedDownRate(u);
        down = RealAdd(down, value);
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_DOWN_RATE, down);
        RecalcUnitSpeed(u);
    }

    // 增加固定移速（不受增减幅影响）
    public function AddUnitSpeedBonus(unit u, real value) -> nothing {
        integer uid; real bonus;
        if (u == null || value == 0.0) { return; }
        uid = GetHandleId(u);
        bonus = GetUnitSpeedBonusReal(u);
        bonus = bonus + value;
        SaveReal(HASH_UNIT, uid, KEY_UNIT_MOVE_SPEED_BONUS_REAL, bonus);
        RecalcUnitSpeed(u);
    }

    //射程(还会+警戒范围)
    public function GetUnitAttackRange(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE));
    }
    //设置射程(还会设置警戒范围)
    public function SetUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),range);
		SetUnitAcquireRange(u,RMaxBJ(range,900.0));
    }
    //增加射程(还会+警戒范围)
	public function AddUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE),GetUnitAttackRange(u) + range);
		SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0));
    }

    // 获取攻速
    public function GetUnitAttackSpeed(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE));
    }
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE),GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE)) + speed);
	}

    // (获取缓存的攻击间隔(可能为负))
    public function GetUnitAttackIntervalCache(unit u) -> real {
        return LoadReal(HASH_UNIT,GetHandleId(u),KEY_UNIT_ATTACK_INTERVAL_CACHE);
    }

    // (获取单位的攻击间隔,不会小于0.1)
    public function GetUnitAttackInterval(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL));
    }

    // 攻击间隔(虽然写着加,但是实际是减) - 带最小值与观察者
	public function AddAttackInterval (unit u,real value) {
        real cacheValue; real newValue; integer uid;

        uid = GetHandleId(u);

        // 检查是否已初始化缓存
        if (!HaveSavedReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE)) {
            // 如果没有初始化，先保存当前攻击间隔到缓存
            SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE, GetUnitAttackInterval(u));
        }

        // 获取当前缓存值并添加新值
        cacheValue = LoadReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE);
        cacheValue += value;

        // 更新缓存
        SaveReal(HASH_UNIT, uid, KEY_UNIT_ATTACK_INTERVAL_CACHE, cacheValue);

        // 设置实际攻击间隔（确保不小于MIN_ATTACK_INTERVAL）
        newValue = RMaxBJ(cacheValue, MIN_ATTACK_INTERVAL);
        SetUnitState(u, ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL), newValue);

        // 观察者模式回调
        if (unitAttrObserver.attackIntervalCB != null) {
            unitAttrObserver.argsU = u;
            TriggerEvaluate(unitAttrObserver.attackIntervalCB);
        }
	}

    //=====================
    // 攻击图标自定义显示（角标与贴图）
    //=====================

    // 设置单位攻击图标角标文本
    public function SetUnitAtkCornerText(unit u, string value) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        // 空字符串视为无效，等同于清除
        if (value == null || value == "") {
            if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT)) {
                RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT);
            }
        } else {
            SaveStr(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT, value);
        }
    }

    // 获取单位攻击图标角标文本（无效时返回 null）
    public function GetUnitAtkCornerText(unit u) -> string {
        integer uid; string value;
        if (u == null) { return null; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT)) {
            value = LoadStr(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT);
            // 空字符串视为无效
            if (value == "") {
                return null;
            }
            return value;
        }
        return null;
    }

    // 清除单位攻击图标角标文本
    public function ClearUnitAtkCornerText(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT)) {
            RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_CORNER_TEXT);
        }
    }

    // 设置单位攻击图标自定义贴图路径
    public function SetUnitAtkTexture(unit u, string value) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        // 空字符串视为无效，等同于清除
        if (value == null || value == "") {
            if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE)) {
                RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE);
            }
        } else {
            SaveStr(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE, value);
        }
    }

    // 获取单位攻击图标自定义贴图路径（无效时返回 null）
    public function GetUnitAtkTexture(unit u) -> string {
        integer uid; string value;
        if (u == null) { return null; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE)) {
            value = LoadStr(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE);
            // 空字符串视为无效
            if (value == "") {
                return null;
            }
            return value;
        }
        return null;
    }

    // 清除单位攻击图标自定义贴图路径
    public function ClearUnitAtkTexture(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE)) {
            RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_TEXTURE);
        }
    }

    //=====================
    // 攻击数值自定义显示（ValueStr）
    //=====================

    // 设置单位攻击数值自定义显示文本
    public function SetUnitAtkValueStr(unit u, string value) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        // 空字符串视为无效，等同于清除
        if (value == null || value == "") {
            if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR)) {
                RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR);
            }
        } else {
            SaveStr(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR, value);
        }
    }

    // 获取单位攻击数值自定义显示文本（无效时返回 null）
    public function GetUnitAtkValueStr(unit u) -> string {
        integer uid; string value;
        if (u == null) { return null; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR)) {
            value = LoadStr(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR);
            // 空字符串视为无效
            if (value == "") {
                return null;
            }
            return value;
        }
        return null;
    }

    // 清除单位攻击数值自定义显示文本
    public function ClearUnitAtkValueStr(unit u) -> nothing {
        integer uid;
        if (u == null) { return; }
        uid = GetHandleId(u);
        if (HaveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR)) {
            RemoveSavedString(HASH_UNIT, uid, KEY_UNIT_ATK_VALUE_STR);
        }
    }

    //传送单位(带特效与镜头转换)
    public function TransportUnit (unit u,real x,real y,boolean camera) {
        if (camera) PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0.2);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)));
        SetUnitPosition(u,x,y);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)));
    }

}

//! endzinc
#endif
