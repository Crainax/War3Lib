#ifndef UnitFilterIncluded
#define UnitFilterIncluded

//! zinc
/*
单位有关
*/
library UnitFilter {

    //判断是否是敌方(不带无敌)
    public function IsEnemy (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitEnemy(u, p) && GetUnitAbilityLevel(u,'Avul') == 0;
    }
    //旧名：IsEnemy2
    //判断是否是敌方(能匹配到无敌单位)
    public function IsEnemyIncludeInvul (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitEnemy(u, p);
    }
    //判断是否是友方
    public function IsAlly (player p,unit u)  -> boolean {
        return GetUnitState(u, UNIT_STATE_LIFE) > .405 && !(IsUnitType(u, UNIT_TYPE_STRUCTURE)) && !(IsUnitHidden(u)) && IsUnitAlly(u, p);
    }

}

//! endzinc
#endif


#ifndef NumberUtilsIncluded
#define NumberUtilsIncluded

//! zinc
/*
数字工具
*/
library NumberUtils  {

    // 老版本叫GetIntegerBit(替换)
    // 获取一个整数中指定范围的数字(按十进制位数)
    // @param value - 要处理的整数,如1483
    // @param bit1 - 起始位置(从右往左,从1开始),如1表示个位
    // @param bit2 - 结束位置,如3表示百位
    // @return - 返回指定范围的数字,如1483取1-3位返回483
    public function GetNumberRange (integer value,integer bit1,integer bit2) -> integer {
        if (bit1 > bit2) {return 0;}
        if (bit1 <= 0 || bit2 <= 0) {return 0;}
        return ModuloInteger(value,R2I(Pow(10,bit2)))/R2I(Pow(10,bit1-1));
    }
    // 老版本叫GetBit(替换)
    // 获取一个整数中指定位置的单个数字(按十进制位数)
    // @param num - 要处理的整数,如1483
    // @param bit - 要获取的位置(从右往左,从1开始),如2表示十位
    // @return - 返回指定位置的数字,如1483取第2位返回8
    // 注意:会自动处理负数(取绝对值),位数超出或不合法返回0
    public function GetDigitAt (integer num,integer bit) -> integer {
        integer bit1 = R2I(Pow(10,bit-1));     //举例,1483取位2 ->这个是10;
        integer bit2 = R2I(Pow(10,bit));       //举例,1483取位2 ->这个是100;
        num = IAbsBJ(num);                     //取绝对值
        if (bit <= 0 || bit >= 32) {return 0;} //超了整数上限
        if (bit1 > num) {return 0;}            //取了不该取的位
        bit1 = IMaxBJ(1,bit1);
        //先取余100,再除10 ->
        return ModuloInteger(num,bit2) / bit1;
    }
}

//! endzinc
#endif

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
        // BJDebugMsg(GetPluginVersion());
        GetPluginVersion();
    }
}

//! endzinc


#ifdef OPEN
#undef public
#endif



#ifndef MathUtilsIncluded
#define MathUtilsIncluded

//! zinc
/*
数学工具
*/
library MathUtils {

    // 实转整 带概率进1的
    public function R2IRandom (real value) -> integer {
        if (GetRandomReal(0,1.0) <= ModuloReal(value,1.0)) {
            return R2I(value) + 1;
        }
        return R2I(value);
    }
    // 除法,但是相等的话还是为0哦
    public function Divide1 (integer i1,integer i2) -> integer {
        if (ModuloInteger(i1,i2) == 0) {
            return i1/i2 - 1;
        }
        return i1/i2;
    }
    // 实数归一化相加
    public function RealAdd ( real a1,real a2 ) -> real {
        if (RAbsBJ(a2) >= 1.0) {return a1;}
        if (a2 >= 0) {return 1.0-(1.0-a1)*(1.0-a2);}
        else {return 1.0-(1.0-a1)/(1.0+a2);}
    }
    // 最小最大值限制
    public function ILimit ( integer target,integer min,integer max ) -> integer {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }
    // 最小最大值限制
    public function RLimit ( real target,real min,real max ) -> real {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }
    //四舍五入法实数转整数
    public function R2IM (real r)  -> integer {
        if (ModuloReal(r,1.0) >= 0.5) return R2I(r)+1;
        else return R2I(r);
    }

    // 计算射线与地图边界的交点
    // 原名字 : limitXY
    public struct radiationEnd {
        static real x = 0,y = 0;

        //修正一下Tan这个函数的问题(精确到1度)
        private static method tan (real angle)  -> real {
            real a = ModuloReal(angle,180); //求余数
            if (a < 1.0) { //接近0度
                return 0.0001;
            } else if (a > 179.0) { //接近180度
                return -0.0001;
            } else if (a > 89 && a <= 90) { //89-90
                return 55555.0;
            } else if (a > 90 && a < 91) { //90-91
                return -55555.0;
            } else { //正常角度
                return TanBJ(angle);
            }
        }

        //一个坐标沿着某个方向的边缘值
        // 输入参数:
        // x1, y1: 起始点坐标
        // angle: 射线的角度（0-360度）
        // 功能说明：
        // 1. 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点
        // 2. 将计算结果存储在结构体的静态变量x和y中
        // 3. 根据角度不同分为四个象限处理：
        //    - 0-90度：第一象限，可能与上边界或右边界相交
        //    - 90-180度：第二象限，可能与上边界或左边界相交
        //    - 180-270度：第三象限，可能与下边界或左边界相交
        //    - 270-360度：第四象限，可能与下边界或右边界相交
        // 这个函数在游戏中经常用于：
        // 限制单位移动范围
        // 计算技能射程终点
        // 确定视线或投射物的最远点
        static method cal (real x1,real y1,real angle) {
            real x2  = 0; //相交点
            real y2  = 0; //相交点
            real a = ModuloReal(angle,360); //求余数
            real tan;
            x = 0;
            y = 0;
            if (a <= 90) { //第一象限
                tan = tan(a);
                x2 = (yd_MapMaxY - y1) / tan + x1;
                y2 = (yd_MapMaxX - x1) * tan + y1;
                if (x2 <= yd_MapMaxX) { //取这个
                    x = x2;
                    y = yd_MapMaxY;
                } else {
                    x = yd_MapMaxX;
                    y = y2;
                }
            } else if( a <= 180) { //第二象限
                tan = tan(a);
                x2 = (yd_MapMaxY - y1) / tan + x1;
                y2 = (yd_MapMinX - x1) * tan + y1;
                if (x2 >= yd_MapMinX) { //取这个
                    x = x2;
                    y = yd_MapMaxY;
                } else {
                    x = yd_MapMinX;
                    y = y2;
                }
            } else if( a <= 270) { //第三象限
                tan = tan(a);
                x2 = (yd_MapMinY - y1) / tan + x1;
                y2 = (yd_MapMinX - x1) * tan + y1;
                if (x2 >= yd_MapMinX) { //取这个
                    x = x2;
                    y = yd_MapMinY;
                } else {
                    x = yd_MapMinX;
                    y = y2;
                }
            } else { //第四象限
                tan = tan(a);
                x2 = (yd_MapMinY - y1) / tan + x1;
                y2 = (yd_MapMaxX - x1) * tan + y1;
                if (x2 <= yd_MapMaxX) { //取这个
                    x = x2;
                    y = yd_MapMinY;
                } else {
                    x = yd_MapMaxX;
                    y = y2;
                }
            }
        }
    }


}

//! endzinc
#endif

#ifndef GeometryIncluded
#define GeometryIncluded

//! zinc
/*
几何工具
todo:直接用宏定义修改试试
*/
library Geometry {

    // 4个坐标的距离
    public function GetDistance (real x1,real y1,real x2,real y2) -> real {
        real dx = x2 - x1 , dy = y2 - y1;
        return SquareRoot(dx*dx+dy*dy);
    }
    // 6个坐标的距离
    public function GetDistanceZ (real x1,real y1,real z1,real x2,real y2,real z2) -> real {
        real dx = x2 - x1 , dy = y2 - y1, dz = z2 - z1;
        return SquareRoot(dx*dx+dy*dy+dz*dz);
    }
    // 4个坐标的角度,前面是人的位置，后面是点的位置
    public function GetFacing (real x1,real y1,real x2,real y2) -> real {
        return Atan2BJ(y2-y1,x2-x1);
    }

}

//! endzinc
#endif

#ifndef UnitUtilsIncluded
#define UnitUtilsIncluded

#include "Crainax/core/constant/UNDefine.j"
#include "Crainax/core/constant/JapiConstant.j"

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
        if (HaveSavedInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            return LoadInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
        }
        else {return R2I(GetUnitMoveSpeed(u));}
    }
    //todo: 这个UNTable其他地图需要兼容
    // 增加移速
    public function AddUnitSpeed (unit u,integer speed) {
        integer value;
        if (HaveSavedInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED)) { //突破522与0的移速的Hook
            value  = LoadInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED);
            value += speed;
            SaveInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED,value);
        } else {value = R2I(GetUnitMoveSpeed(u)) + speed;}
		SetUnitMoveSpeed(u,value);
    }
    // 初始化突破移速
    public function InitUnitSpeed (unit u) {
        SaveInteger(UNTable,GetHandleId(u),KEY_UNIT_MOVE_SPEED,R2I(GetUnitMoveSpeed(u)));
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
        FlushChildHashtable(UNTable,GetHandleId(u));
        RemoveUnit(u);
    }

}

//! endzinc
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



#ifndef YDWEEffectIncluded
#define YDWEEffectIncluded

library YDWEJapiEffect
	native EXGetEffectX takes effect e returns real
	native EXGetEffectY takes effect e returns real
	native EXGetEffectZ takes effect e returns real
	native EXSetEffectXY takes effect e, real x, real y returns nothing
	native EXSetEffectZ takes effect e, real z returns nothing
	native EXGetEffectSize takes effect e returns real
	native EXSetEffectSize takes effect e, real size returns nothing
	native EXEffectMatRotateX takes effect e, real angle returns nothing
	native EXEffectMatRotateY takes effect e, real angle returns nothing
	native EXEffectMatRotateZ takes effect e, real angle returns nothing
	native EXEffectMatScale takes effect e, real x, real y, real z returns nothing
	native EXEffectMatReset takes effect e returns nothing
	native EXSetEffectSpeed takes effect e, real speed returns nothing

	function YDWESetEffectLoc takes effect e, location loc returns nothing
		call EXSetEffectXY(e, GetLocationX(loc), GetLocationY(loc))
	endfunction
endlibrary

#endif  /// YDWEEffectIncluded

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
    unit tempU = null;

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
    public function GetEnemyGroup (unit u,real x,real y,real radius) -> group {
        tempG = CreateGroup();
        tempU = u;
        GroupEnumUnitsInRangeEx(tempG, x, y, radius, Filter(function () -> boolean {
            if (IsEnemy(GetOwningPlayer(tempU),GetFilterUnit())) {
                return true;
            }
            return false;
        }));
        tempU = null;
        return tempG;
    }

    //获取圆形随机单位
    public function GetRandomEnemy (unit u,real x,real y,real radius)  -> unit {
        return GroupPickRandomUnit(GetEnemyGroup(u,x,y,radius));
    }

}

//! endzinc
#endif

#ifndef BZAPIINCLUDE
#define BZAPIINCLUDE

#define ANCHOR_TOPLEFT 0
#define ANCHOR_TOP 1
#define ANCHOR_TOPRIGHT 2
#define ANCHOR_LEFT 3
#define ANCHOR_CENTER 4
#define ANCHOR_RIGHT 5
#define ANCHOR_BOTTOMLEFT 6
#define ANCHOR_BOTTOM 7
#define ANCHOR_BOTTOMRIGHT 8

#define FRAME_EVENT_NONE  0
#define FRAME_EVENT_PRESSED  1
#define FRAME_MOUSE_ENTER  2
#define FRAME_MOUSE_LEAVE  3
#define FRAME_MOUSE_UP  4
#define FRAME_MOUSE_DOWN  5
#define FRAME_MOUSE_WHEEL  6
#define FRAME_FOCUS_ENTER  2
#define FRAME_FOCUS_LEAVE  3
#define FRAME_CHECKBOX_CHECKED  7
#define FRAME_CHECKBOX_UNCHECKED  8
#define FRAME_EDITBOX_TEXT_CHANGED  9
#define FRAME_POPUPMENU_ITEM_CHANGE_START  10
#define FRAME_POPUPMENU_ITEM_CHANGED  11
#define FRAME_MOUSE_DOUBLECLICK  12
#define FRAME_SPRITE_ANIM_UPDATE  13

#define FRAME_EVENT_KEY_PRESSED 1
#define FRAME_EVENT_KEY_UP 0
#define FRAME_MOUSE_LEFT 1
#define FRAME_MOUSE_RIGHT 2

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

    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction

    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction



endlibrary

#endif /// YDWEAddAIOrderIncluded

#ifndef YDWEBaseIncluded
#define YDWEBaseIncluded

library_once YDWEBase initializer InitializeYD

#if WARCRAFT_VERSION >= 124
#  include "Base/YDWEBase_hashtable.j"
#else
#  include "Base/YDWEBase_returnbug.j"
#endif
#
#  include "Base/YDWEBase_common.j"

endlibrary

#endif // YDWEBaseIncluded

#if 0
//--------------------------------------------//
//         本文件为自动生成，请勿编辑         //
//             thanks to 最萌小汐             //
//--------------------------------------------//
#endif
#ifdef USE_BJ_ANTI_LEAK
#ifndef YDWEGetUnitsInRectAllNullIncluded
#define YDWEGetUnitsInRectAllNullIncluded

#include "AntiBJLeak/detail/GetUnitsInRectMatching.j"

library YDWEGetUnitsInRectAllNull requires YDWEGetUnitsInRectMatchingNull

function YDWEGetUnitsInRectAllNull takes rect r returns group
    return YDWEGetUnitsInRectMatchingNull(r, null)
endfunction

endlibrary

#endif
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
/*
常用常量
*/
//玩家总数
//! zinc
library Constant {
    public integer playerCount = 0; //从游戏开始的玩家人数
public integer renshu = 0; //动态游戏人数

    function onInit () {
        integer i;
        for (1 <= i <= 4) {
            if ((GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING) && (GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER)) {
                playerCount += 1;
                renshu += 1;
            }
        }
    }
}
//! endzinc
//! zinc
/*
公用变量
*/
library Variable requires Constant {
	//玩家信息
	public struct pd [] {
		integer gold;	//金币
integer gem;	//宝石
integer kill;	//杀怪
string name;	//名字

		integer goldRate;	//金币获取率,除100
integer goldNega;	//金币负获取率,除100
integer gemRate;	//结晶获取率,除100
integer gemNega;	//结晶负获取率,除100
integer killExtra;	//不用除100,单纯加减
integer killNega;	//不用除100,单纯加减
//以后再说:要不要金币与宝石突破上限

		optional module auraAfter; //引用
}
	//主英雄
	public unit H[];
	public unit USelected[]; //正在选择的单位[同步]

	//表数据
	public hashtable UNTable = InitHashtable(); //以unittype为头的表
public hashtable UTTable = InitHashtable(); //以unit为头的表
public hashtable TITable = InitHashtable(); //以计时器为头的表
public hashtable GRTable = InitHashtable(); //以单位组为头的表
public hashtable SPTable = InitHashtable(); //以SpellStruct为头的表

	//选择事件
	public trigger TrSelect = null;
	//[结构体创建事件]类型
	public integer StType = 0;
	//[结构体创建事件]指针
	public integer StThis = 0;
	//[结构体创建事件]触发器
	public trigger TrStruct = null;
	//几个矩形区域
	public rect RHome[];
	public rect RFuben[];
	public function OnStructCreate (integer typeid,integer stthis) {
		StType = typeid;
		StThis = stthis;
		if (TrStruct != null) {
			TriggerEvaluate(TrStruct);
		}
	}
	function onInit () {
		//在游戏开始0.1秒后再调用
		integer i = 1;
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.2);
		TriggerAddCondition(tr,Condition(function (){
			integer i;
			for (1 <= i <= 4) {
				pd[i].name = GetPlayerName(ConvertedPlayer(i));
			}
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		//选单位的事件[同步]
		TrSelect = CreateTrigger();
		for (1 <= i <= 4) {TriggerRegisterPlayerSelectionEventBJ(TrSelect, ConvertedPlayer(i), true);}
		TriggerAddCondition(TrSelect, Condition(function (){
			//单位选择事件[同步]
			integer index = GetConvertedPlayerId(GetTriggerPlayer());
			USelected[index] = GetTriggerUnit();
		}));
	}
}
//! endzinc
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
static timer t = null; //运动计时器
static thistype List [];	//内容列表
static integer size = 0;	//现在有几个东西

        integer uID; //[成员]绑定的ID
real x, y, z, dx, dy, dz; //[成员]起点与终点
real xySpeed, zSpeed, speed;	//[成员]移动速度
effect e; //[成员]特效本体
trigger tr; //[成员]特效到达目标后
boolean down; //[成员]是向上还是向下

        optional module efStat; //[外导的]存储信息

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
                List[uID] = List[size];
                List[uID].uID = uID;
                size -= 1;
                uID = 0;
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
            this.x = x;
            this.y = y;
            this.z = z;
            this.dx = dx;
            this.dy = dy;
            this.dz = dz;
            distanceXY = GetDistance(x,y,dx,dy);
            distanceZ = RAbsBJ(z-dz);
            distance = GetDistanceZ(x,y,z,dx,dy,dz);
            if (distance > 0) { //设置一下速度
this.speed = speed;
                this.xySpeed = speed * SquareRoot(distanceXY * distanceXY / distance / distance);
                this.zSpeed = speed * SquareRoot(distanceZ * distanceZ / distance / distance);
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
size += 1;
                List[size] = this;
                uID = size;
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
                                thistype this = efut.args1;
                                real angle = GetFacing(x,y,dx,dy);
                                real nx = YDWECoordinateX(x + xySpeed * CosBJ(angle));
                                real ny = YDWECoordinateY(y + xySpeed * SinBJ(angle));
                                real nz;
                                if (down) nz = RMaxBJ(dz,z - zSpeed); //向下运动,z速是负数
else nz = RMinBJ(dz,zSpeed + z); //向上运动,z速是正数

                                EXSetEffectXY(e,nx,ny);
                                EXSetEffectZ(e,nz);
                                if (GetDistanceZ(nx,ny,nz,dx,dy,dz) <= speed) { //到地方了
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
static timer t = null; //运动计时器
static thistype List [];	//内容列表
static integer size = 0;	//现在有几个东西

        integer uID; //[成员]绑定的ID
real cd; //[成员]倒计时
real ux, uy, uz;	//[成员]贝塞尔点1(起点)
real ex, ey, ez;	//[成员]贝塞尔点2(中点)
real nx, ny, nz;	//[成员]贝塞尔点2(终点),用于如果目标死亡的缓存点
unit u; //[成员]目标单位
effect e; //[成员]特效本体
trigger tr; //[成员]特效到达目标后

        optional module efStat; //[外导的]存储信息

        method isExist () -> boolean {return (this != null && si__umissile_V[this] == -1);}
        method onDestroy () {
            DestroyEffect(e);
            DestroyTrigger(tr);
            e = null;
            tr = null;
            u = null;
        }
        method unreg () {
            if (!(isExist())) return;
            if (uID != 0) {
                //这个其实就是将List的[2]设成5  假设2是删  5是最长
                //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
                //但是实例[2]本身的内容已经被清除. 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                List[uID] = List[size];
                List[uID].uID = uID;
                size -= 1;
                uID = 0;
            }
            this.destroy();
        }
        //由于是跟踪型,目标
        static method reg (string s,real x,real y,real z,unit target,code func1) -> thistype {
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
			angle = GetFacing(x,y,GetUnitX(target),GetUnitY(target));
			ux = YDWECoordinateX(x - 60 * CosBJ(angle));
			uy = YDWECoordinateY(y - 60 * SinBJ(angle));
			uz = z + 80;
			x1 = YDWECoordinateX(x - 1 * CosBJ(angle));
			y1 = YDWECoordinateY(y - 1 * SinBJ(angle));
			angle2 = GetFacing(x,y,x1,y1);
			random = GetRandomInt(1,10);
			ex = CosBJ(90-(18*random+angle2)) * 1000 + x1;
			ey = SinBJ(90-(18*random+angle2)) * 1000 + y1;
			ez = 600;
			e = AddSpecialEffect(s, ux,uy );
			u = target;
			cd = 0.;
			nx = GetUnitX(target);
			ny = GetUnitY(target);
			nz = GetUnitFlyHeight(target) + 50;
			EXSetEffectZ(e,uz);
            if (uID == 0) { //这里是初始化时的设置内容,不需要改
size += 1;
                List[size] = this;
                uID = size;
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
                                thistype this = efut.args1;
                                real tx,ty,tz; //贝塞尔坐标
real txi,tyi; //下一步的位置,求出角度

                                if (cd > 0.98) { //到地方了
if (tr != null) {
                                        ethis = this;
                                        TriggerEvaluate(tr);
                                    }
                                    unreg();
                                    return false;
                                } else { //没到 存一下地点以防万一
if (IsUnitAliveBJ(u)) { //活着跟踪
nx = GetUnitX(u);
                                        ny = GetUnitY(u);
                                        nz = GetUnitFlyHeight(u) + 50;
                                    } //没活着就

                                    cd += 0.02;
                                    tx = Pow((1-cd),2)*ux + 2 *cd * (1-cd)*ex + Pow(cd,2)*nx;
                                    ty = Pow((1-cd),2)*uy + 2 *cd * (1-cd)*ey + Pow(cd,2)*ny;
                                    tz = Pow((1-cd),2)*uz + 2 *cd * (1-cd)*ez + Pow(cd,2)*nz;
                                    EXSetEffectZ(e,tz);
                                    EXSetEffectXY(e,tx,ty);
                                    EXEffectMatReset(e);
                                    txi = Pow((1-(cd+0.02)),2)*ux + 2 *(cd+0.02) * (1-(cd+0.02))*ex + Pow((cd+0.02),2)*nx;
                                    tyi = Pow((1-(cd+0.02)),2)*uy + 2 *(cd+0.02) * (1-(cd+0.02))*ey + Pow((cd+0.02),2)*ny;
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
static timer t = null; //运动计时器
static thistype List []; //内容列表
static integer size = 0; //现在有几个东西

        integer uID; //[成员]绑定的ID
real x, y, dx, dy;	//[成员]起点与终点(没有Z)
real speed,radius;	//[成员]移动速度/单位组检测范围
effect e; //[成员]特效本体
trigger trU,trEnd;	//[成员]触发(伤害时(与帧事件)/结束时)
group g; //[成员]缓存单位组

        optional module efStat; //[外导的]存储信息

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
                List[uID] = List[size];
                List[uID].uID = uID;
                size -= 1;
                uID = 0;
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
            this.x = x;
            this.y = y;
            this.dx = dx;
            this.dy = dy;
            this.speed = speed;
            this.radius = radius;
            this.g = CreateGroup();
            if (uID == 0) { //这里是初始化时的设置内容,不需要改
size += 1;
                List[size] = this;
                uID = size;
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
                                thistype this = efut.args1;
                                real angle = GetFacing(x,y,dx,dy);
                                real nx = YDWECoordinateX(x + speed * CosBJ(angle));
                                real ny = YDWECoordinateY(y + speed * SinBJ(angle));
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
                                if (GetDistance(nx,ny,dx,dy) <= speed) { //到地方了
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
//! zinc
//blp
//blp
//blp
//自动生成的文件
library UTEffectUtils requires optional EffectUtils,Variable { //blp
//blp
//blp

	//blp
	//blp
	//blp
	//blp
	//blp
	function TTestUTEffectUtils1 (player p) {
		MemoryLeakShow();
		StructShow();
		GetLocalizedHotkey("yd_leak_monitor::create_report");
		DumpAllString("PO_stringTT.txt");
	}
	//blp
	//blp
	//blp
	function TTestUTEffectUtils2 (player p) { //测试一下纯直线弹幕
missile ms;
		integer i;
		for (1 <= i <= 10) {
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",GetRandomReal(-2000,2000),GetRandomReal(-2000,2000),0,GetRandomReal(-2000,2000),GetRandomReal(-2000,2000),0,GetRandomReal(30,100),function(){
				BJDebugMsg("到达地点咯!");
			});
		}
	}
	function TTestUTEffectUtils3 (player p) { //測試一下向上飞的直线弹幕
missile ms;
		integer i;
		real x;
		real y;
		for (1 <= i <= 10) {
			// ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",0,0,0,GetRandomReal(-1000,2000),GetRandomReal(-1000,2000),GetRandomReal(2000,3000),GetRandomReal(10,30),function(){
			// 	BJDebugMsg("飞天咯!");
			// });
			x = GetRandomReal(-1000,2000);
			y = GetRandomReal(-1000,2000);
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",x,y,0,x,y,GetRandomReal(2000,3000),GetRandomReal(30,100),function(){
				BJDebugMsg("飞天咯!");
			});
			EXEffectMatRotateY(ms.e,270);
			// EXEffectMatRotateY(ms.e,90);
		}
	}
	function TTestUTEffectUtils4 (player p) { //測試一下向下飞的直线弹幕
missile ms;
		integer i;
		real x;
		real y;
		for (1 <= i <= 10) {
			// ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",GetRandomReal(-1000,2000),GetRandomReal(-1000,2000),GetRandomReal(2000,3000),0,0,0,GetRandomReal(10,30),function(){
			// 	BJDebugMsg("落地咯!");
			// });
			x = GetRandomReal(-1000,2000);
			y = GetRandomReal(-1000,2000);
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",x,y,GetRandomReal(2000,3000),x,y,0,GetRandomReal(30,100),function(){
				BJDebugMsg("落地咯!");
			});
			EXEffectMatRotateY(ms.e,90);
		}
	}
	effect ef = null;
	function TTestUTEffectUtils5 (player p) { //研究一下特效X轴旋转
timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateX(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils6 (player p) { //研究一下特效Y轴旋转
timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateY(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils7 (player p) { //研究一下特效Z轴旋转:就是普通的
timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateZ(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	unit u1 = null;
	unit u2 = null;
	trigger trSY = null;
	function TTestUTEffectUtils8 (player p) { //贝塞尔
timer t;
		if (trSY == null) {
			trSY = CreateTrigger();
			TriggerAddCondition(trSY, Condition(function () {
				if (GetIssuedOrderId() == String2OrderIdBJ("smart")) {
					DzSetUnitPosition(GetTriggerUnit(),GetOrderPointX(),GetOrderPointY());
				}
			}));
		}
		if (u1 == null) {
			u1 = CreateUnit(p,'Hpal',0,0,0);
			TriggerRegisterUnitEvent(trSY,u1,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		if (u2 == null) {
			u2 = CreateUnit(p,'Ewar',1000,1000,0);
			TriggerRegisterUnitEvent(trSY,u2,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.1,true,function (){
			timer t2;
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			real angle = GetFacing(GetUnitX(u1),GetUnitY(u1),GetUnitX(u2),GetUnitY(u2));
			real ux = GetUnitX(u1) - 60 * CosBJ(angle);
			real uy = GetUnitY(u1) - 60 * SinBJ(angle);
			real uz = GetUnitFlyHeight(u1) + 80;
			real x1 = GetUnitX(u1) - 1 * CosBJ(angle);
			real y1 = GetUnitY(u1) - 1 * SinBJ(angle);
			real angle2 = GetFacing(GetUnitX(u1),GetUnitY(u1),x1,y1);
			integer random = GetRandomInt(1,10);
			real ex = CosBJ(90-(18*random+angle2)) * 1000 + x1;
			real ey = SinBJ(90-(18*random+angle2)) * 1000 + y1;
			real ez = 600;
			effect e = AddSpecialEffect("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", ux,uy );
			EXSetEffectZ(e,uz);
			if (i <= 100) {
				t2 = CreateTimer();
				SaveReal(TITable,GetHandleId(t2),1,0.0);
				SaveReal(TITable,GetHandleId(t2),2,ux);
				SaveReal(TITable,GetHandleId(t2),3,uy);
				SaveReal(TITable,GetHandleId(t2),4,uz);
				SaveReal(TITable,GetHandleId(t2),5,ex);
				SaveReal(TITable,GetHandleId(t2),6,ey);
				SaveReal(TITable,GetHandleId(t2),7,ez);
				SaveEffectHandle(TITable,GetHandleId(t2),8,e);
				TimerStart(t2,0.03,true,function (){
					timer t2 = GetExpiredTimer();
					integer id = GetHandleId(t2);
					real cd = LoadReal(TITable,id,1);
					real ux = LoadReal(TITable,id,2);
					real uy = LoadReal(TITable,id,3);
					real uz = LoadReal(TITable,id,4);
					real ex = LoadReal(TITable,id,5);
					real ey = LoadReal(TITable,id,6);
					real ez = LoadReal(TITable,id,7);
					effect e = LoadEffectHandle(TITable,id,8);
					real nx,ny,nz; //当前单位的位置
real tx,ty,tz; //
real txi,tyi; //下一步的位置,求出角度
if (cd <= 0.98) {
						nx = GetUnitX(u2);
						ny = GetUnitY(u2);
						nz = GetUnitFlyHeight(u2) + 50;
						cd += 0.02;
						tx = Pow((1-cd),2)*ux + 2 *cd * (1-cd)*ex + Pow(cd,2)*nx;
						ty = Pow((1-cd),2)*uy + 2 *cd * (1-cd)*ey + Pow(cd,2)*ny;
						tz = Pow((1-cd),2)*uz + 2 *cd * (1-cd)*ez + Pow(cd,2)*nz;
						EXSetEffectZ(e,tz);
						EXSetEffectXY(e,tx,ty);
						EXEffectMatReset(e);
						txi = Pow((1-(cd+0.02)),2)*ux + 2 *(cd+0.02) * (1-(cd+0.02))*ex + Pow((cd+0.02),2)*nx;
						tyi = Pow((1-(cd+0.02)),2)*uy + 2 *(cd+0.02) * (1-(cd+0.02))*ey + Pow((cd+0.02),2)*ny;
						EXEffectMatRotateZ(e,GetFacing(tx,ty,txi,tyi));
						SaveReal(TITable,id,1,cd);
					} else {
						DestroyEffect(e);
						PauseTimer(t2);
						FlushChildHashtable(TITable,id);
						DestroyTimer(t2);
					}
					t2 = null;
					e = null;
				});
				t2 = null;
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				DestroyEffect(e);
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
			e = null;
		});
		t = null;
	}
	function TTestUTEffectUtils9 (player p) { //测试一下umissile
timer t;
		if (trSY == null) {
			trSY = CreateTrigger();
			TriggerAddCondition(trSY, Condition(function () {
				if (GetIssuedOrderId() == String2OrderIdBJ("smart")) {
					DzSetUnitPosition(GetTriggerUnit(),GetOrderPointX(),GetOrderPointY());
				}
			}));
		}
		if (u1 == null) {
			u1 = CreateUnit(p,'Hpal',0,0,0);
			TriggerRegisterUnitEvent(trSY,u1,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		if (u2 == null) {
			u2 = CreateUnit(p,'Ewar',1000,1000,0);
			TriggerRegisterUnitEvent(trSY,u2,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.1,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 100) {
				umissile.reg("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl",GetUnitX(u1),GetUnitY(u1),GetUnitFlyHeight(u1),u2,function(){
					BJDebugMsg("击中了哦.");
				});
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	integer fra[];
	function TTestUTEffectUtils10 (player p) { //测试一下穿刺
pierce pe;
		integer i;
		integer index = GetConvertedPlayerId(p);
		ForGroup(YDWEGetUnitsInRectAllNull(GetPlayableMapRect()),function () {
			if (GetUnitTypeId(GetEnumUnit()) == 'nmam') {
				RemoveUnit(GetEnumUnit());
			}
		});
		// for (1 <= i <= 10) {
		pe = pierce.reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl",GetRandomReal(-2000,-1000),GetRandomReal(-2000,-1000),GetRandomReal(1000,2000),GetRandomReal(1000,2000),100,450,function(){ //帧事件与单位
pierce pe = pierce.ethis;
			if (CountUnitsInGroup(efut.g) > 0) {
				ForGroup(efut.g,function () {
					pierce pe = pierce.ethis;
					integer index = 1;
					if (IsEnemyIncludeInvul(Player(0),GetEnumUnit())) {
						BJDebugMsg(pd[index].name +"的敌人:"+GetUnitName(GetEnumUnit()));
						KillUnit(GetEnumUnit());
					} else if (IsAlly(Player(0),GetEnumUnit())) {
						BJDebugMsg(pd[index].name +"的队友:"+GetUnitName(GetEnumUnit()));
						SetUnitState(GetEnumUnit(),UNIT_STATE_LIFE,100);
					} else {
						BJDebugMsg("已经死亡的:"+GetUnitName(GetEnumUnit()));
					}
				});
			}
			fra[pe] = ModuloInteger(fra[pe],3)+1;
			if (ModuloInteger(fra[pe],3) == 0) {
				DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", pe.x,pe.y ));
			}
		},
		function(){ //结束事件
pierce pe = pierce.ethis;
			BJDebugMsg("结束啦!!");
		});
		// pe.h = MH[index];
		fra[pe]= 0;
		EXEffectMatScale(pe.e,3.0,3.0,3.0);
		EXSetEffectZ(pe.e,200);
		// }
		for (1 <= i <= 20) { //创建几个单位
CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'nmam',GetRandomReal(-200,200),GetRandomReal(-200,200),0);
			CreateUnit(Player(0),'nmam',GetRandomReal(-200,200),GetRandomReal(-200,200),0);
		}
	}
	real xLi = 0.;
	real yLi = 0.;
	function TTestUTEffectUtils11 (player p) { //测试一下边界点
timer t;
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.05,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			pierce pe;
			if (i <= 720) {
				//每个角度各来一发
				radiationEnd.cal(xLi,yLi,i*0.5);
				pe = pierce.reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl",xLi,
				yLi,YDWECoordinateX(radiationEnd.x),YDWECoordinateY(radiationEnd.y),100,450,function(){ //帧事件与单位
pierce pe = pierce.ethis;
					if (CountUnitsInGroup(efut.g) > 0) {
						ForGroup(efut.g,function () {
							pierce pe = pierce.ethis;
							BJDebugMsg("单位名字:"+GetUnitName(GetEnumUnit()));
						});
					}
				},
				function(){ //结束事件
pierce pe = pierce.ethis;
					BJDebugMsg("光波("+I2S(pe)+")结束啦:"+R2S(pe.x)+","+R2S(pe.y));
				});
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils12 (player p) {
	}
	function TTestUTEffectUtils13 (player p) {
	}
	function TTestUTEffectUtils14 (player p) {
	}
	function TTestUTEffectUtils15 (player p) {
	}
	function TTestUTEffectUtils16 (player p) {
	}
	function TTestUTEffectUtils17 (player p) {
	}
	function TTestUTEffectUtils18 (player p) {
	}
	function TTestUTEffectUtils19 (player p) {
	}
	function TTestUTEffectUtils20 (player p) {
	}
	function TTestActUTEffectUtils1 (string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str); //获取范围式数字
string paramS []; //所有参数S
integer paramI []; //所有参数I
real	paramR []; //所有参数R
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
		if (paramS[0] == "x") { //测试一下混合的特效
EXEffectMatRotateX(ef,paramR[1]);
		} else if (paramS[0] == "y") {
			EXEffectMatRotateY(ef,paramR[1]);
		} else if (paramS[0] == "z") {
			EXEffectMatRotateZ(ef,paramR[1]);
		} else if (paramS[0] == "height") { //高度
EXSetEffectZ(ef,paramR[1]);
		} else if (paramS[0] == "reset") { //恢复
EXEffectMatReset(ef);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		} else if (paramS[0] == "xl") { //设置一下s11的初始位置
xLi = paramR[1];
			BJDebugMsg("xLi"+":"+R2S(xLi));
		} else if (paramS[0] == "yl") { //设置一下s11的初始位置
yLi = paramR[1];
			BJDebugMsg("yLi"+":"+R2S(yLi));
		}
		p = null;
	}
	//blpend
	//blpend
	//blpend
	function onInit () {
		integer i;
		for (1 <= i <= 16) {
			CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() );
		}
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTEffectUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTEffectUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTEffectUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTEffectUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTEffectUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTEffectUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTEffectUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTEffectUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTEffectUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTEffectUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTEffectUtils10(GetTriggerPlayer());
			else if(str == "s11") TTestUTEffectUtils11(GetTriggerPlayer());
			else if(str == "s12") TTestUTEffectUtils12(GetTriggerPlayer());
			else if(str == "s13") TTestUTEffectUtils13(GetTriggerPlayer());
			else if(str == "s14") TTestUTEffectUtils14(GetTriggerPlayer());
			else if(str == "s15") TTestUTEffectUtils15(GetTriggerPlayer());
			else if(str == "s16") TTestUTEffectUtils16(GetTriggerPlayer());
			else if(str == "s17") TTestUTEffectUtils17(GetTriggerPlayer());
			else if(str == "s18") TTestUTEffectUtils18(GetTriggerPlayer());
			else if(str == "s19") TTestUTEffectUtils19(GetTriggerPlayer());
			else if(str == "s20") TTestUTEffectUtils20(GetTriggerPlayer());
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
