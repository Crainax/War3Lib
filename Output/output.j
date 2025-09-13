globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from DzAPI:
constant boolean LIBRARY_DzAPI=true
//endglobals from DzAPI
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
//globals from MallItem:
constant boolean LIBRARY_MallItem=true
//endglobals from MallItem
//globals from UTMallItem:
constant boolean LIBRARY_UTMallItem=true
//endglobals from UTMallItem
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
constant integer si__assert=1
constant integer si__mallItem=2
boolean s__mallItem_initialized=false
boolean s__mallItem_ready=false
trigger s__mallItem_readyTrigger=null
hashtable s__mallItem_table=null
integer s__mallItem_itemCount=0
string array s__mallItem_itemKeys
boolean array s__mallItem_owns
integer array s__mallItem_uses
string array s__mallItem_names
string array s__mallItem_icons
string array s__mallItem_descs
integer array s__mallItem_techs
player s__mallItem_callbackPlayer=null

endglobals
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
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    native DzSyncDataImmediately takes string prefix, string data returns nothing 
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
    native DzFrameAddText takes integer frame, string text returns nothing
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    native DzUpdateMinimap takes nothing returns nothing
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    native DzSaveMemoryCache takes string cache returns nothing
    native DzGetMemoryCache takes nothing returns string
    native DzSetSpeed takes real ratio returns nothing
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    native DzGetConvertWorldPositionX takes nothing returns real
    native DzGetConvertWorldPositionY takes nothing returns real
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
    native DzAPI_Map_HasMallItem takes player whichPlayer, string key returns boolean
    native DzAPI_Map_GetMapLevel takes player whichPlayer returns integer
    native RequestExtraIntegerData takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns integer
    native RequestExtraBooleanData takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns boolean
    native RequestExtraStringData takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns string
    native RequestExtraRealData takes integer dataType, player whichPlayer, string param1, string param2, boolean param3, integer param4, integer param5, integer param6 returns real


//library BzAPI:
    //hardware




























    //plus











    //sync






    //native DzGetPushContext takes nothing returns string

    //gui











































































        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）

    // 沉默单位-禁用技能

    // 禁用攻击

    // 禁用道具

    // 刷新小地图

    // 修改单位alpha

    // 设置单位是否可以选中

    // 修改单位是否可以被设置为目标

    // 保存内存数据

    // 读取内存数据

    // 设置加速倍率

    // 转换世界坐标为屏幕坐标-异步

    // 转换世界坐标为屏幕坐标-获取转换后的X坐标

    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标

    // 创建command button

    function DzTriggerRegisterMouseEventTrg takes trigger trg,integer status,integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction
    function DzTriggerRegisterKeyEventTrg takes trigger trg,integer status,integer btn returns nothing
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
//library DzAPI:


    // native DzAPI_Map_GetGuildName takes player whichPlayer returns string




    
    // SaveServerValue,               //保存服务器存档
    function DzAPI_Map_SaveServerValue takes player whichPlayer,string key,string value returns boolean
        return RequestExtraBooleanData(4, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    // GetServerValue,                //读取服务器存档
    function DzAPI_Map_GetServerValue takes player whichPlayer,string key returns string
        return RequestExtraStringData(5, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetGameStartTime,              //取游戏开始时间
    function DzAPI_Map_GetGameStartTime takes nothing returns integer
        return RequestExtraIntegerData(11, null, null, null, false, 0, 0, 0)
    endfunction
    // IsRPGLadder,                   //判断当前是否rpg天梯
    function DzAPI_Map_IsRPGLadder takes nothing returns boolean
        return RequestExtraBooleanData(12, null, null, null, false, 0, 0, 0)
    endfunction
    // GetMatchType,                  //获取匹配类型
    function DzAPI_Map_GetMatchType takes nothing returns integer
        return RequestExtraIntegerData(13, null, null, null, false, 0, 0, 0)
    endfunction
        // SetStat,                       //统计-提交地图数据
    function DzAPI_Map_Stat_SetStat takes player whichPlayer,string key,string value returns nothing
        call RequestExtraIntegerData(7, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    // SetLadderStat,                 //天梯-统计数据
    function DzAPI_Map_Ladder_SetStat takes player whichPlayer,string key,string value returns nothing
        call RequestExtraIntegerData(8, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    // SetLadderPlayerStat,           //天梯-统计数据
    function DzAPI_Map_Ladder_SetPlayerStat takes player whichPlayer,string key,string value returns nothing
        call RequestExtraIntegerData(9, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
        // GetServerValueErrorCode,       //读取加载服务器存档时的错误码
    function DzAPI_Map_GetServerValueErrorCode takes player whichPlayer returns integer
        return RequestExtraIntegerData(6, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // GetLadderLevel,                //提供给地图的接口，用与取天梯等级
    function DzAPI_Map_GetLadderLevel takes player whichPlayer returns integer
        return RequestExtraIntegerData(14, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // PlayerIdentityType, // 获取玩家身份类型
    function KKApiPlayerIdentityType takes player whichPlayer,integer id returns boolean
        return RequestExtraBooleanData(92, whichPlayer, null, null, false, id, 0, 0)
    endfunction
    // IsRedVIP,                      //提供给地图的接口，用与判断是否红V
    function DzAPI_Map_IsRedVIP takes player whichPlayer returns boolean
        return KKApiPlayerIdentityType(whichPlayer , 4)
    endfunction
    // IsBlueVIP,                     //提供给地图的接口，用与判断是否蓝V
    function DzAPI_Map_IsBlueVIP takes player whichPlayer returns boolean
        return KKApiPlayerIdentityType(whichPlayer , 3)
    endfunction
    // GetLadderRank,                 //提供给地图的接口，用与取天梯排名
    function DzAPI_Map_GetLadderRank takes player whichPlayer returns integer
        return RequestExtraIntegerData(17, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // GetMapLevelRank,               //提供给地图的接口，用与取地图等级排名
    function DzAPI_Map_GetMapLevelRank takes player whichPlayer returns integer
        return RequestExtraIntegerData(18, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // GetGuildRole,                  //获取公会职责 Member=10 Admin=20 Leader=30
    function DzAPI_Map_GetGuildRole takes player whichPlayer returns integer
        return RequestExtraIntegerData(20, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // IsRPGLobby,                    //检查是否大厅地图
    function DzAPI_Map_IsRPGLobby takes nothing returns boolean
        return RequestExtraBooleanData(10, null, null, null, false, 0, 0, 0)
    endfunction
    
    // MissionComplete,               //用作完成某个任务，发奖励
    function DzAPI_Map_MissionComplete takes player whichPlayer,string key,string value returns nothing
        call RequestExtraIntegerData(1, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    // GetActivityData,               //提供给地图的接口，用作取服务器上的活动数据
    function DzAPI_Map_GetActivityData takes nothing returns string
        return RequestExtraStringData(2, null, null, null, false, 0, 0, 0)
    endfunction
    // GetMapConfig,                  //获取地图配置
    function DzAPI_Map_GetMapConfig takes string key returns string
        return RequestExtraStringData(21, null, key, null, false, 0, 0, 0)
    endfunction
    // SavePublicArchive,             //保存服务器存档组
    function DzAPI_Map_SavePublicArchive takes player whichPlayer,string key,string value returns boolean
        return RequestExtraBooleanData(31, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    // GetPublicArchive,              //读取服务器存档组
    function DzAPI_Map_GetPublicArchive takes player whichPlayer,string key returns string
        return RequestExtraStringData(32, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_UseConsumablesItem takes player whichPlayer,string key returns nothing
        call RequestExtraIntegerData(33, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // OrpgTrigger,                   //触发boss击杀
    function DzAPI_Map_OrpgTrigger takes player whichPlayer,string key returns nothing
        call RequestExtraIntegerData(28, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetServerArchiveDrop,          //读取服务器掉落数据
    function DzAPI_Map_GetServerArchiveDrop takes player whichPlayer,string key returns string
        return RequestExtraStringData(27, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetServerArchiveEquip,         //读取服务器装备数据
    function DzAPI_Map_GetServerArchiveEquip takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(26, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_GetPlatformVIP takes player whichPlayer returns integer
        return RequestExtraIntegerData(30, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_IsPlatformVIP takes player whichPlayer returns boolean
        return DzAPI_Map_GetPlatformVIP(whichPlayer) > 0
    endfunction
    function DzAPI_Map_Global_GetStoreString takes string key returns string
        return RequestExtraStringData(36, GetLocalPlayer(), key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_Global_StoreString takes string key,string value returns nothing
        call RequestExtraBooleanData(37, GetLocalPlayer(), key, value, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_Global_ChangeMsg takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZGAU", true)
    endfunction
    function DzAPI_Map_ServerArchive takes player whichPlayer,string key returns string
        return RequestExtraStringData(38, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_SaveServerArchive takes player whichPlayer,string key,string value returns nothing
        call RequestExtraBooleanData(39, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_IsRPGQuickMatch takes nothing returns boolean
        return RequestExtraBooleanData(40, null, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_GetMallItemCount takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(41, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_ConsumeMallItem takes player whichPlayer,string key,integer count returns boolean
        return RequestExtraBooleanData(42, whichPlayer, key, null, false, count, 0, 0)
    endfunction
    function DzAPI_Map_EnablePlatformSettings takes player whichPlayer,integer option,boolean enable returns boolean
        return RequestExtraBooleanData(43, whichPlayer, null, null, enable, option, 0, 0)
    endfunction
    function GetPlayerServerValueSuccess takes player whichPlayer returns boolean
        if ( DzAPI_Map_GetServerValueErrorCode(whichPlayer) == 0 ) then
            return true
        else
            return false
        endif
    endfunction
    function DzAPI_Map_StoreIntegerEX takes player whichPlayer,string key,integer value returns nothing
        set key="I" + key
        call RequestExtraBooleanData(39, whichPlayer, key, I2S(value), false, 0, 0, 0)
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredIntegerEX takes player whichPlayer,string key returns integer
        local integer value
        set key="I" + key
        set value=S2I(RequestExtraStringData(38, whichPlayer, key, null, false, 0, 0, 0))
        set key=null
        set whichPlayer=null
        return value
    endfunction
    function DzAPI_Map_StoreInteger takes player whichPlayer,string key,integer value returns nothing
        set key="I" + key
        call DzAPI_Map_SaveServerValue(whichPlayer , key , I2S(value))
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredInteger takes player whichPlayer,string key returns integer
        local integer value
        set key="I" + key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer , key))
        set key=null
        set whichPlayer=null
        return value
    endfunction
        function DzAPI_Map_CommentTotalCount1 takes player whichPlayer,integer id returns integer
            return RequestExtraIntegerData(52, whichPlayer, null, null, false, id, 0, 0)
    endfunction
    function DzAPI_Map_StoreReal takes player whichPlayer,string key,real value returns nothing
        set key="R" + key
        call DzAPI_Map_SaveServerValue(whichPlayer , key , R2S(value))
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredReal takes player whichPlayer,string key returns real
        local real value
        set key="R" + key
        set value=S2R(DzAPI_Map_GetServerValue(whichPlayer , key))
        set key=null
        set whichPlayer=null
        return value
    endfunction
    function DzAPI_Map_StoreBoolean takes player whichPlayer,string key,boolean value returns nothing
        set key="B" + key
        if ( value ) then
            call DzAPI_Map_SaveServerValue(whichPlayer , key , "1")
        else
            call DzAPI_Map_SaveServerValue(whichPlayer , key , "0")
        endif
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredBoolean takes player whichPlayer,string key returns boolean
        local boolean value
        set key="B" + key
        set key=DzAPI_Map_GetServerValue(whichPlayer , key)
        if ( key == "1" ) then
            set value=true
        else
            set value=false
        endif
        set key=null
        set whichPlayer=null
        return value
    endfunction
    function DzAPI_Map_StoreString takes player whichPlayer,string key,string value returns nothing
        set key="S" + key
        call DzAPI_Map_SaveServerValue(whichPlayer , key , value)
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredString takes player whichPlayer,string key returns string
        return DzAPI_Map_GetServerValue(whichPlayer , "S" + key)
    endfunction
    function DzAPI_Map_StoreStringEX takes player whichPlayer,string key,string value returns nothing
        set key="S" + key
        call RequestExtraBooleanData(39, whichPlayer, key, value, false, 0, 0, 0)
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredStringEX takes player whichPlayer,string key returns string
        return RequestExtraStringData(38, whichPlayer, "S" + key, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_GetStoredUnitType takes player whichPlayer,string key returns integer
        local integer value
        set key="I" + key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer , key))
        set key=null
        set whichPlayer=null
        return value
    endfunction
    function DzAPI_Map_GetStoredAbilityId takes player whichPlayer,string key returns integer
        local integer value
        set key="I" + key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer , key))
        set key=null
        set whichPlayer=null
        return value
    endfunction
    function DzAPI_Map_FlushStoredMission takes player whichPlayer,string key returns nothing
        call DzAPI_Map_SaveServerValue(whichPlayer , key , null)
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_Ladder_SubmitIntegerData takes player whichPlayer,string key,integer value returns nothing
        call DzAPI_Map_Ladder_SetStat(whichPlayer , key , I2S(value))
    endfunction
    function DzAPI_Map_Stat_SubmitUnitIdData takes player whichPlayer,string key,integer value returns nothing
        if ( value == 0 ) then
            //call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"0")
        else
            call DzAPI_Map_Ladder_SetStat(whichPlayer , key , I2S(value))
        endif
    endfunction
    function DzAPI_Map_Stat_SubmitUnitData takes player whichPlayer,string key,unit value returns nothing
        call DzAPI_Map_Stat_SubmitUnitIdData(whichPlayer , key , GetUnitTypeId(value))
    endfunction
    function DzAPI_Map_Ladder_SubmitAblityIdData takes player whichPlayer,string key,integer value returns nothing
        if ( value == 0 ) then
            //call DzAPI_Map_Ladder_SetStat(whichPlayer,key,"0")
        else
            call DzAPI_Map_Ladder_SetStat(whichPlayer , key , I2S(value))
        endif
    endfunction
    function DzAPI_Map_Ladder_SubmitItemIdData takes player whichPlayer,string key,integer value returns nothing
        local string S
        if ( value == 0 ) then
            set S="0"
        else
            set S=I2S(value)
            call DzAPI_Map_Ladder_SetStat(whichPlayer , key , S)
        endif
        //call DzAPI_Map_Ladder_SetStat(whichPlayer,key,S)
        set S=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_Ladder_SubmitItemData takes player whichPlayer,string key,item value returns nothing
        call DzAPI_Map_Ladder_SubmitItemIdData(whichPlayer , key , GetItemTypeId(value))
    endfunction
    function DzAPI_Map_Ladder_SubmitBooleanData takes player whichPlayer,string key,boolean value returns nothing
        if ( value ) then
            call DzAPI_Map_Ladder_SetStat(whichPlayer , key , "1")
        else
            call DzAPI_Map_Ladder_SetStat(whichPlayer , key , "0")
        endif
    endfunction
    function DzAPI_Map_Ladder_SubmitTitle takes player whichPlayer,string value returns nothing
        call DzAPI_Map_Ladder_SetStat(whichPlayer , value , "1")
    endfunction
    function DzAPI_Map_Ladder_SubmitPlayerRank takes player whichPlayer,integer value returns nothing
        call DzAPI_Map_Ladder_SetPlayerStat(whichPlayer , "RankIndex" , I2S(value))
    endfunction
    function DzAPI_Map_Ladder_SubmitPlayerExtraExp takes player whichPlayer,integer value returns nothing
        call DzAPI_Map_Ladder_SetStat(whichPlayer , "ExtraExp" , I2S(value))
    endfunction
    function DzAPI_Map_PlayedGames takes player whichPlayer returns integer
        return RequestExtraIntegerData(45, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_CommentCount takes player whichPlayer returns integer
        return RequestExtraIntegerData(46, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_FriendCount takes player whichPlayer returns integer
        return RequestExtraIntegerData(47, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_IsConnoisseur takes player whichPlayer returns boolean
        return RequestExtraBooleanData(48, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_IsAuthor takes player whichPlayer returns boolean
        return RequestExtraBooleanData(50, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_CommentTotalCount takes nothing returns integer
        return RequestExtraIntegerData(51, null, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_Statistics takes player whichPlayer,string eventKey,string eventType,integer value returns nothing
        call RequestExtraBooleanData(34, whichPlayer, eventKey, eventType, false, value, 0, 0)
    endfunction
    function DzAPI_Map_Returns takes player whichPlayer,integer label returns boolean
        return RequestExtraBooleanData(53, whichPlayer, null, null, false, label, 0, 0)
    endfunction
    function DzAPI_Map_ContinuousCount takes player whichPlayer,integer id returns integer
        return RequestExtraIntegerData(54, whichPlayer, null, null, false, id, 0, 0)
    endfunction
    // IsPlayer,                      //是否为玩家
    function DzAPI_Map_IsPlayer takes player whichPlayer returns boolean
        return RequestExtraBooleanData(55, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // MapsTotalPlayed,               //所有地图的总游戏时长
    function DzAPI_Map_MapsTotalPlayed takes player whichPlayer returns integer
        return RequestExtraIntegerData(56, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // MapsLevel,                    //指定地图的地图等级
    function DzAPI_Map_MapsLevel takes player whichPlayer,integer mapId returns integer
        return RequestExtraIntegerData(57, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeGold,              //所有地图的金币消耗
    function DzAPI_Map_MapsConsumeGold takes player whichPlayer,integer mapId returns integer
        return RequestExtraIntegerData(58, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeLumber,            //所有地图的木材消耗
    function DzAPI_Map_MapsConsumeLumber takes player whichPlayer,integer mapId returns integer
        return RequestExtraIntegerData(59, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeLv1,               //消费 1-199
    function DzAPI_Map_MapsConsumeLv1 takes player whichPlayer,integer mapId returns boolean
        return RequestExtraBooleanData(60, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeLv2,               //消费 200-499
    function DzAPI_Map_MapsConsumeLv2 takes player whichPlayer,integer mapId returns boolean
        return RequestExtraBooleanData(61, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeLv3,               //消费 500~999
    function DzAPI_Map_MapsConsumeLv3 takes player whichPlayer,integer mapId returns boolean
        return RequestExtraBooleanData(62, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // MapsConsumeLv4,               //消费 1000+
    function DzAPI_Map_MapsConsumeLv4 takes player whichPlayer,integer mapId returns boolean
        return RequestExtraBooleanData(63, whichPlayer, null, null, false, mapId, 0, 0)
    endfunction
    // IsPlayerUsingSkin,            //检查是否装备着皮肤（skinType：头像=1、边框=2、称号=3、底纹=4）
    function DzAPI_Map_IsPlayerUsingSkin takes player whichPlayer,integer skinType,integer id returns boolean
        return RequestExtraBooleanData(64, whichPlayer, null, null, false, skinType, id, 0)
    endfunction
    //获取论坛数据（0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量）
    function DzAPI_Map_GetForumData takes player whichPlayer,integer whichData returns integer
        return RequestExtraIntegerData(65, whichPlayer, null, null, false, whichData, 0, 0)
    endfunction
    // PlayerFlags,                   //玩家标记 label（1=曾经是平台回流用户，2=当前是平台回流用户，4=曾经是地图回流用户，8=当前是地图回流用户，16=地图是否被玩家收藏）
    function DzAPI_Map_PlayerFlags takes player whichPlayer,integer label returns boolean
        return RequestExtraBooleanData(53, whichPlayer, null, null, false, label, 0, 0)
    endfunction
    // GetLotteryUsedCount, // 获取宝箱抽取次数
    function DzAPI_Map_GetLotteryUsedCountEx takes player whichPlayer,integer index returns integer
        return RequestExtraIntegerData(68, whichPlayer, null, null, false, index, 0, 0)
    endfunction
    function DzAPI_Map_GetLotteryUsedCount takes player whichPlayer returns integer
        return DzAPI_Map_GetLotteryUsedCountEx(whichPlayer , 0) + DzAPI_Map_GetLotteryUsedCountEx(whichPlayer , 1) + DzAPI_Map_GetLotteryUsedCountEx(whichPlayer , 2)
    endfunction
    function DzAPI_Map_OpenMall takes player whichPlayer,string whichkey returns boolean
        return RequestExtraBooleanData(66, whichPlayer, whichkey, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_GameResult_CommitData takes player whichPlayer,string key,string value returns nothing
        call RequestExtraIntegerData(69, whichPlayer, key, value, false, 0, 0, 0)
    endfunction
    //游戏结算
    function DzAPI_Map_GameResult_CommitTitle takes player whichPlayer,string value returns nothing
        call DzAPI_Map_GameResult_CommitData(whichPlayer , value , "1")
        set whichPlayer=null
        set value=null
    endfunction
    function DzAPI_Map_GameResult_CommitPlayerRank takes player whichPlayer,integer value returns nothing
        call DzAPI_Map_GameResult_CommitData(whichPlayer , "RankIndex" , I2S(value))
        set whichPlayer=null
        set value=0
    endfunction
    function DzAPI_Map_GameResult_CommitGameMode takes string value returns nothing
        call DzAPI_Map_GameResult_CommitData(GetLocalPlayer() , "InnerGameMode" , value)
        set value=null
    endfunction
    function DzAPI_Map_GameResult_CommitGameResult takes player whichPlayer,integer value returns nothing
        call DzAPI_Map_GameResult_CommitData(whichPlayer , "GameResult" , I2S(value))
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GameResult_CommitGameResultNoEnd takes player whichPlayer,integer value returns nothing
        call DzAPI_Map_GameResult_CommitData(whichPlayer , "GameResultNoEnd" , I2S(value))
        set whichPlayer=null
    endfunction
    // GetSinceLastPlayedSeconds, // 获取距最后一次游戏的秒数
    function DzAPI_Map_GetSinceLastPlayedSeconds takes player whichPlayer returns integer
        return RequestExtraIntegerData(70, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // QuickBuy, //游戏内快速购买
    function DzAPI_Map_QuickBuy takes player whichPlayer,string key,integer count,integer seconds returns boolean
        return RequestExtraBooleanData(72, whichPlayer, key, null, false, count, seconds, 0)
    endfunction
    // CancelQuickBuy, //取消快速购买
    function DzAPI_Map_CancelQuickBuy takes player whichPlayer returns boolean
        return RequestExtraBooleanData(73, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    //判断是加载成功某个玩家的道具
    function DzAPI_Map_PlayerLoadedItems takes player whichPlayer returns boolean
        return RequestExtraBooleanData(77, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function DzAPI_Map_CustomRankCount takes integer id returns integer
        return RequestExtraIntegerData(78, null, null, null, false, id, 0, 0)
    endfunction
    // CustomRankPlayerName            // 获取排行榜上指定排名的用户名称
    function DzAPI_Map_CustomRankPlayerName takes integer id,integer ranking returns string
        return RequestExtraStringData(79, null, null, null, false, id, ranking, 0)
    endfunction
    // CustomRankPlayerValue           // 获取排行榜上指定排名的值
    function DzAPI_Map_CustomRankValue takes integer id,integer ranking returns integer
        return RequestExtraIntegerData(80, null, null, null, false, id, ranking, 0)
    endfunction
    //获取玩家在KK平台的完整昵称（基础昵称#编号）
    function DzAPI_Map_GetPlayerUserName takes player whichPlayer returns string
        return RequestExtraStringData(81, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    // GetServerValueLimitLeft,   // 获取服务器存档限制余额
    function KKApiGetServerValueLimitLeft takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(82, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // RequestBackendLogic,       //请求后端逻辑生成 
    function KKApiRequestBackendLogic takes player whichPlayer,string key,string groupkey returns boolean
        return RequestExtraBooleanData(83, whichPlayer, key, groupkey, false, 0, 0, 0)
    endfunction
    // CheckBackendLogicExists,   // 获取后端逻辑生成结果 是否存在
    function KKApiCheckBackendLogicExists takes player whichPlayer,string key returns boolean
        return RequestExtraBooleanData(84, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetBackendLogicIntResult,  // 获取后端逻辑生成结果 整型
    function KKApiGetBackendLogicIntResult takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(85, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetBackendLogicStrResult,  // 获取后端逻辑生成结果 字符串
    function KKApiGetBackendLogicStrResult takes player whichPlayer,string key returns string
        return RequestExtraStringData(86, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetBackendLogicUpdateTime, // 获取后端逻辑生成时间
    function KKApiGetBackendLogicUpdateTime takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(87, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // GetBackendLogicGroup,      // 获取后端逻辑生成组
    function KKApiGetBackendLogicGroup takes player whichPlayer,string key returns string
        return RequestExtraStringData(88, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // RemoveBackendLogicResult,  // 删除后端逻辑生成结果
    function KKApiRemoveBackendLogicResult takes player whichPlayer,string key returns boolean
        return RequestExtraBooleanData(89, whichPlayer, key, null, false, 0, 0, 0)
    endfunction
    // 获取随机存档剩余次数
    function KKApiRandomSaveGameCount takes player whichPlayer,string groupkey returns integer
        return RequestExtraIntegerData(101, whichPlayer, groupkey, null, false, 0, 0, 0)
    endfunction
    function KKApiTriggerRegisterBackendLogicUpdata takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZBLU", true)
    endfunction
    function KKApiTriggerRegisterBackendLogicDelete takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZBLD", true)
    endfunction
    function KKApiGetSyncBackendLogic takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction
    function KKApiIsGameMode takes nothing returns boolean
        return RequestExtraBooleanData(90, null, null, null, false, 0, 0, 0)
    endfunction
    function KKApiInitializeGameKey takes player whichPlayer,integer setIndex,string k,string data returns boolean
        return RequestExtraBooleanData(91, whichPlayer, "[{\"name\":\"" + data + "\",\"key\":\"" + k + "\"}]", null, false, setIndex, 0, 0)
    endfunction
    function KKApiPlayerGUID takes player whichPlayer returns string
        return RequestExtraStringData(93, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    function KKApiIsTaskInProgress takes player whichPlayer,integer setIndex,integer taskstat returns boolean
        return RequestExtraIntegerData(94, whichPlayer, null, null, false, setIndex, 0, 0) == taskstat
    endfunction
    function KKApiQueryTaskCurrentProgress takes player whichPlayer,integer setIndex returns integer
        return RequestExtraIntegerData(95, whichPlayer, null, null, false, setIndex, 0, 0)
    endfunction
    function KKApiQueryTaskTotalProgress takes player whichPlayer,integer setIndex returns integer
        return RequestExtraIntegerData(96, whichPlayer, null, null, false, setIndex, 0, 0)
    endfunction
    // IsAchievementCompleted,  // 获取玩家成就是否完成
    function KKApiIsAchievementCompleted takes player whichPlayer,string id returns boolean
        return RequestExtraBooleanData(98, whichPlayer, id, null, false, 0, 0, 0)
    endfunction
    // AchievementPoints,  // 获取玩家地图成就点数
    function KKApiAchievementPoints takes player whichPlayer returns integer
        return RequestExtraIntegerData(99, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    
    // 判断游戏时长是否满足条件 minHours: 最小小时数，maxHours: 最大小时数，0表示不限制
    function KKApiPlayedTime takes player whichPlayer,integer minHours,integer maxHours returns boolean
        return RequestExtraBooleanData(100, whichPlayer, null, null, false, minHours, maxHours, 0)
    endfunction
    // BeginBatchSaveArchive,  // 开始批量保存存档
    function KKApiBeginBatchSaveArchive takes player whichPlayer returns boolean
        return RequestExtraBooleanData(102, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    
    // AddBatchSaveArchive,    // 添加批量保存存档条目
    function KKApiAddBatchSaveArchive takes player whichPlayer,string key,string value,boolean caseInsensitive returns boolean
        return RequestExtraBooleanData(103, whichPlayer, key, value, caseInsensitive, 0, 0, 0)
    endfunction
    
    // EndBatchSaveArchive,    // 结束批量保存存档
    function KKApiEndBatchSaveArchive takes player whichPlayer,boolean abandon returns boolean
        return RequestExtraBooleanData(104, whichPlayer, null, null, abandon, 0, 0, 0)
    endfunction
    //天梯投降
    function KKApiTriggerRegisterLadderSurrender takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZSR", true)
    endfunction
    function KKApiGetLadderSurrenderTeamId takes nothing returns integer
        return S2I(DzGetTriggerSyncData())
    endfunction
    // GetGuildLevel,          // 获取公会等级
    function KKApiGetGuildLevel takes player whichPlayer returns integer
        return RequestExtraIntegerData(106, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    //宠物探险次数
    function KKApiMapExplorationNum takes player whichPlayer returns integer
        return RequestExtraIntegerData(107, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    //宠物探险时间
    function KKApiMapExplorationTime takes player whichPlayer returns integer
        return RequestExtraIntegerData(108, whichPlayer, null, null, false, 0, 0, 0)
    endfunction
    
    //测试大厅预约人数
    function KKApiMapOrderNum takes nothing returns integer
        return RequestExtraIntegerData(109, null, null, null, false, 0, 0, 0)
    endfunction
    // 发送云脚本数据
    function KKApiMlScriptEvent takes player whichPlayer,string eventName,string payload returns boolean
        return RequestExtraBooleanData(110, whichPlayer, eventName, payload, false, 0, 0, 0)
    endfunction
    // 获取商城道具最后变动的数量（新增/删除）
    function KKApiGetMallItemUpdateCount takes player whichPlayer,string key returns integer
        return RequestExtraIntegerData(110, whichPlayer, key, null, false, 0, 0, 0)
    endfunction

//library DzAPI ends
//library UnitTestFramwork:

        function s__assert_Boolean takes boolean condition,string name returns nothing
            if ( not condition ) then
                call BJDebugMsg("FAIL: " + name)
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言字符串相等
        function s__assert_String takes string actual,string expected,string name returns nothing
            if ( actual != expected ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + expected)
                call BJDebugMsg("  Actual: " + actual)
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言整数相等
        function s__assert_Integer takes integer actual,integer expected,string name returns nothing
            if ( actual != expected ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + I2S(expected))
                call BJDebugMsg("  Actual: " + I2S(actual))
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction  //断言浮点数相等
        function s__assert_Real takes real actual,real expected,string name returns nothing
            local real maxValue=RMaxBJ(RAbsBJ(actual), RAbsBJ(expected))
            local real epsilon=maxValue * 0.00001
            if ( maxValue < 0.00001 ) then
                set epsilon=0.00001
            endif
            if ( RAbsBJ(actual - expected) > epsilon ) then
                call BJDebugMsg("FAIL: " + name)
                call BJDebugMsg("  Expected: " + R2SW(expected, 0, 1))
                call BJDebugMsg("  Actual: " + R2SW(actual, 0, 1))
            else
                call BJDebugMsg("PASS: " + name)
            endif
        endfunction
    function UnitTestRegisterChatEvent takes code func returns nothing
        call TriggerAddAction(UnitTestFramwork__TUnitTest, func)
    endfunction  //指定开始时间与持续时间的定时器
        function UnitTestFramwork__anon__0 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]开始------")
            call TriggerEvaluate(tr)
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
        function UnitTestFramwork__anon__1 takes nothing returns nothing
            local real time=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 1)
            local real d=LoadReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 2)
            local trigger tr=LoadTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()), 3)
            call TriggerEvaluate(tr)
            call BJDebugMsg("-----[单测 " + R2SW(time, 0, 1) + " - " + R2SW(time + d, 0, 1) + " 秒]结束------")
            call DestroyTrigger(tr)
            call FlushChildHashtable(UnitTestFramwork__HASH_UNITTEST, GetHandleId(GetTriggeringTrigger()))
            call DestroyTrigger(GetTriggeringTrigger())
            set tr=null
        endfunction
    function UnitTestAutoTimer takes real time,real duration,code start,code end returns nothing
        local trigger t=CreateTrigger()
        local trigger tr=CreateTrigger()
        call TriggerAddCondition(t, Condition(start))
        call TriggerRegisterTimerEvent(tr, time, false)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 1, time)
        call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 2, duration)
        call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 3, t)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__0))
        if ( end != null ) then
            set t=CreateTrigger()
            set tr=CreateTrigger()
            call TriggerAddCondition(t, Condition(end))
            call TriggerRegisterTimerEvent(tr, time + duration, false)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 1, time)
            call SaveReal(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 2, duration)
            call SaveTriggerHandle(UnitTestFramwork__HASH_UNITTEST, GetHandleId(tr), 3, t)
            call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__1))
        endif
        set tr=null
        set t=null
    endfunction
        function UnitTestFramwork__anon__2 takes nothing returns nothing
            local integer i
            set i=1
            loop
            exitwhen ( i > 12 )
                call SetPlayerName(ConvertedPlayer(i), "测试员" + I2S(i) + "号") //迷雾全关
                call CreateFogModifierRectBJ(true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, bj_mapInitialPlayableArea)
            set i=i + 1
            endloop
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
    function UnitTestFramwork__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.1, false)
        call TriggerAddCondition(tr, Condition(function UnitTestFramwork__anon__2))
        set tr=null
        set UnitTestFramwork__TUnitTest=CreateTrigger()
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(0), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(1), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(2), "", false)
        call TriggerRegisterPlayerChatEvent(UnitTestFramwork__TUnitTest, Player(3), "", false)
    endfunction

//library UnitTestFramwork ends
//library YDTriggerSaveLoadSystem:
//#  define YDTRIGGER_handle(SG)                          YDTRIGGER_HT##SG##(HashtableHandle)
    function YDTriggerSaveLoadSystem__Init takes nothing returns nothing
            set YDHT=InitHashtable()
        set YDLOC=InitHashtable()
    endfunction

//library YDTriggerSaveLoadSystem ends
//library MallItem:
        function s__mallItem_getIndex takes string key returns integer
            local integer stored
            local integer idx
            set stored=LoadInteger(s__mallItem_table, 0, StringHash(key))
            if ( stored == 0 ) then
                return - 1
            endif // 存储时 +1，读取时 -1
            set idx=stored - 1
            if ( idx < 0 or idx >= s__mallItem_itemCount ) then
                return - 1
            endif
            return idx
        endfunction
        function s__mallItem_setIndex takes string key,integer index returns nothing
            call SaveInteger(s__mallItem_table, 0, StringHash(key), index + 1)
        endfunction
        function s__mallItem_addKey takes string key returns nothing
            local integer idx
            local integer i
            local integer n
            local integer base
            if ( key == null ) then
                return
            endif
            if ( StringLength(key) == 0 ) then // 已存在则跳过
                return
            endif
            set idx=s__mallItem_getIndex(key)
            if ( idx >= 0 ) then
                return
            endif
            if ( s__mallItem_itemCount >= 300 ) then // 超上限忽略
                return
            endif
            set idx=s__mallItem_itemCount
            set s__mallItem_itemKeys[idx]=key
            call s__mallItem_setIndex(key , idx) // 默认元信息
            set s__mallItem_names[idx]=""
            set s__mallItem_icons[idx]=""
            set s__mallItem_descs[idx]=""
            set s__mallItem_techs[idx]=0 // 初始化拥有权为 false（所有玩家）
            set i=0
            loop
            exitwhen ( i >= 4 )
                set base=i * 300
                set s__mallItem_owns[base + idx]=false
                set i=i + 1
            endloop
            set s__mallItem_itemCount=s__mallItem_itemCount + 1
        endfunction  // （移除字符串拆分，改为单商品增量注册）
        function s__mallItem_onInit takes nothing returns nothing
            set s__mallItem_initialized=false // 无句柄局部变量
            set s__mallItem_ready=false
            set s__mallItem_itemCount=0
            set s__mallItem_table=InitHashtable()
            set s__mallItem_readyTrigger=CreateTrigger()
        endfunction  // 外部初始化：每次只注册一个商品 key；首次调用时启动延迟扫描
            function s__mallItem_anon__0 takes nothing returns nothing
                local integer pid
                local integer idx
                local integer base
                local player p
                local string k
                local integer n
                set n=s__mallItem_itemCount
                set pid=0
                loop
                exitwhen ( pid >= 4 )
                    set p=ConvertedPlayer(pid)
                    set base=pid * 300
                    set idx=0
                    loop
                    exitwhen ( idx >= n )
                        set k=s__mallItem_itemKeys[idx]
                        set s__mallItem_owns[base + idx]=DzAPI_Map_HasMallItem(p, k)
                        set s__mallItem_uses[base + idx]=DzAPI_Map_GetMallItemCount(p , k) // 直接在此处解锁科技（如果拥有商品且设置了科技）
                        if ( s__mallItem_owns[base + idx] and s__mallItem_techs[idx] != 0 ) then
                            call SetPlayerTechResearched(p, s__mallItem_techs[idx], 1)
                        endif
                        set idx=idx + 1
                    endloop
                    set p=null
                    set pid=pid + 1
                endloop
                set s__mallItem_ready=true
                if ( s__mallItem_readyTrigger != null ) then // 使用 TriggerEvaluate 调用回调条件
                    call TriggerEvaluate(s__mallItem_readyTrigger)
                endif
            endfunction  // handler 置空
        function s__mallItem_init takes string productKey returns nothing
            local timer t
            call s__mallItem_addKey(productKey)
            if ( not ( s__mallItem_initialized ) ) then
                set s__mallItem_initialized=true
                set t=CreateTimer()
                call TimerStart(t, 2.0, false, function s__mallItem_anon__0)
                set t=null
            endif
        endfunction  // 是否已完成首次扫描
        function s__mallItem_isReady takes nothing returns boolean
            return s__mallItem_ready
        endfunction  // 注册 onReady 回调（使用 Condition 封装 code），若已就绪则立即 Evaluate
        function s__mallItem_onReady takes code cb returns nothing
            if ( s__mallItem_readyTrigger == null ) then
                set s__mallItem_readyTrigger=CreateTrigger()
            endif
            call TriggerAddCondition(s__mallItem_readyTrigger, Condition(cb))
            if ( s__mallItem_ready ) then
                call TriggerEvaluate(s__mallItem_readyTrigger)
            endif
        endfunction  // 拥有权查询：通过玩家句柄
        function s__mallItem_hasByPlayer takes player whichPlayer,string itemKey returns boolean
            local integer pid
            local integer idx
            local integer base
            local boolean result
            set pid=GetPlayerId(whichPlayer)
            if ( pid < 0 or pid >= 4 ) then
                return false
            endif
            set idx=s__mallItem_getIndex(itemKey)
            if ( idx < 0 ) then
                return false
            endif
            set base=pid * 300
            set result=s__mallItem_owns[base + idx]
            return result
        endfunction  // 使用次数查询：通过玩家句柄
        function s__mallItem_getUseCountByPlayer takes player whichPlayer,string itemKey returns integer
            local integer pid
            local integer idx
            local integer base
            set pid=GetPlayerId(whichPlayer)
            if ( pid < 0 or pid >= 4 ) then
                return 0
            endif
            set idx=s__mallItem_getIndex(itemKey)
            if ( idx < 0 ) then
                return 0
            endif
            set base=pid * 300
            return s__mallItem_uses[base + idx]
        endfunction  // 刷新某玩家的拥有权（对已登记商品）
        function s__mallItem_refreshItemsForPlayer takes integer playerId returns nothing
            local integer i
            local integer base
            local player p
            local string k
            local integer n
            if ( playerId < 0 or playerId >= 4 ) then
                return
            endif
            set p=ConvertedPlayer(playerId)
            set base=playerId * 300
            set n=s__mallItem_itemCount
            set i=0
            loop
            exitwhen ( i >= n )
                set k=s__mallItem_itemKeys[i]
                set s__mallItem_owns[base + i]=DzAPI_Map_HasMallItem(p, k)
                set i=i + 1
            endloop
            set p=null
        endfunction  // 消费次数型道具（带回调）：成功消费后调用回调并传入玩家参数
        function s__mallItem_consumeTimes takes player whichPlayer,string itemKey,integer count,code callback returns boolean
            local integer pid
            local integer idx
            local integer base
            local boolean ok
            local trigger tempTr
            set pid=GetPlayerId(whichPlayer)
            if ( pid < 0 or pid >= 4 ) then
                return false
            endif
            set idx=s__mallItem_getIndex(itemKey)
            if ( idx < 0 ) then // 执行消费
                return false
            endif
            set ok=DzAPI_Map_ConsumeMallItem(whichPlayer , itemKey , count)
            if ( ok ) then
                set base=pid * 300 // 刷新该玩家该商品缓存
                set s__mallItem_owns[base + idx]=DzAPI_Map_HasMallItem(whichPlayer, itemKey)
                set s__mallItem_uses[base + idx]=DzAPI_Map_GetMallItemCount(whichPlayer , itemKey) // 如果使用次数小于等于0，则认为该玩家没有这个道具了
                if ( s__mallItem_uses[base + idx] <= 0 ) then
                    set s__mallItem_owns[base + idx]=false
                endif // 调用回调（传入玩家参数）
                if ( callback != null ) then
                    set s__mallItem_callbackPlayer=whichPlayer
                    set tempTr=CreateTrigger()
                    call TriggerAddCondition(tempTr, Condition(callback))
                    call TriggerEvaluate(tempTr)
                    call DestroyTrigger(tempTr)
                    set s__mallItem_callbackPlayer=null
                    set tempTr=null
                endif
            endif
            return ok
        endfunction  // 消费一次性道具（UseConsumablesItem）：无回调
        function s__mallItem_consumeOnce takes player whichPlayer,string itemKey returns nothing
            local integer pid
            local integer idx
            local integer base
            set pid=GetPlayerId(whichPlayer)
            if ( pid < 0 or pid >= 4 ) then
                return
            endif
            set idx=s__mallItem_getIndex(itemKey)
            if ( idx < 0 ) then // 执行消费(无回调)
                return
            endif
            call DzAPI_Map_UseConsumablesItem(whichPlayer , itemKey)
        endfunction  // ========== 元信息写接口 ==========
        function s__mallItem_setName takes string key,string name returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_names[idx]=name
        endfunction
        function s__mallItem_setIcon takes string key,string iconPath returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_icons[idx]=iconPath
        endfunction
        function s__mallItem_setDesc takes string key,string desc returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_descs[idx]=desc
        endfunction
        function s__mallItem_setTech takes string key,integer techId returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_techs[idx]=techId
        endfunction
        function s__mallItem_setMeta takes string key,string name,string iconPath,string desc returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_names[idx]=name
            set s__mallItem_icons[idx]=iconPath
            set s__mallItem_descs[idx]=desc
        endfunction
        function s__mallItem_setMetaWithTech takes string key,string name,string iconPath,string desc,integer techId returns nothing
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return
            endif
            set s__mallItem_names[idx]=name
            set s__mallItem_icons[idx]=iconPath
            set s__mallItem_descs[idx]=desc
            set s__mallItem_techs[idx]=techId
        endfunction  // ========== 元信息读接口 ==========
        function s__mallItem_getName takes string key returns string
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return ""
            endif
            return s__mallItem_names[idx]
        endfunction
        function s__mallItem_getIcon takes string key returns string
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return ""
            endif
            return s__mallItem_icons[idx]
        endfunction
        function s__mallItem_getDesc takes string key returns string
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return ""
            endif
            return s__mallItem_descs[idx]
        endfunction
        function s__mallItem_getTech takes string key returns integer
            local integer idx
            set idx=s__mallItem_getIndex(key)
            if ( idx < 0 ) then
                return 0
            endif
            return s__mallItem_techs[idx]
        endfunction  // 在 consumeTimes 回调中获取触发的玩家
        function s__mallItem_getCallbackPlayer takes nothing returns player
            return s__mallItem_callbackPlayer
        endfunction
        function s__mallItem_hasItemKey takes string key returns boolean
            return s__mallItem_getIndex(key) >= 0
        endfunction
        function s__mallItem_getAllItemKeys takes nothing returns string
            local integer i
            local string out
            local integer n
            set n=s__mallItem_itemCount
            set out=""
            set i=0
            loop
            exitwhen ( i >= n )
                if ( i == 0 ) then
                    set out=s__mallItem_itemKeys[i]
                else
                    set out=out + "," + s__mallItem_itemKeys[i]
                endif
                set i=i + 1
            endloop
            return out
        endfunction  // 根据索引获取商品 key（1-based 外部语义：1 表示第一个）
        function s__mallItem_getItemKeyByIndex takes integer oneBasedIndex returns string
            local integer idx
            set idx=oneBasedIndex - 1
            if ( idx < 0 or idx >= s__mallItem_itemCount ) then
                return ""
            endif
            return s__mallItem_itemKeys[idx]
        endfunction  // 获取已登记商品数量
        function s__mallItem_getItemCount takes nothing returns integer
            return s__mallItem_itemCount
        endfunction

//library MallItem ends
//library UTMallItem:

        function UTMallItem__anon__0 takes nothing returns nothing
        endfunction  //end,这里是2秒后调用的内容
        function UTMallItem__anon__1 takes nothing returns nothing
        endfunction
        function UTMallItem__anon__2 takes nothing returns nothing
        endfunction
    function UTMallItem__Init takes nothing returns nothing
        call UnitTestAutoTimer(0.1 , 2.0 , function UTMallItem__anon__0 , function UTMallItem__anon__1)
        call UnitTestAutoTimer(0.1 , 2.0 , function UTMallItem__anon__2 , null)
    endfunction
    function UTMallItem__TTestUTMallItem1 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem2 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem3 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem4 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem5 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem6 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem7 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem8 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem9 takes player p returns nothing
    endfunction
    function UTMallItem__TTestUTMallItem10 takes player p returns nothing
    endfunction
    function UTMallItem__TTestActUTMallItem1 takes string str returns nothing
        local player p=GetTriggerPlayer()
        local integer index=GetConvertedPlayerId(p)
        local integer i
        local integer num=0
        local integer len=StringLength(str)
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
        set num=num + 1
        if ( paramS[0] == "a" ) then
        elseif ( paramS[0] == "b" ) then
        endif
        set p=null
    endfunction
        function UTMallItem__anon__3 takes nothing returns nothing
            call BJDebugMsg("[MallItem] 单元测试已加载")
            call UTMallItem__Init()
            call DestroyTrigger(GetTriggeringTrigger())
        endfunction
        function UTMallItem__anon__4 takes nothing returns nothing
            local string str=GetEventPlayerChatString()
            local integer i=1
            if ( SubString(str, ( 1 ) - 1, 1) == "-" ) then
                call UTMallItem__TTestActUTMallItem1(SubString(str, ( 2 ) - 1, StringLength(str)))
                return
            endif
            if ( str == "s1" ) then
                call UTMallItem__TTestUTMallItem1(GetTriggerPlayer())
            elseif ( str == "s2" ) then
                call UTMallItem__TTestUTMallItem2(GetTriggerPlayer())
            elseif ( str == "s3" ) then
                call UTMallItem__TTestUTMallItem3(GetTriggerPlayer())
            elseif ( str == "s4" ) then
                call UTMallItem__TTestUTMallItem4(GetTriggerPlayer())
            elseif ( str == "s5" ) then
                call UTMallItem__TTestUTMallItem5(GetTriggerPlayer())
            elseif ( str == "s6" ) then
                call UTMallItem__TTestUTMallItem6(GetTriggerPlayer())
            elseif ( str == "s7" ) then
                call UTMallItem__TTestUTMallItem7(GetTriggerPlayer())
            elseif ( str == "s8" ) then
                call UTMallItem__TTestUTMallItem8(GetTriggerPlayer())
            elseif ( str == "s9" ) then
                call UTMallItem__TTestUTMallItem9(GetTriggerPlayer())
            elseif ( str == "s10" ) then
                call UTMallItem__TTestUTMallItem10(GetTriggerPlayer())
            endif
        endfunction
    function UTMallItem__onInit takes nothing returns nothing
        local trigger tr=CreateTrigger()
        call TriggerRegisterTimerEvent(tr, 0.5, false)
        call TriggerAddCondition(tr, Condition(function UTMallItem__anon__3))
        set tr=null
        call UnitTestRegisterChatEvent(function UTMallItem__anon__4)
    endfunction

//library UTMallItem ends
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerSelectionEventBJ.h>
//#  include <YDTrigger/BJOptimization/detail/TriggerRegisterPlayerKeyEventBJ.h>
//#  define TriggerRegisterPlayerUnitEventSimple(trig, p, e)                 TriggerRegisterPlayerUnitEvent(trig, p, e, null)
//#  define TriggerRegisterPlayerEventVictory(trig, player)                  TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_VICTORY)
//#  define TriggerRegisterPlayerEventDefeat(trig, player)                   TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_DEFEAT)
//#  define TriggerRegisterPlayerEventLeave(trig, player)                    TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_LEAVE)
//#  define TriggerRegisterPlayerEventAllianceChanged(trig, player)          TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_ALLIANCE_CHANGED)
//#  define TriggerRegisterPlayerEventEndCinematic(trig, player)             TriggerRegisterPlayerEvent(trig, player, EVENT_PLAYER_END_CINEMATIC)
// 原生UI的大小

// 常量配置
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
    call SetCameraBounds(- 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), - 13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("NorthrendDay")
    call SetAmbientNightSound("NorthrendNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateAllUnits()
    call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs263216609")
call ExecuteFunc("UnitTestFramwork__onInit")
call ExecuteFunc("YDTriggerSaveLoadSystem__Init")
call ExecuteFunc("UTMallItem__onInit")

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

function jasshelper__initstructs263216609 takes nothing returns nothing



    call ExecuteFunc("s__mallItem_onInit")
endfunction

