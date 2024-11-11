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
4. 创建`Mklink` : `mklink /D "D:\WE\KKWE_Plugin\jass\Crainax" "D:\War3\Library\War3Lib\Jass"`
5. `jass/AntiBJLeak/detail`里所有傻逼YDWE不搞全词匹配改成全词匹配

## KKWE更新后的处理

1. `jass/BlizzardAPI.j`里里对比diff后看看要不要更新,并加入UI的宏定义.
2. 抽离`kkwe`这四个j文件和cfg到`YDWE/jass`里覆盖:
    * `BlizzardAPI.j`
    * `DzAPi.j`
    * `KKAPI.j`
    * `KKPRE.j`
3. 更新`share/mpq/`内容到`mpq/`里
4. `YDWE`里面所有内容重新覆盖到`kkwe`里
5. `kkwe`里的`jass/`挑选出.j文件移到War3Lib的API里研究.
5. 创建`Mklink` : `mklink /D "D:\WE\KKWE_Plugin\jass\Crainax" "D:\War3\Library\War3Lib\Jass"`



## 换了新电脑后，需要处理的事情


## 新建项目后要做的事
