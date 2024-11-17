globals
//globals from AC:
constant boolean LIBRARY_AC=true
//endglobals from AC
//globals from InnerJapi:
constant boolean LIBRARY_InnerJapi=true
//endglobals from InnerJapi
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
trigger UnitTestFramwork__TUnitTest=null
//endglobals from UnitTestFramwork
//globals from Logger:
constant boolean LIBRARY_Logger=true
//endglobals from Logger
//globals from UTAC:
constant boolean LIBRARY_UTAC=true
//endglobals from UTAC
    // Generated
rect gg_rct_Wave1= null
rect gg_rct_Wave2= null
rect gg_rct_Wave3= null
rect gg_rct_Wave4= null
rect gg_rct_Base= null
rect gg_rct_BaseBack= null
rect gg_rct_Home1= null
rect gg_rct_Home2= null
rect gg_rct_Home3= null
rect gg_rct_Home4= null
rect gg_rct_Fuben1= null
rect gg_rct_Fuben2= null
rect gg_rct_Fuben3= null
rect gg_rct_Fuben4= null
rect gg_rct_Fuben5= null
rect gg_rct_Fuben6= null
rect gg_rct_Fuben7= null
rect gg_rct_Fuben8= null
trigger gg_trg_______u= null
unit gg_unit_hcas_0011= null

trigger l__library_init

//JASSHelper struct globals:
constant integer si__ac=1
integer si__ac_F=0
integer si__ac_I=0
integer array si__ac_V
integer s__ac_ethis=0
integer array s__ac_List
integer s__ac_size=0
hashtable s__ac_table=InitHashtable()
timer s__ac_t=null
real s__ac_lastTick=0
integer array s__ac_uID
trigger array s__ac_tr
real array s__ac_remainTime
real array s__ac_duration
boolean array s__ac_cycle
trigger st__ac_onDestroy
integer f__arg_this

endglobals


//Generated method caller for ac.onDestroy
function sc__ac_onDestroy takes integer this returns nothing
            call FlushChildHashtable(s__ac_table, this)
            call DestroyTrigger(s__ac_tr[this])
            set s__ac_tr[this]=null
endfunction

//Generated allocator of ac
function s__ac__allocate takes nothing returns integer
 local integer this=si__ac_F
    if (this!=0) then
        set si__ac_F=si__ac_V[this]
    else
        set si__ac_I=si__ac_I+1
        set this=si__ac_I
    endif
    if (this>8190) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Unable to allocate id for an object of type: ac")
        return 0
    endif

    set si__ac_V[this]=-1
 return this
endfunction

//Generated destructor of ac
function sc__ac_deallocate takes integer this returns nothing
    if this==null then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: ac")
        return
    elseif (si__ac_V[this]!=-1) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: ac")
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__ac_onDestroy)
    set si__ac_V[this]=si__ac_F
    set si__ac_F=this
endfunction

//library AC:
        function s__ac_isExist takes integer this returns boolean
            return ( this != null and si__ac_V[this] == - 1 )
        endfunction
        function s__ac_onDestroy takes integer this returns nothing
            call FlushChildHashtable(s__ac_table, this)
            call DestroyTrigger(s__ac_tr[this])
            set s__ac_tr[this]=null
        endfunction  // 注销当前任务

//Generated destructor of ac
function s__ac_deallocate takes integer this returns nothing
    if this==null then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: ac")
        return
    elseif (si__ac_V[this]!=-1) then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: ac")
        return
    endif
    call s__ac_onDestroy(this)
    set si__ac_V[this]=si__ac_F
    set si__ac_F=this
endfunction
        function s__ac_unreg takes integer this returns nothing
            if ( ( not ( s__ac_isExist(this) ) ) ) then
                call BJDebugMsg("error in unreg: AC is not exist")
                return
            endif //交换数据(以结构体形式)
            if ( s__ac_uID[this] != 0 ) then
                set s__ac_List[s__ac_uID[this]]=s__ac_List[s__ac_size]
                set s__ac_uID[s__ac_List[s__ac_uID[this]]]=s__ac_uID[this]
                set s__ac_size=s__ac_size - 1
                set s__ac_uID[this]=0
            endif
            call s__ac_deallocate(this)
        endfunction  // 将当前注册的所有任务转为字符串形式
        function s__ac_toString takes nothing returns string
            local string s=""
            local integer i
            local integer this
            set i=1
            loop
            exitwhen i > s__ac_size
                set this=s__ac_List[i]
                if ( s__ac_tr[this] == null ) then
                    set s=s + "[" + I2S(i) + "]null->"
                else
                    set s=s + "[" + I2S(this) + "]" + I2S(GetHandleId(s__ac_tr[this])) + "->"
                endif
            set i=i + 1
            endloop
            set s=s + "/"
            return "事件总数[" + I2S(s__ac_size) + "]:" + s
        endfunction  // 注册一个带数据绑定的定时任务
            function s__ac_anon__0 takes nothing returns nothing
                local integer i
                local integer this
                if ( s__ac_size > 0 ) then
                    set i=1
                    loop
                    exitwhen ( i > s__ac_size )
                        set this=s__ac_List[i] // 减去实际流逝的时间
                        set s__ac_remainTime[this]=s__ac_remainTime[this] - 0.1
                        if ( s__ac_remainTime[this] <= 0 ) then // 时间到
                            if ( s__ac_tr[this] != null ) then
                                set s__ac_ethis=this
                                call TriggerEvaluate(s__ac_tr[this])
                            endif // 循环任务
                            if ( s__ac_cycle[this] ) then // 重置时间
                                set s__ac_remainTime[this]=s__ac_duration[this] // 一次性任务
                            else
                                call s__ac_unreg(this)
                                set i=i - 1
                            endif
                        endif
                    set i=i + 1
                    endloop
                endif
                if ( s__ac_size <= 0 ) then
                    call PauseTimer(s__ac_t)
                    call DestroyTimer(s__ac_t)
                    set s__ac_t=null
                endif
            endfunction
        function s__ac_reg takes real duration,boolean b,code func returns integer
            local integer this=s__ac__allocate()
            if ( this <= 0 ) then
                return this
            endif
            set s__ac_cycle[this]=b
            set s__ac_remainTime[this]=duration
            set s__ac_duration[this]=duration
            set s__ac_tr[this]=CreateTrigger()
            call TriggerAddCondition(s__ac_tr[this], Condition(func))
            call FlushChildHashtable(s__ac_table, this)
            if ( s__ac_uID[this] == 0 ) then
                set s__ac_size=s__ac_size + 1
                set s__ac_List[s__ac_size]=this
                set s__ac_uID[this]=s__ac_size
            endif
            if ( s__ac_t == null ) then
                set s__ac_t=CreateTimer()
                call TimerStart(s__ac_t, 0.1, true, function s__ac_anon__0)
            endif
            return this
        endfunction  // 保存整数数据
        function s__ac_saveInt takes integer this,integer key,integer value returns nothing
            call SaveInteger(s__ac_table, this, key, value)
        endfunction  // 获取整数数据
        function s__ac_getInt takes integer this,integer key returns integer
            return LoadInteger(s__ac_table, this, key)
        endfunction

//library AC ends
//library InnerJapi:

    function EXExecuteScript takes string p1 returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 显示屏幕中间的 FPS 文本
    function ShowFpsText takes boolean show returns nothing
        call GetTriggeringTrigger()
    endfunction  // 异步获取 玩家当前的帧数
    function GetFps takes nothing returns real
        call GetTriggeringTrigger()
        return 0.0
    endfunction  // 解锁帧数上限 突破 60 帧
    function UnlockFps takes boolean is_unlock returns nothing
        call GetTriggeringTrigger()
    endfunction
    function GetCacheStringCount takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction
    function ReleaseString takes string str returns nothing
        call GetTriggeringTrigger()
    endfunction
    function ReleaseAllString takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction
    function DumpAllString takes string filename returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 用来清空魔兽的模型文件缓存 降低内存占用 直到下一次读取 才会重新占用。
    function ReleaseModel takes string model_path returns nothing
        call GetTriggeringTrigger()
    endfunction
    function ReleaseAllModel takes nothing returns nothing
        call GetTriggeringTrigger()
    endfunction
    function GetCacheModelCount takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 异步获取 获取当前指向单位 一般用来做 UI 操作时需要用到的接口,注意返回是异步的 handle，切记小心使用
    function GetTargetObject takes nothing returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 异步获取 当前玩家大头像模型的单位 当框选一群单位时 切换选择也会改变返回值 一般用来做 UI 操作时需要用到的接口
    function GetRealSelectUnit takes nothing returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 异步获取 玩家的聊天框是否被打开 一般用来做键盘操作时 避免与输入冲突
    function GetChatState takes nothing returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  //解锁 blp 贴图的像素上限 原本魔兽高清图片也会被限制在 512p 之内
    function UnlockBlpSize takes boolean is_unlock returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位名字 每个单位独立 互相不影响 修改后 获取单位名字 还是返回原值
    function SetUnitName takes unit u,string name returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位头像模型 设置之后会立即改变 当 设置单位模型时 会被新的自动覆盖掉
    function SetUnitPortrait takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道弧度 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileArc takes unit u,real value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道模型 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileModel takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道是否自动追踪 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileHoming takes unit u,boolean value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位普攻弹道速度 每个单位独立 互相不影响 会被法球覆盖
    function SetUnitMissileSpeed takes unit u,real value returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位模型 包括大头像模型也会自动设置 该接口 也可以给物品 特效 可破坏物 更换模型
    function SetUnitModel takes unit u,string model returns nothing
        call GetTriggeringTrigger()
    endfunction  //设置单位贴图 替换单位身上的 id 贴图 例如队伍颜色的 id 贴图是 0 队伍光晕 id 是 1
    function SetUnitTexture takes unit u,string texture,integer id returns nothing
        call GetTriggeringTrigger()
    endfunction  //隐藏单位跟物品 鼠标指向时显示的 UI 包括单位血条
    function SetUnitPressUIVisible takes unit u,boolean is_show returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效动画
    function EXSetEffectAnimation takes effect e,integer index returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效 X Y 轴坐标
    function EXSetEffectVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效是否在迷雾中可见
    function EXSetEffectFogVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效是否在阴影中可见
    function EXSetEffectMaskVisible takes effect e,boolean visible returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置特效颜色 透明值无效 16进制
    function EXSetEffectColor takes effect e,integer color returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取特效的颜色 跟 设置特效颜色 配合使用
    function EXGetEffectColor takes effect e returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 设置英雄称谓 每个单位独立 互相不影响 GetHeroProperName 获取英雄称谓 是修改后的值。
    function SetUnitProperName takes unit u,string name returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取指定商店 选择 指定玩家的哪个单位 返回值是同步的接口 可以安全使用
    function GetStoreTarget takes unit store,player p returns unit
        call GetTriggeringTrigger()
        return null
    endfunction  // 获取指定 frame 的子控件 不能对 simple 类型的控件使用
    function FrameGetChilds takes integer frame,boolean last returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取指定 frame 的父控件 不能对 simple 类型的控件使用 可以获取 大头像模型 的父控件 然后为其新建子控件 用来放置在所有界面之下
    function FrameGetParent takes integer frame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 全屏状态下 返回 false 窗口化模式 返回 true
    function IsWindowMode takes nothing returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  // 设置指定 frame 是否启用视口
    function FrameSetViewPort takes integer frame,boolean enable returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置窗口大小
    function SetWindowSize takes integer width,integer height returns nothing
        call GetTriggeringTrigger()
    endfunction  // 播放特效动画
    function EXPlayEffectAnimation takes effect e,string animation_name,string link_name returns nothing
        call GetTriggeringTrigger()
    endfunction  // 绑定特效
    function BindEffect takes widget u,string socket,effect e returns nothing
        call GetTriggeringTrigger()
    endfunction  // 解除特效绑定
    function UnBindEffect takes effect e returns nothing
        call GetTriggeringTrigger()
    endfunction  //内置默认是 解锁 frame 控件的 屏幕限制的 就是可以随便移动到屏幕之外的位置， 但是有个别用户 依赖这个限制 用网易的接口写了 ui 导致加了内置之后 位置变了， 故此新增这个接口 自行决定是否解锁。
    function SetFrameLimitScreen takes integer frame,boolean is_limit returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取当前玩家 id
    function GetUserId takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  //异步获取 当前玩家在 11 或网易平台游戏时的 uid， 本地返回 0
    function GetUserIdEx takes nothing returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 设置单位碰撞体积
    function SetUnitCollisionSize takes unit u,real size returns nothing
        call GetTriggeringTrigger()
    endfunction  // 设置单位移动类型
    function SetUnitMoveType takes unit u,string s returns nothing
        call GetTriggeringTrigger()
    endfunction  // 获取 框选按钮 slot 从0 ~ 11
    function FrameGetInfoSelectButton takes integer slot returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 下方buff按钮 slot 从0 ~ 7
    function FrameGetBuffButton takes integer slot returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 农民按钮
    function FrameGetUnitButton takes nothing returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 技能右下角数字文本控件 button = 技能按钮  返回值 = SimpleString 类型控件
    function FrameGetButtonSimpleString takes integer btn returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 获取 技能右下角控件  button = 技能按钮  返回值 = SimpleFrame 类型控件
    function FrameGetButtonSimpleFrame takes integer btn returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 判断控件是否显示
    function FrameIsShow takes integer frame returns boolean
        call GetTriggeringTrigger()
        return false
    endfunction  // 修改/获取 原生按钮图片 button 可以是 技能按钮 物品按钮 英雄按钮 农民按钮 框选按钮 buff按钮
    function FrameSetOriginButtonTexture takes integer btn,string path returns nothing
        call GetTriggeringTrigger()
    endfunction
    function FrameGetOriginButtonTexture takes integer btn returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 修改/获取 simple类型控件的 父控件
    function FrameGetSimpleParent takes integer SimpleFrame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction
    function FrameSetSimpleParent takes integer SimpleFrame,integer parentSimple returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 为Simple绑定 frame类型的子控件
    function FrameSimpleBindFrame takes integer SimpleFrame,integer Frame returns integer
        call GetTriggeringTrigger()
        return 0
    endfunction  // 解除绑定 解除后 frame跟simple 就不再关联
    function FrameSimpleUnBindFrame takes integer SetupFrame returns nothing
        call GetTriggeringTrigger()
    endfunction  //获取物品技能的 handle 返回值 可以用在 ydjapi 的技能接口
    function GetItemAbility takes item Item,integer slot returns ability
        call GetTriggeringTrigger()
        return null
    endfunction  // main 函数就初始化的
    function initializePlugin takes nothing returns integer
        call ExecuteFunc("DoNothing")
        call StartCampaignAI(Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback")
        call ExecuteFunc("DoNothing")
        call AbilityId("exec-lua:plugin_main")
        return 0
    endfunction  //显示内置Japi的版本
    function InnerJapi__GetPluginVersion takes nothing returns string
        call GetTriggeringTrigger()
        return ""
    endfunction  // 显示版本
        function InnerJapi__anon__0 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer id=GetHandleId(t)
            call BJDebugMsg("内置Japi" + InnerJapi__GetPluginVersion())
            call PauseTimer(t)
            call DestroyTimer(t)
            set t=null
        endfunction
    function InnerJapi__onInit takes nothing returns nothing
        local integer i=0
        local timer t
        set t=CreateTimer()
        call TimerStart(t, 0.0, false, function InnerJapi__anon__0)
        set t=null
    endfunction

//library InnerJapi ends
//library UnitTestFramwork:

    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest, func)
    endfunction
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号") //迷雾全关
                call CreateFogModifierRectBJ(true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect())
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.1)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__0))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library Logger:

    function Trace takes string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 调试级别日志(绿色),用于输出变量值等调试信息
    function Debug takes string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 信息级别日志(白色),用于输出普通提示信息
    function Info takes string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 警告级别日志(黄色),用于输出警告信息
    function Warn takes string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 错误级别日志(红色),用于输出错误信息
    function Error takes string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 向指定玩家输出追踪日志(灰色)
    function TraceToPlayer takes player p,string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 向指定玩家输出调试日志(绿色)
    function DebugToPlayer takes player p,string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 向指定玩家输出信息日志(白色)
    function InfoToPlayer takes player p,string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 向指定玩家输出警告日志(黄色)
    function WarnToPlayer takes player p,string msg returns nothing
        call GetTriggerUnit()
    endfunction  // 向指定玩家输出错误日志(红色)
    function ErrorToPlayer takes player p,string msg returns nothing
        call GetTriggerUnit()
    endfunction
    function Logger__onInit takes nothing returns nothing
        call AbilityId("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library UTAC:

        function UTAC__anon__0 takes nothing returns nothing
            local integer this=s__ac_ethis
            call Trace("[线程:" + I2S(this) + "] 一次性定时任务测试: 2秒后触发一次")
        endfunction
    function UTAC__TTestUTAC1 takes player p returns nothing
        call s__ac_reg(2.0 , false , function UTAC__anon__0)
    endfunction  // 测试循环定时任务
        function UTAC__anon__1 takes nothing returns nothing
            local integer this=s__ac_ethis
            call Trace("[线程:" + I2S(this) + "] 循环定时任务测试: 每1秒触发一次")
        endfunction
    function UTAC__TTestUTAC2 takes player p returns nothing
        local integer task=s__ac_reg(1.0 , true , function UTAC__anon__1)
        call Trace("已创建循环任务,ID:" + I2S(task))
    endfunction  // 测试数据绑定
        function UTAC__anon__2 takes nothing returns nothing
            local integer this=s__ac_ethis
            local integer count=s__ac_getInt(this,1) + 1
            call s__ac_saveInt(this,1 , count)
            call Trace("[线程:" + I2S(this) + "] 数据绑定测试: 当前计数 " + I2S(count))
        endfunction  // 初始化计数器
    function UTAC__TTestUTAC3 takes player p returns nothing
        local integer task=s__ac_reg(1.0 , true , function UTAC__anon__2)
        call s__ac_saveInt(task,1 , 0)
        call Trace("已创建带数据绑定的任务,ID:" + I2S(task))
    endfunction  // 测试任务注销
        function UTAC__anon__3 takes nothing returns nothing
            local integer this=s__ac_ethis
            call Trace("[线程:" + I2S(this) + "] 该消息只会显示一次,然后任务自动注销")
            call s__ac_unreg(this)
        endfunction
    function UTAC__TTestUTAC4 takes player p returns nothing
        local integer task=s__ac_reg(1.0 , true , function UTAC__anon__3)
    endfunction  // 打印当前任务列表
    function UTAC__TTestUTAC5 takes player p returns nothing
        call Trace(s__ac_toString())
    endfunction  // 其他测试函数保持空实现
    function UTAC__TTestUTAC6 takes player p returns nothing
    endfunction
    function UTAC__TTestUTAC7 takes player p returns nothing
    endfunction
    function UTAC__TTestUTAC8 takes player p returns nothing
    endfunction
    function UTAC__TTestUTAC9 takes player p returns nothing
    endfunction
    function UTAC__TTestUTAC10 takes player p returns nothing
    endfunction
    function UTAC__TTestActUTAC1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
        local integer count=0
        local integer task
        local string array paramS
        local integer array paramI
        local real array paramR
        set i=0
        loop
        exitwhen ( i > len - 1 )
            if ( SubString(str, i, i + 1) == " " ) then
                set paramS[num]=SubString(str, 0, i)
                set paramI[num]=S2I(paramS[num])
                set paramR[num]=S2R(paramS[num])
                set num=num + 1
                set str=SubString(str, i + 1, len)
                set len=StringLength(str)
                set i=- 1
            endif
        set i=i + 1
        endloop
        set paramS[num]=str
        set paramI[num]=S2I(paramS[num])
        set paramR[num]=S2R(paramS[num])
        set num=num + 1 // 处理命令
        if ( paramS[0] == "unreg" ) then
            set task=paramI[1]
            if ( s__ac_isExist(task) ) then
                call s__ac_unreg(task)
                call Trace("已注销任务 " + I2S(task))
            else
                call Trace("任务不存在")
            endif
        elseif ( paramS[0] == "unregAll" ) then // 从后往前遍历,避免数组重排带来的问题
            set i=s__ac_size
            loop
            exitwhen i < 1
                set task=s__ac_List[i]
                if ( s__ac_isExist(task) ) then
                    call s__ac_unreg(task)
                    set count=count + 1
                endif
            set i=i - 1
            endloop
            call Trace("已注销所有任务,共" + I2S(count) + "个")
        endif
        set p=null
    endfunction
        function UTAC__anon__4 takes nothing returns nothing
            call Trace("[AC] 单元测试已加载")
            call Trace("输入s1-s5测试不同功能")
            call Trace("-unreg [id] 可注销指定任务")
            call Trace("-unregAll 可注销所有任务")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTAC__anon__5 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubStringBJ(str, 1, 1) == "-" ) then
                call UTAC__TTestActUTAC1(SubStringBJ(str, 2, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTAC__TTestUTAC1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTAC__TTestUTAC2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTAC__TTestUTAC3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTAC__TTestUTAC4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTAC__TTestUTAC5(GetTriggerPlayer())
            endif
        endfunction
    function UTAC__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.5)
        call TriggerAddCondition(tr, Condition(function UTAC__anon__4))
        set tr=null
        call UnitTestRegisterChatEvent(function UTAC__anon__5)
    endfunction

//library UTAC ends

// API文档: https://japi.war3rpg.top/

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
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer8 takes nothing returns nothing
    local player p= Player(8)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_hcas_0011=CreateUnit(p, 'hcas', - 64.0, - 1984.0, 270.000)
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer8()
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings()
    call CreatePlayerUnits()
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_Wave1=Rect(- 5088.0, 3168.0, - 4448.0, 3968.0)
    set gg_rct_Wave2=Rect(- 1568.0, 3360.0, - 928.0, 4160.0)
    set gg_rct_Wave3=Rect(1312.0, 3584.0, 1952.0, 4384.0)
    set gg_rct_Wave4=Rect(4320.0, 3232.0, 4960.0, 4032.0)
    set gg_rct_Base=Rect(- 320.0, - 2304.0, 192.0, - 1664.0)
    set gg_rct_BaseBack=Rect(- 320.0, - 3328.0, 160.0, - 2848.0)
    set gg_rct_Home1=Rect(- 10496.0, 1440.0, - 8128.0, 3776.0)
    set gg_rct_Home2=Rect(7712.0, 1568.0, 10080.0, 3904.0)
    set gg_rct_Home3=Rect(- 10464.0, - 3680.0, - 8096.0, - 1344.0)
    set gg_rct_Home4=Rect(7712.0, - 3552.0, 10080.0, - 1216.0)
    set gg_rct_Fuben1=Rect(- 11872.0, 7968.0, - 8224.0, 11584.0)
    set gg_rct_Fuben2=Rect(- 5472.0, 8000.0, - 1824.0, 11616.0)
    set gg_rct_Fuben3=Rect(1184.0, 8000.0, 4832.0, 11616.0)
    set gg_rct_Fuben4=Rect(7712.0, 7968.0, 11360.0, 11584.0)
    set gg_rct_Fuben5=Rect(- 11872.0, - 11328.0, - 8224.0, - 7712.0)
    set gg_rct_Fuben6=Rect(- 5472.0, - 11328.0, - 1824.0, - 7712.0)
    set gg_rct_Fuben7=Rect(1184.0, - 11328.0, 4832.0, - 7712.0)
    set gg_rct_Fuben8=Rect(7712.0, - 11328.0, 11360.0, - 7712.0)
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
//函数入口
// 用原始地图测试
// 用空地图测试
// 用原始地图测试
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
    set gg_trg_______u=CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_______u, function Trig_______uActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_______u()
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation(Player(0), 0)
    call ForcePlayerStartLocation(Player(0), 0)
    call SetPlayerColor(Player(0), ConvertPlayerColor(0))
    call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(0), false)
    call SetPlayerController(Player(0), MAP_CONTROL_USER)
    // Player 1
    call SetPlayerStartLocation(Player(1), 1)
    call ForcePlayerStartLocation(Player(1), 1)
    call SetPlayerColor(Player(1), ConvertPlayerColor(1))
    call SetPlayerRacePreference(Player(1), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(1), false)
    call SetPlayerController(Player(1), MAP_CONTROL_USER)
    // Player 2
    call SetPlayerStartLocation(Player(2), 2)
    call ForcePlayerStartLocation(Player(2), 2)
    call SetPlayerColor(Player(2), ConvertPlayerColor(2))
    call SetPlayerRacePreference(Player(2), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(2), false)
    call SetPlayerController(Player(2), MAP_CONTROL_USER)
    // Player 3
    call SetPlayerStartLocation(Player(3), 3)
    call ForcePlayerStartLocation(Player(3), 3)
    call SetPlayerColor(Player(3), ConvertPlayerColor(3))
    call SetPlayerRacePreference(Player(3), RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(Player(3), false)
    call SetPlayerController(Player(3), MAP_CONTROL_USER)
    // Player 4
    call SetPlayerStartLocation(Player(4), 4)
    call ForcePlayerStartLocation(Player(4), 4)
    call SetPlayerColor(Player(4), ConvertPlayerColor(4))
    call SetPlayerRacePreference(Player(4), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(4), false)
    call SetPlayerController(Player(4), MAP_CONTROL_COMPUTER)
    // Player 5
    call SetPlayerStartLocation(Player(5), 5)
    call ForcePlayerStartLocation(Player(5), 5)
    call SetPlayerColor(Player(5), ConvertPlayerColor(5))
    call SetPlayerRacePreference(Player(5), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(5), false)
    call SetPlayerController(Player(5), MAP_CONTROL_COMPUTER)
    // Player 6
    call SetPlayerStartLocation(Player(6), 6)
    call ForcePlayerStartLocation(Player(6), 6)
    call SetPlayerColor(Player(6), ConvertPlayerColor(6))
    call SetPlayerRacePreference(Player(6), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(6), false)
    call SetPlayerController(Player(6), MAP_CONTROL_COMPUTER)
    // Player 7
    call SetPlayerStartLocation(Player(7), 7)
    call ForcePlayerStartLocation(Player(7), 7)
    call SetPlayerColor(Player(7), ConvertPlayerColor(7))
    call SetPlayerRacePreference(Player(7), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(7), false)
    call SetPlayerController(Player(7), MAP_CONTROL_COMPUTER)
    // Player 8
    call SetPlayerStartLocation(Player(8), 8)
    call ForcePlayerStartLocation(Player(8), 8)
    call SetPlayerColor(Player(8), ConvertPlayerColor(8))
    call SetPlayerRacePreference(Player(8), RACE_PREF_NIGHTELF)
    call SetPlayerRaceSelectable(Player(8), false)
    call SetPlayerController(Player(8), MAP_CONTROL_COMPUTER)
    // Player 9
    call SetPlayerStartLocation(Player(9), 9)
    call ForcePlayerStartLocation(Player(9), 9)
    call SetPlayerColor(Player(9), ConvertPlayerColor(9))
    call SetPlayerRacePreference(Player(9), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(9), false)
    call SetPlayerController(Player(9), MAP_CONTROL_COMPUTER)
    // Player 10
    call SetPlayerStartLocation(Player(10), 10)
    call ForcePlayerStartLocation(Player(10), 10)
    call SetPlayerColor(Player(10), ConvertPlayerColor(10))
    call SetPlayerRacePreference(Player(10), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(10), false)
    call SetPlayerController(Player(10), MAP_CONTROL_COMPUTER)
    // Player 11
    call SetPlayerStartLocation(Player(11), 11)
    call ForcePlayerStartLocation(Player(11), 11)
    call SetPlayerColor(Player(11), ConvertPlayerColor(11))
    call SetPlayerRacePreference(Player(11), RACE_PREF_UNDEAD)
    call SetPlayerRaceSelectable(Player(11), false)
    call SetPlayerController(Player(11), MAP_CONTROL_COMPUTER)
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_013
    call SetPlayerTeam(Player(0), 0)
    call SetPlayerTeam(Player(1), 0)
    call SetPlayerTeam(Player(2), 0)
    call SetPlayerTeam(Player(3), 0)
    call SetPlayerTeam(Player(4), 0)
    call SetPlayerTeam(Player(5), 0)
    call SetPlayerTeam(Player(6), 0)
    call SetPlayerTeam(Player(7), 0)
    call SetPlayerTeam(Player(8), 0)
    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(0), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(1), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(2), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(3), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(4), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(5), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(7), true)
    call SetPlayerAllianceStateAllyBJ(Player(6), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(7), Player(8), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(0), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(1), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(2), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(3), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(4), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(5), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(6), true)
    call SetPlayerAllianceStateAllyBJ(Player(8), Player(7), true)
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(0), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(1), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(2), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(3), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(4), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(5), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(7), true)
    call SetPlayerAllianceStateVisionBJ(Player(6), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(7), Player(8), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(0), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(1), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(2), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(3), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(4), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(5), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(6), true)
    call SetPlayerAllianceStateVisionBJ(Player(8), Player(7), true)
    // Force: TRIGSTR_014
    call SetPlayerTeam(Player(9), 1)
    call SetPlayerTeam(Player(10), 1)
    call SetPlayerTeam(Player(11), 1)
    //   Allied
    call SetPlayerAllianceStateAllyBJ(Player(9), Player(10), true)
    call SetPlayerAllianceStateAllyBJ(Player(9), Player(11), true)
    call SetPlayerAllianceStateAllyBJ(Player(10), Player(9), true)
    call SetPlayerAllianceStateAllyBJ(Player(10), Player(11), true)
    call SetPlayerAllianceStateAllyBJ(Player(11), Player(9), true)
    call SetPlayerAllianceStateAllyBJ(Player(11), Player(10), true)
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ(Player(9), Player(10), true)
    call SetPlayerAllianceStateVisionBJ(Player(9), Player(11), true)
    call SetPlayerAllianceStateVisionBJ(Player(10), Player(9), true)
    call SetPlayerAllianceStateVisionBJ(Player(10), Player(11), true)
    call SetPlayerAllianceStateVisionBJ(Player(11), Player(9), true)
    call SetPlayerAllianceStateVisionBJ(Player(11), Player(10), true)
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount(0, 3)
    call SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(0, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(1, 3)
    call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(1, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(2, 3)
    call SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(2, 2, 3, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrioCount(3, 3)
    call SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 1, 1, MAP_LOC_PRIO_HIGH)
    call SetStartLocPrio(3, 2, 2, MAP_LOC_PRIO_HIGH)
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call initializePlugin()
 call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs163975781")
call ExecuteFunc("InnerJapi__onInit")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("Logger__onInit")
call ExecuteFunc("UTAC__onInit")

    call InitGlobals()
    call InitCustomTriggers()
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName("TRIGSTR_1232")
    call SetMapDescription("TRIGSTR_1234")
    call SetPlayers(12)
    call SetTeams(12)
    call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    call DefineStartLocation(0, 0.0, 0.0)
    call DefineStartLocation(1, 0.0, 0.0)
    call DefineStartLocation(2, 0.0, 0.0)
    call DefineStartLocation(3, 0.0, 0.0)
    call DefineStartLocation(4, 0.0, 0.0)
    call DefineStartLocation(5, 0.0, 0.0)
    call DefineStartLocation(6, 0.0, 0.0)
    call DefineStartLocation(7, 0.0, 0.0)
    call DefineStartLocation(8, 0.0, 0.0)
    call DefineStartLocation(9, 0.0, 0.0)
    call DefineStartLocation(10, 0.0, 0.0)
    call DefineStartLocation(11, 0.0, 0.0)
    // Player setup
    call InitCustomPlayerSlots()
    call InitCustomTeams()
    call InitAllyPriorities()
endfunction




//Struct method generated initializers/callers:
function sa__ac_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call FlushChildHashtable(s__ac_table, this)
            call DestroyTrigger(s__ac_tr[this])
            set s__ac_tr[this]=null
   return true
endfunction

function jasshelper__initstructs163975781 takes nothing returns nothing
    set st__ac_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__ac_onDestroy,Condition( function sa__ac_onDestroy))


endfunction

