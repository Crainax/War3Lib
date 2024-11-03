#ifndef XYweuiZFCXTIncluded
#define XYweuiZFCXTIncluded

#include "XYwebase.j"

//! JassUtils

library XYweuiZFCXT initializer XYweuiZFCXTInit requires XYwebase

constant function GetMapRect takes nothing returns Rect
    call XYweuiOpenAll2()
    return maprect
endfunction

private function XYweuiZFCXTInit takes nothing returns nothing    
    set maprect=GetWorldBounds()
    call XYweuiOpenAll2()
endfunction

function SubStringEx takes string source,integer start,integer len returns string
    call XYweuiOpenAll2()
    if len > 0 then
        return SubString(source,start,start+len)
    endif
    return ""
endfunction

function FindStrEx takes string source,string s,integer startindex returns integer
    local integer i = startindex
    local integer len1 = StringLength(source)
    local integer len2 = StringLength(s)
    local integer n = len1 - len2 + 1
    call XYweuiOpenAll2()
    if len1==0 or len2==0 or i>len1-1 or len1<len2 then
        return -1
    endif
    loop
        exitwhen i >= n
        if SubStringEx(source, i, len2) == s then
            return i
        endif
        set i = i + 1
    endloop
    return -1
endfunction

function FindStr takes string source, string s returns integer
    call XYweuiOpenAll2()
    return FindStrEx(source,s,0)
endfunction

function ReplaceStrEx takes string source,string old,string new,integer startindex returns string
    local integer ri = startindex
    local integer li = startindex
    local integer len1 = StringLength(source)
    local integer len2 = StringLength(old)
    local string result = SubString(source,0,startindex)
    local string compare = source
    call XYweuiOpenAll2()
    if len1==0 or len2==0 or startindex>len1-1 or len1<len2 then
        return source
    endif
    loop
        exitwhen ri >= len1
        if SubStringEx(compare, ri, len2 ) == old then
            set result = result + SubString(source, li, ri) + new
            set ri = ri + len2
            set li = ri
        else
            set ri = ri + 1
        endif
    endloop
    set result = result + SubString(source, li, len1)
    return result
endfunction

function ReplaceStr takes string source,string old,string new returns string
    return ReplaceStrEx(source,old,new,0)
endfunction

function Str2Num takes string s,string charmap returns integer
    local integer i = StringLength(s)
    local integer m = 0
    local integer n = StringLength(charmap)
    local integer f
    call XYweuiOpenAll2()
    loop
        exitwhen i == 0
        set f = FindStr(charmap, SubString(s, i - 1, i)) * R2I(Pow(n, I2R(StringLength(s) - i)))
        if f == -1 then
            return m
        endif
        set m = m + f
        set i = i - 1
    endloop
    return m
endfunction

function Num2Str takes integer m,string charmap returns string
    local integer i = m
    local string s = ""
    local integer n = StringLength(charmap)
    call XYweuiOpenAll2()
    loop
        exitwhen i == 0
        set s = SubStringEx(charmap, ModuloInteger(i, n), 1) + s
        set i = i / n
    endloop
    return s
endfunction

function Str2Bin takes string s returns integer
    call XYweuiOpenAll2()
    return Str2Num(s,bincharmap)
endfunction

function Bin2Str takes integer i returns string
    call XYweuiOpenAll2()
    return Num2Str(i,bincharmap)
endfunction

function Str2Hex takes string s returns integer
    call XYweuiOpenAll2()
    return Str2Num(s,hexcharmap)
endfunction

function Hex2Str takes integer i returns string
    call XYweuiOpenAll2()
    return Num2Str(i,hexcharmap)
endfunction

function Str2Oct takes string s returns integer
    call XYweuiOpenAll2()
    return Str2Num(s,octcharmap)
endfunction

function Oct2Str takes integer i returns string
    call XYweuiOpenAll2()
    return Num2Str(i,octcharmap)
endfunction

function Str2Id takes string s returns integer
    call XYweuiOpenAll2()
    return Str2Num(s,idcharmap)
endfunction

function Id2Str takes integer i returns string
    call XYweuiOpenAll2()
    return Num2Str(i,idcharmap)
endfunction

endlibrary

#endif /// XYweuiZFCXTIncluded
