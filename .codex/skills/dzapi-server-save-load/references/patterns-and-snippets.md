# 存档模式与代码片段

## 目录

- 1. 开局一次读取 + 内存缓存（强制）
- 2. 写回策略（write-through）
- 3. 60 位数字串位图方案（IsSuperBit / SetSuperBit）
- 4. 设置项紧凑串方案（版本前缀 + 单字符位）
- 5. 可选防篡改方案（仅在明确要求时启用）

## 1) 开局一次读取 + 内存缓存（强制）

```jass
#define SIGN_TOTAL_DAYS       7
#define SIGN_KEY_DAY          "SIGN_DAY"
#define SIGN_KEY_LAST_DAY_ID  "SIGN_LAST_DAY_ID"

//! zinc
library SignArchive {
    public struct signData [] {
        private static integer claimedDay[];
        private static integer lastDayId[];

        public static method getBeijingDayId() -> integer {
            integer t;
            t = DzAPI_Map_GetGameStartTime();
            return (t + 28800) / 86400;
        }

        public static method refreshPlayer(player p) {
            integer pid;
            integer d;
            pid = GetConvertedPlayerId(p);
            if (pid < 1 || pid > MAX_PLAYER_COUNT) { return; }

            d = DzAPI_Map_GetStoredInteger(p, SIGN_KEY_DAY);
            if (d < 0) { d = 0; }
            if (d > SIGN_TOTAL_DAYS) { d = SIGN_TOTAL_DAYS; }

            claimedDay[pid] = d;
            lastDayId[pid] = DzAPI_Map_GetStoredInteger(p, SIGN_KEY_LAST_DAY_ID);
        }

        static method onInit() {
            trigger tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr, 0.3);
            TriggerAddCondition(tr, Condition(function (){
                integer i;
                for (1 <= i <= MAX_PLAYER_COUNT) {
                    if (GetPlayerSlotState(ConvertedPlayer(i)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(ConvertedPlayer(i)) == MAP_CONTROL_USER) {
                        thistype.refreshPlayer(ConvertedPlayer(i));
                    }
                }
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;
        }
    }
}
//! endzinc
```

规则：
- 局中不要依赖重复 `GetStored*` 来读取“最新值”。
- 所有判断逻辑依赖缓存变量。

## 2) 写回策略（write-through）

```jass
public static method canClaim(player p) -> boolean {
    integer pid = GetConvertedPlayerId(p);
    integer nowId = thistype.getBeijingDayId();

    if (claimedDay[pid] >= SIGN_TOTAL_DAYS) { return false; }
    return nowId > lastDayId[pid];
}

public static method claim(player p) -> boolean {
    integer pid = GetConvertedPlayerId(p);
    integer nowId = thistype.getBeijingDayId();

    if (!thistype.canClaim(p)) { return false; }

    // 先改缓存
    claimedDay[pid] = claimedDay[pid] + 1;
    lastDayId[pid] = nowId;

    // 再写服务器
    DzAPI_Map_StoreInteger(p, SIGN_KEY_DAY, claimedDay[pid]);
    DzAPI_Map_StoreInteger(p, SIGN_KEY_LAST_DAY_ID, lastDayId[pid]);

    return true;
}
```

规则：
- 先内存、后落盘，顺序固定。
- 上限（例如“每日仅 +1”）由后端控制，前端保留同名宏注释。

## 3) 60 位数字串位图方案（IsSuperBit / SetSuperBit）

位串基础函数（可直接复用）：

```jass
public function IsSuperBit ( string s, integer bit ) -> boolean {
    integer iGroup = (bit - 1)/31 + 1;
    integer iBit = ModuloInteger((bit-1),31) + 1;
    integer resultInt = 0;

    if (bit <= 0 || bit > 186) {return false;}
    resultInt = S2I(SubStringBJ(s,iGroup * 10 - 9,iGroup * 10));
    return I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) > 0;
}

public function SetSuperBit ( string s,integer bit,boolean b ) -> string {
    integer iGroup = (bit - 1)/31 + 1;
    integer iBit = ModuloInteger((bit-1),31) + 1;
    integer resultInt = 0;
    string result = s;

    if (StringLength(s) < 60) {result = "000000000000000000000000000000000000000000000000000000000000";}
    if (bit <= 0 || bit > 186) {return result;}

    resultInt = S2I(SubStringBJ(result,iGroup * 10 - 9,iGroup * 10));
    if (b) {
        if (I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) > 0) {
            return result;
        } else {
            resultInt = resultInt + R2I(Pow(2,iBit-1));
        }
    } else {
        if (I3(iBit == 31,resultInt,ModuloInteger(resultInt,R2I(Pow(2,iBit))))/R2I(Pow(2,iBit-1)) == 0) {
            return result;
        } else {
            resultInt = resultInt - R2I(Pow(2,iBit-1));
        }
    }

    return SubStringBJ(result,1,iGroup * 10 - 10) + IMendS(resultInt,10) + SubStringBJ(result,iGroup * 10+1,StringLength(result));
}
```

用法模板：

```jass
#define ARK_KEY_ACHI "SAchi"

//! zinc
library AchiArchive {
    string SAchi[];

    public function IsUnlocked(player p, integer pos) -> boolean {
        integer index = GetConvertedPlayerId(p);
        return IsSuperBit(SAchi[index], pos);
    }

    public function Unlock(player p, integer pos) {
        integer index = GetConvertedPlayerId(p);
        SAchi[index] = SetSuperBit(SAchi[index], pos, true);
        DzAPI_Map_StoreString(p, ARK_KEY_ACHI, SAchi[index]);
    }
}
//! endzinc
```

规则：
- 60 位串可覆盖 186 个 bit 位。
- 位操作前确保字符串已初始化为 60 位数字串。
- 若需要额外校验位（盐/签名），把校验位放在外层包装，不破坏 60 位主体。

## 4) 设置项紧凑串方案（版本前缀 + 单字符位）

```jass
#define SETTINGS_VERSION "S4"

public function BuildSettingString(player p) -> string {
    string s;
    integer i;
    integer v;

    s = SETTINGS_VERSION;
    for (i = 1; i <= GetPersistentCount(); i += 1) {
        v = GetSettingState(p, GetPersistentPosByIndex(i));
        if (v < 0) v = 0;
        if (v > 9) v = 9;
        s = s + I2S(v);
    }
    return s;
}

public function ApplySettingString(player p, string s) {
    integer n;
    integer i;
    integer v;
    string c;

    n = StringLength(s);
    if (n < 2) { return; }
    if (SubString(s, 0, 2) != SETTINGS_VERSION) { return; }

    for (i = 1; i <= GetPersistentCount(); i += 1) {
        if (2 + (i - 1) >= n) {
            v = 0;
        } else {
            c = SubString(s, 2 + (i - 1), 2 + i);
            v = S2I(c);
            if (v < 0) v = 0;
            if (v > 9) v = 9;
        }
        SetSettingState(p, GetPersistentPosByIndex(i), v);
    }
}
```

规则：
- 始终校验版本前缀，不匹配直接放弃读取。
- 每位都做限幅与非法兜底。

## 5) 可选防篡改方案（仅在明确要求时启用）

### 5.1 旧方案：盐值包头尾

```jass
public function IsArchiveValid(player p, string body, integer headDigit, integer tailDigit) -> boolean {
    integer salt = GetArchiveSalt(p);
    return salt == S2I(I2S(headDigit) + I2S(tailDigit));
}

public function WrapWithSalt(player p, string body) -> string {
    integer salt = GetArchiveSalt(p);
    return I2S(salt / 10) + body + I2S(ModuloInteger(salt, 10));
}
```

### 5.2 新方案：UID 加盐 + 校验尾巴

```jass
private function GetUIDForCipher(player p) -> string {
    string uid;
    integer pidStored;

    uid = KKApiPlayerGUID(p);
    if (uid == null || uid == "") {
        pidStored = DzAPI_Map_GetStoredInteger(p, "PID");
        if (pidStored > 0) { return I2S(pidStored); }
        return GetPlayerName(p);
    }
    return uid;
}

private function BuildChecksum(player p, string tag, integer a, integer b) -> integer {
    string uid = GetUIDForCipher(p);
    return ModuloInteger(IAbsBJ(StringHash(uid + "|" + tag + "|" + I2S(a) + "|" + I2S(b))), 36 * 36);
}
```

规则：
- 写入时编码，读取时必须验签；失败立即回退默认值。
- 不在普通、低价值存档上默认启用，避免无效复杂度。

