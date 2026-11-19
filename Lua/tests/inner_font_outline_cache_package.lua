local root='D:/War3/tools/w3x2lni'
package.path=root..'/script/?.lua;'..root..'/script/?/init.lua;'..package.path
package.cpath=root..'/bin/?.dll;'..package.cpath
local a=assert(require('ffi.stormlib').open(require('bee.filesystem').path(assert(arg[1],'map path required')),true))
local function same(n)
 local source='script/experiments/innerjapi/'..n
 local f=assert(io.open(source,'rb'));local b=f:read('*a');f:close()
 assert(a:load_file(source:gsub('/','\\'))==b,'missing/stale '..n)
end
for _,n in ipairs({'font_outline.lua','font_outline_kkcache.lua','font_outline_cache_core.lua','font_outline_cache_bytes.lua','font_style.lua','font_size.lua','cases/ui_font_outline_kkcache.lua'})do same(n)end
for _,n in ipairs({'UITextFontInnerStyle.fdf','UITextFontInnerStyle.toc'})do
 local f=assert(io.open('Jass/ui/components/text/'..n,'rb'));local b=f:read('*a');f:close()
 assert(a:load_file('ui\\'..n)==b,'missing/stale template '..n)
end
for _,n in ipairs({'FontStyle-SimHei.ttf','FontStyle-SourceHanSansCN-Bold.ttf','FontStyle-SourceHanSansCN-Heavy.ttf','FontStyle-YaHeiBold.ttf'})do
 assert(not a:load_file('Fonts\\'..n),'obsolete comparison font '..n)
end
assert(a:load_file('plugin_main.lua'):find('script.experiments.innerjapi.cases.ui_font_outline_kkcache',1,true))
assert(not a:load_file('script\\experiments\\innerjapi\\native\\font_outline_blob.lua'),'old DLL payload present')
assert(not a:load_file('path.lua'):find('D:',1,true),'local runtime dependency')
require('ffi').load('stormlib').SFileCloseArchive(a.handle);a.handle=0
print('PASS: exact packaged cache implementation and case; no extra DLL payload or local source path')
