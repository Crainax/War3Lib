// 常量配置
#define MALLITEM_MAX_ITEMS      300
#define MALLITEM_INIT_DELAY     2.0

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

        // 数据表
        private static hashtable table = null; // key 映射与临时使用

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
            integer stored; integer idx;
            stored = LoadInteger(mallItem.table, 0, StringHash(key));
            if (stored == 0) {
                return -1;
            }
            idx = stored - 1; // 存储时 +1，读取时 -1
            if (idx < 0 || idx >= mallItem.itemCount) { return -1; }
            return idx;
        }

        private static method setIndex(string key, integer index) {
            SaveInteger(mallItem.table, 0, StringHash(key), index + 1);
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
            // 无句柄局部变量

            mallItem.initialized = false;
            mallItem.ready = false;
            mallItem.itemCount = 0;
            mallItem.table = InitHashtable();
            mallItem.readyTrigger = CreateTrigger();
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

        // 消费次数型道具（带回调）：成功消费后调用回调并传入玩家参数
        static method consumeTimes(player whichPlayer, string itemKey, integer count, code callback) ->boolean {
            integer pid; integer idx; integer base; boolean ok; trigger tempTr;

            pid = GetPlayerId(whichPlayer);
            if (pid < 0 || pid >= MAX_PLAYER_COUNT) { return false; }
            idx = mallItem.getIndex(itemKey);
            if (idx < 0) { return false; }

            // 执行消费
            ok = DzAPI_Map_ConsumeMallItem(whichPlayer, itemKey, count);
            if (ok) {
                base = pid * MALLITEM_MAX_ITEMS;
                // 刷新该玩家该商品缓存
                mallItem.owns[base + idx] = DzAPI_Map_HasMallItem(whichPlayer, itemKey);
                mallItem.uses[base + idx] = DzAPI_Map_GetMallItemCount(whichPlayer, itemKey);

                // 如果使用次数小于等于0，则认为该玩家没有这个道具了
                if (mallItem.uses[base + idx] <= 0) {
                    mallItem.owns[base + idx] = false;
                }

                // 调用回调（传入玩家参数）
                if (callback != null) {
                    mallItem.callbackPlayer = whichPlayer;
                    tempTr = CreateTrigger();
                    TriggerAddCondition(tempTr, Condition(callback));
                    TriggerEvaluate(tempTr);
                    DestroyTrigger(tempTr);
                    mallItem.callbackPlayer = null;
                    tempTr = null;
                }
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

    }
}
//! endzinc


