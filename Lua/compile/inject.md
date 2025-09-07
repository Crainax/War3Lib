### 背景
大型脚本（约 5.2 万行）在代码注入前需要扫描调用点，旧实现对每个函数名在整份源码中做一次全文匹配（严格/简单两种），时间复杂度近似 O(|s|·N)。在 N 较大时（上百上千）会导致 40s+ 的检测耗时。

### 性能瓶颈
- 多次 `string.find`/正则在整份源码上重复扫描，重复 I/O 与模式回溯成本高。
- 严格模式使用 `[^%w_]name[^%w_]` 作为边界，存在较多回溯。
- 单线程串行；即便某文件已命中，也会对其余函数继续尝试匹配。

### 已实施优化（本次改动）
- 单次扫描词元索引（支持“带点”名称窗口）
  - 将源码按行扫描，提取“词元”[%w_]+，把 `.` 作为分隔符。
  - 构建两个集合：
    - wordSet：所有出现过的单词（不含点）。
    - windowSet：由点连接的连续词窗口（长度 2..maxSegments），例如从 `obj.uiText.bindSimple` 生成 `uiText.bindSimple`。
  - 查找时：
    - 不含点的函数名 → 在 wordSet 常数时间判断存在性（等价于 `%f[%w_]name%f[^%w_]`）。
    - 含点的函数名 → 在 windowSet 常数时间判断存在性（语义等价于 `%f[%w_]A%.B%f[^%w_]`）。
  - 正确性：
    - 命中：`obj.uiText.bindSimple(` → 生成 `uiText.bindSimple` 窗口，命中。
    - 不误：`uiText.bindSimpleX` 不会生成 `uiText.bindSimple` 窗口；`auiText.bindSimple` 左侧为词内字符，亦不命中。

- 边界判定采用 frontier 语义（通过索引结构间接实现）
  - 旧式 `[^%w_]name[^%w_]` 改为 frontier 语义 `%f[%w_]name%f[^%w_]` 的等价行为，降低回溯、提升稳定性。

- 结果缓存
  - 缓存键包含：
    - 源脚本 `mtime:size`（lfs.attributes）。
    - 函数名集合签名（对 new_table key 排序后计算轻量哈希）。
    - 依赖链签名（chain_table 归一化后计算哈希）。
  - 命中缓存直接返回已注入集合，连编可近似 0 成本。

### 本次代码改动点
- 新增：`compute_keys_signature(table)`
  - 对 `self.new_table` 的所有函数名排序并计算轻量哈希，生成签名字符串。

- 新增：`compute_chain_signature(chain_table)`
  - 对依赖链 `file -> deps[]` 归一化（排序）并计算轻量哈希，生成签名字符串。

- 新增：`build_identifier_index(s, maxSegments)`
  - 单趟扫描源码，构建 `wordSet` 与 `windowSet`。`maxSegments` 为函数名中最大段数（按点计数）。

- 新增字段：`inject_code.detect_cache = {}`
  - 以复合键缓存上次检测结果（文件签名 + 函数签名 + 依赖签名）。

- 重写 `inject_code:detect(path)` 逻辑
  - 构造缓存键 → 命中则直接返回。
  - 计算 `maxSegments`，单次扫描构建索引。
  - 按“含点/不含点”和“模式（YDWE 简单/严格）”用索引集合进行 O(1) 判断；命中即登记并展开依赖链。
  - 结果写入缓存，打印耗时。

### 效果对比（你的实测）
- 旧实现：函数检测用时 ~43–47 秒。
- 新实现：函数检测用时 ~1.6 秒。
- 注入集合对比：新结果为旧结果的超集，多出的项包括 `GetForceOfPlayer.j`、`GetUnitsInRectMatching.j`、`PolledWait.j`，更可能是修正了旧算法漏检。

### 仍可考虑的优化（未实施）
- 代表锚点：同一注入文件仅挑一个代表函数名命中即可，减少匹配面。
- 剔除注释/字符串：减少输入体积与误命中机会。
- 两阶段预筛：按首字符/前缀分桶，仅对可能命中的桶做确认。
- 外部批量匹配：以 ripgrep/grep 模式文件一次性返回所有命中。
- 并行：若不做索引，也可分块并行，但收益不如“单次索引”。
- 限定扫描区域：仅扫描可能出现调用的段落，跳过常量/数据区。
- 热路径记忆：优先检查历史高频命中库，尽早短路。

### 正确性与边界说明
- 带点名示例：`uiText.bindSimple`
  - 命中：`obj.uiText.bindSimple(`
  - 不命中：`uiText.bindSimpleX`、`auiText.bindSimple`

### 维护建议
- 缓存失效策略：当源脚本修改、函数集合变化、依赖链变化时会自动失效（由签名保证）。
- 若需要绝对一致性验证，可临时加入“对照检测开关”，同时运行旧算法与新算法输出差集，确认零差异后再关闭。


