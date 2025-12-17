#ifndef AttractionIncluded
#define AttractionIncluded

#include "Crainax/core/table/Hash_UnitDefine.j"

//! zinc
/*
吸怪共通库
*/

#define KEY_TIMER_ATTRACT_THIS  801234561

library Attraction {

    /*
    引力（可选回返）
    */
    public struct Attraction {
        private unit caster;
        private real radius;
        private real interval;
        private real speed;
        private timer t;
        private boolean forbitHero;
        private boolean deathContinue;
        private boolean enableComeback;
        private group comebackGroup;

        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(Attraction)

        static method create(unit caster, real radius, real interval, real speed) -> thistype {
            thistype this;

            this = thistype.allocate();
            this.caster = caster;
            this.radius = radius;
            this.interval = interval;
            this.speed = speed;
            this.forbitHero = false;
            this.deathContinue = false;
            this.enableComeback = false;
            this.comebackGroup = null;
            return this;
        }

        static method createBack(unit caster, real radius, real speed) -> thistype {
            thistype this;

            this = thistype.create(caster, radius, 0.05, speed);
            this.setComeback(true);
            return this;
        }

        method setComeback(boolean enable) {
            if (this.t != null) {
                return;
            }
            this.enableComeback = enable;
            if (enable) {
                if (this.comebackGroup == null) {
                    this.comebackGroup = CreateGroup();
                }
            } else {
                if (this.comebackGroup != null) {
                    DestroyGroup(this.comebackGroup);
                    this.comebackGroup = null;
                }
            }
        }

        method SetForbitHero() {
            this.forbitHero = true;
        }

        method SetDeathContinue() {
            this.deathContinue = true;
        }

        method setSpeed(real speed) {
            this.speed = speed;
        }

        method start() {
            if (!this.isExist()) {
                return;
            }
            this.t = CreateTimer();
            SaveInteger(HASH_TIMER, GetHandleId(this.t), KEY_TIMER_ATTRACT_THIS, this);
            TimerStart(this.t, this.interval, true, function () {

                real x1;
                real y1;
                real x2;
                real y2;
                real facing;
                real distance;
                thistype this;
                group l_group;
                unit l_unit;

                this = LoadInteger(HASH_TIMER, GetHandleId(GetExpiredTimer()), KEY_TIMER_ATTRACT_THIS);
                l_group = CreateGroup();

                if (IsUnitAliveBJ(this.caster)) {
                    GroupEnumUnitsInRangeEx(l_group, GetUnitX(this.caster), GetUnitY(this.caster), this.radius, null);
                    while (true) {
                        l_unit = FirstOfGroup(l_group);
                        if (l_unit == null) {
                            break;
                        }
                        GroupRemoveUnit(l_group, l_unit);
                        if (IsEnemyUnit(l_unit, this.caster) && (GetUnitMoveSpeed(l_unit) > 0) && !(this.forbitHero && IsUnitType(l_unit, UNIT_TYPE_HERO)) && GetUnitAbilityLevel(l_unit, 'A04m') < 1 && !IsUnitBoss(l_unit)) {
                            if (this.enableComeback && this.comebackGroup != null) {
                                if (!HaveSavedReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_X)) {
                                    SaveReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_X, GetUnitX(l_unit));
                                    SaveReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_Y, GetUnitY(l_unit));
                                    GroupAddUnit(this.comebackGroup, l_unit);
                                }
                            }
                            x2 = GetUnitX(l_unit);
                            y2 = GetUnitY(l_unit);
                            x1 = GetUnitX(this.caster);
                            y1 = GetUnitY(this.caster);
                            distance = SquareRoot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
                            if (distance > 80) {
                                facing = Atan2BJ(y1 - y2, x1 - x2);
                                SetUnitX(l_unit, YDWECoordinateX(x2 + CosBJ(facing) * this.speed));
                                SetUnitY(l_unit, YDWECoordinateY(y2 + SinBJ(facing) * this.speed));
                            }
                        }
                    }
                    DestroyGroup(l_group);
                } else {
                    if (!this.deathContinue && this.isExist()) {
                        this.destroy();
                    }
                }
                l_group = null;
                l_unit = null;

            });
        }

        static method comeback(group g) {
            integer iGroup;
            integer iMaxGroup;
            unit l_unit;

            iGroup = 1;
            iMaxGroup = CountUnitsInGroup(g);
            l_unit = null;

            while (true) {
                if (iGroup > iMaxGroup) {
                    break;
                }
                l_unit = FirstOfGroup(g);
                GroupRemoveUnit(g, l_unit);
                if (l_unit != null) {
                    if (HaveSavedReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_X)) {
                        SetUnitX(l_unit, LoadReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_X));
                        SetUnitY(l_unit, LoadReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_Y));
                        DestroyEffect(AddSpecialEffect("effects\\comeback.mdl", GetUnitX(l_unit), GetUnitY(l_unit)));
                        RemoveSavedReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_Y);
                        RemoveSavedReal(HASH_UNIT, GetHandleId(l_unit), KEY_UNIT_BACK_X);
                    }
                }
                iGroup = iGroup + 1;
            }
            l_unit = null;
        }

        method onDestroy() {
            if (!this.isExist()) {
                return;
            }
            if (this.t != null) {
                FlushChildHashtable(HASH_TIMER, GetHandleId(this.t));
                PauseTimer(this.t);
                DestroyTimer(this.t);
                this.t = null;
            }
            this.caster = null;
            if (this.enableComeback && this.comebackGroup != null) {
                thistype.comeback(this.comebackGroup);
            }
            if (this.comebackGroup != null) {
                DestroyGroup(this.comebackGroup);
                this.comebackGroup = null;
            }
        }
    }

    /*
    简约式的吸怪
    2:是怪物专用
    */
    public function CreateAttractionAt(unit caster, real x, real y, real radius, real yinli, real time, boolean b) {
        unit u;
        Attraction attract;

        u = CreateUnit(GetOwningPlayer(caster), 'h005', x, y, 0);
        attract = Attraction.createBack(u, radius, yinli);
        UnitApplyTimedLifeBJ(time, 'BHwe', u);
        if (b) {
            attract.SetForbitHero();
        }
        attract.start();
        u = null;
    }

    //面向前面100吸怪
    public function CreateAttractionForCaster(unit caster, real radius, real time) {
        real rad;
        real tx;
        real ty;

        rad = GetUnitFacing(caster) * bj_DEGTORAD;
        tx = YDWECoordinateX(GetUnitX(caster) + 100.0 * Cos(rad));
        ty = YDWECoordinateY(GetUnitY(caster) + 100.0 * Sin(rad));
        CreateAttractionAt(caster, tx, ty, radius, radius * 0.1, time, true);
    }

}

#undef KEY_TIMER_ATTRACT_THIS

//! endzinc
#endif
