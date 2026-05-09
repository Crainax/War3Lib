#ifndef OnceHintIncluded
#define OnceHintIncluded

#include "Crainax/core/constant/OnceHintConstant.j"

//! zinc
/*
玩家"一次性提醒"基底库（OnceHint）
---------------------------------------------------------------------------
功能：
  - 用一串 60 位数字串为每个玩家维护"首次事件提醒"的 bit 位图
  - 触发某事件时：业务侧自行 has(p, pos) 判断，未触发则展示文字并 mark(p, pos)
  - 全部 bit 位常量集中在 `core/constant/OnceHintConstant.j`（1..186 内分配）

存档约定（遵循 dzapi-server-save-load 规范）：
  - 仅在开局 0.5s 后做一次 `DzAPI_Map_GetStoredString` 拉取，进入内存缓存
  - 局中读 `has` 一律走缓存，不再回查 DzAPI
  - 写入采用 write-through：先改缓存，再调用 `DzAPI_Map_StoreString` 写回

仅暴露三个 API：
  - onceHint.isReady()         : 存档是否拉取完毕（0.5s 后变 true）
  - onceHint.has(p, pos)       : 该位是否已经被标记过（即是否触发过）
  - onceHint.mark(p, pos)      : 标记该位（true=本次为首次，false=已标记/参数非法）

典型业务用法：
  if (onceHint.isReady() && onceHint.mark(p, ONCE_HINT_FIRST_KILL)) {
      DisplayTimedTextToPlayer(p, 0, 0, 8.0, "首次击杀！可以前往商店购买装备。");
  }
---------------------------------------------------------------------------
*/
library OnceHint requires StringBitUtils, PlayerUtils, DzAPI {

    // ====== 内存缓存（按 ConvertedPlayerId: 1..MAX_PLAYER_COUNT） ======
    private string sBits[];
    private boolean onceHintReady = false;

    // ====== 内部：参数校验并返回缓存索引（非法返回 0） ======
    private function getIdx(player p) -> integer {
        integer idx;
        if (p == null) { return 0; }
        idx = GetConvertedPlayerId(p);
        if (idx < 1 || idx > MAX_PLAYER_COUNT) { return 0; }
        return idx;
    }

    // ====== 内部：拉取并落入缓存（容错为空串/非法长度） ======
    private function loadFromServer(player p, integer idx) {
        string s = DzAPI_Map_GetStoredString(p, ONCE_HINT_KEY);
        if (s == null) { s = ONCE_HINT_EMPTY; }
        if (StringLength(s) < 60) { s = ONCE_HINT_EMPTY; }
        sBits[idx] = s;
    }

    // ====== 公共 API（黑箱） ======
    public struct onceHint []{

        // 是否已就绪（开局存档读取完毕）
        static method isReady() -> boolean {
            return onceHintReady;
        }

        // 查询：某 bit 是否已经触发过（已显示过）
        static method has(player p, integer pos) -> boolean {
            integer idx = getIdx(p);
            if (idx == 0) { return false; }
            if (pos <= 0 || pos > ONCE_HINT_MAX_BIT) { return false; }
            return IsSuperBit(sBits[idx], pos);
        }

        // 标记：将某 bit 置 1 并写回服务器
        // 返回：true=本次为"首次"（0→1，业务侧据此显示提示）；false=之前已是 1 或参数非法
        static method mark(player p, integer pos) -> boolean {
            integer idx = getIdx(p);
            if (idx == 0) { return false; }
            if (pos <= 0 || pos > ONCE_HINT_MAX_BIT) { return false; }
            if (IsSuperBit(sBits[idx], pos)) {
                return false;
            }
            sBits[idx] = SetSuperBit(sBits[idx], pos, true);
            DzAPI_Map_StoreString(p, ONCE_HINT_KEY, sBits[idx]);
            return true;
        }

        // ====== 生命周期 ======
        static method onInit() {
            integer i;
            trigger tr;

            // 缓存初始化为空串，避免 IsSuperBit 在未就绪时读到 null
            for (1 <= i <= MAX_PLAYER_COUNT) {
                sBits[i] = ONCE_HINT_EMPTY;
            }

            // 延迟 0.5s 拉取存档（与 MallItem/Server 时序错峰，避免抢资源）
            tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr, 0.5);
            TriggerAddCondition(tr, Condition(function () {
                integer i;
                player p;
                for (1 <= i <= MAX_PLAYER_COUNT) {
                    p = ConvertedPlayer(i);
                    if (GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(p) == MAP_CONTROL_USER) {
                        loadFromServer(p, i);
                    }
                    p = null;
                }
                onceHintReady = true;
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;
        }
    }

}
//! endzinc

#endif
