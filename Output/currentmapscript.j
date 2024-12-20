globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from GrowData:
constant boolean LIBRARY_GrowData=true
//endglobals from GrowData
//globals from LBKKAPI:
constant boolean LIBRARY_LBKKAPI=true
                string MOVE_TYPE_NONE = "none" //没有（无视碰撞）  
string MOVE_TYPE_FOOT = "foot" //步行  
string MOVE_TYPE_HORSE = "horse" //骑马  
string MOVE_TYPE_FLY = "fly" //飞行（还具有空中视野，也可以设置飞行高度）  
string MOVE_TYPE_HOVER = "hover" //浮空（不会踩中地雷）  
string MOVE_TYPE_FLOAT = "float" //漂浮（只能在深水里活动）  
string MOVE_TYPE_AMPH = "amph" //两栖  
string MOVE_TYPE_UNBUILD = "unbuild" //不可建造  
constant integer DEFENSE_TYPE_LIGHT = 0 
		constant integer DEFENSE_TYPE_MEDIUM = 1 
		constant integer DEFENSE_TYPE_LARGE = 2 
		constant integer DEFENSE_TYPE_FORT = 3 
		constant integer DEFENSE_TYPE_NORMAL = 4 
		constant integer DEFENSE_TYPE_HERO = 5 
		constant integer DEFENSE_TYPE_DIVINE = 6 
		constant integer DEFENSE_TYPE_NONE = 7 
//endglobals from LBKKAPI
//globals from MapBoundsUtils:
constant boolean LIBRARY_MapBoundsUtils=true
//endglobals from MapBoundsUtils
//globals from MathUtils:
constant boolean LIBRARY_MathUtils=true
//endglobals from MathUtils
//globals from UIAnimTimer:
constant boolean LIBRARY_UIAnimTimer=true
//endglobals from UIAnimTimer
//globals from UIEventModule:
constant boolean LIBRARY_UIEventModule=true
//endglobals from UIEventModule
//globals from UIHashTable:
constant boolean LIBRARY_UIHashTable=true
    hashtable HASH_UI=InitHashtable()
    integer UIHashTable__frame=0
//endglobals from UIHashTable
//globals from UIId:
constant boolean LIBRARY_UIId=true
//endglobals from UIId
//globals from UIImageModule:
constant boolean LIBRARY_UIImageModule=true
//endglobals from UIImageModule
//globals from UILifeCycle:
constant boolean LIBRARY_UILifeCycle=true
//endglobals from UILifeCycle
//globals from UITextModule:
constant boolean LIBRARY_UITextModule=true
//endglobals from UITextModule
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
    trigger UnitTestFramwork__TUnitTest=null
//endglobals from UnitTestFramwork
//globals from Hardware:
constant boolean LIBRARY_Hardware=true
//endglobals from Hardware
//globals from UITocInit:
constant boolean LIBRARY_UITocInit=true
//endglobals from UITocInit
//globals from UIUtils:
constant boolean LIBRARY_UIUtils=true
//endglobals from UIUtils
//globals from BaseAnim:
constant boolean LIBRARY_BaseAnim=true
//endglobals from BaseAnim
//globals from UIBaseModule:
constant boolean LIBRARY_UIBaseModule=true
//endglobals from UIBaseModule
//globals from UIExtendEvent:
constant boolean LIBRARY_UIExtendEvent=true
//endglobals from UIExtendEvent
//globals from UIExtendResize:
constant boolean LIBRARY_UIExtendResize=true
//endglobals from UIExtendResize
//globals from UILayer:
constant boolean LIBRARY_UILayer=true
//endglobals from UILayer
//globals from UIButton:
constant boolean LIBRARY_UIButton=true
//endglobals from UIButton
//globals from UIImage:
constant boolean LIBRARY_UIImage=true
//endglobals from UIImage
//globals from UISprite:
constant boolean LIBRARY_UISprite=true
//endglobals from UISprite
//globals from UIText:
constant boolean LIBRARY_UIText=true
//endglobals from UIText
//globals from ProgressAnim:
constant boolean LIBRARY_ProgressAnim=true
//endglobals from ProgressAnim
//globals from Icon:
constant boolean LIBRARY_Icon=true
//endglobals from Icon
//globals from SpellBtns:
constant boolean LIBRARY_SpellBtns=true
//endglobals from SpellBtns
//globals from UTSpellBtns:
constant boolean LIBRARY_UTSpellBtns=true
    boolean UTSpellBtns__shadeVisible=false
    boolean UTSpellBtns__isInside=false
    boolean UTSpellBtns__isGrow=false
//endglobals from UTSpellBtns
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

trigger l__library_init
endglobals
//library BzAPI:
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
    

//library BzAPI ends
//library GrowData:
    struct growdata extends array
    //! pragma implicitthis
        //public:  //帧数周期
            integer max  //播放间隔
            integer gap  //UI放大的倍数
            real scale  //文件路径
            string path
        static method onInit takes nothing returns nothing  //# sequence: ui/icongrow/ig1_{0-63}.blp
            set thistype[1].max=63  //# sequence: ui/icongrow/ig2_{0-11}.blp
            set thistype[1].gap=2
            set thistype[1].scale=2.65
            set thistype[1].path="ui\\icongrow\\ig1_"
            set thistype[2].max=11  //# sequence: ui/icongrow/ig3_{0-13}.blp
            set thistype[2].gap=3
            set thistype[2].scale=1.4
            set thistype[2].path="ui\\icongrow\\ig2_"
            set thistype[3].max=13  //# sequence: ui/icongrow/ig4_{0-14}.blp
            set thistype[3].gap=3
            set thistype[3].scale=1.48
            set thistype[3].path="ui\\icongrow\\ig3_"
            set thistype[4].max=14  //# sequence: ui/icongrow/ig5_{0-15}.blp
            set thistype[4].gap=3
            set thistype[4].scale=1.25
            set thistype[4].path="ui\\icongrow\\ig4_"
            set thistype[5].max=15  //# sequence: ui/icongrow/ig6_{0-23}.blp
            set thistype[5].gap=4
            set thistype[5].scale=1.66
            set thistype[5].path="ui\\icongrow\\ig5_"
            set thistype[6].max=23  //# sequence: ui/icongrow/ig7_{0-11}.blp
            set thistype[6].gap=3
            set thistype[6].scale=1.8
            set thistype[6].path="ui\\icongrow\\ig6_"
            set thistype[7].max=11  //# sequence: ui/icongrow/ig8_{0-11}.blp
            set thistype[7].gap=4
            set thistype[7].scale=2.0
            set thistype[7].path="ui\\icongrow\\ig7_"
            set thistype[8].max=11  //# sequence: ui/icongrow/ig9_{0-11}.blp
            set thistype[8].gap=4
            set thistype[8].scale=2.0
            set thistype[8].path="ui\\icongrow\\ig8_"
            set thistype[9].max=11  //# sequence: ui/icongrow/ig10_{0-15}.blp
            set thistype[9].gap=4
            set thistype[9].scale=2.0
            set thistype[9].path="ui\\icongrow\\ig9_"
            set thistype[10].max=15  //# sequence: ui/icongrow/ig11_{0-11}.blp
            set thistype[10].gap=3
            set thistype[10].scale=1.22
            set thistype[10].path="ui\\icongrow\\ig10_"
            set thistype[11].max=11  //# sequence: ui/icongrow/ig12_{0-11}.blp
            set thistype[11].gap=4
            set thistype[11].scale=2.0
            set thistype[11].path="ui\\icongrow\\ig11_"
            set thistype[12].max=11
            set thistype[12].gap=4
            set thistype[12].scale=2.0
            set thistype[12].path="ui\\icongrow\\ig12_"
        endmethod
    endstruct

//library GrowData ends
//library LBKKAPI:
        native DzGetSelectedLeaderUnit takes nothing returns unit 
        native DzIsChatBoxOpen takes nothing returns boolean 
        native DzSetUnitPreselectUIVisible takes unit whichUnit, boolean visible returns nothing 
        native DzSetEffectAnimation takes effect whichEffect, integer index, integer flag returns nothing 
        native DzSetEffectPos takes effect whichEffect, real x, real y, real z returns nothing 
        native DzSetEffectVertexColor takes effect whichEffect, integer color returns nothing 
        native DzSetEffectVertexAlpha takes effect whichEffect, integer alpha returns nothing 
        native DzSetEffectModel takes effect whichEffect, string model returns nothing
        native DzSetEffectTeamColor takes effect whichHandle, integer playerId returns nothing
        native DzFrameSetClip takes integer whichframe, boolean enable returns nothing 
        native DzChangeWindowSize takes integer width, integer height returns boolean 
        native DzPlayEffectAnimation takes effect whichEffect, string anim, string link returns nothing 
        native DzBindEffect takes widget parent, string attachPoint, effect whichEffect returns nothing 
        native DzUnbindEffect takes effect whichEffect returns nothing 
        native DzSetWidgetSpriteScale takes widget whichUnit, real scale returns nothing 
        native DzSetEffectScale takes effect whichHandle, real scale returns nothing 
        native DzGetEffectVertexColor takes effect whichEffect returns integer 
        native DzGetEffectVertexAlpha takes effect whichEffect returns integer 
        native DzGetItemAbility takes item whichEffect, integer index returns ability 
        native DzFrameGetChildrenCount takes integer whichframe returns integer 
        native DzFrameGetChild takes integer whichframe, integer index returns integer 
        native DzUnlockBlpSizeLimit takes boolean enable returns nothing 
        native DzGetActivePatron takes unit store, player p returns unit 
        native DzGetLocalSelectUnitCount takes nothing returns integer 
        native DzGetLocalSelectUnit takes integer index returns unit 
        native DzGetJassStringTableCount takes nothing returns integer 
        native DzModelRemoveFromCache takes string path returns nothing 
        native DzModelRemoveAllFromCache takes nothing returns nothing 
        native DzFrameGetInfoPanelSelectButton takes integer index returns integer 
        native DzFrameGetInfoPanelBuffButton takes integer index returns integer 
        native DzFrameGetPeonBar takes nothing returns integer 
        native DzFrameGetCommandBarButtonNumberText takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonNumberOverlay takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonCooldownIndicator takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonAutoCastIndicator takes integer whichframe returns integer 
        native DzToggleFPS takes boolean show returns nothing 
        native DzGetFPS takes nothing returns integer 
        native DzFrameWorldToMinimapPosX takes real x, real y returns real 
        native DzFrameWorldToMinimapPosY takes real x, real y returns real 
        native DzWidgetSetMinimapIcon takes unit whichunit, string path returns nothing 
        native DzWidgetSetMinimapIconEnable takes unit whichunit, boolean enable returns nothing 
        native DzFrameGetWorldFrameMessage takes nothing returns integer 
        native DzSimpleMessageFrameAddMessage takes integer whichframe, string text, integer color, real duration, boolean permanent returns nothing 
        native DzSimpleMessageFrameClear takes integer whichframe returns nothing 
        //转换屏幕坐标到世界坐标  
        native DzConvertScreenPositionX takes real x, real y returns real 
        native DzConvertScreenPositionY takes real x, real y returns real 
        //监听建筑选位置  
        native DzRegisterOnBuildLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnBuildOrderId takes nothing returns integer 
        native DzGetOnBuildOrderType takes nothing returns integer 
        native DzGetOnBuildAgent takes nothing returns widget 
        //监听技能选目标  
        native DzRegisterOnTargetLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnTargetAbilId takes nothing returns integer 
        native DzGetOnTargetOrderId takes nothing returns integer 
        native DzGetOnTargetOrderType takes nothing returns integer 
        native DzGetOnTargetAgent takes nothing returns widget 
        native DzGetOnTargetInstantTarget takes nothing returns widget 
        // 打开QQ群链接  
        native DzOpenQQGroupUrl takes string url returns boolean 
        native DzFrameEnableClipRect takes boolean enable returns nothing 
        native DzSetUnitName takes unit whichUnit, string name returns nothing 
        native DzSetUnitPortrait takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitDescription takes unit whichUnit, string value returns nothing 
        native DzSetUnitMissileArc takes unit whichUnit, real arc returns nothing 
        native DzSetUnitMissileModel takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitProperName takes unit whichUnit, string name returns nothing 
        native DzSetUnitMissileHoming takes unit whichUnit, boolean enable returns nothing 
        native DzSetUnitMissileSpeed takes unit whichUnit, real speed returns nothing 
        native DzSetEffectVisible takes effect whichHandle, boolean enable returns nothing 
        native DzReviveUnit takes unit whichUnit, player whichPlayer, real hp, real mp, real x, real y returns nothing 
        native DzGetAttackAbility takes unit whichUnit returns ability 
        native DzAttackAbilityEndCooldown takes ability whichHandle returns nothing 
        native EXSetUnitArrayString takes integer uid, integer id, integer n, string name returns boolean 
        native EXSetUnitInteger takes integer uid, integer id, integer n returns boolean 
        function DzSetHeroTypeProperName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 61, 0, name) 
                call EXSetUnitInteger(uid, 61, 1) 
        endfunction 
        function DzSetUnitTypeName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 10, 0, name) 
                call EXSetUnitInteger(uid, 10, 1) 
        endfunction 
        function DzIsUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns boolean 
                return ConvertAttackType(R2I(GetUnitState(whichUnit, ConvertUnitState(16 + 19 * index)))) == attackType 
        endfunction 
        function DzSetUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(16 + 19 * index), GetHandleId(attackType)) 
        endfunction 
        function DzIsUnitDefenseType takes unit whichUnit, integer defenseType returns boolean 
                return R2I(GetUnitState(whichUnit, ConvertUnitState(0x50))) == defenseType 
        endfunction 
        function DzSetUnitDefenseType takes unit whichUnit, integer defenseType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(0x50), defenseType) 
        endfunction 
        // 地形装饰物
        native DzDoodadCreate takes integer id, integer var, real x, real y, real z, real rotate, real scale returns integer 
        native DzDoodadGetTypeId takes integer doodad returns integer 
        native DzDoodadSetModel takes integer doodad, string modelFile returns nothing 
        native DzDoodadSetTeamColor takes integer doodad, integer color returns nothing 
        native DzDoodadSetColor takes integer doodad, integer color returns nothing 
        native DzDoodadGetX takes integer doodad returns real 
        native DzDoodadGetY takes integer doodad returns real 
        native DzDoodadGetZ takes integer doodad returns real 
        native DzDoodadSetPosition takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixRotate takes integer doodad, real angle, real axisX, real axisY, real axisZ returns nothing 
        native DzDoodadSetOrientMatrixScale takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixResize takes integer doodad returns nothing 
        native DzDoodadSetVisible takes integer doodad, boolean enable returns nothing 
        native DzDoodadSetAnimation takes integer doodad, string animName, boolean animRandom returns nothing 
        native DzDoodadSetTimeScale takes integer doodad, real scale returns nothing 
        native DzDoodadGetTimeScale takes integer doodad returns real 
        native DzDoodadGetCurrentAnimationIndex takes integer doodad returns integer 
        native DzDoodadGetAnimationCount takes integer doodad returns integer 
        native DzDoodadGetAnimationName takes integer doodad, integer index returns string 
        native DzDoodadGetAnimationTime takes integer doodad, integer index returns integer 
        // 解锁JASS字节码限制
        native DzUnlockOpCodeLimit takes boolean enable returns nothing
        // 设置剪切板内容
        native DzSetClipboard takes string content returns boolean
        //删除装饰物
        native DzDoodadRemove takes integer doodad returns nothing
        //移除科技等级
        native DzRemovePlayerTechResearched takes player whichPlayer, integer techid, integer removelevels returns nothing
        
        // 查找单位技能
        native DzUnitFindAbility takes unit whichUnit, integer abilcode returns ability
        // 修改技能数据-字符串
        native DzAbilitySetStringData takes ability whichAbility, string key, string value returns nothing
                
        // 启用/禁用技能
        native DzAbilitySetEnable takes ability whichAbility, boolean enable, boolean hideUI returns nothing
        // 设置单位移动类型
        native DzUnitSetMoveType takes unit whichUnit, string moveType returns nothing
        // 获取控件宽度
        native DzFrameGetWidth takes integer frame returns real
        native DzFrameSetAnimateByIndex takes integer frame, integer index, integer flag returns nothing
        native DzSetUnitDataCacheInteger takes integer uid, integer id,integer index,integer v returns nothing
        native DzUnitUIAddLevelArrayInteger takes integer uid, integer id,integer lv,integer v returns nothing
        function KKWESetUnitDataCacheInteger takes integer uid,integer id,integer v returns nothing
                call DzSetUnitDataCacheInteger( uid, id, 0, v)
        endfunction
        function KKWEUnitUIAddUpgradesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 94, id, v)
        endfunction
        function KKWEUnitUIAddBuildsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 100, id, v)
        endfunction
        function KKWEUnitUIAddResearchesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 112, id, v)
        endfunction
        function KKWEUnitUIAddTrainsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 106, id, v)
        endfunction
        function KKWEUnitUIAddSellsUnitIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 118, id, v)
        endfunction
        function KKWEUnitUIAddSellsItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 124, id, v)
        endfunction
        function KKWEUnitUIAddMakesItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 130, id, v)
        endfunction
        function KKWEUnitUIAddRequiresUnitCode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresTechcode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction
        function KKWEUnitUIAddRequiresAmounts takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 172, id, v)
        endfunction
         // 设置道具模型
        native DzItemSetModel takes item whichItem, string file returns nothing
        // 设置道具颜色
        native DzItemSetVertexColor takes item whichItem, integer color returns nothing
        // 设置道具透明度
        native DzItemSetAlpha takes item whichItem, integer color returns nothing
        // 设置道具头像
        native DzItemSetPortrait takes item whichItem, string modelPath returns nothing

//library LBKKAPI ends
//library MapBoundsUtils:
    struct mapBounds 
    //! pragma implicitthis
        static real maxX=0.
        static real minX=0.
        static real maxY=0.
        static real minY=0.  // 限制X坐标在地图范围内
        static method X takes real x returns real
            return RMinBJ(RMaxBJ(x,mapBounds.minX),mapBounds.maxX)
        endmethod  // 限制Y坐标在地图范围内
        static method Y takes real y returns real
            return RMinBJ(RMaxBJ(y,mapBounds.minY),mapBounds.maxY)
        endmethod  // 初始化
        static method onInit takes nothing returns nothing
            set mapBounds.minX=GetCameraBoundMinX()-GetCameraMargin(CAMERA_MARGIN_LEFT)
            set mapBounds.minY=GetCameraBoundMinY()-GetCameraMargin(CAMERA_MARGIN_BOTTOM)
            set mapBounds.maxX=GetCameraBoundMaxX()+GetCameraMargin(CAMERA_MARGIN_RIGHT)
            set mapBounds.maxY=GetCameraBoundMaxY()+GetCameraMargin(CAMERA_MARGIN_TOP)
        endmethod
    endstruct

//library MapBoundsUtils ends
//library MathUtils:
    function R2IRandom takes real value returns integer  // 将实数转换为整数，若小数部分大于随机数则进1
        if (GetRandomReal(0,1.0)<=ModuloReal(value,1.0))then
            return R2I(value)+1
        endif
        return R2I(value)
    endfunction  // 进行整数除法，若能整除则结果减1
    function Divide1 takes integer i1,integer i2 returns integer
        if (ModuloInteger(i1,i2)==0)then
            return i1/i2-1
        endif
        return i1/i2
    endfunction  // 实现特殊的数值叠加计算，主要用于游戏中各种加成效果的叠加
    function RealAdd takes real a1,real a2 returns real  // 该函数可以避免简单线性相加导致的数值溢出，保证叠加后的效果符合递减收益原则 // // 特点： // - 正数叠加时使用概率学公式：1-(1-a1)*(1-a2) // - 负数叠加时使用衰减公式：1-(1-a1)/(1+a2) // - 当第二个参数绝对值>=1.0时，直接返回第一个参数 // // 适用场景： // - 技能冷却缩减叠加（CDR） // - 暴击率、闪避率等概率性属性叠加 // - 移速加成等需要控制上限的属性叠加 // // 参数说明： // a1: 第一个数值，通常表示当前已有的加成效果 // a2: 第二个数值，表示要叠加的新加成效果 // 返回值: 叠加后的最终效果值 // // 使用示例： // real currentCDR = 0.4;    // 当前40%冷却缩减 // real newCDR = 0.5;        // 新装备50%冷却缩减 // real finalCDR = RealAdd(currentCDR, newCDR);  // 结果约为0.7，即70%冷却缩减 // // 注意事项： // 1. 虽然函数支持任意实数输入，但建议输入值在[-1.0, 1.0]范围内 // 2. 当|a2| >= 1.0时，函数会直接返回a1值 // 3. 该函数满足结合律，但不满足交换律，建议将已有效果作为第一个参数 // 4. 已测试过可以在用负数叠加后,使用负数的绝对值进行恢复
        if (RAbsBJ(a2)>=1.0)then
            return a1
        endif
        if (a2>=0)then
            return 1.0-(1.0-a1)*(1.0-a2)
        else
            return 1.0-(1.0-a1)/(1.0+a2)
        endif
    endfunction  // 最小最大值限制
    function ILimit takes integer target,integer min,integer max returns integer  // 限制整数在[min, max]范围内
        if (target<min)then
            return min
        elseif (target>max)then
            return max
        else
            return target
        endif
    endfunction  // 最小最大值限制
    function RLimit takes real target,real min,real max returns real  // 限制实数在[min, max]范围内
        if (target<min)then
            return min
        elseif (target>max)then
            return max
        else
            return target
        endif
    endfunction  // 四舍五入法实数转整数
    function R2IM takes real r returns integer  // 将实数四舍五入为整数
        if (ModuloReal(r,1.0)>=0.5)then
            return R2I(r)+1
        else
            return R2I(r)
        endif
    endfunction  // 计算射线与地图边界的交点
    struct radiationEnd   // 计算从给定点出发的射线与地图边界的交点
    //! pragma implicitthis
        static real x=0  // 一个坐标沿着某个方向的边缘值
        static real y=0
        static method cal takes real x1,real y1,real angle returns nothing  // 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点 //相交点
            local real x2=0  //相交点
            local real y2=0  //求余数
            local real a=ModuloReal(angle,360)
            local real tan
            set x=0
            set y=0  // 处理特殊角度
            if (a==0)then  // 正右方
                set x=mapBounds.maxX
                set y=y1
                return
            endif  // 正上方
            if (a==90)then
                set x=x1
                set y=mapBounds.maxY
                return
            endif  // 正左方
            if (a==180)then
                set x=mapBounds.minX
                set y=y1
                return
            endif  // 正下方
            if (a==270)then
                set x=x1
                set y=mapBounds.minY
                return
            endif  // 处理一般角度
            if (a<90)then  //第一象限
                set tan=TanBJ(a)
                set x2=(mapBounds.maxY-y1)/tan+x1
                set y2=(mapBounds.maxX-x1)*tan+y1  //取这个
                if (x2<=mapBounds.maxX)then
                    set x=x2
                    set y=mapBounds.maxY
                else
                    set x=mapBounds.maxX
                    set y=y2
                endif  //第二象限
            elseif (a<180)then
                set tan=TanBJ(a)
                set x2=(mapBounds.maxY-y1)/tan+x1
                set y2=(mapBounds.minX-x1)*tan+y1  //取这个
                if (x2>=mapBounds.minX)then
                    set x=x2
                    set y=mapBounds.maxY
                else
                    set x=mapBounds.minX
                    set y=y2
                endif  //第三象限
            elseif (a<270)then
                set tan=TanBJ(a)
                set x2=(mapBounds.minY-y1)/tan+x1
                set y2=(mapBounds.minX-x1)*tan+y1  //取这个
                if (x2>=mapBounds.minX)then
                    set x=x2
                    set y=mapBounds.minY
                else
                    set x=mapBounds.minX
                    set y=y2
                endif  //第四象限
            else
                set tan=TanBJ(a)
                set x2=(mapBounds.minY-y1)/tan+x1
                set y2=(mapBounds.maxX-x1)*tan+y1  //取这个
                if (x2<=mapBounds.maxX)then
                    set x=x2
                    set y=mapBounds.minY
                else
                    set x=mapBounds.maxX
                    set y=y2
                endif
            endif
        endmethod
    endstruct

//library MathUtils ends
//library UIAnimTimer:
    struct uianim   //随便建,但是要reg与unreg才会生效[建只占用个int]影响不大 //不需要destroy //静态成员[trigNum]
    //! pragma implicitthis
        static thistype  array UIAList
        static integer size=0
        trigger trig  //这个是动画在列表中的ID
        integer trID
        method isExist takes nothing returns boolean  //这个只能同步创建,不能异步创建
            return (this!=null and si__uianim_V[this]==-1)
        endmethod
        static method create takes code fun returns thistype
            local thistype this=allocate()
            set trig=CreateTrigger()
            call TriggerAddCondition(trig,Condition(fun))
            return this
        endmethod  //动画启动,可重复调用
        method reg takes nothing returns nothing
            if (not (this.isExist()))then
                return
            endif
            if (trID==0)then
                set size=size+1
                set UIAList[size]=this
                set trID=size
            endif
        endmethod  //关
        method unreg takes nothing returns nothing
            if (trID!=0)then  //这个其实就是将List的[2]设成5  假设2是删  5是最长
                set UIAList[trID]=UIAList[size]  //然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立) //但是实例[2]本身的内容已经被清除 循环读的是List不受影响(虽然List[5]还是5但是无影响)
                set UIAList[trID].trID=trID
                set size=size-1
                set trID=0
            endif
        endmethod  //共享打印方法
        static method toString takes nothing returns string
            local string s=I2S(size)+"个:"
            local integer i
            set i=1
            loop
            exitwhen (i>size)
                set s=s+"["+I2S(i)+"]|r"+I2S(UIAList[i])+"->"
            set i = i+1
            endloop
            set s=s+"/"
            return s
        endmethod
            private static method anon__0 takes nothing returns nothing  //计时器运行中
                local integer i
                local integer this
                if (size>0)then
                    set i=1
                    loop
                    exitwhen (i>size)
                        set this=UIAList[i]  //这里可以设置一个静态成员来传参获得是第几个uia
                        call TriggerEvaluate(trig)
                    set i = i+1
                    endloop
                endif
            endmethod
        static method onInit takes nothing returns nothing
            local timer t=CreateTimer()
            call TimerStart(t,0.02,true,function thistype.anon__0)
            set t=null
        endmethod
    endstruct

//library UIAnimTimer ends
//library UIEventModule:
    module uiEventModule  // 鼠标进入事件
        method onMouseEnter takes code fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScriptByCode(ui,2,fun,false)
            return this
        endmethod  // 鼠标离开事件
        method onMouseLeave takes code fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScriptByCode(ui,3,fun,false)
            return this
        endmethod  // 鼠标松开事件,和点击一样,基本可以当相同事件
        method onMouseClick takes code fun returns thistype  // method onMouseUp (code fun) -> thistype { //     if (!this.isExist()) {return this;} //     DzFrameSetScriptByCode(ui,FRAME_MOUSE_UP,fun,false); //     return this; // } // 鼠标点击事件(效果和FRAME_MOUSE_UP一样,注释掉上面这个了)
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScriptByCode(ui,1,fun,false)
            return this
        endmethod  // 鼠标滚轮事件
        method onMouseWheel takes code fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScriptByCode(ui,6,fun,false)
            return this
        endmethod  // 鼠标双击事件
        method onMouseDoubleClick takes code fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScriptByCode(ui,12,fun,false)
            return this
        endmethod  //扩展事件
        implement optional extendEvent
    endmodule

//library UIEventModule ends
//library UIHashTable:
    function uiHashTable takes integer f returns UIHashTable__uiHT
        set UIHashTable__frame=f
        return UIHashTable__uiHT[0]
    endfunction  //私有
    struct UIHashTable__uiHT extends array  //方便链式调用  uiHashTable(frame).eventdata.bind(8174);
    //! pragma implicitthis
        UIHashTable__uiHTEvent eventdata  //方便链式调用  uiHashTable(frame).ui.bind(8174);
        UIHashTable__uiHTFrame ui
    endstruct  // 子结构体函数
    struct UIHashTable__uiHTFrame extends array  // 绑定UI实例到frame
    //! pragma implicitthis
        method bind takes integer typeID,integer ui returns nothing
            call SaveInteger(HASH_UI,UIHashTable__frame,1820,typeID)
            call SaveInteger(HASH_UI,UIHashTable__frame,1821,ui)
        endmethod  // 从frame获取UI实例
        method get takes nothing returns integer
            return LoadInteger(HASH_UI,UIHashTable__frame,1821)
        endmethod  // 从frame获取UI类型
        method getType takes nothing returns integer
            return LoadInteger(HASH_UI,UIHashTable__frame,1820)
        endmethod
    endstruct  // 子结构体函数
    struct UIHashTable__uiHTEvent extends array
    //! pragma implicitthis
        method bind takes integer value returns nothing
            call SaveInteger(HASH_UI,UIHashTable__frame,1823,value)
        endmethod
        method get takes nothing returns integer
            return LoadInteger(HASH_UI,UIHashTable__frame,1823)
        endmethod
    endstruct

//library UIHashTable ends
//library UIId:
    struct uiId extends array
    //! pragma implicitthis
        static hashtable ht
        static integer nextId
        static integer recycleCount
        static method onInit takes nothing returns nothing
            set thistype.ht=InitHashtable()
            set thistype.nextId=1
            set thistype.recycleCount=0
        endmethod
        static method get takes nothing returns integer
            local integer id  // 如果有已回收的ID，优先使用
            if (recycleCount>0)then  // 获取最后一个回收的ID
                set id=LoadInteger(ht,1,recycleCount-1)  // 从回收池中删除这个ID
                call RemoveSavedInteger(ht,1,recycleCount-1)  // 从状态表中删除
                call RemoveSavedBoolean(ht,2,id)
                set recycleCount=recycleCount-1
                return id
            endif  // 如果没有可复用的ID，返回新的ID
            set id=nextId
            set nextId=nextId+1
            return id
        endmethod
        static method recycle takes integer id returns nothing  // 快速检查ID是否已经在回收池中
            if (not (HaveSavedBoolean(ht,2,id)))then  // 将ID存入回收池
                call SaveInteger(ht,1,recycleCount,id)  // 标记该ID已被回收
                call SaveBoolean(ht,2,id,true)
                set recycleCount=recycleCount+1
            endif
        endmethod  // 获取回收池中ID的数量
        static method getRecycledCount takes nothing returns integer
            return recycleCount
        endmethod  // 获取当前正在使用的ID数量
        static method getActiveCount takes nothing returns integer  // 最大ID减去已回收的ID数量
            return (nextId-1)-recycleCount
        endmethod
    endstruct

//library UIId ends
//library UIImageModule:
    module uiImageModule  // 设置图片路径
        method setTexture takes string path returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetTexture(this.ui,path,0)
            return this
        endmethod  // 设置图片控件视口,防止模型超出范围
        method setClip takes boolean clip returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetClip(this.ui,clip)
            return this
        endmethod
    endmodule

//library UIImageModule ends
//library UILifeCycle:
    struct uiLifeCycle extends array
    //! pragma implicitthis
        static integer agrsUI=0
        static integer agrsTypeID=0
        static integer agrsFrame=0
        //private:
            private static trigger trCreate=null
            private static trigger trDestroy=null
        static method registerCreate takes code func returns nothing  // 注册创建回调
            call TriggerAddCondition(trCreate,Condition(func))
        endmethod  // 注册销毁回调
        static method registerDestroy takes code func returns nothing
            call TriggerAddCondition(trDestroy,Condition(func))
        endmethod
        static method onCreateCB takes integer ui,integer typeID,integer frame returns nothing
            set agrsUI=ui
            set agrsTypeID=typeID
            set agrsFrame=frame
            call TriggerEvaluate(trCreate)
        endmethod
        static method onDestroyCB takes integer ui,integer typeID,integer frame returns nothing
            set agrsUI=ui
            set agrsTypeID=typeID
            set agrsFrame=frame
            call TriggerEvaluate(trDestroy)
        endmethod
        static method onInit takes nothing returns nothing
            set trCreate=CreateTrigger()
            set trDestroy=CreateTrigger()
        endmethod
    endstruct

//library UILifeCycle ends
//library UITextModule:
    module uiTextModule  // 设置标准字体大小
        method setFontSize takes integer size returns thistype  // size: 1=迷你号, 2=特小号, 3=小号, 4=标准, 5=中号, 6=大号, 7=特大号
            local real fontSize=0.01
            if (not (this.isExist()))then
                return this
            endif
            if (size==1)then
                set fontSize=0.006
            elseif (size==2)then
                set fontSize=0.008
            elseif (size==3)then
                set fontSize=0.009
            elseif (size==4)then
                set fontSize=0.01
            elseif (size==5)then
                set fontSize=0.011
            elseif (size==6)then
                set fontSize=0.012
            elseif (size==7)then
                set fontSize=0.015
            endif
            call DzFrameSetFont(ui,"fonts\\zt.ttf",fontSize,0)
            return this
        endmethod  // 设置对齐方式(前提要先定好大小,不然无处对齐)
        method setAlign takes integer align returns thistype  // align: 可以使用0-8的简单数字,或TEXT_ALIGN_*常量 // 0=左上, 1=顶部居中, 2=右上 // 3=左中, 4=居中, 5=右中 // 6=左下, 7=底部居中, 8=右下
            local integer finalAlign=align
            if (not (this.isExist()))then  // 如果输入0-8,转换为对应的组合值
                return this
            endif
            if (align>=0 and align<=8)then
                if (align==0)then  // 左上
                    set finalAlign=9
                elseif (align==1)then  // 顶部居中
                    set finalAlign=17
                elseif (align==2)then  // 右上
                    set finalAlign=33
                elseif (align==3)then  // 左中
                    set finalAlign=10
                elseif (align==4)then  // 居中
                    set finalAlign=18
                elseif (align==5)then  // 右中
                    set finalAlign=34
                elseif (align==6)then  // 左下
                    set finalAlign=12
                elseif (align==7)then  // 底部居中
                    set finalAlign=20
                elseif (align==8)then  // 右下
                    set finalAlign=36
                endif
            endif
            call DzFrameSetTextAlignment(ui,finalAlign)
            return this
        endmethod  // 设置文本内容
        method setText takes string text returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetText(ui,text)
            return this
        endmethod
    endmodule

//library UITextModule ends
//library UnitTestFramwork:

    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest,func)
    endfunction
        function UnitTestFramwork__anon__0 takes nothing returns nothing  //在游戏开始0.1秒后再调用
            local integer i
            set i=1
            loop
            exitwhen (i>12)
                call SetPlayerName(ConvertedPlayer(i),"测试员"+I2S(i)+"号")  //迷雾全关
                call CreateFogModifierRectBJ(true,ConvertedPlayer(i),FOG_OF_WAR_VISIBLE,GetPlayableMapRect())
            set i = i+1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr,0.1)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__0))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(0),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(1),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(2),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(3),"",false)
    endfunction

//library UnitTestFramwork ends
//library Hardware:
    struct hardware extends array  // 注册一个左键抬起事件
    //! pragma implicitthis
        static method regLeftUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,1,0,false,func)
        endmethod  // 注册一个左键按下事件
        static method regLeftDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,1,1,false,func)
        endmethod  // 注册一个右键按下事件
        static method regRightDownEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,2,1,false,func)
        endmethod  // 注册一个右键抬起事件
        static method regRightUpEvent takes code func returns nothing
            call DzTriggerRegisterMouseEventByCode(null,2,0,false,func)
        endmethod  // 注册一个滚轮事件,不能异步注册
        static method regWheelEvent takes code func returns nothing
            if (trWheel==null)then
                set trWheel=CreateTrigger()
            endif
            call TriggerAddCondition(trWheel,Condition(func))
        endmethod  // 注册一个绘制事件,不能异步注册
        static method regUpdateEvent takes code func returns nothing
            if (trUpdate==null)then
                set trUpdate=CreateTrigger()
            endif
            call TriggerAddCondition(trUpdate,Condition(func))
        endmethod  // 注册一个窗口变化事件,不能异步注册
        static method regResizeEvent takes code func returns nothing
            if (trResize==null)then
                set trResize=CreateTrigger()
            endif
            call TriggerAddCondition(trResize,Condition(func))
        endmethod  // 注册一个鼠标移动事件,不能异步注册
        static method regMoveEvent takes code func returns nothing
            if (trMove==null)then
                set trMove=CreateTrigger()
            endif
            call TriggerAddCondition(trMove,Condition(func))
        endmethod  // 获取鼠标的实数坐标X(0-0.8)
        static method getMouseX takes nothing returns real
            local integer width=DzGetClientWidth()
            if (width>0)then
                return DzGetMouseXRelative()*0.8/width
            else
                return 0.1
            endif
        endmethod  // 获取鼠标的实数坐标Y(0-0.6)
        static method getMouseY takes nothing returns real
            local integer height=DzGetClientHeight()
            if (height>0)then  // 防止除以0
                return 0.6-DzGetMouseYRelative()*0.6/height
            else
                return 0.1
            endif
        endmethod
        //private:
            private static trigger trWheel=null
            private static trigger trUpdate=null
            private static trigger trResize=null
            private static trigger trMove=null
            private static method anon__0 takes nothing returns nothing  // 滚轮事件
                call TriggerEvaluate(trWheel)
            endmethod  // 帧绘制事件
            private static method anon__1 takes nothing returns nothing
                call TriggerEvaluate(trUpdate)
            endmethod  // 窗口大小变化事件
            private static method anon__2 takes nothing returns nothing
                call TriggerEvaluate(trResize)
            endmethod  // 鼠标移动事件
            private static method anon__3 takes nothing returns nothing
                call TriggerEvaluate(trMove)
            endmethod
        static method onInit takes nothing returns nothing
            call DzTriggerRegisterMouseWheelEventByCode(null,false,function thistype.anon__0)
            call DzFrameSetUpdateCallbackByCode(function thistype.anon__1)
            call DzTriggerRegisterWindowResizeEventByCode(null,false,function thistype.anon__2)
            call DzTriggerRegisterMouseMoveEventByCode(null,false,function thistype.anon__3)
        endmethod
    endstruct

//library Hardware ends
//library UITocInit:

    function UITocInit__onInit takes nothing returns nothing
        call DzLoadToc("ui\\Crainax.toc")
        call DzFrameEnableClipRect(false)
    endfunction

//library UITocInit ends
//library UIUtils:
    function GetResizeRate takes nothing returns real  //主要用于UI缩放
        if (DzGetWindowWidth()>0)then
            return DzGetWindowHeight()/600.0*800.0/DzGetWindowWidth()
        else
            return 1.0
        endif
    endfunction  // 获取鼠标位置X(绝对坐标)[修正版]
    function GetMouseXEx takes nothing returns real
        local integer width=DzGetClientWidth()
        if (width>0)then
            return DzGetMouseXRelative()*0.80/width
        else
            return 0.1
        endif
    endfunction  // 获取鼠标位置Y(绝对坐标)[修正版]
    function GetMouseYEx takes nothing returns real
        local integer height=DzGetClientHeight()
        if (height>0)then
            return 0.60-DzGetMouseYRelative()*0.60/height
        else
            return 0.1
        endif
    endfunction  // 限制一个值是在一定区域内以防UI超出这个区域
    function GetFixedMouseX takes real min,real max returns real
        return RLimit(GetMouseXEx(),min,max)
    endfunction  // 限制一个值是在一定区域内以防UI超出这个区域
    function GetFixedMouseY takes real min,real max returns real
        return RLimit(GetMouseYEx(),min,max)
    endfunction

//library UIUtils ends
//library BaseAnim:
    function interface onLifeEnd takes baseanim arg0 returns nothing
    struct baseanim 
    //! pragma implicitthis
        static thistype  array DList
        static thistype  array MList
        static thistype  array AList
        static thistype  array ZList
        static thistype  array SList
        static thistype  array BList
        static thistype  array LList
        static integer DNum=0  //利用上述创建的uianim特定个例
        static integer MNum=0
        static integer ANum=0
        static integer ZNum=0
        static integer SNum=0
        static integer BNum=0
        static integer LNum=0
        static uianim UIA=0  //统计数量
        static integer size=0  //结构成员
        integer ui
        method isExist takes nothing returns boolean  //创建与删除
            return (this!=null and si__baseanim_V[this]==-1)
        endmethod
        static method create takes integer ui returns thistype
            local thistype this=allocate()
            set this.ui=ui
            call SaveInteger(HASH_UI,ui,1822,this)  //统计数量++
            set size=size+1
            return this
        endmethod  //延迟组
        integer dID  //动画延迟
        integer dTime
        integer dNow
        method addDelay takes integer time returns nothing
            if (time<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.dTime=time
            set this.dNow=0  //这里是初始化时的设置内容,不需要改
            if (dID==0)then
                set DNum=DNum+1
                set DList[DNum]=this
                set dID=DNum
            endif  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delDelay takes nothing returns nothing  //数据解除都放这里
            if (dID!=0)then
                set DList[dID]=DList[DNum]
                set DList[dID].dID=dID
                set DNum=DNum-1
                set dID=0
            endif
        endmethod  //移动组
        integer align  //移动组
        integer mTime
        integer mNow
        integer anchor1
        integer anchor2
        integer mID
        real dist  //线性移动
        real off
        real angle
        method addMove takes integer align,real off,real dist,integer time,real angle,integer anchor1,integer anchor2 returns nothing  // @param align 需要对齐的UI // @param off 初始的对应anchor的偏移 // @param dist 距离（加上面的off) // @param time 时间(0.02为一帧) // @param angle 角度 // @param anchor1 本体的锚点 // @param anchor2 需要对齐的UI的锚点
            if (dist<=0. or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.align=align
            set this.dist=dist
            set this.off=off
            set this.mTime=time
            set this.mNow=0
            set this.angle=angle
            set this.anchor1=anchor1
            set this.anchor2=anchor2  //这里是初始化时的设置内容,不需要改
            if (mID==0)then
                set MNum=MNum+1
                set MList[MNum]=this
                set mID=MNum
            endif
            call DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*off,SinBJ(angle)*off)  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delMove takes nothing returns nothing  //数据解除都放这里
            if (mID!=0)then
                set MList[mID]=MList[MNum]
                set MList[mID].mID=mID
                set MNum=MNum-1
                set mID=0
            endif
        endmethod  //透明组
        integer aID  //透明度(0-255)
        integer aStart
        integer aTar
        integer aTime
        integer aNow
        method addAlpha takes integer start,integer tar,integer time returns nothing  // @param start 开始透明度 // @param tar 目标透明度 // @param time 时间(0.02为一帧)
            if (time<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.aStart=start
            set this.aTar=tar
            set this.aTime=time
            set this.aNow=0  //这里是初始化时的设置内容,不需要改
            if (aID==0)then
                set ANum=ANum+1
                set AList[ANum]=this
                set aID=ANum
            endif  //这个不能设置的原因是有可能有2个一起设置，存在延迟;
            call DzFrameSetAlpha(ui,start)  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delAlpha takes nothing returns nothing
            if (aID!=0)then
                set AList[aID]=AList[ANum]
                set AList[aID].aID=aID
                set ANum=ANum-1
                set aID=0
            endif
        endmethod  //放大组[垃圾scale还是用size香]
        integer zID
        integer zTime
        integer zNow
        real zStartX  //放大
        real zTarX
        real zStartY
        real zTarY
        method addZoom takes real startX,real tarX,real startY,real tarY,integer time returns nothing  // @param startX 开始X // @param tarX 目标X // @param startY 开始Y // @param tarY 目标Y // @param time 时间(0.02为一帧)
            if (time<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.zStartX=startX
            set this.zTarX=tarX
            set this.zStartY=startY
            set this.zTarY=tarY
            set this.zTime=time
            set this.zNow=0  //这里是初始化时的设置内容,不需要改
            if (zID==0)then
                set ZNum=ZNum+1
                set ZList[ZNum]=this
                set zID=ZNum
            endif
            call DzFrameSetSize(ui,startX,startY)  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delZoom takes nothing returns nothing  //数据解除都放这里
            if (zID!=0)then
                set ZList[zID]=ZList[ZNum]
                set ZList[zID].zID=zID
                set ZNum=ZNum-1
                set zID=0
            endif
        endmethod  //序列组(永恒序列/一次性序列)
        string sPath  //路径 //ID
        integer sID  //最大帧数
        integer sMax  //当前帧
        integer sPos  //帧间隔
        integer sGap  //帧间隔指针
        integer sGapPos  //是否循环
        boolean sLoop  //序列帧已经自动从0开始了。
        method addSequ takes string path,integer maxFrame,integer interval,boolean isL returns nothing  // @param path 路径 (帧图片取名要这种格式: xxx_0.blp) // @param maxFrame 最大帧数 // @param interval 帧间隔 // @param isL 是否循环
            if (maxFrame<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.sPath=path  //路径; //最大帧数;
            set this.sMax=maxFrame  //当前帧;
            set this.sPos=0  //帧间隔;
            set this.sGap=interval  //帧间隔;
            set this.sGapPos=0  //是否循环;
            set this.sLoop=isL  //这里是初始化时的设置内容,不需要改
            if (sID==0)then
                set SNum=SNum+1
                set SList[SNum]=this
                set sID=SNum
            endif
            call DzFrameSetTexture(ui,sPath+"0.blp",0)  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delSequ takes nothing returns nothing  //数据解除都放这里
            set sPath=null
            if (sID!=0)then
                set SList[sID]=SList[SNum]
                set SList[sID].sID=sID
                set SNum=SNum-1
                set sID=0
            endif
        endmethod  //闪烁组
        integer bID
        integer bPeriod
        integer bTime
        integer bStart
        boolean bOrient  //闪烁组,Time是周期，取消后记得在外面设置Alpha回255
        method addBlink takes integer start,integer period returns nothing  // @param start 开始透明度 // @param period 周期(0.02为一帧)
            if (period<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.bStart=start
            set this.bOrient=false
            set this.bPeriod=period
            set this.bTime=0  //这里是初始化时的设置内容,不需要改
            if (bID==0)then
                set BNum=BNum+1
                set BList[BNum]=this
                set bID=BNum
            endif
            call DzFrameSetAlpha(ui,start)  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delBlink takes nothing returns nothing  //数据解除都放这里
            if (bID!=0)then
                set BList[bID]=BList[BNum]
                set BList[bID].bID=bID
                set BNum=BNum-1
                set bID=0
            endif
        endmethod  //生命周期组
        integer lID
        integer lPeriod
        integer lTime
        onLifeEnd lCB  // @param period 生命周期时长(0.02为一帧)
        method addLife takes integer period,onLifeEnd lCB returns nothing  // @param lCB 生命周期结束时调用,设成0则不调用,自动排泄ba
            if (period<=0 or (not (isExist())))then  //数据设置都放这
                return
            endif
            set this.lPeriod=period
            set this.lTime=0
            set this.lCB=lCB  //这里是初始化时的设置内容,不需要改
            if (lID==0)then
                set LNum=LNum+1
                set LList[LNum]=this
                set lID=LNum
            endif  //Add了后就调用了这个自动开始
            call UIA.reg()
        endmethod
        private method delLife takes nothing returns nothing  //数据解除都放这里
            set lTime=0
            if (lID!=0)then  //这里开始删ui
                if (ui!=0 and lCB!=0)then  //因为会自动排泄,防止在回调删UI的时候继续再调用一次
                    call RemoveSavedInteger(HASH_UI,ui,1822)
                    call lCB.evaluate(this)
                endif
                set LList[lID]=LList[LNum]
                set LList[lID].lID=lID
                set LNum=LNum-1
                set lID=0
            endif
        endmethod  //析构,手动调用或者生命周期结束时自动调用
        method onDestroy takes nothing returns nothing
            if (not (isExist()))then
                return
            endif
            call delDelay()
            call delMove()
            call delZoom()
            call delAlpha()
            call delSequ()
            call delBlink()
            call delLife()
            if (HaveSavedInteger(HASH_UI,ui,1822))then
                call RemoveSavedInteger(HASH_UI,ui,1822)
            endif
            set ui=0  //统计数量--
            set size=size-1
        endmethod  //查看当前的东西
        static method toString takes nothing returns string
            local string s=""
            set s=s+"[DNum]"+I2S(DNum)+"->"
            set s=s+"[MNum]"+I2S(MNum)+"->"
            set s=s+"[ANum]"+I2S(ANum)+"->"
            set s=s+"[ZNum]"+I2S(ZNum)+"->"
            set s=s+"[SNum]"+I2S(SNum)+"->"
            set s=s+"[BNum]"+I2S(BNum)+"->"
            set s=s+"[LNum]"+I2S(LNum)
            return s
        endmethod
            private static method anon__0 takes nothing returns nothing
                local integer i
                local integer this
                local real r  //延迟组先行动
                if (DNum>0)then
                    set i=1  //从结论来说i就是dID
                    loop
                    exitwhen (i>DNum)
                        set this=DList[i]
                        set dNow=dNow+1  //结束了
                        if (dNow>=dTime)then
                            set DList[i]=DList[DNum]
                            set DList[i].dID=i
                            set DNum=DNum-1
                            set dID=0
                            set i=i-1
                        endif
                    set i = i+1
                    endloop
                endif  //移动
                if (MNum>0)then
                    set i=1  //从结论来说i就是mID
                    loop
                    exitwhen (i>MNum)
                        set this=MList[i]
                        if (dID==0)then  //结束了
                            if (mNow>=mTime)then
                                call DzFrameClearAllPoints(ui)
                                call DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*(off+dist),SinBJ(angle)*(off+dist))
                                set MList[i]=MList[MNum]
                                set MList[i].mID=i
                                set MNum=MNum-1
                                set i=i-1
                                set mID=0
                            else
                                set mNow=mNow+1
                                call DzFrameClearAllPoints(ui)
                                call DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*(off+dist*mNow/mTime),SinBJ(angle)*(off+dist*mNow/mTime))
                            endif  //还在延迟中不进行操作
                        endif
                    set i = i+1
                    endloop
                endif  //透明度
                if (ANum>0)then
                    set i=1  //从结论来说i就是aID
                    loop
                    exitwhen (i>ANum)
                        set this=AList[i]  // 结束了
                        if (dID==0)then
                            if (aNow>=aTime)then
                                call DzFrameSetAlpha(ui,aTar)
                                if (aTar<=0)then
                                    call DzFrameShow(ui,false)
                                endif
                                set AList[i]=AList[ANum]
                                set AList[i].aID=i
                                set ANum=ANum-1
                                set i=i-1
                                set aID=0
                            else
                                set aNow=aNow+1
                                call DzFrameSetAlpha(ui,R2I(aStart+(aTar-aStart)*(I2R(aNow)/aTime)))
                            endif  //还在延迟中不进行操作
                        endif
                    set i = i+1
                    endloop
                endif  //放大组
                if (ZNum>0)then
                    set i=1  //从结论来说i就是aID
                    loop
                    exitwhen (i>ZNum)
                        set this=ZList[i]  // 结束了
                        if (dID==0)then
                            if (zNow>=zTime)then  //DzFrameSetScale(ui,zTar);
                                call DzFrameSetSize(ui,zTarX,zTarY)
                                set ZList[i]=ZList[ZNum]
                                set ZList[i].zID=i
                                set ZNum=ZNum-1
                                set i=i-1
                                set zID=0
                            else
                                set zNow=zNow+1
                                call DzFrameSetSize(ui,zStartX+(zTarX-zStartX)*(I2R(zNow)/zTime),zStartY+(zTarY-zStartY)*(I2R(zNow)/zTime))
                            endif  //还在延迟中不进行操作
                        endif
                    set i = i+1
                    endloop
                endif  //序列帧
                if (SNum>0)then
                    set i=1  //从结论来说i就是sID
                    loop
                    exitwhen (i>SNum)
                        set this=SList[i]
                        if (dID==0)then
                            set sGapPos=sGapPos+1  //几帧一绘
                            if (sGapPos>=sGap)then
                                set sGapPos=0
                                set sPos=sPos+1  // 结束了,且不循环
                                if (sPos>sMax)then
                                    set sPos=0  //不循环
                                    if (not sLoop)then
                                        call DzFrameSetTexture(ui,sPath+I2S(sMax)+".blp",0)
                                        set SList[i]=SList[SNum]
                                        set SList[i].sID=i
                                        set SNum=SNum-1
                                        set i=i-1
                                        set sID=0
                                    else
                                        call DzFrameSetTexture(ui,sPath+"0.blp",0)
                                    endif
                                else  //正常绘帧
                                    call DzFrameSetTexture(ui,sPath+I2S(sPos)+".blp",0)
                                endif
                            endif  //还在延迟中不进行操作
                        endif
                    set i = i+1
                    endloop
                endif  //闪烁组
                if (BNum>0)then
                    set i=1  //从结论来说i就是aID
                    loop
                    exitwhen (i>BNum)
                        set this=BList[i]
                        if (dID==0)then  //变透明
                            if (bOrient)then
                                set bTime=bTime-1  //实体化
                            else
                                set bTime=bTime+1
                            endif
                            if (bTime>=R2I(bPeriod*0.5) or bTime<=0)then
                                set bOrient=not bOrient
                            endif
                            call DzFrameSetAlpha(ui,R2I(255*(I2R(bTime)/bPeriod*2)))  //还在延迟中不进行操作
                        endif
                    set i = i+1
                    endloop
                endif  //生命周期[不受延迟组影响]
                if (LNum>0)then
                    set i=1  //从结论来说i就是dID
                    loop
                    exitwhen (i>LNum)
                        set this=LList[i]
                        set lTime=lTime+1  //结束了
                        if (lTime>=lPeriod)then
                            call destroy()
                            set i=i-1
                        endif
                    set i = i+1
                    endloop
                endif
                if (DNum<=0 and MNum<=0 and ANum<=0 and ZNum<=0 and SNum<=0 and BNum<=0 and LNum<=0)then  //这里就删计时器吧
                    call UIA.unreg()
                    call BJDebugMsg("baseanim停止了")
                endif
            endmethod  // UI销毁时回调删除基础动画(UI销毁时会自动调用),但是不需要再删ba了,
            private static method anon__1 takes nothing returns nothing
                local integer ui=uiLifeCycle.agrsFrame
                local thistype this
                if (HaveSavedInteger(HASH_UI,ui,1822))then
                    set this=LoadInteger(HASH_UI,ui,1822)
                    if (this.isExist())then
                        call this.destroy()
                    endif
                endif
            endmethod
        static method onInit takes nothing returns nothing
            set UIA=uianim.create(function thistype.anon__0)
            call uiLifeCycle.registerDestroy(function thistype.anon__1)
        endmethod
    endstruct

//library BaseAnim ends
//library UIBaseModule:
    module uiBaseModule  // 设置位置
        method setPoint takes integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX,offsetY)
            return this
        endmethod  // 大小完全对齐父框架
        method setAllPoint takes integer relative returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetAllPoints(ui,relative)
            return this
        endmethod  //绝对位置
        method setAbsPoint takes integer anchor,real x,real y returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetAbsolutePoint(ui,anchor,x,y)
            return this
        endmethod  // 清除所有位置
        method clearPoint takes nothing returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameClearAllPoints(ui)
            return this
        endmethod  // 设置大小
        method setSize takes real width,real height returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetSize(ui,width,height)
            return this
        endmethod  // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        method setSizeFix takes real width,real height returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetSize(ui,width*GetResizeRate(),height)
            return this
        endmethod  // 显示控件
        method show takes boolean flag returns thistype  // 参数: boolean flag 是否显示
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameShow(ui,flag)
            return this
        endmethod  //透明度(0-255)
        method setAlpha takes integer value returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetAlpha(ui,value)
            return this
        endmethod  //扩展自适应大小方法
        implement optional extendResize
    endmodule

//library UIBaseModule ends
//library UIExtendEvent:

    function interface uiEvent takes integer arg0 returns nothing
    struct uiEventState extends array  // 是否开始右键点击
    //! pragma implicitthis
        static boolean rcStart=false  // 点击开始时的UI(判断是否进入过UI)
        static integer uiId=0
    endstruct
    module extendEvent  //注册按下事件,只适用于非Simple类型的
        method exLeftDown takes uiEvent func returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1901,func)
            return this
        endmethod  //注册抬起事件,只适用于非Simple类型的
        method exLeftUp takes uiEvent func returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1902,func)
            return this
        endmethod  // 鼠标进入事件(右键前提强化版)
            private static method anon__0 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local uiEvent func  //修改为使用结构体的静态成员
                set uiEventState.uiId=frame
                if (HaveSavedInteger(HASH_UI,frame,1910))then
                    set func=LoadInteger(HASH_UI,frame,1910)
                    call func.evaluate(frame)
                endif
            endmethod
        method spEnter takes uiEvent fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1910,fun)
            call DzFrameSetScriptByCode(ui,2,function thistype.anon__0,false)
            return this
        endmethod  // 鼠标离开事件(右键前提强化版)
            private static method anon__1 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local uiEvent func  //修改为使用结构体的静态成员
                set uiEventState.uiId=0
                if (HaveSavedInteger(HASH_UI,frame,1911))then
                    set func=LoadInteger(HASH_UI,frame,1911)
                    call func.evaluate(frame)
                endif
            endmethod
        method spLeave takes uiEvent fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1911,fun)
            call DzFrameSetScriptByCode(ui,3,function thistype.anon__1,false)
            return this
        endmethod  // 鼠标点击事件,其实这个不是必须项,只是为了统一写法硬加的
            private static method anon__2 takes nothing returns nothing
                local integer frame=DzGetTriggerUIEventFrame()
                local uiEvent func
                if (HaveSavedInteger(HASH_UI,frame,1912))then
                    set func=LoadInteger(HASH_UI,frame,1912)
                    call func.evaluate(frame)
                endif
            endmethod
        method spClick takes uiEvent fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1912,fun)
            call DzFrameSetScriptByCode(ui,1,function thistype.anon__2,false)
            return this
        endmethod  // 鼠标右键点击事件
        method spRightClick takes uiEvent fun returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call SaveInteger(HASH_UI,this.ui,1913,fun)
            return this
        endmethod  // 下面这批不适Simple的所以全部删除了
    endmodule  // //注册右键按下事件 // method exRightDown (uiEvent func)  -> thistype { //     if (!this.isExist()) {return this;} //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN,func); //     return this; // } // //注册右键抬起事件 // method exRightUp (uiEvent func)  -> thistype { //     if (!this.isExist()) {return this;} //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP,func); //     return this; // } // //注册右键点击事件（精确判断） // method exRightClick (uiEvent func) -> thistype { //     if (!this.isExist()) {return this;} //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK,func); //     return this; // }
        function UIExtendEvent__anon__3 takes nothing returns nothing  //注册左键按下事件
            local integer currentUI
            local uiEvent func
            if (not (DzIsMouseOverUI()))then
                return
            endif
            set currentUI=DzGetMouseFocus()
            if (HaveSavedInteger(HASH_UI,currentUI,1901))then
                set func=LoadInteger(HASH_UI,currentUI,1901)
                call func.evaluate(currentUI)
            endif
        endfunction  //注册左键抬起事件,在click事件之前触发
        function UIExtendEvent__anon__4 takes nothing returns nothing
            local integer currentUI
            local uiEvent func  //如果鼠标不在游戏内，就不响应该事件
            if (not (DzIsMouseOverUI()))then
                return
            endif
            set currentUI=DzGetMouseFocus()
            if (HaveSavedInteger(HASH_UI,currentUI,1902))then
                set func=LoadInteger(HASH_UI,currentUI,1902)
                call func.evaluate(currentUI)
            endif
        endfunction
        function UIExtendEvent__anon__5 takes nothing returns nothing
            if (uiEventState.uiId!=0)then
                set uiEventState.rcStart=true
            endif
        endfunction
        function UIExtendEvent__anon__6 takes nothing returns nothing
            local uiEvent func
            if (uiEventState.rcStart and uiEventState.uiId!=0)then
                if (HaveSavedInteger(HASH_UI,uiEventState.uiId,1913))then
                    set func=LoadInteger(HASH_UI,uiEventState.uiId,1913)
                    call func.evaluate(uiEventState.uiId)
                endif
            endif
            set uiEventState.rcStart=false
        endfunction  // UI销毁时如果鼠标正在上面,则触发一次离开事件,不然会引进只进不出的错误
        function UIExtendEvent__anon__7 takes nothing returns nothing
            local integer ui=uiLifeCycle.agrsFrame
            local uiEvent func
            if (uiEventState.uiId==ui and HaveSavedInteger(HASH_UI,ui,1911))then
                set func=LoadInteger(HASH_UI,uiEventState.uiId,1911)
                call func.evaluate(uiEventState.uiId)
            endif
            set uiEventState.uiId=0
        endfunction  // hardware.regRightDownEvent(function () { //注册右键按下事件
    function UIExtendEvent__onInit takes nothing returns nothing
        call hardware.regLeftDownEvent(function UIExtendEvent__anon__3)
        call hardware.regLeftUpEvent(function UIExtendEvent__anon__4)
        call hardware.regRightDownEvent(function UIExtendEvent__anon__5)
        call hardware.regRightUpEvent(function UIExtendEvent__anon__6)
        call uiLifeCycle.registerDestroy(function UIExtendEvent__anon__7)
    endfunction  //     integer currentUI; //     uiEvent func; //     if (!DzIsMouseOverUI()) { //         return; //     } //     currentUI = DzGetMouseFocus(); //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN)) { //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN); //         func.evaluate(currentUI); //     } //     // 新增的click判断逻辑 //     rcStartOnUI = true; //     rcStartUI = currentUI; // }); // hardware.regRightUpEvent(function () { //注册右键抬起事件 //     integer currentUI; //     uiEvent func; //     if (!DzIsMouseOverUI()) { //         return; //     } //     currentUI = DzGetMouseFocus(); //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP)) { //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP); //         func.evaluate(currentUI); //     } //     // 新增的click判断逻辑 //     if (rcStartOnUI && currentUI == rcStartUI) { //         if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK)) { //             func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK); //             func.evaluate(currentUI); //         } //     } //     rcStartOnUI = false; //     rcStartUI = 0; // });

//library UIExtendEvent ends
//library UIExtendResize:

    module extendResize  //注册一个大小重组器
        method exReSize takes real width,real height returns thistype
            local resizer ser
            if (not (this.isExist()))then
                return this
            endif
            if (HaveSavedInteger(HASH_UI,ui,1940))then
                set ser=LoadInteger(HASH_UI,ui,1940)
                set ser.frame=ui
                set ser.width=width
                set ser.height=height
            else
                set ser=resizer.create(ui,width,height)
                call SaveInteger(HASH_UI,ui,1940,ser)
            endif
            call DzFrameSetSize(ui,width*GetResizeRate(),height)
            return this
        endmethod
        method exRePoint takes integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype
            local rePointer ptr
            if (not (this.isExist()))then
                return this
            endif
            if (HaveSavedInteger(HASH_UI,ui,1941))then
                set ptr=LoadInteger(HASH_UI,ui,1941)
                set ptr.frame=ui
                set ptr.anchor=anchor
                set ptr.relative=relative
                set ptr.relativeAnchor=relativeAnchor
                set ptr.offsetX=offsetX
                set ptr.offsetY=offsetY
            else
                set ptr=rePointer.create(ui,anchor,relative,relativeAnchor,offsetX,offsetY)
                call SaveInteger(HASH_UI,ui,1941,ptr)
            endif
            call DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX*GetResizeRate(),offsetY)
            return this
        endmethod
    endmodule  //大小重组器
    struct resizer   //内容列表
    //! pragma implicitthis
        static thistype  array List  //现在有几个东西
        static integer size=0  //[成员]绑定的内容
        integer frame  //[成员]注册宽度
        real width  //[成员]注册高度
        real height  //[成员]绑定的ID
        integer uID
        method isExist takes nothing returns boolean  //注册一个对象进池里
            return (this!=null and si__resizer_V[this]==-1)
        endmethod
        static method create takes integer frame,real width,real height returns thistype
            local thistype this=allocate()
            set this.frame=frame
            set this.width=width
            set this.height=height  //这里是初始化时的设置内容,不需要改
            if (uID==0)then
                set size=size+1
                set List[size]=this
                set uID=size
            endif
            return this
        endmethod
        static method toString takes nothing returns string
            local string s=I2S(size)+"个:"
            local integer i
            set i=1
            loop
            exitwhen (i>size)
                set s=s+"["+I2S(i)+"]|r"+I2S(List[i])+"->"
            set i = i+1
            endloop
            set s=s+"/"
            return s
        endmethod
        method onDestroy takes nothing returns nothing  //数据解除都放这里
            set frame=0
            if (uID!=0)then
                set List[uID]=List[size]
                set List[uID].uID=uID
                set size=size-1
                set uID=0
            endif
            if (size<=0)then
                call BJDebugMsg("UIExtendResize: 大小重组器已销毁")
            endif
        endmethod
    endstruct  //位置重组器
    struct rePointer   //内容列表
    //! pragma implicitthis
        static thistype  array List  //现在有几个东西
        static integer size=0  //[成员]绑定的内容
        integer frame  //[成员]锚点
        integer anchor  //[成员]相对锚点
        integer relative  //[成员]相对锚点
        integer relativeAnchor  //[成员]偏移X
        real offsetX  //[成员]偏移Y
        real offsetY  //[成员]绑定的ID
        integer uID
        method isExist takes nothing returns boolean  //注册一个对象进池里
            return (this!=null and si__rePointer_V[this]==-1)
        endmethod
        static method create takes integer frame,integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype
            local thistype this=allocate()
            set this.frame=frame
            set this.anchor=anchor
            set this.relative=relative
            set this.relativeAnchor=relativeAnchor
            set this.offsetX=offsetX
            set this.offsetY=offsetY  //这里是初始化时的设置内容,不需要改
            if (uID==0)then
                set size=size+1
                set List[size]=this
                set uID=size
            endif
            return this
        endmethod
        static method toString takes nothing returns string
            local string s=I2S(size)+"个:"
            local integer i
            set i=1
            loop
            exitwhen (i>size)
                set s=s+"["+I2S(i)+"]|r"+I2S(List[i])+"->"
            set i = i+1
            endloop
            set s=s+"/"
            return s
        endmethod
        method onDestroy takes nothing returns nothing  //数据解除都放这里
            set frame=0
            if (uID!=0)then
                set List[uID]=List[size]
                set List[uID].uID=uID
                set size=size-1
                set uID=0
            endif
        endmethod
    endstruct
        function UIExtendResize__anon__0 takes nothing returns nothing  //注册窗口大小变化事件
            local real resizeX=GetResizeRate()
            local integer i
            local resizer ser
            if (resizer.size>0)then  //反向遍历可以删除下面的　i-= 1
                set i=resizer.size  //从结论来说i就是.uID
                loop
                exitwhen i<1
                    set ser=resizer.List[i]
                    call DzFrameSetSize(ser.frame,ser.width*resizeX,ser.height)
                set i=i-1
                endloop
            endif
        endfunction  //注册窗口大小变化事件
        function UIExtendResize__anon__1 takes nothing returns nothing
            local real resizeX=GetResizeRate()
            local integer i
            local rePointer ptr
            if (rePointer.size>0)then  //反向遍历可以删除下面的　i-= 1
                set i=rePointer.size  //从结论来说i就是.uID
                loop
                exitwhen i<1
                    set ptr=rePointer.List[i]
                    call DzFrameSetPoint(ptr.frame,ptr.anchor,ptr.relative,ptr.relativeAnchor,ptr.offsetX*resizeX,ptr.offsetY)
                set i=i-1
                endloop
            endif
        endfunction  //UI的销毁回调事件
        function UIExtendResize__anon__2 takes nothing returns nothing
            local integer frame=uiLifeCycle.agrsFrame
            local resizer ser
            local rePointer ptr
            if (HaveSavedInteger(HASH_UI,frame,1940))then
                set ser=LoadInteger(HASH_UI,frame,1940)
                if (ser.isExist())then
                    call ser.destroy()
                endif
            endif
            if (HaveSavedInteger(HASH_UI,frame,1941))then
                set ptr=LoadInteger(HASH_UI,frame,1941)
                if (ptr.isExist())then
                    call ptr.destroy()
                endif
            endif
        endfunction
    function UIExtendResize__onInit takes nothing returns nothing
        call hardware.regResizeEvent(function UIExtendResize__anon__0)
        call hardware.regResizeEvent(function UIExtendResize__anon__1)
        call uiLifeCycle.registerDestroy(function UIExtendResize__anon__2)
    endfunction

//library UIExtendResize ends
//library UILayer:
    struct uilayer extends array
    //! pragma implicitthis
        static integer  array lv
        static method onInit takes nothing returns nothing
            set uilayer.lv[1]=DzCreateFrameByTagName("BACKDROP","layer1",DzGetGameUI(),"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[1],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[1],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[2]=DzCreateFrameByTagName("BACKDROP","layer2",uilayer.lv[1],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[2],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[2],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[3]=DzCreateFrameByTagName("BACKDROP","layer3",uilayer.lv[2],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[3],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[3],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[4]=DzCreateFrameByTagName("BACKDROP","layer4",uilayer.lv[3],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[4],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[4],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[5]=DzCreateFrameByTagName("BACKDROP","layer5",uilayer.lv[4],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[5],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[5],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[6]=DzCreateFrameByTagName("BACKDROP","layer6",uilayer.lv[5],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[6],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[6],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
            set uilayer.lv[7]=DzCreateFrameByTagName("BACKDROP","layer7",uilayer.lv[6],"IT",0)
            call DzFrameSetAllPoints(uilayer.lv[7],DzGetGameUI())
            call DzFrameSetTexture(uilayer.lv[7],"UI\\Widgets\\EscMenu\\Human\\blank-background.blp",0)
        endmethod
    endstruct

//library UILayer ends
//library UIButton:
    struct uiBtn   // UI组件内部共享方法及成员
    //! pragma implicitthis
        integer ui
        integer id
        method isExist takes nothing returns boolean
            return (this!=null and si__uiBtn_V[this]==-1)
        endmethod
        implement optional uiLifeCycle
        implement  uiBaseModule  // UI事件的共用方法
        implement  uiEventModule  //扩展拖动(只有button能用,其他就不放进去了)
        implement optional extendDrag  // 创建一个不带声音的
        static method create takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()  //有高亮无声音的图标
            set ui=DzCreateFrameByTagName("BUTTON","Btn"+I2S(id),parent,"BT",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  //普通带声效系
        static method createSound takes integer parent returns thistype
            local thistype this=allocate()
            set id=uiId.get()  //有高亮有声音的图标
            set ui=DzCreateFrameByTagName("GLUEBUTTON","Btn"+I2S(id),parent,"BT",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  //右键菜单系
        static method createRC takes integer parent returns thistype
            local thistype this=allocate()
            set id=uiId.get()  //配合异度下的菜单使用,要导入:ui\image\textbutton_highlight.blp
            set ui=DzCreateFrameByTagName("GLUEBUTTON","Btn"+I2S(id),parent,"TBT",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建空白按钮
        static method createBlank takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("BUTTON","Btn"+I2S(id),parent,"BB",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建一个用在原生Frame里的按钮,这种按钮是不能destroy的!
        static method createSimple takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("SIMPLEBUTTON","Btn"+I2S(id),parent,"简单按钮",id)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  //绑定原生的Button成为SimpleButton,注意不能删除哦
        static method bindCreated takes integer frame returns thistype  // 不能用bindSimple,因为没有dzfindSimpleButton函数,只能用这个
            local thistype this=allocate()
            set id=uiId.get()
            set ui=frame
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod
        method onDestroy takes nothing returns nothing
            if (not (this.isExist()))then
                return
            endif
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onDestroyCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call FlushChildHashtable(HASH_UI,ui)
            endif
            call DzDestroyFrame(ui)
            call uiId.recycle(id)
        endmethod
    endstruct

//library UIButton ends
//library UIImage:
    struct uiImage   // UI组件内部共享方法及成员
    //! pragma implicitthis
        integer ui
        integer id
        method isExist takes nothing returns boolean
            return (this!=null and si__uiImage_V[this]==-1)
        endmethod
        implement optional uiLifeCycle
        implement  uiBaseModule  // UI图片的共用方法
        implement  uiImageModule  // 创建图片
        static method create takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("BACKDROP","Img"+I2S(id),parent,"IT",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建工具提示背景图片(种类1)
        static method createToolTips takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("BACKDROP","Img"+I2S(id),parent,"ToolTipsTemplate",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建工具提示背景图片(种类2)
        static method createToolTips2 takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("BACKDROP","Img"+I2S(id),parent,"ToolTipsTemplate2",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建边角(图标系的)
        static method createCornerBorder takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("BACKDROP","Img"+I2S(id),parent,"CornerBorder",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建一个用在原生Frame里的图片,这种图片是不能destroy的!
        static method createSimple takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            call DzCreateFrameByTagName("SIMPLEFRAME","Img"+I2S(id),parent,"简单图片",id)
            set ui=DzSimpleTextureFindByName("简单图片内容",id)
            call DzFrameClearAllPoints(ui)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 绑定原生图片
        static method bindSimple takes string name,integer index returns thistype  // name: 图片名称(fdf写的image的名字) // index: 图片索引(在外部创建时的填写的ID最后一个参数)
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzSimpleTextureFindByName(name,index)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod
        method onDestroy takes nothing returns nothing
            if (not (this.isExist()))then
                return
            endif
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onDestroyCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call FlushChildHashtable(HASH_UI,ui)
            endif
            call DzDestroyFrame(ui)
            call uiId.recycle(id)
        endmethod
    endstruct

//library UIImage ends
//library UISprite:
    struct uiSprite   // UI组件内部共享方法及成员
    //! pragma implicitthis
        integer ui
        integer id
        method isExist takes nothing returns boolean
            return (this!=null and si__uiSprite_V[this]==-1)
        endmethod
        implement optional uiLifeCycle
        implement  uiBaseModule  // 可选引入进度动画模块
        implement optional panimable  // 创建模型
        static method create takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("SPRITE","Sprite"+I2S(id),parent,"SpriteTemplate",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 设置模型(目前只做平面型就行了,后面2个0固定了)
        method setModel takes string path,integer modelType,integer flag returns thistype  // @param path: 模型路径 // @param modelType: 模型类型(0 = SPRITE（精灵/图标）,1 = MODEL（3D模型）,2 = STATUSBAR（状态条）) // @param flag: 标志(0 = 普通显示,1 = 允许选择模型,2 = 使用鼠标移动模型,4 = 添加模型动画控制器),要位运算
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetModel(ui,path,modelType,flag)
            return this
        endmethod  // 设置缩放
        method setScale takes real scale returns thistype  // @param scale: 缩放比例
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetScale(ui,scale)
            return this
        endmethod  // 设置动画
        method setAnimate takes integer animate,boolean auto returns thistype  // @param animate: 动画ID,一般为0 // @param auto: 是否自动播放
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetAnimate(ui,animate,auto)
            return this
        endmethod  // 设置进度
        method setProgress takes real progress returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetAnimateOffset(ui,progress)
            return this
        endmethod
        method onDestroy takes nothing returns nothing
            if (not (this.isExist()))then
                return
            endif
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onDestroyCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call FlushChildHashtable(HASH_UI,ui)
            endif
            call DzDestroyFrame(ui)
            call uiId.recycle(id)
        endmethod
    endstruct

//library UISprite ends
//library UIText:
    struct uiText   // UI组件内部共享方法及成员
    //! pragma implicitthis
        integer ui
        integer id
        method isExist takes nothing returns boolean
            return (this!=null and si__uiText_V[this]==-1)
        endmethod
        implement optional uiLifeCycle
        implement  uiBaseModule  // UI控件的共用方法
        implement  uiTextModule  // UI文本的共用方法 // 创建文本
        static method create takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzCreateFrameByTagName("TEXT","Text"+I2S(id),parent,"T1",0)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 创建一个用在原生Frame里的文本,这种文本是不能destroy的!
        static method createSimple takes integer parent returns thistype  // parent: 父级框架
            local thistype this=allocate()
            set id=uiId.get()
            call DzCreateFrameByTagName("SIMPLEFRAME","Text"+I2S(id),parent,"简单文字",id)
            set ui=DzSimpleFontStringFindByName("简单文字内容",id)
            call DzFrameClearAllPoints(ui)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod  // 绑定原生文本
        static method bindSimple takes string name,integer index returns thistype  // name: 文本名称(fdf写的text的名字) // index: 文本索引(在外部创建时的填写的ID最后一个参数)
            local thistype this=allocate()
            set id=uiId.get()
            set ui=DzSimpleFontStringFindByName(name,index)
            call DzFrameClearAllPoints(ui)
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onCreateCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call uiHashTable(ui).ui.bind(thistype.typeid,this)
            endif
            return this
        endmethod
        method onDestroy takes nothing returns nothing
            if (not (this.isExist()))then
                return
            endif
            static if LIBRARY_UILifeCycle then
                call uiLifeCycle.onDestroyCB(this,thistype.typeid,ui)
            endif
            static if LIBRARY_UIHashTable then
                call FlushChildHashtable(HASH_UI,ui)
            endif
            call DzDestroyFrame(ui)
            call uiId.recycle(id)
        endmethod
    endstruct

//library UIText ends
//library ProgressAnim:
    function interface onProgressEnd takes uiSprite arg0 returns nothing
    struct progAnim   // 内容列表
    //! pragma implicitthis
        static thistype  array List  // 现在有几个东西
        static integer size=0  // 动画实例
        static uianim UIA=0  // [成员]绑定的sprite
        uiSprite sprite  // [成员]起始值
        real from  // [成员]目标值
        real to  // [成员]持续时间
        integer time  // [成员]当前时间
        integer now  // [成员]绑定的ID
        integer id  // [成员]结束回调
        onProgressEnd cb
        method isExist takes nothing returns boolean  // 创建进度动画
            return (this!=null and si__progAnim_V[this]==-1)
        endmethod
        static method create takes uiSprite sprite,real from,real to,integer time,onProgressEnd cb returns thistype
            local thistype this=allocate()  // 数据设置都放这
            set this.sprite=sprite
            set this.from=from
            set this.to=to
            set this.time=time
            set this.now=0
            set this.cb=cb  // 这里是初始化时的设置内容,不需要改
            if (this.id==0)then
                set size=size+1
                set List[size]=this
                set this.id=size
            endif
            call UIA.reg()
            return this
        endmethod
        method onDestroy takes nothing returns nothing  // 数据解除都放这里
            if (sprite.isExist() and HaveSavedInteger(HASH_UI,sprite.ui,1945))then
                call RemoveSavedInteger(HASH_UI,sprite.ui,1945)
            endif
            set sprite=0
            set cb=0
            if (id!=0)then
                set List[id]=List[size]
                set List[id].id=id
                set size=size-1
                set id=0
            endif
            if (size<=0)then  // 这里就删计时器
                call UIA.unreg()  // 添加调试输出
                call BJDebugMsg("progAnim计时器已停止")
            endif
        endmethod
            private static method anon__0 takes nothing returns nothing  // 初始化动画计时器
                local integer i
                local thistype this
                local real progress
                if (size>0)then
                    set i=1  // 从结论来说i就是.id
                    loop
                    exitwhen (i>size)
                        set this=List[i]
                        set this.now=this.now+1  // 删除的条件
                        if (this.now>=this.time)then
                            call this.sprite.setProgress(this.to)
                            if (this.cb!=0)then  //因为会自动排泄,防止在回调删UI的时候继续再调用一次
                                call RemoveSavedInteger(HASH_UI,this.sprite.ui,1945)
                                call this.cb.evaluate(this.sprite)
                            endif
                            call this.destroy()  // 正向遍历必须要保留这条
                            set i=i-1
                        else
                            set progress=this.from+(this.to-this.from)*(I2R(this.now)/this.time)
                            call this.sprite.setProgress(progress)
                        endif
                    set i = i+1
                    endloop
                endif
            endmethod  // UI销毁时回调删除进度动画
            private static method anon__1 takes nothing returns nothing
                local integer ui=uiLifeCycle.agrsFrame
                local thistype this
                if (HaveSavedInteger(HASH_UI,ui,1945))then
                    set this=LoadInteger(HASH_UI,ui,1945)  // 检查实例是否存在
                    if (this.isExist())then
                        call this.destroy()
                    endif
                endif
            endmethod
        static method onInit takes nothing returns nothing
            set UIA=uianim.create(function thistype.anon__0)
            call uiLifeCycle.registerDestroy(function thistype.anon__1)
        endmethod
    endstruct  // 进度动画模块
    module panimable
        method progAnimate takes real from,real to,real duration,onProgressEnd cb returns thistype
            local progAnim anim
            if (not (this.isExist()))then  // 检查是否已存在progAnim实例
                return this
            endif
            if (HaveSavedInteger(HASH_UI,ui,1945))then
                set anim=LoadInteger(HASH_UI,ui,1945)  // 更新动画参数
                set anim.sprite=this
                set anim.from=from
                set anim.to=to
                set anim.time=R2I(duration*50)
                set anim.now=0
                set anim.cb=cb
            else  // 创建新实例
                set anim=progAnim.create(this,from,to,R2I(duration*50),cb)
                call SaveInteger(HASH_UI,ui,1945,anim)
            endif
            return this
        endmethod
    endmodule

//library ProgressAnim ends
//library Icon:
    struct icon   // UI组件
    //! pragma implicitthis
        uiImage mainImage  // 主图标图片 // 图标暗遮罩
        uiImage shadowImage  // 角落文字背景
        uiImage cornerShade  // 流光特效图片
        uiImage glowImage  // 角落文字
        uiText cornerText  // 点击按钮
        uiBtn clickBtn  // CD显示精灵
        uiSprite cdSprite  // 父级UI()
        integer parent  // 动画相关
        baseanim glowAnim  // 流光动画 // 流光数据
        growdata gd  // 尺寸
        real sizeX
        real sizeY
        boolean isResize  // 是否是原生
        boolean isSimple
        integer spAnchor
        integer spRelative
        integer spRelativeAnchor
        real spOffsetX
        real spOffsetY  // 用于CD显示的辅助图片
        uiImage cdSpriteImage
        method isExist takes nothing returns boolean  // 私有的初始化方法
            return (this!=null and si__icon_V[this]==-1)
        endmethod
        private method init takes nothing returns nothing  // 初始化所有成员为0
            set mainImage=0
            set shadowImage=0
            set cornerShade=0
            set cornerText=0
            set clickBtn=0
            set glowImage=0
            set cdSprite=0
            set cdSpriteImage=0  // 动画相关
            set glowAnim=0
            set gd=0  // 尺寸初始化为0
            set sizeX=0.04
            set sizeY=0.04
        endmethod  // 普通创建方法
        static method create takes integer parent returns thistype
            local thistype this=allocate()
            call this.init()
            set this.parent=parent
            set isSimple=false  // 创建必需组件
            set mainImage=uiImage.create(parent).setClip(true)
            call mainImage.show(false)
            return this
        endmethod  // 从现有UI创建图标(parent是后面创建东西的parent)
        static method fromExistingUI takes uiImage existingImage,integer parent returns thistype
            local thistype this=allocate()
            call this.init()
            set this.parent=parent
            set isSimple=true
            set spAnchor=0
            set spRelative=0
            set spRelativeAnchor=0
            set spOffsetX=0
            set spOffsetY=0  // 绑定现有图片
            set mainImage=existingImage
            return this
        endmethod  // 从现有UI创建图标(parent是后面创建东西的parent)
        static method createSimple takes integer parent returns thistype
            return fromExistingUI(uiImage.createSimple(parent),parent)
        endmethod  // 更新流光尺寸
        private method updateGlowSize takes nothing returns nothing
            if (glowImage.isExist())then
                if (isResize)then
                    call glowImage.exReSize(sizeX*gd.scale,sizeY*gd.scale)
                else
                    call glowImage.setSize(sizeX*gd.scale,sizeY*gd.scale)
                endif
            endif
        endmethod  // 加入流光效果
        method grow takes growdata gd returns thistype
            if (not (this.isExist()))then
                return this
            endif
            if (not (glowImage.isExist()))then
                if (isSimple)then  // 创建流光图片 -> 到最底层
                    set glowImage=uiImage.create(uilayer.lv[1])
                else
                    set glowImage=uiImage.create(this.parent)
                endif
                call glowImage.setPoint(4,mainImage.ui,4,0,0)
                call this.updateGlowSize()
            endif  // 显示流光
            call glowImage.show(true)
            if (gd!=this.gd)then
                set this.gd=gd
            endif
            if (not (glowAnim.isExist()))then
                set glowAnim=baseanim.create(glowImage.ui)
                call glowAnim.addSequ(gd.path,gd.max,gd.gap,true)
            endif
            call this.updateGlowSize()
            return this
        endmethod  // 取消流光
        method unGrow takes nothing returns thistype
            if (not (this.isExist()))then  //
                return this
            endif
            if (glowImage.isExist())then
                call glowImage.destroy()
                set glowImage=0
            endif
            if (glowAnim.isExist())then
                call glowAnim.destroy()
                set glowAnim=0
            endif
            return this
        endmethod  // 设置尺寸
        method setSize takes real x,real y returns thistype
            if (not (this.isExist()))then
                return this
            endif
            if (sizeX<=0 or sizeY<=0)then
                return this
            endif
            if (isResize)then
                call mainImage.exReSize(x,y)
            else
                call mainImage.setSize(x,y)
            endif
            set sizeX=x
            set sizeY=y
            call this.updateGlowSize()
            return this
        endmethod
        method enableResize takes nothing returns thistype
            if (not (this.isExist()))then
                return this
            endif
            set isResize=true
            call setSize(sizeX,sizeY)
            return this
        endmethod  // 设置数字
        method setCornerText takes string value returns thistype
            local real padding
            if (not (this.isExist()))then  // 如果value为null,隐藏cornerText和cornerShade
                return this
            endif
            if (value==null)then
                if (cornerText.isExist())then
                    call cornerText.show(false)
                    call cornerShade.show(false)
                endif
                return this
            endif  // 创建或更新cornerText
            if (not (cornerText.isExist()))then
                if (isSimple)then
                    set cornerShade=uiImage.createCornerBorder(uilayer.lv[1])
                    set cornerText=uiText.create(cornerShade.ui)
                else
                    set cornerShade=uiImage.createCornerBorder(this.parent)
                    set cornerText=uiText.create(cornerShade.ui)
                endif
                call cornerText.setFontSize(2).setPoint(8,mainImage.ui,8,-0.003,0.003)
                set padding=0.003
                call cornerShade.setPoint(0,cornerText.ui,0,-padding,padding).setPoint(8,cornerText.ui,8,padding,-padding)
            endif
            call cornerText.setText(value)
            call cornerText.show(true)
            call cornerShade.show(true)
            return this
        endmethod  // 设置图标暗遮罩
        method setShadow takes boolean flag returns thistype
            if (not (this.isExist()))then
                return this
            endif
            if (not (shadowImage.isExist()) and flag)then
                if (isSimple)then
                    set shadowImage=uiImage.create(uilayer.lv[1])
                else
                    set shadowImage=uiImage.create(mainImage.ui)
                endif
                call shadowImage.setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp").setAllPoint(mainImage.ui)
            endif
            if (shadowImage.isExist())then
                call shadowImage.show(flag)
            endif
            return this
        endmethod  // CD显示相关方法
        method startCooldown takes real duration,onProgressEnd func returns thistype  // func回调函数中的eventdata.get时是返回这个icon本体
            if (not (this.isExist()))then
                return this
            endif
            if (not (cdSprite.isExist()))then
                if (isSimple)then
                    set cdSpriteImage=uiImage.create(uilayer.lv[1]).setTexture("UI\\Widgets\\EscMenu\\Human\\blank-background.blp").setAllPoint(mainImage.ui).setClip(true)
                    set cdSprite=uiSprite.create(cdSpriteImage.ui)
                else
                    set cdSprite=uiSprite.create(mainImage.ui)
                endif
                call cdSprite.setPoint(4,mainImage.ui,4,0,0).setSize(0.001,0.001).setModel("ui\\model\\cooldown_center.mdx",0,0).setAnimate(0,false)
                call uiHashTable(cdSprite).eventdata.bind(this)
            endif
            call cdSprite.progAnimate(0,1,duration,func)
            call cdSprite.setScale(sizeY/0.038)
            return this
        endmethod  // 获取按钮,然后再在外面设按钮相关的事件
        method getClickBtn takes nothing returns uiBtn
            if (not (this.isExist()))then
                return 0
            endif
            if (not (clickBtn.isExist()))then  //原生
                if (isSimple)then
                    if (parent!=0)then
                        set clickBtn=uiBtn.createSimple(parent).setAllPoint(mainImage.ui)
                    else
                        call BJDebugMsg("parent is 0")
                    endif  //非原生
                else
                    set clickBtn=uiBtn.create(mainImage.ui).setAllPoint(mainImage.ui)
                endif
            endif
            return clickBtn
        endmethod  // 设置图标贴图
        method setTexture takes string path returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call mainImage.setTexture(path)
            return this
        endmethod  // 设置位置(顺便存位置)
        method setPoint takes integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype  // 原生的话1个点就行, 不要设太多点
            if (not (this.isExist()))then
                return this
            endif
            if (isSimple)then
                call mainImage.clearPoint().setPoint(anchor,relative,relativeAnchor,offsetX,offsetY)
                set this.spAnchor=anchor
                set this.spRelative=relative
                set this.spRelativeAnchor=relativeAnchor
                set this.spOffsetX=offsetX
                set this.spOffsetY=offsetY
            else
                call mainImage.setPoint(anchor,relative,relativeAnchor,offsetX,offsetY)
            endif
            return this
        endmethod  // 显示/隐藏整个图标(Simple无效)
        method show takes boolean flag returns thistype
            if (not (this.isExist()))then  //原生就移到屏幕外
                return this
            endif
            if (isSimple)then  //显示
                if (flag)then
                    call mainImage.clearPoint().setPoint(spAnchor,spRelative,spRelativeAnchor,spOffsetX,spOffsetY)
                else  //隐藏
                    call mainImage.clearPoint().setPoint(4,DzGetGameUI(),4,-0.8,0.0)
                endif  //非原生才能用这个函数
            else
                call mainImage.show(flag)
                if (glowImage.isExist())then
                    call glowImage.show(flag)
                endif
            endif
            return this
        endmethod
        method onDestroy takes nothing returns nothing
            if (glowAnim.isExist())then
                call glowAnim.destroy()
                set glowAnim=0
            endif
            if (cdSprite.isExist())then
                call cdSprite.destroy()
                set cdSprite=0
            endif
            if (cdSpriteImage.isExist())then
                call cdSpriteImage.destroy()
                set cdSpriteImage=0
            endif
            if (shadowImage.isExist())then
                call shadowImage.destroy()
                set shadowImage=0
            endif
            if (cornerShade.isExist())then
                call cornerShade.destroy()
                set cornerShade=0
            endif
            if (cornerText.isExist())then
                call cornerText.destroy()
                set cornerText=0
            endif
            if (clickBtn.isExist())then
                call clickBtn.destroy()
                set clickBtn=0
            endif
            if (glowImage.isExist())then
                call glowImage.destroy()
                set glowImage=0
            endif
            if (mainImage.isExist())then
                call mainImage.destroy()
                set mainImage=0
            endif
        endmethod
    endstruct

//library Icon ends
//library SpellBtns:
    struct spellBtns   // 使用grid表示技能格子Frame
    //! pragma implicitthis
        static integer  array grid[3][4]
        static icon  array icons[3][4]  // 回调参数:行
        static integer argsRow=0  // 回调参数:列
        static integer argsCol=0
        //private:  //技能栏大暗遮罩,用于右键表示
            private static uiImage shadeImg=0  //技能栏大暗遮罩,用于右键表示
            private static uiBtn shadeBtn=0  // 进入事件
            private static trigger trEnter=null  // 离开事件
            private static trigger trLeave=null  // 点击事件
            private static trigger trClick=null  // 右键点击事件
            private static trigger trRightClick=null  //当前鼠标所在的位置
            private static integer mousePos=0  // 是否开始右键点击
            private static boolean rcStartOnUI=false  // 右键点击开始时的鼠标位置
            private static integer rcStartPos=0
        static method onEnter takes code func returns nothing  // 注册进入事件
            if (trEnter==null)then
                set trEnter=CreateTrigger()
            endif
            call TriggerAddCondition(trEnter,Condition(func))
        endmethod  // 注册离开事件
        static method onLeave takes code func returns nothing
            if (trLeave==null)then
                set trLeave=CreateTrigger()
            endif
            call TriggerAddCondition(trLeave,Condition(func))
        endmethod  // 注册点击事件
        static method onClick takes code func returns nothing
            if (trClick==null)then
                set trClick=CreateTrigger()
            endif
            call TriggerAddCondition(trClick,Condition(func))
        endmethod  // 注册右键点击事件
        static method onRightClick takes code func returns nothing
            if (trRightClick==null)then
                set trRightClick=CreateTrigger()
            endif
            call TriggerAddCondition(trRightClick,Condition(func))
        endmethod  // 把技能按钮移出屏幕外
        static method outside takes integer row,integer col returns nothing
            call DzFrameClearAllPoints(grid[row][col])
            call DzFrameSetAbsolutePoint(grid[row][col],6,-1.0,0)
        endmethod  // 把技能按钮移回应有的位置
        static method inside takes integer row,integer col returns nothing
            call DzFrameClearAllPoints(grid[row][col])
            call DzFrameSetPoint(grid[row][col],4,DzGetGameUI(),5,-0.3078+(0.0398*row),-0.165-(0.0385*col))
        endmethod  // 显示或隐藏遮罩
            private static method anon__0 takes nothing returns nothing  //这样也没用,全都挡不住,但是全能hover
                call BJDebugMsg("enter")
            endmethod
            private static method anon__1 takes nothing returns nothing
                call BJDebugMsg("leave")
            endmethod
            private static method anon__2 takes nothing returns nothing
                call BJDebugMsg("click")
            endmethod
        static method showShade takes boolean show returns nothing
            if (not (shadeImg.isExist()))then
                set shadeImg=uiImage.create(uilayer.lv[1]).setSize(0.02,0.02).setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
            endif
            if (not (shadeBtn.isExist()))then
                set shadeBtn=uiBtn.createSimple(DzFrameGetParent(spellBtns.grid[3][4])).setPoint(0,shadeImg.ui,0,0.0,0.0).setPoint(8,shadeImg.ui,8,0.0,0.0).onMouseEnter(function thistype.anon__0).onMouseLeave(function thistype.anon__1).onMouseClick(function thistype.anon__2)
            endif
            if (show)then
                call shadeImg.clearPoint().setPoint(0,grid[1][1],0,0.0,0.0).setPoint(8,grid[3][4],8,0.0,0.0)
            else
                call shadeImg.clearPoint().setPoint(4,DzGetGameUI(),4,-0.8,0.6)
            endif  //随便用一个技能也可以,刷新一下
            call SetPlayerAbilityAvailable(GetLocalPlayer(),'AHbz',false)
            call SetPlayerAbilityAvailable(GetLocalPlayer(),'AHbz',true)
        endmethod  // 初始化
            private static method anon__3 takes integer frame returns nothing
                local integer data=uiHashTable(frame).eventdata.get()
                set argsRow=(data-1)/4+1
                set argsCol=ModuloInteger(data-1,4)+1
                call TriggerEvaluate(trEnter)
            endmethod
            private static method anon__4 takes integer frame returns nothing
                local integer data=uiHashTable(frame).eventdata.get()
                set argsRow=(data-1)/4+1
                set argsCol=ModuloInteger(data-1,4)+1
                call TriggerEvaluate(trLeave)
            endmethod
            private static method anon__5 takes integer frame returns nothing
                local integer data=uiHashTable(frame).eventdata.get()
                set argsRow=(data-1)/4+1
                set argsCol=ModuloInteger(data-1,4)+1
                call TriggerEvaluate(trClick)
            endmethod
            private static method anon__6 takes integer frame returns nothing
                local integer data=uiHashTable(frame).eventdata.get()
                set argsRow=(data-1)/4+1
                set argsCol=ModuloInteger(data-1,4)+1
                call TriggerEvaluate(trRightClick)
            endmethod
        static method onInit takes nothing returns nothing
            local integer row
            local integer col
            local uiBtn btn
            set row=1
            loop
            exitwhen (row>3)
                set col=1
                loop
                exitwhen (col>4)
                    set grid[row][col]=DzFrameGetCommandBarButton(row-1,col-1)
                    set btn=uiBtn.bindCreated(grid[row][col])
                    call btn.spEnter(thistype.anon__3)
                    call btn.spLeave(thistype.anon__4)
                    call btn.spClick(thistype.anon__5)
                    call btn.spRightClick(thistype.anon__6)
                    set icons[row][col]=icon.create(uilayer.lv[1])  // 自定义技能栏按钮大小
                    static if LIBRARY_DIYBtnsSize then
                        call icons[row][col].setSize(DIY_BTN_SPELL_SIZE,DIY_BTN_SPELL_SIZE)
                    else
                        call icons[row][col].setSize(0.038,0.038)
                    endif
                    call icons[row][col].setPoint(4,grid[row][col],4,0.0,0.0).setTexture("UI\\Widgets\\EscMenu\\Human\\blank-background.blp")
                    set icons[row][col].clickBtn=btn
                    call uiHashTable(grid[row][col]).eventdata.bind(((row-1)*4)+col)
                set col = col+1
                endloop
            set row = row+1
            endloop
        endmethod
    endstruct

//library SpellBtns ends
//library UTSpellBtns:

    function UTSpellBtns__TTestUTSpellBtns1 takes player p returns nothing
        local integer i
        set UTSpellBtns__shadeVisible=not UTSpellBtns__shadeVisible
        call spellBtns.showShade(UTSpellBtns__shadeVisible)
        call BJDebugMsg("测试了一下遮挡SpellBtns的按钮")
    endfunction
    function UTSpellBtns__TTestUTSpellBtns2 takes player p returns nothing
        local integer i
        local integer j
        set UTSpellBtns__isInside=not UTSpellBtns__isInside
        if (UTSpellBtns__isInside)then
            set i=1
            loop
            exitwhen (i>3)
                set j=1
                loop
                exitwhen (j>4)
                    call spellBtns.inside(i,j)
                set j = j+1
                endloop
            set i = i+1
            endloop
            call BJDebugMsg("全部物品显示")
        else
            set i=1
            loop
            exitwhen (i>3)
                set j=1
                loop
                exitwhen (j>4)
                    call spellBtns.outside(i,j)
                set j = j+1
                endloop
            set i = i+1
            endloop
            call BJDebugMsg("全部物品隐藏")
        endif
    endfunction
    function UTSpellBtns__TTestUTSpellBtns3 takes player p returns nothing
        local integer i
        local integer j
        set UTSpellBtns__isGrow=not UTSpellBtns__isGrow
        if (UTSpellBtns__isGrow)then
            call spellBtns.icons[1][1].grow(growdata[1])
            call spellBtns.icons[2][1].grow(growdata[2])
            call spellBtns.icons[3][1].grow(growdata[3])
            call spellBtns.icons[1][2].grow(growdata[4])
            call spellBtns.icons[2][2].grow(growdata[5])
            call spellBtns.icons[3][2].grow(growdata[6])
            call spellBtns.icons[1][3].grow(growdata[7])
            call spellBtns.icons[2][3].grow(growdata[8])
            call spellBtns.icons[3][3].grow(growdata[9])
            call spellBtns.icons[1][4].grow(growdata[10])
            call spellBtns.icons[2][4].grow(growdata[11])
            call spellBtns.icons[3][4].grow(growdata[12])
        else
            set i=1
            loop
            exitwhen (i>3)
                set j=1
                loop
                exitwhen (j>4)
                    call spellBtns.icons[i][j].ungrow()
                set j = j+1
                endloop
            set i = i+1
            endloop
        endif
        call BJDebugMsg("测试了一下技能图标的高亮")
    endfunction
    function UTSpellBtns__TTestUTSpellBtns4 takes player p returns nothing
        local integer i
        local integer j
        set i=1
        loop
        exitwhen (i>3)
            set j=1
            loop
            exitwhen (j>4)
                call BJDebugMsg("原生第"+I2S(i)+"行,第"+I2S(j)+"列:"+I2S(DzFrameGetCommandBarButton(i-1,j-1)))
                call BJDebugMsg("CD第"+I2S(i)+"行,第"+I2S(j)+"列:"+I2S(DzFrameGetCommandBarButtonAutoCastIndicator(DzFrameGetCommandBarButton(i-1,j-1))))
                call BJDebugMsg("扩展第"+I2S(i)+"行,第"+I2S(j)+"列:"+I2S(spellBtns.grid[i][j]))
            set j = j+1
            endloop
        set i = i+1
        endloop
    endfunction  //给原生遮罩里再创个按钮
    function UTSpellBtns__TTestUTSpellBtns5 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestUTSpellBtns6 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestUTSpellBtns7 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestUTSpellBtns8 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestUTSpellBtns9 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestUTSpellBtns10 takes player p returns nothing
    endfunction
    function UTSpellBtns__TTestActUTSpellBtns1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)  //获取范围式数字
        local integer i  //所有参数S
        local integer num=0
        local integer len=StringLength(str)
        local string  array paramS  //所有参数I
        local integer  array paramI  //所有参数R
        local real  array paramR
        set i=0
        loop
        exitwhen (i>len-1)
            if (SubString(str,i,i+1)==" ")then
                set paramS[num]=SubString(str,0,i)
                set paramI[num]=S2I(paramS[num])
                set paramR[num]=S2R(paramS[num])
                set num=num+1
                set str=SubString(str,i+1,len)
                set len=StringLength(str)
                set i=-1
            endif
        set i = i+1
        endloop
        set paramS[num]=str
        set paramI[num]=S2I(paramS[num])
        set paramR[num]=S2R(paramS[num])
        set num=num+1
        if (paramS[0]=="a")then
        elseif (paramS[0]=="b")then
        endif
        set p=null
    endfunction
            function UTSpellBtns__anon__1 takes nothing returns nothing  //在游戏开始0.0秒后再调用 // 为玩家1创建测试英雄 // 创建大法师在坐标(0,0) // 创建一个建筑单位用于测试12个技能 // 创建人族城堡 // 为建筑添加12个技能 // 暴风雪 // 水元素 // 闪现 // 群体传送 // 烈焰风暴 // 驱逐魔法 // 吸取魔法 // 凤凰 // 奥术光环 // 化身 // 寒冰护甲 // 烈焰护甲 // 添加8个预选的技能 // 火焰呼吸 // 霜冻闪电 // 变形术 // 妖术 // 吞噬 // 诱捕 // 混乱之雨 // 医疗波
                local integer row=spellBtns.argsRow
                local integer column=spellBtns.argsCol
                call BJDebugMsg("第"+I2S(row)+"行,第"+I2S(column)+"列的技能进入:"+I2S(spellBtns.grid[row][column]))  // BJDebugMsg("触发的UI:" + I2S(DzGetTriggerUIEventFrame()) + " 数据:" + I2S(uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get()));
            endfunction
            function UTSpellBtns__anon__2 takes nothing returns nothing
                local integer row=spellBtns.argsRow
                local integer column=spellBtns.argsCol
                call BJDebugMsg("第"+I2S(row)+"行,第"+I2S(column)+"列的技能离开")
            endfunction
            function UTSpellBtns__anon__3 takes nothing returns nothing
                local integer row=spellBtns.argsRow
                local integer column=spellBtns.argsCol
                call BJDebugMsg("第"+I2S(row)+"行,第"+I2S(column)+"列的技能点击")
            endfunction
            function UTSpellBtns__anon__4 takes nothing returns nothing
                local integer row=spellBtns.argsRow
                local integer column=spellBtns.argsCol
                call BJDebugMsg("第"+I2S(row)+"行,第"+I2S(column)+"列的技能右键点击")
            endfunction
        function UTSpellBtns__anon__0 takes nothing returns nothing
            local unit hero
            local unit building
            local real x=0
            local real y=0
            local integer i=0
            call BJDebugMsg("|cff00ff00[技能按钮测试]|r 单元测试已加载")
            call BJDebugMsg("|cff00ff00[技能按钮测试]|r 可用命令:")
            call BJDebugMsg("|cffffcc00s1|r - 切换遮罩显示/隐藏")
            call BJDebugMsg("|cffffcc00s2|r - 切换技能按钮显示/隐藏")
            call BJDebugMsg("|cffffcc00s3|r - 测试技能按钮高亮效果")
            call BJDebugMsg("|cffffcc00s4|r - 显示技能按钮框架信息")
            set hero=CreateUnit(Player(0),'Hamg',0,0,270)
            call SetHeroLevel(hero,10,true)
            set building=CreateUnit(Player(0),'hcas',400,0,270)
            call UnitAddAbility(building,'AHbz')
            call UnitAddAbility(building,'AHwe')
            call UnitAddAbility(building,'AHab')
            call UnitAddAbility(building,'AHmt')
            call UnitAddAbility(building,'AHfs')
            call UnitAddAbility(building,'AHbn')
            call UnitAddAbility(building,'AHdr')
            call UnitAddAbility(building,'AHpx')
            call UnitAddAbility(building,'AHad')
            call UnitAddAbility(building,'AHav')
            call UnitAddAbility(building,'AHcs')
            call UnitAddAbility(building,'AHfa')
            call UnitAddAbility(hero,'ACbc')
            call UnitAddAbility(hero,'ACbf')
            call UnitAddAbility(hero,'ACpy')
            call UnitAddAbility(hero,'AOhx')
            call UnitAddAbility(hero,'ACdv')
            call UnitAddAbility(hero,'ACen')
            call UnitAddAbility(hero,'ANr3')
            call UnitAddAbility(hero,'AOhw')
            call spellBtns.onEnter(function UTSpellBtns__anon__1)
            call spellBtns.onLeave(function UTSpellBtns__anon__2)
            call spellBtns.onClick(function UTSpellBtns__anon__3)
            call spellBtns.onRightClick(function UTSpellBtns__anon__4)
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTSpellBtns__anon__5 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if (SubStringBJ(str,1,1)=="-")then
                call UTSpellBtns__TTestActUTSpellBtns1(SubStringBJ(str,2,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTSpellBtns__TTestUTSpellBtns1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTSpellBtns__TTestUTSpellBtns2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTSpellBtns__TTestUTSpellBtns3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTSpellBtns__TTestUTSpellBtns4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTSpellBtns__TTestUTSpellBtns5(GetTriggerPlayer())
            elseif (str=="s6")then
                call UTSpellBtns__TTestUTSpellBtns6(GetTriggerPlayer())
            elseif (str=="s7")then
                call UTSpellBtns__TTestUTSpellBtns7(GetTriggerPlayer())
            elseif (str=="s8")then
                call UTSpellBtns__TTestUTSpellBtns8(GetTriggerPlayer())
            elseif (str=="s9")then
                call UTSpellBtns__TTestUTSpellBtns9(GetTriggerPlayer())
            elseif (str=="s10")then
                call UTSpellBtns__TTestUTSpellBtns10(GetTriggerPlayer())
            endif
        endfunction
    function UTSpellBtns__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr,0.5)
        call TriggerAddCondition(tr,Condition(function UTSpellBtns__anon__0))
        set tr=null
        call UnitTestRegisterChatEvent(function UTSpellBtns__anon__5)
    endfunction

//library UTSpellBtns ends

// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)

//窗口的大小
// [DzSetUnitMoveType]  
// title = "设置单位移动类型[NEW]"  
// description = "设置 ${单位} 的移动类型：${movetype} "  
// comment = ""  
// category = TC_KKPRE  
// [[.args]]  
// type = unit  
// [[.args]]  
// type = MoveTypeName  
// default = MoveTypeName01  
//控件的共用基本方法
//===========================================================================
// Icon.j
//===========================================================================
//
// 模块描述：
//   实现了魔兽争霸3中通用的图标UI组件，支持图标显示、数字标记、
//   按钮功能、流光特效等特性。
//
// 作者：[你的名字]
// 创建日期：[创建日期]
// 最后修改：[最后修改日期]
//
// 依赖项：
//   - UIBase
//   - UIAnim
//   - GrowData
//   - UIText
//   - UIImage
//   - UIButton
//   - UISprite
//
// 使用示例：
//   icon myIcon = icon.create(parentFrame, true, true);
//   myIcon.size(0.04, 0.04);
//
//===========================================================================
//# dependency:ui/model/cooldown_center.mdx
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
// 原生UI的大小
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

//! initstructs
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("UITocInit__onInit")
call ExecuteFunc("UIExtendEvent__onInit")
call ExecuteFunc("UIExtendResize__onInit")
call ExecuteFunc("UTSpellBtns__onInit")

//! initdatastructs
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



