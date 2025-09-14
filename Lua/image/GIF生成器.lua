local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = "D:/War3/自定义UI/特效/2022-2-12", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['size'] = 128, -- 目标尺寸［用于转换/合成］
	['trimSize'] = 0, -- 图片四周扩展留白的像素
	['bgColor'] = 'black', -- GIF 的背景底色
	['isPrint'] = false, -- 是否打印生成的命令
	['namePrefix'] = 'ig', -- 命名前缀
	['nameCount'] = 100, -- 命名起始计数（用于 GIF 序号）
	['frame'] = 6, -- 帧延迟（每帧停留时间）
	['blp'] = true, -- 是否进行 BLP 文件转换
}

-- 从文件名中获取序号
function string:gifIndex()
	return tonumber(self:match("_(%d+)%.png$") or self:match("%((%d+)%)%.png$"))
end

-- 获取 GIF 前缀：既支持 _数字 的格式，也支持 (数字) 的格式
function string:gifPrefix()
	return self:gsub('_%d+$', ''):gsub(' %(%d+%)$', '')
end

-- 排序比较函数（按序号升序）
local cp = function(a, b)
	local ai = tonumber(a:gifIndex())
	local bi = tonumber(b:gifIndex())
	if ai == nil or bi == nil then return false end
	if ai == bi then return false end
	return ai <= bi
end

-- 裁切并标准化图像
local function Trim(filePath, output)
	-- -trim +repage \
	local cmd = 'magick convert ' ..
		fu.PathString(filePath) .. ' ' ..
		'-background rgba(0,0,0,0) ' ..
		'-flatten ' ..
		'-resize ' .. flag.size .. 'x' .. flag.size .. ' ' ..
		'-gravity center ' ..
		'-extent ' .. (flag.size + flag.trimSize) .. 'x' .. (flag.size + flag.trimSize) .. ' ' ..
		'-resize ' .. flag.size .. 'x' .. flag.size .. ' ' ..
		fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去掉换行与制表符
	-- 执行命令
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

-- 生成 GIF 预览
local function GenerateGIF(gifPrefix)
	local cmd = 'magick convert ' ..
		'-resize ' .. flag.size .. 'x' .. flag.size .. ' ' ..
		'-delay ' .. flag.frame .. ' ' ..
		'-dispose previous ' ..
		gifPrefix .. '_*.png ' .. gifPrefix .. '.gif'
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去掉换行与制表符
	-- 执行命令
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

-- 生成图片与 GIF 预览
local function GenerateIcon(gifPath, outputPath, newPath)
	local gifs = {}
	os.execute("explorer " .. string.gsub(gifPath, "/", "\\"))
	fu.ForDir(flag.path, function(filePath)
		local name, type = fu.GetFile(filePath)
		local listName = name:gifPrefix()
		gifs[listName] = gifs[listName] or {}
		gifs[listName].length = gifs[listName].length or 0
		gifs[listName].length = gifs[listName].length + 1
		gifs[listName].list = gifs[listName].list or {}
		gifs[listName].list[#gifs[listName].list + 1] = filePath
	end, flag.isSubDir)

	-- 第一步：整理并输出中间资源与标准化图
	for _, gif in pairs(gifs) do
		-- 自定义比较函数排序（避免 1,10,11 排在 2 之前）
		table.sort(gif.list, cp)

		gif.prefix = newPath .. "/" .. flag.namePrefix .. flag.nameCount    -- 新的重命名前缀路径
		gif.gifPrefix = gifPath .. "/" .. flag.namePrefix .. flag.nameCount -- GIF 序列前缀
		-- 拷贝图片文件并重命名
		for j, oldFile in ipairs(gif.list) do
			local suffix = "_" .. string.format("%02d", j - 1) .. ".png" -- GIF 预览用 %02d，魔兽帧可用 %d
			local file = gif.prefix .. suffix
			copy.CopyBin(oldFile, file)
			gif.list[j] = file

			local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix
			local gifFile = gifPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix

			Trim(file, outputFile)                                          -- 小步1：Trim 规范化
			iu:Combine(file, "canvas:" .. flag.bgColor, gifFile, flag.size) -- 小步2：叠背景
		end
		flag.nameCount = flag.nameCount + 1                                 -- GIF 计数 +1
		print(gbk.toutf8(gif.prefix))
	end

	-- 第二步：拼接 GIF
	print(gbk.toutf8("生成 GIF 预览图中..."))
	for _, gif in pairs(gifs) do
		GenerateGIF(gif.gifPrefix)
	end
end

-- 重命名：将 _0 归并为无后缀（_05.png -> _5.png 等）
function Rename(path)
	fu.ForDir(path, function(filePath)
		local dir = fu.GetDir(filePath)
		local name, type = fu.GetFile(filePath)
		local newName = name:gsub("_0", '_')
		os.rename(filePath, dir .. '/' .. newName .. '.png')
		-- print(gbk.toutf8(dir .. '/' .. newName .. '.png'))
	end)
end

local newPath = fu.GetDir(flag.path) .. "/rename" -- 重新命名的临时文件夹
local gifPath = fu.GetDir(flag.path) .. "/gif"
local outputPath = fu.GetDir(flag.path) .. "/output"
local blpPath = fu.GetDir(flag.path) .. "/blp"
fu.clearDir(gifPath)
fu.clearDir(outputPath)
fu.clearDir(blpPath)
fu.clearDir(newPath)
lfs.mkdir(gifPath)
lfs.mkdir(outputPath)
lfs.mkdir(blpPath)
lfs.mkdir(newPath)
iu.Flag(flag)      -- 设置 Flag
GenerateIcon(gifPath, outputPath, newPath)
Rename(outputPath) -- 生成后规范文件名：_05.png -> _5.png 等
if flag.blp then
	BlpLab:ConvertBLP(outputPath, blpPath)
	BlpLab:Move(blpPath, path.image.frame)
end
print(gbk.toutf8("GIF 生成完成."))
