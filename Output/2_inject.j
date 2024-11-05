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

#ifndef KKAPIINCLUDE
#define KKAPIINCLUDE

library LBKKAPI
        globals
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
        endglobals

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

endlibrary



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


#endif


//===========================================================================
//
// 只是另外一张魔兽争霸的地图
//
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Sun Nov 21 04:56:35 2021
//   Map Author: 未知
//
//===========================================================================
//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************
globals
    // Generated
    trigger gg_trg_______u = null
endglobals
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateUnitsForPlayer0 takes nothing returns nothing
    local player p = Player(0)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set u = CreateUnit( p, 'Hpal', 570.0, 552.3, 51.429 )
    set u = CreateUnit( p, 'hpea', -552.3, 69.1, 282.313 )
    set u = CreateUnit( p, 'hpea', -145.7, -39.9, 323.623 )
    set u = CreateUnit( p, 'hpea', 96.7, -330.2, 92.189 )
    set u = CreateUnit( p, 'hpea', -524.6, -462.3, 34.256 )
    set u = CreateUnit( p, 'hfoo', 502.5, -170.6, 231.775 )
    set u = CreateUnit( p, 'hfoo', 705.6, -242.4, 293.674 )
    set u = CreateUnit( p, 'hfoo', 813.7, -187.0, 59.053 )
    set u = CreateUnit( p, 'hfoo', 846.7, -125.9, 192.179 )
    set u = CreateUnit( p, 'Hblm', 123.7, 250.6, 0.000 )
    set u = CreateUnit( p, 'Hamg', -299.6, 414.6, 1.033 )
    set u = CreateUnit( p, 'Hmkg', 329.3, 207.7, 69.337 )
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
    call CreateUnitsForPlayer0( )
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings( )
    call CreatePlayerUnits( )
endfunction
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
//===========================================================================
// Trigger: 简介
//===========================================================================
//TESH.scrollpos=0
//TESH.alwaysfold=0
// 当前构建版本
// 当前的平台分包
    // 模型测试
    // lua_print: 模型测试
// #define StructMode // todo:结构体数量查看模式:用条件编译直接全部搞定
//函数入口
// lua_print: 模型地图
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
//模型测试
library MT requires optional Variable {
	group g = null;
	//单位模型
	function UnitModel (player p,string path) {
		unit u = CreateUnit(Player(0),'Hamg',GetRandomReal(0,300),GetRandomReal(0,300),GetRandomReal(0,360));
		DzSetUnitModel(u,path);
		// 这个是下面的变化,是异步的
		if (GetConvertedPlayerId(p) == GetConvertedPlayerId(GetLocalPlayer())) {
			DzSetUnitPortrait(u,path);
			SetCinematicScene('Hamg',GetPlayerColor(Player(0)),"","",.01,0);
			EndCinematicScene();
		}
		GroupAddUnit(g,u);
		u = null;
	}
	//普通一次性特效
	//绑定特效,并在5秒后删除
	function EfxB (string bind,string path) {
		timer t = CreateTimer();
		unit u = CreateUnit(Player(0),'Hblm',GetRandomReal(0,300),GetRandomReal(0,300),GetRandomReal(0,360));
		SaveEffectHandle(TITable,GetHandleId(t),1,AddSpecialEffectTargetUnitBJ(bind,u,path));
		SaveUnitHandle(TITable,GetHandleId(t),2,u);
		TimerStart(t,5.0,false,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			effect e = LoadEffectHandle(TITable,id,1);
			unit u = LoadUnitHandle(TITable,id,2);
			timer t2 = CreateTimer();
			DestroyEffect(e);
			SaveUnitHandle(TITable,GetHandleId(t2),1,u);
			TimerStart(t2,3.0,false,function (){
				timer t2 = GetExpiredTimer();
				integer id = GetHandleId(t2);
				unit u = LoadUnitHandle(TITable,id,1);
				RemoveUnit(u);
				PauseTimer(t2);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t2);
				t2 = null;
				u = null;
			});
			t2 = null;
			PauseTimer(t);
			FlushChildHashtable(TITable,id);
			DestroyTimer(t);
			t = null;
			e = null;
			u = null;
		});
		t = null;
	}
	//测试弹幕
	function Danmu (string path) {
		timer t = CreateTimer();
		real cx = 0, cy = 0;
		real dx = GetRandomReal(-1200,1200), dy = GetRandomReal(-1200,1200);
		real cz = 0, dz = GetRandomReal(300,600);
		real speed = 25.0;
		effect e = AddSpecialEffect(path, cx,cy);
		// EXEffectMatScale(e,2.0,2.0,2.0);
		EXEffectMatRotateZ(e,GetFacing(cx,cy,dx,dy));
		SaveEffectHandle(TITable,GetHandleId(t),1,e);
		SaveReal(TITable,GetHandleId(t),2,cx);
		SaveReal(TITable,GetHandleId(t),3,cy);
		SaveReal(TITable,GetHandleId(t),4,dx);
		SaveReal(TITable,GetHandleId(t),5,dy);
		SaveReal(TITable,GetHandleId(t),6,cz);
		SaveReal(TITable,GetHandleId(t),7,dz);
		SaveReal(TITable,GetHandleId(t),8,speed*(RAbsBJ(dz-cz))/GetDistance(cx,cy,dx,dy));
		SaveReal(TITable,GetHandleId(t),9,speed); //帧速度,乘间隔就是秒速
TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			effect e = LoadEffectHandle(TITable,id,1);
			real cx = LoadReal(TITable,id,2), cy = LoadReal(TITable,id,3);
			real dx = LoadReal(TITable,id,4), dy = LoadReal(TITable,id,5);
			real cz = LoadReal(TITable,id,6), dz = LoadReal(TITable,id,7);
			real speed = LoadReal(TITable,id,9), zSpeed = LoadReal(TITable,id,8);
			real angle = GetFacing(cx,cy,dx,dy);
			real ncx = YDWECoordinateX(cx + speed *CosBJ(angle)), ncy = YDWECoordinateY(cy + speed * SinBJ(angle)), ncz = zSpeed + cz;
			if (GetDistance(cx,cy,dx,dy) > speed) {
				//还行
				SaveReal(TITable,GetHandleId(t),2,ncx);
				SaveReal(TITable,GetHandleId(t),3,ncy);
				SaveReal(TITable,GetHandleId(t),6,ncz);
				EXSetEffectXY(e,ncx,ncy);
				EXSetEffectZ(e,ncz);
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
		e = null;
	}
	//UnitModel(p,"hero_singer.mdl");
	//Efx("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl");
	//EfxB("chest","Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorTarget.mdl");
	//Danmu("Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl");
	function TTestMT1 (player p) {
		UnitModel(p,"qiuti_antusheng.mdl");
		DestroyEffect(AddSpecialEffect("qiuti_antusheng.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","qiuti_antusheng.mdl");
		Danmu("qiuti_antusheng.mdl");
	}
	function TTestMT2 (player p) {
		UnitModel(p,"e_summon (7).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (7).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (7).mdl");
		Danmu("e_summon (7).mdl");
	}
	function TTestMT3 (player p) {
		UnitModel(p,"e_summon (6).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (6).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (6).mdl");
		Danmu("e_summon (6).mdl");
	}
	function TTestMT4 (player p) {
		UnitModel(p,"e_summon (5).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (5).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (5).mdl");
		Danmu("e_summon (5).mdl");
	}
	function TTestMT5 (player p) {
		UnitModel(p,"e_summon (4).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (4).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (4).mdl");
		Danmu("e_summon (4).mdl");
	}
	function TTestMT6 (player p) {
		UnitModel(p,"e_summon (3).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (3).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (3).mdl");
		Danmu("e_summon (3).mdl");
	}
	function TTestMT7 (player p) {
		UnitModel(p,"e_summon (2).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (2).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (2).mdl");
		Danmu("e_summon (2).mdl");
	}
	function TTestMT8 (player p) {
		UnitModel(p,"e_summon (1).mdl");
		DestroyEffect(AddSpecialEffect("e_summon (1).mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_summon (1).mdl");
		Danmu("e_summon (1).mdl");
	}
	function TTestMT9 (player p) {
		UnitModel(p,"e_pet_blink.mdl");
		DestroyEffect(AddSpecialEffect("e_pet_blink.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","e_pet_blink.mdl");
		Danmu("e_pet_blink.mdl");
	}
	function TTestMT10 (player p) {
		UnitModel(p,"effect_roar_langhun.mdl");
		DestroyEffect(AddSpecialEffect("effect_roar_langhun.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_roar_langhun.mdl");
		Danmu("effect_roar_langhun.mdl");
	}
	function TTestMT11 (player p) {
		UnitModel(p,"effect_langhun_f_target.mdl");
		DestroyEffect(AddSpecialEffect("effect_langhun_f_target.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_langhun_f_target.mdl");
		Danmu("effect_langhun_f_target.mdl");
	}
	function TTestMT12 (player p) {
		UnitModel(p,"effect_knight_w_blast.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_w_blast.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_knight_w_blast.mdl");
		Danmu("effect_knight_w_blast.mdl");
	}
	function TTestMT13 (player p) {
		UnitModel(p,"effect_knight_w_1.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_w_1.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_knight_w_1.mdl");
		Danmu("effect_knight_w_1.mdl");
	}
	function TTestMT14 (player p) {
		UnitModel(p,"effect_knight_r.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_r.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_knight_r.mdl");
		Danmu("effect_knight_r.mdl");
	}
	function TTestMT15 (player p) {
		UnitModel(p,"effect_knight_q_1.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_q_1.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_knight_q_1.mdl");
		Danmu("effect_knight_q_1.mdl");
	}
	function TTestMT16 (player p) {
		UnitModel(p,"effect_knight_f.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_f.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		EfxB("chest","effect_knight_f.mdl");
		Danmu("effect_knight_f.mdl");
	}
	function TTestMT17 (player p) {
		// UnitModel(p,"effect_knight_e_impact.mdl");
		// Efx("effect_knight_e_impact.mdl");
		EfxB("chest","effect_knight_e_impact.mdl");
		// Danmu("effect_knight_e_impact.mdl");
	}
	function TTestMT18 (player p) {
		// UnitModel(p,"effect_knight_e.mdl");
		DestroyEffect(AddSpecialEffect("effect_knight_e.mdl",GetRandomReal(-300,300),GetRandomReal(-300,300)));
		// EfxB("chest","effect_knight_e.mdl");
		// Danmu("effect_knight_e.mdl");
	}
	function TTestMT19 (player p) {
		//replace
	}
	function TTestMT20 (player p) {
		//replace
	}
	function TTestMT21 (player p) {
		//replace
	}
	function TTestMT22 (player p) {
		//replace
	}
	function TTestMT23 (player p) {
		//replace
	}
	function TTestMT24 (player p) {
		//replace
	}
	function TTestMT25 (player p) {
		//replace
	}
	function TTestMT26 (player p) {
		//replace
	}
	function TTestMT27 (player p) {
		//replace
	}
	function TTestMT28 (player p) {
		//replace
	}
	function TTestMT29 (player p) {
		//replace
	}
	function TTestMT30 (player p) {
		//replace
	}
	function TTestMT31 (player p) {
		//replace
	}
	function TTestMT32 (player p) {
		//replace
	}
	function TTestMT33 (player p) {
		//replace
	}
	function TTestMT34 (player p) {
		//replace
	}
	function TTestMT35 (player p) {
		//replace
	}
	function TTestMT36 (player p) {
		//replace
	}
	function TTestMT37 (player p) {
		//replace
	}
	function TTestMT38 (player p) {
		//replace
	}
	function TTestMT39 (player p) {
		//replace
	}
	function TTestMT40 (player p) {
		//replace
	}
	function TTestMT41 (player p) {
		//replace
	}
	function TTestMT42 (player p) {
		//replace
	}
	function TTestMT43 (player p) {
		//replace
	}
	function TTestMT44 (player p) {
		//replace
	}
	function TTestMT45 (player p) {
		//replace
	}
	function TTestMT46 (player p) {
		//replace
	}
	function TTestMT47 (player p) {
		//replace
	}
	function TTestMT48 (player p) {
		//replace
	}
	function TTestMT49 (player p) {
		//replace
	}
	function TTestMT50 (player p) {
		//replace
	}
	function DeleteUnits () {
		ForGroup(g,function () {
			RemoveUnit(GetEnumUnit());
		});
	}
	function onInit () {
		integer i;
		for (1 <= i <= 12) {
			CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() );
			SetCameraFieldForPlayer( ConvertedPlayer(i), CAMERA_FIELD_ZOFFSET, ( GetCameraTargetPositionZ() + 800.00 ), 0 );
		}
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;
			if (str == "t") DeleteUnits();
			if (str == "s1") TTestMT1(GetTriggerPlayer());
			else if(str == "s2") TTestMT2(GetTriggerPlayer());
			else if(str == "s3") TTestMT3(GetTriggerPlayer());
			else if(str == "s4") TTestMT4(GetTriggerPlayer());
			else if(str == "s5") TTestMT5(GetTriggerPlayer());
			else if(str == "s6") TTestMT6(GetTriggerPlayer());
			else if(str == "s7") TTestMT7(GetTriggerPlayer());
			else if(str == "s8") TTestMT8(GetTriggerPlayer());
			else if(str == "s9") TTestMT9(GetTriggerPlayer());
			else if(str == "s10") TTestMT10(GetTriggerPlayer());
			else if(str == "s11") TTestMT11(GetTriggerPlayer());
			else if(str == "s12") TTestMT12(GetTriggerPlayer());
			else if(str == "s13") TTestMT13(GetTriggerPlayer());
			else if(str == "s14") TTestMT14(GetTriggerPlayer());
			else if(str == "s15") TTestMT15(GetTriggerPlayer());
			else if(str == "s16") TTestMT16(GetTriggerPlayer());
			else if(str == "s17") TTestMT17(GetTriggerPlayer());
			else if(str == "s18") TTestMT18(GetTriggerPlayer());
			else if(str == "s19") TTestMT19(GetTriggerPlayer());
			else if(str == "s20") TTestMT20(GetTriggerPlayer());
			else if(str == "s21") TTestMT21(GetTriggerPlayer());
			else if(str == "s22") TTestMT22(GetTriggerPlayer());
			else if(str == "s23") TTestMT23(GetTriggerPlayer());
			else if(str == "s24") TTestMT24(GetTriggerPlayer());
			else if(str == "s25") TTestMT25(GetTriggerPlayer());
			else if(str == "s26") TTestMT26(GetTriggerPlayer());
			else if(str == "s27") TTestMT27(GetTriggerPlayer());
			else if(str == "s28") TTestMT28(GetTriggerPlayer());
			else if(str == "s29") TTestMT29(GetTriggerPlayer());
			else if(str == "s30") TTestMT30(GetTriggerPlayer());
			else if(str == "s31") TTestMT31(GetTriggerPlayer());
			else if(str == "s32") TTestMT32(GetTriggerPlayer());
			else if(str == "s33") TTestMT33(GetTriggerPlayer());
			else if(str == "s34") TTestMT34(GetTriggerPlayer());
			else if(str == "s35") TTestMT35(GetTriggerPlayer());
			else if(str == "s36") TTestMT36(GetTriggerPlayer());
			else if(str == "s37") TTestMT37(GetTriggerPlayer());
			else if(str == "s38") TTestMT38(GetTriggerPlayer());
			else if(str == "s39") TTestMT39(GetTriggerPlayer());
			else if(str == "s40") TTestMT40(GetTriggerPlayer());
			else if(str == "s41") TTestMT41(GetTriggerPlayer());
			else if(str == "s42") TTestMT42(GetTriggerPlayer());
			else if(str == "s43") TTestMT43(GetTriggerPlayer());
			else if(str == "s44") TTestMT44(GetTriggerPlayer());
			else if(str == "s45") TTestMT45(GetTriggerPlayer());
			else if(str == "s46") TTestMT46(GetTriggerPlayer());
			else if(str == "s47") TTestMT47(GetTriggerPlayer());
			else if(str == "s48") TTestMT48(GetTriggerPlayer());
			else if(str == "s49") TTestMT49(GetTriggerPlayer());
			else if(str == "s50") TTestMT50(GetTriggerPlayer());
		});
		g = CreateGroup();
	}
}
//! endzinc
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
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), true )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_002
    call SetPlayerTeam( Player(0), 0 )
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds( -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "LordaeronSummerDay" )
    call SetAmbientNightSound( "LordaeronSummerNight" )
    call SetMapMusic( "Music", true, 0 )
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
    call SetMapName( "只是另外一张魔兽争霸的地图" )
    call SetMapDescription( "没有说明" )
    call SetPlayers( 1 )
    call SetTeams( 1 )
    call SetGamePlacement( MAP_PLACEMENT_USE_MAP_SETTINGS )
    call DefineStartLocation( 0, -2048.0, 1088.0 )
    // Player setup
    call InitCustomPlayerSlots( )
    call SetPlayerSlotAvailable( Player(0), MAP_CONTROL_USER )
    call InitGenericPlayerSlots( )
endfunction
/**/
