-- Runs under w3x2lni's Lua runtime so StormLib can read the actual MPQ.
local root, mapPath, output, checkerRoot, reportPath = table.unpack(arg)
package.path = root .. '/script/?.lua;' .. root .. '/script/?/init.lua;' .. package.path
package.cpath = root .. '/bin/?.dll;' .. package.cpath
local fs = require 'bee.filesystem'
local storm = require 'ffi.stormlib'
local function fail(message)
    print('[打包检查] ' .. message)
    os.exit(1)
end
local function read(file)
    local f = io.open(file, 'rb')
    if not f then return nil end
    local s = f:read('a'); f:close(); return s
end
local function write(file, data)
    local f = assert(io.open(file, 'wb')); f:write(data); f:close()
end
if reportPath and reportPath ~= '' then
    local report = read(reportPath)
    if not report then fail('缺少本次 w3x2lni 报告: ' .. reportPath) end
    write(output .. '/packed-w2l-report.log', report)
    local errors = tonumber(report:match('严重错误 %((%d+)%)') or report:match('Error %((%d+)%)') or '0')
    if errors > 0 then fail('w3x2lni 报告严重错误，见 output/packed-w2l-report.log') end
end
local archive = storm.open(fs.path(mapPath), true)
if not archive then fail('无法读取地图: ' .. mapPath) end
local found = false
for index, name in ipairs({'war3map.j', 'scripts\\war3map.j'}) do
    local script = archive:load_file(name)
    if script then
        found = true
        -- Strip strings and comments before checking declarations.
        local code = script:gsub('"[^"\r\n]*"', '""'):gsub('//[^\r\n]*', '')
        for _, entry in ipairs({'main', 'config'}) do
            if not code:match('%f[%w_]function%s+' .. entry .. '%s+takes%s+nothing%s+returns%s+nothing%f[^%w_]') then
                archive:close(); fail(name .. ' 缺少入口 ' .. entry)
            end
        end
        local extracted = output .. '/packed-script-' .. index .. '.j'
        write(extracted, script)
        local cmd = string.format('"%s/pjass.exe" "%s/common.j" "%s/blizzard.j" "%s" > "%s/packed-pjass-%d.log" 2>&1',
            checkerRoot, checkerRoot, checkerRoot, extracted, output, index)
        local ok, kind, status = os.execute('"' .. cmd .. '"')
        if not (ok == true or ok == 0 or (kind == 'exit' and status == 0)) then
            archive:close(); fail(name .. ' PJASS 失败，见 output/packed-pjass-' .. index .. '.log')
        end
        print('[打包检查] ' .. name .. ': ' .. #script .. ' bytes; main/config + PJASS PASS')
    end
end
archive:close()
if not found then fail('地图中没有 JASS 脚本') end
