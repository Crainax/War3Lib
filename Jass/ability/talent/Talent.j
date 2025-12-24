#ifndef TalentIncluded
#define TalentIncluded

#define SKILL_LIMIT_PER_PLAYER     31
#define BOOK1                      'A000'
#define BOOK2                      'A001'
#define BOOK3                      'A002'
#define ORDERID_IN_SPELLBOOK       851975

#include "Crainax/core/constant/JapiConstant.j"

//! zinc
/*
新版异度上的天赋系统
*/
library Talent requires AbilityCool {

    public struct talent [] {
        private static unit bookUnit[];
        private static integer skills[MAX_PLAYER_COUNT][SKILL_LIMIT_PER_PLAYER];
        private static integer skillCount[];

        private static string lastList1[];
        private static string lastList2[];
        private static string lastList3[];
        private static boolean lastEnable2[];
        private static boolean lastEnable3[];

        private static integer snapCount[];
        private static integer snapAbil[MAX_PLAYER_COUNT][SKILL_LIMIT_PER_PLAYER];
        private static real snapCd[MAX_PLAYER_COUNT][SKILL_LIMIT_PER_PLAYER];
        private static timer restoreTimer[];

        private static method getPid(player p) -> integer {
            integer pid;
            if (p == null) {
                return 0;
            }
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) {
                return 0;
            }
            return pid;
        }

        private static method indexOf(integer pid, integer abilId) -> integer {
            integer i;
            for (1 <= i <= thistype.skillCount[pid]) {
                if (thistype.skills[pid][i] == abilId) {
                    return i;
                }
            }
            return 0;
        }

        private static method joinRange(integer pid, integer startIdx, integer endIdx) -> string {
            integer i;
            string result = "";
            string token;

            if (endIdx < startIdx) {
                return "";
            }

            if (endIdx > thistype.skillCount[pid]) {
                endIdx = thistype.skillCount[pid];
            }

            if (startIdx < 1) {
                startIdx = 1;
            }

            for (startIdx <= i <= endIdx) {
                if (thistype.skills[pid][i] != 0) {
                    token = YDWEId2S(thistype.skills[pid][i]);
                    if (result == "") {
                        result = token;
                    } else {
                        result = result + "," + token;
                    }
                }
            }
            return result;
        }

        private static method buildBook1(integer pid, integer total, boolean enable2) -> string {
            string list;
            string bridge;

            if (total <= 11) {
                return thistype.joinRange(pid, 1, total);
            }

            list = thistype.joinRange(pid, 1, 10);
            bridge = YDWEId2S(BOOK2);
            if (list == "") {
                return bridge;
            }
            return list + "," + bridge;
        }

        private static method buildBook2(integer pid, integer total, boolean enable2, boolean enable3) -> string {
            string list;
            string bridge;

            if (!enable2) {
                return "";
            }

            if (!enable3) {
                return thistype.joinRange(pid, 11, total);
            }

            list = thistype.joinRange(pid, 11, 20);
            bridge = YDWEId2S(BOOK3);
            if (list == "") {
                return bridge;
            }
            return list + "," + bridge;
        }

        private static method buildBook3(integer pid, integer total, boolean enable3) -> string {
            if (!enable3) {
                return "";
            }
            return thistype.joinRange(pid, 21, total);
        }

        private static method snapshotRange(integer pid, unit u, integer startIdx, integer endIdx) {
            integer i;
            integer abilId;
            real cd;

            if (u == null) { return; }
            if (endIdx > thistype.skillCount[pid]) {
                endIdx = thistype.skillCount[pid];
            }
            if (startIdx < 1) {
                startIdx = 1;
            }
            if (endIdx < startIdx) {
                return;
            }

            for (startIdx <= i <= endIdx) {
                abilId = thistype.skills[pid][i];
                if (abilId != 0) {
                    cd = YDWEGetUnitAbilityState(u, abilId, ABILITY_STATE_COOLDOWN);
                    if (cd > 0.0) {
                        thistype.snapCount[pid] += 1;
                        thistype.snapAbil[pid][thistype.snapCount[pid]] = abilId;
                        thistype.snapCd[pid][thistype.snapCount[pid]] = cd;
                    }
                }
            }
        }

        private static method restoreCooldownNow(integer pid, unit u) {
            integer i;

            if (u == null) { return; }

            for (1 <= i <= thistype.snapCount[pid]) {
                if (thistype.snapAbil[pid][i] != 0 && thistype.snapCd[pid][i] > 0.0) {
                    YDWESetUnitAbilityState(u, thistype.snapAbil[pid][i], ABILITY_STATE_COOLDOWN, thistype.snapCd[pid][i]);
                }
                thistype.snapAbil[pid][i] = 0;
                thistype.snapCd[pid][i] = 0.0;
            }

            thistype.snapCount[pid] = 0;
        }

        private static method rebuild(integer pid, boolean fo) {
            unit u;
            integer total;
            boolean enable2; boolean enable3;
            boolean need1; boolean need2; boolean need3;
            boolean set1; boolean set2; boolean set3;
            string list1; string list2; string list3;

            u = thistype.bookUnit[pid];
            if (u == null) {
                return;
            }

            total = thistype.skillCount[pid];
            enable2 = total > 11;
            enable3 = total > 21;

            list1 = thistype.buildBook1(pid, total, enable2);
            list2 = thistype.buildBook2(pid, total, enable2, enable3);
            list3 = thistype.buildBook3(pid, total, enable3);

            need1 = fo || list1 != thistype.lastList1[pid] || enable2 != thistype.lastEnable2[pid] || enable3 != thistype.lastEnable3[pid];
            need2 = fo || list2 != thistype.lastList2[pid];
            need3 = fo || list3 != thistype.lastList3[pid];

            set1 = false;
            set2 = false;
            set3 = false;

            if (need1) {
                set1 = true;
                set2 = true;
                set3 = true;
            } else if (need2) {
                set2 = true;
                set3 = true;
            } else if (need3) {
                set3 = true;
            } else {
                return;
            }

            if (GetUnitAbilityLevel(u, BOOK1) == 0) {
                UnitAddAbility(u, BOOK1);
            }

            thistype.snapCount[pid] = 0;
            if (set1) {
                thistype.snapshotRange(pid, u, 1, total);
            } else if (set2) {
                thistype.snapshotRange(pid, u, 11, total);
            } else if (set3) {
                thistype.snapshotRange(pid, u, 21, total);
            }

            if (set1) {
                DzSetUnitAbilitySpellBookList(u, BOOK1, list1, true);
                DzSetUnitAbilityUpdate(u, BOOK1);
            }

            if (set2 && enable2) {
                DzSetUnitAbilitySpellBookList(u, BOOK2, list2, true);
                DzSetUnitAbilityUpdate(u, BOOK2);
            }

            if (set3 && enable3) {
                DzSetUnitAbilitySpellBookList(u, BOOK3, list3, true);
                DzSetUnitAbilityUpdate(u, BOOK3);
            }

            thistype.lastList1[pid] = list1;
            thistype.lastList2[pid] = list2;
            thistype.lastList3[pid] = list3;
            thistype.lastEnable2[pid] = enable2;
            thistype.lastEnable3[pid] = enable3;

            if (thistype.snapCount[pid] > 0) {
                thistype.restoreCooldownNow(pid, u);
            }
        }

        public static method bindUnit(player p, unit u) {
            integer pid;

            pid = thistype.getPid(p);
            if (pid == 0) { return; }

            thistype.bookUnit[pid] = u;
            thistype.rebuild(pid, true);
        }

        public static method getCount(player p) -> integer {
            integer pid;
            pid = thistype.getPid(p);
            if (pid == 0) { return 0; }
            return thistype.skillCount[pid];
        }

        public static method hasSpellId(player p, integer abilId) -> boolean {
            integer pid;
            pid = thistype.getPid(p);
            if (pid == 0) { return false; }
            return thistype.indexOf(pid, abilId) != 0;
        }

        public static method debugPrintList(player p) {
            integer pid;
            integer i;
            unit u;
            string list;

            pid = thistype.getPid(p);
            if (pid == 0) { return; }

            DisplayTextToPlayer(p, 0, 0, "|cffffcc00[Talent]|r skills=" + I2S(thistype.skillCount[pid]));
            for (1 <= i <= thistype.skillCount[pid]) {
                DisplayTextToPlayer(p, 0, 0, "  [" + I2S(i) + "] " + YDWEId2S(thistype.skills[pid][i]));
            }

            u = thistype.bookUnit[pid];
            if (u == null) {
                DisplayTextToPlayer(p, 0, 0, "  (no bound unit)");
                return;
            }

            list = DzGetUnitAbilitySpellBookList(u, BOOK1);
            DisplayTextToPlayer(p, 0, 0, "BOOK1: " + S3(list == null, "", list));
            list = DzGetUnitAbilitySpellBookList(u, BOOK2);
            DisplayTextToPlayer(p, 0, 0, "BOOK2: " + S3(list == null, "", list));
            list = DzGetUnitAbilitySpellBookList(u, BOOK3);
            DisplayTextToPlayer(p, 0, 0, "BOOK3: " + S3(list == null, "", list));
        }

        public static method clearAll(player p) {
            integer pid;
            integer i;

            pid = thistype.getPid(p);
            if (pid == 0) { return; }

            for (1 <= i <= thistype.skillCount[pid]) {
                thistype.skills[pid][i] = 0;
            }
            thistype.skillCount[pid] = 0;
            thistype.rebuild(pid, true);
        }

        public static method addSpellId(player p, integer abilId) -> boolean {
            integer pid;
            unit u;
            real cd;

            pid = thistype.getPid(p);
            if (pid == 0 || abilId == 0) { return false; }

            if (thistype.indexOf(pid, abilId) != 0) {
                return false;
            }

            if (thistype.skillCount[pid] >= SKILL_LIMIT_PER_PLAYER) {
                BJDebugMsg("|cffff0000[Talent]|r reach limit " + I2S(SKILL_LIMIT_PER_PLAYER));
                return false;
            }

            thistype.skillCount[pid] += 1;
            thistype.skills[pid][thistype.skillCount[pid]] = abilId;

            thistype.rebuild(pid, false);

            // 若该技能此前被移出技能书但仍处于冷却中，则从 AbilityCool 取剩余CD并写回真实CD
            u = thistype.bookUnit[pid];
            if (u != null) {
                cd = GetAbilityCD(u, abilId);
                if (cd > 0.0) {
                    YDWESetUnitAbilityState(u, abilId, ABILITY_STATE_COOLDOWN, cd);
                }
            }
            u = null;
            return true;
        }

        public static method removeSpellId(player p, integer abilId) -> boolean {
            integer pid;
            integer idx;
            integer i;
            unit u;
            real cd;

            pid = thistype.getPid(p);
            if (pid == 0 || abilId == 0) { return false; }

            idx = thistype.indexOf(pid, abilId);
            if (idx == 0) {
                return false;
            }

            u = thistype.bookUnit[pid];
            if (u != null) {
                cd = YDWEGetUnitAbilityState(u, abilId, ABILITY_STATE_COOLDOWN);
                if (cd > 0.0) {
                    SetAbilityCD(u, abilId, cd);
                }
            }
            u = null;

            for (idx <= i <= thistype.skillCount[pid] - 1) {
                thistype.skills[pid][i] = thistype.skills[pid][i + 1];
            }
            thistype.skills[pid][thistype.skillCount[pid]] = 0;
            thistype.skillCount[pid] -= 1;

            thistype.rebuild(pid, false);
            return true;
        }

        public static method isInSpellBookLocal(player p) -> boolean {
            integer pid;
            integer abilId;
            integer orderId;

            pid = thistype.getPid(p);
            if (pid == 0) { return false; }

            abilId = GetCurrentXYAbility(0, 0);
            orderId = GetCurrentXYAbilityOrder(3, 2);

            if (orderId != ORDERID_IN_SPELLBOOK) {
                return false;
            }

            if (abilId == 0) {
                return false;
            }

            return thistype.indexOf(pid, abilId) != 0;
        }
    }

}

//! endzinc
#endif
