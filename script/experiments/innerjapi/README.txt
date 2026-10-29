InnerJapi 单人实验

GUI 每次默认 YDLua；主动选择 InnerJapi 后才加载本目录。
修改 init.lua 的 runner.start 模块名选择测试。
测试模块提供 start()/stop()；stop 必须释放自己创建的 UI、计时器和事件。
本地 Lua 控制台可执行 require('script.experiments.innerjapi.runner').reload()。
重载仅清除当前 case 的缓存，依赖修改需要重进地图；不要重载公共初始化。
当前默认关闭控制台，可通过聊天命令 -lua-reload 触发单人实验重载。
DLL、callback 或引擎切换后退出旧游戏进程再启动。
源码在 script 下；不要编辑 UnitTestMap/map 中的生成脚本。
