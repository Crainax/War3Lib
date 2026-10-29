local root,base=arg[1],arg[2]
package.path=root..'/script/?.lua;'..root..'/script/?/init.lua;'..package.path
package.cpath=root..'/bin/?.dll;'..package.cpath
local fs=require 'bee.filesystem'
local storm=require 'ffi.stormlib'
for _,engine in ipairs({'ydlua','innerjapi-1.49-9'}) do
 local archive=assert(storm.open(fs.path(base..'/Output/launcher/engines/'..engine..'/UnitTestMap_slk.w3x'),true))
 local inner=engine~='ydlua'
 for _,name in ipairs({'callback','(key)','wenhao_plugin.tga'}) do
  local data=archive:load_file(name)
  assert((data~=nil)==inner,engine..' unexpected asset '..name)
  if inner then local f=assert(io.open(base..'/runtime/innerjapi/1.49-9/'..name,'rb'));assert(data==f:read('a'),name..' differs');f:close() end
 end
 local script=assert(archive:load_file('war3map.j'))
 assert((script:find('StartCampaignAI',1,true)~=nil)==inner)
 assert((script:find('Cheat("exec-lua:plugin_main")',1,true)~=nil)==not inner)
 local entry=assert(archive:load_file('plugin_main.lua'))
 assert(entry:find("package.lua_engine = '"..(inner and 'innerjapi' or 'ydlua').."'",1,true))
 archive:close()
 print('PASS actual MPQ: '..engine)
end
