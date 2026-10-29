local M = {}
function M.start()
    assert(package.lua_engine == 'innerjapi', '此用例需要InnerJapi')
    print('[InnerJapi实验]Hello, ' .. tostring(_VERSION))
end
function M.stop()
    -- Destroy all UI, timers and event registrations owned by this case here.
end
return M
