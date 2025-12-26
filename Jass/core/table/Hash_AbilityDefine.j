#ifndef AbilityConstantIncluded
#define AbilityConstantIncluded

// 子键盐值（在复合哈希上加盐，避免同一键位存多值冲突）
#define HASH_CHILD_SALT_ICON           1001
#define HASH_CHILD_SALT_GLOW           1002
#define HASH_CHILD_SALT_CORNER         1003

// 能力冷却（AbilityCool）使用的子键：保存逻辑剩余冷却时间（real，单位：秒）
#define HASH_CHILD_SALT_ABILITY_COOLDOWN  1004

// 技能范围冷却（SpellBase）使用的子键：保存范围扩展冷却时间（real，单位：秒）
#define HASH_CHILD_SALT_SPELL_RANGE_COOLDOWN  1005


// 冷却倍率（CoolRate）使用的子键：保存持久倍率、下一次施法覆盖冷却、下一次施法倍率
#define HASH_CHILD_SALT_COOL_PERSIST_MUL    2001  // 持久倍率（长期生效）
#define HASH_CHILD_SALT_COOL_NEXT_OVERRIDE 2002  // 下一次施法覆盖冷却（一次性）
#define HASH_CHILD_SALT_COOL_NEXT_MUL      2003  // 下一次施法倍率（一次性）

#endif


