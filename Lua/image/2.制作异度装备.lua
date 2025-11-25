package.path = package.path .. ';' .. debug.getinfo(1, "S").source:match [[^@?(.*[\/])[^\/]-$]] .. '?.lua;'

--[[
 图像处理与BLP转换一体化脚本

chcp 65001

 功能:
 1. 批量处理图片, 可同时生成多种版本 (常规, 失效)。
 2. 处理完成后, 可选择自动调用blplab_runner模块来修改配置并启动BLPLab。
--]]

-- ======================= 配置区域 =======================
-- 1. 基础路径配置
local paths = {
    -- [重要] 图标的基础目录, 也是传递给BLPLab的参数
    icon_base_dir = "D:\\War3Asset\\Asset\\Xlimon\\Equitment\\5\\",

    -- 各种叠加图片的路径
    btn           = "D:\\War3\\tools\\Image\\btn.png",
    paoguang      = "D:\\War3\\tools\\Image\\Paoguangx4.png",
    dis           = "D:\\War3\\tools\\Image\\dis.png",

    -- 品质图片路径 (0-6)
    quality = {
        [0] = "D:\\War3\\tools\\Image\\bj0.png",
        [1] = "D:\\War3\\tools\\Image\\bj1.png",
        [2] = "D:\\War3\\tools\\Image\\bj2.png",
        [3] = "D:\\War3\\tools\\Image\\bj3.png",
        [4] = "D:\\War3\\tools\\Image\\bj4.png",
        [5] = "D:\\War3\\tools\\Image\\bj5.png",
        [6] = "D:\\War3\\tools\\Image\\bj6.png"
    },

    -- 光晕图片路径 (0-6, 根据品质等级选择)
    glow = {
        [0] = "D:\\War3\\tools\\Image\\fg4_glowCyan.png",
        [1] = "D:\\War3\\tools\\Image\\fg4_glowGreen.png",
        [2] = "D:\\War3\\tools\\Image\\fg4_glowBlue.png",
        [3] = "D:\\War3\\tools\\Image\\fg4_glowMagenta.png",
        [4] = "D:\\War3\\tools\\Image\\fg4_glowMagenta.png",
        [5] = "D:\\War3\\tools\\Image\\fg4_glowOrange.png",
        [6] = "D:\\War3\\tools\\Image\\fg4_glowRed.png"
    }
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
    disabled = true
}
local paoguang_flag = false

-- 4. 品质等级配置 (0-6, 当前使用的品质等级)
local quality_level = 6

-- 5. [新功能] magick处理完成后是否自动运行BLPLab脚本
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
    local normal_output_path = nil

    if generate_flags.normal then
        output_filename = "btn" .. filename
        normal_output_path = output_dir .. output_filename
        output_path = '"' .. normal_output_path .. '"'
        local quality_path = paths.quality[quality_level]
        local glow_path = paths.glow[quality_level]

        if not quality_path then
            print("  [警告] 品质等级 " .. quality_level .. " 不存在，跳过品质图片合并")
            quality_path = nil
        end
        if not glow_path then
            print("  [警告] 品质等级 " .. quality_level .. " 的光晕图片不存在，跳过光晕合并")
            glow_path = nil
        end

        -- 构建基础命令：先创建背景
        local base_cmd = string.format('-size %s xc:black', size_str)

        -- 构建合成命令片段
        local composite_parts = {}

        -- 1. 光晕（最前面，在背景上叠加）
        if glow_path then
            table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
                glow_path, size_str))
        end

        -- 2. 源图
        table.insert(composite_parts, string.format('( %s -resize %s ) -gravity center -composite',
            input_path, size_str))

        -- 3. 抛光（如果有）
        if paoguang_flag then
            table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
                paths.paoguang, size_str))
        end

        -- 4. btn
        table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
            paths.btn, size_str))

        -- 5. 品质（如果有）
        if quality_path then
            table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
                quality_path, size_str))
        end

        -- 组合完整命令
        magick_command = 'magick convert ' .. base_cmd .. ' ' .. table.concat(composite_parts, ' ') .. ' ' .. output_path

        -- 生成描述信息
        local desc_parts = {}
        if glow_path then table.insert(desc_parts, "光晕") end
        if paoguang_flag then table.insert(desc_parts, "抛光") end
        table.insert(desc_parts, "常规")
        if quality_path then table.insert(desc_parts, "品质" .. quality_level) end
        print("  -> 生成 (" .. table.concat(desc_parts, "+") .. "): " .. output_filename)

        os.execute(magick_command)
    end
    if generate_flags.disabled then
        output_filename = "disbtn" .. filename
        output_path = '"' .. output_dir .. output_filename .. '"'

        if normal_output_path then
            -- 基于已生成的普通图标叠加失效遮罩
            local normal_input = '"' .. normal_output_path .. '"'
            magick_command = string.format(
                'magick convert %s ( "%s" -resize %s ) -gravity center -composite %s',
                normal_input, paths.dis, size_str, output_path
            )
        else
            -- 如果未生成普通图标, 退回到旧的基于原图的方案
            print("  [警告] 未生成常规图标, 失效图标将从原始图片生成（不包含光晕/品质）。")
            magick_command = string.format(
                'magick convert %s -resize %s -background black -gravity center -extent %s ( "%s" -resize %s ) -gravity center -composite %s',
                input_path, size_str, size_str, paths.dis, size_str, output_path
            )
        end

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
