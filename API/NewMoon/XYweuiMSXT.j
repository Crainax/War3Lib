#ifndef XYweuiMSXTIncluded
#define XYweuiMSXTIncluded

#include "XYwebase.j"
#include "XYweuiddjl.j"

library XYweuiMSXT requires XYwebase, XYweuiddjl

/*
�������ƣ�    ���˺�ϵͳ
���ߣ�        �����Ŷ�:��ħ-���� 
����޸����ڣ�2017��/4��/22�� 
�����汾�ţ�  2.0


XYweui 
����
101�˺����⴩͸ �̶�ֵ
102�˺����⴩͸ �ٷֱ�
103�˺����� �̶�ֵ
104�˺����� �ٷְ�
105�������� �̶�ֵ
106�����˺� �̶�ֵ
107�����˺� �ٷֱ�
108�����˺����� �ٷֱ�
109�������� �̶�ֵ
110�������� �ٷֱ�
111�������⼸�� �ٷֱ�
112�˺����� �̶�ֵ
113�˺����� �ٷֱ�
114������ȡ �̶�ֵ
115������ȡ �ٷֱ� 
116���м��� �ٷֱ�
117���ܼ��� �ٷֱ� 
ħ��
201�˺����⴩͸ �̶�ֵ
202�˺����⴩͸ �ٷֱ�
203�˺����� �̶�ֵ
204�˺����� �ٷְ�
205�������� �̶�ֵ
206�����˺� �̶�ֵ
207�����˺� �ٷֱ�
208�����˺����� �ٷֱ�
209�������� �̶�ֵ
210�������� �ٷֱ�
211�������⼸�� �ٷֱ�
212�˺����� �̶�ֵ
213�˺����� �ٷֱ�
214������ȡ �̶�ֵ
215������ȡ �ٷֱ� 
216���м��� �ٷֱ�
217���ܼ��� �ٷֱ� 
ȫ�˺�
301�˺����⴩͸ �̶�ֵ
302�˺����⴩͸ �ٷֱ�
303�˺����� �̶�ֵ
304�˺����� �ٷְ�
305�������� �̶�ֵ
306�����˺� �̶�ֵ
307�����˺� �ٷֱ�
308�����˺����� �ٷֱ�
309�������� �̶�ֵ
310�������� �ٷֱ�
311�������⼸�� �ٷֱ�
312�˺����� �̶�ֵ
313�˺����� �ٷֱ�
314������ȡ �̶�ֵ
315������ȡ �ٷֱ� 
316���м��� �ٷֱ�
317���ܼ��� �ٷֱ� 

�Ƚ������������� ֮������Ƿ񱩻��˺�   ֮������˺�����  �ٽ����˺����� �ٽ�����Ѫ  �����㻤��

�ж��������ħ���˺�  ���ͬ�����ȫ�˺�

�����˺�ϵͳ
������� ���� �����ֿ�   

if ((XYweuiddjla(XYweuiddjlr)) == true) then
        set XYweuiddjlb = TRUE
    endif
    
        local unit XYweui_0_0/*�˺���Դ*/=GetEventDamageSource()
    local unit XYweui_0_1/*���˵�λ*/=GetTriggerUnit()
    local timer XYweui_0_2/*��ʱ��*/=CreateTimer()
    local integer XYweui_0_3/*�˺���ԴID*/=GetHandleId(XYweui_0_0)
    local integer XYweui_0_3/*���˵�λID*/=GetHandleId(XYweui_0_1)
    local integer XYweui_0_4/*��ʱ��ID*/=GetHandleId(XYweui_0_2)
    local real XYweui_0_5/*����˺�*/= GetEventDamage()
    local real XYweui_0_6/*���˺�*/
    local real XYweuiMSXT_6 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,1)    //�˺����� 
    local real XYweuiMSXT_7 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,2)    //�˺�����ٷֱ� 
    local real XYweuiMSXT_8 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,3)    //����ֵ 
    local real XYweuiMSXT_12 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,4)  //�����˺� 
    local real XYweuiMSXT_13 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,5)  //�����˺��ٷֱ� 
    local real XYweuiMSXT_14 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,6)  //�������� 
    local real XYweuiMSXT_15 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,7)  //��Ѫ 
    local real XYweuiMSXT_16 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,8)  //��Ѫ�ٷֱ� 
    local real XYweuiMSXT_17 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,9)  //�˺�����ٷֱ� 
    local real XYweuiMSXT_9                                           //������ֵ 
    local real XYweuiMSXT_10                                          //�������˺� 
    local real XYweuiMSXT_11                                          //�������Ѻ�ʣ����˺� 
    local real XYweuiMSXT_20                                          //��Ѫ 
    local real XYweuiMSXT_21 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,10) //�˺����� 
    local boolean XYweuiMSXT_23 = LoadBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11) //��������˺� 
    
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
    local unit XYweuiMSXT_1 = GetTriggerUnit()                        //������λ 
    local unit XYweuiMSXT_18 = GetEventDamageSource()                 //�˺���Դ 
    local timer XYweuiMSXT_2 = CreateTimer()                          //�½���ʱ�� 
    local integer XYweuiMSXT_3 = GetHandleId(XYweuiMSXT_1)            //������λ�ĺ���ֵ 
    local integer XYweuiMSXT_4 = GetHandleId(XYweuiMSXT_2)            //��ʱ���ĺ���ֵ 
    local integer XYweuiMSXT_19 = GetHandleId(XYweuiMSXT_18)          //�˺���Դ�ĺ���ֵ 
    local real XYweuiMSXT_5 = GetEventDamage()                        //ԭ�˺�ֵ 
    local real XYweuiMSXT_22                                          //���˺�ֵ 
    local real XYweuiMSXT_6 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,1)    //�˺����� 
    local real XYweuiMSXT_7 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,2)    //�˺�����ٷֱ� 
    local real XYweuiMSXT_8 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_3,3)    //����ֵ 
    local real XYweuiMSXT_12 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,4)  //�����˺� 
    local real XYweuiMSXT_13 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,5)  //�����˺��ٷֱ� 
    local real XYweuiMSXT_14 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,6)  //�������� 
    local real XYweuiMSXT_15 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,7)  //��Ѫ 
    local real XYweuiMSXT_16 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,8)  //��Ѫ�ٷֱ� 
    local real XYweuiMSXT_17 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,9)  //�˺�����ٷֱ� 
    local real XYweuiMSXT_9                                           //������ֵ 
    local real XYweuiMSXT_10                                          //�������˺� 
    local real XYweuiMSXT_11                                          //�������Ѻ�ʣ����˺� 
    local real XYweuiMSXT_20                                          //��Ѫ 
    local real XYweuiMSXT_21 = LoadReal(XYwe_hxb_ms,XYweuiMSXT_19,10) //�˺����� 
    local boolean XYweuiMSXT_23 = LoadBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11) //��������˺� 
    
    if ((XYweuiMSXT_23 != true) and (GetUnitAbilityLevel(GetTriggerUnit(), 'Avul') < 1)) then
        call SaveBoolean(XYwe_hxb_ms,XYweuiMSXT_19,11,true) 
        if (XYweui2 == true) then  // ״̬Ϊ��������
            if ( XYweuiMSXT_14 <= 0.00 ) then //��������С�ڻ���� 0 [��������] 
                set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21) //�����������˺� 
                set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)   //���˺�����ֵ
            else
                if  (( XYweuiMSXT_14 > 0.00 ) and ( XYweuiMSXT_14 < 100.00 )) then
                    if ( GetRandomReal(0.00, 100.00) <= XYweuiMSXT_14 ) then   //������
                        set XYweuiMSXT_22 = ((((((XYweuiMSXT_5 * (100.00 + XYweuiMSXT_13))/100.00) + XYweuiMSXT_12) * (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //����������˺� 
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)  //���˺�����ֵ
                    else
                        set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //�����������˺� 
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6) //���˺�����ֵ
                    endif
                else
                    if ( XYweuiMSXT_14 >= 100.0 ) then
                        set XYweuiMSXT_22 = ((((((XYweuiMSXT_5 * (100.00 + XYweuiMSXT_13))/100.00) + XYweuiMSXT_12) * (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //����������˺�
                        set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6)  //���˺�����ֵ
                    endif
                endif
            endif
        else
            set XYweuiMSXT_22 = (((XYweuiMSXT_5* (100.00 + XYweuiMSXT_17))/100.00) + XYweuiMSXT_21)   //�����������˺� 
            set XYweuiMSXT_9 = (((XYweuiMSXT_22*XYweuiMSXT_7)/100.00)+XYweuiMSXT_6) //���˺�����ֵ
        endif
        
        if (XYweuiMSXT_9 > 0.00) then //������ֵ����0 
            if (XYweuiMSXT_9 >= XYweuiMSXT_22) then //������ֵ���ڻ�������˺� 
                call SetUnitInvulnerable(XYweuiMSXT_1,true) 
                call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                if (XYweui3 == true) then//��Ѫ���� 
                    set XYweuiMSXT_20 = (XYweuiMSXT_15)
                    call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                    if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then  //Ư�����ֿ��� 
                        call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                        call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                        call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                        call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                        call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                    endif
                endif
            else
                set XYweuiMSXT_10 = (XYweuiMSXT_22 - XYweuiMSXT_9) //�����ʣ����˺�
                if (XYweuiMSXT_8 >= XYweuiMSXT_10) then  //����ֵ���ڻ���ڼ������˺�
                    call SaveReal(XYwe_hxb_ms,XYweuiMSXT_3,3,(XYweuiMSXT_8 - XYweuiMSXT_10)) 
                    call SetUnitInvulnerable(XYweuiMSXT_1,true)
                    call SaveUnitHandle(XYwe_hxb_ms,XYweuiMSXT_4,1,XYweuiMSXT_1)
                    call TimerStart(XYweuiMSXT_2,0.00,false,function XYweuiMSXTb)
                    if (XYweui3 == true) then //��Ѫ����
                        set XYweuiMSXT_20 = (XYweuiMSXT_15)
                        call SetUnitLifeBJ(XYweuiMSXT_18,(GetUnitStateSwap(UNIT_STATE_LIFE,XYweuiMSXT_18) + XYweuiMSXT_20))
                        if ((XYweui1 == true) and (XYweuiMSXT_20 > 0.00)) then //Ư�����ֿ��� 
                            call CreateTextTagUnitBJ(((( "|cffffc" + I2S(GetRandomInt(100, 999))) + R2S(XYweuiMSXT_20) + "|r")),XYweuiMSXT_18, GetRandomReal(10.00, 40.00), GetRandomReal(8.00, 16.00), 100.00, 100.00, 100.00, 20.00 )
                            call SetTextTagPermanent( GetLastCreatedTextTag(), false )
                            call SetTextTagVelocityBJ( GetLastCreatedTextTag(), GetRandomReal(150.00, 250.00), GetRandomDirectionDeg() )
                            call SetTextTagLifespan( GetLastCreatedTextTag(), 0.45 )
                            call SetTextTagFadepoint( GetLastCreatedTextTag(), 0.45 )
                        endif
                    endif
                else
                    if ((XYweuiMSXT_8 < XYweuiMSXT_10) and (XYweuiMSXT_8 > 0)) then   //����ֵС��ʣ����˺�ֵ �� ����0 
                        set XYweuiMSXT_11 = (XYweuiMSXT_10 - XYweuiMSXT_8) //���Ѻ���˺� 
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
            set XYweuiMSXT_10 = (XYweuiMSXT_22) //�޼�������˺� 
            if (XYweuiMSXT_8 >= XYweuiMSXT_10) then //����ֵ���ڻ�������˺� 
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
                if ((XYweuiMSXT_8 < XYweuiMSXT_10) and (XYweuiMSXT_8 > 0)) then//����ֵС���˺� �Ҵ���0 
                    set XYweuiMSXT_11 = (XYweuiMSXT_10 - XYweuiMSXT_8)//�������Ѻ���˺� 
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
