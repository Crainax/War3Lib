#ifndef AbilityConstantIncluded
#define AbilityConstantIncluded

// 子键盐值（在复合哈希上加盐，避免同一键位存多值冲突）
#define HASH_CHILD_SALT_ICON           1001
#define HASH_CHILD_SALT_GLOW           1002
#define HASH_CHILD_SALT_CORNER         1003
#define HASH_CHILD_SALT_SHADOW         1006
#define HASH_CHILD_SALT_TOP_RIGHT      1007
#define HASH_CHILD_SALT_TOP_RIGHT_SIZE 1008

// 能力冷却（AbilityCool）使用的子键：保存逻辑剩余冷却时间（real，单位：秒）
#define HASH_CHILD_SALT_ABILITY_COOLDOWN  1004

// 技能范围冷却（SpellBase）使用的子键：保存范围扩展冷却时间（real，单位：秒）
#define HASH_CHILD_SALT_SPELL_RANGE_COOLDOWN  1005


// 冷却倍率（CoolRate）使用的子键：保存持久倍率、下一次施法覆盖冷却、下一次施法倍率
#define HASH_CHILD_SALT_COOL_PERSIST_MUL    2001  // 持久倍率（长期生效）
#define HASH_CHILD_SALT_COOL_NEXT_OVERRIDE 2002  // 下一次施法覆盖冷却（一次性）
#define HASH_CHILD_SALT_COOL_NEXT_MUL      2003  // 下一次施法倍率（一次性）

// 技能属性（SpellUtils）使用的子键：保存单位 + 技能维度的加成与已应用快照
#define HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_UP      3001
#define HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_DOWN    3002
#define HASH_CHILD_SALT_SPELL_RANGE_UP             3003
#define HASH_CHILD_SALT_SPELL_RANGE_DOWN           3004
#define HASH_CHILD_SALT_SPELL_PASSIVE_RATE         3005
#define HASH_CHILD_SALT_SPELL_PASSIVE_APPLIED_RATE 3006
#define HASH_CHILD_SALT_SPELL_FINAL_DAMAGE_STRING_ID 3007
#define HASH_CHILD_SALT_SPELL_RANGE_STRING_ID        3008
#define HASH_CHILD_SALT_SPELL_PASSIVE_STRING_ID      3009

// 技能额外属性自定义字符串（AbilityDecorateData）：3101..3200 专用于最多 100 条 string 内容
#define HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_TEXT_BASE 3100
#define HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_ID_BASE   3200
#define HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_COUNT     3301
#define HASH_CHILD_SALT_ABILITY_CUSTOM_STRING_NEXT_ID   3302

#endif
