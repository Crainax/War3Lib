local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
    ['path'] = "D:/War3/自定义UI/Test/equit", -- 要处理的文件夹
    ['isSubDir'] = false, -- 是否遍历子文件夹
    ['disable'] = true, -- 是否生成禁用（灰度）图
    ['frame'] = true, -- 是否启用自定义边框［不使用原版边框］
    ['size'] = 128, -- 图标目标尺寸［用于转换/合成］
    ['tSize'] = 128, -- 临时缩放尺寸
    ['trimSize'] = 40, -- 图片四周扩展留白的像素（裁切后再扩边）
    ['frameSize'] = 12, -- 边框粗细
    ['frameOff'] = 6, -- 边框内缩/外扩偏移
    ['bgColor'] = "orange", -- 背景色［仅支持 green/blue/purple/orange/pink/red 六种，注释掉则为黑色］
    -- ['fColor'] = "rgb(107,194,53)", -- ［绿边框］
    -- ['fColor']  = "rgb(65,117,182)", -- ［蓝边框］
    -- ['fColor']  = "rgb(255,0,255)", -- ［紫边框］
    ['fColor'] = "rgb(255,94,0)", -- ［橙边框］
    -- ['fColor'] = "rgb(255,0,0)", -- ［红边框］
    -- ['fColor'] = "rgb(243,109,180)", -- ［粉边框］
    -- ['fColor']  = "rgb(128,128,128)", -- ［灰边框］
    ['isPrint'] = false, -- 是否打印生成的命令
    ['namePrefix'] = 'test', -- 命名前缀
    ['nameCount'] = 1, -- 命名起始计数
    ['isCorner'] = function(fileName) return false end, -- 判断某文件是否需要叠加“角标”
    ['corner'] = 5 -- 角标编号（当前仅支持 0-5）
}

-- 裁切图像（使用 ImageMagick convert）
local function Trim(filePath, output)
    local cmd = 'magick convert ' ..
        fu.PathString(filePath) .. ' ' ..
        '-background rgba(0,0,0,0) ' ..
        '-flatten ' ..
        '-fuzz 25% -trim +repage ' ..
        '-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
        '-gravity center ' ..
        '-extent ' .. (flag.tSize + flag.trimSize) .. 'x' .. (flag.tSize + flag.trimSize) .. ' ' ..
        '-resize ' .. flag.tSize .. 'x' .. flag.tSize .. ' ' ..
        fu.PathString(output)
    cmd = string.gsub(cmd, '[\n\t]', '') -- 去掉换行与制表符
    -- 执行命令
    if flag.isPrint then
        print(gbk.toutf8(cmd)) -- 打印命令
    end
    os.execute(cmd)
end

-- 叠加角标（按规则判断）
function Corner(file)
    if flag.isCorner(file) then
        iu.Combine(path.image.path .. "/bj" .. flag.corner .. ".png", file, file, flag.tSize)
    end
end

-- 生成图标
local function GenerateIcon(outputPath, tempPath)
    os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
    fu.ForDir(flag.path, function(filePath)
        local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
        local tempFile = tempPath .. "/" .. flag.namePrefix .. flag.nameCount .. ".png"
        local disFile = outputPath .. "/dis" .. flag.namePrefix .. flag.nameCount .. ".png"
        if not (flag.isPrint) then
            print(gbk.toutf8("生成中..." .. outputFile))
        end
        flag.nameCount = flag.nameCount + 1
        Trim(filePath, tempFile) -- 第1步：裁切与标准化图像
        iu:BG(tempFile, outputFile) -- 第2步：合成背景/图标
        iu:Frame(outputFile) -- 第3步：加边框
        Corner(outputFile) -- 第4步：角标
        iu:Light(outputFile) -- 第5步：高光
        if flag.disable then
            iu:Disable(outputFile, disFile) -- 第6步：生成禁用（灰度）图
        end
        flag.isPrint = false
    end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 设置 Flag
GenerateIcon(outputPath, tempPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:MoveBLP(blpPath)
print(gbk.toutf8("成品图标生成完成."))

-- magick convert canvas:white -resize 128x128 dis.psd -resize 128x128 -background none -flatten -composite 1.png