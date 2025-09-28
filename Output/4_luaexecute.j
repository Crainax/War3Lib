//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 当前构建版本
// 当前的平台分包
// 原生UI的大小
//地图的最低攻击间隔(非特殊情况)
//冲刺最大槽位数
//! zinc
/*
单位有关
*/
// 基础单位状态检查（生命值、存活状态）
// 敌对关系检查（不包含虚拟单位判断）
// 完整的敌方目标检查（合并两部分）
library UnitFilter {
    //判断是否是敌方(不带无敌)
    public function IsEnemy (unit u,player p) -> boolean {
        return ( ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 && (GetUnitState(u, UNIT_STATE_LIFE) > 0) ) && ( !IsUnitType(u, UNIT_TYPE_SLEEPING) && !IsUnitType(u, UNIT_TYPE_STRUCTURE) && !IsUnitHidden(u) && IsUnitEnemy(u, p) && IsUnitVisible(u, p) ) ) && GetUnitAbilityLevel(u, 'Avul') < 1;
    }
    //旧名：IsEnemy2
    //判断是否是敌方(能匹配到无敌单位)
    public function IsEnemyIncludeInvul (unit u,player p) -> boolean {
        return ( ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 && (GetUnitState(u, UNIT_STATE_LIFE) > 0) ) && ( !IsUnitType(u, UNIT_TYPE_SLEEPING) && !IsUnitType(u, UNIT_TYPE_STRUCTURE) && !IsUnitHidden(u) && IsUnitEnemy(u, p) && IsUnitVisible(u, p) ) );
    }
    //判断是否是敌方非魔法免疫单位
    public function IsEnemyMagic (unit u,player p) -> boolean {
        return !IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) && IsEnemy(u,p) && !IsUnitType(u, UNIT_TYPE_RESISTANT);
    }
    //判断是否是敌方(简化版本,只检查基础状态和敌对关系)
    public function IsEnemyBasic(unit u, player p) -> boolean {
        return ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 && (GetUnitState(u, UNIT_STATE_LIFE) > 0) ) && IsUnitEnemy(u, p);
    }
    //判断是否是友方
    public function IsAlly (unit u,player p) -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitAlly(u, p);
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
        return ( GetUnitState(target, UNIT_STATE_LIFE) > 0.405 && (GetUnitState(target, UNIT_STATE_LIFE) > 0) ) && IsUnitEnemy(target, GetOwningPlayer(caster));
    }
    //判断是否是敌方非魔法免疫单位(双单位参数版)
    public function IsEnemyMagicUnit(unit target, unit caster) -> boolean {
        return IsEnemyMagic(target, GetOwningPlayer(caster));
    }
    // //判断单位是否属于指定常见种族或中立阵营
    // // 人族/兽族/不死/精灵 以及 中立敌对/中立中立
    // // 注意：当传入目标并非单位（例如对可破坏物 'DTrc' 使用 GetSpellTargetUnit()）时，u 可能为 null，返回 false
    // public function IsUnitRaceOK (unit u)  -> boolean {
    //     race r; player o;
    //     if (u == null) return false;
    //     r = GetUnitRace(u);
    //     if (r == RACE_HUMAN) return true;      // 人族
    //     if (r == RACE_ORC) return true;        // 兽族
    //     if (r == RACE_UNDEAD) return true;     // 不死
    //     if (r == RACE_NIGHTELF) return true;   // 精灵
    //     // 娜迦单位在实际地图中多归属中立敌对/中立中立，这里通过中立所属判断覆盖
    //     o = GetOwningPlayer(u);
    //     if (o == Player(PLAYER_NEUTRAL_AGGRESSIVE)) return true; // 中立敌对
    //     if (o == Player(PLAYER_NEUTRAL_PASSIVE))    return true; // 中立中立
    //     return false;
    // }
}
//! endzinc
/*
japi引用的常量库 由于wave宏定义 只对以下的代码有效
请将常量库里所有内容复制到  自定义脚本代码区
*/
//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
//-----------模拟聊天------------------
//---------技能数据类型---------------
//冷却时间
//目标允许
//施放时间
//持续时间
//持续时间
//魔法消耗
//施放间隔
//影响区域
//施法距离
//数据A
//数据B
//数据C
//数据D
//数据E
//数据F
//数据G
//数据H
//数据I
//单位类型
//热键
//关闭热键
//学习热键
//名字
//图标
//目标效果
//施法者效果
//目标点效果
//区域效果
//投射物
//特殊效果
//闪电效果
//buff提示
//buff提示
//学习提示
//提示
//关闭提示
//学习提示
//提示
//关闭提示
//----------物品数据类型----------------------
//物品图标
//物品提示
//物品扩展提示
//物品名字
//物品说明
//------------单位数据类型--------------
//攻击1 伤害骰子数量
//攻击1 伤害骰子面数
//攻击1 基础伤害
//攻击1 升级奖励
//攻击1 最小伤害
//攻击1 最大伤害
//攻击1 全伤害范围
//装甲
// attack 1 attribute adds
//攻击1 伤害衰减参数
//攻击1 武器声音
//攻击1 攻击类型
//攻击1 最大目标数
//攻击1 攻击间隔
//攻击1 攻击延迟/summary>
//攻击1 弹射弧度
//攻击1 攻击范围缓冲
//攻击1 目标允许
//攻击1 溅出区域
//攻击1 溅出半径
//攻击1 武器类型
// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
//攻击2 伤害骰子面数
//攻击2 基础伤害
//攻击2 升级奖励
//攻击2 伤害衰减参数
//攻击2 武器声音
//攻击2 攻击类型
//攻击2 最大目标数
//攻击2 攻击间隔
//攻击2 攻击延迟
//攻击2 攻击范围
//攻击2 攻击缓冲
//攻击2 最小伤害
//攻击2 最大伤害
//攻击2 弹射弧度
//攻击2 目标允许类型
//攻击2 溅出区域
//攻击2 溅出半径
//攻击2 武器类型
//装甲类型
//! zinc
/*
单位有关的增强功能
*/
library UnitUtils {
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
    //获取单位的攻击力/防御/生命/魔法值
    public function GetUnitAttack(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(0x12)));
    }
    public function GetUnitDefense(unit u) -> integer {
        return R2I(GetUnitState(u,ConvertUnitState(0x20)));
    }
    public function GetUnitHP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_LIFE);
    }
    public function GetUnitMP(unit u) -> real {
        return GetUnitState(u,UNIT_STATE_MAX_MANA);
    }
    //设置攻击力
    public function SetUnitAttack(unit u, real attack) -> nothing {
        SetUnitState(u,ConvertUnitState(0x12),attack);
    }
    //增加攻击力
    public function AddUnitAttack(unit u, real attack) -> nothing {
        SetUnitAttack(u,GetUnitAttack(u) + attack);
    }
    //设置防御
    public function SetUnitDefense(unit u, real defense) -> nothing {
        SetUnitState(u,ConvertUnitState(0x20),defense);
    }
    //增加防御
    public function AddUnitDefense(unit u, real defense) -> nothing {
        SetUnitDefense(u,GetUnitDefense(u)+defense);
    }
    //修改生命最大值
    public function SetUnitHP(unit u, real hp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_LIFE,RMaxBJ(hp,2.0));
    }
    //增加生命最大值
    public function AddUnitHP(unit u,real hp ) {
        SetUnitHP(u,RMaxBJ(GetUnitHP(u)+hp,10.0));
        if (hp > 0) {SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+hp));}
    }
    //回血(定值)
    public function RegenUnitHP(unit u, real volume) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+volume));
    }
    //回蓝(百分比)
    public function RegenUnitHPPercent(unit u, real rate) -> nothing {
        SetUnitState(u, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState(u,UNIT_STATE_LIFE)+GetUnitHP(u)*rate));
    }
    //设置魔法最大值
    public function SetUnitMP(unit u, real mp) -> nothing {
        SetUnitState(u,UNIT_STATE_MAX_MANA,mp);
    }
    //增加魔法最大值
    public function AddUnitMP(unit u,real mp ) {
        SetUnitMP(u,GetUnitMP(u)+mp);
        if (mp > 0) {SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+mp));}
    }
    //回蓝(定值)
    public function RegenUnitMP(unit u, real volume) -> nothing {
        SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+volume));
    }
    //回蓝(百分比)
    public function RegenUnitMPPercent(unit u, real rate) -> nothing {
        SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState(u,UNIT_STATE_MANA)+GetUnitMP(u)*rate));
    }
    // 获取移速
    public function GetUnitSpeed (unit u) -> integer {
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560)) { //突破522与0的移速的Hook
return LoadInteger(HASH_UNIT,GetHandleId(u),237960560);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(HASH_UNIT,GetHandleId(u),237960560)) { //突破522与0的移速的Hook
value = LoadInteger(HASH_UNIT,GetHandleId(u),237960560);
            value += speed;
            SaveInteger(HASH_UNIT,GetHandleId(u),237960560,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }
    // 初始化突破移速
    public function InitUnitSpeed (unit u) {
        SaveInteger(HASH_UNIT,GetHandleId(u),237960560,R2I(GetUnitMoveSpeed(u)));
    }
    //射程(还会+警戒范围)
    public function GetUnitAttackRange(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x16));
    }
    //设置射程(还会设置警戒范围)
    public function SetUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(0x16),range);
		SetUnitAcquireRange(u,RMaxBJ(range,900.0));
    }
    //增加射程(还会+警戒范围)
	public function AddUnitAttackRange (unit u,real range) {
		SetUnitState(u,ConvertUnitState(0x16),GetUnitAttackRange(u) + range);
		SetUnitAcquireRange(u,RMaxBJ(GetUnitAcquireRange(u)+range,900.0));
    }
    // 获取攻速
    public function GetUnitAttackSpeed(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x51));
    }
    // 增加攻速
	public function AddUnitAttackSpeed (unit u,real speed) {
		SetUnitState(u,ConvertUnitState(0x51),GetUnitState(u,ConvertUnitState(0x51)) + speed);
	}
    // (获取缓存的攻击间隔(可能为负))
    public function GetUnitAttackIntervalCache(unit u) -> real {
        return LoadReal(HASH_UNIT,GetHandleId(u),255610124);
    }
    // (获取单位的攻击间隔,不会小于0.1)
    public function GetUnitAttackInterval(unit u) -> real {
        return GetUnitState(u,ConvertUnitState(0x25));
    }
    // 攻击间隔(虽然写着加,但是实际是减) - 带最小值与观察者
	public function AddAttackInterval (unit u,real value) {
        real cacheValue; real newValue; integer uid;
        uid = GetHandleId(u);
        // 检查是否已初始化缓存
        if (!HaveSavedReal(HASH_UNIT, uid, 255610124)) {
            // 如果没有初始化，先保存当前攻击间隔到缓存
            SaveReal(HASH_UNIT, uid, 255610124, GetUnitAttackInterval(u));
        }
        // 获取当前缓存值并添加新值
        cacheValue = LoadReal(HASH_UNIT, uid, 255610124);
        cacheValue += value;
        // 更新缓存
        SaveReal(HASH_UNIT, uid, 255610124, cacheValue);
        // 设置实际攻击间隔（确保不小于MIN_ATTACK_INTERVAL）
        newValue = RMaxBJ(cacheValue, 0.2);
        SetUnitState(u, ConvertUnitState(0x25), newValue);
        // 观察者模式回调
        if (unitAttrObserver.attackIntervalCB != null) {
            unitAttrObserver.argsU = u;
            TriggerEvaluate(unitAttrObserver.attackIntervalCB);
        }
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
//! zinc
//==================================
// 日志打印系统
// version: 1.0
// author: 系统自动生成
// date: 2024/3/21
//
// 功能：提供五个日志级别输出
// - TRACE(灰)：追踪调试用
// - DEBUG(绿)：调试信息用
// - INFO(白)：普通信息用
// - WARN(黄)：警告信息用
// - ERROR(红)：错误信息用
//
// 示例：
// call Info("普通信息")
// call Error(Player(0), "玩家1的错误")
//==================================
library Logger requires YDLua {
    public integer logger_level = 0;
    public string logger_msg = null;
    public player logger_p = null;
    public trigger logger_tr = null;
    // 追踪级别日志(灰色),用于程序执行追踪
    public function Trace(string msg) {
        logger_msg = msg;
        logger_level = 0;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 调试级别日志(绿色),用于输出变量值等调试信息
    public function Debug(string msg) {
        logger_msg = msg;
        logger_level = 1;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 信息级别日志(白色),用于输出普通提示信息
    public function Info(string msg) {
        logger_msg = msg;
        logger_level = 2;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 警告级别日志(黄色),用于输出警告信息
    public function Warn(string msg) {
        logger_msg = msg;
        logger_level = 3;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 错误级别日志(红色),用于输出错误信息
    public function Error(string msg) {
        logger_msg = msg;
        logger_level = 4;
        logger_p = GetLocalPlayer();
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出追踪日志(灰色)
    public function TraceToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 0;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出调试日志(绿色)
    public function DebugToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 1;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出信息日志(白色)
    public function InfoToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 2;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出警告日志(黄色)
    public function WarnToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 3;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    // 向指定玩家输出错误日志(红色)
    public function ErrorToPlayer(player p, string msg) {
        logger_msg = msg;
        logger_level = 4;
        logger_p = p;
		TriggerEvaluate(logger_tr);
    }
    function onInit() {
        Cheat("exec-lua:depends.debug.logger"); //日志打印系统初始化
}
}
//! endzinc
/*
UI哈希表定义
*/
// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
//! zinc
/*
结构体
硬件事件(按/滑/帧事件)
*/
library Hardware requires BzAPI {
	public struct hardware []{
		// 注册一个左键抬起事件
		static method regLeftUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,1,0,false,func);
		}
		// 注册一个左键按下事件
		static method regLeftDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,1,1,false,func);
		}
		// 注册一个右键按下事件
		static method regRightDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,2,1,false,func);
		}
		// 注册一个右键抬起事件
		static method regRightUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,2,0,false,func);
		}
		// 注册一个滚轮事件,不能异步注册
		static method regWheelEvent (code func) {
			if (trWheel == null) {trWheel = CreateTrigger();}
			TriggerAddCondition(trWheel, Condition(func));
		}
		// 注册一个绘制事件,不能异步注册
		static method regUpdateEvent (code func) {
			if (trUpdate == null) {trUpdate = CreateTrigger();}
			TriggerAddCondition(trUpdate, Condition(func));
		}
		// 注册一个窗口变化事件,不能异步注册
		static method regResizeEvent (code func) {
			if (trResize == null) {trResize = CreateTrigger();}
			TriggerAddCondition(trResize, Condition(func));
		}
		// 注册一个鼠标移动事件,不能异步注册
		static method regMoveEvent (code func) {
			BJDebugMsg("注册鼠标移动事件");
			if (trMove == null) {trMove = CreateTrigger();}
			TriggerAddCondition(trMove, Condition(func));
		}
		// 获取鼠标的实数坐标X(0-0.8)
		static method getMouseX () -> real {
			integer width = DzGetClientWidth();
			if (width > 0) return DzGetMouseXRelative()* 0.8 / width;
			else return 0.1;
		}
		// 获取鼠标的实数坐标Y(0-0.6)
		static method getMouseY () -> real {
			integer height = DzGetClientHeight();
			if (height > 0) return 0.6 - DzGetMouseYRelative()* 0.6 / height;
			else return 0.1; // 防止除以0
}
		private {
			static trigger trWheel = null;
			static trigger trUpdate = null;
			static trigger trResize = null;
			static trigger trMove = null;
		}
		static method onInit () {
			//在游戏开始0.0秒后再调用
			trigger tr = CreateTrigger();
			TriggerRegisterTimerEvent(tr, 0.0, false);
			TriggerAddCondition(tr,Condition(function (){
				// 滚轮事件
				DzTriggerRegisterMouseWheelEventByCode(null,false,function (){
					TriggerEvaluate(trWheel);
				});
				// 帧绘制事件
				DzFrameSetUpdateCallbackByCode(function (){
					TriggerEvaluate(trUpdate);
				});
				// 窗口大小变化事件
				DzTriggerRegisterWindowResizeEventByCode(null, false, function (){
				 TriggerEvaluate(trResize);
				});
				// 鼠标移动事件
				DzTriggerRegisterMouseMoveEventByCode(null, false, function (){
				 TriggerEvaluate(trMove);
				});
				DestroyTrigger(GetTriggeringTrigger());
			}));
			tr = null;
		}
	}
}
//! endzinc
//! zinc
/*
原生Lua引擎非内置
*/
// https://create.reckfeng.com/kkapidoc/#/menu_kkapi_japi kkapi的japi文档
library YDLua {
    // main 函数就初始化的
    public function initializeLua () -> integer {
        Cheat("exec-lua:plugin_main");
        return 0;
    }
    function onInit () {
        //在游戏开始0.0秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEvent(tr, 0.0, false);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("调用了YDLua引擎");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}
//! endzinc
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
    //获取圆形随机单位
    public function GetRandomEnemy (player p,real x,real y,real radius) -> unit {
        return GroupPickRandomUnit(GetEnemyGroup(p,x,y,radius));
    }
    //复制单位组
    //复制g1进新组并返回
    public function CopyGroup (group g1) -> group {
        tempG = CreateGroup();
        GroupAddGroup(g1, tempG);
        return tempG;
    }
}
//! endzinc
/*
japi引用的常量库 由于wave宏定义 只对以下的代码有效
请将常量库里所有内容复制到  自定义脚本代码区
*/
//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
//-----------模拟聊天------------------
//---------技能数据类型---------------
//----------物品数据类型----------------------
//物品图标
//物品提示
//物品扩展提示
//物品名字
//物品说明
//------------单位数据类型--------------
//攻击1 伤害骰子数量
//攻击1 伤害骰子面数
//攻击1 基础伤害
//攻击1 升级奖励
//攻击1 最小伤害
//攻击1 最大伤害
//攻击1 全伤害范围
//装甲
// attack 1 attribute adds
//攻击1 伤害衰减参数
//攻击1 武器声音
//攻击1 攻击类型
//攻击1 最大目标数
//攻击1 攻击间隔
//攻击1 攻击延迟/summary>
//攻击1 弹射弧度
//攻击1 攻击范围缓冲
//攻击1 目标允许
//攻击1 溅出区域
//攻击1 溅出半径
//攻击1 武器类型
// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
//攻击2 伤害骰子面数
//攻击2 基础伤害
//攻击2 升级奖励
//攻击2 伤害衰减参数
//攻击2 武器声音
//攻击2 攻击类型
//攻击2 最大目标数
//攻击2 攻击间隔
//攻击2 攻击延迟
//攻击2 攻击范围
//攻击2 攻击缓冲
//攻击2 最小伤害
//攻击2 最大伤害
//攻击2 弹射弧度
//攻击2 目标允许类型
//攻击2 溅出区域
//攻击2 溅出半径
//攻击2 武器类型
//装甲类型
//! zinc
/*
伤害工具
*/
library DamageUtils requires UnitFilter,GroupUtils {
    // --------------------
    // Lifesteal aggregation for single-hit (no new structs; lightweight stack)
    // --------------------
    private integer lsTop = -1;
    private unit lsSource[];
    private real lsTotal[];
    public function LS_begin(unit src) {
        lsTop += 1;
        lsSource[lsTop] = src;
        lsTotal[lsTop] = 0.0;
    }
    public function LS_end() -> real {
        real dealt;
        if (lsTop < 0) {
            return 0.0;
        }
        dealt = lsTotal[lsTop];
        lsSource[lsTop] = null;
        lsTotal[lsTop] = 0.0;
        lsTop -= 1;
        return dealt;
    }
    public function LS_isActive(unit src) -> boolean {
        if (lsTop < 0) return false;
        return lsSource[lsTop] == src;
    }
    public function LS_add(real amount) {
        if (lsTop < 0) return;
        if (amount > 0.0) {
            lsTotal[lsTop] = lsTotal[lsTop] + amount;
        }
    }
    //旧名替换:DamageSingle
    //单体伤害:物理
    public function ApplyPhysicalDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();
            //触发回调
            uArgs = u; //回调参数
rArgs = dealt; //回调参数
TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
        }
    }
    //单体伤害:魔法
    public function ApplyMagicDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();
            //触发回调
            uArgs = u; //回调参数
rArgs = dealt; //回调参数
TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
        }
    }
    //单体伤害:真实
    public function ApplyPureDamage (unit u,unit target,real dmg) {
        real dealt;
        // 检查是否需要吸血聚合
        if (TrLifeSteal != null) {
            LS_begin(u);
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
            dealt = LS_end();
            //触发回调
            uArgs = u; //回调参数
rArgs = dealt; //回调参数
TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        } else {
            UnitDamageTarget( u, target, dmg, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
        }
    }
    //模拟普攻(最后一个参数代表额外的终伤,0)
    public function SimulateBasicAttack (unit u,unit target,real fd) {
        UnitDamageTarget( u, target, GetUnitState(u,ConvertUnitState(0x12))*(1.0+fd), true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS );
    }
    // 伤害参数结构体
    public struct DmgP {
        unit source;
        string eft;
        real damage;
        // Lifesteal aggregation control (skill lifesteal only when enabled on AoE)
        boolean enableLifestealAggregation;
        real lifestealDealtTotal;
        // 正确使用 onDestroy，而不是 destroy
        method onDestroy() {
            this.source = null;
            // this.eft = null; // 可选
        }
    }
    // 伤害参数栈
    public struct DmgS [] {
        private static DmgP stack [];
        private static integer top = -1;
        static method push(DmgP params) {
            if (thistype.top >= 8190) {
                // 调试期提示或直接 return，避免越界
                BJDebugMsg("DmgS overflow");
                return;
            }
            thistype.top += 1;
            thistype.stack[thistype.top] = params;
        }
        static method pop() -> DmgP {
            DmgP params = thistype.stack[thistype.top];
            if (thistype.top < 0) {
                BJDebugMsg("DmgS underflow");
                return 0;
            }
            thistype.stack[thistype.top] = 0;
            thistype.top -= 1;
            return params;
        }
        static method current() -> DmgP {
            return thistype.stack[thistype.top];
        }
        // 是否存在可用的上下文，且开启了技能吸血聚合，并且来源匹配
        static method hasAggregation(unit src) -> boolean {
            DmgP p;
            if (thistype.top < 0) return false;
            p = thistype.stack[thistype.top];
            return p.enableLifestealAggregation && p.source == src;
        }
        // 聚合一次最终造成的伤害（由 DamageSystem 在事件最终阶段调用）
        static method aggregate(real amount) {
            DmgP p;
            if (thistype.top < 0) return;
            p = thistype.stack[thistype.top];
            if (p.enableLifestealAggregation && amount > 0) {
                p.lifestealDealtTotal += amount;
                thistype.stack[thistype.top] = p; // 写回（结构体为值语义）
}
        }
    }
    // 范围普通伤害
    public function DamageAreaPhysical (unit u, real x, real y, real radius, real damage, string efx) {
        group g; real dealt; DmgP params;
        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;
        DmgS.push(params);
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(), GetOwningPlayer(current.source))) {
                ApplyPhysicalDamage(current.source, GetFilterUnit(), current.damage);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));
        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }
    //范围魔法伤害
    public function DamageAreaMagic (unit u,real x,real y,real radius,real damage,string efx) {
        group g; real dealt; DmgP params;
        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;
        DmgS.push(params);
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                ApplyMagicDamage(current.source,GetFilterUnit(),current.damage);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));
        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }
    //范围真实伤害
    public function DamageAreaPure (unit u,real x,real y,real radius,real damage,string efx) {
        group g; real dealt; DmgP params;
        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.damage = damage;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;
        DmgS.push(params);
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                ApplyPureDamage(current.source,GetFilterUnit(),current.damage);
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));
        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }
    //范围秒杀
    public function DamageAreaKill (unit u,real x,real y,real radius,string efx) {
        group g; real dealt; DmgP params;
        g = CreateGroup();
        params = DmgP.create();
        params.source = u;
        params.eft = efx;
        params.enableLifestealAggregation = (TrLifeSteal != null);
        params.lifestealDealtTotal = 0.0;
        DmgS.push(params);
        GroupEnumUnitsInRangeEx(g, x, y, radius, Filter(function () -> boolean {
            DmgP current = DmgS.current();
            if (IsEnemy(GetFilterUnit(),GetOwningPlayer(current.source))) {
                UnitDamageTarget( current.source, GetFilterUnit(), GetUnitState(GetFilterUnit(),UNIT_STATE_MAX_LIFE)*1.2, false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS );
                if (current.eft != null) {
                    DestroyEffect(AddSpecialEffect(current.eft, GetUnitX(GetFilterUnit()),GetUnitY(GetFilterUnit())));
                }
                return true;
            }
            return false;
        }));
        params = DmgS.pop();
        dealt = params.lifestealDealtTotal;
        params.destroy();
        DestroyGroup(g);
        g = null;
        // 如果有吸血回调且造成了伤害，触发回调
        if (TrLifeSteal != null && dealt > 0.0) {
            uArgs = u;
            rArgs = dealt;
            TriggerEvaluate(TrLifeSteal);
            uArgs = null;
            rArgs = 0.;
        }
    }
    private trigger TrLifeSteal = null; //回调触发器
private unit uArgs = null; //回调参数
private real rArgs = 0.; //回调参数
    //注册
    public function RegisterDamageLifeSteal(code func) {
        if (TrLifeSteal == null) {
            TrLifeSteal = CreateTrigger();
        }
        TriggerAddCondition(TrLifeSteal, Condition(func));
    }
    //吸血的单位
    public function GetDamageLifeStealUnit () -> unit { return uArgs;}
    //吸血的数值
    public function GetDamageLifeStealReal () -> real { return rArgs;}
}
//! endzinc
library BzAPI
    //hardware
    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    //plus
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzGetLocale takes nothing returns string
    native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
    //sync
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    //native DzGetPushContext takes nothing returns string
    native DzSyncDataImmediately takes string prefix, string data returns nothing 
    //gui
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
    native DzFrameSetPriority takes integer frame, integer priority returns nothing
    native DzFrameSetParent takes integer frame, integer parent returns nothing
    native DzFrameGetHeight takes integer frame returns real
    native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
    native DzFrameGetParent takes integer frame returns integer
    native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
    native DzFrameGetName takes integer frame returns string
    native DzGetClientWidth takes nothing returns integer
    native DzGetClientHeight takes nothing returns integer
    native DzFrameIsVisible takes integer frame returns boolean
        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）
    native DzFrameAddText takes integer frame, string text returns nothing
    // 沉默单位-禁用技能
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    // 禁用攻击
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    // 禁用道具
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    // 刷新小地图
    native DzUpdateMinimap takes nothing returns nothing
    // 修改单位alpha
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    // 设置单位是否可以选中
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    // 修改单位是否可以被设置为目标
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    // 保存内存数据
    native DzSaveMemoryCache takes string cache returns nothing
    // 读取内存数据
    native DzGetMemoryCache takes nothing returns string
    // 设置加速倍率
    native DzSetSpeed takes real ratio returns nothing
    // 转换世界坐标为屏幕坐标-异步
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    // 转换世界坐标为屏幕坐标-获取转换后的X坐标
    native DzGetConvertWorldPositionX takes nothing returns real
    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标
    native DzGetConvertWorldPositionY takes nothing returns real
    // 创建command button
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
    function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterKeyEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseMoveEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseWheelEvent(trg, true, null)
    endfunction
    function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterWindowResizeEvent(trg, true, null)
    endfunction
    function DzF2I takes integer i returns integer
        return i
    endfunction
    function DzI2F takes integer i returns integer
        return i
    endfunction
    function DzK2I takes integer i returns integer
        return i
    endfunction
    function DzI2K takes integer i returns integer
        return i
    endfunction
    function DzTriggerRegisterMallItemSyncData takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIA", true)
    endfunction
    //玩家消耗/使用商城道具事件
    function DzTriggerRegisterMallItemConsumeEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIC", true)
    endfunction
    //玩家删除商城道具事件
    function DzTriggerRegisterMallItemRemoveEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMID", true)
    endfunction
    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction
    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction
    
endlibrary
/*
单位哈希表定义
*/
// 怪物掉落相关键值 (预留20个空间 1800-1819)
// 怪物掉落概率相关键值 (预留20个空间 1820-1839)
// 怪物掉落数量键值
// 单位技能相关键值 (预留200个空间 1800-1999)
// 2400开始可继续添加新的键值定义...
//! zinc
/*
单位哈希表
*/
library UnitHashTable {
    public hashtable HASH_UNIT = InitHashtable(); // 单位哈希表
}
//! endzinc
/*
单元测试框架(注入)
*/
//! zinc
library UnitTestFramwork {
	//单元测试总
	trigger TUnitTest = null;
    private hashtable HASH_UNITTEST = InitHashtable(); // 单元测试哈希表
    //断言
    public struct assert []{
        //断言布尔值
        static method Boolean (boolean condition,string name) {
            if (!condition) {
                BJDebugMsg("FAIL: " + name);
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言字符串相等
        static method String(string actual, string expected, string name) {
            if (actual != expected) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + expected);
                BJDebugMsg("  Actual: " + actual);
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言整数相等
        static method Integer(integer actual, integer expected, string name) {
            if (actual != expected) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + I2S(expected));
                BJDebugMsg("  Actual: " + I2S(actual));
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
        //断言浮点数相等
        static method Real(real actual, real expected, string name) {
            real maxValue = RMaxBJ(RAbsBJ(actual), RAbsBJ(expected)); // 取两个数的绝对值的较大值
real epsilon = maxValue * 0.00001; // 相对误差为数值大小的万分之一
// 处理接近0的特殊情况
if (maxValue < 0.00001) {
                epsilon = 0.00001;
            }
            if (RAbsBJ(actual - expected) > epsilon) {
                BJDebugMsg("FAIL: " + name);
                BJDebugMsg("  Expected: " + R2SW(expected,0,1));
                BJDebugMsg("  Actual: " + R2SW(actual,0,1));
            } else {
                BJDebugMsg("PASS: " + name);
            }
        }
    }
    //注册单元测试事件(聊天内容),自动注入
    public function UnitTestRegisterChatEvent (code func) {
        TriggerAddAction(TUnitTest, func);
    }
    //指定开始时间与持续时间的定时器
    public function UnitTestAutoTimer (real time, real duration,code start, code end) {
        trigger t = CreateTrigger();
        trigger tr = CreateTrigger();
        TriggerAddCondition(t, Condition(start));
        TriggerRegisterTimerEvent(tr, time, false);
        SaveReal(HASH_UNITTEST,GetHandleId(tr),1,time);
        SaveReal(HASH_UNITTEST,GetHandleId(tr),2,duration);
        SaveTriggerHandle(HASH_UNITTEST,GetHandleId(tr),3,t);
        TriggerAddCondition(tr,Condition(function (){
            real time = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1);
            real d = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2);
            trigger tr = LoadTriggerHandle(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3);
            BJDebugMsg("-----[单测 " + R2SW(time,0,1) + " - " + R2SW(time+d,0,1) + " 秒]开始------");
            TriggerEvaluate(tr);
            DestroyTrigger(tr);
            FlushChildHashtable(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()));
            DestroyTrigger(GetTriggeringTrigger());
            tr = null;
        }));
        if (end != null) {
            t = CreateTrigger();
            tr = CreateTrigger();
            TriggerAddCondition(t, Condition(end));
            TriggerRegisterTimerEvent(tr, time+duration, false);
            SaveReal(HASH_UNITTEST,GetHandleId(tr),1,time);
            SaveReal(HASH_UNITTEST,GetHandleId(tr),2,duration);
            SaveTriggerHandle(HASH_UNITTEST,GetHandleId(tr),3,t);
            TriggerAddCondition(tr,Condition(function (){
                real time = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1);
                real d = LoadReal(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2);
                trigger tr = LoadTriggerHandle(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3);
                TriggerEvaluate(tr);
                BJDebugMsg("-----[单测 " + R2SW(time,0,1) + " - " + R2SW(time+d,0,1) + " 秒]结束------");
                DestroyTrigger(tr);
                FlushChildHashtable(HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()));
                DestroyTrigger(GetTriggeringTrigger());
                tr = null;
            }));
        }
        tr = null;
        t = null;
    }
    function onInit () {
        //在游戏开始0.1秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEvent(tr, 0.1, false);
        TriggerAddCondition(tr,Condition(function (){
            integer i;
            for (1 <= i <= 12) {
				SetPlayerName(ConvertedPlayer(i),"测试员" + I2S(i)+ "号");
                CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, bj_mapInitialPlayableArea ); //迷雾全关
}
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
		TUnitTest = CreateTrigger();
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(0), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(1), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(2), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(3), "", false );
    }
}
//! endzinc
//! zinc
/*
鼠标滚轮控制视距
一键切换宽屏模式
made by 裂魂
2018/10/19
*/
library CameraControl requires Hardware{
    integer ViewLevel = 8; //初始视野等级
boolean ResetCam = false; //开启重置镜头属性标识
real WheelSpeed = 0.1; //镜头变化平滑度
boolean WideScr = false; //是否是宽屏
real X_ANGLE = 304; //默认X轴角度
boolean HeightLocked = false; //镜头高度是否锁定
    public struct cameraControl {
        // 打开滚轮控制镜头高度
        public static method openWheel () {DoNothing();}
        // 锁定镜头高度
        public static method lockHeight () { HeightLocked = true; }
        // 解锁镜头高度
        public static method unlockHeight () { HeightLocked = false; }
        // 查询是否锁定
        public static method isHeightLocked () ->boolean { return HeightLocked; }
        // 初始化镜头（仅对指定玩家生效）
        public static method initCamera (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }
            ResetCam = true;
            ViewLevel = ViewLevel + 5; // 增加1000高度（1000/200=5）
SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
            X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
        }
        // 增加镜头高度400（仅对指定玩家生效）
        public static method increaseHeight (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }
            ResetCam = true;
            if (ViewLevel < 16) { // 确保不超过上限（3600-400=3200，3200/200=16）
ViewLevel = ViewLevel + 2; // 增加400高度（400/200=2）
SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
                X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
            }
        }
        // 减少镜头高度400（仅对指定玩家生效）
        public static method decreaseHeight (player p) {
            if (GetLocalPlayer() != p) {
                return;
            }
            ResetCam = true;
            if (ViewLevel > 5) { // 确保不低于下限（600+400=1000，1000/200=5）
ViewLevel = ViewLevel - 2; // 减少400高度（400/200=2）
SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
                X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK));
            }
        }
    }
    // 滚轮控制镜头
    // 初始化就调用
    function onInit () {
        //注册滚轮事件
        hardware.regWheelEvent(function (){
            integer delta = DzGetWheelDelta(); //滚轮变化量
// 鼠标不在游戏内或焦点在UI控件上则不处理
if ((!DzIsMouseOverUI()) || DzGetMouseFocus() != 0) {return;}
            ResetCam = true; //标记需要重置镜头属性
if (!HeightLocked) {
                // 使用 600 ~ 3600 的高度范围（步长 200）
                if (delta < 0) { //滚轮下滑 -> 拉远
if (ViewLevel < 18) {ViewLevel = ViewLevel + 1;} //上限 3600/200=18
} else { //滚轮上滑 -> 拉近
if (ViewLevel > 3) {ViewLevel = ViewLevel - 1;} //下限 600/200=3
}
            } else {
                // 锁定时维持当前高度
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, 0.1);
            }
            X_ANGLE = Rad2Deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)); //记录滚动前的镜头角度
});
        //注册每帧渲染事件
        hardware.regUpdateEvent(function (){
            if (ResetCam) {//重设镜头角度和高度
                SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, X_ANGLE, 0 );
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, ViewLevel*200, WheelSpeed);
                ResetCam = false;
            }
        });
        //注册按下键码为145的按键(ScrollLock)事件
        DzTriggerRegisterKeyEventByCode( null, 145, 1, false, function (){
            WideScr = !WideScr;
            DzEnableWideScreen(WideScr);
        });
    }
}
//! endzinc
//===========================================================================
//
// - |cff00ff00单元测试地图|r -
//
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Sun Nov 27 05:00:30 2022
//   Map Author: Crainax
//
//===========================================================================
//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************
globals
    // Generated
    rect gg_rct_Wave1 = null
    rect gg_rct_Wave2 = null
    rect gg_rct_Wave3 = null
    rect gg_rct_Wave4 = null
    rect gg_rct_Base = null
    rect gg_rct_BaseBack = null
    rect gg_rct_Home1 = null
    rect gg_rct_Home2 = null
    rect gg_rct_Home3 = null
    rect gg_rct_Home4 = null
    rect gg_rct_Fuben1 = null
    rect gg_rct_Fuben2 = null
    rect gg_rct_Fuben3 = null
    rect gg_rct_Fuben4 = null
    rect gg_rct_Fuben5 = null
    rect gg_rct_Fuben6 = null
    rect gg_rct_Fuben7 = null
    rect gg_rct_Fuben8 = null
    trigger gg_trg_______u = null
    unit gg_unit_hcas_0011 = null
endglobals
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer8 takes nothing returns nothing
    local player p = Player(8)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_hcas_0011 = CreateUnit( p, 'hcas', -64.0, -1984.0, 270.000 )
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer8( )
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings( )
    call CreatePlayerUnits( )
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_Wave1 = Rect( -5088.0, 3168.0, -4448.0, 3968.0 )
    set gg_rct_Wave2 = Rect( -1568.0, 3360.0, -928.0, 4160.0 )
    set gg_rct_Wave3 = Rect( 1312.0, 3584.0, 1952.0, 4384.0 )
    set gg_rct_Wave4 = Rect( 4320.0, 3232.0, 4960.0, 4032.0 )
    set gg_rct_Base = Rect( -320.0, -2304.0, 192.0, -1664.0 )
    set gg_rct_BaseBack = Rect( -320.0, -3328.0, 160.0, -2848.0 )
    set gg_rct_Home1 = Rect( -10496.0, 1440.0, -8128.0, 3776.0 )
    set gg_rct_Home2 = Rect( 7712.0, 1568.0, 10080.0, 3904.0 )
    set gg_rct_Home3 = Rect( -10464.0, -3680.0, -8096.0, -1344.0 )
    set gg_rct_Home4 = Rect( 7712.0, -3552.0, 10080.0, -1216.0 )
    set gg_rct_Fuben1 = Rect( -11872.0, 7968.0, -8224.0, 11584.0 )
    set gg_rct_Fuben2 = Rect( -5472.0, 8000.0, -1824.0, 11616.0 )
    set gg_rct_Fuben3 = Rect( 1184.0, 8000.0, 4832.0, 11616.0 )
    set gg_rct_Fuben4 = Rect( 7712.0, 7968.0, 11360.0, 11584.0 )
    set gg_rct_Fuben5 = Rect( -11872.0, -11328.0, -8224.0, -7712.0 )
    set gg_rct_Fuben6 = Rect( -5472.0, -11328.0, -1824.0, -7712.0 )
    set gg_rct_Fuben7 = Rect( 1184.0, -11328.0, 4832.0, -7712.0 )
    set gg_rct_Fuben8 = Rect( 7712.0, -11328.0, 11360.0, -7712.0 )
endfunction
//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//TESH.scrollpos=0
//TESH.alwaysfold=0
// 当前构建版本
// 当前的平台分包
// 原生UI的大小
//地图的最低攻击间隔(非特殊情况)
//冲刺最大槽位数
    // 单元测试
    // lua_print: 单元测试
//这两条是用到YDWE函数就要导入的,没用到就不用导入
//函数入口
// 用原始地图测试
// 用空地图测试
//! zinc
/*
DamageUtils测试库
测试命令:
s1 - 测试物理伤害
s2 - 测试真实伤害
s3 - 测试模拟普攻
s4 - 测试范围物理伤害
s5 - 测试范围真实伤害
s6 - 切换伤害数值显示
s7 - 切换伤害反弹测试
参数命令:
-d [数值] - 设置伤害值
-r [数值] - 设置范围值
-e [特效路径] - 设置特效
*/
library UTDamageUtils requires DamageUtils {
	private unit testDummy = null; // 测试用假人
private unit testSource = null; // 测试用伤害源
private real testDamage = 100.0; // 测试用伤害值
private real testRadius = 300.0; // 测试用范围值
private string testEffect = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl"; // 测试用特效
private trigger damageEventTrigger = null;
	private boolean isShowDamage = false;
	private boolean isReflectDamage = false; // 反伤开关
private integer reflectCount = 0; // 反伤计数器
	// 创建测试环境
	function CreateTestEnv(player p) {
		real x = GetPlayerStartLocationX(p);
		real y = GetPlayerStartLocationY(p);
		real angle;
		integer i;
		group g = CreateGroup();
		unit dummy;
		// 清理所有已存在的测试单位
		GroupEnumUnitsInRange(g, x, y, 1000, null);
		ForGroup(g, function() {
			unit u = GetEnumUnit();
			if(GetUnitTypeId(u) == 'opeo' || GetUnitTypeId(u) == 'hpea') {
				RemoveUnit(u);
			}
			u = null;
		});
		DestroyGroup(g);
		g = null;
		testDummy = null;
		testSource = null;
		// 创建中心苦工单位
		testDummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo', x + 200, y, 270);
		SetUnitInvulnerable(testDummy, false);
		SetUnitState(testDummy, UNIT_STATE_LIFE, GetUnitState(testDummy, UNIT_STATE_MAX_LIFE));
		// 注册伤害事件
		TriggerRegisterUnitEvent(damageEventTrigger, testDummy, EVENT_UNIT_DAMAGED);
		// 创建环形分布的额外苦工
		for(0 <= i < 8) {
			angle = i * 45.0 * 0.0174538;
			dummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'opeo',
			x + 200 + testRadius * Cos(angle),
			y + testRadius * Sin(angle),
			270);
			// 为每个苦工注册伤害事件
			TriggerRegisterUnitEvent(damageEventTrigger, dummy, EVENT_UNIT_DAMAGED);
		}
		// 创建伤害源(农民)
		testSource = CreateUnit(p, 'hpea', x, y, 90);
		SetUnitAttack(testSource, 50);
		// 为农民也注册伤害事件
		TriggerRegisterUnitEvent(damageEventTrigger, testSource, EVENT_UNIT_DAMAGED);
	}
	// 测试物理伤害
	function TTestUTDamageUtils1(player p) {
		CreateTestEnv(p);
		Trace("测试物理伤害: " + R2S(testDamage));
		ApplyPhysicalDamage(testSource, testDummy, testDamage);
	}
	// 测试真实伤害
	function TTestUTDamageUtils2(player p) {
		CreateTestEnv(p);
		Trace("测试真实伤害: " + R2S(testDamage));
		ApplyPureDamage(testSource, testDummy, testDamage);
	}
	// 测试模拟普攻
	function TTestUTDamageUtils3(player p) {
		CreateTestEnv(p);
		Trace("测试模拟普攻，基础攻击: 50");
		SimulateBasicAttack(testSource, testDummy, 0);
	}
	// 测试范围物理伤害
	function TTestUTDamageUtils4(player p) {
		CreateTestEnv(p);
		Trace("测试范围物理伤害: " + R2S(testDamage) + " 范围: " + R2S(testRadius));
		Trace("中心点有1个假人，半径 " + R2S(testRadius) + " 处有8个假人");
		Trace("范围内的假人都会受到伤害和特效");
		DamageAreaPhysical(testSource, GetUnitX(testSource), GetUnitY(testSource),
		testRadius, testDamage, testEffect);
	}
	// 测试范围真实伤害
	function TTestUTDamageUtils5(player p) {
		CreateTestEnv(p);
		Trace("测试范围真实伤害: " + R2S(testDamage) + " 范围: " + R2S(testRadius));
		Trace("中心点有1个假人，半径 " + R2S(testRadius) + " 处有8个假人");
		Trace("范围内的假人都会受到伤害和特效");
		DamageAreaPure(testSource, GetUnitX(testSource), GetUnitY(testSource),
		testRadius, testDamage, testEffect);
	}
	// 测试伤害显示开关
	function TTestUTDamageUtils6(player p) {
		isShowDamage = !isShowDamage;
		if(isShowDamage) {
			Trace("|cff00ff00开启|r伤害数值显示");
		} else {
			Trace("|cffff0000关闭|r伤害数值显示");
		}
	}
	// 测试反伤开关
	function TTestUTDamageUtils7(player p) {
		isReflectDamage = !isReflectDamage;
		if(isReflectDamage) {
			reflectCount = 0; // 重置反伤计数
Trace("|cff00ff00开启|r伤害反弹测试 - 受伤单位将反弹50%伤害(最多5次)");
		} else {
			Trace("|cffff0000关闭|r伤害反弹测试");
		}
	}
	// 处理参数设置命令
	function TTestActUTDamageUtils1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[]; // 所有参数S
integer paramI[]; // 所有参数I
real paramR[]; // 所有参数R
		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;
		// 处理命令
		if (paramS[0] == "d") {
			testDamage = paramR[1];
			Trace("设置伤害值为: " + R2S(testDamage));
		} else if (paramS[0] == "r") {
			testRadius = paramR[1];
			Trace("设置范围值为: " + R2S(testRadius));
		} else if (paramS[0] == "e") {
			testEffect = paramS[1];
			Trace("设置特效为: " + testEffect);
		}
		p = null;
	}
	function onInit() {
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEvent(tr, 0.5, false);
		TriggerAddCondition(tr, Condition(function() {
			Trace("|cff00ff00[DamageUtils测试]|r 输入以下命令进行测试:");
			Trace("s1 - 测试物理伤害");
			Trace("s2 - 测试真实伤害");
			Trace("s3 - 测试模拟普攻");
			Trace("s4 - 测试范围物理伤害");
			Trace("s5 - 测试范围真实伤害");
			Trace("s6 - 切换伤害数值显示");
			Trace("s7 - 切换伤害反弹测试");
			Trace("参数设置:");
			Trace("-d [数值] - 设置伤害值");
			Trace("-r [数值] - 设置范围值");
			Trace("-e [路径] - 设置特效");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		// 创建伤害事件触发器
		damageEventTrigger = CreateTrigger();
		TriggerAddCondition(damageEventTrigger, Condition(function (){
			unit source = GetEventDamageSource();
			unit target = GetTriggerUnit();
			real damage = GetEventDamage();
			// 显示伤害信息
			if(isShowDamage) {
				Trace("|cffff0000伤害事件|r - 来源: " + GetUnitName(source) +
				" 目标: " + GetUnitName(target) +
				"("+I2S(GetHandleId(target))+ ") 伤害: " + R2S(damage) + " 当前栈层: " + I2S(DmgS.current()));
			}
			// 反伤测试
			if(isReflectDamage && reflectCount < 5) { // 限制反伤次数
reflectCount += 1; // 增加反伤计数
Trace("第 " + I2S(reflectCount) + " 次反伤");
				// 造成反伤
				DamageAreaPhysical(target, GetUnitX(target),GetUnitY(target), 100, damage * 0.5, I2S(DmgS.current()));
				if(reflectCount >= 5) {
					Trace("|cffff0000达到最大反伤次数(5次),现在栈层: " + I2S(DmgS.current()));
				}
			}
		}));
		// 注册聊天事件
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			if(SubString(str, 0, 1) == "-") {
				TTestActUTDamageUtils1(SubString(str, 1, StringLength(str)));
				return;
			}
			if(str == "s1") TTestUTDamageUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTDamageUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTDamageUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTDamageUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTDamageUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTDamageUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTDamageUtils7(GetTriggerPlayer()); // 新增命令
});
		cameraControl.openWheel();
	}
	function onDestroy() {
		DestroyTrigger(damageEventTrigger);
		damageEventTrigger = null;
	}
}
//! endzinc
// lua_print: 空白地图
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
//===========================================================================
// Trigger: 简介
//===========================================================================
function Trig_______uActions takes nothing returns nothing
    // 欢迎使用世界编辑器，开始你的地图创造之旅。
    // 你可以从dz.163.com获取最新编辑器咨询。
    // 当你的地图意外损坏时，你可以在backups目录找到你最近26次保存的地图。
    // 任何疑问请加官方作者群：QQ35063417。
    // 本次更新添加判断玩家是否为平台AI玩家，现在平台已经添加虚拟玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
endfunction
//===========================================================================
function InitTrig_______u takes nothing returns nothing
    set gg_trg_______u = CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_______u, function Trig_______uActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_______u( )
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation( Player(0), 0 )
    call ForcePlayerStartLocation( Player(0), 0 )
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), false )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )
    // Player 1
    call SetPlayerStartLocation( Player(1), 1 )
    call ForcePlayerStartLocation( Player(1), 1 )
    call SetPlayerColor( Player(1), ConvertPlayerColor(1) )
    call SetPlayerRacePreference( Player(1), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(1), false )
    call SetPlayerController( Player(1), MAP_CONTROL_USER )
    // Player 2
    call SetPlayerStartLocation( Player(2), 2 )
    call ForcePlayerStartLocation( Player(2), 2 )
    call SetPlayerColor( Player(2), ConvertPlayerColor(2) )
    call SetPlayerRacePreference( Player(2), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(2), false )
    call SetPlayerController( Player(2), MAP_CONTROL_USER )
    // Player 3
    call SetPlayerStartLocation( Player(3), 3 )
    call ForcePlayerStartLocation( Player(3), 3 )
    call SetPlayerColor( Player(3), ConvertPlayerColor(3) )
    call SetPlayerRacePreference( Player(3), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(3), false )
    call SetPlayerController( Player(3), MAP_CONTROL_USER )
    // Player 4
    call SetPlayerStartLocation( Player(4), 4 )
    call ForcePlayerStartLocation( Player(4), 4 )
    call SetPlayerColor( Player(4), ConvertPlayerColor(4) )
    call SetPlayerRacePreference( Player(4), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(4), false )
    call SetPlayerController( Player(4), MAP_CONTROL_COMPUTER )
    // Player 5
    call SetPlayerStartLocation( Player(5), 5 )
    call ForcePlayerStartLocation( Player(5), 5 )
    call SetPlayerColor( Player(5), ConvertPlayerColor(5) )
    call SetPlayerRacePreference( Player(5), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(5), false )
    call SetPlayerController( Player(5), MAP_CONTROL_COMPUTER )
    // Player 6
    call SetPlayerStartLocation( Player(6), 6 )
    call ForcePlayerStartLocation( Player(6), 6 )
    call SetPlayerColor( Player(6), ConvertPlayerColor(6) )
    call SetPlayerRacePreference( Player(6), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(6), false )
    call SetPlayerController( Player(6), MAP_CONTROL_COMPUTER )
    // Player 7
    call SetPlayerStartLocation( Player(7), 7 )
    call ForcePlayerStartLocation( Player(7), 7 )
    call SetPlayerColor( Player(7), ConvertPlayerColor(7) )
    call SetPlayerRacePreference( Player(7), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(7), false )
    call SetPlayerController( Player(7), MAP_CONTROL_COMPUTER )
    // Player 8
    call SetPlayerStartLocation( Player(8), 8 )
    call ForcePlayerStartLocation( Player(8), 8 )
    call SetPlayerColor( Player(8), ConvertPlayerColor(8) )
    call SetPlayerRacePreference( Player(8), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(8), false )
    call SetPlayerController( Player(8), MAP_CONTROL_COMPUTER )
    // Player 9
    call SetPlayerStartLocation( Player(9), 9 )
    call ForcePlayerStartLocation( Player(9), 9 )
    call SetPlayerColor( Player(9), ConvertPlayerColor(9) )
    call SetPlayerRacePreference( Player(9), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(9), false )
    call SetPlayerController( Player(9), MAP_CONTROL_COMPUTER )
    // Player 10
    call SetPlayerStartLocation( Player(10), 10 )
    call ForcePlayerStartLocation( Player(10), 10 )
    call SetPlayerColor( Player(10), ConvertPlayerColor(10) )
    call SetPlayerRacePreference( Player(10), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(10), false )
    call SetPlayerController( Player(10), MAP_CONTROL_COMPUTER )
    // Player 11
    call SetPlayerStartLocation( Player(11), 11 )
    call ForcePlayerStartLocation( Player(11), 11 )
    call SetPlayerColor( Player(11), ConvertPlayerColor(11) )
    call SetPlayerRacePreference( Player(11), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(11), false )
    call SetPlayerController( Player(11), MAP_CONTROL_COMPUTER )
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_013
    call SetPlayerTeam( Player(0), 0 )
    call SetPlayerTeam( Player(1), 0 )
    call SetPlayerTeam( Player(2), 0 )
    call SetPlayerTeam( Player(3), 0 )
    call SetPlayerTeam( Player(4), 0 )
    call SetPlayerTeam( Player(5), 0 )
    call SetPlayerTeam( Player(6), 0 )
    call SetPlayerTeam( Player(7), 0 )
    call SetPlayerTeam( Player(8), 0 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(7), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(7), true )
    // Force: TRIGSTR_014
    call SetPlayerTeam( Player(9), 1 )
    call SetPlayerTeam( Player(10), 1 )
    call SetPlayerTeam( Player(11), 1 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(10), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(10), true )
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount( 0, 3 )
    call SetStartLocPrio( 0, 0, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 1, 3 )
    call SetStartLocPrio( 1, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 2, 3 )
    call SetStartLocPrio( 2, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 3, 3 )
    call SetStartLocPrio( 3, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 2, 2, MAP_LOC_PRIO_HIGH )
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call initializeLua() 
 call SetCameraBounds( -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "NorthrendDay" )
    call SetAmbientNightSound( "NorthrendNight" )
    call SetMapMusic( "Music", true, 0 )
    call CreateRegions( )
    call CreateAllUnits( )
    call InitBlizzard( )
    call InitGlobals( )
    call InitCustomTriggers( )
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName( "TRIGSTR_1232" )
    call SetMapDescription( "TRIGSTR_1234" )
    call SetPlayers( 12 )
    call SetTeams( 12 )
    call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )
    call DefineStartLocation( 0, 0.0, 0.0 )
    call DefineStartLocation( 1, 0.0, 0.0 )
    call DefineStartLocation( 2, 0.0, 0.0 )
    call DefineStartLocation( 3, 0.0, 0.0 )
    call DefineStartLocation( 4, 0.0, 0.0 )
    call DefineStartLocation( 5, 0.0, 0.0 )
    call DefineStartLocation( 6, 0.0, 0.0 )
    call DefineStartLocation( 7, 0.0, 0.0 )
    call DefineStartLocation( 8, 0.0, 0.0 )
    call DefineStartLocation( 9, 0.0, 0.0 )
    call DefineStartLocation( 10, 0.0, 0.0 )
    call DefineStartLocation( 11, 0.0, 0.0 )
    // Player setup
    call InitCustomPlayerSlots( )
    call InitCustomTeams( )
    call InitAllyPriorities( )
endfunction
/**/
