#ifndef UTItemAbilityIncluded
#define UTItemAbilityIncluded

#include "Crainax/core/constant/TypeConstant.j"

//! zinc
library UTItemAbility requires ItemAbility {

    // 替换为你地图中存在的技能 rawcode
    private constant integer ABIL_A1 = 'A001'; // 示例：技能1
    private constant integer ABIL_A2 = 'A002'; // 示例：技能2
    private constant integer ABIL_B1 = 'A003'; // 示例：技能1的另一种
    private constant integer ABIL_B2 = 'A004'; // 示例：技能2的另一种

    // 测试用物品类型（rawcode）
    private constant integer ITYPE_1 = 'I001'; // 测试物品1
    private constant integer ITYPE_2 = 'I002'; // 测试物品2

    // 测试环境对象
    private static unit gHero = null;
    private static player gP = null;

    // 工具：打印单位的某个技能等级
    private function PrintAbilityLevel(unit u, integer abilId) {
        local integer lvl = GetUnitAbilityLevel(u, abilId);
        if (lvl > 0) {
            BJDebugMsg("[UT] Ability " + I2S(abilId) + " level = " + I2S(lvl));
        } else {
            BJDebugMsg("[UT] Ability " + I2S(abilId) + " not present.");
        }
    }

    // 工具：显示当前英雄技能情况
    private function ShowAllAbilities() {
        BJDebugMsg("|cff00ff00[UT] === Show Abilities ===|r");
        PrintAbilityLevel(gHero, ABIL_A1);
        PrintAbilityLevel(gHero, ABIL_A2);
        PrintAbilityLevel(gHero, ABIL_B1);
        PrintAbilityLevel(gHero, ABIL_B2);
        BJDebugMsg("|cff00ff00[UT] =======================|r");
    }

    // 工具：清空单位身上的测试技能（强制重置）
    private function ForceClearAbilities() {
        if (GetUnitAbilityLevel(gHero, ABIL_A1) > 0) { UnitRemoveAbility(gHero, ABIL_A1); }
        if (GetUnitAbilityLevel(gHero, ABIL_A2) > 0) { UnitRemoveAbility(gHero, ABIL_A2); }
        if (GetUnitAbilityLevel(gHero, ABIL_B1) > 0) { UnitRemoveAbility(gHero, ABIL_B1); }
        if (GetUnitAbilityLevel(gHero, ABIL_B2) > 0) { UnitRemoveAbility(gHero, ABIL_B2); }
        BJDebugMsg("[UT] Force cleared abilities on hero.");
    }

    // 工具：清空背包中的所有物品
    private function ClearHeroItems() {
        local integer i = 0;
        local item it;
        loop
            exitwhen i >= 6
            set it = UnitItemInSlot(gHero, i)
            if (it != null) then
                call RemoveItem(it)
            endif
            set i = i + 1
        endloop
        set it = null
        BJDebugMsg("[UT] Cleared hero items.");
    }

    // 工具：创建并给予英雄测试物品（并调用 UnitGetItemtypeAbility）
    private function GiveTestItem(integer itemTypeId) {
        local item it = CreateItem(itemTypeId, GetUnitX(gHero), GetUnitY(gHero));
        call UnitAddItem(gHero, it)
        call UnitGetItemtypeAbility(gHero, itemTypeId)
        call BJDebugMsg("[UT] Gave item type: " + I2S(itemTypeId))
        set it = null
    }

    // 工具：从英雄身上移除1件该类型物品（若有），并调用 UnitLostItemtypeAbility
    private function RemoveOneTestItem(integer itemTypeId) {
        local integer i = 0
        local item it
        loop
            exitwhen i >= 6
            set it = UnitItemInSlot(gHero, i)
            if (it != null and GetItemTypeId(it) == itemTypeId) then
                call UnitRemoveItem(gHero, it)
                call UnitLostItemtypeAbility(gHero, itemTypeId)
                call RemoveItem(it)
                call BJDebugMsg("[UT] Removed one item type: " + I2S(itemTypeId))
                set it = null
                return
            endif
            set i = i + 1
        endloop
        set it = null
        BJDebugMsg("[UT] No item of type " + I2S(itemTypeId) + " found to remove.")
    }

    // 初始化物品类型的技能配置（覆盖 SetItemtypeAbility1/2）
    private function ConfigItemtypeBase() {
        // ITYPE_1: A1@lv2, A2@lv3
        call SetItemtypeAbility1(ITYPE_1, ABIL_A1, 2)
        call SetItemtypeAbility2(ITYPE_1, ABIL_A2, 3)
        // ITYPE_2: A1@lv4, A2@lv1
        call SetItemtypeAbility1(ITYPE_2, ABIL_A1, 4)
        call SetItemtypeAbility2(ITYPE_2, ABIL_A2, 1)
        BJDebugMsg("[UT] Config item types done.")
    }

    // 测试：ItemtypeHasAbility
    private function Test_ItemtypeHasAbility() {
        local boolean h1 = ItemtypeHasAbility(null, ITYPE_1)
        local boolean h2 = ItemtypeHasAbility(null, ITYPE_2)
        call BJDebugMsg("[UT] ItemtypeHasAbility(ITYPE_1) = " + (h1 ? "true" : "false"))
        call BJDebugMsg("[UT] ItemtypeHasAbility(ITYPE_2) = " + (h2 ? "true" : "false"))
    }

    // 自动测试流程
    private function AutoFlow() {
        // 清理环境
        call ClearHeroItems()
        call ForceClearAbilities()
        call ConfigItemtypeBase()
        call Test_ItemtypeHasAbility()

        // 1) 给一个 ITYPE_1 => A1@2, A2@3
        call BJDebugMsg("|cffffff00[UT] Step1: Give ITYPE_1|r")
        call GiveTestItem(ITYPE_1)
        call ShowAllAbilities() // 预期：A1=2, A2=3

        // 2) 再给一个 ITYPE_2 => A1@4(覆盖到4), A2@3(仍3)
        call BJDebugMsg("|cffffff00[UT] Step2: Give ITYPE_2|r")
        call GiveTestItem(ITYPE_2)
        call ShowAllAbilities() // 预期：A1=4, A2=3

        // 3) 移除一个 ITYPE_1 => A1仍4, A2 可能保持3（因为还有 ITYPE_2 的 A2@1，所以 A2 应回退到1 还是 3？注意：ITYPE_2 提供 A2@1 -> 最大等级应回退到1）
        call BJDebugMsg("|cffffff00[UT] Step3: Remove ITYPE_1|r")
        call RemoveOneTestItem(ITYPE_1)
        call ShowAllAbilities() // 预期：A1=4（来自 ITYPE_2），A2=1（来自 ITYPE_2）

        // 4) 再移除 ITYPE_2 => A1/A2 都应被移除
        call BJDebugMsg("|cffffff00[UT] Step4: Remove ITYPE_2|r")
        call RemoveOneTestItem(ITYPE_2)
        call ShowAllAbilities() // 预期：A1/A2 不存在
    }

    // 聊天命令
    private function OnChat() {
        local string s = GetEventPlayerChatString()
        local string cmd
        local integer sp = StringLength(s)
        if (SubStringBJ(s, 1, 1) == "-") then
            set cmd = SubStringBJ(s, 2, sp)
            // 简单命令解析
            if (cmd == "auto") then
                call AutoFlow()
            elseif (cmd == "show") then
                call ShowAllAbilities()
            elseif (cmd == "clear") then
                call ClearHeroItems()
                call ForceClearAbilities()
            elseif (cmd == "give1") then
                call GiveTestItem(ITYPE_1)
            elseif (cmd == "give2") then
                call GiveTestItem(ITYPE_2)
            elseif (cmd == "drop1") then
                call RemoveOneTestItem(ITYPE_1)
            elseif (cmd == "drop2") then
                call RemoveOneTestItem(ITYPE_2)
            elseif (SubStringBJ(cmd,1,4) == "set1") then
                // 语法：-set1 abilId level
                // 例如：-set1 1093677105 2
                local string rest = SubStringBJ(cmd,6,StringLength(cmd))
                local integer spacePos = StringFind(rest, " ", 0)
                local string aStr; local string lStr
                local integer aId; local integer lvl
                if (spacePos >= 0) then
                    set aStr = SubString(rest, 0, spacePos)
                    set lStr = SubString(rest, spacePos+1, StringLength(rest))
                    set aId  = S2I(aStr)
                    set lvl  = S2I(lStr)
                    call SetItemtypeAbility1(ITYPE_1, aId, lvl)
                    call BJDebugMsg("[UT] Set ITYPE_1 ability1 = " + I2S(aId) + " lv=" + I2S(lvl))
                endif
            elseif (SubStringBJ(cmd,1,4) == "set2") then
                // 语法：-set2 abilId level
                local string rest2 = SubStringBJ(cmd,6,StringLength(cmd))
                local integer spacePos2 = StringFind(rest2, " ", 0)
                local string aStr2; local string lStr2
                local integer aId2; local integer lvl2
                if (spacePos2 >= 0) then
                    set aStr2 = SubString(rest2, 0, spacePos2)
                    set lStr2 = SubString(rest2, spacePos2+1, StringLength(rest2))
                    set aId2  = S2I(aStr2)
                    set lvl2  = S2I(lStr2)
                    call SetItemtypeAbility2(ITYPE_1, aId2, lvl2)
                    call BJDebugMsg("[UT] Set ITYPE_1 ability2 = " + I2S(aId2) + " lv=" + I2S(lvl2))
                endif
            endif
        endif
    }

    // 创建测试英雄
    private function CreateTestHero() {
        local integer pid = 0 // 玩家1
        set gP = Player(pid)
        // 替换为你地图中存在的英雄 rawcode
        set gHero = CreateUnit(gP, 'H000', GetStartLocationX(pid), GetStartLocationY(pid), 0.0)
        call SelectUnitForPlayerSingle(gHero, gP)
        call PanCameraToTimedForPlayer(gP, GetUnitX(gHero), GetUnitY(gHero), 0.00)
        call BJDebugMsg("[UT] Test hero created for Player1.")
    }

    public function Init() {
        call CreateTestHero()
        // 注册聊天事件
        call UnitTestRegisterChatEvent(function OnChat)
        // 初始提示
        call BJDebugMsg("|cffffcc00[ItemAbility UT] Commands:|r -auto, -show, -clear, -give1, -give2, -drop1, -drop2, -set1 abilId lv, -set2 abilId lv")
    }

    function onInit() {
        // 延时启动，避免与地图其他初始化冲突
        local trigger tr = CreateTrigger()
        call TriggerRegisterTimerEventSingle(tr, 0.50)
        call TriggerAddAction(tr, function Init)
        set tr = null
    }
}
//! endzinc

#endif
