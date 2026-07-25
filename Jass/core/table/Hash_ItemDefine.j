#ifndef ItemConstantIncluded
#define ItemConstantIncluded

#define HASH_KEY_ITEM_ICON   4001  //装饰:图标路径
#define HASH_KEY_ITEM_GLOW   4002  //装饰:图标流光

#define HASH_KEY_ITEM_LEVEL   12934285      //装备的等级(异度上用)
#define ITEM_YUZAOQIAN 29311929             //玉藻的转换位(异度上用)
#define ITEM_SHENGJINGSHI 29311839          //圣晶石的转换位(异度上用)
#define ITEM_XIAOMAI_MYTH 29311840          //小埋的跳过判断装备属性用
#define HASH_KEY_CHEST_EXTRA_GOLD 29311841  //副本箱子的额外金钱
#define HASH_KEY_ITEM_COMBINE_SESSION 29311842 //合成会话标记（同会话排除材料）
#define HASH_KEY_ITEM_SHENGJINGSHI_APPLIED_RATE 29311843 // [异度] 圣晶石已应用效果倍率
#define HASH_KEY_ITEM_ACTIVE_ATTR_EQUIP_PLAYER 29311844  // [异度] 已生效属性装备队列玩家索引
#define HASH_KEY_ITEM_ACTIVE_ATTR_EQUIP_POS 29311845     // [异度] 已生效属性装备队列位置
#define HASH_KEY_ITEM_SHENGJINGSHI_OWNER 29311846        // [异度] 圣晶石所属玩家索引
#define HASH_KEY_ITEM_SHENGJINGSHI_LEVEL 29311847        // [异度] 圣晶石等级
#define HASH_KEY_ITEM_SHENGJINGSHI_ATTR 29311848         // [异度] 圣晶石属性类型
#define HASH_KEY_ITEM_EQUIT_ATTR_RATE 29311849          // [异度] 装备属性率
#define HASH_KEY_ITEM_EQUIT_ATTR_APPLIED_RATE 29311850  // [异度] 装备属性率已应用倍率
#define HASH_KEY_ITEM_SPELL_FINAL_DAMAGE_PERM 29311851  // [异度] 强化技能书永久技能最终伤害
#define HASH_KEY_ITEM_SPELL_RANGE_PERM 29311852         // [异度] 强化技能书永久技能范围
#define HASH_KEY_ITEM_SPELL_PASSIVE_PERM 29311853       // [异度] 强化技能书永久技能被动强化
#define HASH_KEY_ITEM_SPELL_FINAL_DAMAGE_BAYUNZI 29311854 // [异度] 八云紫临时技能最终伤害
#define HASH_KEY_ITEM_SPELL_RANGE_BAYUNZI 29311855      // [异度] 八云紫临时技能范围
#define HASH_KEY_ITEM_SPELL_PASSIVE_BAYUNZI 29311856    // [异度] 八云紫临时技能被动强化
#define HASH_KEY_ITEM_SPELL_BAYUNZI_TIMER 29311857      // [异度] 八云紫临时强化技能书过期计时器
#define HASH_KEY_ITEM_SPELL_BAYUNZI_START_SECOND 29311858 // [异度] 八云紫临时强化技能书创建时间
#define HASH_KEY_ITEM_NO_JIEJING_RETURN 29311859        // [异度] 装备分解/出售不返还结晶
#define HASH_KEY_ITEM_SOLE_CANDIDATE_LOCK_BASE 29311860 // [异度] 唯一装备候选lock基址（+1..8）
#define HASH_KEY_ITEM_SOLE_CANDIDATE_TRIGGER_BASE 29311870 // [异度] 唯一装备候选获得触发器基址（+1..8）
#define HASH_KEY_ITEM_SOLE_CANDIDATE_ACTION_BASE 29311880 // [异度] 唯一装备候选获得action基址（+1..8）
#define HASH_KEY_ITEM_TAOZHUANG_CANDIDATE_START 29311890 // [异度] 套装候选起始键
#define HASH_KEY_ITEM_TAOZHUANG_CANDIDATE_COUNT 29311891 // [异度] 套装候选件数
#define HASH_KEY_ITEM_TAOZHUANG_CANDIDATE_POS 29311892  // [异度] 套装候选位置
#define HASH_KEY_ITEM_TAOZHUANG_CANDIDATE_UNIT 29311893 // [异度] 套装候选所属单位
#define HASH_KEY_ITEM_STATE_EFFECT_ACTIVE_BASE 29311930 // [异度] 状态型装备效果生效标记基址（+状态槽1..99）
#define HASH_KEY_ITEM_STATE_EFFECT_LEVEL_BASE 29312030  // [异度] 状态型装备效果生效等级基址（+状态槽1..99）
#define HASH_KEY_ITEM_STATE_EFFECT_CLEAR_TRIGGER_BASE 29312130 // [异度] 状态型装备效果清理触发器基址（+状态槽1..99）
#define HASH_KEY_ITEM_ATTR_ADDED 29312240               // [异度] 装备属性已应用幂等标记
#define HASH_KEY_ITEM_EPIC_I30W_FINAL_RATE 29312241     // [异度] 神宫帽Alter已应用最终伤害
#define HASH_KEY_ITEM_EPIC_I30X_FINAL_RATE 29312242     // [异度] 森罗幽淀羽已应用最终伤害
#define HASH_KEY_ITEM_EPIC_I311_INT_APPLIED 29312243    // [异度] I311已应用智力
#define HASH_KEY_ITEM_EPIC_I31K_AGI_APPLIED 29312244    // [异度] I31K已应用敏捷
#define HASH_KEY_ITEM_I40_KILL_ATTR_APPLIED 29312245    // [异度] I40杀敌成长已应用属性
#define HASH_KEY_ITEM_I304_SPELL_CHARGE 29312246        // [异度] I304施法充能
#define HASH_KEY_ITEM_I408_AURA_COUNT 29312247          // [异度] I408已同步光环种类数
#define HASH_KEY_ITEM_I408_AURA_RATE_APPLIED 29312248   // [异度] I408光环状态已应用倍率
#define HASH_KEY_ITEM_I40C_FINAL_RATE_APPLIED 29312249  // [异度] I40C蔷薇终伤已应用倍率
#define HASH_KEY_ITEM_I40C_LAST_NO_KILL_SECOND 29312250 // [异度] I40C上次无击杀计时点
#define HASH_KEY_ITEM_I50O_DASH_BASE 29312251           // [异度] I50O独立冲刺实例起始键（+1..3）
#define HASH_KEY_ITEM_I50K_ENERGY_DECAY_REMAINING 29312252 // [异度] I50K能量衰减剩余时间
#define HASH_KEY_ITEM_I314_TALENT_MAX_APPLIED 29312253  // [异度] I314已发放天赋可学习上限
#define HASH_KEY_ITEM_HIDDEN_STORAGE 29312254           // [异度] 多重背包/挂起隐藏寄存标记
#define HASH_KEY_CHEST_SNAPSHOT_GOLD 29312255            // [异度] 副本宝箱结算时快照的最终金币
#define HASH_KEY_CHEST_SNAPSHOT_EXP 29312256             // [异度] 副本宝箱结算时快照的最终经验
#define HASH_KEY_CHEST_SNAPSHOT_BASE_GOLD 29312257       // [异度] 副本宝箱结算时快照的基础金币
#define HASH_KEY_CHEST_SNAPSHOT_BASE_EXP 29312258        // [异度] 副本宝箱结算时快照的基础经验

// [异度] 物品实例运行态
#define ITEM_SAVED_TRIGGER 2134              // 物品绑定触发器/计时器起始键
#define ITEM_SAVED_TRIGGER_ACTION 3134       // 物品绑定触发器 action 起始键
#define ITEM_SAVED_DASH 81734                // 物品绑定冲刺
#define ITEM_BINDING_EFFECT 3420934          // 物品绑定特效
#define ITEM_PROTECT 31921910                // 临时掉落保护所属玩家
#define HASH_KEY_ITEM_SUPERSHOP_TALENT_BOOK_SPELL 31921970 // 超级商店天赋技能书保存的技能ID
#define HASH_KEY_ITEM_CD 31921980           // 物品冷却中标记
#define HASH_KEY_ITEM_CD_QUEUE_INDEX 31921981 // 物品冷却队列下标
#define HASH_KEY_ITEM_CD_LEFT_TICKS 31921982  // 物品冷却剩余0.1秒刻度
#define ITEM_MOSHOU 92719456                 // 物品绑定的战斗宠物单位



#endif
