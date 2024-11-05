#ifndef EffectUtilsIncluded
#define EffectUtilsIncluded

#include "GroupUtils.j"

//! zinc
/*
特效工具
*/
library EffectUtils requires GroupUtils {

    public struct efut [] {
        static integer args1 = 0;
        static group g = null; //临时
    }

    //直线型特效
    public struct missile {

        public static thistype ethis = 0;	//正在运行的实例获取
        static timer t = null;				//运动计时器
        static thistype List [];	//内容列表
        static integer size = 0;	//现在有几个东西

        integer uID;					//[成员]绑定的ID
        real x, y, z, dx, dy, dz;		//[成员]起点与终点
        real xySpeed, zSpeed, speed;	//[成员]移动速度
        effect e;						//[成员]特效本体
        trigger tr;						//[成员]特效到达目标后
        boolean down;					//[成员]是向上还是向下

        optional module efStat;   //[外导的]存储信息

        method isExist () -> boolean {return (this != null && si__missile_V[this] == -1);}

        method onDestroy () {
            DestroyEffect(e);
            DestroyTrigger(tr);
            e = null;
            tr = null;
        }

        method unreg () {
            if (!(isExist())) return;
            if (uID != 0) {
                //这个其实就是将List的[2]设成5  假设2是删  5是最长
                //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
                //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
            this.destroy();
        }

        //func1 是结束时调用
        static method reg (string s,real x,real y,real z,real dx,real dy,real dz,real speed,code func1) -> thistype {
            real distanceXY , distance , distanceZ;
            thistype this = allocate();
            if (this <= 0) {return this;}
            if (size > 8190) {return this;} //防止爆炸

            if (func1 != null) {
                tr = CreateTrigger();
                TriggerAddCondition(tr,Condition(func1));
            }
            e = AddSpecialEffect(s, x, y );
            EXSetEffectZ(e,z);
            EXEffectMatRotateZ(e,GetFacing(x,y,dx,dy));

            this.x       = x;
            this.y       = y;
            this.z       = z;
            this.dx      = dx;
            this.dy      = dy;
            this.dz      = dz;

            distanceXY   = GetDistance(x,y,dx,dy);
            distanceZ    = RAbsBJ(z-dz);
            distance     = GetDistanceZ(x,y,z,dx,dy,dz);
            if (distance > 0) { //设置一下速度
                this.speed   = speed;
                this.xySpeed = speed * SquareRoot(distanceXY * distanceXY / distance / distance);
                this.zSpeed  = speed * SquareRoot(distanceZ * distanceZ / distance / distance);
                if (dz > z) {
                    down = false;
                } else {
                    down = true;
                }
            } else { //原地还行,那就立刻触发吧
                if (tr != null) {
                    ethis = this;
                    TriggerEvaluate(tr);
                }
                destroy();
                return 0;
            }

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }

            if (t == null) {
                t = CreateTimer();
                TimerStart(t,0.05,true,function (){
                    trigger tr;
                    integer i , this;
                    boolean b;
                    if (size > 0) {
                        for (1 <= i <= size) {
                            tr = CreateTrigger();
                            efut.args1 = List[i];
                            TriggerAddCondition(tr, Condition(function () -> boolean {
                                thistype this  = efut.args1;
                                real     angle = GetFacing(x,y,dx,dy);
                                real     nx   = YDWECoordinateX(x + xySpeed * CosBJ(angle));
                                real     ny   = YDWECoordinateY(y + xySpeed * SinBJ(angle));
                                real     nz;

                                if (down) nz = RMaxBJ(dz,z - zSpeed); //向下运动,z速是负数
                                else nz = RMinBJ(dz,zSpeed + z); //向上运动,z速是正数

                                EXSetEffectXY(e,nx,ny);
                                EXSetEffectZ(e,nz);

                                if (GetDistanceZ(nx,ny,nz,dx,dy,dz) <= speed) {  //到地方了
                                    if (tr != null) {
                                        ethis = this;
                                        TriggerEvaluate(tr);
                                    }
                                    unreg();
                                    return false;
                                } else { //没到 存一下地点
                                    x = nx;
                                    y = ny;
                                    z = nz;
                                }

                                return true;
                            }));
                            b = TriggerEvaluate(tr);
                            DestroyTrigger(tr);
                            tr = null;

                            if (!b) i -= 1; //代替在里面的减
                        }
                    }

                    if (size <= 0) { //这里就删计时器吧
                        PauseTimer(t);
                        DestroyTimer(t);
                        t = null;
                    }
                });
            }

            return this;

        }

    }

    //瞄准单位型(带Z轴的贝塞尔曲线)
    public struct umissile {

        public static thistype ethis = 0;	//正在运行的实例获取
        static timer t = null;				//运动计时器
        static thistype List [];	//内容列表
        static integer size = 0;	//现在有几个东西

        integer uID;		//[成员]绑定的ID
        real cd;			//[成员]倒计时
        real ux, uy, uz;	//[成员]贝塞尔点1(起点)
        real ex, ey, ez;	//[成员]贝塞尔点2(中点)
        real nx, ny, nz;	//[成员]贝塞尔点2(终点),用于如果目标死亡的缓存点
        unit u;				//[成员]目标单位
        effect e;			//[成员]特效本体
        trigger tr;			//[成员]特效到达目标后

        optional module efStat;   //[外导的]存储信息

        method isExist () -> boolean {return (this != null && si__umissile_V[this] == -1);}

        method onDestroy () {
            DestroyEffect(e);
            DestroyTrigger(tr);
            e  = null;
            tr = null;
            u  = null;
        }

        method unreg () {
            if (!(isExist())) return;
            if (uID != 0) {
                //这个其实就是将List的[2]设成5  假设2是删  5是最长
                //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
                //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
            this.destroy();
        }

        //由于是跟踪型,目标
        static method reg (string s,real x,real y,real z,unit target,code func1) -> thistype  {
            real angle,angle2;
            real x1,y1;
            integer random;
            thistype this = allocate();
            if (this <= 0) {return this;}
            if (size > 8190) {return this;} //防止爆炸

            if (func1 != null) {
                tr = CreateTrigger();
                TriggerAddCondition(tr,Condition(func1));
            }

			angle  = GetFacing(x,y,GetUnitX(target),GetUnitY(target));
			ux     = YDWECoordinateX(x - 60 * CosBJ(angle));
			uy     = YDWECoordinateY(y - 60 * SinBJ(angle));
			uz     = z + 80;
			x1     = YDWECoordinateX(x - 1 * CosBJ(angle));
			y1     = YDWECoordinateY(y - 1 * SinBJ(angle));
			angle2 = GetFacing(x,y,x1,y1);
			random = GetRandomInt(1,10);
			ex     = CosBJ(90-(18*random+angle2)) * 1000 + x1;
			ey     = SinBJ(90-(18*random+angle2)) * 1000 + y1;
			ez     = 600;
			e      = AddSpecialEffect(s, ux,uy );
			u      = target;
			cd     = 0.;
			nx     = GetUnitX(target);
			ny     = GetUnitY(target);
			nz     = GetUnitFlyHeight(target) + 50;
			EXSetEffectZ(e,uz);

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }

            if (t == null) {
                t = CreateTimer();
                TimerStart(t,0.03,true,function (){
                    trigger tr;
                    integer i , this;
                    boolean b;
                    if (size > 0) {
                        for (1 <= i <= size) {
                            tr = CreateTrigger();
                            efut.args1 = List[i];
                            TriggerAddCondition(tr, Condition(function () -> boolean {
                                thistype this  = efut.args1;
                                real tx,ty,tz; //贝塞尔坐标
                                real txi,tyi; //下一步的位置,求出角度

                                if (cd > 0.98) {  //到地方了
                                    if (tr != null) {
                                        ethis = this;
                                        TriggerEvaluate(tr);
                                    }
                                    unreg();
                                    return false;
                                } else { //没到 存一下地点以防万一
                                    if (IsUnitAliveBJ(u)) { //活着跟踪
                                        nx  = GetUnitX(u);
                                        ny  = GetUnitY(u);
                                        nz  = GetUnitFlyHeight(u) + 50;
                                    } //没活着就

                                    cd += 0.02;
                                    tx  = Pow((1-cd),2)*ux + 2 *cd * (1-cd)*ex  + Pow(cd,2)*nx;
                                    ty  = Pow((1-cd),2)*uy + 2 *cd * (1-cd)*ey  + Pow(cd,2)*ny;
                                    tz  = Pow((1-cd),2)*uz + 2 *cd * (1-cd)*ez  + Pow(cd,2)*nz;
                                    EXSetEffectZ(e,tz);
                                    EXSetEffectXY(e,tx,ty);
                                    EXEffectMatReset(e);
                                    txi = Pow((1-(cd+0.02)),2)*ux + 2 *(cd+0.02) * (1-(cd+0.02))*ex  + Pow((cd+0.02),2)*nx;
                                    tyi = Pow((1-(cd+0.02)),2)*uy + 2 *(cd+0.02) * (1-(cd+0.02))*ey  + Pow((cd+0.02),2)*ny;
                                    EXEffectMatRotateZ(e,GetFacing(tx,ty,txi,tyi));
                                }

                                return true;
                            }));
                            b = TriggerEvaluate(tr);
                            DestroyTrigger(tr);
                            tr = null;

                            if (!b) i -= 1; //代替在里面的减
                        }
                    }

                    if (size <= 0) { //这里就删计时器吧
                        PauseTimer(t);
                        DestroyTimer(t);
                        t = null;
                    }
                });
            }

            return this;

        }

    }

    //直线穿透型
    public struct pierce {

        public static thistype ethis = 0;	//正在运行的实例获取
        static timer t = null;				//运动计时器
        static thistype List [];			//内容列表
        static integer size = 0;			//现在有几个东西

        integer uID;		//[成员]绑定的ID
        real x, y, dx, dy;	//[成员]起点与终点(没有Z)
        real speed,radius;	//[成员]移动速度/单位组检测范围
        effect e;			//[成员]特效本体
        trigger trU,trEnd;	//[成员]触发(伤害时(与帧事件)/结束时)
        group g;			//[成员]缓存单位组

        optional module efStat;   //[外导的]存储信息

        method isExist () -> boolean {return (this != null && si__pierce_V[this] == -1);}

        method onDestroy () {
            DestroyEffect(e);
            DestroyTrigger(trU);
            DestroyTrigger(trEnd);
            DestroyGroup(g);
            e = null;
            trU = null;
            trEnd = null;
            g = null;
        }

        method unreg () {
            if (!(isExist())) return;
            if (uID != 0) {
                //这个其实就是将List的[2]设成5  假设2是删  5是最长
                //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
                //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }
            this.destroy();
        }

        //func1 是结束时调用
        static method reg (string s,real x,real y,real dx,real dy,real speed,real radius,code funU,code funEnd) -> thistype {
            thistype this = allocate();
            if (this <= 0) {return this;}
            if (size > 8190) {return this;} //防止爆炸

            if (funU != null) {
                trU = CreateTrigger();
                TriggerAddCondition(trU,Condition(funU));
            }
            if (funEnd != null) {
                trEnd = CreateTrigger();
                TriggerAddCondition(trEnd,Condition(funEnd));
            }

            e = AddSpecialEffect(s, x, y );
            EXEffectMatRotateZ(e,GetFacing(x,y,dx,dy));

            this.x     = x;
            this.y     = y;
            this.dx    = dx;
            this.dy    = dy;
            this.speed = speed;
            this.radius = radius;
            this.g     = CreateGroup();

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }

            if (t == null) {
                t = CreateTimer();
                TimerStart(t,0.05,true,function (){
                    trigger tr;
                    integer i , this;
                    boolean b;
                    if (size > 0) {
                        for (1 <= i <= size) {
                            tr = CreateTrigger();
                            efut.args1 = List[i];
                            TriggerAddCondition(tr, Condition(function () -> boolean {
                                thistype this  = efut.args1;
                                real     angle = GetFacing(x,y,dx,dy);
                                real     nx    = YDWECoordinateX(x + speed * CosBJ(angle));
                                real     ny    = YDWECoordinateY(y + speed * SinBJ(angle));

                                EXSetEffectXY(e,nx,ny);

                                efut.g = CreateGroup();
                                efut.args1 = this;
                                GroupEnumUnitsInRangeEx(efut.g, nx,ny, radius, Filter(function () -> boolean {
                                    thistype this = efut.args1;
                                    if (!IsUnitInGroup(GetFilterUnit(),g)) {
                                        GroupAddUnit(g,GetFilterUnit());
                                        return true;
                                    }
                                    return false;
                                }));
                                if (trU != null) { //针对每个穿刺到的单位进行操作,也自动归进单位组了
                                    ethis = this;
                                    TriggerEvaluate(trU); //Frame也写到这里吧 帧事件
                                }
                                DestroyGroup(efut.g);
                                efut.g = null;

                                if (GetDistance(nx,ny,dx,dy) <= speed) {  //到地方了
                                    if (trEnd != null) {
                                        ethis = this;
                                        TriggerEvaluate(trEnd);
                                    }
                                    unreg();
                                    return false;
                                } else { //没到 存一下地点
                                    x = nx;
                                    y = ny;
                                }

                                return true;
                            }));
                            b = TriggerEvaluate(tr);
                            DestroyTrigger(tr);
                            tr = null;

                            if (!b) i -= 1; //代替在里面的减
                        }
                    }

                    if (size <= 0) { //这里就删计时器吧
                        PauseTimer(t);
                        DestroyTimer(t);
                        t = null;
                    }
                });
            }

            return this;

        }

    }

}

//! endzinc
#endif
