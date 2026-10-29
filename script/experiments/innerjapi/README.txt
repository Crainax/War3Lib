InnerJapi 单人实验

GUI 每次默认 YDLua；主动选择 InnerJapi 后才加载本目录。
修改 init.lua 的 runner.start 模块名选择测试。
测试模块提供 start()/stop()；stop 必须释放自己创建的 UI、计时器和事件。
本地 Lua 控制台可执行 require('script.experiments.innerjapi.runner').reload()。
重载仅清除当前 case 的缓存，依赖修改需要重进地图；不要重载公共初始化。
当前默认关闭控制台，可通过聊天命令 -lua-reload 触发单人实验重载。
DLL、callback 或引擎切换后退出旧游戏进程再启动。
源码在 script 下；不要编辑 UnitTestMap/map 中的生成脚本。

HTTP 网络测试（当前默认用例）
1. 在项目根目录终端运行：python Lua/tests/http_echo_server.py
2. 打开启动GUI，选择 InnerJapi；首次使用全量启动，单人进入地图。
3. 服务器应收到 POST /test 和 ping-from-innerjapi，项目日志应出现 [HTTP测试]PASS。
4. 修改 cases/http_post.lua 并保存，聊天输入 -lua-reload 再发一次请求。
5. 测试迟到响应时，先停止服务器，再用 --delay 3 启动；发请求后立即重载。
   旧请求仍可能到达服务器，但旧回调不会再打印结果。不要高频连续重载。
6. Ctrl+C 停止服务器，再重载可观察连接失败行为；没有回调不能判断为成功。
服务器仅监听 127.0.0.1，不需要安装 Python 第三方依赖；不会随地图打包。
用例只记录网络结果，不改变单位、奖励等游戏状态。本机 HTTP 成功不等于 HTTPS 或远程服务通过。
Lua/tests/innerjapi_http.lua 使用模拟接口验证生命周期，不代替实际内置引擎联网测试。
