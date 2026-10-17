-- Run with w3x2lni-lua.exe; arguments: w2l root, War3Lib root, checker root, scratch directory.
local root, lib, checker, scratch = table.unpack(arg)
package.path = root .. '/script/?.lua;' .. package.path
package.cpath = root .. '/bin/?.dll;' .. package.cpath
local fs = require 'bee.filesystem'
local storm = require 'ffi.stormlib'
fs.create_directories(fs.path(scratch))
local valid = 'function config takes nothing returns nothing\nendfunction\nfunction main takes nothing returns nothing\nendfunction\n'
local cases = {
    {'valid', valid, true},
    {'empty', 'globals\nendglobals\n', false},
    {'missing-config', 'function main takes nothing returns nothing\nendfunction\n', false},
    {'undefined-call', valid:gsub('function main takes nothing returns nothing', 'function main takes nothing returns nothing\ncall MissingFunction()'), false},
    {'comment-decoy', '// function config takes nothing returns nothing\n// function main takes nothing returns nothing\nglobals\nendglobals\n', false},
    {'bad-secondary', valid, false, 'globals\nendglobals\n'},
    {'w2l-error', valid, false, nil, '严重错误 (1)\n脚本语法错误'},
    {'w2l-warning', valid, true, nil, '警告 (1)\n历史物编警告'},
}
for _, case in ipairs(cases) do
    local map = scratch .. '/' .. case[1] .. '.w3x'
    local archive = assert(storm.create(fs.path(map), 16))
    assert(archive:save_file('war3map.j', case[2]))
    if case[4] then assert(archive:save_file('scripts\\war3map.j', case[4])) end
    archive:close()
    local report = ''
    if case[5] then
        report = scratch .. '/' .. case[1] .. '.log'
        local f = assert(io.open(report, 'wb')); f:write(case[5]); f:close()
    end
    local cmd = string.format('"%s/bin/w3x2lni-lua.exe" "%s/Lua/tasks/TaskValidatePackedMap.lua" "%s" "%s" "%s" "%s" "%s"',
        root, lib, root, map, scratch, checker, report)
    local ok, kind, code = os.execute('"' .. cmd .. '"')
    local passed = ok == true or ok == 0 or (kind == 'exit' and code == 0)
    assert(passed == case[3], 'unexpected result: ' .. case[1])
    print('PASS: ' .. case[1])
end
