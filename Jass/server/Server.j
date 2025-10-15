#ifndef ServerIncluded
#define ServerIncluded

// 常量配置（与 MallItem 时序对齐：扫描延迟 = MALLITEM_INIT_DELAY + 0.5）
#define SERVER_MAX_KEYS        512
#define SERVER_HASH_CAP        1021
#define SERVER_TYPE_INTEGER    1
#define SERVER_TYPE_REAL       2
#define SERVER_TYPE_STRING     3

//! zinc
/*
服务器总控
*/
library Server {

    // 通用服务器键值黑箱（支持 integer/real/string）
    public struct server []{
        // ====== 状态与事件 ======
        private static boolean initialized = false;
        private static boolean ready = false;
        private static trigger readyTrigger = null;

        // ====== 键表（统一哈希：key -> index+1） ======
        private static integer mapIdx[];     // 开放寻址哈希槽（0 表示空）
        private static string keys[];        // 按索引存储键名
        private static integer kinds[];      // 每个键的类型（SERVER_TYPE_*）
        private static integer keyCount = 0; // 已注册键数量

        // ====== 值缓存（玩家 × 键索引） ======
        private static integer intVals[];
        private static real realVals[];
        private static string strVals[];

        // ====== 内部：哈希检索 ======
        private static method getIndex(string key) -> integer {
            integer slot; integer steps; integer cap; integer val; integer idx;
            if (key == null) { return -1; }
            if (StringLength(key) == 0) { return -1; }

            cap = SERVER_HASH_CAP;
            slot = ModuloInteger(StringHash(key), cap);
            if (slot < 0) { slot = slot + cap; }
            steps = 0;
            while (steps < cap) {
                val = server.mapIdx[slot];
                if (val == 0) { return -1; }
                idx = val - 1;
                if (idx >= 0 && idx < server.keyCount && server.keys[idx] == key) {
                    return idx;
                }
                slot = slot + 1;
                if (slot >= cap) { slot = 0; }
                steps = steps + 1;
            }
            return -1;
        }

        private static method setIndex(string key, integer index) {
            integer slot; integer steps; integer cap; integer val;
            cap = SERVER_HASH_CAP;
            slot = ModuloInteger(StringHash(key), cap);
            if (slot < 0) { slot = slot + cap; }
            steps = 0;
            while (steps < cap) {
                val = server.mapIdx[slot];
                if (val == 0) {
                    server.mapIdx[slot] = index + 1; // 写入 index+1
                    return;
                }
                slot = slot + 1;
                if (slot >= cap) { slot = 0; }
                steps = steps + 1;
            }
        }

        private static method addKey(string key, integer kind) {
            integer idx; integer pid; integer base;
            if (key == null) { return; }
            if (StringLength(key) == 0) { return; }

            // 已存在则校验类型，若不一致则忽略更新
            idx = server.getIndex(key);
            if (idx >= 0) {
                // 若已存在且未标注类型，则补齐；若已有类型则保持不变
                if (server.kinds[idx] == 0) {
                    server.kinds[idx] = kind;
                }
                return;
            }

            if (server.keyCount >= SERVER_MAX_KEYS) {
                return; // 超上限忽略
            }

            idx = server.keyCount;
            server.keys[idx] = key;
            server.kinds[idx] = kind;
            server.setIndex(key, idx);

            // 为所有玩家初始化该键的默认值
            pid = 0;
            while (pid < MAX_PLAYER_COUNT) {
                base = pid * SERVER_MAX_KEYS;
                if (kind == SERVER_TYPE_INTEGER) {
                    server.intVals[base + idx] = 0;
                } else if (kind == SERVER_TYPE_REAL) {
                    server.realVals[base + idx] = 0.0;
                } else if (kind == SERVER_TYPE_STRING) {
                    server.strVals[base + idx] = "";
                }
                pid = pid + 1;
            }

            server.keyCount = server.keyCount + 1;
        }

        // ====== 生命周期 ======
        static method onInit() {
            // 初始化就绪触发器与状态
            server.initialized = false;
            server.ready = false;
            server.keyCount = 0;
            server.readyTrigger = CreateTrigger();

            // 如需：清空哈希槽（默认 0 即为空）
            // integer i; integer cap;
            // cap = SERVER_HASH_CAP;
            // i = 0;
            // while (i < cap) { server.mapIdx[i] = 0; i = i + 1; }
        }

        // 注册键；首次调用时启动延迟扫描
        static method init(integer kind, string key) {
            timer t;

            // 增量注册 key（开放寻址哈希）
            server.addKey(key, kind);

            // 首次调用：延迟扫描（比 MallItem 晚 0.5 秒）
            if (!server.initialized) {
                server.initialized = true;

                t = CreateTimer();
                TimerStart(t, MALLITEM_INIT_DELAY + 0.5, false, function () {
                    integer pid; integer idx; integer base; player p; integer n; integer k;

                    n = server.keyCount;
                    pid = 0;
                    while (pid < MAX_PLAYER_COUNT) {
                        p = ConvertedPlayer(pid + 1);
                        base = pid * SERVER_MAX_KEYS;

                        idx = 0;
                        while (idx < n) {
                            k = server.kinds[idx];
                            if (k == SERVER_TYPE_INTEGER) {
                                server.intVals[base + idx] = DzAPI_Map_GetStoredInteger(p, server.keys[idx]);
                            } else if (k == SERVER_TYPE_REAL) {
                                server.realVals[base + idx] = DzAPI_Map_GetStoredReal(p, server.keys[idx]);
                            } else if (k == SERVER_TYPE_STRING) {
                                server.strVals[base + idx] = DzAPI_Map_GetStoredString(p, server.keys[idx]);
                            }
                            idx = idx + 1;
                        }

                        p = null;
                        pid = pid + 1;
                    }

                    server.ready = true;
                    if (server.readyTrigger != null) {
                        TriggerEvaluate(server.readyTrigger);
                    }
                });
                // handler 置空
                t = null;
            }
        }

        // ====== 事件注册 ======
        static method onReady(code cb) {
            if (server.readyTrigger == null) {
                server.readyTrigger = CreateTrigger();
            }
            TriggerAddCondition(server.readyTrigger, Condition(cb));
            if (server.ready) {
                TriggerEvaluate(server.readyTrigger);
            }
        }

        static method isReady() -> boolean {
            return server.ready;
        }

        // ====== 读取 API（per-player） ======
        static method loadInteger(player whichPlayer, string key) -> integer {
            integer pid; integer idx; integer base; integer v;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return 0; }
            idx = server.getIndex(key);
            if (idx < 0) { return 0; }
            base = pid * SERVER_MAX_KEYS;
            if (server.ready) {
                return server.intVals[base + idx];
            }
            // 未就绪：即时从 DzAPI 读取并写回缓存
            v = DzAPI_Map_GetStoredInteger(whichPlayer, key);
            server.intVals[base + idx] = v;
            return v;
        }

        static method loadReal(player whichPlayer, string key) -> real {
            integer pid; integer idx; integer base; real v;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return 0.0; }
            idx = server.getIndex(key);
            if (idx < 0) { return 0.0; }
            base = pid * SERVER_MAX_KEYS;
            if (server.ready) {
                return server.realVals[base + idx];
            }
            v = DzAPI_Map_GetStoredReal(whichPlayer, key);
            server.realVals[base + idx] = v;
            return v;
        }

        static method loadString(player whichPlayer, string key) -> string {
            integer pid; integer idx; integer base; string v;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return ""; }
            idx = server.getIndex(key);
            if (idx < 0) { return ""; }
            base = pid * SERVER_MAX_KEYS;
            if (server.ready) {
                return server.strVals[base + idx];
            }
            v = DzAPI_Map_GetStoredString(whichPlayer, key);
            server.strVals[base + idx] = v;
            return v;
        }

        // ====== 保存 API（per-player） ======
        static method saveInteger(player whichPlayer, string key, integer val) -> boolean {
            integer pid; integer idx; integer base;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return false; }
            idx = server.getIndex(key);
            if (idx < 0) { return false; }
            if (server.kinds[idx] != SERVER_TYPE_INTEGER) { return false; }
            DzAPI_Map_StoreInteger(whichPlayer, key, val);
            base = pid * SERVER_MAX_KEYS;
            server.intVals[base + idx] = val;
            return true;
        }

        static method saveReal(player whichPlayer, string key, real val) -> boolean {
            integer pid; integer idx; integer base;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return false; }
            idx = server.getIndex(key);
            if (idx < 0) { return false; }
            if (server.kinds[idx] != SERVER_TYPE_REAL) { return false; }
            DzAPI_Map_StoreReal(whichPlayer, key, val);
            base = pid * SERVER_MAX_KEYS;
            server.realVals[base + idx] = val;
            return true;
        }

        static method saveString(player whichPlayer, string key, string val) -> boolean {
            integer pid; integer idx; integer base;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return false; }
            idx = server.getIndex(key);
            if (idx < 0) { return false; }
            if (server.kinds[idx] != SERVER_TYPE_STRING) { return false; }
            DzAPI_Map_StoreString(whichPlayer, key, val);
            base = pid * SERVER_MAX_KEYS;
            server.strVals[base + idx] = val;
            return true;
        }

        // ====== 刷新与查询 ======
        static method refreshForPlayer(integer playerId) {
            integer pid; player p; integer base; integer i; integer n; integer k;
            pid = playerId;
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return; }
            p = ConvertedPlayer(pid + 1);
            base = pid * SERVER_MAX_KEYS;
            n = server.keyCount;
            i = 0;
            while (i < n) {
                k = server.kinds[i];
                if (k == SERVER_TYPE_INTEGER) {
                    server.intVals[base + i] = DzAPI_Map_GetStoredInteger(p, server.keys[i]);
                } else if (k == SERVER_TYPE_REAL) {
                    server.realVals[base + i] = DzAPI_Map_GetStoredReal(p, server.keys[i]);
                } else if (k == SERVER_TYPE_STRING) {
                    server.strVals[base + i] = DzAPI_Map_GetStoredString(p, server.keys[i]);
                }
                i = i + 1;
            }
            p = null;
        }

        static method hasKey(string key) -> boolean {
            return server.getIndex(key) >= 0;
        }

        static method getKeyCount() -> integer {
            return server.keyCount;
        }

        static method getKeyByIndex(integer oneBasedIndex) -> string {
            integer idx;
            idx = oneBasedIndex - 1;
            if (idx < 0 || idx >= server.keyCount) { return ""; }
            return server.keys[idx];
        }

        static method getAllKeysByType(integer kind) -> string {
            integer i; string out; integer n;
            n = server.keyCount;
            out = "";
            i = 0;
            while (i < n) {
                if (server.kinds[i] == kind) {
                    if (StringLength(out) == 0) {
                        out = server.keys[i];
                    } else {
                        out = out + "," + server.keys[i];
                    }
                }
                i = i + 1;
            }
            return out;
        }
    }

}

//! endzinc
#endif
