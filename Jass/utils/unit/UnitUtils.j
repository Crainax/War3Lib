#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/UNDefine.j" //constant可以直接加进去没问题
#include "Crainax/core/constant/JapiConstant.j" //constant可以直接加进去没问题

//! zinc
/*
单位有关的增强功能
*/
library UnitUtils {

    //获取单位的攻击力/防御/生命/魔法值
    #define GetUnitAttack(u) R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE)))
    #define GetUnitDefense(u) R2I(GetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR)))
    #define GetUnitHP(u) GetUnitState(u,UNIT_STATE_MAX_LIFE)
    #define GetUnitMP(u) GetUnitState(u,UNIT_STATE_MAX_MANA)

    //设置攻击力
    #define SetUnitAttack(u,attack) SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_DAMAGE_BASE),attack)
    //增加攻击力
    #define AddUnitAttack(u,attack) SetUnitAttack(u,GetUnitAttack(u) + attack)

    //设置防御
	#define SetUnitDefense(u,defense) SetUnitState(u,ConvertUnitState(UNIT_STATE_ARMOR),defense)
    //增加防御
	#define AddUnitDefense(u,defense) SetUnitDefense(u,GetUnitDefense(u)+defense)

    //修改生命最大值
    #define SetUnitHP(u,hp) SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(hp,5.0))
    //增加生命最大值
	public function AddUnitHP(unit u,real hp ) {
		SetUnitHP(u,RMaxBJ(GetUnitHP(u)+hp,10.0));
		if (hp > 0) {SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+hp);}
	}
    //回血(定值)
    #define RegenUnitHP(u,volume) SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+volume)
    //回蓝(百分比)
    #define RegenUnitHPPercent(u,rate) SetUnitLifeBJ(u,GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate)

    //设置魔法最大值
    #define SetUnitMP(u,mp) SetUnitState(u,UNIT_STATE_MAX_MANA,mp)
    //增加魔法最大值
	public function AddUnitMP(unit u,real mp ) {
		SetUnitMP(u,GetUnitMP(u)+mp);
		if (mp > 0) {SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+mp);}
	}
    //回蓝(定值)
    #define RegenUnitMP(u,volume) SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+volume)
    //回蓝(百分比)
    #define RegenUnitMPPercent(u,rate) SetUnitManaBJ(u,GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate)

    // 获取移速
    public function GetUnitSpeed (unit u)  -> integer {
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            return LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            value  = LoadInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
            value += speed;
            SaveInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }
    // 初始化突破移速
    public function InitUnitSpeed (unit u) {
        SaveInteger(HASH_UNIT,GetHandleId(u),KEY_UNIT_MOVE_SPEED,R2I(GetUnitMoveSpeed(u)));
    }

    //射程(还会+警戒范围)
    #define GetUnitAttackRange(u) GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_RANGE))
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
    #define GetUnitAttackSpeed(u) GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE))
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE),GetUnitState(u,ConvertUnitState(UNIT_STATE_RATE_OF_FIRE)) + speed);
	}

    #define GetUnitInterval(u) GetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL))
    // 攻击间隔(虽然写着加,但是实际是减)
	public function AddAttackInterval (unit u,real value) {
        SetUnitState(u,ConvertUnitState(UNIT_STATE_ATTACK1_INTERVAL),GetUnitInterval(u) - value);
	}

    //传送单位(带特效与镜头转换)
    public function TransportUnit (unit u,real x,real y,boolean camera) {
        if (camera) PanCameraToTimedForPlayer(GetOwningPlayer(u),x,y,0.2);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)));
        SetUnitPosition(u,x,y);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", GetUnitX(u), GetUnitY(u)));
    }

    //删除单位
    public function DeleteUnit (unit u) {
        FlushChildHashtable(HASH_UNIT,GetHandleId(u));
        RemoveUnit(u);
    }

}

//! endzinc
#endif
