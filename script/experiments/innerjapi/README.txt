InnerJapi 单人实验

GUI 首次默认 YDLua，之后恢复上次确认的引擎和测试入口；选择 InnerJapi 时加载本目录。
修改 init.lua 的 runner.start 模块名选择测试。
测试模块提供 start()/stop()；stop 必须释放自己创建的 UI、计时器和事件。
本地 Lua 控制台可执行 require('script.experiments.innerjapi.runner').reload()。
重载仅清除当前 case 的缓存，依赖修改需要重进地图；不要重载公共初始化。
当前默认关闭控制台，可通过聊天命令 -lua-reload 触发单人实验重载。
DLL、callback 或引擎切换后退出旧游戏进程再启动。
源码在 script 下；不要编辑 UnitTestMap/map 中的生成脚本。

HTTP 对比测试（当前默认用例）
1. 当前入口为 cases/http_post.lua，请求 http://httpbin.org/post，不需要本机服务器。
2. 打开“🥭启动”，选择 InnerJapi + 空地图；首次使用全量启动，单人进入地图。
3. 用例发送固定字符串 ping-from-innerjapi，核对 JSON 的 data 原始文本或 form 表单回显字段。
4. 日志出现 [HTTP测试]PASS：HTTP请求与httpbin回显内容正确，表示本次通信成功。
5. 修改当前用例后保存，聊天输入 -lua-reload 重试；公共服务不要高频请求。
6. 空字符串、异常响应或无回调不代表成功，请保留完整日志排查。
Lua/tests/innerjapi_http.lua 使用模拟接口验证生命周期，不代替内置引擎实际联网。
Lua/tests/http_echo_server.py 保留用于本机HTTP测试；若切回它，需同步修改URL与响应校验规则。

本轮对比：curl对HTTP与HTTPS均成功；内置引擎HTTP返回表单回显，HTTPS立即返回空字符串。
静态分析确认1.49-9的post_message所用libcurl没有HTTPS协议和SSL后端，且请求错误未传给Lua。
切回HTTPS只需修改http_post.lua中的URL，日志协议名称会随URL更新。
