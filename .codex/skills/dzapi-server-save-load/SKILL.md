---
name: dzapi-server-save-load
description: War3/KK DzAPI 服务器存档读写规范。用于在 JASS/Zinc 中新增或重构服务器存档功能时，严格使用 DzAPI_Map_SaveServerValue、DzAPI_Map_GetServerValue、DzAPI_Map_StoreInteger、DzAPI_Map_GetStoredInteger、DzAPI_Map_StoreString、DzAPI_Map_GetStoredString，并遵循开局一次读取+内存缓存、63 位字符串限制、存档 Key 宏常量、位串拼装与可选 UID 加盐校验策略。
---

# DzAPI 服务器存档读写规范

## 执行入口

- 先读 `references/api-contract.md`，确认 API 语义、前缀规则、长度上限、错误码。
- 再读 `references/patterns-and-snippets.md`，直接复用初始化缓存、写回、位串拼装、可选校验模板。
- 仅在用户明确要求“加密/校验/防篡改”时启用校验模板；默认不加密。

## 强制规则

- 在文件头先声明本模块全部存档位宏常量（Key、版本号、上限值、节流参数）。
- 默认使用 `DzAPI_Map_StoreInteger/GetStoredInteger` 与 `DzAPI_Map_StoreString/GetStoredString`；仅在确实需要自定义前缀或原始存取时使用 `SaveServerValue/GetServerValue`。
- 只在开局初始化阶段执行 `GetStored*` 读取；局中逻辑只读内存缓存，不依赖再次 `GetStored*` 获取“最新值”。
- 每次存档写入都先更新内存缓存，再调用 `Store*` 写回（write-through）。
- 字符串 Key 与 Value 一律按 `<=63` 设计；接近上限时优先拆分或压缩，不赌平台边界。
- 涉及位判断存档时优先使用 `IsSuperBit/SetSuperBit` 方案，保持 60 位数字串模板一致。
- 涉及设置项紧凑存档时，使用“版本前缀 + 单字符位”拼接法，解析时做长度与版本校验。

## 标准流程

1. 在模块头定义宏常量（存档 Key、版本、上下限）。
2. 在开局延迟回调（如 0.1~0.3 秒）统一读取玩家存档到缓存数组。
3. 业务逻辑只改缓存，并在需要落盘时调用 `Store*`。
4. 对字符串型存档做长度保护与格式保护（版本前缀、字符合法性）。
5. 若启用防篡改：写入时编码+签名，读取时验签失败即回退默认值。

## 生成代码要求

- 保持 Zinc/JASS 可直接粘贴风格，不引入与任务无关依赖。
- 新增存档位时必须先补齐头部宏常量，再写读写逻辑。
- 写法优先简洁可审计：少魔法数，多命名常量。
- 对后端防刷规则（每局上限、每日上限、只增、时间窗）预留常量和注释位，避免硬编码散落。

## 参考

- `references/api-contract.md`
- `references/patterns-and-snippets.md`
