local slk   = require 'jass.slk'
local jass  = require 'jass.common'
local g     = require 'jass.globals'

-- 与 JASS 侧 SpellUtils 通信用：
--  JASS 全局：
--      public trigger spellutilsUberTip_tr
--      public integer spellutilsUberTip_id
--      public integer spellutilsUberTip_level
--      public string  spellutilsUberTip_result
--
--  JASS 调用流程：
--      spellutilsUberTip_id    = id
--      spellutilsUberTip_level = level
--      spellutilsUberTip_result = ""
--      TriggerEvaluate(spellutilsUberTip_tr)
--      // Lua 在这里写回 spellutilsUberTip_result

-- 缓存拆分后的 Tip/Ubertip 段落，避免每次都重新 split
local level_text_cache = {}

local function read_level_text(id, field, level)
    local ability = slk.ability[id]
    if not ability then
        return ""
    end

    local v = ability[field]
    local t = type(v)

    if t == "table" then
        -- 多等级：按 level 取第 N 个；容错：取不到时退回第 1 个
        local val = v[level] or v[tostring(level)] or v[1] or v["1"]
        if val ~= nil then
            return tostring(val)
        end
        return ""
    elseif t == "string" then
        -- 单一长字符串：按优先级尝试不同的分隔符模式拆成多段，再按 level 取
        local raw = tostring(v)
        local field_cache = level_text_cache[field]
        if not field_cache then
            field_cache = {}
            level_text_cache[field] = field_cache
        end

        local segs = field_cache[id]
        if not segs then
            segs = {}
            local start_pos = 1
            local separator_pattern = nil
            local separator_len = 0

            -- 按优先级尝试不同的分隔符模式
            if string.find(raw, '","', 1, true) then
                separator_pattern = '","'
                separator_len = 3
            elseif string.find(raw, '",', 1, true) then
                separator_pattern = '",'
                separator_len = 2
            elseif string.find(raw, ',', 1, true) then
                separator_pattern = ','
                separator_len = 1
            end

            if separator_pattern then
                while true do
                    local p = string.find(raw, separator_pattern, start_pos, true)
                    if not p then
                        -- 最后一段
                        local seg = string.sub(raw, start_pos)
                        if #seg > 0 then
                            table.insert(segs, seg)
                        end
                        break
                    else
                        local seg = string.sub(raw, start_pos, p - 1)
                        if #seg > 0 then
                            table.insert(segs, seg)
                        end
                        start_pos = p + separator_len
                    end
                end
            else
                -- 没有分隔符，整个字符串作为一段
                table.insert(segs, raw)
            end

            field_cache[id] = segs
        end

        local seg = segs[level] or segs[1]
        if seg then
            return seg
        end
        return ""
    elseif v ~= nil then
        -- 其他类型，做一次 tostring 兜底
        return tostring(v)
    end

    return ""
end

g.spellutilsTip_tr = jass.CreateTrigger()

jass.TriggerAddCondition(g.spellutilsTip_tr, jass.Condition(function ()
    local id    = g.spellutilsTip_id or 0
    local level = g.spellutilsTip_level or 1

    g.spellutilsTip_result = read_level_text(id, "Tip", level) or ""
end))

g.spellutilsUberTip_tr = jass.CreateTrigger()

jass.TriggerAddCondition(g.spellutilsUberTip_tr, jass.Condition(function ()
    local id    = g.spellutilsUberTip_id or 0
    local level = g.spellutilsUberTip_level or 1

    -- 写回 JASS 全局变量
    g.spellutilsUberTip_result = read_level_text(id, "Ubertip", level) or ""
end))

print("初始化 SLK SpellUtils 扩展 [Tip/Ubertip by level]")


