local target = require 'Lua.compile.UnitTestTarget'
local path = require 'Lua.path'
local profile = require 'Lua.compile.RuntimeProfile'
local artifact = require 'Lua.compile.LauncherArtifact'
path.init('D:/War3', 'D:/War3/Library/War3Lib', 'D:/WE/KKWE_Plugin')
path.initUnitTest()
local lease = artifact.acquire(path.project)
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
assert(currentSlot == 'current')
path.testScenario = 'empty'
local emptySlot = profile.key('innerjapi')
assert(emptySlot == currentSlot)
assert(target.selected(path.project, 'empty'):match('/EmptyRuntime_Test%.j$'))
profile.stage('innerjapi')
assert(path.package:find('/launcher/work/UnitTestMap', 1, true))
assert(read(header) == before, '选择空白测试不能覆盖当前测试头')
path.testScenario = 'current'
assert(profile.key('innerjapi') == currentSlot)
assert(target.selected(path.project, 'current') == current)
lease:close()
print('PASS: current/empty selection, reusable staging and unchanged UnitTest.h')
