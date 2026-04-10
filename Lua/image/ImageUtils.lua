local fu = require "lua.utils.FileUtils"
local lfs = require "lfs"
local gbk = require "gbk"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local BlpLab = {}
local iu = { ['BlpLab'] = BlpLab }

local SUPPORTED_EXT = {
	png = true,
	bmp = true,
	jpg = true,
	jpeg = true,
	tga = true,
	dds = true,
	gif = true,
	webp = true
}

local function fileExists(filePath)
	local file = io.open(filePath, "rb")
	if file then
		file:close()
		return true
	end
	return false
end

local function resolveBlpNetCl()
	if iu.flag and iu.flag.blpCliExe and fileExists(iu.flag.blpCliExe) then
		return iu.flag.blpCliExe
	end

	local base = path.image.blplab
	local candidates = {
		base .. "/BLP.NET.CL/BLP.NET/blpnetcl.exe",
		base .. "/blpnetcl.exe"
	}
	for _, exePath in ipairs(candidates) do
		if fileExists(exePath) then
			return exePath
		end
	end
	return nil
end

local function runSilentBlpConvert(sourcePath, destPath)
	local cliExe = resolveBlpNetCl()
	if not cliExe then
		return false, "未找到 blpnetcl.exe。"
	end

	fu.createDir(destPath)

	local cliArgs = ""
	if iu.flag and iu.flag.blpCliArgs then
		cliArgs = iu.flag.blpCliArgs
	end

	local converted = 0
	local failed = 0

	fu.ForDir(sourcePath, function(filePath)
		local fileName, format = fu.GetFile(filePath)
		local ext = format and string.lower(format) or nil

		if not fileName or not ext or not SUPPORTED_EXT[ext] then
			return
		end

		local outputFile = destPath .. "/" .. fileName .. ".blp"
		local cmd = 'cmd /c ""' .. cliExe .. '" "' .. string.gsub(filePath, "/", "\\") .. '" "' ..
			string.gsub(outputFile, "/", "\\") .. '"'
		if cliArgs ~= "" then
			cmd = cmd .. " " .. cliArgs
		end
		cmd = cmd .. '"'

		os.execute(cmd)
		if fileExists(outputFile) then
			converted = converted + 1
		else
			failed = failed + 1
			print("BLP 静默转换失败: " .. filePath)
		end
	end, false)

	if failed > 0 then
		return false, string.format("成功 %d, 失败 %d", converted, failed)
	end

	return true, string.format("成功转换 %d 个文件", converted)
end

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
	local ok, msg = runSilentBlpConvert(pngPath, blpPath)
	if ok then
		print("BLP 静默转换完成: " .. msg)
		return true
	end

	print("警告: " .. msg)
	if iu.flag and iu.flag.blpDisableGuiFallback then
		print("已禁用 GUI 回退，跳过 blplab.exe。")
		return false
	end

	print("回退到 blplab.exe（需要手动点击开始）...")
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
	return true
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
