-- 每次 start/reload 只发一次请求；网络结果只记录日志。
local M = {}
local generation = 0
local active = false

local URL = 'http://127.0.0.1:18080/test'
local BODY = 'ping-from-innerjapi'

function M.start()
    assert(package.lua_engine == 'innerjapi', '请在启动GUI中选择 InnerJapi')
    assert(type(_G.post_message) == 'function', '当前运行时没有提供 post_message')

    generation = generation + 1
    local requestGeneration = generation
    active = true
    local finished = false
    print('[HTTP测试]发送请求: ' .. URL)

    local ok, err = pcall(function()
        post_message(URL, BODY, function(result)
            -- 旧请求无法取消，但停止/重载后不能再处理它的响应。
            if not active or generation ~= requestGeneration or finished then
                return
            end
            finished = true
            if type(result) ~= 'string' then
                print('[HTTP测试]FAIL：异常响应类型: ' .. type(result))
                return
            end
            print('[HTTP测试]响应字节数: ' .. #result)
            print('[HTTP测试]响应内容: ' .. result:sub(1, 512))
            if result == 'ok:' .. BODY then
                print('[HTTP测试]PASS：请求与响应内容正确')
            else
                print('[HTTP测试]FAIL：响应与预期不符')
            end
        end)
    end)
    if not ok then
        active = false
        error('[HTTP测试]调用失败: ' .. tostring(err))
    end
    if not finished then
        print('[HTTP测试]等待异步响应；无回调不代表成功，请同时检查服务器终端')
    end
end

function M.stop()
    active = false
    generation = generation + 1
    print('[HTTP测试]已停止处理当前用例的响应')
end

return M
