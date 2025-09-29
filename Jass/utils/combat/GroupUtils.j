#ifndef GroupUtilsIncluded
#define GroupUtilsIncluded

//! zinc
/*
单位组有关
伤害有关
// u = FirstOfGroup(g);  //少用这个,单位删了后直接是0了
用GroupPickRandomUnit(g);好一些
*/
library GroupUtils requires UnitFilter {

    group tempG = null;
    player tempP = null;

    //库补充,防内存泄漏
    public function GroupEnumUnitsInRangeEx (group whichGroup,real x,real y,real radius,boolexpr filter) {
        GroupEnumUnitsInRange(whichGroup, x, y, radius, filter);
        DestroyBoolExpr(filter);
    }
    //库补充,防内存泄漏
    public function GroupEnumUnitsInRectEx (group whichGroup,rect r,boolexpr filter) {
        GroupEnumUnitsInRect(whichGroup, r, filter);
        DestroyBoolExpr(filter);
    }

    //获取单位组:[敌方]
    public function GetEnemyGroup (player p,real x,real y,real radius) -> group {
        tempG = CreateGroup();
        tempP = p;
        GroupEnumUnitsInRangeEx(tempG, x, y, radius, Filter(function () -> boolean {
            if (IsEnemy(GetFilterUnit(),tempP)) {
                return true;
            }
            return false;
        }));
        tempP = null;
        return tempG;
    }

    //复制单位组
    //复制g1进新组并返回
    public function CopyGroup (group g1) -> group {
        tempG = CreateGroup();
        GroupAddGroup(g1, tempG);
        return tempG;
    }


    // 矩形区域过滤参数
    real tempRectX = 0.0;
    real tempRectY = 0.0;
    real tempRectFacing = 0.0;
    real tempRectRadius = 0.0;

    /*
    获取矩形区域的敌方单位组
    参数: p - 玩家, x,y - 矩形中心点, facing - 朝向角度, radius - 矩形宽度的一半, length - 矩形长度
    */
    public function GetRectEnemyGroup (player p, real x, real y, real facing, real radius, real length) -> group {
        real centerX; real centerY;

        // 计算矩形中心点坐标
        centerX = YDWECoordinateX(x + length / 2 * CosBJ(facing));
        centerY = YDWECoordinateY(y + length / 2 * SinBJ(facing));

        // 设置过滤参数
        tempG = CreateGroup();
        tempP = p;
        tempRectX = x;
        tempRectY = y;
        tempRectFacing = facing;
        tempRectRadius = radius;

        // 使用圆形枚举，然后在过滤器中进行矩形判断
        GroupEnumUnitsInRangeEx(tempG, centerX, centerY, length/2, Filter(function () -> boolean {
            real unitX; real unitY; real perpDistance;

            if (!IsEnemy(GetFilterUnit(), tempP)) {
                return false;
            }

            // 计算单位到矩形中轴线的垂直距离
            unitX = GetUnitX(GetFilterUnit());
            unitY = GetUnitY(GetFilterUnit());
            perpDistance = RAbsBJ(SinBJ(tempRectFacing) * (unitX - tempRectX) + CosBJ(tempRectFacing) * (tempRectY - unitY));

            return perpDistance < tempRectRadius;
        }));

        // 清理临时变量
        tempP = null;
        tempRectX = 0.0;
        tempRectY = 0.0;
        tempRectFacing = 0.0;
        tempRectRadius = 0.0;

        return tempG;
    }

    //返回范围内的随机一个敌方单位
    public function GetRandomEnemyUnit (player p, real x, real y, real radius) -> unit {
        group g = GetEnemyGroup(p, x, y, radius);
        unit u = GroupPickRandomUnit(g);
        DestroyGroup(g);
        g = null;
        return u;
    }

    // 用于存储最大生命值单位的临时变量
    unit tempMaxLifeUnit = null;
    real tempMaxLife = 0.0;

    //返回范围内生命值最高的随机敌方单位
    public function GetRandomMaxLifeEnemy (player p, real x, real y, real radius) -> unit {
        group enemyGroup; unit result;

        // 重置临时变量
        tempMaxLifeUnit = null;
        tempMaxLife = 0.0;
        tempP = p;

        // 创建临时单位组
        enemyGroup = CreateGroup();
        GroupEnumUnitsInRangeEx(enemyGroup, x, y, radius, Filter(function () -> boolean {
            real currentLife;

            if (!IsEnemy(GetFilterUnit(), tempP)) {
                return false;
            }

            // 检查是否是生命值更高的单位
            currentLife = GetUnitState(GetFilterUnit(), UNIT_STATE_LIFE);
            if (currentLife > tempMaxLife) {
                tempMaxLife = currentLife;
                tempMaxLifeUnit = GetFilterUnit();
            }

            return true;
        }));

        // 获取结果并清理
        result = tempMaxLifeUnit;
        tempMaxLifeUnit = null;
        tempMaxLife = 0.0;
        tempP = null;
        DestroyGroup(enemyGroup);
        enemyGroup = null;

        return result;
    }

    //获取矩形区域内的所有敌方单位
    public function GetRectAllEnemy (rect r, player p) -> group {
        tempG = CreateGroup();
        tempP = p;
        GroupEnumUnitsInRectEx(tempG, r, Filter(function () -> boolean {
            return IsEnemy(GetFilterUnit(), tempP);
        }));
        tempP = null;
        return tempG;
    }

    //获取矩形区域内的所有敌方单位
    public function GetRectByFilter (rect r, code be) -> group {
        tempG = CreateGroup();
        GroupEnumUnitsInRectEx(tempG, r, Filter(be));
        tempP = null;
        return tempG;
    }
}

//! endzinc
#endif
