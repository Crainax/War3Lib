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
//globals from SLKTable:
constant boolean LIBRARY_SLKTable=true
    hashtable HASH_SLK=InitHashtable()
//endglobals from SLKTable
//globals from Spell:
constant boolean LIBRARY_Spell=true
//endglobals from Spell
//globals from SpellData:
constant boolean LIBRARY_SpellData=true
//endglobals from SpellData
//globals from UnitTestFramwork:
constant boolean LIBRARY_UnitTestFramwork=true
    trigger UnitTestFramwork__TUnitTest=null
    hashtable UnitTestFramwork__HASH_UNITTEST=InitHashtable()
//endglobals from UnitTestFramwork
//globals from YDLua:
constant boolean LIBRARY_YDLua=true
//endglobals from YDLua
//globals from YDWEAbilityState:
constant boolean LIBRARY_YDWEAbilityState=true
		constant integer YDWEAbilityState__ABILITY_STATE_COOLDOWN = 1
		constant integer YDWEAbilityState__ABILITY_DATA_TARGS = 100 // integer
constant integer YDWEAbilityState__ABILITY_DATA_CAST = 101 // real
constant integer YDWEAbilityState__ABILITY_DATA_DUR = 102 // real
constant integer YDWEAbilityState__ABILITY_DATA_HERODUR = 103 // real
constant integer YDWEAbilityState__ABILITY_DATA_COST = 104 // integer
constant integer YDWEAbilityState__ABILITY_DATA_COOL = 105 // real
constant integer YDWEAbilityState__ABILITY_DATA_AREA = 106 // real
constant integer YDWEAbilityState__ABILITY_DATA_RNG = 107 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_A = 108 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_B = 109 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_C = 110 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_D = 111 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_E = 112 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_F = 113 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_G = 114 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_H = 115 // real
constant integer YDWEAbilityState__ABILITY_DATA_DATA_I = 116 // real
constant integer YDWEAbilityState__ABILITY_DATA_UNITID = 117 // integer
		constant integer YDWEAbilityState__ABILITY_DATA_HOTKET = 200 // integer
constant integer YDWEAbilityState__ABILITY_DATA_UNHOTKET = 201 // integer
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_HOTKEY = 202 // integer
constant integer YDWEAbilityState__ABILITY_DATA_NAME = 203 // string
constant integer YDWEAbilityState__ABILITY_DATA_ART = 204 // string
constant integer YDWEAbilityState__ABILITY_DATA_TARGET_ART = 205 // string
constant integer YDWEAbilityState__ABILITY_DATA_CASTER_ART = 206 // string
constant integer YDWEAbilityState__ABILITY_DATA_EFFECT_ART = 207 // string
constant integer YDWEAbilityState__ABILITY_DATA_AREAEFFECT_ART = 208 // string
constant integer YDWEAbilityState__ABILITY_DATA_MISSILE_ART = 209 // string
constant integer YDWEAbilityState__ABILITY_DATA_SPECIAL_ART = 210 // string
constant integer YDWEAbilityState__ABILITY_DATA_LIGHTNING_EFFECT = 211 // string
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_TIP = 212 // string
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_UBERTIP = 213 // string
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_TIP = 214 // string
constant integer YDWEAbilityState__ABILITY_DATA_TIP = 215 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNTIP = 216 // string
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_UBERTIP = 217 // string
constant integer YDWEAbilityState__ABILITY_DATA_UBERTIP = 218 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNUBERTIP = 219 // string
constant integer YDWEAbilityState__ABILITY_DATA_UNART = 220 // string
//endglobals from YDWEAbilityState
//globals from Hardware:
constant boolean LIBRARY_Hardware=true
//endglobals from Hardware
//globals from Logger:
constant boolean LIBRARY_Logger=true
    integer logger_level=0
    string logger_msg=null
    player logger_p=null
    trigger logger_tr=null
//endglobals from Logger
//globals from UTSpell:
constant boolean LIBRARY_UTSpell=true
    unit UTSpell___testArchmage=null
    unit UTSpell___testFootman=null
//endglobals from UTSpell
//globals from UnitSelect:
constant boolean LIBRARY_UnitSelect=true
//endglobals from UnitSelect
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
//library SLKTable:

//library SLKTable ends
//library Spell:
    struct spell   // 技能拥有者
    //! pragma implicitthis
        unit owner  // 技能ID(一致则1类,不一致则2类,为0则是3类)
        integer id  // 技能实例的对应技能数据
        spellData sd
        method isExist takes nothing returns boolean
            return (this!=null and si__spell_V[this]==-1)
        endmethod
        static method parse takes unit u,integer id returns thistype
            local thistype this
            local integer handleId=GetHandleId(u)  // 先检查是否已存在
            if (HaveSavedInteger(HASH_UNIT,handleId,HASH_KEY_UNIT_MONSTER))then
                return LoadInteger(HASH_UNIT,handleId,HASH_KEY_UNIT_MONSTER)
            endif  // 不存在才创建新的
            set this=allocate()
            set this.u=u
            set thistype.md=monsterData.byType(GetUnitTypeId(u))
            set this.gold=this.md.gold
            set this.exp=this.md.exp
            set this.kill=this.md.kill
            call this.useDefaultDrop()  //其他地图的自定义属性
            static if LIBRARY_AllMonster then  //使用默认掉落模式
                call this.initAllMonster()
            endif
            call SaveInteger(HASH_UNIT,handleId,HASH_KEY_UNIT_MONSTER,this)
            return this
        endmethod
    endstruct

//library Spell ends
//library SpellData:
    struct spellData extends array
    //! pragma implicitthis
        static integer counter=0  // 技能ID(从那边直接获取数据)
        integer id  // 技能等级(最大等级)
        integer maxLevel  // 技能描述
        string description  // 技能图标
        string icon  //根据技能类型
        static method byType takes integer at returns thistype
            local thistype this
            if (HaveSavedInteger(HASH_SLK,at,1727))then
                set this=LoadInteger(HASH_SLK,at,1727)
            else
                set counter=counter+1
                set this=thistype[counter]
                call SaveInteger(HASH_SLK,at,1727,this)
                set id=at
            endif
            return this
        endmethod
    endstruct

//library SpellData ends
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
//library YDLua:

    function initializeLua takes nothing returns integer
        call Cheat("exec-lua:plugin_main")
        return 0
    endfunction
        function YDLua___anon__0 takes nothing returns nothing  //在游戏开始0.0秒后再调用
            call BJDebugMsg("调用了YDLua引擎")
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function YDLua___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.0,false)
        call TriggerAddCondition(tr,Condition(function YDLua___anon__0))
        set tr=null
    endfunction

//library YDLua ends
//library YDWEAbilityState:
	native EXGetUnitAbility takes unit u, integer abilcode returns ability
	native EXGetUnitAbilityByIndex takes unit u, integer index returns ability
	native EXGetAbilityId takes ability abil returns integer
	native EXGetAbilityState takes ability abil, integer state_type returns real
	native EXSetAbilityState takes ability abil, integer state_type, real value returns boolean
	native EXGetAbilityDataReal takes ability abil, integer level, integer data_type returns real
	native EXSetAbilityDataReal takes ability abil, integer level, integer data_type, real value returns boolean
	native EXGetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
	native EXSetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
	native EXGetAbilityDataString takes ability abil, integer level, integer data_type returns string
	native EXSetAbilityDataString takes ability abil, integer level, integer data_type, string value returns boolean
	function YDWEGetUnitAbilityState takes unit u, integer abilcode, integer state_type returns real
		return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type)
	endfunction
	function YDWEGetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type returns integer
		return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWEGetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type returns real
		return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWEGetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type returns string
		return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
	function YDWESetUnitAbilityState takes unit u, integer abilcode, integer state_type, real value returns boolean
		return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value)
	endfunction
	function YDWESetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type, integer value returns boolean
		return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	function YDWESetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type, real value returns boolean
		return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	function YDWESetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type, string value returns boolean
		return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
	native EXSetAbilityAEmeDataA takes ability abil, integer unitid returns boolean
	function YDWEUnitTransform takes unit u, integer abilcode, integer targetid returns nothing
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, YDWEAbilityState__ABILITY_DATA_UNITID, GetUnitTypeId(u))
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), GetUnitTypeId(u))
		call UnitRemoveAbility(u, abilcode)
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid)
		call UnitRemoveAbility(u, abilcode)
	endfunction
	native EXGetItemDataString takes integer itemcode, integer data_type returns string
	native EXSetItemDataString takes integer itemcode, integer data_type, string value returns boolean
	function YDWEGetItemDataString takes integer itemcode, integer data_type returns string
		return EXGetItemDataString(itemcode, data_type)
	endfunction
	function YDWESetItemDataString takes integer itemcode, integer data_type, string value returns boolean
		return EXSetItemDataString(itemcode, data_type, value)
	endfunction

//library YDWEAbilityState ends
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
            call BJDebugMsg("注册鼠标移动事件")
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
//library Logger:

    function Trace takes string msg returns nothing
        set logger_msg=msg
        set logger_level=0
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 调试级别日志(绿色),用于输出变量值等调试信息
    function Debug takes string msg returns nothing
        set logger_msg=msg
        set logger_level=1
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 信息级别日志(白色),用于输出普通提示信息
    function Info takes string msg returns nothing
        set logger_msg=msg
        set logger_level=2
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 警告级别日志(黄色),用于输出警告信息
    function Warn takes string msg returns nothing
        set logger_msg=msg
        set logger_level=3
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 错误级别日志(红色),用于输出错误信息
    function Error takes string msg returns nothing
        set logger_msg=msg
        set logger_level=4
        set logger_p=GetLocalPlayer()
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出追踪日志(灰色)
    function TraceToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=0
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出调试日志(绿色)
    function DebugToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=1
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出信息日志(白色)
    function InfoToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=2
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出警告日志(黄色)
    function WarnToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=3
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction  // 向指定玩家输出错误日志(红色)
    function ErrorToPlayer takes player p,string msg returns nothing
        set logger_msg=msg
        set logger_level=4
        set logger_p=p
        call TriggerEvaluate(logger_tr)
    endfunction
    function Logger___onInit takes nothing returns nothing  //日志打印系统初始化
        call Cheat("exec-lua:depends.debug.logger")
    endfunction

//library Logger ends
//library UTSpell:

    struct UTSpell___spell [20000]
    //! pragma implicitthis
        integer id
        integer level
        integer sdId
    endstruct  // 添加全局测试单位变量
        function UTSpell___anon__0 takes nothing returns nothing  //start
        endfunction  //end
        function UTSpell___anon__1 takes nothing returns nothing
        endfunction
        function UTSpell___anon__2 takes nothing returns nothing  //assert.Boolean(true, "测试1");
        endfunction  //spell
        function UTSpell___anon__3 takes nothing returns nothing  //结论:EXGetUnitAbility获取百位动态技能
            local unit u=unitSelect.argsSync  //DzUnitFindAbility获取正常Handle技能,未学习的技能没有Handle,学习后的Handle不是最大的(代表不是新建的) //AInv这个物品栏技能不知道为什么步兵也有 //删除再新建后,Handle会变
            local integer index
            local ability a=null
            local ability b=null
            call Trace("已选择单位:"+GetUnitName(u))
            set b=DzUnitFindAbility(u,'AHbz')
            call Trace(" AHbz: "+I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u,'AHab')
            call Trace(" AHab: "+I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u,'AHwe')
            call Trace(" AHwe: "+I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u,'AHmt')
            call Trace(" AHmt: "+I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u,'AInv')
            call Trace(" AInv: "+I2S(GetHandleId(b)))
            set b=DzUnitFindAbility(u,'Adef')
            call Trace(" Adef: "+I2S(GetHandleId(b)))
            set u=null
        endfunction
    function UTSpell___Init takes nothing returns nothing
        call UnitTestAutoTimer(0.1,2.0,function UTSpell___anon__0,function UTSpell___anon__1)
        call UnitTestAutoTimer(0.1,2.0,function UTSpell___anon__2,null)
        call unitSelect.onSync(function UTSpell___anon__3)
    endfunction  //测试一下Japi获取的技能
    function UTSpell___TTestUTSpell1 takes player p returns nothing  // 在(0,0)位置创建大法师
        set UTSpell___testArchmage=CreateUnit(p,'Hamg',0,0,270)  // 在(200,0)位置创建步兵
        set UTSpell___testFootman=CreateUnit(p,'hfoo',200,0,270)  // 将大法师升到10级
        call SetHeroLevel(UTSpell___testArchmage,10,true)
        call Trace("已创建大法师和步兵用于测试")
    endfunction
    function UTSpell___TTestUTSpell2 takes player p returns nothing
        if (UTSpell___testFootman!=null)then  // 移除防御技能
            call UnitRemoveAbility(UTSpell___testFootman,'Adef')
            call Trace("已移除步兵的防御技能")
        else
            call Trace("错误：请先使用s1创建测试单位")
        endif
    endfunction
    function UTSpell___TTestUTSpell3 takes player p returns nothing
        if (UTSpell___testFootman!=null)then  // 添加防御技能
            call UnitAddAbility(UTSpell___testFootman,'Adef')
            call Trace("已给步兵添加防御技能")
        else
            call Trace("错误：请先使用s1创建测试单位")
        endif
    endfunction
    function UTSpell___TTestUTSpell4 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell5 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell6 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell7 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell8 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell9 takes player p returns nothing
    endfunction
    function UTSpell___TTestUTSpell10 takes player p returns nothing
    endfunction
    function UTSpell___TTestActUTSpell1 takes string str returns nothing
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
        function UTSpell___anon__4 takes nothing returns nothing  //在游戏开始0.0秒后再调用
            call BJDebugMsg("[Spell] 单元测试已加载")
            call UTSpell___Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTSpell___anon__5 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if (SubString(str,(1)-1,1)=="-")then
                call UTSpell___TTestActUTSpell1(SubString(str,(2)-1,StringLength(str)))
                return
            endif
            if (str=="s1")then
                call UTSpell___TTestUTSpell1(GetTriggerPlayer())
            elseif (str=="s2")then
                call UTSpell___TTestUTSpell2(GetTriggerPlayer())
            elseif (str=="s3")then
                call UTSpell___TTestUTSpell3(GetTriggerPlayer())
            elseif (str=="s4")then
                call UTSpell___TTestUTSpell4(GetTriggerPlayer())
            elseif (str=="s5")then
                call UTSpell___TTestUTSpell5(GetTriggerPlayer())
            elseif (str=="s6")then
                call UTSpell___TTestUTSpell6(GetTriggerPlayer())
            elseif (str=="s7")then
                call UTSpell___TTestUTSpell7(GetTriggerPlayer())
            elseif (str=="s8")then
                call UTSpell___TTestUTSpell8(GetTriggerPlayer())
            elseif (str=="s9")then
                call UTSpell___TTestUTSpell9(GetTriggerPlayer())
            elseif (str=="s10")then
                call UTSpell___TTestUTSpell10(GetTriggerPlayer())
            endif
        endfunction
    function UTSpell___onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr,0.5,false)
        call TriggerAddCondition(tr,Condition(function UTSpell___anon__4))
        set tr=null
        call UnitTestRegisterChatEvent(function UTSpell___anon__5)
    endfunction

//library UTSpell ends
//library UnitSelect:
    struct unitSelect extends array  //回调传参用(异步)
    //! pragma implicitthis
        static unit args=null  //回调传参用(同步)
        static unit argsSync=null  //每个人当前选择的单位(同步)
        static unit  array currentU
        //private:
            private static trigger trAsync
            private static trigger trAsyncUn
            private static trigger trSync
            private static trigger trSyncUn  //现在的选择单位-异步(每个人的引用不一样)
            private static unit asyncU=null
        static method onAsync takes code func returns nothing  // 异步时选中单位调用,在取消选择后面 // 调用这个函数注册过程要同步,不能注册的时候异步
            call TriggerAddCondition(trAsync,Condition(func))
        endmethod  // 异步时取消选择单位调用
        static method onAsyncUn takes code func returns nothing  // 调用这个函数注册过程要同步,不能注册的时候异步
            call TriggerAddCondition(trAsyncUn,Condition(func))
        endmethod  // 同步时选中单位调用
        static method onSync takes code func returns nothing
            call TriggerAddCondition(trSync,Condition(func))
        endmethod  // 同步时取消选择单位调用
        static method onSyncUn takes code func returns nothing
            call TriggerAddCondition(trSyncUn,Condition(func))
        endmethod  //初始化
            private static method anon__0 takes nothing returns nothing  //一次性用的选择事件 //选单位的事件[同步] //单位选择事件[同步]
                local integer index=GetConvertedPlayerId(GetTriggerPlayer())
                if (GetTriggerUnit()!=unitSelect.currentU[index])then
                    set unitSelect.argsSync=unitSelect.currentU[index]  //事件里用unitSelect.argsSync来指代
                    call TriggerEvaluate(trSyncUn)
                    set unitSelect.argsSync=GetTriggerUnit()  //事件里用unitSelect.argsSync来指代
                    call TriggerEvaluate(trSync)
                    set unitSelect.currentU[index]=GetTriggerUnit()
                    set unitSelect.argsSync=null
                endif
            endmethod  //注册2个事件:选择单位,与不选择事件
            private static method anon__1 takes nothing returns nothing
                if (DzGetSelectedLeaderUnit()!=unitSelect.asyncU)then
                    set unitSelect.args=unitSelect.asyncU  //事件里用unitSelect.args来指代
                    call TriggerEvaluate(trAsyncUn)
                    set unitSelect.args=DzGetSelectedLeaderUnit()  //事件里用unitSelect.args来指代
                    call TriggerEvaluate(trAsync)
                    set unitSelect.asyncU=DzGetSelectedLeaderUnit()
                    set unitSelect.args=null
                endif
            endmethod
        static method onInit takes nothing returns nothing
            local integer i
            local trigger tr=CreateTrigger()
            set trAsync=CreateTrigger()
            set trAsyncUn=CreateTrigger()
            set trSync=CreateTrigger()
            set trSyncUn=CreateTrigger()
            set i=1
            loop
            exitwhen (i>12)
                call TriggerRegisterPlayerSelectionEventBJ(tr,ConvertedPlayer(i),true)
            set i = i+1
            endloop
            call TriggerAddCondition(tr,Condition(function thistype.anon__0))
            call hardware.regUpdateEvent(function thistype.anon__1)
        endmethod
    endstruct

//library UnitSelect ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小

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

// 物品掉落相关键值 (预留20个空间 1800-1819/1820-1839)  MonsterData
// 技能相关键值 (预留200个空间 2000-2199) UnitData
// 2400开始可继续添加新的键值定义...
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
//这两条是用到YDWE函数就要导入的,没用到就不用导入
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

//! initstructs
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("YDLua___onInit")
call ExecuteFunc("Logger___onInit")
call ExecuteFunc("UTSpell___onInit")

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



