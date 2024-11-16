# War3Lib

这是我个人的魔兽争霸3地图开发工具库。
当前版本 0.0.6

## 简介

War3Lib 是一个用于开发魔兽争霸3地图的工具库。它提供了编译脚本、任务管理等功能,可以帮助开发者更高效地创建和管理魔兽争霸3地图项目。

## 特点

- 强大的编译功能
- 灵活的任务管理系统
- 支持多个项目和地图
- 开源分享
- 完善的调试工具集

## 如何使用

1. 克隆仓库
2. 安装所需的依赖(如 LuaFileSystem)
3. 在命令行中运行编译任务:
   ```
   lua Lua/tasks/TaskCompile.lua <项目根目录> <地图名称>
   ```

## 主要组件

- `Compiler.lua`: 负责编译流程,包括Wave预处理、Lua处理和JassHelper编译
- `TaskCompile.lua`: 编译任务的入口点,处理命令行参数并调用编译器
- `depends/`: 常用工具库目录
  - `debug/`: 调试工具集
    - `logger.lua`: 日志系统
    - `memory_leak.lua`: 内存泄露检测
    - `hero_detector.lua`: 英雄数据检测
    - `struct_detector.lua`: 结构体检测
  - `init.lua`: 基础初始化
  - `slkutils.lua`: SLK数据工具
  - `w2s.lua`: 坐标转换工具
  - `IOUtils.lua`: IO操作工具

## 项目结构

```
War3Lib/
│
├── Lua/
│   ├── compile/                              # 编译相关模块
│   │   ├── Compiler.lua                      # 核心编译器,处理地图编译流程
│   │   ├── TestControl.lua                   # 测试控制器,管理测试版本和环境
│   │   ├── UTReplace.lua                     # 单元测试替换工具
│   │   ├── W3xLni.lua                        # 地图格式转换工具
│   │   ├── Inject.lua                        # 代码注入工具
│   │   └── Launcher.lua                      # 游戏启动器
│   ├── tasks/                                # 任务管理模块
│   │   ├── TaskCompile.lua                   # 编译任务
│   │   ├── TaskCreateUT.lua                  # 单元测试创建
│   │   ├── TaskLNI.lua                       # 地图LNI格式转换
│   │   ├── TaskOBJ.lua                       # 物编重构建
│   │   ├── TaskLaunch.lua                    # 游戏启动
│   │   └── TaskStartMap.lua                  # 地图启动(支持多版本)
│   ├── tools/                                # 工具类模块
│   │   └── Backuper.lua                      # 文件备份还原工具
│   ├── model/                                # 模型处理相关
│   │   ├── 1.32模型处理.lua                  # 1.32版本模型适配工具
│   │   ├── 转移模型.lua                      # 模型迁移工具
│   │   ├── 模型第1步_FBX.lua                 # FBX模型转换工具
│   │   ├── 模型第3步_压缩.lua                # 模型压缩工具
│   │   ├── 模型测试.lua                      # 模型效果测试工具
│   │   └── 寻找模型贴图.lua                  # 模型贴图提取工具
│   ├── image/                                # 图片处理工具
│   │   ├── ImageUtils.lua                    # 图片处理工具集
│   │   └── GIF生成器.lua                     # GIF动图制作工具
│   ├── utils/                                # 通用工具类
│   │   ├── FileUtils.lua                     # 文件操作工具
│   │   └── copy.lua                          # 文件复制工具
│   └── path.lua                              # 项目路径管理器
│
├── jass/
│   ├── core/                                 # 核心模块
│   │   ├── constant/                         # 常量定义
│   │   │   └── UNDefine.j                    # 单位相关常量定义
│   │   └── structs/                          # 核心数据结构
│   │       └── RandSet.j                     # 随机集合工具(不重复随机数)
│   ├── utils/                                # 实用工具集
│   │   ├── combat/                           # 战斗相关工具
│   │   │   ├── DamageUtils.j                 # 伤害计算工具
│   │   │   ├── DamageUtils.cfg              # 伤害系统配置
│   │   │   ├── GroupUtils.j                 # 单位组操作工具
│   │   │   └── GroupUtils.cfg               # 单位组系统配置
│   │   ├── unit/                            # 单位相关工具
│   │   │   ├── UnitUtils.j                  # 单位操作工具集
│   │   │   ├── UnitFilter.j                 # 单位筛选器
│   │   │   └── UnitFilter.cfg               # 单位筛选配置
│   │   ├── debug/                           # 调试工具集
│   │   │   ├── Logger.j                     # 日志系统(支持5个级别输出)
│   │   │   ├── MemoryLeak.j                 # 内存泄露检测工具
│   │   │   └── StructDetector.j             # 结构体检测工具
│   │   └── math/                            # 数学计算工具
│   │       ├── NumberUtils.j                # 数值计算工具集
│   │       └── MapBoundsUtils.j             # 地图边界计算工具
│   │   ├── ConversionUtils.j                # 数据类型转换工具
│   │   └── ConversionUtils.cfg              # 转换工具配置
│   ├── template/                            # 测试模板文件
│   │   ├── MTTemplate.j                     # 模型测试模板
│   │   ├── UTTemplate.j                     # 单元测试模板
│   │   └── UTTemplate2.j                    # 高级单元测试模板(可视化)
│   └── InnerJapi.j                          # 内部JAPI接口定义
│
├── README.md                                # 项目说明文档
├── CHANGELOG.md                             # 更新日志
└── 编译流程图.MD                            # 编译流程说明文档
```

## 模板文件说明

- `MTTemplate.j`: 模型测试模板文件
- `UTTemplate.j`: 单元测试模板文件
- `UTTemplate2.j`: 高级单元测试模板文件，包含可视化测试模块

## 贡献

欢迎提出建议和改进意见。如果您有任何想法,请随时提交 Issue 或 Pull Request。

## 许可

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 最新更新

v0.0.6 版本主要更新：
- 完善了依赖注入系统
- 修复了重复注入文件的问题
- 优化了路径处理机制
- 增强了调试功能
