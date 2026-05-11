# DzAPI 存档契约与约束

## 1) 核心 API（必须掌握）

```jass
native DzAPI_Map_SaveServerValue takes player whichPlayer, string key, string value returns boolean
native DzAPI_Map_GetServerValue takes player whichPlayer, string key returns string

function DzAPI_Map_StoreInteger takes player whichPlayer, string key, integer value returns nothing
    set key="I"+key
    call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
    set key=null
    set whichPlayer=null
endfunction

function DzAPI_Map_GetStoredInteger takes player whichPlayer, string key returns integer
    local integer value
    set key="I"+key
    set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
    set key=null
    set whichPlayer=null
    return value
endfunction

function DzAPI_Map_StoreString takes player whichPlayer, string key, string value returns nothing
    set key="S"+key
    call DzAPI_Map_SaveServerValue(whichPlayer,key,value)
    set key=null
    set whichPlayer=null
endfunction

function DzAPI_Map_GetStoredString takes player whichPlayer, string key returns string
    return DzAPI_Map_GetServerValue(whichPlayer,"S"+key)
endfunction
```

要点：
- `StoreInteger/GetStoredInteger` 自动加 `I` 前缀。
- `StoreString/GetStoredString` 自动加 `S` 前缀。
- 若手写 `SaveServerValue/GetServerValue`，必须自行保证前缀一致。

## 2) 平台长度与频率约束

- `key`：按 `<=63` 设计。
- `value`：字符串按 `<=63` 设计。
- 写入受平台防刷配置控制：可能触发只增、每局上限、每日上限、频率限制。

实务规则：
- 永远把长度限制当做硬约束，不在边界值上赌博。
- 需要存更多数据时，优先压缩编码或拆分多个 Key。

## 3) 读取成功校验

```jass
native DzAPI_Map_GetServerValueErrorCode takes player whichPlayer returns integer

function GetPlayerServerValueSuccess takes player whichPlayer returns boolean
    if (DzAPI_Map_GetServerValueErrorCode(whichPlayer) == 0) then
        return true
    else
        return false
    endif
endfunction
```

建议：
- 开局初始化前先检查加载成功。
- 失败时走默认值，并提示玩家重开局。

## 4) 常见错误码（重点）

- `1190` 存档初始化加载失败
- `1191` 存档变量 Key 长度超限
- `1192` 存档数量超过上限
- `1757` 上传频率超限
- `1758` 超过每局最大值
- `1766` 只增存档不能被减少
- `1250/1266/1272/1273/1274` 防刷分相关限制
- `10322` Key 不在配置的白名单列表

## 5) 宏常量模板

```jass
#define ARK_KEY_SIGN_DAY           "SIGN_DAY"
#define ARK_KEY_SIGN_LAST_DAY_ID   "SIGN_LAST_DAY_ID"
#define ARK_KEY_SETTINGS           "SETTINGS"

#define ARK_TOTAL_DAYS             7
#define ARK_SETTINGS_VERSION       "S4"
#define ARK_MAX_TEXT_LEN           63
```

要求：
- 新增存档位先加宏，再写逻辑。
- 与后端约束相关的上限同样写成宏。

## 6) 来源

- KK 开发者文档（docsify 页面）
- DzAPI.j 的函数实现定义
