#ifndef MoverIncluded
#define MoverIncluded

//! zinc
/*
特效移动库
*/
library Mover {

    //弹道移动的接口
    function interface OnMoveComplete takes unit u returns nothing

    // 指定移动  对应接口 OnMoveComplete
    public function Move(unit caster, real x, real y, real speed, OnMoveComplete omc) {
        timer t;

        t = CreateTimer();
        SaveInteger(SPTable, GetHandleId(t), 1, 1);
        SaveReal(SPTable, GetHandleId(t), 3, YDWECoordinateX(x));
        SaveReal(SPTable, GetHandleId(t), 4, YDWECoordinateY(y));
        SaveReal(SPTable, GetHandleId(t), 5, speed);
        SaveUnitHandle(SPTable, GetHandleId(t), 6, caster);
        SaveInteger(SPTable, GetHandleId(t), 7, omc);
        TimerStart(t, 0.05, true, function () {

            timer t;
            integer id;
            integer i;
            real x;
            real y;
            real speed;
            unit u;
            OnMoveComplete omc;
            real facing;
            real xp;
            real yp;
            boolean b;

            t = GetExpiredTimer();
            id = GetHandleId(t);
            i = LoadInteger(SPTable, id, 1);
            x = LoadReal(SPTable, id, 3);
            y = LoadReal(SPTable, id, 4);
            speed = LoadReal(SPTable, id, 5);
            u = LoadUnitHandle(SPTable, id, 6);
            facing = GetFacing(GetUnitX(u), GetUnitY(u), x, y);
            xp = YDWECoordinateX(GetUnitX(u) + speed * CosBJ(facing));
            yp = YDWECoordinateY(GetUnitY(u) + speed * SinBJ(facing));
            b = !IsUnitAliveBJ(u);

            if (GetDistance(xp, yp, x, y) < speed) {
                SetUnitX(u, x);
                SetUnitY(u, y);
                b = true;
            } else {
                SetUnitX(u, xp);
                SetUnitY(u, yp);
            }

            if (b) {
                omc = LoadInteger(SPTable, id, 7);
                omc.execute(u);
                PauseTimer(t);
                FlushChildHashtable(SPTable, id);
                DestroyTimer(t);
            }

            t = null;
            u = null;

        });
        t = null;
    }


}

//! endzinc
#endif
