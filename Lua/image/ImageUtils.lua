local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.compile.Copy"

local BlpLab = {}
local iu = {['BlpLab'] = BlpLab}

-- 直接在这初始化表
function iu.Flag(flag)
	iu.flag = flag
	BlpLab.flag = flag
end

-- 合并一张图片(用composite合并psd好像会有点问题,还是convert香)
function iu:Combine(front, back, output, size)
	local cmd = 'magick convert \
	' .. fu.PathString(back) .. ' \
	-resize ' .. size .. 'x' .. size .. ' \
	-gravity center \
	' .. fu.PathString(front) .. ' \
	-resize ' .. size .. 'x' .. size .. ' \
	-gravity center \
	-composite \
	' .. output
	cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
	os.execute(cmd)
end

-- 加后光晕
function iu:Grow(file, outFile)
	if iu.flag.gColor then
		-- 有色背景
		iu:Combine(file, path.image.path .. "/fg4_glow" .. iu.flag.gColor .. ".png", outFile, iu.flag.tSize)
	end
end

-- 创建背景
function iu:BG(file, outFile)
	if iu.flag.bgColor then
		-- 有色背景
		iu:Combine(file, path.image.path .. "/bg_item_quality_" .. iu.flag.bgColor .. ".png", outFile, iu.flag.tSize)
	else
		-- 黑色背景
		iu:Combine(file, "canvas:black", outFile, iu.flag.tSize)
	end
end

-- 加边框
function iu:Frame(file)
	if iu.flag.frame then
		-- DIY边框
		local cmd = 'magick mogrify \
		-shave ' .. iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. ' \
		-mattecolor ' .. iu.flag.fColor .. ' \
		-frame ' .. iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. '+' .. iu.flag.frameOff .. '+' .. iu.flag.frameOff .. ' \
		-resize ' .. iu.flag.tSize .. 'x' .. iu.flag.tSize .. ' \
		' .. file
		cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
		-- 输出文件名
		if iu.flag.isPrint then
			print(gbk.toutf8(cmd)) -- 打印一次
		end
		os.execute(cmd)
	else
		-- 原生边框
		self:Combine(path.image.path .. "/btn.png", file, file, iu.flag.tSize)
	end
end

-- 图标抛光与变小[在这里就开始变成最终大小了]
function iu:Light(file)
	self:Combine(path.image.path .. "/Paoguangx4.png", file, file, iu.flag.size)
end

-- 生成暗图标
function iu:Disable(outputFile, disFile)
	self:Combine(path.image.path .. "/dis.png", outputFile, disFile, iu.flag.size)
end

-- 打开BLPLAB
function BlpLab:ConvertBLP(pngPath, blpPath)
	fu.ExecuteFile(path.image.blplab .. '/blplab.ini', function(line)
		if (string.match(line, "SourceFolder")) then
			line = "SourceFolder=" .. string.gsub(pngPath, "/", "\\")
		elseif (string.match(line, "DestFolder")) then
			line = "DestFolder=" .. string.gsub(blpPath, "/", "\\")
		end
		return line
	end)
	os.execute(fu.PathString(path.image.blplab .. "/blplab.exe"))
	-- 关闭程序后才会继续往下运行
end

-- 移到项目文件
function BlpLab:MoveBLP(blpPath)
	fu.ForDir(blpPath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		if format == "blp" then
			if fileName:match("^dis") then
				copy.CopyBin(filePath, path.image.disbtn .. "/" .. fileName .. "." .. format)
			else
				copy.CopyBin(filePath, path.image.btn .. "/" .. fileName .. "." .. format)
			end
		end
	end, false)
	os.execute("explorer " .. string.gsub(path.image.btn, "/", "\\"))
	os.execute("explorer " .. string.gsub(path.image.disbtn, "/", "\\"))
end

-- 移到项目文件[特效序列帧]
function BlpLab:Move(blpPath, newPath)
	fu.ForDir(blpPath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		if format == "blp" then copy.ForceCopyBin(filePath, newPath .. "/" .. fileName .. "." .. format) end
	end, false)
	os.execute("explorer " .. string.gsub(newPath, "/", "\\"))
end

return iu
