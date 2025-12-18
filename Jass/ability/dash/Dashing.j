#ifndef DashingIncluded
#define DashingIncluded

#include "edit/Base/CRBase.j"
//! zinc
/*
简易单位冲刺(带多处回调)
*/
library Dashing requires CRBase {



    public function DashI(unit caster, real x, real y, real speed, real max, OnDashComplete odc, OnDashing od) -> timer {
        real facing;

        facing = GetFacing(GetUnitX(caster), GetUnitY(caster), x, y);
        tempTimer = CreateTimer();
        SetUnitFacing(caster, facing);
        IssuePointOrder(caster, "move", x, y);
        SetUnitAnimation(caster, "spell");
        SaveInteger(SPTable, GetHandleId(tempTimer), 1, 1);
        SaveReal(SPTable, GetHandleId(tempTimer), 2, facing);
        SaveReal(SPTable, GetHandleId(tempTimer), 3, YDWECoordinateX(x));
        SaveReal(SPTable, GetHandleId(tempTimer), 4, YDWECoordinateY(y));
        SaveReal(SPTable, GetHandleId(tempTimer), 5, speed);
        SaveUnitHandle(SPTable, GetHandleId(tempTimer), 6, caster);
        SaveReal(SPTable, GetHandleId(tempTimer), 7, max);
        if (odc != 0) {
            SaveInteger(SPTable, GetHandleId(tempTimer), 8, odc);
        }
        if (od != 0) {
            SaveInteger(SPTable, GetHandleId(tempTimer), 9, od);
        }
        TimerStart(tempTimer, 0.02, true, function () {
            timer t;
            integer id;
            integer i;
            real facing;
            real x;
            real y;
            real speed;
            unit u;
            real xp;
            real yp;
            real max;
            OnDashComplete odc;
            OnDashing od;
            boolean b;

            t = GetExpiredTimer();
            id = GetHandleId(t);
            i = LoadInteger(SPTable, id, 1);
            facing = LoadReal(SPTable, id, 2);
            x = LoadReal(SPTable, id, 3);
            y = LoadReal(SPTable, id, 4);
            speed = LoadReal(SPTable, id, 5);
            u = LoadUnitHandle(SPTable, id, 6);
            xp = YDWECoordinateX(GetUnitX(u) + speed * CosBJ(facing));
            yp = YDWECoordinateY(GetUnitY(u) + speed * SinBJ(facing));
            max = LoadReal(SPTable, id, 7);
            odc = 0;
            od = 0;
            b = false;

            if (HaveSavedInteger(SPTable, id, 8)) {
                odc = LoadInteger(SPTable, id, 8);
            }
            if (HaveSavedInteger(SPTable, id, 9)) {
                od = LoadInteger(SPTable, id, 9);
            }

            if (i <= 600 && !IsTerrainPathable(xp, yp, PATHING_TYPE_WALKABILITY)) {
                i = i + 1;
                SaveInteger(SPTable, id, 1, i);
                if (GetDistance(xp, yp, x, y) < speed) {
                    SetUnitX(u, x);
                    SetUnitY(u, y);
                    b = true;
                } else {
                    SetUnitX(u, xp);
                    SetUnitY(u, yp);
                    if (i * speed >= max) {
                        b = true;
                    }
                }
                if (od != 0) {
                    od.execute(t, u, i);
                }
            } else {
                b = true;
            }

            if (b) {
                odc.execute(t, u);
                IssuePointOrder(u, "move", GetUnitX(u), GetUnitY(u));
                PauseTimer(t);
                FlushChildHashtable(SPTable, id);
                DestroyTimer(t);
            }

            t = null;
            u = null;

        });
        return tempTimer;
    }

    // Dash带接口的(有伤害的)
    public function DashII(unit caster, real x, real y, real speed, real max, OnDashComplete odc, OnDashing od, real radius, real damage) -> timer {
        real facing;
        integer id;

        facing = GetFacing(GetUnitX(caster), GetUnitY(caster), x, y);
        id = 0;
        tempTimer = CreateTimer();
        id = GetHandleId(tempTimer);
        SetUnitFacing(caster, facing);
        IssuePointOrder(caster, "move", x, y);
        SetUnitAnimation(caster, "spell");
        SaveInteger(SPTable, id, 1, 1);
        SaveReal(SPTable, id, 2, facing);
        SaveReal(SPTable, id, 3, YDWECoordinateX(x));
        SaveReal(SPTable, id, 4, YDWECoordinateY(y));
        SaveReal(SPTable, id, 5, speed);
        SaveUnitHandle(SPTable, id, 6, caster);
        SaveReal(SPTable, id, 7, max);
        if (odc != 0) {
            SaveInteger(SPTable, id, 8, odc);
        }
        if (od != 0) {
            SaveInteger(SPTable, id, 9, od);
        }
        SaveGroupHandle(SPTable, id, 10, CreateGroup());
        SaveReal(SPTable, id, 11, damage);
        SaveReal(SPTable, id, 12, radius);
        TimerStart(tempTimer, 0.02, true, function () {

            timer t;
            integer id;
            integer i;
            real facing;
            real x;
            real y;
            real speed;
            unit u;
            real xp;
            real yp;
            real max;
            group g;
            real damage;
            real radius;
            OnDashComplete odc;
            OnDashing od;
            boolean b;
            group l_group;
            unit l_unit;

            t = GetExpiredTimer();
            id = GetHandleId(t);
            i = LoadInteger(SPTable, id, 1);
            facing = LoadReal(SPTable, id, 2);
            x = LoadReal(SPTable, id, 3);
            y = LoadReal(SPTable, id, 4);
            speed = LoadReal(SPTable, id, 5);
            u = LoadUnitHandle(SPTable, id, 6);
            xp = YDWECoordinateX(GetUnitX(u) + speed * CosBJ(facing));
            yp = YDWECoordinateY(GetUnitY(u) + speed * SinBJ(facing));
            max = LoadReal(SPTable, id, 7);
            g = LoadGroupHandle(SPTable, id, 10);
            damage = LoadReal(SPTable, id, 11);
            radius = LoadReal(SPTable, id, 12);
            odc = 0;
            od = 0;
            b = false;
            l_group = null;
            l_unit = null;

            if (HaveSavedInteger(SPTable, id, 8)) {
                odc = LoadInteger(SPTable, id, 8);
            }
            if (HaveSavedInteger(SPTable, id, 9)) {
                od = LoadInteger(SPTable, id, 9);
            }

            if (i <= 300 && !IsTerrainPathable(xp, yp, PATHING_TYPE_WALKABILITY)) {
                i = i + 1;
                SaveInteger(SPTable, id, 1, i);
                if (GetDistance(xp, yp, x, y) < speed) {
                    SetUnitX(u, x);
                    SetUnitY(u, y);
                    b = true;
                } else {
                    SetUnitX(u, xp);
                    SetUnitY(u, yp);
                    if (i * speed >= max) {
                        b = true;
                    }
                }
                l_group = CreateGroup();
                GroupEnumUnitsInRangeEx(l_group, GetUnitX(u), GetUnitY(u), radius, null);
                while (true) {
                    l_unit = FirstOfGroup(l_group);
                    if (l_unit == null) {
                        break;
                    }
                    GroupRemoveUnit(l_group, l_unit);
                    if (!IsUnitInGroup(l_unit, g) && IsEnemyMagicUnit(l_unit, u)) {
                        UnitDamageTarget(u, l_unit, damage, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
                        GroupAddUnit(g, l_unit);
                    }
                }
                DestroyGroup(l_group);
                if (od != 0) {
                    od.execute(t, u, i);
                }
            } else {
                b = true;
            }

            if (b) {
                odc.execute(t, u);
                IssuePointOrder(u, "move", GetUnitX(u), GetUnitY(u));
                PauseTimer(t);
                FlushChildHashtable(SPTable, id);
                DestroyTimer(t);
                DestroyGroup(g);
            }

            t = null;
            u = null;
            g = null;
            l_group = null;
            l_unit = null;

        });
        return tempTimer;
    }
}

//! endzinc
#endif
