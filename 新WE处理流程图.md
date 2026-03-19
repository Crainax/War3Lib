## 换了新的WE后，需要处理的事情

1. 把项目下的`YDWE`文件夹内所有文件替换到`新WE根目录`下
    * YDWE里轮回之狱的冲撞系统`Jass/YDWETimerPattern.j`
    * 2021年修正BUG的任意单位伤害事件系统`Jass/YDWETriggerEvent.j`
    * `jass/japi/`文件下的`YDWEAbilityState.j`和`YDWEJapiOther.j`要删常量
    * `share/script/wave.lua`删掉`--define=USE_BJ_OPTIMIZATION=1`这条容易引起报错的东西,再加入`--define=USE_BJ_ANTI_LEAK=1`这条两次都要调用的定义
    * `share/script/inject.lua`里注入文件尾改成注入文件头
    * `jass/YDWEBase.j`加library_once防止重复导入,`jass/Base/`里面其实没有问题的
2. 把`war3/plugins`里的`jasshelper`里的dll全复制过去
3. 修改`share/script/ydwe_on_save.lua`里的`wave:compile(compile_t)`复制多一份移到inject前面,实行两次预处理.
4. 旧流程里的 `mklink /D "D:\WE\KKWE_Plugin\jass\Crainax" ...` 现在已经不是必需项
    * 当前编译链会在每次编译前自动把 `War3Lib/Jass` 镜像到 `当前项目/.linked/Crainax`
    * Wave 与注入阶段优先吃 `当前项目/.linked/`
    * 不再依赖 `D:\WE\KKWE_Plugin\jass\Crainax`
5. `jass/AntiBJLeak/detail`里所有傻逼YDWE不搞全词匹配改成全词匹配

### 当前编译链新增注意事项

1. `Jass/` 仍然是唯一源码目录，平时只编辑这里
2. `.linked/` 是编译时自动生成/刷新的镜像目录，不要手改
3. 如果出现 `Crainax/...`、`DzAPI...`、`BlizzardAPI...`、`YDWEBase...` 找不到:
    * 先直接重新跑一次编译/启动任务
    * 再不行就删掉 `项目/.linked/` 后重跑，让它整目录重建
4. 目前会自动同步到 `项目/.linked/` 的来源:
    * `War3Lib/Jass` 整体镜像到 `项目/.linked/Crainax`
    * `D:\WE\KKWE_Plugin\jass` 根目录下的 `.j/.h/.cfg`
    * `D:\WE\KKWE_Plugin\jass\japi\`
5. 如果 KKWE 更新后改了根目录文件名、移动了 `japi/` 位置、或者根目录不再放这些 API 文件，就要同步检查 `Lua/compile/Compiler.lua`

## KKWE更新后的处理

1. 抽离`kkwe`这四个j文件和cfg到`YDWE/jass`里覆盖,并更新JassVSC里的内容
    * `BlizzardAPI.j`
    * `DzAPi.j`
    * `KKAPI.j`
    * `KKPRE.j`
2. 更新`share/mpq/`内容到`mpq/`里
3. `YDWE`里面所有内容重新覆盖到`kkwe`里
4. `kkwe`里的`jass/`挑选出.j文件移到War3Lib的API里研究.  (PS:可不需要)
5. 修改`share/script/ydwe_on_save.lua`里的`wave:compile(compile_t)`复制多一份移到inject前面,实行两次预处理.

                    we.show_progress(_("KKWE SaveMap"), 5, _("Execute Wave"))
                    -- Wave预处理
                    if not wave:compile(compile_t) then
                        return nil
                    end
                    compile_t.input = compile_t.output
最下面这句也要复制过去(被坑惨了)

### KKWE更新后现在要额外确认的文件

1. 下面这些文件会在编译前自动以 `D:\WE\KKWE_Plugin\jass` 为准同步到 `项目/.linked/`
    * `BlizzardAPI.cfg`
    * `BlizzardAPI.j`
    * `DzAPI.cfg`
    * `DzAPI.j`
    * `KKAPI.cfg`
    * `KKAPI.j`
    * `KKPRE.cfg`
    * `KKPRE.j`
2. `D:\WE\KKWE_Plugin\jass\japi\` 整个目录也会被同步
3. 所以 KKWE 更新后至少要做一次完整编译，让 `.linked` 刷成新版本
4. 如果这些文件的函数签名、库名、目录层级发生变化，要优先检查:
    * `Lua/compile/Compiler.lua`
    * `Lua/compile/Inject.lua`
5. 当前策略是:
    * `Crainax` 相关代码以 `War3Lib/Jass` 为主
    * `BlizzardAPI/DzAPI/KKAPI/KKPRE/japi` 以 `D:\WE\KKWE_Plugin\jass` 为主



## 换了新电脑后，需要处理的事情

1. 先确认 `.vscode/settings.json` 里的:
    * `War3RootPath`
    * `WEPath`
2. 确认 `D:\WE\KKWE_Plugin\jass\` 与 `D:\War3\plugins\` 结构完整
3. 第一次编译任意项目时，观察 `项目/.linked/` 是否自动生成
4. 现在不需要再手动创建 `Crainax` 的 `mklink`


## 新建项目后要做的事
1. 创建`Mklink` : `mklink /D "D:\War3\Maps\PhantomOrbit\script\depends" "D:\War3\Library\War3Lib\script\depends" `
2. 只要新项目的任务仍然调用 `War3Lib/Lua/tasks/TaskCompile.lua` / `TaskStartMap.lua`，`项目/.linked/Crainax` 会在首次编译时自动生成
3. 新项目不需要手动创建 `Crainax` 相关 `mklink`
4. 新项目第一次编译后建议确认这些目录是否出现:
    * `项目/.linked/Crainax`
    * `项目/.linked/japi`
