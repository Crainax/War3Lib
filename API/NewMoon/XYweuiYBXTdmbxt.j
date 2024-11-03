#ifndef YBDMBIncluded
#define YBDMBIncluded

#include "AntiBJLeak\MultiboardSetItemColorBJ.j"
#include "AntiBJLeak\MultiboardSetItemIconBJ.j"
#include "AntiBJLeak\MultiboardSetItemStyleBJ.j"
#include "AntiBJLeak\MultiboardSetItemValueBJ.j"
#include "AntiBJLeak\MultiboardSetItemWidthBJ.j"

/*
    “Ï≤Ω∂‡√Ê∞Â
*/
library YBDMB requires XYwebase

    globals
        private player array MPlayerIndex
        private multiboard array MMB
    endglobals

function CreateYBDMB takes player p,integer index,integer column,integer row,string title returns nothing
    set MPlayerIndex[index] = p
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call CreateMultiboardBJ(column,row,title)
        set MMB[index] = bj_lastCreatedMultiboard
    endif
endfunction

function DestroyYBDMB takes integer index returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call DestroyMultiboard(MMB[index])
        set MMB[index] = null
        set MPlayerIndex[index] = null
    endif
endfunction

function YBDMBDisplay takes integer index,boolean show returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardDisplay(MMB[index],show)
    endif
endfunction

function YBDMBSuppressDisplay takes player p,boolean open returns nothing
    if (p == GetLocalPlayer()) then
        call MultiboardSuppressDisplay(open)
    endif
endfunction

function YBDMBMinimize takes integer index,boolean min returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardMinimize(MMB[index],min)
    endif
endfunction

function YBDMBClear takes integer index returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardClear(MMB[index])
    endif
endfunction

function SetYBDMBTitleText takes integer index,string title returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetTitleText(MMB[index],title)
    endif
endfunction

function YBDMBSetTitleTextColor takes integer index,integer red,integer green,integer blue,integer alpha returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetTitleTextColor(MMB[index],red,green,blue,alpha)
    endif
endfunction

function YBDMBSetTitleTextColorBJ takes integer index,real red,real green,real blue,real transparency returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetTitleTextColorBJ(MMB[index],red,green,blue,transparency)
    endif
endfunction

function YBDMBSetRowCount takes integer index,integer count returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetRowCount(MMB[index],count)
    endif
endfunction

function YBDMBSetColumnCount takes integer index,integer count returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetColumnCount(MMB[index],count)
    endif
endfunction

function YBDMBSetItemsStyle takes integer index,boolean textShow,boolean picShow returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemsStyle(MMB[index],textShow,picShow)
    endif
endfunction

function YBDMBSetItemsValue takes integer index,string value returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemsValue(MMB[index],value)
    endif
endfunction

function YBDMBSetItemsValueColor takes integer index,integer red,integer green,integer blue,integer alpha returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemsValueColor(MMB[index],red,green,blue,alpha)
    endif
endfunction

function YBDMBSetItemsWidth takes integer index,real width returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemsWidth(MMB[index],width)
    endif
endfunction

function YBDMBSetItemsIcon takes integer index,string icon returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemsIcon(MMB[index],icon)
    endif
endfunction

function YBDMBSetItemStyleBJ takes integer index,integer column,integer row,boolean showText,boolean showPic returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemStyleBJ(MMB[index],column,row,showText,showPic)
    endif
endfunction

function YBDMBSetItemStyleBJ takes integer index,integer column,integer row,string text returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemValueBJ(MMB[index],column,row,text)
    endif
endfunction

function YBDMBSetItemColorBJ takes integer index,integer column,integer raw,real red,real green,real blue,real transparency returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemColorBJ(MMB[index],column,raw,red,green,blue,transparency)
    endif
endfunction

function YBDMBSetItemWidthBJ takes integer index,integer column,integer raw,real width returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemWidthBJ(MMB[index],column,raw,width)
    endif
endfunction

function YBDMBSetItemIconBJ takes integer index,integer column,integer raw,string width returns nothing
    if (MPlayerIndex[index] == GetLocalPlayer()) then
        call MultiboardSetItemIconBJ(MMB[index],column,raw,width)
    endif
endfunction

endlibrary 

#endif /// YBDMBIncluded
