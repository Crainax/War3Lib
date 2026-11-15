local root='D:/War3/tools/w3x2lni'
package.path=root..'/script/?.lua;'..root..'/script/?/init.lua;'..package.path
package.cpath=root..'/bin/?.dll;'..package.cpath
local a=assert(require('ffi.stormlib').open(require('bee.filesystem').path(arg[1] or 'Output/font-style/UITextFontStyle.w3x'),true))
for _,n in ipairs({'UITextFontStyle.fdf','UITextFontStyle.toc'}) do
 local f=assert(io.open('Jass/ui/components/text/'..n,'rb'));local s=f:read('*a');f:close()
 assert(a:load_file('ui\\'..n)==s,'Missing or stale template: '..n)
end
for _,n in ipairs({'FontStyle-SimHei.ttf','FontStyle-SourceHanSansCN-Bold.ttf','FontStyle-SourceHanSansCN-Heavy.ttf','SourceHanSans-LICENSE.txt','FontStyle-YaHeiBold.ttf'}) do
 local font=assert(io.open('UnitTestMap/map/Fonts/'..n,'rb'))
 local fontBytes=font:read('*a');font:close()
 assert(a:load_file('Fonts\\'..n)==fontBytes,'Missing or stale font/license: '..n)
end
local s=assert(a:load_file('war3map.j'))
assert(s:find('DzFrameAddTextShadow',1,true))
assert(s:find('FontStyle-SimHei.ttf',1,true) and s:find('[FONT_STYLE_V4_DONE]',1,true),'Stale test script')
assert(s:find('FontStyle-SourceHanSansCN-Bold.ttf',1,true) and s:find('FontStyle-SourceHanSansCN-Heavy.ttf',1,true),'Missing font selection')
assert(s:find('FontStyle-YaHeiBold.ttf',1,true),'Missing YaHei font selection')
assert(s:find('R2SW',1,true),'Missing four-decimal formatting')
assert(not s:find('exec-lua:',1,true),'Unexpected Lua bootstrap')
a:close()
print('PASS: packed FDF/TOC and all four imported fonts/license match sources; V4 script with four-decimal formatting; pure JASS entry')
