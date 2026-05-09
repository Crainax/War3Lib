local hook = require 'jass.hook'

function hook.CrainaxLuaDzWriteLog(msg)
    print(tostring(msg or ''))
end

return true
