local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local font = require "lua.font"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\War3\War3HDMod\png]], -- 要处理的文件夹
	['tarPath'] = [[D:\War3\War3HDMod\png]], -- 移到这里
	['isPrint'] = true                    -- 是否打印命令
}

local function ConvertPNG(filePath, output)
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 将换行符替换掉
	-- 打印命令
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一下
	end
	os.execute(cmd)
	print(gbk.toutf8("转换完成..." .. output))
end

local function Resize(filePath)
	-- -resize "512x512>" \   移到这里，这是强制把图片缩小
	local cmd = 'magick mogrify \
    -resize 50% \
	' .. fu.PathString(filePath)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 将换行符替换掉
	-- 打印命令
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一下
	end
	os.execute(cmd)
	print(gbk.toutf8("缩小完成了..." .. filePath))
end

local function Convert()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "dds" then
			ConvertPNG(filePath, flag.tarPath .. "/" .. name .. ".png")
		end
	end, false)
end

local function ResizePNG()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "png" then
			Resize(filePath)
		end
	end, false)
end

-- Convert()
ResizePNG()
print(gbk.toutf8("处理完成"))
