--[[
 BLPLab 运行模块

 功能:
  - 暴露一个 run(base_path, blplab_config) 函数
  - 接收一个基础路径, 并自动拼接出 source 和 dest 文件夹
  - 优先使用 blpnetcl.exe 静默转换
  - 可选回退: 修改 blplab.ini 并启动 blplab.exe
--]]

local BlpRunner = {}

local DEFAULT_CLI_ARGS = "--type 0 --mipmap 10 --quality 98 --alpha 2"

local SUPPORTED_EXT = {
    png = true,
    bmp = true,
    jpg = true,
    jpeg = true,
    tga = true,
    dds = true,
    gif = true,
    webp = true
}

local function file_exists(path)
    local file = io.open(path, "rb")
    if file then
        file:close()
        return true
    end
    return false
end

local function ensure_trailing_slash(path)
    if path:sub(-1) ~= "\\" and path:sub(-1) ~= "/" then
        return path .. "\\"
    end
    return path
end

local function join_path(path, file)
    return ensure_trailing_slash(path) .. file
end

local function get_ext(file_name)
    local ext = file_name:match("%.([^%.]+)$")
    if not ext then
        return nil
    end
    return string.lower(ext)
end

local function get_stem(file_name)
    return file_name:match("(.+)%.[^%.]+$") or file_name
end

local function ensure_dir(path)
    os.execute('mkdir "' .. path .. '" > nul 2>&1')
end

local function get_dir_name(path)
    return path:match("^(.*)[/\\][^/\\]+$")
end

local function resolve_blpnetcl(blplab_config)
    local candidates = {}

    if blplab_config.cli_exe then
        table.insert(candidates, blplab_config.cli_exe)
    end

    if blplab_config.exe then
        local blplab_dir = get_dir_name(blplab_config.exe)
        if blplab_dir then
            table.insert(candidates, blplab_dir .. "\\BLP.NET.CL\\BLP.NET\\blpnetcl.exe")
            table.insert(candidates, blplab_dir .. "\\blpnetcl.exe")
        end
    end

    for _, candidate in ipairs(candidates) do
        if file_exists(candidate) then
            return candidate
        end
    end

    return nil
end

local function collect_source_files(source_folder)
    local files = {}
    local source = ensure_trailing_slash(source_folder)
    local cmd = 'dir /b /a-d "' .. source .. '*.*"'
    local handle = io.popen(cmd)
    if not handle then
        return files
    end

    for file_name in handle:lines() do
        local ext = get_ext(file_name)
        if ext and SUPPORTED_EXT[ext] then
            table.insert(files, file_name)
        end
    end
    handle:close()

    return files
end

local function run_blpnetcl_batch(source_folder, dest_folder, blplab_config)
    local cli_exe = resolve_blpnetcl(blplab_config)
    if not cli_exe then
        return false, "未找到 blpnetcl.exe，请在 blplab_config.cli_exe 指定路径。"
    end

    ensure_dir(dest_folder)

    local files = collect_source_files(source_folder)
    if #files == 0 then
        return true, "源目录中没有可转换文件。"
    end

    local cli_args = blplab_config.cli_args or ""
    if cli_args == "" then
        cli_args = DEFAULT_CLI_ARGS
    end
    local source = ensure_trailing_slash(source_folder)
    local dest = ensure_trailing_slash(dest_folder)

    local converted = 0
    local failed = 0

    print("使用 CLI 静默转换: " .. cli_exe)
    for _, file_name in ipairs(files) do
        local input_file = join_path(source, file_name)
        local output_file = join_path(dest, get_stem(file_name) .. ".blp")

        local cmd = 'cmd /c ""' .. cli_exe .. '" "' .. input_file .. '" "' .. output_file .. '"'
        if cli_args ~= "" then
            cmd = cmd .. " " .. cli_args
        end
        cmd = cmd .. '"'

        os.execute(cmd)
        if file_exists(output_file) then
            converted = converted + 1
        else
            failed = failed + 1
            print("  [失败] " .. file_name)
        end
    end

    if failed > 0 then
        return false, "成功 " .. converted .. " 个，失败 " .. failed .. " 个。"
    end

    return true, "成功转换 " .. converted .. " 个文件。"
end

local function run_gui_fallback(source_folder, dest_folder, blplab_config)
    -- 1. 读取INI文件
    print("正在读取配置文件: " .. blplab_config.ini_file)
    local file = io.open(blplab_config.ini_file, "r")
    if not file then
        print("错误: 无法打开配置文件. 请检查路径: " .. blplab_config.ini_file)
        return false
    end

    local new_lines = {}
    for line in file:lines() do
        if line:match("^SourceFolder=") then
            table.insert(new_lines, "SourceFolder=" .. source_folder)
        elseif line:match("^DestFolder=") then
            table.insert(new_lines, "DestFolder=" .. dest_folder)
        else
            table.insert(new_lines, line)
        end
    end
    file:close()

    -- 2. 写回INI文件
    print("正在写回更新后的配置...")
    local output_file = io.open(blplab_config.ini_file, "w")
    if not output_file then
        print("错误: 无法写入配置文件. 请检查文件权限。")
        return false
    end
    output_file:write(table.concat(new_lines, "\n"))
    output_file:close()
    print("配置文件更新成功!")

    -- 3. 创建目标文件夹
    print("正在创建目标 BLP 文件夹: " .. dest_folder)
    ensure_dir(dest_folder)
    print("文件夹准备就绪。")

    -- 4. 启动程序
    print("正在启动 BLPLab...")
    local launch_cmd = 'start "" "' .. blplab_config.exe .. '"'
    os.execute(launch_cmd)
    print("BLPLab 已启动!")
    return true
end

function BlpRunner.run(base_icon_path, blplab_config)
    if not base_icon_path or not blplab_config then
        print("错误 [blplab_runner]: 调用 run 函数时未提供足够的参数。")
        return false
    end

    -- 根据传入的基础路径, 动态构建新的源和目标文件夹路径
    local new_source_folder = ensure_trailing_slash(base_icon_path .. "output")
    local new_dest_folder = ensure_trailing_slash(base_icon_path .. "blp")

    local ok, msg = run_blpnetcl_batch(new_source_folder, new_dest_folder, blplab_config)
    if ok then
        print("静默转换完成: " .. msg)
        return true
    end

    print("静默转换失败: " .. msg)

    if blplab_config.allow_gui_fallback ~= true then
        print("已禁用 GUI 回退，流程终止。")
        return false
    end

    print("开始 GUI 回退流程（需要手动点击开始）...")
    return run_gui_fallback(new_source_folder, new_dest_folder, blplab_config)
end

return BlpRunner
