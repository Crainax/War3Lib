---
name: dzapi-server-save-load
description: War3/KK DzAPI 服务器存档读写与防刷设计规范。用于在 JASS/Zinc 中新增或重构服务器存档、每英雄/每角色成长经验、多 Key 共享每日/每局限制、只增存档、版本阶段封顶与未来扩展时，严格使用 DzAPI_Map_SaveServerValue、DzAPI_Map_GetServerValue、DzAPI_Map_StoreInteger、DzAPI_Map_GetStoredInteger、DzAPI_Map_StoreString、DzAPI_Map_GetStoredString，并遵循开局一次读取+内存缓存、63 位字符串限制、短 Key、存档 Key 宏常量、位串拼装与可选 UID 加盐校验策略。
---

# DzAPI 服务器存档读写规范

## 执行入口

- 先读 `references/api-contract.md`，确认 API 语义、前缀规则、长度上限、错误码。
- 再读 `references/patterns-and-snippets.md`，直接复用初始化缓存、写回、位串拼装、可选校验模板。
- 设计“多个角色各自积累经验、但共享每局/每日上限”时，再读 `references/multi-entity-progression.md`。
- 仅在用户明确要求“加密/校验/防篡改”时启用校验模板；默认不加密。

## 强制规则

- 在文件头先声明本模块全部存档位宏常量（Key、版本号、上限值、节流参数）。
- 默认使用 `DzAPI_Map_StoreInteger/GetStoredInteger` 与 `DzAPI_Map_StoreString/GetStoredString`；仅在确实需要自定义前缀或原始存取时使用 `SaveServerValue/GetServerValue`。
- 只在开局初始化阶段执行 `GetStored*` 读取；局中逻辑只读内存缓存，不依赖再次 `GetStored*` 获取“最新值”。
- 服务器读档不是本地异步数据：初始化时，各客户端读取任意本局玩家的 `GetStored*` 开局快照，都会得到相同结果。因此应由所有客户端按相同玩家顺序直接读取并写入同步变量缓存；不得把读档包装成 `SyncBus`/发包收包流程，也不得只让存档所属玩家本地读取后再广播。
- 不要因“DzAPI 是平台接口”就推断读档会 OOS。只要读取时机、玩家遍历和后续分支保持一致，直接读取缓存是同步安全的；Xlimon 的成熟基线是 `edit/DzServer.j` 和 `edit/system/achieve/AchiUpgrade.j` 的 `ReadAchiCapArchives()`（开局约 0.1 秒读取快照）。
- 安全边界：同步包中的存档值属于玩家客户端可伪造的输入，不能作为权威读档来源。防作弊应依赖平台返回的服务器存档、防刷规则与必要校验，而不是让客户端把“读到的存档”重新发包给全局。
- `GetStoredInteger/GetStoredString` 在同一局内按开局快照返回；即使局中 `Store*` 成功、失败、被后端上限拒绝或写入不同值，再次 `GetStored*` 也仍可能返回开局值，禁止用它确认局中写入结果。
- 每次存档写入都先更新内存缓存，再调用 `Store*` 写回（write-through）。
- 遇到后端每日/每局上限、只增、频率限制等不确定写入结果时，区分“开局可消费存量”和“局中新获得增量”：本局消费只用开局存量，局中增量只展示并写回尝试，下局读取后再参与消费。
- 字符串 Key 与 Value 一律按 `<=63` 设计；接近上限时优先拆分或压缩，不赌平台边界。
- 涉及位判断存档时优先使用 `IsSuperBit/SetSuperBit` 方案，保持 60 位数字串模板一致。
- 涉及设置项紧凑存档时，使用“版本前缀 + 单字符位”拼接法，解析时做长度与版本校验。
- 多实体成长值需要保护“总获取量”、但允许在既有总量内重新分配时，优先采用“每实体非只增整数 Key + 一个只增总获取 Key”：每个实体 Key 配单 Key 每局/每日限制，总获取 Key 配相同限制；正常奖励使用批量接口同时增加当前实体和总获取 Key。
- 开局仅在全部关键 Key 读取成功后校验 `sum(entityXp) <= totalEarnedXp`；超额部分按确定性规则从当前最高经验实体开始扣回。负值按 0 参与业务计算并标记异常；阶段上限以上的实体值可向下修正，降低不会返还后端周期额度。
- 实测“多个 KEY 逻辑”的加法公式只看组合净变化，会接受批量降一项、升另一项以及负数抵消；禁止把它作为非只增实体 Key 的总量安全边界。
- `KKApiGetServerValueLimitLeft` 对实际后端 Key（整数 Key 含自动 `I` 前缀）可返回剩余额度，但同局写入后仍是开局快照；需要局中显示时自行扣减内存额度，最终以下一局后端快照为准。
- 后端没有绝对最大值时：若实体 Key 采用非只增方案，可在开局把超过当前阶段上限的值向下修正；只增总获取 Key 不作为可消费经验，只作为累计授权总量，因此其历史高值不得直接转化为任一实体经验。

## Xlimon 项目兼容例外（老写法白名单）

- 默认仍遵循“开局一次读取 + 内存缓存”；以下仅在用户明确指定该模块可走老写法时启用。
- 允许在 `edit/DzServer.j` 的 `dzServerCallback.registerCallback` 回调里做一次性初始化，然后再在业务模块使用该值。
- 典型场景：依赖无尽积分展示值（如 `IEndlessJifenShow`，口头也常叫 `Iwujinjifen`）的逻辑，需要等 `DzServer` 读档并 `FlashEndlessJifen` 后再取值。
- 该例外仅限“初始化阶段的一次回调”，禁止在局中高频逻辑中反复调用 `GetStored*` 直读服务器存档。
- 若新功能可改为标准缓存流，优先改为标准流；仅为兼容历史模块（如指定的 `edit/ability/base/LearnAbility.j` 场景）保留此入口。

## 标准流程

1. 在模块头定义宏常量（存档 Key、版本、上下限）。
2. 在所有客户端都会一致执行的开局延迟回调（如 0.1~0.3 秒）中，按固定顺序遍历玩家，直接读取每名玩家的服务器存档到同步缓存数组；不要使用 `GetLocalPlayer`，也不要发包同步读档结果。
3. 业务逻辑只改缓存，并在需要落盘时调用 `Store*`。
4. 对字符串型存档做长度保护与格式保护（版本前缀、字符合法性）。
5. 若启用防篡改：写入时编码+签名，读取时验签失败即回退默认值。

## 生成代码要求

- 保持 Zinc/JASS 可直接粘贴风格，不引入与任务无关依赖。
- 新增存档位时必须先补齐头部宏常量，再写读写逻辑。
- 写法优先简洁可审计：少魔法数，多命名常量。
- 对后端防刷规则（每局上限、每日上限、只增、时间窗）预留常量和注释位，避免硬编码散落。
- 只有本地 UI 点击、键鼠输入等真正的本地异步事件在需要修改同步游戏状态时才走同步包；服务器存档初始化读取不属于此类事件。

## 参考

- `references/api-contract.md`
- `references/patterns-and-snippets.md`
- `references/multi-entity-progression.md`
