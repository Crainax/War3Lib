#define CRNL <?='\n'?>  //因为这是二次wave的,所以这个宏定义得重定义一次


// API文档: https://japi.war3rpg.top/


#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
初始化内置JAPI
*/
library InnerJapi {

    // 运行Lua内容(在Jass端)
    public function EXExecuteScript (string p1) -> string {
        GetTriggeringTrigger();
        return "";
    }

    // 显示屏幕中间的 FPS 文本
    public function ShowFpsText(boolean show) {
        GetTriggeringTrigger();
    }

    // 异步获取 玩家当前的帧数
    // 玩家比较卡时 帧数较低 可以异步空特效路径 以及 弹道模型 屏蔽特效来提高帧数。
    public function GetFps () -> real {
        GetTriggeringTrigger();
        return 0.0;
    }
    // 解锁帧数上限 突破 60 帧
    // 填 true 解锁 填 false 恢复
    public function UnlockFps (boolean is_unlock) {
        GetTriggeringTrigger();
    }

    /* 清除魔兽 jass 虚拟机里缓存的字符串 解决游戏后期字符串太多导致游戏卡顿的问题
    ReleaseAllString 做了特殊处理 不处理 jass 全局变量 局部变量 哈希表里的字符串 能安全使用
    ReleaseString 没判定 字符串是否被引用， 需要小心使用。
    DumpAllString 将现存的字符串 输出到文件里
    顺便修复了 对玩家发送消息太多 导致卡顿的问题 */
    public function GetCacheStringCount () -> integer {
        GetTriggeringTrigger();
        return 0;
    }
    public function ReleaseString(string str) {
        GetTriggeringTrigger();
    }
    public function ReleaseAllString() {
        GetTriggeringTrigger();
    }
    public function DumpAllString(string filename) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 用来清空魔兽的模型文件缓存 降低内存占用 直到下一次读取 才会重新占用。
    //call ReleaseModel("xxx.mdx")
    public function ReleaseModel(string model_path) {
        GetTriggeringTrigger();
    }
    public function ReleaseAllModel() {
        GetTriggeringTrigger();
    }
    public function GetCacheModelCount() -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 异步获取 获取当前指向单位 一般用来做 UI 操作时需要用到的接口,注意返回是异步的 handle，切记小心使用
    public function GetTargetObject() -> unit {
        GetTriggeringTrigger();
        return null;
    }

    // 异步获取 当前玩家大头像模型的单位 当框选一群单位时 切换选择也会改变返回值 一般用来做 UI 操作时需要用到的接口
    public function GetRealSelectUnit () -> unit {
        GetTriggeringTrigger();
        return null;
    }

    // 异步获取 玩家的聊天框是否被打开 一般用来做键盘操作时 避免与输入冲突
    // 打开时返回 true 未打开时返回 false 注意返回是异步的，切记小心使用
    public function GetChatState () -> boolean {
        GetTriggeringTrigger();
        return false;
    }

    //解锁 blp 贴图的像素上限 原本魔兽高清图片也会被限制在 512p 之内
    // 填 true 解锁 填 false 恢复
    public function UnlockBlpSize (boolean is_unlock) {
        GetTriggeringTrigger();
    }


    //设置单位名字 每个单位独立 互相不影响 修改后 获取单位名字 还是返回原值
    public function SetUnitName (unit u, string name) {
        GetTriggeringTrigger();
    }

    //设置单位头像模型 设置之后会立即改变 当 设置单位模型时 会被新的自动覆盖掉
    // 模型路径 后缀可以是.mdx .mdl 省略后缀自动默认.mdx
    public function SetUnitPortrait (unit u, string model) {
        GetTriggeringTrigger();
    }

    //设置单位普攻弹道弧度 每个单位独立 互相不影响 会被法球覆盖
    //call SetUnitMissileArc(GetTriggerUnit(), 0.8)
    public function SetUnitMissileArc (unit u, real value) {
        GetTriggeringTrigger();
    }

    //设置单位普攻弹道模型 每个单位独立 互相不影响 会被法球覆盖
    //call SetUnitMissileModel(GetTriggerUnit(), "units\\human\\phoenix\\phoenix.mdx")
    public function SetUnitMissileModel (unit u, string model) {
        GetTriggeringTrigger();
    }

    //设置单位普攻弹道是否自动追踪 每个单位独立 互相不影响 会被法球覆盖
    //call SetUnitMissileHoming(GetTriggerUnit(), true)
    public function SetUnitMissileHoming (unit u, boolean value) {
        GetTriggeringTrigger();
    }

    //设置单位普攻弹道速度 每个单位独立 互相不影响 会被法球覆盖
    // call SetUnitMissileSpeed(GetTriggerUnit(), 2000)
    public function SetUnitMissileSpeed (unit u, real value) {
        GetTriggeringTrigger();
    }

    //设置单位模型 包括大头像模型也会自动设置 该接口 也可以给物品 特效 可破坏物 更换模型
    // call SetUnitModel(GetTriggerUnit(), "units\\human\\Peasant\\Peasant.mdx")
    public function SetUnitModel (unit u, string model) {
        GetTriggeringTrigger();
    }

    //设置单位贴图 替换单位身上的 id 贴图 例如队伍颜色的 id 贴图是 0 队伍光晕 id 是 1
    // call SetUnitTexture(GetTriggerUnit(), "xx.blp", 0)
    public function SetUnitTexture (unit u, string texture, integer id) {
        GetTriggeringTrigger();
    }

    //隐藏单位跟物品 鼠标指向时显示的 UI 包括单位血条
    // 警告
    // 目前对 物品使用会引起 掉线 请勿对物品使用
    // 是否显示 填 false 就是隐藏
    public function SetUnitPressUIVisible (unit u, boolean is_show) {
        GetTriggeringTrigger();
    }

    // 设置特效动画
    // index 动画索引
    public function EXSetEffectAnimation (effect e, integer index) {
        GetTriggeringTrigger();
    }

    // 设置特效 X Y 轴坐标
    // 设置特效坐标 修复了原本 ydjapi 里面特效超过出生范围一定距离 游戏不会渲染的问题 用了类似全图挂的方式 强行让魔兽渲染该特效。 todo:测试一下来自普通japi的这个能不能强制渲染
    //public function EXSetEffectXY (effect e, real x, real y) {
    //    GetTriggeringTrigger();
    //}

    // 设置特效 Z 轴坐标
    // 设置特效坐标 修复了原本 ydjapi 里面特效超过出生范围一定距离 游戏不会渲染的问题 用了类似全图挂的方式 强行让魔兽渲染该特效。
    //public function EXSetEffectZ (effect e, real z) {
    //    GetTriggeringTrigger();
    //}

    // 设置特效是否可见
    public function EXSetEffectVisible (effect e, boolean visible) {
        GetTriggeringTrigger();
    }
    // 设置特效是否在迷雾中可见
    public function EXSetEffectFogVisible (effect e, boolean visible) {
        GetTriggeringTrigger();
    }
    // 设置特效是否在阴影中可见
    public function EXSetEffectMaskVisible (effect e, boolean visible) {
        GetTriggeringTrigger();
    }

    // 设置特效颜色 透明值无效 16进制
    public function EXSetEffectColor (effect e, integer color) {
        GetTriggeringTrigger();
    }
    // 获取特效的颜色 跟 设置特效颜色 配合使用
    public function EXGetEffectColor (effect e) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 设置英雄称谓 每个单位独立 互相不影响 GetHeroProperName 获取英雄称谓 是修改后的值。
    public function SetUnitProperName (unit u, string name) {
        GetTriggeringTrigger();
    }

    // 获取指定商店 选择 指定玩家的哪个单位 返回值是同步的接口 可以安全使用
    // 如果商店周围没有可选的人的时候 会返回 0
    // store 商店单位 拥有 出售物品 选择英雄 的单位
    public function GetStoreTarget (unit store, player p) -> unit {
        GetTriggeringTrigger();
        return null;
    }

    // 获取指定 frame 的子控件 不能对 simple 类型的控件使用
    // 整数	frame	控件地址
    // 整数	last	上一个控件的地址 第一次读可以填 0
    public function FrameGetChilds (integer frame, boolean last) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 获取指定 frame 的父控件 不能对 simple 类型的控件使用 可以获取 大头像模型 的父控件 然后为其新建子控件 用来放置在所有界面之下
    public function FrameGetParent (integer frame) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 全屏状态下 返回 false 窗口化模式 返回 true
    public function IsWindowMode () -> boolean {
        GetTriggeringTrigger();
        return false;
    }

    // 设置指定 frame 是否启用视口
    // 设置开启 设置控件视口 比如 底板开启后 他的子控件 在边缘 超出部分不会渲染
    public function FrameSetViewPort (integer frame, boolean enable) {
        GetTriggeringTrigger();
    }

    // 设置窗口大小
    // 修改窗口大小 可以强行限制用户 窗口模式下的 窗口比例 16/9
    // call SetWindowSize(1024, 768)
    public function SetWindowSize (integer width, integer height) {
        GetTriggeringTrigger();
    }


    // 播放特效动画
    // 特效	handle	绑定的特效
    // 动画名	animation_name	字符串动画名字
    // 链接名	link_name	变身动画才需要的链接名 一般情况填 "" 空字符串就行、
    // call EXPlayEffectAnimation(eff, "attack", "")
    public function EXPlayEffectAnimation (effect e, string animation_name, string link_name) {
        GetTriggeringTrigger();
    }

    // 绑定特效
    // 主动绑定 effect 到 handle 上面 可以单位绑 特效 可以特效绑 特效
    // 对象	handle	可以是单位 特效 物品
    // 绑点	socket	绑点名字
    // 特效	handle	绑定的特效
    // local effect eff = AddSpecialEffect("units\\human\\Peasant\\Peasant.mdl", 0, 0)
    // call BindEffect(GetTriggerUnit(), eff)
    public function BindEffect (widget u, string socket, effect e) {
        GetTriggeringTrigger();
    }

    // 解除特效绑定
    // 可以让绑定在单位身上的特效 分离出来， 被分离的特效能设置坐标 跟缩放、
    public function UnBindEffect (effect e) {
        GetTriggeringTrigger();
    }

    //内置默认是 解锁 frame 控件的 屏幕限制的 就是可以随便移动到屏幕之外的位置， 但是有个别用户 依赖这个限制 用网易的接口写了 ui 导致加了内置之后 位置变了， 故此新增这个接口 自行决定是否解锁。
    // 布尔值	is_limit	填 true 是锁定 填 false 是解锁
    public function SetFrameLimitScreen (integer frame, boolean is_limit) {
        GetTriggeringTrigger();
    }

    // 获取当前玩家 id
    public function GetUserId () -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    //异步获取 当前玩家在 11 或网易平台游戏时的 uid， 本地返回 0
    //返回值是异步的 建议先同步后再使用
    //这 2 个接口一般情况下 返回值都是一致的 有万分之一局的概率 2 个接口会返回不一致， 自己验证使用吧。
    //网易的 uid 获取率 达到 99.999% 目前来说测试是稳定 有效的 11 的 uid 还没有经过测试， 需要自行测试 小心使用 切记。
    public function GetUserIdEx () -> string {
        GetTriggeringTrigger();
        return "";
    }

    // 设置单位碰撞体积
    //跟物编一样 修改单位的碰撞体积 会刷新寻路， 依然受到魔兽碰撞上限的限制
    // 就是 当你 size 填 512 的时候 在远距离走路时 魔兽寻路 会按照 512 的碰撞体积去搜索路线， 在近距离时 魔兽会按照最高上限 估计 128 去搜索寻路 单位实际碰撞 也最高只有 128
    public function SetUnitCollisionSize (unit u, real size) {
        GetTriggeringTrigger();
    }

    // 设置单位移动类型
    // 修改指定单位的移动类型 按字符串修改 类型可以是跟物编里效果一样 type 有以下几个数值
    // "none"  = 没有， 无视碰撞
    // "foot"  = 步行， 地面碰撞跟寻路
    // "horse" = 骑马
    // "fly"   = 飞行  具有飞行视野，寻路能穿越树木跟悬崖，可以直接设置飞行高度 不用乌鸦形态了
    // "hover" = 浮空  不会踩中地雷
    // "float" = 漂浮 只能在深水里活动 不能在地面活动
    // "amph"  = 两栖
    // "unbuild" = 未知 自己测试
    public function SetUnitMoveType (unit u, string s) {
        GetTriggeringTrigger();
    }

    // 获取 框选按钮 slot 从0 ~ 11
    public function FrameGetInfoSelectButton (integer slot) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 获取 下方buff按钮 slot 从0 ~ 7
    public function FrameGetBuffButton (integer slot) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 获取 农民按钮
    public function FrameGetUnitButton () -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 获取 技能右下角数字文本控件 button = 技能按钮  返回值 = SimpleString 类型控件
    public function FrameGetButtonSimpleString (integer btn) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 获取 技能右下角控件  button = 技能按钮  返回值 = SimpleFrame 类型控件
    public function FrameGetButtonSimpleFrame (integer btn) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 判断控件是否显示
    public function FrameIsShow (integer frame) -> boolean {
        GetTriggeringTrigger();
        return false;
    }

    // 修改/获取 原生按钮图片 button 可以是 技能按钮 物品按钮 英雄按钮 农民按钮 框选按钮 buff按钮
    public function FrameSetOriginButtonTexture (integer btn, string path) {
        GetTriggeringTrigger();
    }

    public function FrameGetOriginButtonTexture (integer btn) -> string {
        GetTriggeringTrigger();
        return "";
    }

    // 修改/获取 simple类型控件的 父控件
    public function FrameGetSimpleParent (integer SimpleFrame) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    public function FrameSetSimpleParent (integer SimpleFrame, integer parentSimple) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 为Simple绑定 frame类型的子控件
    // 可以将任意frame类型 绑定到 原生ui下面 返回值 可以解除绑定
    // 返回的是一个 SetupFrame值
    public function FrameSimpleBindFrame (integer SimpleFrame, integer Frame) -> integer {
        GetTriggeringTrigger();
        return 0;
    }

    // 解除绑定 解除后 frame跟simple 就不再关联
    public function FrameSimpleUnBindFrame (integer SetupFrame) {
        GetTriggeringTrigger();
    }

    //获取物品技能的 handle 返回值 可以用在 ydjapi 的技能接口
    //slot	指定槽位 0 从开始
    public function GetItemAbility (item Item, integer slot) -> ability {
        GetTriggeringTrigger();
        return null;
    }

    #define SetCameraBounds(a,b,c,d,e,f,g,h) initializePlugin() CRNL call SetCameraBounds(a,b,c,d,e,f,g,h)

    // main 函数就初始化的
    public function initializePlugin () -> integer {
        ExecuteFunc("DoNothing");
        StartCampaignAI( Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback" );
        ExecuteFunc("DoNothing");
        AbilityId("exec-lua:plugin_main");
        return 0;
    }

    //显示内置Japi的版本
    function GetPluginVersion  () -> string {
        GetTriggeringTrigger();
        return "";
    }

    // 显示版本
    function onInit ()  {
        integer i = 0;
        timer t;
        t = CreateTimer();
        TimerStart(t,0.0,false,function (){
            timer t = GetExpiredTimer();
            integer id = GetHandleId(t);
            BJDebugMsg("内置Japi" + GetPluginVersion());
            PauseTimer(t);
            DestroyTimer(t);
            t = null;
        });
        t = null;
    }
}

//! endzinc


#ifdef OPEN
#undef public
#endif



#ifndef UnitTestFramworkIncluded
#define UnitTestFramworkIncluded

/*
单元测试框架(注入)
*/

//! zinc
library UnitTestFramwork {

	//单元测试总
	trigger TUnitTest = null;

    //注册单元测试事件(聊天内容),自动注入
    public function UnitTestRegisterChatEvent (code func) {
        TriggerAddAction(TUnitTest, func);
    }

    function onInit ()  {
        //在游戏开始0.1秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.1);
        TriggerAddCondition(tr,Condition(function (){
            integer i;
            for (1 <= i <= 12) {
				SetPlayerName(ConvertedPlayer(i),"测试员" + I2S(i)+ "号");
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
#endif



#ifndef LoggerIncluded
#define LoggerIncluded

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
library Logger requires InnerJapi {

    // 追踪级别日志(灰色),用于程序执行追踪
    public function Trace(string msg) {
        GetTriggerUnit();
    }

    // 调试级别日志(绿色),用于输出变量值等调试信息
    public function Debug(string msg) {
        GetTriggerUnit();
    }

    // 信息级别日志(白色),用于输出普通提示信息
    public function Info(string msg) {
        GetTriggerUnit();
    }

    // 警告级别日志(黄色),用于输出警告信息
    public function Warn(string msg) {
        GetTriggerUnit();
    }

    // 错误级别日志(红色),用于输出错误信息
    public function Error(string msg) {
        GetTriggerUnit();
    }

    // 向指定玩家输出追踪日志(灰色)
    public function TraceToPlayer(player p, string msg) {
        GetTriggerUnit();
    }

    // 向指定玩家输出调试日志(绿色)
    public function DebugToPlayer(player p, string msg) {
        GetTriggerUnit();
    }

    // 向指定玩家输出信息日志(白色)
    public function InfoToPlayer(player p, string msg) {
        GetTriggerUnit();
    }

    // 向指定玩家输出警告日志(黄色)
    public function WarnToPlayer(player p, string msg) {
        GetTriggerUnit();
    }

    // 向指定玩家输出错误日志(红色)
    public function ErrorToPlayer(player p, string msg) {
        GetTriggerUnit();
    }

    function onInit() {
        AbilityId("exec-lua:depends.debug.logger"); //日志打印系统初始化
    }
}

//! endzinc
#endif

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
    // 单元测试
    // lua_print: 单元测试
// #define StructMode // todo:结构体数量查看模式:用条件编译直接全部搞定
//函数入口
// 用原始地图测试
// 用空地图测试
// 用原始地图测试
//! zinc
//==================================
// Logger测试模块
// version: 1.0
// author: 系统自动生成
// date: 2024/3/21
//
// 功能：测试Logger库的所有日志输出功能
// 测试指令：
// s1 - 测试全局日志输出(Trace/Debug/Info/Warn/Error)
// s2 - 测试指定玩家日志输出
// -a [msg] - 测试自定义消息的全局日志输出
// -b [msg] - 测试自定义消息的玩家日志输出
//==================================
library UTLogger requires Logger {
	// 测试全局日志输出
	function TTestUTLogger1(player p) {
		Trace("这是一条追踪日志");
		Debug("这是一条调试日志");
		Info("这是一条信息日志");
		Warn("这是一条警告日志");
		Error("这是一条错误日志");
	}
	// 测试指定玩家日志输出
	function TTestUTLogger2(player p) {
		TraceToPlayer(p, "这是发送给玩家的追踪日志");
		DebugToPlayer(p, "这是发送给玩家的调试日志");
		InfoToPlayer(p, "这是发送给玩家的信息日志");
		WarnToPlayer(p, "这是发送给玩家的警告日志");
		ErrorToPlayer(p, "这是发送给玩家的错误日志");
	}
	// 其他测试函数预留
	function TTestUTLogger3(player p) {}
	function TTestUTLogger4(player p) {}
	function TTestUTLogger5(player p) {}
	function TTestUTLogger6(player p) {}
	function TTestUTLogger7(player p) {}
	function TTestUTLogger8(player p) {}
	function TTestUTLogger9(player p) {}
	function TTestUTLogger10(player p) {}
	// 处理带参数的测试命令
	function TTestActUTLogger1(string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str);
		string paramS[]; // 所有参数S
integer paramI[]; // 所有参数I
real paramR[]; // 所有参数R

		// 解析参数
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num] = SubString(str,0,i);
				paramI[num] = S2I(paramS[num]);
				paramR[num] = S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num] = str;
		paramI[num] = S2I(paramS[num]);
		paramR[num] = S2R(paramS[num]);
		num = num + 1;
		// 测试自定义消息的全局日志输出
		if (paramS[0] == "a") {
			Trace(paramS[1]);
			Debug(paramS[1]);
			Info(paramS[1]);
			Warn(paramS[1]);
			Error(paramS[1]);
		}
		// 测试自定义消息的玩家日志输出
		else if (paramS[0] == "b") {
			TraceToPlayer(p, paramS[1]);
			DebugToPlayer(p, paramS[1]);
			InfoToPlayer(p, paramS[1]);
			WarnToPlayer(p, paramS[1]);
			ErrorToPlayer(p, paramS[1]);
		}
		p = null;
	}
	function onInit() {
		// 注册聊天事件处理器
		UnitTestRegisterChatEvent(function() {
			string str = GetEventPlayerChatString();
			integer i = 1;
			// 处理带参数的命令
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTLogger1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			// 处理简单测试命令
			if (str == "s1") TTestUTLogger1(GetTriggerPlayer());
			else if(str == "s2") TTestUTLogger2(GetTriggerPlayer());
			else if(str == "s3") TTestUTLogger3(GetTriggerPlayer());
			else if(str == "s4") TTestUTLogger4(GetTriggerPlayer());
			else if(str == "s5") TTestUTLogger5(GetTriggerPlayer());
			else if(str == "s6") TTestUTLogger6(GetTriggerPlayer());
			else if(str == "s7") TTestUTLogger7(GetTriggerPlayer());
			else if(str == "s8") TTestUTLogger8(GetTriggerPlayer());
			else if(str == "s9") TTestUTLogger9(GetTriggerPlayer());
			else if(str == "s10") TTestUTLogger10(GetTriggerPlayer());
		});
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
