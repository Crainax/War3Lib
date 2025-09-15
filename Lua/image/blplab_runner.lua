--[[
 BLPLab 运行模块

 功能:
  - 暴露一个 run(base_path, blplab_config) 函数
  - 接收一个基础路径, 并自动拼接出 source 和 dest 文件夹
  - 修改 blplab.ini 文件
  - 创建目标文件夹
  - 启动 blplab.exe
--]]

local BlpRunner = {}

function BlpRunner.run(base_icon_path, blplab_config)
    if not base_icon_path or not blplab_config then
        print("错误 [blplab_runner]: 调用 run 函数时未提供足够的参数。")
        return
    end

    -- 根据传入的基础路径, 动态构建新的源和目标文件夹路径
    local new_source_folder = base_icon_path .. "output\\"
    local new_dest_folder   = base_icon_path .. "blp\\"

    -- 1. 读取INI文件
    print("正在读取配置文件: " .. blplab_config.ini_file)
    local file = io.open(blplab_config.ini_file, "r")
    if not file then
        print("错误: 无法打开配置文件. 请检查路径: " .. blplab_config.ini_file)
        return
    end

    local new_lines = {}
    for line in file:lines() do
        if line:match("^SourceFolder=") then
            table.insert(new_lines, "SourceFolder=" .. new_source_folder)
        elseif line:match("^DestFolder=") then
            table.insert(new_lines, "DestFolder=" .. new_dest_folder)
        else
            table.insert(new_lines, line)
        end
    end
    file:close()
    print("  -> 已将 SourceFolder 修改为: " .. new_source_folder)
    print("  -> 已将 DestFolder 修改为: " .. new_dest_folder)

    -- 2. 写回INI文件
    print("正在写回更新后的配置...")
    local output_file = io.open(blplab_config.ini_file, "w")
    if not output_file then
        print("错误: 无法写入配置文件. 请检查文件权限。")
        return
    end
    output_file:write(table.concat(new_lines, "\n"))
    output_file:close()
    print("配置文件更新成功!")

    -- 3. 创建目标文件夹
    print("正在创建目标 BLP 文件夹: " .. new_dest_folder)
    os.execute('mkdir "' .. new_dest_folder .. '" > nul 2>&1')
    print("文件夹准备就绪。")

    -- 4. 启动程序
    print("正在启动 BLPLab...")
    local launch_cmd = 'start "" "' .. blplab_config.exe .. '"'
    os.execute(launch_cmd)
    print("BLPLab 已启动!")
end

return BlpRunner
