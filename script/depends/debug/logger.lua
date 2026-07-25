local jass = require 'jass.common'
local console = require 'jass.console'
local log = require 'jass.log'
local g = require 'jass.globals'
local debug = require 'jass.debug'
local mt = {}

local DEDUP_WINDOW = 0.35
local TARGET_ALL = -1
local TARGET_NONE = -2
local last_key = nil
local last_time = 0

local function local_pid()
    local ok, pid = pcall(function()
        return jass.GetPlayerId(jass.GetLocalPlayer())
    end)
    if ok and type(pid) == 'number' then
        return pid
    end
    return -1
end

local function player_pid(p)
    if p == nil then
        return TARGET_NONE
    end
    local ok, pid = pcall(function()
        return jass.GetPlayerId(p)
    end)
    if ok and type(pid) == 'number' then
        return pid
    end
    return TARGET_NONE
end

local function should_log_target(target_pid)
    target_pid = tonumber(target_pid)
    if target_pid == nil then
        if g.logger_p ~= nil then
            return g.logger_p == jass.GetLocalPlayer()
        end
        return true
    end
    if target_pid == TARGET_NONE then
        return false
    end
    return target_pid == TARGET_ALL or target_pid == local_pid()
end

local function is_release_version()
    local version = tostring(package.build_version or '')
    return version:find('正式', 1, true) ~= nil or version:find('RELEASE', 1, true) ~= nil
end

local function is_important_display()
    return (tonumber(g.logger_important_depth) or 0) > 0
end

local function should_capture_display()
    return not is_release_version() or is_important_display()
end

local function is_duplicate(text, target_pid)
    local now = os.clock()
    local key = tostring(target_pid or TARGET_ALL) .. '\31' .. tostring(text)
    if key == last_key and now - last_time <= DEDUP_WINDOW then
        return true
    end
    last_key = key
    last_time = now
    return false
end

local function emit(level, text)
    if level == 0 then
        log.trace(text)
        console.write(text)
    elseif level == 1 then
        log.debug(text)
        console.write(text)
    elseif level == 2 then
        log.info(text)
        console.write(text)
    elseif level == 3 then
        log.warn(text)
        console.write(text)
    elseif level == 4 then
        log.error(text)
    else
        log.info(text)
        console.write(text)
    end
end

function mt.write(level, message, target_pid)
    local normalized_target_pid = tonumber(target_pid)
    if not should_log_target(normalized_target_pid) then
        return false
    end
    normalized_target_pid = normalized_target_pid or TARGET_ALL

    local text = tostring(message or '')
    if text == '' or is_duplicate(text, normalized_target_pid) then
        return false
    end

    emit(tonumber(level) or 2, text)
    return true
end

function mt.display(toPlayer, message)
    if not should_capture_display() then
        return false
    end
    return mt.write(0, message, player_pid(toPlayer))
end

g.logger_tr = jass.CreateTrigger()
debug.handle_ref(g.logger_tr)
jass.TriggerAddCondition(g.logger_tr, jass.Condition(function()
    mt.write(g.logger_level, g.logger_msg, g.logger_target_pid)
end))

console.write("[日志系统]初始化成功.")
return mt
