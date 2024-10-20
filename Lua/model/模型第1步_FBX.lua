local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.compile.Copy"
local iu = require "lua.image.ImageUtils"
local BlpLab = iu.BlpLab

local flag = {
	['path'] = [[D:\模型\创世轨迹\安徒生]], -- 要处理的文件夹
	['isPrint'] = true, -- 打印命令行
	['size'] = 512 -- dds文件的尺寸
}

-- 将文件夹内的所有X转成FBX
local function ConvertX(filePath)
	local name = fu.GetFile(filePath)
	copy.CopyBin(filePath, path.model.jump2fbx .. "/" .. name .. ".x")
	local cmd = 'jump2fbx.exe \
			' .. name .. '.x \
			' .. name .. '.fbx'
	cmd = cmd:gsub('[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
	copy.CopyBin(path.model.jump2fbx .. "/" .. name .. ".fbx", flag.path .. "/" .. name .. ".fbx")
end

-- 将文件夹内的DDS转成PNG,再转成BLP放进Crainax里
function ConvertDDS(filePath, output)
	local cmd = 'magick convert \
	' .. fu.PathString(filePath) .. ' \
	-resize ' .. flag.size .. 'x' .. flag.size .. '! \
	' .. fu.PathString(output)
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	-- 输出文件名
	if flag.isPrint then
		print(gbk.toutf8(cmd)) -- 打印一次
	end
	os.execute(cmd)
end

local function StartConvert(tempPath)
	lfs.chdir(path.model.jump2fbx)
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "dds" then
			ConvertDDS(filePath, tempPath .. "/" .. name .. ".png")
			print(gbk.toutf8("dds" .. filePath))
		elseif format:lower() == "x" then
			ConvertX(filePath)
		end
	end, false)
end

local tempPath = fu.GetDir(flag.path) .. "/temp"
local blpPath = fu.GetDir(flag.path) .. "/crainax"
lfs.mkdir(tempPath)
lfs.mkdir(blpPath)
StartConvert(tempPath)
BlpLab:ConvertBLP(tempPath, blpPath)
