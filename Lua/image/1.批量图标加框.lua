package.path = package.path .. ';' .. debug.getinfo(1, "S").source:match [[^@?(.*[\/])[^\/]-$]] .. '?.lua;'

--[[
 图像处理与BLP转换一体化脚本

chcp 65001

 功能:
 1. 批量处理图片, 可同时生成多种版本 (常规, 被动, 失效)。
 2. 处理完成后, 可选择自动调用blplab_runner模块来修改配置并启动BLPLab。
--]]

-- ======================= 配置区域 =======================
-- 1. 基础路径配置
local paths = {
    -- [重要] 图标的基础目录, 也是传递给BLPLab的参数
    icon_base_dir = "D:\\War3Asset\\Asset\\Xlimon\\Icon\\20251217\\",

    -- 各种叠加图片的路径
    btn           = "D:\\War3\\tools\\Image\\btn.png",
    paoguang      = "D:\\War3\\tools\\Image\\Paoguangx4.png",
    passive       = "D:\\War3\\tools\\Image\\passive.png",
    dis           = "D:\\War3\\tools\\Image\\dis.png"
}

-- BLPLab 相关配置
local blplab_config = {
    exe = "D:\\War3\\tools\\BLPLAB\\blplab.exe",
    ini_file = "D:\\War3\\tools\\BLPLAB\\blplab.ini"
}

-- 2. 图片尺寸配置
local image_size = 64

-- 3. 生成开关
local generate_flags = {
    normal = true,
    passive = false,
    disabled = true
}
local paoguang_flag = true

-- 4. [新功能] magick处理完成后是否自动运行BLPLab脚本
local run_blplab_after = true

-- ========================================================


-- --- 脚本主体部分, 一般无需修改 ---

-- 使用基础目录作为源目录
local source_dir = paths.icon_base_dir
local size_str = image_size .. "x" .. image_size
local output_dir = source_dir .. "output\\"

print("检查输出目录: " .. output_dir)
os.execute('mkdir "' .. output_dir .. '" > nul 2>&1')

local list_files_cmd = 'dir /b "' .. source_dir .. '*.png"'

print("\n开始批量处理图片...")
-- (图片处理逻辑... 和之前版本完全相同)
for filename in io.popen(list_files_cmd):lines() do
    print("源文件: " .. filename)
    local basename = filename:match("(.+)%..+") or filename
    local extension = filename:match "%.([^.]+)$" or ""
    local input_path = '"' .. source_dir .. filename .. '"'

    local magick_command, output_path, output_filename

    if generate_flags.normal then
        output_filename = "btn" .. filename; output_path = '"' .. output_dir .. output_filename .. '"'
        if paoguang_flag then
            magick_command = string.format(
            'magick convert %s -resize %s -background black -gravity center -extent %s ( "%s" -resize %s ) -gravity center -composite ( "%s" -resize %s ) -gravity center -composite %s',
                input_path, size_str, size_str, paths.paoguang, size_str, paths.btn, size_str, output_path)
            print("  -> 生成 (常规+抛光): " .. output_filename)
        else
            magick_command = string.format(
            'magick convert %s -resize %s -background black -gravity center -extent %s ( "%s" -resize %s ) -gravity center -composite %s',
                input_path, size_str, size_str, paths.btn, size_str, output_path)
            print("  -> 生成 (常规): " .. output_filename)
        end
        os.execute(magick_command)
    end
    if generate_flags.passive then
        output_filename = "btn" .. basename .. "p." .. extension; output_path = '"' ..
        output_dir .. output_filename .. '"'
        magick_command = string.format(
        'magick convert %s -resize %s -background black -gravity center -extent %s ( "%s" -resize %s ) -gravity center -composite %s',
            input_path, size_str, size_str, paths.passive, size_str, output_path)
        print("  -> 生成 (被动): " .. output_filename)
        os.execute(magick_command)
    end
    if generate_flags.disabled then
        output_filename = "disbtn" .. filename; output_path = '"' .. output_dir .. output_filename .. '"'
        magick_command = string.format(
        'magick convert %s -resize %s -background black -gravity center -extent %s ( "%s" -resize %s ) -gravity center -composite %s',
            input_path, size_str, size_str, paths.dis, size_str, output_path)
        print("  -> 生成 (失效): " .. output_filename)
        os.execute(magick_command)
    end
end
print("----------------------------------------")
print("批量图片处理完成！")


-- --- [新功能] 调用BLPLab处理程序 ---
if run_blplab_after then
    print("\n准备执行BLPLab后续处理...")
    -- 使用 require 加载模块, 然后调用其 .run 方法
    -- 将图标基础路径和BLPLab配置传给模块
    require("blplab_runner").run(paths.icon_base_dir, blplab_config)
    print("\n所有任务执行完毕!")
else
    print("\n已跳过BLPLab处理步骤。")
end
