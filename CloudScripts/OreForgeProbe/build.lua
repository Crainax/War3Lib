-- Run at War3Lib root. Builds only; never launches game or changes KK/cloud settings.
local path = require('Lua.path')
local tc = require('Lua.compile.TestControl')
local compiler = require('lua.compile.compiler')
local packer = require('Lua.compile.W3xLni')
path.init('D:/War3', 'D:/War3/Library/War3Lib', 'D:/WE/KKWE_Plugin')
tc.GetState()
assert(path.buildVersion == '单元测试', 'Select VERSION_UNITTEST before building')
local target = assert(io.open('Jass/config/UnitTest.h', 'rb'))
local content = target:read('*a'); target:close()
assert(content:find('OreForgeProbe_Test.j', 1, true), 'Select OreForgeProbe_Test.j before building')
path.jassCompiler = 'vjassc'
path.jassCompilerSelect = 'vjassc'
path.allowVjasscNonAlpha = true
path.vjasscStrict = true
assert(compiler:StartCompile(), 'compile failed')
assert(packer:StartOBJ(), 'package failed')
local source = assert(io.open(path.project .. '/' .. path.mapName .. '.w3x', 'rb'))
local binary = source:read('*a'); source:close()
local output = path.project .. '/Output/OreForgeProbe.w3x'
local file = assert(io.open(output, 'wb')); assert(file:write(binary)); file:close()
print('PACKAGED: ' .. output .. ' (' .. #binary .. ' bytes)')
