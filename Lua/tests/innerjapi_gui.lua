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
local context='Output/gui-fixture-context.txt'
local cf=assert(io.open(context,'w'));cf:write('test_file=D:/War3/Library/War3Lib/Jass/learn/CommandButtonDecorateExplore_Test.j\n');cf:close()
local f=assert(io.open(history,'w'));f:write('version=VERSION_RELEASE\nengine=innerjapi\ncompiler=vjassc\nscenario=empty\n');f:close()
for _,mode in ipairs({'war3lib','war3lib-empty','default','missing','invalid'}) do
 local unitOnly = mode ~= 'default'
 if mode=='missing' then os.remove(history) end
 if mode=='invalid' then
  local f=assert(io.open(history,'w'));f:write('engine=unknown\nscenario=unknown\n');f:close()
 end
 local restored = mode=='war3lib' or mode=='war3lib-empty'
 buttons,labels={},{}
 arg={'Output/gui-fixture-selection.txt',history,'Output/nonexistent-state.txt',unitOnly and 'war3lib' or 'default',context}
 loopAction=function()
  if unitOnly then
   assert(buttons.InnerJapi.checked==restored)
   assert(buttons.YDLua.checked==not restored)
   assert(not buttons['正式'] and not buttons['内测'])
   assert(buttons.InnerJapi and not buttons['InnerJapi 1.49-9'])
   assert(buttons['空地图'].checked==restored)
   assert(buttons['当前单测文件'].checked==not restored)
   assert(labels['当前单测：CommandButtonDecorateExplore_Test.j'])
   if mode=='war3lib' then buttons['当前单测文件']:onclick() end
   buttons.InnerJapi:onclick()
  else
   assert(buttons['正式'].checked==true)
   assert(not buttons.InnerJapi and not buttons['空地图'])
  end
  buttons['启动']:onclick()
 end
 dofile('Lua/gui/launcher/main.lua')
 local result=read(arg[1])
 if unitOnly then
  assert(result:find('version=VERSION_UNITTEST',1,true))
  assert(result:find('engine=innerjapi',1,true))
  assert(result:find('scenario='..(mode=='war3lib-empty' and 'empty' or 'current'),1,true))
 else assert(not result:find('engine=',1,true)) end
end
print('PASS: GUI restores engine/scenario, defaults missing/invalid history, selection changes and legacy GUI preserved')
