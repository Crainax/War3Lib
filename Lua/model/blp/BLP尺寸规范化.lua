-- BLP 尺寸规范化
-- 流程: blp -> png -> 检测尺寸 -> 必要时调整 -> png -> blp
-- 仅处理 source_dir 当前层 .blp，不递归

local config = {
    source_dir = [[D:\War3Asset\Model\Shangquemoxing\20260418\shop10\war3mapImported]],
    blpnetcl_exe = [[D:\War3\tools\BLPLAB\BLP.NET.CL\BLP.NET\blpnetcl.exe]],
    magick_exe = "magick",
    blp_args = "--type 0 --mipmap 1 --quality 98 --alpha 2",
    temp_dir_name = "_tmp_png",
    old_dir_name = "old",
}

local function trim_trailing_sep(path)
    return (path:gsub("[/\\]+$", ""))
end

local function to_win(path)
    return (path:gsub("/", "\\"))
end

local function join_path(a, b)
    a = trim_trailing_sep(a)
    return a .. "/" .. b
end

local function q(path)
    return '"' .. path .. '"'
end

local function file_exists(path)
    local f = io.open(path, "rb")
    if f then
        f:close()
        return true
    end
    return false
end

local function ensure_dir(path)
    os.execute('mkdir ' .. q(to_win(path)) .. " > nul 2>&1")
end

local function os_cmd_ok(cmd)
    local a, b, c = os.execute(cmd)
    if type(a) == "number" then
        return a == 0
    end
    if type(a) == "boolean" then
        if a == true then
            return true
        end
        if b == "exit" and c == 0 then
            return true
        end
        return false
    end
    return false
end

local function run_capture(cmd)
    local p = io.popen(cmd)
    if not p then
        return nil
    end
    local out = p:read("*a")
    p:close()
    if not out then
        return nil
    end
    return (out:gsub("%s+$", ""))
end

local function split_name_ext(filename)
    local name, ext = filename:match("^(.*)%.([^%.]+)$")
    return name, ext
end

local function list_blp_files(dir)
    local files = {}
    local cmd = 'cmd /d /c "dir /b /a:-d ' .. q(to_win(trim_trailing_sep(dir) .. "\\*.blp")) .. ' 2>nul"'
    local p = io.popen(cmd)
    if not p then
        return files
    end
    for line in p:lines() do
        if line and line ~= "" then
            table.insert(files, line)
        end
    end
    p:close()
    return files
end

local function is_power_of_two(n)
    if n < 1 then
        return false
    end
    while n % 2 == 0 do
        n = n / 2
    end
    return n == 1
end

local function next_pow2(n)
    local p = 1
    while p < n do
        p = p * 2
    end
    return p
end

local function prev_pow2(n)
    local p = 1
    while (p * 2) <= n do
        p = p * 2
    end
    return p
end

local function normalize_dim(dim)
    if is_power_of_two(dim) then
        return dim
    end
    if dim <= 128 then
        return next_pow2(dim)
    end
    return prev_pow2(dim)
end

local function decide_target_size(w, h)
    if w > 512 or h > 512 then
        return 512, 512
    end
    return normalize_dim(w), normalize_dim(h)
end

local function check_magick_available(magick_exe)
    local cmd = 'cmd /d /c ""' .. magick_exe .. '" -version 2>nul"'
    local out = run_capture(cmd)
    return out ~= nil and out ~= ""
end

local function blp_to_png(blpnetcl_exe, blp_path, png_path)
    local cmd = 'cmd /d /c ""' .. to_win(blpnetcl_exe) .. '" ' ..
        q(to_win(blp_path)) .. " " .. q(to_win(png_path)) .. '"'
    return os_cmd_ok(cmd) and file_exists(png_path)
end

local function png_to_blp(blpnetcl_exe, png_path, blp_path, blp_args)
    local cmd = 'cmd /d /c ""' .. to_win(blpnetcl_exe) .. '" ' ..
        q(to_win(png_path)) .. " " .. q(to_win(blp_path))
    if blp_args and blp_args ~= "" then
        cmd = cmd .. " " .. blp_args
    end
    cmd = cmd .. '"'
    return os_cmd_ok(cmd) and file_exists(blp_path)
end

local function get_image_size(magick_exe, png_path)
    local cmd = 'cmd /d /c ""' .. magick_exe .. '" identify -ping ' .. q(to_win(png_path)) .. ' 2>nul"'
    local out = run_capture(cmd)
    if not out or out == "" then
        return nil, nil
    end
    local w, h = out:match("(%d+)x(%d+)")
    if not w or not h then
        return nil, nil
    end
    return tonumber(w), tonumber(h)
end

local function resize_png_force(magick_exe, png_path, w, h)
    local cmd = 'cmd /d /c ""' .. magick_exe .. '" mogrify -resize ' ..
        tostring(w) .. "x" .. tostring(h) .. "! " .. q(to_win(png_path)) .. '"'
    return os_cmd_ok(cmd)
end

local function copy_bin(src, dst)
    local fsrc = io.open(src, "rb")
    if not fsrc then
        return false
    end
    local data = fsrc:read("*a")
    fsrc:close()

    local fdst = io.open(dst, "wb")
    if not fdst then
        return false
    end
    fdst:write(data)
    fdst:close()
    return true
end

local function move_file(src, dst)
    local ok = os.rename(src, dst)
    if ok then
        return true
    end
    if not copy_bin(src, dst) then
        return false
    end
    os.remove(src)
    return true
end

local function get_backup_path(old_dir, filename)
    local base, ext = split_name_ext(filename)
    local path0 = join_path(old_dir, filename)
    if not file_exists(path0) then
        return path0
    end

    local ts = os.date("%Y%m%d_%H%M%S")
    local path1 = join_path(old_dir, base .. "_" .. ts .. "." .. ext)
    if not file_exists(path1) then
        return path1
    end

    local idx = 1
    while true do
        local pathn = join_path(old_dir, base .. "_" .. ts .. "_" .. tostring(idx) .. "." .. ext)
        if not file_exists(pathn) then
            return pathn
        end
        idx = idx + 1
    end
end

local function main()
    local source_dir = trim_trailing_sep(config.source_dir)
    local blpnetcl_exe = trim_trailing_sep(config.blpnetcl_exe)
    local temp_dir = join_path(source_dir, config.temp_dir_name)
    local old_dir = join_path(source_dir, config.old_dir_name)

    if not file_exists(blpnetcl_exe) then
        print("[错误] 未找到 blpnetcl.exe: " .. blpnetcl_exe)
        return
    end
    if not check_magick_available(config.magick_exe) then
        print("[错误] 无法调用 ImageMagick: " .. tostring(config.magick_exe))
        return
    end

    ensure_dir(temp_dir)
    ensure_dir(old_dir)

    local blp_files = list_blp_files(source_dir)
    if #blp_files == 0 then
        print("[完成] 当前目录没有 .blp 文件: " .. source_dir)
        return
    end

    local total = 0
    local skipped = 0
    local modified = 0
    local failed = 0
    local failed_list = {}

    print("[开始] 目录: " .. source_dir)
    print("[开始] 文件数量: " .. tostring(#blp_files))

    for _, filename in ipairs(blp_files) do
        total = total + 1
        local base = split_name_ext(filename)
        local blp_path = join_path(source_dir, filename)
        local png_path = join_path(temp_dir, base .. ".png")

        local ok = true
        local fail_reason = nil

        if not blp_to_png(blpnetcl_exe, blp_path, png_path) then
            ok = false
            fail_reason = "blp->png 失败"
        end

        local w, h
        if ok then
            w, h = get_image_size(config.magick_exe, png_path)
            if not w or not h then
                ok = false
                fail_reason = "无法获取图片尺寸"
            end
        end

        local tw, th
        if ok then
            tw, th = decide_target_size(w, h)
        end

        if ok and tw == w and th == h then
            skipped = skipped + 1
            os.remove(png_path)
            print(string.format("[跳过] %s (%dx%d)", filename, w, h))
        elseif ok then
            if not resize_png_force(config.magick_exe, png_path, tw, th) then
                ok = false
                fail_reason = "PNG 尺寸调整失败"
            end
        end

        if ok and not (tw == w and th == h) then
            local backup_path = get_backup_path(old_dir, filename)
            if not move_file(blp_path, backup_path) then
                ok = false
                fail_reason = "备份原始 BLP 失败"
            else
                if not png_to_blp(blpnetcl_exe, png_path, blp_path, config.blp_args) then
                    ok = false
                    fail_reason = "png->blp 失败"
                    if not file_exists(blp_path) then
                        move_file(backup_path, blp_path)
                    end
                end
            end
        end

        if ok then
            if not (tw == w and th == h) then
                modified = modified + 1
                os.remove(png_path)
                print(string.format("[修改] %s %dx%d -> %dx%d", filename, w, h, tw, th))
            end
        else
            failed = failed + 1
            table.insert(failed_list, filename .. " (" .. tostring(fail_reason) .. ")")
            print("[失败] " .. filename .. " - " .. tostring(fail_reason))
            -- 失败时保留临时 PNG 便于排查
        end
    end

    print("")
    print("========== 汇总 ==========")
    print("总数: " .. tostring(total))
    print("跳过: " .. tostring(skipped))
    print("修改: " .. tostring(modified))
    print("失败: " .. tostring(failed))
    if #failed_list > 0 then
        print("失败文件列表:")
        for _, item in ipairs(failed_list) do
            print(" - " .. item)
        end
    end
    print("==========================")
end

main()
