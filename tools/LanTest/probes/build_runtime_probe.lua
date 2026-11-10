local runtime, source, target, probe = table.unpack(arg)
package.path=runtime..'/script/common/?.lua;'..package.path
package.cpath=runtime..'/bin/modules/?.dll;'..runtime..'/bin/?.dll;'..package.cpath
require 'filesystem'
local storm=require 'ffi.stormlib'
local map=assert(storm.open(fs.path(target),false))
local code=assert(map:load_file('war3map.j'))
for i=4,5 do
    local old='call SetPlayerController(Player('..i..'),MAP_CONTROL_COMPUTER)'
    assert(code:find(old,1,true))
    code=code:gsub('call SetPlayerController%(Player%('..i..'%),MAP_CONTROL_COMPUTER%)','call SetPlayerController(Player('..i..'),MAP_CONTROL_USER)')
end
assert(map:save_file('war3map.j',code))
local entry=assert(map:load_file('plugin_main.lua'))
local file=assert(io.open(probe,'rb'));local script=file:read('*a');file:close()
assert(map:save_file('runtime_probe.lua',script))
assert(map:save_file('plugin_main.lua',entry..'\nrequire "runtime_probe"\n'))
map:close()
print('Disposable six-player runtime harness created; source unchanged.')
