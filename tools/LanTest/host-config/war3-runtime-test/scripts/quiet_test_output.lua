-- 仅处理视觉入口持有的临时地图。使用原图现有的 Trace 写入 P1 日志。
local root = 'D:/War3/tools/w3x2lni'
package.path = root .. '/script/?.lua;' .. package.path
package.cpath = root .. '/bin/?.dll;' .. package.cpath
local fs = require 'bee.filesystem'
local storm = require 'ffi.stormlib'
local archive = assert(storm.open(fs.path(assert(arg[1])), false))
local name = 'war3map.j'
local source = archive:load_file(name)
if not source then
    name = 'scripts\\war3map.j'
    source = archive:load_file(name)
end
if not source or not source:match('function%s+Trace%s+takes%s+string%s+[%w_]+%s+returns%s+nothing') then
    archive:close()
    print('No War3Lib JASS Trace adapter; use the project test logger for visual diagnostics.')
    return
end

local function is_diagnostic(expression)
    for _, prefix in ipairs({ 'PASS:', 'FAIL:', '  Expected:', '  Actual:', '-----[单测 ', '[UT_PASS]', '[UT_FAIL]' }) do
        if expression:sub(1, #prefix + 1) == '"' .. prefix then
            return true
        end
    end
    return false
end

local count = 0
local function route_line(line)
    local expression = line:match('^%s*call%s+BJDebugMsg%s*%(%s*(.*)%)%s*$')
        or line:match('^%s*call%s+DisplayTimedTextToPlayer%s*%(%s*GetLocalPlayer%s*%(%s*%)%s*,%s*[%d%.]+%s*,%s*[%d%.]+%s*,%s*[%d%.]+%s*,%s*(.*)%)%s*$')
    if not expression or not is_diagnostic(expression) then
        return line
    end
    count = count + 1
    return 'set War3VisualDiagnosticText = ' .. expression .. '\ncall ExecuteFunc("War3VisualWriteDiagnostic")'
end

local updated = source:gsub('[^\r\n]+', route_line)
if count > 0 then
    assert(not source:find('War3VisualDiagnosticText', 1, true) and not source:find('War3VisualWriteDiagnostic', 1, true))
    local inserted
    updated, inserted = updated:gsub('(%f[%w]globals[ \t]*\r?\n)', '%1string War3VisualDiagnosticText\n', 1)
    assert(inserted == 1)
    -- JASS 函数声明有顺序；断言可能比地图中的 Trace 更早定义。
    updated = updated .. '\nfunction War3VisualWriteDiagnostic takes nothing returns nothing\n'
        .. 'call Trace(War3VisualDiagnosticText)\nendfunction\n'
    assert(archive:save_file(name, updated))
    assert(archive:load_file(name) == updated)
end
archive:close()
print(('Visual diagnostics routed to Trace: %d call sites'):format(count))
