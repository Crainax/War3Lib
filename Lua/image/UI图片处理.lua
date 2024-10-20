local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local args = {
	['bg_close'] = { --
		['tWidth'] = 512,
		['tHeight'] = 512,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['detail_arrow'] = { --
		['tWidth'] = 128,
		['tHeight'] = 128,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_close'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_left'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_right'] = { --
		['tWidth'] = 64,
		['tHeight'] = 64,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
	['select_flash'] = { --
		['tWidth'] = 256,
		['tHeight'] = 128,
		['trimWidth'] = 0,
		['trimHeight'] = 0,
	},
}

local flag = {
	['path'] = [[D:\War3\创世UI\教程\使用]], -- 要处理的文件夹
	['isSubDir'] = false, -- 是否处理子文件夹
	['disable'] = true, -- 是否生成暗图标
	['size'] = 128, -- 文件长宽[最终转换的]
	['tWidth'] = function(name)
		if args[name] then return args[name].tWidth or 256 end
		return 256 -- 文件长宽[中转]
	end,
	['tHeight'] = function(name)
		if args[name] then return args[name].tHeight or 128 end
		return 128 -- 文件长宽[中转]
	end,
	['trimWidth'] = function(name)
		if args[name] then return args[name].trimWidth or 20 end
		return 20 -- 左右空边
	end,
	['trimHeight'] = function(name)
		if args[name] then return args[name].trimHeight or 10 end
		return 10 -- 左右空边
	end,
	['isPrint'] = false, -- 是否打印生成的指令
	['namePrefix'] = 'HeroSpell', -- 名字前缀
	['nameCount'] = 1, -- 名字起始点
}
-- 名字映射
flag['name'] = function(name)
	-- name = 'TT' .. name --1
	-- local result = '' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- 名字
	-- flag.nameCount = flag.nameCount + 1
	return name
end -- 生成

-- 创建对应文字的Text,并Trim
local function Resize(oldName, tempFile, outputFile, lookFile)
	local tWidth = flag.tWidth(oldName)
	local tHeight = flag.tHeight(oldName)
	local trimWidth = flag.trimWidth(oldName)
	local trimHeight = flag.trimHeight(oldName)
	local cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-background none \
	-gravity center \
	-trim +repage \
	-resize ' .. tWidth .. 'x' .. tHeight .. '! \
	-gravity center \
	-extent ' .. (tWidth + trimWidth) .. 'x' .. (tHeight + trimHeight) .. ' \
	-resize ' .. tWidth .. 'x' .. tHeight .. '! \
	' .. fu.PathString(outputFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行，生成结果
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)

	cmd = 'magick convert \
	' .. fu.PathString(tempFile) .. ' \
	-background none \
	-gravity center \
	-trim +repage \
	' .. fu.PathString(lookFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行，生成结果
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)

end

local function GenerateIcon(outputPath, lookPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	os.execute("explorer " .. string.gsub(lookPath, "/", "\\")) -- 这个是参照一下大小
	fu.ForDir(flag.path, function(filePath)
		local oldName, format = fu.GetFile(filePath)
		local name = flag.name(oldName)
		local outputFile = outputPath .. "/" .. name .. ".png"
		local lookFile = lookPath .. "/" .. name .. ".png"
		if not (flag.isPrint) then print(gbk.toutf8("处理中..." .. outputFile)) end
		Resize(oldName, filePath, outputFile, lookFile) -- 第1步:直接做最初的调整
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local lookPath = fu.GetDir(flag.path) .. "/look"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(lookPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 传递Flag
GenerateIcon(outputPath, lookPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:Move(blpPath, path.image.bg)
print(gbk.toutf8("UI所用图处理完毕"))
