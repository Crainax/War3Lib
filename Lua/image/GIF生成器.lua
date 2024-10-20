local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.compile.Copy"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {

	['path'] = "D:/War3/创世UI/光效/2022-2-12", -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['size'] = 128, -- 文件长宽[最终转换的]
	['trimSize'] = 0, -- 图标相邻四边的距离
	['bgColor'] = 'black', -- GIF的背景颜色
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'ig', -- 名字前缀
	['nameCount'] = 100, -- 名字起始点(包含這個)
	['frame'] = 6, -- 多少秒一帧
	['blp'] = true, -- 是否生成BLP文件并转移
}

-- 排序函数的获取索引
function string:gifIndex()
	return tonumber(self:match("_(%d+)%.png$") or self:match("%((%d+)%)%.png$"))
end
-- 可能是_的形式也可能是(XX)的索引形式
function string:gifPrefix()
	return self:gsub('_%d+$', ''):gsub(' %(%d+%)$', '')
end

-- 排序函数
local cp = function(a, b)
	local ai = tonumber(a:gifIndex())
	local bi = tonumber(b:gifIndex())
	if ai == nil or bi == nil then return false end
	if ai == bi then return false end
	return ai <= bi
end

-- 裁剪图标
local function Trim(filePath, output)
	-- -trim +repage \
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	-background rgba(0,0,0,0) \
	-flatten \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
	-gravity center \
	-extent ' .. (flag.size + flag.trimSize) .. 'x' .. (flag.size + flag.trimSize) .. ' \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

-- 生成GIF康康
local function GenerateGIF(gifPrefix)
	local cmd = 'magick convert \
	-resize ' .. flag.size .. 'x' .. flag.size .. ' \
    -delay ' .. flag.frame .. ' \
    -dispose previous \
    ' .. gifPrefix .. '_*.png ' .. gifPrefix .. '.gif'
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

-- 生成图片预览
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
	-- 第一大步:重命名与排序
	for _, gif in pairs(gifs) do
		table.sort(gif.list, cp) -- 对集合进行排序(把1,10,11这个移到2后面)

		gif.prefix = newPath .. "/" .. flag.namePrefix .. flag.nameCount -- 新的改名路径
		gif.gifPrefix = gifPath .. "/" .. flag.namePrefix .. flag.nameCount -- 新的改名路径
		-- 针对图片文件进行改名
		for j, oldFile in ipairs(gif.list) do
			local suffix = "_" .. string.format("%02d", j - 1) .. ".png" -- 这里有点蛋疼,生成预览要%02d,但是魔兽是%d
			local file = gif.prefix .. suffix
			copy.CopyBin(oldFile, file)
			gif.list[j] = file
			local outputFile = outputPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix
			local gifFile = gifPath .. "/" .. flag.namePrefix .. flag.nameCount .. suffix

			Trim(file, outputFile) -- 第1小步:Trim
			iu:Combine(file, "canvas:" .. flag.bgColor, gifFile, flag.size) -- 第2小步:加背景
		end
		flag.nameCount = flag.nameCount + 1 -- GIF序号+1
		print(gbk.toutf8(gif.prefix))
	end

	-- 第二大步:生成GIF
	print(gbk.toutf8("生成GIF预览图中..."))
	for _, gif in pairs(gifs) do GenerateGIF(gif.gifPrefix) end
end

function Rename(path)
	fu.ForDir(path, function(filePath)
		local dir = fu.GetDir(filePath)
		local name, type = fu.GetFile(filePath)
		local newName = name:gsub("_0", '_')
		os.rename(filePath, dir .. '/' .. newName .. '.png')
		-- print(gbk.toutf8(dir .. '/' .. newName .. '.png'))
	end)
end

local newPath = fu.GetDir(flag.path) .. "/rename" -- 重新改名后的文件夹
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
iu.Flag(flag) -- 传递Flag
GenerateIcon(gifPath, outputPath, newPath)
Rename(outputPath) -- 生成后给所有文件改名, _05.png -> _5.png 这样
if flag.blp then
	BlpLab:ConvertBLP(outputPath, blpPath)
	BlpLab:Move(blpPath, path.image.frame)
end
print(gbk.toutf8("GIF生成结束."))
