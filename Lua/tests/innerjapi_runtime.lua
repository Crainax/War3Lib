local path = require 'Lua.path'
local profile = require 'Lua.compile.RuntimeProfile'
local runtime = require 'Lua.compile.LuaRuntime'
local lfs = require 'lfs'
local function read(p) local f=assert(io.open(p,'rb'));local s=f:read('*a');f:close();return s end
path.init('D:/War3', 'D:/War3/Library/War3Lib', 'D:/WE/KKWE_Plugin')
path.initUnitTest()
local originalCallback = read(path.package .. '/map/callback')
local originalImp = read(path.table.root .. '/imp.ini')
for _, engine in ipairs({'ydlua','innerjapi','ydlua'}) do
    path.init('D:/War3', 'D:/War3/Library/War3Lib', 'D:/WE/KKWE_Plugin')
    path.initUnitTest()
    profile.stage(engine)
    assert(not read(path.table.root .. '/imp.ini'):find('wenhao_plugin.tga',1,true))
    local files = runtime.getPackageFiles()
    local byName={};for _,file in ipairs(files) do byName[file.archive]=file end
    assert((byName.callback ~= nil) == (engine == 'innerjapi'))
    local cleanup=assert(runtime.prepareForPackage())
    local entry=read(path.package .. '/map/plugin_main.lua')
    assert(entry:find("package.lua_engine = '"..engine.."'",1,true))
    if engine=='innerjapi' then
        assert(read(path.package .. '/map/callback')==read('runtime/innerjapi/1.49-9/callback'))
        assert(read(path.package .. '/resource/wenhao_plugin.tga')==read('runtime/innerjapi/1.49-9/wenhao_plugin.tga'))
    else
        assert(not lfs.attributes(path.package .. '/map/callback'))
        assert(not lfs.attributes(path.package .. '/resource/wenhao_plugin.tga'))
    end
    cleanup()
    assert(not lfs.attributes(path.package .. '/resource/wenhao_plugin.tga'))
    assert(require('Lua.compile.IncrementalPack').prepare('unused', {dryRun=true}))
end
assert(read('UnitTestMap/map/callback')==originalCallback)
assert(read('UnitTestMap/table/imp.ini')==originalImp)
-- Project isolation: InnerJapi env is never adopted by Xlimon/LH.
for _, project in ipairs({'Xlimon','LH'}) do
    path.init('D:/War3','D:/War3/Maps/'..project,'D:/WE/KKWE_Plugin')
    assert(path.luaEngine=='ydlua')
    assert(#profile.files()==0)
    local entry=runtime.getPackageFiles()[1].content
    assert(not entry:find("package.lua_engine = ",1,true))
end
-- Runner lifecycle: reload cleans before loading, dependencies survive.
local name='script.experiments.innerjapi.cases.fixture'
local events={};local generation=0
package.preload[name]=function()
    generation=generation+1;local n=generation
    return {start=function() events[#events+1]='start'..n end,stop=function() events[#events+1]='stop'..n end}
end
local runner=require 'script.experiments.innerjapi.runner'
runner.start(name);runner.reload();runner.stop()
assert(table.concat(events,',')=='start1,stop1,start2,stop2')
assert(not pcall(runner.start,'jass.common'))
package.loaded[name]=nil
package.preload[name]=function() return {start=function() error('fixture failure') end,stop=function() events[#events+1]='clean failure' end} end
assert(not pcall(runner.start,name));assert(events[#events]=='clean failure')
print('PASS: engine staging, resource restoration, project isolation, reload lifecycle')
