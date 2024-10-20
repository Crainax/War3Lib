-- package.cpath = package.cpath .. ";./bin/?.dll"
local lfs = require "lfs"
local fu = {}

-- 局部函数:读文件,并写进表
local ReadFile = function(file)
	assert(file, "file open error!")
	local fileTab = {}
	local line = file:read()
	while line do
		table.insert(fileTab, line)
		line = file:read()
	end
	return fileTab
end

-- 局部函数:写文件,函数指针传入
local WriteFile = function(file, fileTab, func)
	assert(file, "file open failed")
	for i, line in ipairs(fileTab) do
		line = func(line)
		if line then
			file:write(line)
			file:write("\n")
		end
	end
end

-- 读取一个文件,每行字符串使用func进行处理重写,func参数一个字符串,返回处理后的字符串
function fu.ExecuteFile(fileName, func)
	local fileRead = io.open(fileName)
	if fileRead then
		local tab = ReadFile(fileRead)
		fileRead:close()
		local fileWrite = io.open(fileName, "w")
		if fileWrite then
			WriteFile(fileWrite, tab, func)
			fileWrite:close()
		end
	end
	return true
end

-- 只遍历一遍文件(不进行重写)
function fu.ReadFile(fileName, func)
	local file = io.open(fileName, "r")
	if file then
		local line = file:read()
		while line do
			func(line)
			line = file:read()
		end
		file:close()
	end
	return true
end

-- 获取一个文件的所有文本内容
function fu.GetContent(fileName)
	local file = io.open(fileName, "r")
	if file then
		local result = file:read("a")
		file:close()
		return result
	end
end

-- 在文件最后写东西
function fu.WriteLast(fileName, content)
	local fileWrite = io.open(fileName, "a+")
	if fileWrite then
		fileWrite:write(content)
		fileWrite:close()
		return true
	end
end

-- 覆盖创建一个新文件
function fu.WriteOver(fileName, content)
	local fileWrite = io.open(fileName, "w+")
	if fileWrite then
		fileWrite:write(content)
		fileWrite:close()
		return true
	end
end

-- 遍历文件夹并做出操作[func:文件路径]
function fu.ForDir(srcPath, func, isSub)
	for file in lfs.dir((srcPath)) do
		if file ~= "." and file ~= ".." then -- 遍历过程中会有这两个,本层和上一层,过滤掉
			local attr = lfs.attributes((srcPath .. "/" .. file))
			if attr.mode == "file" then
				func(srcPath .. "/" .. file)
			end
			if isSub then
				if attr.mode == "directory" then
					fu.ForDir(srcPath .. "/" .. file, func, isSub)
				end
			end
		end
	end
end

-- 遍历文件夹[仅针对文件夹]
function fu.EachDir(srcPath, func)
	func(srcPath)
	for file in lfs.dir((srcPath)) do
		if file ~= "." and file ~= ".." then -- 遍历过程中会有这两个,本层和上一层,过滤掉
			local attr = lfs.attributes((srcPath .. "/" .. file))
			if attr.mode == "directory" then
				fu.EachDir(srcPath .. "/" .. file, func)
			end
		end
	end
end

-- 路径生成:自动在前面与后面加上"
function fu.PathString(str)
	-- local str = path:string()
	if str:sub(-1) == '\\' then
		return '"' .. str .. ' "'
	else
		return '"' .. str .. '"'
	end
end

-- 截取获取一个全路径文件的文件名与格式
function fu.GetFile(filePath) return string.match(filePath, "([^%/\\]+)%.([^%.]+)$") end

-- 截取获取一个全路径文件的对应路径
function fu.GetDir(filePath)
	if fu.GetFile(filePath) then
		local result = string.gsub(filePath, "[%/\\][^%/\\]+$", "")
		return result
	end
	return filePath
end

-- 给一个文件路径加上后缀(123.png -> 123_1.png)
function fu.Suffix(filePath, suffix)
	local dir = fu.GetDir(filePath)
	local name, type = fu.GetFile(filePath)
	return dir .. "/" .. name .. suffix .. "." .. type
end

-- 清空一个文件夹里所有东西(包括子文件夹)[需要传入GBK]
function fu.clearDir(path) fu.ForDir(path, function(filePath) os.remove(filePath) end, true) end

-- 使用mkdir前可以用这个办法判断文件夹是否存在
function fu.DirExist(path)
	local _, _, v = io.open(path, "r")
	return v ~= 2
end

function fu.FileExist(file) return io.open(file, "r") ~= nil end

-- 使用mkdir来直接创建一个文件夹(无视当前目录)
function fu.Mkdir(path) os.execute('mkdir "' .. path .. '"') end

-- local filePath = "D:/War3/创世UI/Test/equit/battlepass_task_icon_004.png"
-- local filePath2 = [[D:\War3\创世UI\Test\equit\battlepass_task_icon_004.png]]
-- print(tostring(modules.GetDir(filePath)))
-- print(modules.GetFile(filePath))
-- print(modules.GetFile(filePath2))
-- print(modules.Suffix(filePath, "_2"))
-- modules.clearDir("D:/War3/创世UI/Test/gif/rename")
-- print(modules.FileExist([[D:\War3\Maps\ResearchJass\ResearchJas2s.sublime-project]]))

return fu
