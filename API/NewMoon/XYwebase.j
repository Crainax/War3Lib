#ifndef XYwebaseIncluded
#define XYwebaseIncluded

library XYwebase initializer XYweuiOpenAll1

/*
º¯ÊıÀàĞÍ£º    ĞÂÔÂWEuiÄÚÈİ³õÊ¼»¯ 
×÷Õß£º        ĞÂÔÂÍÅ¶Ó:¶ñÄ§-ÒÅÍü 
*/

globals
    boolean islanmode=false
    rect maprect
    string bincharmap="01"
    string octcharmap="012345678"
    string hexcharmap="0123456789ABCDEF"
    string idcharmap="..................................!.#$%&'()*+,-./0123456789:;<=>.@ABCDEFGHIJKLMNOPQRSTUVWXYZ[.]^_`abcdefghijklmnopqrstuvwxyz{|}~................................................................................................................................"
    location L = Location(0,0)
    hashtable XYwe_HXB = InitHashtable(  )
    gamecache SLGC
    string SLFN
    string SLMK
    player SLSP
    hashtable XYwe_open = InitHashtable(  )
    hashtable XYwe_hxb_ms = InitHashtable(  )
    hashtable XYwe_hxb_sh = InitHashtable(  )
    hashtable XYwe_hxb_shys = InitHashtable(  )
    hashtable XYwe_hxb_4 = InitHashtable(  )
    hashtable XYwe_hxb_JYXT = InitHashtable(  )
    gamecache SLK_GC = InitGameCache("SLK_GC")
    player array XYweuiYBXTdmbxt_wj
    multiboard array XYweuiYBXTdmbxt_dmb
    gamecache          GC = InitGameCache("JassUtils")
    integer            temp_i = 0
    real               temp_r = 0
    boolean            temp_b = false
    string             temp_s = ""
    player             temp_player               = null
    unit               temp_unit                 = null
    destructable       temp_destructable         = null
    item               temp_item                 = null
    timer              temp_timer                = null
    trigger            temp_trigger              = null
    triggercondition   temp_triggercondition     = null
    triggeraction      temp_triggeraction        = null
    force              temp_force                = null
    group              temp_group                = null
    location           temp_location             = null
    rect               temp_rect                 = null
    boolexpr           temp_boolexpr             = null
    sound              temp_sound                = null
    effect             temp_effect               = null
    unitpool           temp_unitpool             = null
    itempool           temp_itempool             = null
    quest              temp_quest                = null
    questitem          temp_questitem            = null
    defeatcondition    temp_defeatcondition      = null
    timerdialog        temp_timerdialog          = null
    leaderboard        temp_leaderboard          = null
    multiboard         temp_multiboard           = null
    multiboarditem     temp_multiboarditem       = null
    trackable          temp_trackable            = null
    dialog             temp_dialog               = null
    button             temp_button               = null
    texttag            temp_texttag              = null
    lightning          temp_lightning            = null
    image              temp_image                = null
    ubersplat          temp_ubersplat            = null
    region             temp_region               = null
    fogmodifier        temp_fogmodifier          = null
    integer NS = 31536000
    integer LS = 31622400	
    integer BJTIME = 28800
    integer BASE2015_SEC = 1451606400
    integer BASE2015_WEEKDAY = 4
	integer array NORMALMON
    boolean udg_bIsInit = false
    integer udg_ServerTime
    string array WEEKSTR
    integer XYweuiZHDZapiTime_Year
	integer XYweuiZHDZapiTime_Mon
	integer XYweuiZHDZapiTime_Day
	integer XYweuiZHDZapiTime_Hour
	integer XYweuiZHDZapiTime_Min
	integer XYweuiZHDZapiTime_Sec
	integer XYweuiZHDZapiTime_Week 
	boolean XYweuiOpenAll_first = FALSE
	boolean XYweuiOpenAll_second = FALSE
endglobals

private function XYweuiOpenAll1 takes nothing returns nothing
    if (XYweuiOpenAll_first != TRUE) then
        set XYweuiOpenAll_first = TRUE
        call BJDebugMsg("ã€ç³»ç»Ÿæç¤ºã€‘åœ°å›¾ç¼–è¾‘å™¨ç‰ˆæœ¬ï¼šNew Moon[æ–°æœˆ]WEv 1.03 å…¨æ–°ç‰ˆ [æ–°æœˆå›¢é˜Ÿ]ç¥æ‚¨æ¸¸æˆæ„‰å¿«ï¼")
    endif
endfunction

function XYweuiOpenAll2 takes nothing returns nothing
    local integer XYweui_0
endfunction

function XYweuiOpenAll3 takes nothing returns nothing
    if (XYweuiOpenAll_second != TRUE) then
        set XYweuiOpenAll_second = TRUE
        call BJDebugMsg("ã€ç³»ç»Ÿæç¤ºã€‘åœ°å›¾ç¼–è¾‘å™¨ç‰ˆæœ¬ï¼šNew Moon[æ–°æœˆ]WEv 1.03 å…¨æ–°ç‰ˆ [æ–°æœˆå›¢é˜Ÿ]ç¥æ‚¨æ¸¸æˆæ„‰å¿«ï¼")
    endif
endfunction

/*
º¯ÊıÀàĞÍ£º    BJĞŞ¸Ä
×÷Õß£º        ĞÂÔÂÍÅ¶Ó:¶ñÄ§-ÒÅÍü 
*/

function XYweCustomVictoryBJ takes player XYweui0,boolean XYweui1,boolean XYweui2 returns nothing
    call XYweuiOpenAll3()
    call CustomVictoryBJ(XYweui0,XYweui1,XYweui2)
endfunction

function XYweCustomDefeatBJ takes player XYweui0,string XYweui1 returns nothing
    call XYweuiOpenAll3()
    call CustomDefeatBJ(XYweui0,XYweui1)
endfunction

function XYweForGroupBJ takes group whichGroup, code callback returns nothing
	local boolean wantDestroy = bj_wantDestroyGroup
	local group g = whichGroup
	local unit u
	local group g2
	set bj_wantDestroyGroup = false
	loop
		set u = FirstOfGroup(g)
		exitwhen u == null
		if (u != null) then
			call GroupRemoveUnit( g, u )
			set g2 = CreateGroup()
			call GroupAddUnit( g2, u )
			call ForGroup(g2, callback)
			call GroupClear(g2)
			call DestroyGroup(g2)
		endif
	endloop
	call GroupClear(g)
	call DestroyGroup(g)
	if (wantDestroy) then
		call DestroyGroup(whichGroup)
	endif
set g = null
set g2 = null
set u = null
set whichGroup = null 
endfunction

endlibrary

#endif /// XYwebaseIncluded
