-- 模拟接口只验证用例行为；真实网络由游戏内 post_message 验证。
local originalPrint = print
local logs, callbacks = {}, {}
print = function(message) logs[#logs + 1] = tostring(message) end
package.lua_engine = 'innerjapi'
post_message = function(url, body, callback)
    assert(url == 'http://127.0.0.1:18080/test')
    assert(body == 'ping-from-innerjapi')
    callbacks[#callbacks + 1] = callback
end
local runner = require 'script.experiments.innerjapi.runner'
local name = 'script.experiments.innerjapi.cases.http_post'
runner.start(name)
callbacks[1]('ok:ping-from-innerjapi')
assert(logs[#logs]:find('PASS', 1, true))
local count = #logs
callbacks[1]('duplicate')
assert(#logs == count, '重复回调必须忽略')

runner.start(name)
runner.reload()
count = #logs
callbacks[2]('old response')
assert(#logs == count, '重载后旧回调必须忽略')
callbacks[3]('wrong response')
assert(logs[#logs]:find('FAIL', 1, true))

runner.start(name)
callbacks[4](nil)
assert(logs[#logs]:find('异常响应类型', 1, true))
runner.start(name)
runner.stop()
count = #logs
callbacks[5]('ok:ping-from-innerjapi')
assert(#logs == count, '停止后回调必须忽略')

post_message = function() error('mock dispatch failure') end
assert(not pcall(runner.start, name), '同步调用异常应传给runner')
post_message = nil
assert(not pcall(runner.start, name), '接口缺失应报错')
package.lua_engine = 'ydlua'
assert(not pcall(runner.start, name), '错误引擎应报错')
print = originalPrint
print('PASS: HTTP request, response, duplicate/late callbacks, reload, stop and failure handling')
