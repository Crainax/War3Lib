#ifndef SpellDataIncluded
#define SpellDataIncluded

#include "Crainax/core/table/Hash_SLKDefine.j"

//! zinc
/*
技能数据
*/
library SpellData {

    public constant integer SPELL_TYPE_ENTITY  = 0;  //固定技能(默认)
    public constant integer SPELL_TYPE_MIRROR  = 1;  //镜像技能(英雄的模板技能)
    public constant integer SPELL_TYPE_VIRTUAL = 2;  //虚拟技能(物品技能)
    public constant integer SPELL_TYPE_SIMPLE  = 3;  //简单技能(无结构体,固定发挥)

    public struct spellData [] {

        static unit argsU = null; //事件单位
        static integer argsLevel = 0; //事件等级
        static integer counter = 0; // 当前有几个技能数据

        integer id;         // 技能ID(从那边直接获取数据)
        integer spellType;  // 技能类型(1:结构技能,2:无结构技能,3:虚拟技能,4:简单技能)

        trigger trInit;     // 技能初始化事件
        trigger trDestroy;  // 技能销毁事件
        trigger trUpgrade;  // 技能升级事件

        integer maxLevel;     // 技能等级(最大等级)
        string  description;  // 技能描述
        string  icon;         // 技能图标

        public method registerInit(code func) {
            if (trInit == null) {
                trInit = CreateTrigger();
            }
            TriggerAddCondition(trInit, Condition(func));
        }

        public method registerDestroy(code func) {
            if (trDestroy == null) {
                trDestroy = CreateTrigger();
            }
            TriggerAddCondition(trDestroy, Condition(func));
        }

        public method registerUpgrade(code func) {
            if (trUpgrade == null) {
                trUpgrade = CreateTrigger();
            }
            TriggerAddCondition(trUpgrade, Condition(func));
        }

        //根据技能类型
        public static method byType(integer at) -> thistype {
            thistype this;
            if (HaveSavedInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA)) {
                this = LoadInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA);
            } else {
                counter += 1;
                this = thistype[counter];
                SaveInteger(HASH_SLK, at, HASH_KEY_SLK_SPELLDATA, this);
                id = at;
                maxLevel = 1; //默认最大等级1级
            }
            return this;
        }

        // 返回一个新的并自增(空物编),这个一定不能用来做spell的,只能用来做
        public static method new ()  -> thistype {
            thistype this;
            counter += 1;
            this = thistype[counter];
            return this;
        }
    }

}

//! endzinc
#endif
