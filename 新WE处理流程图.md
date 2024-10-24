## 换了新的WE后，需要处理的事情

1. 把项目下的`YDWE`文件夹内所有文件替换到`新WE根目录`下
    * YDWE里轮回之狱的冲撞系统`Jass/YDWETimerPattern.j`
    * 2021年修正BUG的任意单位伤害事件系统`Jass/YDWETriggerEvent.j`
    * `jass/japi/`文件下的`YDWEAbilityState.j`和`YDWEJapiOther.j`看下要不要删常量.
    * `share/script/wave.lua`删掉`--define=USE_BJ_OPTIMIZATION=1`这条容易引起报错的东西
    *`jass/YDWEBase.j`加library_once防止重复导入,`jass/Base/`里面其实没有问题的

2. 把`war3/plugins`里的`jasshelper`里的dll全复制过去

## KKWE更新后的处理

1. 抽离`kkwe`这四个j文件和cfg到`YDWE/jass`里覆盖:
    * `BlizzardAPI.j`
    * `DzAPi.j`
    * `KKAPI.j`
    * `KKPRE.j`
2. 更新`share/mpq/`内容到`mpq/`里
3. `YDWE`里面所有内容重新覆盖到`kkwe`里
4. `kkwe`里的`jass/`内容转到项目文件夹里的`plugins/wave/`里


## 换了新电脑后，需要处理的事情

1. 把`war3/maps`里的所有地图文件复制到新电脑的`war3/maps`里
2. 把`war3/replay`里的所有录像文件复制到新电脑的`war3/replay`里
3. 把`war3/save`里的所有存档文件复制到新电脑的`war3/save`里
