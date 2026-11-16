local root='D:/War3/tools/w3x2lni'
package.path=root..'/script/?.lua;'..root..'/script/?/init.lua;'..package.path
package.cpath=root..'/bin/?.dll;'..package.cpath
local a=assert(require('ffi.stormlib').open(require('bee.filesystem').path(arg[1] or 'Output/font-style/UITextFontStyle.w3x'),true))
for _,n in ipairs({'UITextFontStyle.fdf','UITextFontStyle.toc'}) do
 local f=assert(io.open('Jass/ui/components/text/'..n,'rb'));local s=f:read('*a');f:close()
 assert(a:load_file('ui\\'..n)==s,'Missing or stale template: '..n)
end
local s=assert(a:load_file('war3map.j'))
assert(s:find('DzFrameAddTextShadow',1,true))
assert(s:find('dfst-m3u.ttf',1,true) and s:find('[FONT_STYLE_V4_DONE]',1,true),'Stale default-font test')
for _,n in ipairs({'FontStyle-SimHei.ttf','FontStyle-SourceHanSansCN-Bold.ttf','FontStyle-SourceHanSansCN-Heavy.ttf','FontStyle-YaHeiBold.ttf'})do
 assert(not s:find(n,1,true),'obsolete font reference '..n)
 assert(not a:load_file('Fonts\\'..n),'obsolete packaged font '..n)
end
assert(s:find('R2SW',1,true),'Missing four-decimal formatting')
assert(not s:find('exec-lua:',1,true),'Unexpected Lua bootstrap')
a:close()
print('PASS: packed FDF/TOC match sources; default-font V4 script with four-decimal formatting; pure JASS entry')
