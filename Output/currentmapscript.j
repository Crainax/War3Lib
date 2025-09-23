globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
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
//globals from UIEventModule:
constant boolean LIBRARY_UIEventModule=true
//endglobals from UIEventModule
//globals from UIId:
constant boolean LIBRARY_UIId=true
//endglobals from UIId
//globals from UIImageModule:
constant boolean LIBRARY_UIImageModule=true
//endglobals from UIImageModule
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
    trigger UnitTestFramwork__TUnitTest=null
    hashtable UnitTestFramwork__HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from YDTriggerSaveLoadSystem:
constant boolean LIBRARY_YDTriggerSaveLoadSystem=true
        hashtable YDHT
    hashtable YDLOC
//endglobals from YDTriggerSaveLoadSystem
//globals from UITocInit:
constant boolean LIBRARY_UITocInit=true
//endglobals from UITocInit
//globals from UIUtils:
constant boolean LIBRARY_UIUtils=true
//endglobals from UIUtils
//globals from UIBaseModule:
constant boolean LIBRARY_UIBaseModule=true
//endglobals from UIBaseModule
//globals from UIButton:
constant boolean LIBRARY_UIButton=true
//endglobals from UIButton
//globals from UIImage:
constant boolean LIBRARY_UIImage=true
//endglobals from UIImage
//globals from UTUIButton:
constant boolean LIBRARY_UTUIButton=true
    uiBtn UTUIButton__currentBtn=0
//endglobals from UTUIButton
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
                set tan=Tan((a)*0.0174538)
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
                set tan=Tan((a)*0.0174538)
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
                set tan=Tan((a)*0.0174538)
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
                set tan=Tan((a)*0.0174538)
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
    endstruct  // 实现三个数值的特殊叠加计算
    function RealAdd3 takes real a1,real a2,real a3 returns real  // 效果等同于 RealAdd(RealAdd(a1,a2),a3) // // 参数说明： // a1: 第一个数值，通常表示当前已有的加成效果 // a2: 第二个数值，表示第一次要叠加的新加成效果 // a3: 第三个数值，表示第二次要叠加的新加成效果 // 返回值: 三个数值叠加后的最终效果值 // // 使用示例： // real baseEffect = 0.3;     // 基础30%效果 // real bonus1 = 0.4;         // 第一个40%加成 // real bonus2 = 0.2;         // 第二个20%加成 // real final = RealAdd3(baseEffect, bonus1, bonus2);  // 一次性计算三个效果的叠加
        local real temp  // 如果第二个参数绝对值>=1.0，直接用第一个参数与第三个参数计算
        if (RAbsBJ(a2)>=1.0)then
            return RealAdd(a1,a3)
        endif  // 如果第三个参数绝对值>=1.0，直接返回前两个参数的计算结果
        if (RAbsBJ(a3)>=1.0)then
            return RealAdd(a1,a2)
        endif  // 先计算前两个参数的结果
        if (a2>=0)then
            set temp=1.0-(1.0-a1)*(1.0-a2)
        else
            set temp=1.0-(1.0-a1)/(1.0+a2)
        endif  // 再与第三个参数计算
        if (a3>=0)then
            return 1.0-(1.0-temp)*(1.0-a3)
        else
            return 1.0-(1.0-temp)/(1.0+a3)
        endif
    endfunction

//library MathUtils ends
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
//library UnitTestFramwork:

    struct assert extends array  //断言布尔值
    //! pragma implicitthis
        static method Boolean takes boolean condition,string name returns nothing
            if (not condition)then
                call BJDebugMsg("FAIL: "+name)
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言字符串相等
        static method String takes string actual,string expected,string name returns nothing
            if (actual!=expected)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+expected)
                call BJDebugMsg("  Actual: "+actual)
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言整数相等
        static method Integer takes integer actual,integer expected,string name returns nothing
            if (actual!=expected)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+I2S(expected))
                call BJDebugMsg("  Actual: "+I2S(actual))
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod  //断言浮点数相等
        static method Real takes real actual,real expected,string name returns nothing  // 取两个数的绝对值的较大值
            local real maxValue=RMaxBJ(RAbsBJ(actual),RAbsBJ(expected))  // 相对误差为数值大小的万分之一
            local real epsilon=maxValue*0.00001  // 处理接近0的特殊情况
            if (maxValue<0.00001)then
                set epsilon=0.00001
            endif
            if (RAbsBJ(actual-expected)>epsilon)then
                call BJDebugMsg("FAIL: "+name)
                call BJDebugMsg("  Expected: "+R2SW(expected,0,1))
                call BJDebugMsg("  Actual: "+R2SW(actual,0,1))
            else
                call BJDebugMsg("PASS: "+name)
            endif
        endmethod
    endstruct  //注册单元测试事件(聊天内容),自动注入
    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest,func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork__anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()),3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 "+R2SW(time,0,1)+" - "+R2SW(time+d,0,1)+" 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST,GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t,Condition(start))
        call TriggerRegisterTimerEvent(tr,time,false)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),1,time)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),2,duration)
        call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),3,t)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__0))
        if (end!=null)then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t,Condition(end))
            call TriggerRegisterTimerEvent(tr,time+duration,false)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),1,time)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),2,duration)
            call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST,GetHandleId(tr),3,t)
            call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork__anon__2 takes nothing returns nothing  //在游戏开始0.1秒后再调用
            local integer i
            set i=1
            loop
            exitwhen (i>12)
                call SetPlayerName(ConvertedPlayer(i),"测试员"+I2S(i)+"号")  //迷雾全关
                call CreateFogModifierRectBJ(true,ConvertedPlayer(i),FOG_OF_WAR_VISIBLE,bj_mapInitialPlayableArea)
            set i = i+1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.1,false)
        call TriggerAddCondition(tr,Condition(function UnitTestFramwork__anon__2))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(0),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(1),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(2),"",false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest,Player(3),"",false)
    endfunction

//library UnitTestFramwork ends
//library YDTriggerSaveLoadSystem:
//#  define YDTRIGGER_handle(SG)                          YDTRIGGER_HT##SG##(HashtableHandle)
    function YDTriggerSaveLoadSystem___Init takes nothing returns nothing
            set YDHT = InitHashtable()
        set YDLOC = InitHashtable()
    endfunction

//library YDTriggerSaveLoadSystem ends
//library UITocInit:

    function UITocInit___onInit takes nothing returns nothing
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
//library UIBaseModule:
    module uiBaseModule  // 设置位置
        method setPoint takes integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX,offsetY)
            return this
        endmethod  // 设置位置
        method setPointFix takes integer anchor,integer relative,integer relativeAnchor,real offsetX,real offsetY returns thistype
            if (not (this.isExist()))then
                return this
            endif
            call DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX*GetResizeRate(),offsetY)
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
            set ui=DzCreateFrameByTagName("GLUEBUTTON","Btn"+I2S(id),parent,"TEMPLATE_TEXT_BUTTON",0)
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
//library UTUIButton:

    function UTUIButton__TTestUTUIButton1 takes player p returns nothing
        local uiImage img
        if (GetLocalPlayer()==p)then
            set img=uiImage.create(DzGetGameUI()).setSize(0.04,0.04).setTexture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp").setPoint(4,DzGetGameUI(),4,0.0,0.0)
            set UTUIButton__currentBtn=uiBtn.create(DzGetGameUI()).setAllPoint(img.ui)
            call BJDebugMsg("创建了一个基础按钮UI")
        endif
    endfunction  // 测试按钮事件系统
        function UTUIButton__anon__0 takes nothing returns nothing
            call BJDebugMsg("鼠标进入按钮")
        endfunction
        function UTUIButton__anon__1 takes nothing returns nothing
            call BJDebugMsg("鼠标离开按钮")
        endfunction
        function UTUIButton__anon__2 takes nothing returns nothing
            call BJDebugMsg("点击按钮")
        endfunction
    function UTUIButton__TTestUTUIButton2 takes player p returns nothing
        if (GetLocalPlayer()==p)then
            set UTUIButton__currentBtn=uiBtn.create(DzGetGameUI()).setSize(0.04,0.04).setPoint(4,DzGetGameUI(),4,0.0,0.0).onMouseEnter(function UTUIButton__anon__0).onMouseLeave(function UTUIButton__anon__1).onMouseClick(function UTUIButton__anon__2)
            call BJDebugMsg("创建了一个带事件的按钮UI")
        endif
    endfunction  // 测试空白按钮
        function UTUIButton__anon__3 takes nothing returns nothing
            call BJDebugMsg("鼠标进入按钮")
        endfunction
        function UTUIButton__anon__4 takes nothing returns nothing
            call BJDebugMsg("鼠标离开按钮")
        endfunction
        function UTUIButton__anon__5 takes nothing returns nothing
            call BJDebugMsg("点击按钮")
        endfunction
        function UTUIButton__anon__6 takes nothing returns nothing
            call BJDebugMsg("鼠标滚轮:"+I2S(DzGetTriggerUIEventFrame()))
        endfunction
        function UTUIButton__anon__7 takes nothing returns nothing
            call BJDebugMsg("鼠标双击:"+I2S(DzGetTriggerUIEventFrame()))
        endfunction
    function UTUIButton__TTestUTUIButton3 takes player p returns nothing
        local uiBtn blankBtn=uiBtn.createBlank(DzGetGameUI()).setSize(0.04,0.04).setPoint(4,DzGetGameUI(),4,0.0,0.0).onMouseEnter(function UTUIButton__anon__3).onMouseLeave(function UTUIButton__anon__4).onMouseClick(function UTUIButton__anon__5).onMouseWheel(function UTUIButton__anon__6).onMouseDoubleClick(function UTUIButton__anon__7)
        local uiImage img=uiImage.create(DzGetGameUI()).setTexture("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp").setAllPoint(blankBtn.ui)
        call BJDebugMsg("创建了空白按钮UI")
    endfunction  // 测试按钮销毁功能
    function UTUIButton__TTestUTUIButton4 takes player p returns nothing
        if (GetLocalPlayer()==p)then
            if (UTUIButton__currentBtn!=0)then
                call UTUIButton__currentBtn.destroy()
                call BJDebugMsg("销毁了当前按钮")
                set UTUIButton__currentBtn=0
            else
                call BJDebugMsg("当前没有可销毁的按钮")
            endif
        endif
    endfunction
        function UTUIButton__anon__8 takes nothing returns nothing
            call BJDebugMsg("鼠标进入按钮")
        endfunction
        function UTUIButton__anon__9 takes nothing returns nothing
            call BJDebugMsg("鼠标离开按钮")
        endfunction
        function UTUIButton__anon__10 takes nothing returns nothing
            call BJDebugMsg("点击按钮")
        endfunction
    function UTUIButton__TTestUTUIButton5 takes player p returns nothing
        if (GetLocalPlayer()==p)then
            set UTUIButton__currentBtn=uiBtn.createRC(DzGetGameUI()).setSize(0.04,0.04).setPoint(4,DzGetGameUI(),4,0.0,0.0).onMouseEnter(function UTUIButton__anon__8).onMouseLeave(function UTUIButton__anon__9).onMouseClick(function UTUIButton__anon__10)
            call BJDebugMsg("创建了一个带事件的按钮UI")
        endif
    endfunction
        function UTUIButton__anon__11 takes nothing returns nothing
            call BJDebugMsg("鼠标进入按钮")
        endfunction
        function UTUIButton__anon__12 takes nothing returns nothing
            call BJDebugMsg("鼠标离开按钮")
        endfunction
        function UTUIButton__anon__13 takes nothing returns nothing
            call BJDebugMsg("点击按钮")
        endfunction
    function UTUIButton__TTestUTUIButton6 takes player p returns nothing
        if (GetLocalPlayer()==p)then
            set UTUIButton__currentBtn=uiBtn.createMenu(DzGetGameUI()).setSize(0.179,0.031).setPoint(4,DzGetGameUI(),4,0.0,0.0).onMouseEnter(function UTUIButton__anon__11).onMouseLeave(function UTUIButton__anon__12).onMouseClick(function UTUIButton__anon__13)
            call BJDebugMsg("创建了一个菜单系的按钮UI")
        endif
    endfunction
    function UTUIButton__TTestUTUIButton7 takes player p returns nothing
    endfunction
    function UTUIButton__TTestUTUIButton8 takes player p returns nothing
    endfunction
    function UTUIButton__TTestUTUIButton9 takes player p returns nothing
    endfunction
    function UTUIButton__TTestUTUIButton10 takes player p returns nothing  // 处理带参数的测试命令
    endfunction
    function UTUIButton__TTestActUTUIButton1 takes string str returns nothing
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
        if (paramS[0]=="a")then  // 可以添加带参数的测试功能
        elseif (paramS[0]=="b")then  // 可以添加带参数的测试功能
        endif
        set p=null
    endfunction
        function UTUIButton__anon__14 takes nothing returns nothing  //在游戏开始0.5秒后再调用
            call BJDebugMsg("[UIButton] 单元测试已加载")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTUIButton__anon__15 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if (SubString(str,(1)-1,1)=="-")then
                call UTUIButton__TTestActUTUIButton1(SubString(str,(2)-1,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTUIButton__TTestUTUIButton1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTUIButton__TTestUTUIButton2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTUIButton__TTestUTUIButton3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTUIButton__TTestUTUIButton4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTUIButton__TTestUTUIButton5(GetTriggerPlayer())
            elseif (str=="s6")then
                call UTUIButton__TTestUTUIButton6(GetTriggerPlayer())
            elseif (str=="s7")then
                call UTUIButton__TTestUTUIButton7(GetTriggerPlayer())
            elseif (str=="s8")then
                call UTUIButton__TTestUTUIButton8(GetTriggerPlayer())
            elseif (str=="s9")then
                call UTUIButton__TTestUTUIButton9(GetTriggerPlayer())
            elseif (str=="s10")then
                call UTUIButton__TTestUTUIButton10(GetTriggerPlayer())
            endif
        endfunction
    function UTUIButton__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.5,false)
        call TriggerAddCondition(tr,Condition(function UTUIButton__anon__14))
        set tr=null
        call UnitTestRegisterChatEvent(function UTUIButton__anon__15)
    endfunction

//library UTUIButton ends
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
//控件的共用基本方法

// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
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
// 结构体共用方法定义
//共享打印方法
// UI组件内部共享方法及成员
// UI组件依赖库
// UI组件创建时共享调用
// UI组件销毁时共享调用

//窗口的大小
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
// redeclaration of library YDTriggerSaveLoadSystem skipped
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
    // 单元测试
    // lua_print: 单元测试
//这两条是用到YDWE函数就要导入的,没用到就不用导入
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
call ExecuteFunc("YDTriggerSaveLoadSystem___Init")
call ExecuteFunc("UITocInit___onInit")
call ExecuteFunc("UTUIButton__onInit")

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



