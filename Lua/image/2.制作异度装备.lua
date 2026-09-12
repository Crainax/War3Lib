local script_source = debug.getinfo(1, "S").source
local script_dir = script_source:match([[^@?(.*[\/])[^\/]-$]]) or ".\\"
package.path = package.path .. ";" .. script_dir .. "?.lua;"

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
    icon_base_dir = [[D:\War3Asset\Asset\Xlimon\Icon\20260902\NewEquipment\]],

    -- 各种叠加图片的路径
    btn           = [[D:\War3\tools\Image\btn.png]],
    paoguang      = [[D:\War3\tools\Image\Paoguangx4.png]],
    dis           = [[D:\War3\tools\Image\dis.png]]
}

-- 装备品质流程。frame 是最后叠加的品质边框，glow 是先铺在源图下方的品质底纹。
-- 普通品质流程: bj0 + old_1
-- 稀有品质流程: bj2 + old_2
-- 史诗品质流程: bj4 + old_3
-- 传说品质流程: bj5 + old_4
-- 神话品质流程: bj6 + fg4_glowRed
local quality_presets = {
    common = {
        label = "普通",
        frame = [[D:\War3\tools\Image\bj0.png]],
        glow = [[D:\War3\tools\Image\old_1.png]]
    },
    rare = {
        label = "稀有",
        frame = [[D:\War3\tools\Image\bj2.png]],
        glow = [[D:\War3\tools\Image\old_2.png]]
    },
    epic = {
        label = "史诗",
        frame = [[D:\War3\tools\Image\bj4.png]],
        glow = [[D:\War3\tools\Image\old_3.png]]
    },
    legendary = {
        label = "传说",
        frame = [[D:\War3\tools\Image\bj5.png]],
        glow = [[D:\War3\tools\Image\old_4.png]]
    },
    myth = {
        label = "神话",
        frame = [[D:\War3\tools\Image\bj6.png]],
        glow = [[D:\War3\tools\Image\fg4_glowRed.png]]
    }
}

-- 混合品质批次按不含扩展名的文件名指定品质；未列出的文件使用 default_quality。
-- 整个目录都是同一品质时，可设置 default_quality（如 "rare"）并清空本表。
local default_quality = nil
local icon_quality_by_name = {
    I31m = "epic",
    I40q = "legendary",
    I50q = "myth"
}

-- BLPLab 相关配置
-- blpnetcl 参数说明:
-- type: 0=Compressed(JPEG质量1-100), 1=Paletted(调色板质量1-256)
-- mipmap: 0-15
-- quality: 依据 type 不同而不同
-- alpha: 0=Auto, 1=Opaque, 2=Alpha
local blp_cli = {
    type = 0,
    mipmap = 10,
    quality = 98,
    alpha = 2,
    option1 = false,
    option2 = false
}

local function build_blp_cli_args(cfg)
    local args = {
        "--type " .. tostring(cfg.type),
        "--mipmap " .. tostring(cfg.mipmap),
        "--quality " .. tostring(cfg.quality),
        "--alpha " .. tostring(cfg.alpha)
    }
    if cfg.option1 then table.insert(args, "--option1") end
    if cfg.option2 then table.insert(args, "--option2") end
    return table.concat(args, " ")
end

local blplab_config = {
    exe = "D:\\War3\\tools\\BLPLAB\\blplab.exe",
    ini_file = "D:\\War3\\tools\\BLPLAB\\blplab.ini",
    cli_exe = "D:\\War3\\tools\\BLPLAB\\BLP.NET.CL\\BLP.NET\\blpnetcl.exe",
    cli_args = build_blp_cli_args(blp_cli),
    allow_gui_fallback = false
}

-- 2. 图片尺寸配置
local image_size = 64

-- 3. 生成开关
local generate_flags = {
    normal = true,
    disabled = true
}
local paoguang_flag = false

-- 4. magick处理完成后是否自动运行BLPLab脚本
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
    local quality_key = icon_quality_by_name[basename] or default_quality
    local quality_preset = quality_presets[quality_key]

    if not quality_preset then
        error("图标 " .. basename .. " 未配置有效品质，请填写 icon_quality_by_name 或 default_quality。")
    end
    print("  品质流程: " .. quality_preset.label .. " (" .. quality_key .. ")")

    if generate_flags.normal then
        output_filename = "btn" .. filename
        normal_output_path = output_dir .. output_filename
        output_path = '"' .. normal_output_path .. '"'
        local quality_path = quality_preset.frame
        local glow_path = quality_preset.glow

        -- 构建基础命令：先创建背景
        local base_cmd = string.format('-size %s xc:black', size_str)

        -- 构建合成命令片段
        local composite_parts = {}

        -- 1. 品质底纹（最前面，在黑色背景上叠加）
        table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
            glow_path, size_str))

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

        -- 5. 品质边框（最后覆盖）
        table.insert(composite_parts, string.format('( "%s" -resize %s ) -gravity center -composite',
            quality_path, size_str))

        -- 组合完整命令
        magick_command = 'magick convert ' .. base_cmd .. ' ' .. table.concat(composite_parts, ' ') .. ' ' .. output_path

        -- 生成描述信息
        local desc_parts = {}
        table.insert(desc_parts, quality_preset.label .. "底纹")
        if paoguang_flag then table.insert(desc_parts, "抛光") end
        table.insert(desc_parts, "常规")
        table.insert(desc_parts, quality_preset.label .. "边框")
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
