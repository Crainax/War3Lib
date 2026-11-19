-- w3x2lni-lua.exe this-file <w2l-root> <packed-map>
local root,map=assert(arg[1]),assert(arg[2])
package.path=root..'/script/?.lua;'..root..'/script/?/init.lua;'..package.path
package.cpath=root..'/bin/?.dll;'..package.cpath
local archive=assert(require('ffi.stormlib').open(require('bee.filesystem').path(map),true))
local jass=assert(archive:load_file('war3map.j'))
assert(not jass:find('native InnerFont',1,true),'Custom DLL native remains in map')
assert(jass:find('StartCampaignAI',1,true) and jass:find('exec-lua:plugin_main',1,true),'Missing embedded engine bootstrap')
local main=assert(archive:load_file('plugin_main.lua'))
assert(main:find('script.experiments.innerjapi.cases.ui_font_unlock',1,true))
for _,name in ipairs({'callback','(key)','wenhao_plugin.tga','ui\\slider\\nandu_slider_bg.blp','ui\\slider\\nandu_slider_button.blp'}) do
    assert(archive:load_file(name),'Missing resource '..name)
end
local path=assert(archive:load_file('path.lua'))
assert(path:find('return false',1,true) and not path:find('D:',1,true),'Map still depends on a local Lua path')
for _,name in ipairs({'script\\init.lua','script\\experiments\\innerjapi\\font_size.lua','script\\experiments\\innerjapi\\cases\\ui_font_unlock.lua'}) do
    assert(archive:load_file(name),'Lua missing from MPQ: '..name)
end
assert(not archive:load_file('inner_font_size.dll'),'Custom DLL unexpectedly packaged')
archive:close()
print('PASS: self-contained MPQ, existing InnerJAPI bootstrap, Lua font module and slider assets; no custom natives/DLL')
