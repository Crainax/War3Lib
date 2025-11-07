#ifndef AbilityConstantIncluded
#define AbilityConstantIncluded

#define HASH_KEY_ABILITY_ICON         4101  // 装饰:图标路径
#define HASH_KEY_ABILITY_GLOW         4102  // 装饰:图标流光
#define HASH_KEY_ABILITY_CORNER_TEXT  4103  // 装饰:角落文字

// 统一的父键（固定不变，用于能力装饰的所有存取）
#define HASH_PARENT_ABILITY_DECORATE   91400321

// 子键盐值（在复合哈希上加盐，避免同一键位存多值冲突）
#define HASH_CHILD_SALT_ICON           1001
#define HASH_CHILD_SALT_GLOW           1002
#define HASH_CHILD_SALT_CORNER         1003

#endif


