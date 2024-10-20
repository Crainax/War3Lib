package.cpath = package.cpath .. ";./bin/?.dll"
local lfs = require "lfs"
local path = require("lua.path")
local copy = require("lua.compile.Copy")

local timestring = os.date("%Y-%m-%d-%H-%M-%S", os.time())
local targetPath = path.backup.root .. "/lni/" .. timestring

local modules = {}

local function multiCopyFile(srcPath, tarPath)
	-- lfs.chdir(path)
	for file in lfs.dir((srcPath)) do
		if file ~= "." and file ~= ".." then -- 遍历过程中会有这两个,本层和上一层,过滤掉
			local attr = lfs.attributes((srcPath .. "/" .. file))
			if attr.mode == "file" then
				if copy.CopyFile(srcPath .. "/" .. file, tarPath .. "/" .. file) then
					print("成功:" .. srcPath .. "/" .. file .. " -> " .. tarPath .. "/" .. file)
				else
					print("失败:" .. srcPath .. "/" .. file .. " -> " .. tarPath .. "/" .. file)
				end
			end
			if attr.mode == "directory" then
				multiCopyFile(srcPath .. "/" .. file)
			end
		end
	end
end

function modules.StartBackup()
	print("备份目标:" .. targetPath)
	local code = lfs.mkdir(targetPath)
	if code then
		multiCopyFile(path.backup.resource, targetPath)
		os.execute("explorer " .. string.gsub(targetPath, "/", "\\"))
		return true
	end
	return false
end

function modules.StartRecover()
	-- local rPath = "D:/War3/Backup/PhantomOrbit/Lni/normal"
	print("还原路径:" .. targetPath)
	multiCopyFile(targetPath, path.backup.resource)
end

modules.StartRecover()
return modules
