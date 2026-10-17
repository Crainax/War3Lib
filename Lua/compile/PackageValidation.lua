local path = require 'Lua.path'
local fu = require 'Lua.utils.FileUtils'
local validation = {}

-- Opt in per project; existing projects retain their current packaging policy.
function validation.enabled()
    return fu.fileExist(path.project .. '/config/validate-packed-jass.enabled')
end

function validation.check(mapPath, reportPath)
    if not validation.enabled() then return true end
    local root = path.toolRoot .. '/w3x2lni'
    local cmd = string.format('"%s/bin/w3x2lni-lua.exe" "%s/Lua/tasks/TaskValidatePackedMap.lua" "%s" "%s" "%s" "%s" "%s"',
        root, path.libRoot, root, mapPath, path.project .. '/output',
        path.root .. '/plugins/jasshelper', reportPath or '')
    local ok, kind, code = os.execute('"' .. cmd .. '"')
    if ok == true or ok == 0 or (kind == 'exit' and code == 0) then return true end
    print('[打包检查]失败，停止启动地图。')
    return false
end

return validation
