local lfs = require "lfs"
local fu = require "Lua.utils.FileUtils"
local ini = require "Lua.utils.Ini"
local path = require "Lua.path"

local localDzApi = {}

local DEFAULT_MODES = {
    VERSION_ALPHA = true,
    VERSION_BETA = true,
    VERSION_UNITTEST = true
}

local PLAYER_USER_NAME_MODES = {
    VERSION_ALPHA = true,
    VERSION_UNITTEST = true
}

local WORLD_EDIT_REG_KEY = [[HKCU\Software\Blizzard Entertainment\WorldEdit]]
local WORLD_EDIT_PLAYER_PROFILE_VALUE = "Test Map - Player Profile"

local function elapsedMs(startClock)
    return math.floor((os.clock() - startClock) * 1000 + 0.5)
end

local function formatElapsedSeconds(ms)
    return string.format("[用时%.2f秒]", (ms or 0) / 1000)
end

local function ensureDir(dir)
    if lfs.attributes(dir, "mode") == "directory" then
        return true
    end
    local parent = dir:match("(.+)/[^/]+$")
    if parent and lfs.attributes(parent, "mode") ~= "directory" then
        local ok, err = ensureDir(parent)
        if not ok then
            return false, err
        end
    end
    local ok, err = lfs.mkdir(dir)
    if ok or lfs.attributes(dir, "mode") == "directory" then
        return true
    end
    return false, err
end

local function readCurrentVersion()
    local content = fu.GetContent(path.rewave) or ""
    return content:match("#define%s+CURRENT_BUILD_VERSION%s+(VERSION_%w+)") or "VERSION_UNITTEST"
end

local function splitModes(value, defaultModes)
    if not value or value == "" then
        return defaultModes or DEFAULT_MODES
    end

    local modes = {}
    for item in tostring(value):gmatch("[^,%s]+") do
        modes[item] = true
    end
    return modes
end

local function boolEnabled(value)
    if value == nil or value == "" then
        return true
    end
    value = tostring(value):lower()
    return value == "1" or value == "true" or value == "yes" or value == "on"
end

local function jassBool(value, defaultValue)
    if value == nil or value == "" then
        value = defaultValue
    end
    value = tostring(value or ""):lower()
    if value == "1" or value == "true" or value == "yes" or value == "on" then
        return "true"
    end
    return "false"
end

local function jassString(value)
    value = tostring(value or "")
    value = value:gsub("\\", "\\\\")
    value = value:gsub('"', '\\"')
    return '"' .. value .. '"'
end

local function base64Encode(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local result = {}
    local index = 1
    local a
    local b
    local c
    local triple

    while index <= #data do
        a = data:byte(index) or 0
        b = data:byte(index + 1) or 0
        c = data:byte(index + 2) or 0
        triple = a * 65536 + b * 256 + c

        result[#result + 1] = alphabet:sub(math.floor(triple / 262144) % 64 + 1, math.floor(triple / 262144) % 64 + 1)
        result[#result + 1] = alphabet:sub(math.floor(triple / 4096) % 64 + 1, math.floor(triple / 4096) % 64 + 1)
        if index + 1 <= #data then
            result[#result + 1] = alphabet:sub(math.floor(triple / 64) % 64 + 1, math.floor(triple / 64) % 64 + 1)
        else
            result[#result + 1] = "="
        end
        if index + 2 <= #data then
            result[#result + 1] = alphabet:sub(triple % 64 + 1, triple % 64 + 1)
        else
            result[#result + 1] = "="
        end

        index = index + 3
    end

    return table.concat(result)
end

local function utf16LeBase64(value)
    local bytes = {}
    for i = 1, #value do
        bytes[#bytes + 1] = value:sub(i, i)
        bytes[#bytes + 1] = "\0"
    end
    return base64Encode(table.concat(bytes))
end

local function runPowerShell(script)
    script = "$ProgressPreference = 'SilentlyContinue'; " .. script
    local cmd = "powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand " .. utf16LeBase64(script)
    local handle = io.popen(cmd)
    local output

    if not handle then
        return nil, "无法执行powershell"
    end

    output = handle:read("*a") or ""
    handle:close()
    output = output:gsub("%s+$", "")
    return output
end

local function powershellCodePagePrefix()
    return "try { [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance) } catch {}; "
end

local function toRegistryPlayerProfileBase64(value)
    local inputBase64 = base64Encode(tostring(value or ""))
    local script = powershellCodePagePrefix()
        .. "$text = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('" .. inputBase64 .. "')); "
        .. "$regValue = [System.Text.Encoding]::GetEncoding(936).GetString([System.Text.Encoding]::UTF8.GetBytes($text)); "
        .. "[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($regValue))"
    local output = runPowerShell(script)

    if not output or output == "" then
        return nil, "无法转换PlayerName"
    end

    return output
end

local function readWorldEditPlayerProfileBase64()
    local script = "$path = 'HKCU:\\Software\\Blizzard Entertainment\\WorldEdit'; "
        .. "$name = 'Test Map - Player Profile'; "
        .. "$value = Get-ItemPropertyValue -Path $path -Name $name -ErrorAction SilentlyContinue; "
        .. "if ($null -ne $value) { [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([string]$value)) }"
    local output = runPowerShell(script)

    if not output or output == "" then
        return nil, "未找到注册表项"
    end

    return output
end

local function writeWorldEditPlayerProfile(value)
    local inputBase64 = base64Encode(tostring(value or ""))
    local script = powershellCodePagePrefix()
        .. "$path = 'HKCU:\\Software\\Blizzard Entertainment\\WorldEdit'; "
        .. "$name = 'Test Map - Player Profile'; "
        .. "$text = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('" .. inputBase64 .. "')); "
        .. "$regValue = [System.Text.Encoding]::GetEncoding(936).GetString([System.Text.Encoding]::UTF8.GetBytes($text)); "
        .. "New-Item -Path $path -Force | Out-Null; "
        .. "New-ItemProperty -Path $path -Name $name -PropertyType String -Value $regValue -Force | Out-Null"
    local output = runPowerShell(script)

    if output == nil then
        return false, "powershell执行失败"
    end

    return true
end

local function getConfiguredPlayerName(cfg)
    local section = cfg["PlayerName"] or {}
    return section["Name"] or section[WORLD_EDIT_PLAYER_PROFILE_VALUE] or section["Value"] or section["Default"]
end

local function syncWorldEditPlayerName(cfg)
    local section = cfg["PlayerName"] or {}
    local desired = getConfiguredPlayerName(cfg)
    local current
    local currentErr
    local err
    local ok

    if not boolEnabled(section["Enable"]) or desired == nil or desired == "" then
        return true, "跳过: 未配置[PlayerName]Name"
    end

    desired = tostring(desired)
    desiredProfileBase64, err = toRegistryPlayerProfileBase64(desired)
    if not desiredProfileBase64 then
        return false, err
    end

    current, currentErr = readWorldEditPlayerProfileBase64()
    if current == desiredProfileBase64 then
        return true, "已一致: " .. desired
    end

    ok, err = writeWorldEditPlayerProfile(desired)
    if not ok then
        return false, "写入失败: " .. tostring(err)
    end

    if current == nil then
        return true, "写入: " .. desired .. " (" .. tostring(currentErr) .. ")"
    end
    return true, "写入: " .. desired
end

local function writeLocalGameStartTime(timestamp)
    local content = fu.GetContent(path.localDzApiIni)
    if not content or content == "" then
        return true, false
    end

    local newline = content:find("\r\n", 1, true) and "\r\n" or "\n"
    local endsWithNewline = content:match("\r?\n$") ~= nil
    local normalized = content:gsub("\r\n", "\n")
    if normalized:sub(-1) ~= "\n" then
        normalized = normalized .. "\n"
    end

    local lines = {}
    local inLocalSection = false
    local changed = false

    for line in normalized:gmatch("(.-)\n") do
        local nextSection = line:match("^%s*%[([^%]]+)%]%s*$")
        if nextSection then
            inLocalSection = nextSection:match("^%s*(.-)%s*$") == "War3Lib.LocalDzApi"
        elseif inLocalSection and not line:match("^%s*[;#]") then
            local prefix, _, suffix = line:match("^([ \t]*DzAPI_Map_GetGameStartTime[ \t]*=[ \t]*)([^;#]*)(.*)$")
            if prefix then
                line = prefix .. tostring(timestamp) .. (suffix or "")
                changed = true
            end
        end
        lines[#lines + 1] = line
    end

    if not changed then
        return true, false
    end

    local output = table.concat(lines, newline)
    if endsWithNewline then
        output = output .. newline
    end
    local ok, err = fu.WriteOver(path.localDzApiIni, output)
    return ok, true, err
end

local function jassNonNegativeInteger(value, defaultValue)
    if value == nil or value == "" then
        value = defaultValue
    end
    value = tostring(value or ""):match("^%s*(%-?%d+)%s*$")
    if not value then
        value = tostring(defaultValue or "0")
    end

    value = tonumber(value) or 0
    if value < 0 then
        value = 0
    end
    return tostring(math.floor(value))
end

local function collectSectionKeys(section)
    local result = {}
    local seen = {}

    for key, _ in pairs(section or {}) do
        if key ~= "Default" and not seen[key] then
            seen[key] = true
            result[#result + 1] = key
        end
    end

    table.sort(result)
    return result
end

local function getPlayerUserNameIndex(key)
    local index = tostring(key or ""):match("^[Pp]?(%d+)$")
    index = tonumber(index)
    if not index or index < 1 or index > 24 then
        return nil
    end
    return math.floor(index)
end

local function collectPlayerUserNameIndexes(section)
    local result = {}
    local seen = {}

    for key, _ in pairs(section or {}) do
        local index = getPlayerUserNameIndex(key)
        if index and not seen[index] then
            seen[index] = true
            result[#result + 1] = index
        end
    end

    table.sort(result)
    return result
end

local function getPlayerUserNameValue(section, index)
    return section[tostring(index)] or section["P" .. tostring(index)] or section["p" .. tostring(index)]
end

local function isPlayerUserNameMockEnabled(version, section)
    local modes
    if not section then
        return false
    end

    modes = splitModes(section["Modes"], PLAYER_USER_NAME_MODES)
    return boolEnabled(section["Enable"]) and modes[version] == true
end

local function buildPlayerUserNameMockLines(section, localSection)
    local defaultValue = section["Default"] or localSection["PlayerUserNameDefault"] or ""
    local indexes = collectPlayerUserNameIndexes(section)
    local lines = {
        "library War3LibLocalDzApiPlayerUserName",
        "function War3Lib_LocalDzApiPlayerUserName_Get takes player whichPlayer returns string",
        "    local integer playerNo",
        "    if whichPlayer == null then",
        "        return " .. jassString(defaultValue),
        "    endif",
        "    set playerNo = GetPlayerId(whichPlayer) + 1"
    }

    for i, index in ipairs(indexes) do
        local prefix = i == 1 and "    if" or "    elseif"
        lines[#lines + 1] = prefix .. " playerNo == " .. tostring(index) .. " then"
        lines[#lines + 1] = "        return " .. jassString(getPlayerUserNameValue(section, index))
    end
    if #indexes > 0 then
        lines[#lines + 1] = "    endif"
    end
    lines[#lines + 1] = "    return " .. jassString(defaultValue)
    lines[#lines + 1] = "endfunction"
    lines[#lines + 1] = "endlibrary"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "#define DzAPI_Map_GetPlayerUserName(p) War3Lib_LocalDzApiPlayerUserName_Get(p)"

    return lines
end

local function appendMallItemHasFunction(lines, hasSection, defaultValue)
    local keys = collectSectionKeys(hasSection)

    lines[#lines + 1] = "private function War3Lib_LocalDzApiMallItem_InitialHas takes string itemKey returns boolean"
    for i, key in ipairs(keys) do
        local prefix = i == 1 and "    if" or "    elseif"
        lines[#lines + 1] = prefix .. " itemKey == " .. jassString(key) .. " then"
        lines[#lines + 1] = "        return " .. jassBool(hasSection[key], defaultValue)
    end
    if #keys > 0 then
        lines[#lines + 1] = "    endif"
    end
    lines[#lines + 1] = "    return " .. jassBool(defaultValue, "true")
    lines[#lines + 1] = "endfunction"
end

local function appendMallItemCountFunction(lines, countSection, defaultValue)
    local keys = collectSectionKeys(countSection)

    lines[#lines + 1] = "private function War3Lib_LocalDzApiMallItem_InitialCount takes string itemKey returns integer"
    for i, key in ipairs(keys) do
        local prefix = i == 1 and "    if" or "    elseif"
        lines[#lines + 1] = prefix .. " itemKey == " .. jassString(key) .. " then"
        lines[#lines + 1] = "        return " .. jassNonNegativeInteger(countSection[key], defaultValue)
    end
    if #keys > 0 then
        lines[#lines + 1] = "    endif"
    end
    lines[#lines + 1] = "    return " .. jassNonNegativeInteger(defaultValue, "100")
    lines[#lines + 1] = "endfunction"
end

local function buildMallItemMockLines(cfg, localSection)
    local hasSection = cfg["War3Lib.LocalDzApi.MallItemHas"] or {}
    local countSection = cfg["War3Lib.LocalDzApi.MallItemCount"] or {}
    local defaultHas = hasSection["Default"] or localSection["MallItemHasDefault"] or "true"
    local defaultCount = countSection["Default"] or localSection["MallItemCountDefault"] or "100"
    local lines = {
        "library War3LibLocalDzApiMallItem",
        "globals",
        "    private hashtable War3Lib_LocalDzApiMallItem_CountTable = InitHashtable()",
        "    private hashtable War3Lib_LocalDzApiMallItem_TimerTable = InitHashtable()",
        "endglobals",
        ""
    }

    appendMallItemHasFunction(lines, hasSection, defaultHas)
    lines[#lines + 1] = ""
    appendMallItemCountFunction(lines, countSection, defaultCount)

    local tail = {
        "",
        "private function War3Lib_LocalDzApiMallItem_Ensure takes player whichPlayer, string itemKey returns nothing",
        "    local integer parent = GetHandleId(whichPlayer)",
        "    local integer child = StringHash(itemKey)",
        "    if not HaveSavedInteger(War3Lib_LocalDzApiMallItem_CountTable, parent, child) then",
        "        call SaveInteger(War3Lib_LocalDzApiMallItem_CountTable, parent, child, War3Lib_LocalDzApiMallItem_InitialCount(itemKey))",
        "    endif",
        "endfunction",
        "",
        "function War3Lib_LocalDzApiMallItem_GetCount takes player whichPlayer, string itemKey returns integer",
        "    local integer parent",
        "    local integer child",
        "    if whichPlayer == null then",
        "        return 0",
        "    endif",
        "    call War3Lib_LocalDzApiMallItem_Ensure(whichPlayer, itemKey)",
        "    set parent = GetHandleId(whichPlayer)",
        "    set child = StringHash(itemKey)",
        "    return LoadInteger(War3Lib_LocalDzApiMallItem_CountTable, parent, child)",
        "endfunction",
        "",
        "function War3Lib_LocalDzApiMallItem_Has takes player whichPlayer, string itemKey returns boolean",
        "    if whichPlayer == null then",
        "        return false",
        "    endif",
        "    return War3Lib_LocalDzApiMallItem_InitialHas(itemKey) and War3Lib_LocalDzApiMallItem_GetCount(whichPlayer, itemKey) > 0",
        "endfunction",
        "",
        "private function War3Lib_LocalDzApiMallItem_ConsumeDelayed takes nothing returns nothing",
        "    local timer t = GetExpiredTimer()",
        "    local integer timerId = GetHandleId(t)",
        "    local player whichPlayer = LoadPlayerHandle(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 1)",
        "    local string itemKey = LoadStr(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 2)",
        "    local integer count = LoadInteger(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 3)",
        "    local integer parent = 0",
        "    local integer child = 0",
        "    local integer current = 0",
        "    if whichPlayer != null then",
        "        call War3Lib_LocalDzApiMallItem_Ensure(whichPlayer, itemKey)",
        "        set parent = GetHandleId(whichPlayer)",
        "        set child = StringHash(itemKey)",
        "        set current = LoadInteger(War3Lib_LocalDzApiMallItem_CountTable, parent, child) - count",
        "        if current < 0 then",
        "            set current = 0",
        "        endif",
        "        call SaveInteger(War3Lib_LocalDzApiMallItem_CountTable, parent, child, current)",
        "    endif",
        "    call FlushChildHashtable(War3Lib_LocalDzApiMallItem_TimerTable, timerId)",
        "    call PauseTimer(t)",
        "    call DestroyTimer(t)",
        "    set whichPlayer = null",
        "    set t = null",
        "endfunction",
        "",
        "function War3Lib_LocalDzApiMallItem_Consume takes player whichPlayer, string itemKey, integer count returns boolean",
        "    local timer t",
        "    local integer timerId",
        "    local integer current",
        "    if whichPlayer == null or count <= 0 then",
        "        return false",
        "    endif",
        "    if not War3Lib_LocalDzApiMallItem_InitialHas(itemKey) then",
        "        return false",
        "    endif",
        "    set current = War3Lib_LocalDzApiMallItem_GetCount(whichPlayer, itemKey)",
        "    if current < count then",
        "        return false",
        "    endif",
        "    set t = CreateTimer()",
        "    set timerId = GetHandleId(t)",
        "    call SavePlayerHandle(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 1, whichPlayer)",
        "    call SaveStr(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 2, itemKey)",
        "    call SaveInteger(War3Lib_LocalDzApiMallItem_TimerTable, timerId, 3, count)",
        "    call TimerStart(t, 0.30, false, function War3Lib_LocalDzApiMallItem_ConsumeDelayed)",
        "    set t = null",
        "    return true",
        "endfunction",
        "endlibrary",
        "",
        "#define DzAPI_Map_HasMallItem(p, k) War3Lib_LocalDzApiMallItem_Has(p, k)",
        "#define DzAPI_Map_GetMallItemCount(p, k) War3Lib_LocalDzApiMallItem_GetCount(p, k)",
        "#define DzAPI_Map_ConsumeMallItem(p, k, c) War3Lib_LocalDzApiMallItem_Consume(p, k, c)"
    }

    for _, line in ipairs(tail) do
        lines[#lines + 1] = line
    end

    return lines
end

local function splitTopLevelArgs(args)
    local result = {}
    local start = 1
    local depth = 0
    local inString = false
    local escaped = false

    for i = 1, #args do
        local ch = args:sub(i, i)
        if inString then
            if escaped then
                escaped = false
            elseif ch == "\\" then
                escaped = true
            elseif ch == '"' then
                inString = false
            end
        elseif ch == '"' then
            inString = true
        elseif ch == "(" then
            depth = depth + 1
        elseif ch == ")" then
            depth = math.max(depth - 1, 0)
        elseif ch == "," and depth == 0 then
            result[#result + 1] = args:sub(start, i - 1):match("^%s*(.-)%s*$")
            start = i + 1
        end
    end

    result[#result + 1] = args:sub(start):match("^%s*(.-)%s*$")
    return result
end

local function emptyHeader(version)
    return table.concat({
        "#ifndef WAR3LIB_LOCAL_DZAPI_MOCK_GENERATED_H",
        "#define WAR3LIB_LOCAL_DZAPI_MOCK_GENERATED_H",
        "// Generated by War3Lib compile flow. Current build: " .. version,
        "#endif"
    }, "\n") .. "\n"
end

local function buildHeader(version, cfg)
    local localSection = cfg["War3Lib.LocalDzApi"] or {}
    local playerUserNameSection = cfg["War3Lib.LocalDzApi.PlayerUserName"]
    local dzSection = cfg["DzAPI"] or {}
    local startTime = localSection["DzAPI_Map_GetGameStartTime"] or dzSection["DzAPI_Map_GetGameStartTime"] or "0"

    startTime = tostring(startTime):match("^%-?%d+$") and tostring(startTime) or "0"

    local lines = {
        "#ifndef WAR3LIB_LOCAL_DZAPI_MOCK_GENERATED_H",
        "#define WAR3LIB_LOCAL_DZAPI_MOCK_GENERATED_H",
        "// Generated by War3Lib compile flow. Source: " .. (path.localDzApiIni or ""),
        "",
        "#if defined(WAR3LIB_SECOND_WAVE)",
        "#define DzAPI_Map_GetGameStartTime() " .. startTime,
        ""
    }

    for _, line in ipairs(buildMallItemMockLines(cfg, localSection)) do
        lines[#lines + 1] = line
    end

    if isPlayerUserNameMockEnabled(version, playerUserNameSection) then
        lines[#lines + 1] = ""
        for _, line in ipairs(buildPlayerUserNameMockLines(playerUserNameSection, localSection)) do
            lines[#lines + 1] = line
        end
    end

    lines[#lines + 1] = "#endif"
    lines[#lines + 1] = ""
    lines[#lines + 1] = "#endif"

    return table.concat(lines, "\n") .. "\n"
end

local function readMockState()
    local version = readCurrentVersion()
    local cfg = ini.read(path.localDzApiIni)
    local localSection = cfg["War3Lib.LocalDzApi"] or {}
    local modes = splitModes(localSection["Modes"])
    local enabled = boolEnabled(localSection["Enable"]) and modes[version] == true
    return version, cfg, localSection, enabled
end

function localDzApi.generate()
    local started = os.clock()
    local timestamp = os.time()
    local ok, changed, err = writeLocalGameStartTime(timestamp)
    local cfg
    local syncMsg
    if not ok then
        return false, err
    end

    cfg = ini.read(path.localDzApiIni)
    ok, syncMsg = syncWorldEditPlayerName(cfg)
    if not ok then
        return false, syncMsg
    end

    local version, mockCfg, _, enabled = readMockState()
    local content
    local label

    if enabled then
        content = buildHeader(version, mockCfg)
        label = "[DzAPI本地替换]启用: " .. version .. " <- " .. path.localDzApiIni
    else
        content = emptyHeader(version)
        label = "[DzAPI本地替换]跳过: " .. version
    end

    local ok, err = ensureDir(path.generatedConfig)
    if not ok then
        return false, err
    end
    ok, err = fu.WriteOver(path.localDzApiMockH, content)
    if ok then
        if changed then
            print("[DzAPI本地替换]GameStartTime写入: " .. tostring(timestamp))
        end
        print("[本地玩家名]注册表同步: " .. tostring(syncMsg))
        print(label .. formatElapsedSeconds(elapsedMs(started)))
    end
    return ok, err
end

function localDzApi.applyMapConfigReplacement(filePath)
    local started = os.clock()
    local version, cfg, localSection, enabled = readMockState()
    if not enabled then
        print("[DzAPI本地替换]MapConfig跳过: " .. version .. formatElapsedSeconds(elapsedMs(started)))
        return true
    end

    local content = fu.GetContent(filePath)
    if not content then
        return false, "无法读取MapConfig替换目标: " .. tostring(filePath)
    end

    local mapConfig = cfg["War3Lib.LocalDzApi.MapConfig"] or {}
    local defaultValue = localSection["MapConfigDefault"] or ""
    local keyCount = 0
    local fallbackCount = 0

    content = content:gsub('DzAPI_Map_GetMapConfig%s*%(%s*"([^"]*)"%s*%)', function(key)
        keyCount = keyCount + 1
        return jassString(mapConfig[key] or defaultValue)
    end)

    content = content:gsub('DzAPI_Map_GetMapConfig%s*(%b())', function()
        fallbackCount = fallbackCount + 1
        return jassString(defaultValue)
    end)

    local ok, err = fu.WriteOver(filePath, content)
    if ok then
        print(string.format("[DzAPI本地替换]MapConfig完成: 按Key替换=%d, 兜底替换=%d%s", keyCount, fallbackCount, formatElapsedSeconds(elapsedMs(started))))
    end
    return ok, err
end

function localDzApi.applyPlayerFlagsReplacement(filePath)
    local started = os.clock()
    local version, cfg, localSection, enabled = readMockState()
    if not enabled then
        print("[DzAPI本地替换]PlayerFlags跳过: " .. version .. formatElapsedSeconds(elapsedMs(started)))
        return true
    end

    local content = fu.GetContent(filePath)
    if not content then
        return false, "无法读取PlayerFlags替换目标: " .. tostring(filePath)
    end

    local flags = cfg["War3Lib.LocalDzApi.PlayerFlags"] or {}
    local defaultValue = flags["Default"] or localSection["PlayerFlagsDefault"] or "false"
    local labelCount = 0
    local fallbackCount = 0

    content = content:gsub('DzAPI_Map_PlayerFlags%s*(%b())', function(callArgs)
        local args = splitTopLevelArgs(callArgs:sub(2, -2))
        local label = args[2] and args[2]:match("^%s*(%-?%d+)%s*$")
        if label then
            labelCount = labelCount + 1
            return jassBool(flags[label], defaultValue)
        end
        fallbackCount = fallbackCount + 1
        return jassBool(defaultValue, "false")
    end)

    local ok, err = fu.WriteOver(filePath, content)
    if ok then
        print(string.format("[DzAPI本地替换]PlayerFlags完成: 按label替换=%d, 兜底替换=%d%s", labelCount, fallbackCount, formatElapsedSeconds(elapsedMs(started))))
    end
    return ok, err
end

return localDzApi
