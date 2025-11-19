#ifndef AbilityConstantIncluded
#define AbilityConstantIncluded

// 子键盐值（在复合哈希上加盐，避免同一键位存多值冲突）
#define HASH_CHILD_SALT_ICON           1001
#define HASH_CHILD_SALT_GLOW           1002
#define HASH_CHILD_SALT_CORNER         1003

// 能力冷却（AbilityCool）使用的子键：保存逻辑剩余冷却时间（real，单位：秒）
#define HASH_CHILD_SALT_ABILITY_COOLDOWN  1004

#endif


