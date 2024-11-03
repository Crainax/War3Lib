#ifndef XYweuiMSXTIncluded
#define XYweuiMSXTIncluded

#include "XYwebase.j"
#include "XYweuiddjl.j"

library XYweuiMSXT requires XYwebase, XYweuiddjl

/*
函数名称：    被伤害系统
作者：        新月团队:恶魔-遗忘 
最后修改日期：2017年/4月/22日 
函数版本号：  2.0


XYweui 
物理
101伤害减免穿透 固定值
102伤害减免穿透 百分比
103伤害减免 固定值
104伤害减免 百分百
105护盾生命 固定值
106暴击伤害 固定值
107暴击伤害 百分比
108暴击伤害几率 百分比
109暴击减免 固定值
110暴击减免 百分比
111暴击减免几率 百分比
112伤害加深 固定值
113伤害加深 百分比
114生命汲取 固定值
115生命汲取 百分比 
116命中几率 百分比
117闪避几率 百分比 
魔法
201伤害减免穿透 固定值
202伤害减免穿透 百分比
203伤害减免 固定值
204伤害减免 百分百
205护盾生命 固定值
206暴击伤害 固定值
207暴击伤害 百分比
208暴击伤害几率 百分比
209暴击减免 固定值
210暴击减免 百分比
211暴击减免几率 百分比
212伤害加深 固定值
213伤害加深 百分比
214生命汲取 固定值
215生命汲取 百分比 
216命中几率 百分比
217闪避几率 百分比 
全伤害
301伤害减免穿透 固定值
302伤害减免穿透 百分比
303伤害减免 固定值
304伤害减免 百分百
305护盾生命 固定值
306暴击伤害 固定值
307暴击伤害 百分比
308暴击伤害几率 百分比
309暴击减免 固定值
310暴击减免 百分比
311暴击减免几率 百分比
312伤害加深 固定值
313伤害加深 百分比
314生命汲取 固定值
315生命汲取 百分比 
316命中几率 百分比
317闪避几率 百分比 

先结算闪避与命中 之后结算是否暴击伤害   之后结算伤害加深  再结算伤害减免 再结算吸血  最后结算护盾

判断物理或者魔法伤害  最后同理结算全伤害

主动伤害系统
添加闪避 命中 致命抵抗   

if ((XYweuiddjla(XYweuiddjlr)) == true) then
        set XYweuiddjlb = TRUE
    endif
    
        local unit XYweui_0_0/*伤害来源*/=GetEventDamageSource()
    local unit XYweui_0_1/*受伤单位*/=GetTriggerUnit()
    local timer XYweui_0_2/*计时器*/=CreateTimer()
    local integer XYweui_0_3/*伤害来源ID*/=GetHandleId(XYweui_0_0)
    local integer XYweui_0_3/*受伤单位ID*/=GetHandleId(XYweui_0_1)
    local integer XYweui_0_4/*计时器ID*/=GetHandleId(XYweui_0_2)
    local real XYweui_0_5/*最初伤害*/= GetEventDamage()
    local real XYweui_0_6/*新伤害*/
    local real XYweuiMSXT_6 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,1)    //伤害减免 
    local real XYweuiMSXT_7 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,2)    //伤害减免百分比 
    local real XYweuiMSXT_8 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,3)    //护盾值 
    local real XYweuiMSXT_12 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,4)  //暴击伤害 
    local real XYweuiMSXT_13 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,5)  //暴击伤害百分比 
    local real XYweuiMSXT_14 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,6)  //暴击几率 
    local real XYweuiMSXT_15 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,7)  //吸血 
    local real XYweuiMSXT_16 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,8)  //吸血百分比 
    local real XYweuiMSXT_17 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,9)  //伤害加深百分比 
    local real XYweuiMSXT_9                                           //减免总值 
    local real XYweuiMSXT_10                                          //减免后的伤害 
    local real XYweuiMSXT_11                                          //护盾破裂后剩余的伤害 
    local real XYweuiMSXT_20                                          //吸血 
    local real XYweuiMSXT_21 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,10) //伤害加深 
    local boolean XYweuiMSXT_23 = LoadBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11) //计算马甲伤害 
    
*/

function XYweuiMSXTb takes nothing returns nothing
    local timer XYweui_0 = GetExpiredTimer()
    local integer XYweui_1 = GetHandleId(XYweui_0)
    local unit XYweui_2 = LoadUnitHandle(XYwe_hxb_ms,XYweui_1,1)
    call SetUnitInvulnerable(XYweui_2,false)
    call PauseTimer(XYweui_0)
    call DestroyTimer(XYweui_0)
    call FlushChildHashtable(XYwe_hxb_ms,XYweui_1)
    set XYweui_0 = null
    set XYweui_2 = null
endfunction
    
function XYweuiMSXTa takes boolean XYweui1,boolean XYweui2,boolean XYweui3 returns nothing
    local unit XYweuiMSXT_1 = GetTriggerUnit()                        //触发单位 
    local unit XYweuiMSXT_18 = GetEventDamageSource()                 //伤害来源 
    local timer XYweuiMSXT_2 = CreateTimer()                          //新建计时器 
    local integer XYweuiMSXT_3 = GetHandleId(XYweuiMSXT_1)            //触发单位的汉德值 
    local integer XYweuiMSXT_4 = GetHandleId(XYweuiMSXT_2)            //计时器的汉德值 
    local integer XYweuiMSXT_19 = GetHandleId(XYweuiMSXT_18)          //伤害来源的汉德值 
    local real XYweuiMSXT_5 = GetEventDamage()                        //原伤害值 
    local real XYweuiMSXT_22                                          //新伤害值 
    local real XYweuiMSXT_6 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,1)    //伤害减免 
    local real XYweuiMSXT_7 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,2)    //伤害减免百分比 
    local real XYweuiMSXT_8 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,3)    //护盾值 
    local real XYweuiMSXT_12 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,4)  //暴击伤害 
    local real XYweuiMSXT_13 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,5)  //暴击伤害百分比 
    local real XYweuiMSXT_14 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,6)  //暴击几率 
    local real XYweuiMSXT_15 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,7)  //吸血 
    local real XYweuiMSXT_16 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,8)  //吸血百分比 
    local real XYweuiMSXT_17 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,9)  //伤害加深百分比 
    local real XYweuiMSXT_9                                           //减免总值 
    local real XYweuiMSXT_10                                          //减免后的伤害 
    local real XYweuiMSXT_11                                          //护盾破裂后剩余的伤害 
    local real XYweuiMSXT_20                                          //吸血 
    local real XYweuiMSXT_21 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,10) //伤害加深 
    local boolean XYweuiMSXT_23 = LoadBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11) //计算马甲伤害 
    
    if ((XYweuiMSXT_23 != true) and (GetUnitAbilityLevel(GetTriggerUnit(), 'Avul') < 1)) then
        call SaveBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11,true) 
        if (XYweui2 == true) then  // 状态为开启暴击
            if ( XYweuiMSXT_14 <= 0.00 ) then //暴击几率小于或等于 0 [不允许暴击] 
                set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21) //不暴击的总伤害 
                set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)   //总伤害减免值
            else
                if  (( XYweuiMSXT_14 > 0.00 ) and ( XYweuiMSXT_14 < 100.00 )) then
                    if ( GetRandomReal(0.00, 100.00) <= XYweuiMSXT_14 ) then   //允许暴击
                        set XYweuiMSXT_22 = ((((((XYweuiMSXT_5 * (100.00 + XYweuiMSXT_13))/100.00) + XYweuiMSXT_12) * (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //暴击后的总伤害 
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)  //总伤害减免值
                    else
                        set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //不暴击的总伤害 
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6) //总伤害减免值
                    endif
                else
                    if ( XYweuiMSXT_14 >= 100.0 ) then
                        set XYweuiMSXT_22 = ((((((XYweuiMSXT_5 * (100.00 + XYweuiMSXT_13))/100.00) + XYweuiMSXT_12) * (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //暴击后的总伤害
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)  //总伤害减免值
                    endif
                endif
            endif
        else
            set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //不暴击的总伤害 
            set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6) //总伤害减免值
        endif
        
        if (XYweuiMSXT_9 > 0.00) then //减免总值大于0 
            if (XYweuiMSXT_9 >= XYweuiMSXT_22) then //减免总值大于或等于总伤害 
                call SetUnitInvulnerable(XYweuiMSXT_1,true) 
                call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                if (XYweui3 == true) then//吸血开启 
                    set XYweuiMSXT_20 = (XYweuiMSXT_15)
                    call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                    if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then  //漂浮文字开启 
                        call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                        call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                        call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                        call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                        call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                    endif
                endif
            else
                set XYweuiMSXT_10 = (XYweuiMSXT_22 - XYweuiMSXT_9) //减免后剩余的伤害
                if (XYweuiMSXT_8 >= XYweuiMSXT_10) then  //护盾值大于或等于减免后的伤害
                    call SaveReal(XYwe_hxb_ms,XYweuiMSXT_3,3,(XYweuiMSXT_8 - XYweuiMSXT_10)) 
                    call SetUnitInvulnerable(XYweuiMSXT_1,true)
                    call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                    call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                    if (XYweui3 == true) then //吸血开启
                        set XYweuiMSXT_20 = (XYweuiMSXT_15)
                        call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                        if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then //漂浮文字开启 
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if ((XYweuiMSXT_8 < XYweuiMSXT_10) and (XYweuiMSXT_8 > 0)) then   //护盾值小于剩余的伤害值 且 大于0 
                        set XYweuiMSXT_11 = (XYweuiMSXT_10 - XYweuiMSXT_8) //破裂后的伤害 
                        call SaveReal(XYwe_hxb_ms,XYweuiMSXT_3,3,0)
                        call SetUnitInvulnerable(XYweuiMSXT_1,true)
                        call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                        call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                        if ((XYweui1 == true) and (XYweuiMSXT_11 > 0.00)) then
                            call CreateTextTagUnitBJ(((( "|cffff" + I2S(GetRandomInt(1000, 9999))) + R2S(XYweuiMSXT_11) + "|r")),XYweuiMSXT_1, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                        if (XYweui3 == true) then
                            set XYweuiMSXT_20 = (XYweuiMSXT_15 + ((XYweuiMSXT_11 * XYweuiMSXT_16)/100.00))
                            call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                            if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then
                                call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                                call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                                call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                                call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                                call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                            endif
                        endif
                        call UnitDamageTarget(XYweuiMSXT_18,XYweuiMSXT_1,XYweuiMSXT_11, false, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS )
                    else
                        set XYweuiMSXT_11 = (XYweuiMSXT_5 - XYweuiMSXT_10)
                        call SetUnitLifeBJ(XYweuiMSXT_1,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_1) + XYweuiMSXT_11))
                        if ((XYweui1 == true) and (XYweuiMSXT_10 > 0.00)) then
                            call CreateTextTagUnitBJ(((( "|cffff" + I2S(GetRandomInt(1000, 9999))) + R2S(XYweuiMSXT_10) + "|r")),XYweuiMSXT_1, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                        if (XYweui3 == true) then
                            set XYweuiMSXT_20 = (XYweuiMSXT_15 + ((XYweuiMSXT_10 * XYweuiMSXT_16)/100.00))
                            call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                            if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then
                                call CreateTextTagUnitBJ(((( "|cfffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                                call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                                call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                                call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                                call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                            endif
                        endif
                    endif
                endif
            endif
        else
            set XYweuiMSXT_10 = (XYweuiMSXT_22) //无减免的总伤害 
            if (XYweuiMSXT_8 >= XYweuiMSXT_10) then //护盾值大于或等于总伤害 
                call SaveReal(XYwe_hxb_ms,XYweuiMSXT_3,3,(XYweuiMSXT_8 - XYweuiMSXT_10))
                call SetUnitInvulnerable(XYweuiMSXT_1,true)
                call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                if (XYweui3 == true) then
                    set XYweuiMSXT_20 = (XYweuiMSXT_15) 
                    call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                    if ((XYweui1 == true)  and (XYweuiMSXT_20 > 0.00)) then
                        call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                        call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                        call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                        call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                        call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                    endif
                endif
            else
                if ((XYweuiMSXT_8 < XYweuiMSXT_10) and (XYweuiMSXT_8 > 0)) then//护盾值小于伤害 且大于0 
                    set XYweuiMSXT_11 = (XYweuiMSXT_10 - XYweuiMSXT_8)//护盾破裂后的伤害 
                    call SaveReal(XYwe_hxb_ms,XYweuiMSXT_3,3,0)
                    call SetUnitInvulnerable(XYweuiMSXT_1,true)
                    call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                    call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                    if ((XYweui1 == true) and (XYweuiMSXT_11 > 0.00)) then
                        call CreateTextTagUnitBJ(((( "|cffff" + I2S(GetRandomInt(1000, 9999))) + R2S(XYweuiMSXT_11) + "|r")),XYweuiMSXT_1, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                        call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                        call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                        call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                        call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                    endif
                    if (XYweui3 == true) then
                        set XYweuiMSXT_20 = ((XYweuiMSXT_15 + ((XYweuiMSXT_11 * XYweuiMSXT_16)/100.00)) + XYweuiMSXT_15)
                        call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                        if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                    call UnitDamageTarget(XYweuiMSXT_18,XYweuiMSXT_1,XYweuiMSXT_11, false, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS )
                else
                    set XYweuiMSXT_11 = (XYweuiMSXT_22 - XYweuiMSXT_5)
                    call UnitDamageTarget(XYweuiMSXT_18,XYweuiMSXT_1,XYweuiMSXT_11, false, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNIVERSAL, WEAPON_TYPE_WHOKNOWS )
                    if ((XYweui1 == true) and (XYweuiMSXT_22 > 0.00 )) then
                        call CreateTextTagUnitBJ(((( "|cffff" + I2S(GetRandomInt(1000, 9999))) + R2S(XYweuiMSXT_22) + "|r")),XYweuiMSXT_1, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                        call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                        call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                        call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                        call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                    endif
                    if (XYweui3 == true) then
                        set XYweuiMSXT_20 = ((XYweuiMSXT_15 + ((XYweuiMSXT_22 * XYweuiMSXT_16)/100.00)) + XYweuiMSXT_15)
                        call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                        if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                endif
            endif
        endif
    endif
    call XYweuiOpenAll2()
    call SaveBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11,false) 
    set XYweuiMSXT_1 = null
    set XYweuiMSXT_2 = null
    set XYweuiMSXT_18 = null
endfunction

function XYweuiMSXTc takes unit XYweuiMSXTca1, integer XYweuiMSXTca3, integer XYweuiMSXTca2, real XYweuiMSXTca4 returns nothing
    local integer XYweuiMSXTca_1 =  GetHandleId(XYweuiMSXTca1)
    if (XYweuiMSXTca2 == 1) then
        call SaveReal(XYwe_hxb_ms,XYweuiMSXTca_1,XYweuiMSXTca3,((LoadReal(XYwe_hxb_ms,XYweuiMSXTca_1,XYweuiMSXTca3)) + XYweuiMSXTca4))
    endif
    if (XYweuiMSXTca2 == 2) then
        call SaveReal(XYwe_hxb_ms,XYweuiMSXTca_1,XYweuiMSXTca3,XYweuiMSXTca4)
    endif
    if (XYweuiMSXTca2 == 3) then
        call SaveReal(XYwe_hxb_ms,XYweuiMSXTca_1,XYweuiMSXTca3,((LoadReal(XYwe_hxb_ms,XYweuiMSXTca_1,XYweuiMSXTca3)) - XYweuiMSXTca4))
    endif
    call XYweuiOpenAll2()
endfunction

function XYweuiMSXTd takes unit XYweuiMSXTda1, integer XYweuiMSXTda2 returns real
    local integer XYweuiMSXTda_1 =  GetHandleId(XYweuiMSXTda1)
    local real XYweuiMSXTda_2 
    
    call XYweuiOpenAll2()
    set XYweuiMSXTda_2 = LoadReal(XYwe_hxb_ms,XYweuiMSXTda_1,XYweuiMSXTda2)
    
    return XYweuiMSXTda_2
endfunction

function XYweuiMSXTe takes unit XYweui0 returns nothing
    local integer XYweui_0 = GetHandleId(XYweui0)
    call FlushChildHashtable(XYwe_hxb_ms,XYweui_0)
endfunction

endlibrary

#endif /// XYweuiMSXTIncluded
