内置 JAPI 实验运行库

来源：D:/War3/内置JAPI/2026年/war3UI1.49-9/war3UI/package/plugin
只保存 callback、(key)、wenhao_plugin.tga，SHA256SUMS.txt 记录原文件校验值。
GUI 显示 InnerJapi；内部目录保留版本，升级时可隔离旧缓存。

在 War3Lib 运行 VS Code 任务“🥭启动”。首次默认 YDLua，之后记住上次确认的引擎与测试入口。
GUI 显示 UnitTest.h 当前选择的 JASS 文件；测试入口首次默认“当前单测文件”，可改选“空地图”。
空地图使用 Jass/template/EmptyRuntime_Test.j，不执行当前用例，不覆盖 UnitTest.h，仍保留 Lua 实验启动。
空白入口复用 UnitTestMap 的基础地形；它表示不加载业务测试，不承诺删除地图已有地形或预放置物。
引擎及测试入口各有独立地图缓存；切换入口后的第一次使用请选择全量启动。
选择 InnerJapi 后全量启动；增量和老地图启动仅使用同引擎专属地图。
源码地图 UnitTestMap 不永久写入这些资源；打包副本位于 Output/launcher/engines。
由于 w3x2lni 按扩展名分类，tga 在副本中放 resource/，另两项放 map/；MPQ 中三项均在根目录。
不使用 InnerJapi 关键词注入。Jass/YDLua.j 依据本次构建宏选择唯一启动入口。
Lua 实验入口：script/experiments/innerjapi/init.lua。

本地任务配置 .vscode/tasks.json 按仓库现有规则忽略；可直接用以下命令打开同一 GUI：
lua Lua/tasks/TaskLaunch.lua D:/War3 D:/War3/Library/War3Lib D:/WE/KKWE_Plugin

验证：lua Lua/tests/innerjapi_runtime.lua
实际打包后的 MPQ 检查使用 w3x2lni 的 Lua 运行时运行 Lua/tests/innerjapi_mpq.lua，参数为 w3x2lni 根目录及项目目录。
已完成静态/编译/打包验证，游戏内兼容性及性能需要实测。
