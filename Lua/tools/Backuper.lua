local lfs = require "lfs"
local path = require("Lua.path")
local copy = require("Lua.utils.copy")

local timestring = os.date("%Y-%m-%d-%H-%M-%S", os.time())
local targetPath = nil

local modules = {}

local function multiCopyFile(srcPath, tarPath)
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
				-- 创建目标子目录
				local newTarPath = tarPath .. "/" .. file
				lfs.mkdir(newTarPath)
				-- 递归时传入正确的源路径和目标路径
				multiCopyFile(srcPath .. "/" .. file, newTarPath)
			end
		end
	end
end

--- 备份资源目录到备份目录(然后再开始W3xLni覆盖原资源目录)
function modules.StartBackup()
	if targetPath == nil then
		targetPath = path.backup.root .. "/lni/" .. timestring
	end
	print("备份目标:" .. targetPath)
	local code = lfs.mkdir(targetPath)
	if code then
		multiCopyFile(path.backup.resource, targetPath)
		os.execute("explorer " .. string.gsub(targetPath, "/", "\\"))
		return true
	end
	return false
end

--- 将备份目录的内容还原到资源目录(Lni之后)
function modules.StartRecover()
	if targetPath == nil then
		targetPath = path.backup.root .. "/lni/" .. timestring
	end
	print("还原路径:" .. targetPath)
	multiCopyFile(targetPath, path.backup.resource)
end

return modules
