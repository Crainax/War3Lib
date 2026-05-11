local ini = {}

local function trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function unquote(value)
    value = trim(value)
    if (#value >= 2) and (
        (value:sub(1, 1) == '"' and value:sub(-1) == '"') or
        (value:sub(1, 1) == "'" and value:sub(-1) == "'")
    ) then
        return value:sub(2, -2)
    end
    return value
end

function ini.read(filePath)
    local result = {}
    local section = ""
    local file = io.open(filePath, "r")
    if not file then
        return result
    end

    for line in file:lines() do
        line = trim(line)
        if line ~= "" and line:sub(1, 1) ~= ";" and line:sub(1, 1) ~= "#" then
            local nextSection = line:match("^%[([^%]]+)%]$")
            if nextSection then
                section = trim(nextSection)
                result[section] = result[section] or {}
            else
                local key, value = line:match("^([^=]+)=(.*)$")
                if key then
                    result[section] = result[section] or {}
                    result[section][trim(key)] = unquote(value)
                end
            end
        end
    end

    file:close()
    return result
end

return ini
