# War3Lib

这是我个人的魔兽争霸3地图开发工具库。
当前版本 0.0.1

## 简介

War3Lib 是一个用于开发魔兽争霸3地图的工具库。它提供了编译脚本、任务管理等功能,可以帮助开发者更高效地创建和管理魔兽争霸3地图项目。

## 特点

- 强大的编译功能
- 灵活的任务管理系统
- 支持多个项目和地图
- 开源分享

## 如何使用

1. 克隆仓库
2. 安装所需的依赖(如 LuaFileSystem)
3. 在命令行中运行编译任务:
   ```
   lua Lua/tasks/TaskCompile.lua <项目根目录> <地图名称>
   ```

## 主要组件

- `Compiler.lua`: 负责编译流程,包括Wave预处理、Lua处理和JassHelper编译
- `TaskCompile.lua`: 编译任务的入口点,处理命令行参数并调用编译器(参数1:War3目录,参数2:地图名称)

## 项目结构

```
War3Lib/
│
├── Lua/
│   ├── compile/
│   │   └── Compiler.lua
│   ├── tasks/
│   │   └── TaskCompile.lua
│   ├── utils/
│   │   └── FileUtils.lua
│   └── path.lua
│
├── README.md
├── CHANGELOG.md
└── 编译流程图.MD
```

## 贡献

欢迎提出建议和改进意见。如果您有任何想法,请随时提交 Issue 或 Pull Request。

## 许可

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。
