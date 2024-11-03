#ifndef XYweuihqwpjgIncluded
#define XYweuihqwpjgIncluded

<?
    local slk = require 'slk'
?>

#include "YDWEBase.j"
#include "XYwebase.j"

//first 

library XYweuihqwpjg1 initializer XYweuihqwpjg1Init requires YDWEBase, XYwebase

private function XYweuihqwpjg1Init takes nothing returns nothing
    call XYweuiOpenAll2()
    set SLK_GC = InitGameCache("SLK_GC")

    <?
        for id, obj in slk.item:factory() do
            local goldcost = obj.goldcost
            if goldcost ~= '' then
    ?>
                call StoreInteger(SLK_GC, "<?=id?>", "goldcost", <?=goldcost?>)
    <?
            end
        end
    ?>
endfunction

function XYweuihqwpjga takes item XYweuihqwpjga1 returns integer 
    local integer XYweuihqwpjga_1 = (GetStoredInteger(SLK_GC, YDWEId2S(GetItemTypeId(XYweuihqwpjga1)), "goldcost"))
    return XYweuihqwpjga_1
endfunction 

endlibrary

//second 

library XYweuihqwpjg2 initializer XYweuihqwpjg2Init requires YDWEBase, XYwebase

private function XYweuihqwpjg2Init takes nothing returns nothing
    call XYweuiOpenAll2()
    set SLK_GC = InitGameCache("SLK_GC")

    <?
        for id, obj in slk.item:factory() do
            local lumbercost = obj.lumbercost
            if lumbercost ~= '' then
    ?>
                call StoreInteger(SLK_GC, "<?=id?>", "lumbercost", <?=lumbercost?>)
    <?
            end
        end
    ?>
endfunction

function XYweuihqwpjgb takes item XYweuihqwpjgb1 returns integer 
    local integer XYweuihqwpjgb_1 = (GetStoredInteger(SLK_GC, YDWEId2S(GetItemTypeId(XYweuihqwpjgb1)), "lumbercost"))
    return XYweuihqwpjgb_1
endfunction 

endlibrary

#endif /// XYweuihqwpjgIncluded
