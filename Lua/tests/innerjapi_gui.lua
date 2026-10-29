-- Exercise the real GUI callbacks with a minimal widget backend; no game launch.
local buttons, labels, loopAction
local function widget(value)
 local w={title=type(value)=='table' and value.title or value}
 return setmetatable(w,{__index=function(_,key)
  if key=='setchecked' then return function(self,v) self.checked=v end end
  return function() end
 end})
end
package.loaded['yue.gui']={
 Font={create=function() return {} end},
 Container={create=widget}, Window={create=widget},
 Label={create=function(value) labels[value]=true;return widget(value) end},
 Button={create=function(value) local w=widget(value);buttons[w.title]=w;return w end},
 MessageLoop={quit=function()end,run=function()loopAction()end}
}
local function read(p) local f=assert(io.open(p));local s=f:read('*a');f:close();return s end
local history='Output/gui-fixture-history.txt'
local f=assert(io.open(history,'w'));f:write('version=VERSION_RELEASE\nengine=innerjapi\ncompiler=vjassc\n');f:close()
for _,mode in ipairs({'war3lib','default'}) do
 buttons,labels={},{}
 arg={'Output/gui-fixture-selection.txt',history,'Output/nonexistent-state.txt',mode}
 loopAction=function()
  if mode=='war3lib' then
   assert(buttons.YDLua.checked==true)
   assert(not buttons['正式'] and not buttons['内测'])
   assert(buttons.InnerJapi and not buttons['InnerJapi 1.49-9'])
   buttons.InnerJapi:onclick()
  else
   assert(buttons['正式'].checked==true)
   assert(not buttons.InnerJapi)
  end
  buttons['启动']:onclick()
 end
 dofile('Lua/gui/launcher/main.lua')
 local result=read(arg[1])
 if mode=='war3lib' then
  assert(result:find('version=VERSION_UNITTEST',1,true))
  assert(result:find('engine=innerjapi',1,true))
 else assert(not result:find('engine=',1,true)) end
end
print('PASS: GUI default YDLua, InnerJapi selection, fixed unittest, legacy GUI preserved')
