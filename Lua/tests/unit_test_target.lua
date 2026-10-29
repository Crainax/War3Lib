local target = require 'Lua.compile.UnitTestTarget'
local path = require 'Lua.path'
local profile = require 'Lua.compile.RuntimeProfile'
path.init('D:/War3', 'D:/War3/Library/War3Lib', 'D:/WE/KKWE_Plugin')
path.initUnitTest()
local function read(name)
    local file = assert(io.open(name, 'rb'))
    local content = file:read('*a'); file:close(); return content
end
local header = path.project .. '/Jass/config/UnitTest.h'
local before = read(header)
local current = target.current(path.project)
assert(current:match('%.j$'))
path.testScenario = 'current'
local currentSlot = profile.key('innerjapi')
assert(currentSlot:find('/tests/current-', 1, true))
path.testScenario = 'empty'
local emptySlot = profile.key('innerjapi')
assert(emptySlot ~= currentSlot and emptySlot:match('/tests/empty$'))
assert(target.selected(path.project, 'empty'):match('/EmptyRuntime_Test%.j$'))
profile.stage('innerjapi')
assert(path.package:find('/tests/empty/staging/', 1, true))
assert(read(header) == before, '选择空白测试不能覆盖当前测试头')
path.testScenario = 'current'
assert(profile.key('innerjapi') == currentSlot)
assert(target.selected(path.project, 'current') == current)
print('PASS: current target, empty target, separate slots and unchanged UnitTest.h')
