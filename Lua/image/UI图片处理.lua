local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

-- 针对不同 UI 元素的尺寸与留白参数
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
	['path'] = [[D:\War3\自定义UI\教程\示例]], -- 要处理的文件夹
	['isSubDir'] = false, -- 是否遍历子文件夹
	['disable'] = true, -- 是否生成禁用图（本脚本未用到，可保留）
	['size'] = 128, -- 目标尺寸（旧参数，保留兼容）
	['tWidth'] = function(name)
		if args[name] then return args[name].tWidth or 256 end
		return 256 -- 临时宽度（默认）
	end,
	['tHeight'] = function(name)
		if args[name] then return args[name].tHeight or 128 end
		return 128 -- 临时高度（默认）
	end,
	['trimWidth'] = function(name)
		if args[name] then return args[name].trimWidth or 20 end
		return 20 -- 额外留白（宽）
	end,
	['trimHeight'] = function(name)
		if args[name] then return args[name].trimHeight or 10 end
		return 10                 -- 额外留白（高）
	end,
	['isPrint'] = false,          -- 是否打印生成的命令
	['namePrefix'] = 'HeroSpell', -- 命名前缀（未使用，保留）
	['nameCount'] = 1,            -- 命名起始计数（未使用，保留）
}
-- 命名映射
flag['name'] = function(name)
	-- name = 'TT' .. name -- 方案1：加前缀
	-- local result = '' .. name
	-- local result = flag.namePrefix .. flag.nameCount -- 递增命名
	-- flag.nameCount = flag.nameCount + 1
	return name
end -- 命名

-- 按元素名的配置进行等比裁切、居中、强制尺寸与留白，另导出“观察图”
local function Resize(oldName, tempFile, outputFile, lookFile)
	local tWidth = flag.tWidth(oldName)
	local tHeight = flag.tHeight(oldName)
	local trimWidth = flag.trimWidth(oldName)
	local trimHeight = flag.trimHeight(oldName)

	-- 产出规范化后的最终图
	local cmd = 'magick convert ' ..
		fu.PathString(tempFile) .. ' ' ..
		'-background none ' ..
		'-gravity center ' ..
		'-trim +repage ' ..
		'-resize ' .. tWidth .. 'x' .. tHeight .. '! ' ..
		'-gravity center ' ..
		'-extent ' .. (tWidth + trimWidth) .. 'x' .. (tHeight + trimHeight) .. ' ' ..
		'-resize ' .. tWidth .. 'x' .. tHeight .. '! ' ..
		fu.PathString(outputFile)

	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行与制表符，便于执行
	if flag.isPrint then
		print(gbk.toutf8(cmd))
	end
	os.execute(cmd)

	-- 产出“观察图”（仅裁切+透明背景，方便肉眼比对源素）
	cmd = 'magick convert ' ..
		fu.PathString(tempFile) .. ' ' ..
		'-background none ' ..
		'-gravity center ' ..
		'-trim +repage ' ..
		fu.PathString(lookFile)

	cmd = string.gsub(cmd, '[\n\t]', '')
	if flag.isPrint then
		print(gbk.toutf8(cmd))
	end
	os.execute(cmd)
end

local function GenerateIcon(outputPath, lookPath)
	os.execute("explorer " .. string.gsub(outputPath, "/", "\\"))
	os.execute("explorer " .. string.gsub(lookPath, "/", "\\")) -- 同时打开预览目录
	fu.ForDir(flag.path, function(filePath)
		local oldName, format = fu.GetFile(filePath)
		local name = flag.name(oldName)
		local outputFile = outputPath .. "/" .. name .. ".png"
		local lookFile = lookPath .. "/" .. name .. ".png"
		if not (flag.isPrint) then
			print(gbk.toutf8("生成中..." .. outputFile))
		end
		Resize(oldName, filePath, outputFile, lookFile) -- 第1步：按配置规范化尺寸
		flag.isPrint = false
	end, flag.isSubDir)
end

local outputPath = fu.GetDir(flag.path) .. "/output"
local lookPath = fu.GetDir(flag.path) .. "/look"
local blpPath = fu.GetDir(flag.path) .. "/blp"
lfs.mkdir(outputPath)
lfs.mkdir(lookPath)
lfs.mkdir(blpPath)
iu.Flag(flag) -- 设置 Flag
GenerateIcon(outputPath, lookPath)
BlpLab:ConvertBLP(outputPath, blpPath)
BlpLab:Move(blpPath, path.image.bg)
print(gbk.toutf8("UI元素图片生成完成"))
