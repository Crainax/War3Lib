-- 模拟接口只验证用例行为；真实网络由游戏内 post_message 验证。
local originalPrint = print
local logs, callbacks = {}, {}
print = function(message) logs[#logs + 1] = tostring(message) end
package.lua_engine = 'innerjapi'
post_message = function(url, body, callback)
    assert(url == 'http://httpbin.org/post')
    assert(body == 'ping-from-innerjapi')
    callbacks[#callbacks + 1] = callback
end
local runner = require 'script.experiments.innerjapi.runner'
local name = 'script.experiments.innerjapi.cases.http_post'
runner.start(name)
callbacks[1]('{"data": "ping-from-innerjapi", "url": "http://httpbin.org/post"}')
assert(logs[#logs]:find('PASS', 1, true))
local count = #logs
callbacks[1]('duplicate')
assert(#logs == count, '重复回调必须忽略')

runner.start(name)
runner.reload()
count = #logs
callbacks[2]('old response')
assert(#logs == count, '重载后旧回调必须忽略')
callbacks[3]('{"data": "wrong response", "error": "ping-from-innerjapi"}')
assert(logs[#logs]:find('FAIL', 1, true))

runner.start(name)
callbacks[4](nil)
assert(logs[#logs]:find('异常响应类型', 1, true))
runner.start(name)
runner.stop()
count = #logs
callbacks[5]('{"data": "ping-from-innerjapi", "url": "http://httpbin.org/post"}')
assert(#logs == count, '停止后回调必须忽略')

-- 1.49-9实测表单响应，以及避免把无关位置的字符串当成成功。
for _, fixture in ipairs({
    {'{"data":"","form":{"ping-from-innerjapi":""}}', true},
    {'{ "form": {\n  "ping-from-innerjapi" : ""\n }, "data": "" }', true},
    {'{"data":"","form":{"other":"ping-from-innerjapi"}}', false},
    {'{"data":"","form":{"ping-from-innerjapi":"wrong"}}', false},
    {'{"data":"","form":{},"error":"ping-from-innerjapi"}', false},
    {'', false},
}) do
    runner.start(name)
    callbacks[#callbacks](fixture[1])
    assert((logs[#logs]:find('PASS', 1, true) ~= nil) == fixture[2], fixture[1])
    runner.stop()
end

post_message = function() error('mock dispatch failure') end
assert(not pcall(runner.start, name), '同步调用异常应传给runner')
post_message = nil
assert(not pcall(runner.start, name), '接口缺失应报错')
package.lua_engine = 'ydlua'
assert(not pcall(runner.start, name), '错误引擎应报错')
print = originalPrint
print('PASS: HTTP request, response, duplicate/late callbacks, reload, stop and failure handling')
