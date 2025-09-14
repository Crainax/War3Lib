local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local BlpLab = {}
local iu = { ['BlpLab'] = BlpLab }

-- 直接记录标志位（初始化）
function iu.Flag(flag)
	iu.flag = flag
	BlpLab.flag = flag
end

-- 合成一张图片（用 convert/composite 将前景叠在背景上）
function iu:Combine(front, back, output, size)
	local cmd = 'magick convert ' ..
		fu.PathString(back) .. ' ' ..
		'-resize ' .. size .. 'x' .. size .. ' ' ..
		'-gravity center ' ..
		fu.PathString(front) .. ' ' ..
		'-resize ' .. size .. 'x' .. size .. ' ' ..
		'-gravity center ' ..
		'-composite ' ..
		output
	cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行与制表符
	os.execute(cmd)
end

-- 发光特效
function iu:Grow(file, outFile)
	if iu.flag.gColor then
		-- 有色发光
		iu:Combine(file, path.image.path .. "/fg4_glow" .. iu.flag.gColor .. ".png", outFile, iu.flag.tSize)
	end
end

-- 背景叠加
function iu:BG(file, outFile)
	if iu.flag.bgColor then
		-- 彩色背景
		iu:Combine(file, path.image.path .. "/bg_item_quality_" .. iu.flag.bgColor .. ".png", outFile, iu.flag.tSize)
	else
		-- 黑色背景
		iu:Combine(file, "canvas:black", outFile, iu.flag.tSize)
	end
end

-- 加边框
function iu:Frame(file)
	if iu.flag.frame then
		-- 自定义边框（DIY）
		local cmd = 'magick mogrify ' ..
			'-shave ' .. iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. ' ' ..
			'-mattecolor ' .. iu.flag.fColor .. ' ' ..
			'-frame ' ..
			iu.flag.frameSize .. 'x' .. iu.flag.frameSize .. '+' .. iu.flag.frameOff .. '+' .. iu.flag.frameOff .. ' ' ..
			'-resize ' .. iu.flag.tSize .. 'x' .. iu.flag.tSize .. ' ' ..
			file
		cmd = string.gsub(cmd, '[\n\t]', '') -- 去除换行与制表符
		-- 可选打印命令
		if iu.flag.isPrint then
			print(gbk.toutf8(cmd)) -- 打印一次
		end
		os.execute(cmd)
	else
		-- 使用原版边框
		self:Combine(path.image.path .. "/btn.png", file, file, iu.flag.tSize)
	end
end

-- 图片高光叠加（从左上开始覆盖到同尺寸）
function iu:Light(file)
	self:Combine(path.image.path .. "/Paoguangx4.png", file, file, iu.flag.size)
end

-- 生成禁用图（灰度蒙层）
function iu:Disable(outputFile, disFile)
	self:Combine(path.image.path .. "/dis.png", outputFile, disFile, iu.flag.size)
end

-- 调用 BLPLab 批量生成 BLP
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
	-- 关闭窗口、回收资源等（若有必要）
end

-- 移动到目标文件夹（区分禁用与正常按钮）
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

-- 移动到目标文件夹（不区分，直接覆盖式拷贝）
function BlpLab:Move(blpPath, newPath)
	fu.ForDir(blpPath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		if format == "blp" then
			copy.ForceCopyBin(filePath, newPath .. "/" .. fileName .. "." .. format)
		end
	end, false)
	os.execute("explorer " .. string.gsub(newPath, "/", "\\"))
end

return iu
