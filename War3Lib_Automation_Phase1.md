
# War3Lib 自动化测试系统 - 第一阶段实施方案

## 一、当前 War3Lib 现状分析

你当前的启动链路：

```text
TaskLaunch.lua
    ↓
Launcher.StartWar3()
    ↓
YDWEConfig.exe -launchwar3 -loadfile xxx.w3x
    ↓
War3 启动并直接加载地图
```

当前实现位置：

- `Lua/compile/Launcher.lua`
- `Lua/tasks/TaskLaunch.lua`

目前已经具备：

- Lua 任务系统
- War3 自动启动
- 自动加载地图
- 日志等待与打开
- Antigravity 集成
- 构建流程

这意味着：

```text
War3Lib 已经拥有“任务编排层”
```

缺少的是：

```text
War3 自动化执行层
```

也就是：

- 自动点击局域网
- 自动创建游戏
- 自动加入房间
- 自动开始游戏
- 自动双开
- 自动窗口管理
- 图像识别

---

# 二、推荐架构（最终目标）

推荐架构：

```text
Lua（任务系统）
    ↓
Python（自动化执行层）
    ↓
OpenCV + pywin32
    ↓
War3
```

职责划分：

## Lua

负责：

- 编译
- 构建
- 启动任务
- 自动化任务编排
- 参数配置

## Python

负责：

- 图像识别
- 窗口控制
- 鼠标键盘
- War3 双开
- 自动建房
- 自动加入
- 自动开始

---

# 三、阶段划分

# 第一阶段（当前阶段）

目标：

```text
实现：
启动 War3
自动进入局域网
自动创建游戏
自动开始
```

仅控制：

```text
1 个 War3 窗口
```

暂时不做：

- 双开
- 自动加入
- OCR
- 网络层
- hostbot
- 平台协议

这是：

```text
最小可运行版本（MVP）
```

---

# 四、第一阶段目录结构

建议新增：

```text
War3Lib/
│
├─ Python/
│   ├─ war3auto/
│   │   ├─ main.py
│   │   ├─ launcher.py
│   │   ├─ window.py
│   │   ├─ image.py
│   │   ├─ input.py
│   │   ├─ workflow.py
│   │   └─ config.py
│   │
│   ├─ assets/
│   │   ├─ lan_button.png
│   │   ├─ custom_game.png
│   │   ├─ create_game.png
│   │   └─ start_game.png
│   │
│   └─ requirements.txt
│
└─ Lua/
    └─ compile/
        └─ Automation.lua
```

---

# 五、开发环境准备

# 1. 安装 Python

推荐版本：

```text
Python 3.11.x
```

下载：

https://www.python.org/downloads/

安装时必须勾选：

```text
Add Python to PATH
```

验证：

```bash
python --version
```

---

# 2. 创建虚拟环境

进入：

```text
War3Lib/Python
```

执行：

```bash
python -m venv .venv
```

激活：

## Windows PowerShell

```powershell
.venv\Scripts\Activate.ps1
```

## CMD

```cmd
.venv\Scripts\activate.bat
```

---

# 3. 安装依赖

创建：

```text
requirements.txt
```

内容：

```txt
opencv-python
numpy
pyautogui
pywin32
Pillow
mss
```

安装：

```bash
pip install -r requirements.txt
```

---

# 六、第一阶段功能目标

# 目标流程

```text
启动 War3
↓
等待窗口出现
↓
识别“局域网”
↓
点击“局域网”
↓
识别“创建游戏”
↓
点击“创建游戏”
↓
识别“开始游戏”
↓
点击“开始游戏”
```

---

# 七、第一阶段模块设计

# 1. launcher.py

负责：

```text
启动 War3
```

接口：

```python
launch_war3()
```

功能：

- 调用当前 Launcher.lua 的逻辑
- 或直接调用 YDWEConfig.exe
- 返回 PID

---

# 2. window.py

负责：

```text
窗口管理
```

接口：

```python
find_war3_window()
activate_window()
move_window()
resize_window()
```

使用：

```text
pywin32
```

---

# 3. image.py

负责：

```text
图像识别
```

接口：

```python
find_image()
wait_image()
```

实现：

```text
OpenCV 模板匹配
```

---

# 4. input.py

负责：

```text
鼠标键盘输入
```

接口：

```python
click()
click_center()
press_key()
```

---

# 5. workflow.py

负责：

```text
自动化流程
```

接口：

```python
goto_lan()
create_game()
start_game()
```

---

# 八、第一阶段技术方案

# 不使用 OCR

第一阶段：

```text
只使用模板匹配
```

原因：

- UI 固定
- 按钮固定
- 更简单
- 更稳定

---

# 不使用后台点击

第一阶段：

```text
只使用前台窗口
```

原因：

- 简单稳定
- 调试方便
- 问题少

---

# 不使用 Hook

禁止：

- game.dll hook
- war3.exe 注入
- 平台 DLL 注入

仅使用：

```text
Windows 正常窗口自动化
```

---

# 九、第一阶段截图素材制作

需要自己截取：

```text
局域网按钮
创建游戏按钮
开始游戏按钮
```

要求：

```text
PNG
无压缩
原始分辨率
```

放入：

```text
Python/assets/
```

---

# 十、第一阶段窗口规范

推荐：

```text
War3 窗口化
固定分辨率
```

例如：

```text
1280x720
```

这样：

```text
识图稳定
```

推荐启动参数：

```text
-windowmode windowed
```

---

# 十一、Lua 与 Python 的连接

新增：

```text
Lua/compile/Automation.lua
```

内容：

```lua
local automation = {}

automation.Run = function()
    local cmd = "python Python/war3auto/main.py"
    os.execute(cmd)
end

return automation
```

---

# 十二、TaskLaunch.lua 修改方案

后续：

```lua
local launcher = require("lua.compile.Launcher")
local automation = require("lua.compile.Automation")

launcher.StartWar3()

automation.Run()
```

---

# 十三、第一阶段验收标准

完成以下目标：

## 成功标准

能够：

- 自动启动 War3
- 自动点击局域网
- 自动点击创建游戏
- 自动点击开始游戏

成功率：

```text
90%+
```

---

# 十四、阶段二（未来）

阶段二目标：

```text
双开
自动加入
自动开始
```

新增：

- 多窗口管理
- PID绑定
- 房间识别
- 自动加入逻辑

---

# 十五、阶段三（未来）

阶段三：

```text
OCR
状态检测
失败恢复
自动重试
```

---

# 十六、阶段四（未来）

阶段四：

```text
真正完整的 War3 自动化测试框架
```

包括：

- 自动录像
- 自动截图
- 自动测试任务
- 自动 Debug
- 自动性能统计

---

# 十七、Codex 实施建议

建议：

```text
一次只实现一个模块
```

顺序：

```text
launcher.py
→ window.py
→ image.py
→ input.py
→ workflow.py
→ main.py
```

不要一开始：

- 做双开
- 做 OCR
- 做网络层
- 做 hostbot

---

# 十八、推荐实现顺序（极重要）

# 第一步

实现：

```text
启动 War3
找到窗口
```

---

# 第二步

实现：

```text
截图
模板匹配
```

---

# 第三步

实现：

```text
点击按钮
```

---

# 第四步

实现：

```text
完整自动流程
```

---

# 十九、最终目标（长期）

未来理想状态：

```bash
lua TaskLaunch.lua autotest
```

自动完成：

```text
编译地图
启动War3
双开
自动建房
自动加入
自动开始
进入测试
```

达到：

```text
War3 一键自动测试
```
