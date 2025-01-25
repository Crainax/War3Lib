#ifndef UnitAttrHeaderIncluded
#define UnitAttrHeaderIncluded

/*
 * 初始化单位属性宏定义
 * 用法:
 * INIT_UNIT_ATTR(HP) 会初始化HP相关的所有属性为0
 */
#define INIT_UNIT_ATTR(ATTR) \
        this.base##ATTR = 0; CRNL \
        this.ATTR##RateUp = 0; CRNL \
        this.ATTR##RateDown = 0; CRNL \
        this.cached##ATTR = 0; CRNL

/*
 * 单位属性系统宏定义
 * 用法:
 * DEFINE_UNIT_ATTR(HP) 会生成HP相关的所有属性和方法
 * DEFINE_UNIT_ATTR(MP) 会生成MP相关的所有属性和方法
 *
 * 参数说明:
 * ATTR: 属性名(大写), 如HP, MP
 */

#define DEFINE_UNIT_ATTR(ATTR) \
        public  real base##ATTR;      /* 基础ATTR值 */ CRNL \
        public  real ATTR##RateUp;    /* ATTR增幅比例 */ CRNL \
        public  real ATTR##RateDown;  /* ATTR减幅比例 */ CRNL \
        private real cached##ATTR;    /* 缓存的实际ATTR值 */ CRNL \
CRNL \
        /* 增加或减少基础ATTR */ CRNL \
        public method add##ATTR(real value) { CRNL \
            if (value != 0) { CRNL \
                base##ATTR += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR增幅比例 */ CRNL \
        public method add##ATTR##RateUp(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateUp += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR减幅比例 */ CRNL \
        public method add##ATTR##RateDown(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateDown = RealAdd(ATTR##RateDown, value); CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取当前的ATTR倍率 */ CRNL \
        public method getCurrent##ATTR##Rate() -> real { CRNL \
            return (1.0 + ATTR##RateUp) * (1.0 - ATTR##RateDown) - 1.0; CRNL \
        } CRNL \
CRNL \
        /* 获取当前实际ATTR值 */ CRNL \
        public method getCurrent##ATTR() -> real { CRNL \
            return cached##ATTR; CRNL \
        } CRNL \

/*
 * 战斗属性系统宏定义(适用于攻击力、防御力等带固定加成的属性)
 * 用法:
 * DEFINE_COMBAT_ATTR(Atk) 会生成攻击力相关的所有属性和方法
 * DEFINE_COMBAT_ATTR(Def) 会生成防御力相关的所有属性和方法
 */
#define DEFINE_COMBAT_ATTR(ATTR) \
        /* 基础属性值及加成系数 */ CRNL \
        public real base##ATTR;      /* 基础ATTR值 */ CRNL \
        public real ATTR##RateUp;    /* ATTR增幅比例 */ CRNL \
        public real ATTR##RateDown;  /* ATTR减幅比例 */ CRNL \
        public real ATTR##RateBonus; /* 受增减幅影响的bonus值 */ CRNL \
        public real ATTR##FixedBonus;/* 固定加成值(不受增减幅影响) */ CRNL \
        public static trigger tr##ATTR##Change = null;  /* ATTR变化触发器 */ CRNL \
CRNL \
        /* 设置基础ATTR */ CRNL \
        public method setBase##ATTR(real value) { CRNL \
            if (base##ATTR != value) { CRNL \
                base##ATTR = value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加基础ATTR */ CRNL \
        public method addBase##ATTR(real value) { CRNL \
            if (value != 0) { CRNL \
                base##ATTR += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加固定bonus */ CRNL \
        public method add##ATTR##FixedBonus(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##FixedBonus += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR增幅 */ CRNL \
        public method add##ATTR##RateUp(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateUp += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR减幅 */ CRNL \
        public method add##ATTR##RateDown(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateDown = RealAdd(ATTR##RateDown, value); CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取当前总ATTR */ CRNL \
        public method getCurrent##ATTR() -> real { CRNL \
            return base##ATTR + ATTR##RateBonus + ATTR##FixedBonus; CRNL \
        } CRNL \
CRNL \
        /* 获取当前ATTR倍率 */ CRNL \
        public method getCurrent##ATTR##Rate() -> real { CRNL \
            return (1.0 + ATTR##RateUp) * (1.0 - ATTR##RateDown) - 1.0; CRNL \
        } CRNL \
CRNL \
        /* 回调ATTR变化 */ CRNL \
        public static method on##ATTR##Change(code func) { CRNL \
            if (tr##ATTR##Change == null) { CRNL \
                tr##ATTR##Change = CreateTrigger(); CRNL \
            } CRNL \
            TriggerAddCondition(tr##ATTR##Change, Condition(func)); CRNL \
        } CRNL
/*
 * 百分比属性系统宏定义(适用于技能伤害增幅、治疗效果等纯百分比属性)
 * 用法:
 * DEFINE_PERCENTAGE_ATTR(SpellDmg) 会生成技能伤害加成相关的所有属性和方法
 * DEFINE_PERCENTAGE_ATTR(Heal) 会生成治疗效果加成相关的所有属性和方法
 *
 * 参数说明:
 * ATTR: 属性名, 如SpellDmg(技能伤害), Heal(治疗效果)
 * up: 表示提升百分比(例如+20%表示为0.2)
 * down: 表示降低百分比(例如-30%表示为0.3)
 */
#define DEFINE_PERCENTAGE_ATTR(ATTR) \
        public real ATTR##RateUp;    /* ATTR增幅比例 */ CRNL \
        public real ATTR##RateDown;  /* ATTR减幅比例 */ CRNL \
CRNL \
        /* 增加ATTR增幅比例 */ CRNL \
        public method add##ATTR##RateUp(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateUp += value; CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR减幅比例 */ CRNL \
        public method add##ATTR##RateDown(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateDown = RealAdd(ATTR##RateDown, value); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取当前的ATTR最终倍率 */ CRNL \
        public method getCurrent##ATTR() -> real { CRNL \
            return (1.0 + ATTR##RateUp) * (1.0 - ATTR##RateDown) - 1.0; CRNL \
        } CRNL

/*
 * 初始化百分比属性宏定义
 */
#define INIT_PERCENTAGE_ATTR(ATTR) \
        this.ATTR##RateUp = 0.0; CRNL \
        this.ATTR##RateDown = 0.0; CRNL

/*
 * 初始化战斗属性宏定义
 */
#define INIT_COMBAT_ATTR(ATTR) \
        this.base##ATTR = 0.0; CRNL \
        this.ATTR##RateUp = 0.0; CRNL \
        this.ATTR##RateDown = 0.0; CRNL \
        this.ATTR##RateBonus = 0.0; CRNL \
        this.ATTR##FixedBonus = 0.0; CRNL

/*
 * 英雄主属性系统宏定义(适用于力量、敏捷、智力)
 * 用法:
 * DEFINE_HERO_ATTR(Str) 会生成力量相关的所有属性和方法
 * DEFINE_HERO_ATTR(Agi) 会生成敏捷相关的所有属性和方法
 * DEFINE_HERO_ATTR(Int) 会生成智力相关的所有属性和方法
 *
 * 参数说明:
 * ATTR: 属性名(Str/Agi/Int)
 */
#define DEFINE_HERO_ATTR(ATTR,ATTR_UPPER) \
        public real base##ATTR;                       /* 基础ATTR值 */ CRNL \
        public real ATTR##RateUp;                     /* ATTR增幅比例 */ CRNL \
        public real ATTR##RateDown;                   /* ATTR减幅比例 */ CRNL \
        public real ATTR##RateBonus;                  /* 受增减幅影响的bonus值 */ CRNL \
        public real ATTR##FixedBonus;                 /* 固定加成值(不受增减幅影响) */ CRNL \
        public static trigger tr##ATTR##Change = null;  /* ATTR变化触发器 */ CRNL \
CRNL \
        /* 获取基础ATTR(白字) */ CRNL \
        public method getBase##ATTR() -> real { CRNL \
            if (mainAttrType == MAIN_ATTR_##ATTR_UPPER) { CRNL \
                return base##ATTR + mainAttrBase; CRNL \
            } else { CRNL \
                return base##ATTR + subAttrBase; CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取额外ATTR(绿字) */ CRNL \
        public method getExtra##ATTR() -> real { CRNL \
            if (mainAttrType == MAIN_ATTR_##ATTR_UPPER) { CRNL \
                return ATTR##RateBonus + ATTR##FixedBonus + mainAttrFixedBonus; CRNL \
            } else { CRNL \
                return ATTR##RateBonus + ATTR##FixedBonus + subAttrFixedBonus; CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取当前总ATTR */ CRNL \
        public method getCurrent##ATTR() -> real { CRNL \
            if (mainAttrType == MAIN_ATTR_##ATTR_UPPER) { CRNL \
                return base##ATTR + mainAttrBase + ATTR##RateBonus + ATTR##FixedBonus + mainAttrFixedBonus; CRNL \
            } else { CRNL \
                return base##ATTR + subAttrBase + ATTR##RateBonus + ATTR##FixedBonus + subAttrFixedBonus; CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 获取当前ATTR倍率 */ CRNL \
        public method getCurrent##ATTR##Rate() -> real { CRNL \
            if (mainAttrType == MAIN_ATTR_##ATTR_UPPER) { CRNL \
                return (1.0 + ATTR##RateUp + mainAttrRateUp) * (1.0 - ATTR##RateDown) * (1.0 - mainAttrRateDown) - 1.0; CRNL \
            } else { CRNL \
                return (1.0 + ATTR##RateUp + subAttrRateUp) * (1.0 - ATTR##RateDown) * (1.0 - subAttrRateDown) - 1.0; CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 同步并刷新当前单位的ATTR */ CRNL \
        private method sync##ATTR##Rate() { CRNL \
            ATTR##RateBonus = getBase##ATTR() * getCurrent##ATTR##Rate(); CRNL \
            SetHero##ATTR(u, R2I(RMaxBJ(getCurrent##ATTR(), 0.0)), true); CRNL \
            if (tr##ATTR##Change != null) { CRNL \
                ethis = this; CRNL \
                TriggerEvaluate(tr##ATTR##Change); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 设置基础ATTR */ CRNL \
        public method setBase##ATTR(real value) { CRNL \
            if (base##ATTR != value) { CRNL \
                base##ATTR = value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加基础ATTR */ CRNL \
        public method addBase##ATTR(real value) { CRNL \
            if (value != 0) { CRNL \
                base##ATTR += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加固定bonus */ CRNL \
        public method add##ATTR##FixedBonus(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##FixedBonus += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR增幅 */ CRNL \
        public method add##ATTR##RateUp(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateUp += value; CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 增加ATTR减幅 */ CRNL \
        public method add##ATTR##RateDown(real value) { CRNL \
            if (value != 0) { CRNL \
                ATTR##RateDown = RealAdd(ATTR##RateDown, value); CRNL \
                sync##ATTR##Rate(); CRNL \
            } CRNL \
        } CRNL \
CRNL \
        /* 回调ATTR变化 */ CRNL \
        public static method on##ATTR##Change(code func) { CRNL \
            if (tr##ATTR##Change == null) { CRNL \
                tr##ATTR##Change = CreateTrigger(); CRNL \
            } CRNL \
            TriggerAddCondition(tr##ATTR##Change, Condition(func)); CRNL \
        } CRNL

/*
 * 初始化英雄属性宏定义
 */
#define INIT_HERO_ATTR(ATTR) \
        this.base##ATTR = 0.0; CRNL \
        this.ATTR##RateUp = 0.0; CRNL \
        this.ATTR##RateDown = 0.0; CRNL \
        this.ATTR##RateBonus = 0.0; CRNL \
        this.ATTR##FixedBonus = 0.0; CRNL

#endif
