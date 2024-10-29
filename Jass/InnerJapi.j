#define CRNL <?='\n'?>  //因为这是二次wave的,所以这个宏定义得重定义一次


// API文档: https://japi.war3rpg.top/
/*

japi引用的常量库 由于wave宏定义 只对以下的代码有效

请将常量库里所有内容复制到  自定义脚本代码区
*/

//魔兽版本 用GetGameVersion 来获取当前版本 来对比以下具体版本做出相应操作
#define version_124b   6374
#define version_124e   6387
#define version_126    6401
#define version_127a   7000
#define version_127b   7085
#define version_128a   7205

//-----------模拟聊天------------------
#ifndef JapiOtherConstantIncluded
#define JapiOtherConstantIncluded
#define CHAT_RECIPIENT_ALL    0    // [所有人]
#define CHAT_RECIPIENT_ALLIES      1    // [盟友]
#define CHAT_RECIPIENT_OBSERVERS   2    // [观看者]
#define CHAT_RECIPIENT_REFEREES    2    // [裁判]
#define CHAT_RECIPIENT_PRIVATE     3    // [私人的]
#endif
//---------技能数据类型---------------

#ifndef JapiAbilityConstantIncluded
#define JapiAbilityConstantIncluded
//冷却时间
#define ABILITY_STATE_COOLDOWN 1

//目标允许
#define ABILITY_DATA_TARGS 100

//施放时间
#define ABILITY_DATA_CAST 101

//持续时间
#define ABILITY_DATA_DUR 102

//持续时间
#define ABILITY_DATA_HERODUR 103

//魔法消耗
#define ABILITY_DATA_COST 104

//施放间隔
#define ABILITY_DATA_COOL 105

//影响区域
#define ABILITY_DATA_AREA 106

//施法距离
#define ABILITY_DATA_RNG 107

//数据A
#define ABILITY_DATA_DATA_A 108

//数据B
#define ABILITY_DATA_DATA_B 109

//数据C
#define ABILITY_DATA_DATA_C 110

//数据D
#define ABILITY_DATA_DATA_D 111

//数据E
#define ABILITY_DATA_DATA_E 112

//数据F
#define ABILITY_DATA_DATA_F 113

//数据G
#define ABILITY_DATA_DATA_G 114

//数据H
#define ABILITY_DATA_DATA_H 115

//数据I
#define ABILITY_DATA_DATA_I 116

//单位类型
#define ABILITY_DATA_UNITID 117

//热键
#define ABILITY_DATA_HOTKET 200

//关闭热键
#define ABILITY_DATA_UNHOTKET 201

//学习热键
#define ABILITY_DATA_RESEARCH_HOTKEY 202

//名字
#define ABILITY_DATA_NAME 203

//图标
#define ABILITY_DATA_ART 204

//目标效果
#define ABILITY_DATA_TARGET_ART 205

//施法者效果
#define ABILITY_DATA_CASTER_ART 206

//目标点效果
#define ABILITY_DATA_EFFECT_ART 207

//区域效果
#define ABILITY_DATA_AREAEFFECT_ART 208

//投射物
#define ABILITY_DATA_MISSILE_ART 209

//特殊效果
#define ABILITY_DATA_SPECIAL_ART 210

//闪电效果
#define ABILITY_DATA_LIGHTNING_EFFECT 211

//buff提示
#define ABILITY_DATA_BUFF_TIP 212

//buff提示
#define ABILITY_DATA_BUFF_UBERTIP 213

//学习提示
#define ABILITY_DATA_RESEARCH_TIP 214

//提示
#define ABILITY_DATA_TIP 215

//关闭提示
#define ABILITY_DATA_UNTIP 216

//学习提示
#define ABILITY_DATA_RESEARCH_UBERTIP 217

//提示
#define ABILITY_DATA_UBERTIP 218

//关闭提示
#define ABILITY_DATA_UNUBERTIP 219

#define ABILITY_DATA_UNART 220

#define ABILITY_DATA_RESEARCH_ART 221

#endif


//----------物品数据类型----------------------

//物品图标
#define ITEM_DATA_ART 1

//物品提示
#define ITEM_DATA_TIP 2

//物品扩展提示
#define ITEM_DATA_UBERTIP 3

//物品名字
#define ITEM_DATA_NAME 4

//物品说明
#define ITEM_DATA_DESCRIPTION 5


//------------单位数据类型--------------
//攻击1 伤害骰子数量
#define UNIT_STATE_ATTACK1_DAMAGE_DICE 0x10

//攻击1 伤害骰子面数
#define UNIT_STATE_ATTACK1_DAMAGE_SIDE 0x11

//攻击1 基础伤害
#define UNIT_STATE_ATTACK1_DAMAGE_BASE 0x12

//攻击1 升级奖励
#define UNIT_STATE_ATTACK1_DAMAGE_BONUS 0x13

//攻击1 最小伤害
#define UNIT_STATE_ATTACK1_DAMAGE_MIN 0x14

//攻击1 最大伤害
#define UNIT_STATE_ATTACK1_DAMAGE_MAX 0x15

//攻击1 全伤害范围
#define UNIT_STATE_ATTACK1_RANGE 0x16

//装甲
#define UNIT_STATE_ARMOR 0x20

// attack 1 attribute adds
//攻击1 伤害衰减参数
#define UNIT_STATE_ATTACK1_DAMAGE_LOSS_FACTOR 0x21

//攻击1 武器声音
#define UNIT_STATE_ATTACK1_WEAPON_SOUND 0x22

//攻击1 攻击类型
#define UNIT_STATE_ATTACK1_ATTACK_TYPE 0x23

//攻击1 最大目标数
#define UNIT_STATE_ATTACK1_MAX_TARGETS 0x24

//攻击1 攻击间隔
#define UNIT_STATE_ATTACK1_INTERVAL 0x25

//攻击1 攻击延迟/summary>
#define UNIT_STATE_ATTACK1_INITIAL_DELAY 0x26

//攻击1 弹射弧度
#define UNIT_STATE_ATTACK1_BACK_SWING 0x28

//攻击1 攻击范围缓冲
#define UNIT_STATE_ATTACK1_RANGE_BUFFER 0x27

//攻击1 目标允许
#define UNIT_STATE_ATTACK1_TARGET_TYPES 0x29

//攻击1 溅出区域
#define UNIT_STATE_ATTACK1_SPILL_DIST 0x56

//攻击1 溅出半径
#define UNIT_STATE_ATTACK1_SPILL_RADIUS 0x57

//攻击1 武器类型
#define UNIT_STATE_ATTACK1_WEAPON_TYPE 0x58

// attack 2 attributes (sorted in a sequencial order based on memory address)
//攻击2 伤害骰子数量
#define UNIT_STATE_ATTACK2_DAMAGE_DICE 0x30

//攻击2 伤害骰子面数
#define UNIT_STATE_ATTACK2_DAMAGE_SIDE 0x31

//攻击2 基础伤害
#define UNIT_STATE_ATTACK2_DAMAGE_BASE 0x32

//攻击2 升级奖励
#define UNIT_STATE_ATTACK2_DAMAGE_BONUS 0x33

//攻击2 伤害衰减参数
#define UNIT_STATE_ATTACK2_DAMAGE_LOSS_FACTOR 0x34

//攻击2 武器声音
#define UNIT_STATE_ATTACK2_WEAPON_SOUND 0x35

//攻击2 攻击类型
#define UNIT_STATE_ATTACK2_ATTACK_TYPE 0x36

//攻击2 最大目标数
#define UNIT_STATE_ATTACK2_MAX_TARGETS 0x37

//攻击2 攻击间隔
#define UNIT_STATE_ATTACK2_INTERVAL 0x38

//攻击2 攻击延迟
#define UNIT_STATE_ATTACK2_INITIAL_DELAY 0x39

//攻击2 攻击范围
#define UNIT_STATE_ATTACK2_RANGE 0x40

//攻击2 攻击缓冲
#define UNIT_STATE_ATTACK2_RANGE_BUFFER 0x41

//攻击2 最小伤害
#define UNIT_STATE_ATTACK2_DAMAGE_MIN 0x42

//攻击2 最大伤害
#define UNIT_STATE_ATTACK2_DAMAGE_MAX 0x43

//攻击2 弹射弧度
#define UNIT_STATE_ATTACK2_BACK_SWING 0x44

//攻击2 目标允许类型
#define UNIT_STATE_ATTACK2_TARGET_TYPES 0x45

//攻击2 溅出区域
#define UNIT_STATE_ATTACK2_SPILL_DIST 0x46

//攻击2 溅出半径
#define UNIT_STATE_ATTACK2_SPILL_RADIUS 0x47

//攻击2 武器类型
#define UNIT_STATE_ATTACK2_WEAPON_TYPE 0x59

//装甲类型
#define UNIT_STATE_ARMOR_TYPE 0x50

#define UNIT_STATE_RATE_OF_FIRE 0x51 // global attack rate of unit, work on both attacks
#define UNIT_STATE_ACQUISITION_RANGE 0x52 // how far the unit will automatically look for targets
#define UNIT_STATE_LIFE_REGEN 0x53
#define UNIT_STATE_MANA_REGEN 0x54

#define UNIT_STATE_MIN_RANGE 0x55
#define UNIT_STATE_AS_TARGET_TYPE 0x60
#define UNIT_STATE_TYPE 0x61


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


