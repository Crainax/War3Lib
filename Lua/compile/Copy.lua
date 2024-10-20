local fu = require("lua.utils.FileUtils")
local modules = {}

-- 将src的文件复制到tar文件中
-- 无视文件存在,但是仅针对文本文件
function modules.CopyFile(src, tar)
	local srcFile = io.open(src, "r")
	if srcFile then
		local content = srcFile:read("a")
		srcFile:close()
		local file, msg = io.open(tar, "w") -- 创建文件
		if not (file) then return false, msg end
		file:write(content)
		file:close()
		return true
	end
end

-- 将src的文件复制到tar文件中
-- 会覆写,针对二进制文件
function modules.CopyBin(src, tar)
	local srcFile = io.open(src, "rb")
	local content = srcFile:read("a")
	srcFile:close()
	local file, msg = io.open(tar, "wb") -- 创建文件
	if not (file) then return false, msg end
	file:write(content)
	file:close()
	return true
end

-- 强制复制(没有文件夹的话就强制新建一个文件夹)
function modules.ForceCopyBin(src, tar)
	local dir = fu.GetDir(tar) -- 对应子文件夹是否存在
	if not (fu.DirExist(dir)) then
		fu.Mkdir(dir) -- 创建文件夹
	end
	return modules.CopyBin(src, tar)
end

function modules.IsExist(fileName)
	return io.open(fileName, "r")
end

return modules
