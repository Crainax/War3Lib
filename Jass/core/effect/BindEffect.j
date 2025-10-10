
#ifndef BindEffectIncluded
#define BindEffectIncluded


//! zinc
// ======================================================
// BindEffect - 特效绑定生命周期库
// ======================================================
// 依赖：UnitHashTable.j, Hash_UnitDefine.j
// 使用 HASH_UNIT 存储单位绑定的特效，单位死亡时自动清理
// ======================================================


#define EFFECT_COUNT_KEY HASH_UNIT_EFFECT_COUNT  // 存储特效数量 (100)
#define EFFECT_START_KEY HASH_UNIT_EFFECT_1      // 特效存储起始键 (101-120)
#define MAX_EFFECTS 20                            // 最多存储20个特效
#define MDL_HASH_START_KEY (HASH_UNIT_EFFECT_1 + 20)  // mdl hash 存储起始键 (121-140)

#include "Crainax/core/table/Hash_UnitDefine.j"

library BindEffect requires UnitHashTable {

    // 特效存储配置
    public struct bindEffect [] {

        // 附加唯一特效（同mdl会替换旧特效）
        // 存储位置：EFFECT_START_KEY (101-120) 存储特效句柄
        // mdl hash 存储：MDL_HASH_START_KEY (121-140) 存储字符串hash
        public static method attachUnique(unit u, string mdl, string point) -> effect {
            effect old;
            effect e;
            integer id;
            integer i;
            integer mdlHash;
            integer effectKey;
            integer hashKey;
            integer storedHash;
            integer currentCount;

            if (u == null) { return null; }

            id = GetHandleId(u);
            mdlHash = StringHash(mdl);

            // 先查找是否已存在相同 mdl 的特效
            for (i = 0; i < MAX_EFFECTS; i += 1) {
                effectKey = EFFECT_START_KEY + i;
                hashKey = MDL_HASH_START_KEY + i;

                storedHash = LoadInteger(HASH_UNIT, id, hashKey);
                if (storedHash == mdlHash) {
                    // 找到相同 mdl，替换旧特效
                    old = LoadEffectHandle(HASH_UNIT, id, effectKey);
                    if (old != null) {
                        DestroyEffect(old);
                        old = null;
                    }

                    // 创建新特效并存储
                    e = AddSpecialEffectTarget(mdl, u, point);
                    if (e != null) {
                        SaveEffectHandle(HASH_UNIT, id, effectKey, e);
                        SaveInteger(HASH_UNIT, id, hashKey, mdlHash);
                    }
                    return e;
                }
            }

            // 没找到相同 mdl，寻找空位
            for (i = 0; i < MAX_EFFECTS; i += 1) {
                effectKey = EFFECT_START_KEY + i;
                hashKey = MDL_HASH_START_KEY + i;

                if (!HaveSavedHandle(HASH_UNIT, id, effectKey)) {
                    // 找到空位，创建并存储
                    e = AddSpecialEffectTarget(mdl, u, point);
                    if (e != null) {
                        SaveEffectHandle(HASH_UNIT, id, effectKey, e);
                        SaveInteger(HASH_UNIT, id, hashKey, mdlHash);

                        // 更新特效数量
                        currentCount = LoadInteger(HASH_UNIT, id, EFFECT_COUNT_KEY);
                        SaveInteger(HASH_UNIT, id, EFFECT_COUNT_KEY, currentCount + 1);
                    }
                    return e;
                }
            }

            // 所有槽位已满
            BJDebugMsg("[BindEffect] Warning: Unit unique effects full (" + I2S(MAX_EFFECTS) + ")");
            return null;
        }

        // 清理指定 mdl 的唯一特效（通过 mdl 路径精准匹配）
        public static method detachUnique(unit u, string mdl) {
            integer id;
            integer i;
            integer mdlHash;
            integer effectKey;
            integer hashKey;
            integer storedHash;
            integer currentCount;
            effect e;

            if (u == null) { return; }

            id = GetHandleId(u);
            mdlHash = StringHash(mdl);

            // 遍历查找匹配的 mdl hash
            for (i = 0; i < MAX_EFFECTS; i += 1) {
                effectKey = EFFECT_START_KEY + i;
                hashKey = MDL_HASH_START_KEY + i;

                storedHash = LoadInteger(HASH_UNIT, id, hashKey);
                if (storedHash == mdlHash) {
                    // 找到匹配项，销毁特效并清空存储
                    e = LoadEffectHandle(HASH_UNIT, id, effectKey);
                    if (e != null) {
                        DestroyEffect(e);
                        RemoveSavedHandle(HASH_UNIT, id, effectKey);
                        e = null;
                    }

                    // 清空 mdl hash
                    RemoveSavedInteger(HASH_UNIT, id, hashKey);

                    // 更新特效数量
                    currentCount = LoadInteger(HASH_UNIT, id, EFFECT_COUNT_KEY);
                    if (currentCount > 0) {
                        SaveInteger(HASH_UNIT, id, EFFECT_COUNT_KEY, currentCount - 1);
                    }
                    return;
                }
            }
        }

        // 销毁单位所有特效（带详细调试追踪）
        public static method destroyAll(unit u) {
            integer id;
            integer i;
            integer effectKey;
            integer hashKey;
            effect e;
            boolean anyEffect = false;

            if (u == null) {
                return;
            }

            id = GetHandleId(u);

            // 清理所有特效句柄 (EFFECT_START_KEY: 101-120)
            for (i = 0; i < MAX_EFFECTS; i += 1) {
                effectKey = EFFECT_START_KEY + i;
                if (HaveSavedHandle(HASH_UNIT, id, effectKey)) {
                    e = LoadEffectHandle(HASH_UNIT, id, effectKey);
                    if (e != null) {
                        DestroyEffect(e);
                    }
                    RemoveSavedHandle(HASH_UNIT, id, effectKey);
                    e = null;
                    anyEffect = true;
                }
            }

            // 清理所有 mdl hash (MDL_HASH_START_KEY: 121-140)
            for (i = 0; i < MAX_EFFECTS; i += 1) {
                hashKey = MDL_HASH_START_KEY + i;
                if (HaveSavedInteger(HASH_UNIT, id, hashKey)) {
                    RemoveSavedInteger(HASH_UNIT, id, hashKey);
                }
            }

            // 清空特效数量
            SaveInteger(HASH_UNIT, id, EFFECT_COUNT_KEY, 0);
        }
    }
}
//! endzinc

#endif
