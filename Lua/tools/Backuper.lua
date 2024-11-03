--[[
    资源备份还原工具
    功能: 在进行W3xLni转换前,对地图资源进行备份,并支持转换后的还原操作

    主要功能:
    1. StartBackup(): 备份功能
       - 在backup/lni/目录下创建以时间戳命名的备份文件夹
       - 递归复制所有资源文件到备份目录
       - 备份完成后自动打开备份目录

    2. StartRecover(): 还原功能
       - 将之前备份的文件还原到原始资源目录
       - 用于W3xLni转换后的资源恢复

    使用场景:
    在魔兽地图开发中,使用W3xLni工具转换地图时,可能会对原始资源造成影响
    该工具提供了一个安全机制,确保在转换出问题时可以快速还原资源

    备份文件结构:
    backup/
      └─ lni/
          └─ 2024-03-21-10-30-00/  (时间戳文件夹)
              └─ (备份的资源文件)
]]

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
