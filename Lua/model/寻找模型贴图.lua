local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.utils.copy"

local flag = {
	['path'] = [[D:\模型\模型测试\20221223]], -- 要处理的文件夹
	['mdxTar'] = path.model.test.res -- 移到这里
}
local addr = {
	[[D:\09月11特效]], -- 路径1
	[[D:\模型]], -- 路径2
	[[D:\War3\Maps\ResearchJass\Map]], -- 路径3
	[[D:\War3\War3HDMod\blp]] -- 1.32的高清贴图
}

-- 将目录中的MDX转换MDL
-- 坑警告,第一个参数不能带空格,不然调不起来(可能是task的问题调不起)
local function ConvertMDL()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdx" then
			local cmd = path.model.tool .. ' \
		' .. fu.PathString(filePath)
			cmd = string.gsub(cmd, '[\n\t]', '') -- 将换行符替换掉
			os.execute(cmd)
			print(gbk.toutf8(cmd))
		end
	end, false)
end

-- 从MDL中获取所有图片地址
local function GetAllImage()
	local list = {}
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdl" then
			fu.ReadFile(filePath, function(line)
				if line:match("Image") then
					local content = line:match('"(.+)"')
					if content then
						list[content] = 0
					end
				end
			end)
		end
	end, false)
	local new = {}
	for key, _ in pairs(list) do
		table.insert(new, key)
	end
	return new
end

-- 寻找贴图[重点,for循环中不能remove,所以while]
function SeekBlp(list)
	for _, seekPath in ipairs(addr) do
		if #list == 0 then
			print(gbk.toutf8("[BLP全找到了,退出寻找过程]"))
			break
		end
		fu.EachDir(seekPath, function(dir)
			local index = 1
			while index <= #list do
				local relPath = list[index]
				local name, format = fu.GetFile(relPath)
				local filePath = dir .. '/' .. name .. '.' .. format
				if fu.FileExist(filePath) then
					-- print(gbk.toutf8('[找到了]' .. filePath .. '->' .. flag.path .. '/' .. relPath))
					print(gbk.toutf8('[找到了]' .. filePath))
					copy.ForceCopyBin(filePath, flag.path .. '/' .. relPath)
					table.remove(list, index)
				else
					index = index + 1
				end
			end
		end)
	end
	for _, value in ipairs(list) do
		print(gbk.toutf8('[没找到]' .. value))
	end
end

ConvertMDL()
local blpList = GetAllImage()
SeekBlp(blpList)
print(gbk.toutf8("处理完成啦~"))
