#ifndef MallItemIncluded
#define MallItemIncluded

// 常量配置
#define MALLITEM_MAX_ITEMS      300
#define MALLITEM_INIT_DELAY     2.0
// 消费后服务端回写存在延迟：本地预扣 + 轮询校验
#define MALLITEM_VERIFY_DELAY    0.1
#define MALLITEM_VERIFY_RETRY    8
// 开放寻址哈希容量（必须 < 8192，选用素数以降低冲突）
#define MALLITEM_HASH_CAP       1021

#if (CURRENT_BUILD_VERSION != VERSION_RELEASE)

    #define DzAPI_Map_HasMallItem(p, k) true
    #define DzAPI_Map_GetMallItemCount(p, k) 999
    #define DzAPI_Map_ConsumeMallItem(p, k, c) true

#endif

// 使用说明（MallItem 黑箱）
// 1) 在地图启动阶段注册商品（每次注册一个 key）：
//    mallItem.init("VIP1");
//    mallItem.init("RhdeKey");
//    mallItem.init("RopgKey");
//
// 2) 可选：为商品配置元信息与科技（四位字符如 'Rhde' 为整数字面量）：
//    mallItem.setMeta("VIP1", "白金VIP", "ReplaceableTextures\\CommandButtons\\BTN.tga", "尊享特权");
//    mallItem.setTech("RhdeKey", 'Rhde'); // 步兵测试科技
//    mallItem.setTech("RopgKey", 'Ropg'); // ogre 测试科技
//
// 3) 等待就绪：在 2.0 秒后自动扫描，完成后触发 onReady 回调（使用 Condition/TriggerEvaluate）：
//    mallItem.onReady(function () -> boolean {
//        // 示例：查询玩家0（0-based）的拥有权与次数
//        if (mallItem.hasByPlayer(Player(0), "VIP1")) {
//            BJDebugMsg("[MallItem] 玩家0拥有VIP1, 次数=" + I2S(mallItem.getUseCountByPlayer(Player(0), "VIP1")));
//        }
//        return true;
//    });
//
// 4) 消费：
//    // 数量型消费：成功后回调被调用，并可通过 mallItem.getCallbackPlayer() 获取玩家
//    mallItem.consumeTimes(Player(0), "VIP1", 1, function () -> boolean {
//        player cbp = mallItem.getCallbackPlayer();
//        BJDebugMsg("[MallItem] consumeTimes 回调: " + GetPlayerName(cbp));
//        return true;
//    });
//    // 局数型消费：无回调
//    mallItem.consumeOnce(Player(0), "VIP1");
//
// 5) 其他：
//    local integer n = mallItem.getItemCount();
//    local string k1 = mallItem.getItemKeyByIndex(1); // 1-based 索引
//
//todo: 加入局内商品进包的回调
//! zinc
library MallItem requires DzAPI{

    // 黑箱：商城商品拥有权初始化、缓存、查询与元信息
    public struct mallItem []{

        // 状态与事件
        private static boolean initialized = false;
        private static boolean ready = false;
        private static trigger readyTrigger = null;

        // 开放寻址哈希表（key -> index+1），0 表示空槽
        // 容量受限于 JASS 数组上限（8192），本实现选用 1021
        private static integer mapIdx[];

        // 商品列表与映射
        private static integer itemCount = 0;
        private static string itemKeys[]; // 0..itemCount-1
        // 拥有权缓存：owns[player * MALLITEM_MAX_ITEMS + itemIndex] player是从0开始
        private static boolean owns[];
        // 使用次数缓存：uses[player * MALLITEM_MAX_ITEMS + itemIndex]
        private static integer uses[];

        // 元信息：按 itemIndex 对齐
        private static string names[];
        private static string icons[];
        private static string descs[];
        private static integer techs[];  // 科技 ID，如 'R015'（四位字符转换为整数）

        // 回调参数传递（避免哈希表冲突）
        public static player callbackPlayer = null;


        // ========== 内部：解析与映射 =========
        private static method getIndex(string key) ->integer {
            integer slot; integer steps; integer cap; integer val; integer idx;
            cap = MALLITEM_HASH_CAP;
            slot = ModuloInteger(StringHash(key), cap);
            if (slot < 0) { slot = slot + cap; }
            steps = 0;
            while (steps < cap) {
                val = mallItem.mapIdx[slot];
                if (val == 0) {
                    return -1; // 空槽：查找失败
                }
                idx = val - 1;
                if (idx >= 0 && idx < mallItem.itemCount && mallItem.itemKeys[idx] == key) {
                    return idx; // 命中
                }
                slot = slot + 1;
                if (slot >= cap) { slot = 0; }
                steps = steps + 1;
            }
            return -1;
        }

        private static method setIndex(string key, integer index) {
            integer slot; integer steps; integer cap; integer val;
            cap = MALLITEM_HASH_CAP;
            slot = ModuloInteger(StringHash(key), cap);
            if (slot < 0) { slot = slot + cap; }
            steps = 0;
            while (steps < cap) {
                val = mallItem.mapIdx[slot];
                if (val == 0) {
                    mallItem.mapIdx[slot] = index + 1; // 写入 index+1
                    return;
                }
                // 继续线性探测
                slot = slot + 1;
                if (slot >= cap) { slot = 0; }
                steps = steps + 1;
            }
            // 表已满（理论上不会发生：MALLITEM_MAX_ITEMS << MALLITEM_HASH_CAP）
        }

        private static method addKey(string key) {
            integer idx; integer i; integer n; integer base;
            if (key == null) { return; }
            if (StringLength(key) == 0) { return; }

            // 已存在则跳过
            idx = mallItem.getIndex(key);
            if (idx >= 0) { return; }

            if (mallItem.itemCount >= MALLITEM_MAX_ITEMS) {
                return; // 超上限忽略
            }

            idx = mallItem.itemCount;
            mallItem.itemKeys[idx] = key;
            mallItem.setIndex(key, idx);

            // 默认元信息
            mallItem.names[idx] = "";
            mallItem.icons[idx] = "";
            mallItem.descs[idx] = "";
            mallItem.techs[idx] = 0;

            // 初始化拥有权为 false（所有玩家）
            i = 0;
            while (i < MAX_PLAYER_COUNT) {
                base = i * MALLITEM_MAX_ITEMS;
                mallItem.owns[base + idx] = false;
                i = i + 1;
            }

            mallItem.itemCount = mallItem.itemCount + 1;
        }


        // （移除字符串拆分，改为单商品增量注册）

        //公用方法

        // 初始化底层（在 map 启动时自动调用）
        static method onInit() {
            // 先声明
            integer i; integer cap;

            mallItem.initialized = false;
            mallItem.ready = false;
            mallItem.itemCount = 0;
            mallItem.readyTrigger = CreateTrigger();

            // 清空哈希槽位
            // cap = MALLITEM_HASH_CAP;
            // i = 0;
            // while (i < cap) {
            //     mallItem.mapIdx[i] = 0;
            //     i = i + 1;
            // }
        }

        // 外部初始化：每次只注册一个商品 key；首次调用时启动延迟扫描
        static method init(string productKey) {
            timer t;

            // 注册商品（支持多次调用，去重在 addKey 内部完成）
            mallItem.addKey(productKey);

            // 首次调用时启动延迟扫描
            if (!mallItem.initialized) {
                mallItem.initialized = true;

                // 延迟初始化玩家商品状态
                t = CreateTimer();
                TimerStart(t, MALLITEM_INIT_DELAY, false, function () {
                integer pid; integer idx; integer base; player p; string k; integer n;

                n = mallItem.itemCount;
                pid = 0;
                while (pid < MAX_PLAYER_COUNT) {
                    p = ConvertedPlayer(pid + 1);
                    base = pid * MALLITEM_MAX_ITEMS;

                    idx = 0;
                    while (idx < n) {
                        k = mallItem.itemKeys[idx];
                        mallItem.owns[base + idx] = DzAPI_Map_HasMallItem(p, k);
                        mallItem.uses[base + idx] = DzAPI_Map_GetMallItemCount(p, k);
                        // 直接在此处解锁科技（如果拥有商品且设置了科技）
                        if (mallItem.owns[base + idx] && mallItem.techs[idx] != 0) {
                            SetPlayerTechResearched(p, mallItem.techs[idx], 1);
                        }
                        idx = idx + 1;
                    }

                    p = null;
                    pid = pid + 1;
                }

                mallItem.ready = true;

                if (mallItem.readyTrigger != null) {
                    // 使用 TriggerEvaluate 调用回调条件
                    TriggerEvaluate(mallItem.readyTrigger);
                }
            });
            // handler 置空
            t = null;
            }
        }

        // 是否已完成首次扫描
        static method isReady() ->boolean {
            return mallItem.ready;
        }

        // 注册 onReady 回调（使用 Condition 封装 code），若已就绪则立即 Evaluate
        static method onReady(code cb) {
            if (mallItem.readyTrigger == null) {
                mallItem.readyTrigger = CreateTrigger();
            }
            TriggerAddCondition(mallItem.readyTrigger, Condition(cb));
              if (mallItem.ready) {
                TriggerEvaluate(mallItem.readyTrigger);
            }
        }

        // 拥有权查询：通过玩家句柄
        static method hasByPlayer(player whichPlayer, string itemKey) ->boolean {
            integer pid; integer idx; integer base; boolean result;

            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) {
                return false;
            }

            idx = mallItem.getIndex(itemKey);
            if (idx < 0) {
                return false;
            }

            base = pid * MALLITEM_MAX_ITEMS;
            result = mallItem.owns[base + idx];
            return result;
        }

        // 使用次数查询：通过玩家句柄
        static method getUseCountByPlayer(player whichPlayer, string itemKey) ->integer {
            integer pid; integer idx; integer base;
            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return 0; }
            idx = mallItem.getIndex(itemKey);
            if (idx < 0) { return 0; }
            base = pid * MALLITEM_MAX_ITEMS;
            return mallItem.uses[base + idx];
        }


        // 刷新某玩家的拥有权（对已登记商品）
        static method refreshItemsForPlayer(integer playerId) {
            integer i; integer base; player p; string k; integer n;

            if (playerId < 0 || playerId >= MAX_PLAYER_COUNT) {
                return;
            }

            p = ConvertedPlayer(playerId + 1);
            base = playerId * MALLITEM_MAX_ITEMS;
            n = mallItem.itemCount;

            i = 0;
            while (i < n) {
                k = mallItem.itemKeys[i];
                mallItem.owns[base + i] = DzAPI_Map_HasMallItem(p, k);
                i = i + 1;
            }

            p = null;
        }

        // 消费次数型道具（带延时回调）：
        //  - 先本地预扣，阻止在服务器回写前的重复消费
        //  - 启动计时器周期轮询，待服务器数值可见后再执行回调
        static method consumeTimes(player whichPlayer, string itemKey, integer count, code callback) ->boolean {
            integer pid; integer idx; integer base; integer beforeCount; integer targetCount; boolean ok; trigger cbTr; timer t; integer hid;

            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return false; }
            idx = mallItem.getIndex(itemKey);
            if (idx < 0) { return false; }

            base = pid * MALLITEM_MAX_ITEMS;

            // 本地可用次数校验（阻止因服务器延迟导致的连点重复消费）
            beforeCount = mallItem.uses[base + idx];
            if (beforeCount < count) { return false; }

            // 执行消费（服务器侧异步回写）
            ok = DzAPI_Map_ConsumeMallItem(whichPlayer, itemKey, count);
            if (ok) {
                // 1) 立即进行"本地预扣"，防止在服务器延迟期间被重复消费
                targetCount = beforeCount - count;
                if (targetCount < 0) { targetCount = 0; }
                mallItem.uses[base + idx] = targetCount;
                mallItem.owns[base + idx] = (targetCount > 0);

                // 2) 启动计时器，轮询服务器直至回写可见，然后再执行回调
                //    保存上下文到 hashtable：pid(1), idx(2), target(3), retry(4), player(5), trigger(6)
                t = CreateTimer();
                hid = GetHandleId(t);
                SaveInteger(HASH_TIMER, hid, 1, pid);
                SaveInteger(HASH_TIMER, hid, 2, idx);
                SaveInteger(HASH_TIMER, hid, 3, targetCount);
                SaveInteger(HASH_TIMER, hid, 4, MALLITEM_VERIFY_RETRY);
                SavePlayerHandle(HASH_TIMER, hid, 5, whichPlayer);

                cbTr = null;
                if (callback != null) {
                    cbTr = CreateTrigger();
                    TriggerAddCondition(cbTr, Condition(callback));
                }
                SaveTriggerHandle(HASH_TIMER, hid, 6, cbTr);

                // 周期轮询，直至服务端数值 <= 目标值 或 重试次数耗尽
                TimerStart(t, MALLITEM_VERIFY_DELAY, true, function () {
                    timer tt; integer key; integer rPid; integer rIdx; integer rTarget; integer rRetry; player rp; trigger rTr;
                    integer rBase; integer serverCount; boolean hasOwn;

                    // 声明在前
                    tt = GetExpiredTimer();
                    key = GetHandleId(tt);

                    rPid    = LoadInteger(HASH_TIMER, key, 1);
                    rIdx    = LoadInteger(HASH_TIMER, key, 2);
                    rTarget = LoadInteger(HASH_TIMER, key, 3);
                    rRetry  = LoadInteger(HASH_TIMER, key, 4);
                    rp      = LoadPlayerHandle(HASH_TIMER, key, 5);
                    rTr     = LoadTriggerHandle(HASH_TIMER, key, 6);

                    rBase = rPid * MALLITEM_MAX_ITEMS;
                    serverCount = DzAPI_Map_GetMallItemCount(rp, mallItem.itemKeys[rIdx]);

                    if (serverCount <= rTarget || rRetry <= 0) {
                        // 以服务器结果为准刷新缓存
                        mallItem.uses[rBase + rIdx] = serverCount;
                        hasOwn = DzAPI_Map_HasMallItem(rp, mallItem.itemKeys[rIdx]);
                        if (serverCount <= 0) {
                            mallItem.owns[rBase + rIdx] = false;
                        } else {
                            mallItem.owns[rBase + rIdx] = hasOwn;
                        }

                        // 执行回调（保证此时读取到的是服务器已回写的次数）
                        if (rTr != null) {
                            mallItem.callbackPlayer = rp;
                            TriggerEvaluate(rTr);
                            DestroyTrigger(rTr);
                            mallItem.callbackPlayer = null;
                        }

                        // 清理
                        FlushChildHashtable(HASH_TIMER, key);
                        PauseTimer(tt);
                        DestroyTimer(tt);

                        // 置空句柄
                        rTr = null; rp = null; tt = null;
                    } else {
                        // 重试计数 -1，等待下一个周期
                        rRetry = rRetry - 1;
                        SaveInteger(HASH_TIMER, key, 4, rRetry);
                    }
                });

                // handler 置空
                cbTr = null; t = null;
            }
            return ok;
        }

        // 消费一次性道具（UseConsumablesItem）：无回调
        static method consumeOnce(player whichPlayer, string itemKey) {
            integer pid; integer idx; integer base;

            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return ; }
            idx = mallItem.getIndex(itemKey);
            if (idx < 0) { return ; }

            // 执行消费(无回调)
            DzAPI_Map_UseConsumablesItem(whichPlayer, itemKey);
        }

        // ========== 元信息写接口 ==========
        static method setName(string key, string name) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.names[idx] = name;
        }

        static method setIcon(string key, string iconPath) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.icons[idx] = iconPath;
        }

        static method setDesc(string key, string desc) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.descs[idx] = desc;
        }

        static method setTech(string key, integer techId) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.techs[idx] = techId;
        }

        static method setMeta(string key, string name, string iconPath, string desc) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.names[idx] = name;
            mallItem.icons[idx] = iconPath;
            mallItem.descs[idx] = desc;
        }

        static method setMetaWithTech(string key, string name, string iconPath, string desc, integer techId) {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return; }
            mallItem.names[idx] = name;
            mallItem.icons[idx] = iconPath;
            mallItem.descs[idx] = desc;
            mallItem.techs[idx] = techId;
        }

        // ========== 元信息读接口 ==========
        static method getName(string key) ->string {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return ""; }
            return mallItem.names[idx];
        }

        static method getIcon(string key) ->string {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return ""; }
            return mallItem.icons[idx];
        }

        static method getDesc(string key) ->string {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return ""; }
            return mallItem.descs[idx];
        }

        static method getTech(string key) ->integer {
            integer idx;
            idx = mallItem.getIndex(key);
            if (idx < 0) { return 0; }
            return mallItem.techs[idx];
        }

        // 在 consumeTimes 回调中获取触发的玩家
        static method getCallbackPlayer() ->player {
            return mallItem.callbackPlayer;
        }

        static method hasItemKey(string key) ->boolean {
            return mallItem.getIndex(key) >= 0;
        }

        static method getAllItemKeys() ->string {
            integer i; string out; integer n;
            n = mallItem.itemCount;
            out = "";
            i = 0;
            while (i < n) {
                if (i == 0) {
                    out = mallItem.itemKeys[i];
                } else {
                    out = out + "," + mallItem.itemKeys[i];
                }
                i = i + 1;
            }
            return out;
        }

        // 根据索引获取商品 key（1-based 外部语义：1 表示第一个）
        static method getItemKeyByIndex(integer oneBasedIndex) ->string {
            integer idx;
            idx = oneBasedIndex - 1;
            if (idx < 0 || idx >= mallItem.itemCount) { return ""; }
            return mallItem.itemKeys[idx];
        }

        // 获取已登记商品数量
        static method getItemCount() ->integer {
            return mallItem.itemCount;
        }

        // 查询指定玩家和商品key的当前消耗次数
        static method getConsumeCountByPlayer(player whichPlayer, string itemKey) ->integer {
            integer pid; integer idx; integer base;

            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) {
                return 0;
            }

            idx = mallItem.getIndex(itemKey);
            if (idx < 0) {
                return 0;
            }

            base = pid * MALLITEM_MAX_ITEMS;
            return mallItem.uses[base + idx];
        }

    }
}
//! endzinc

#endif

