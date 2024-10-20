local fu = require "lua.utils.FileUtils"
local gbk = require "gbk"
local lfs = require "lfs"
local path = require "lua.path"
local copy = require "lua.compile.Copy"

local flag = {
	['path'] = [[D:\模型\模型测试\20221223]], -- 要处理的文件夹
	['mdxTar'] = path.model.test.res -- 移到哪里
}
local addr = {
	[[D:\09和11特效]], -- 路径1
	[[D:\模型]], -- 路径2
	[[D:\War3\Maps\ResearchJass\Map]], -- 路径3
	[[D:\War3\War3HDMod\blp]] -- 1.32的高清贴图
}

-- 把目录里的MDX转成MDL
-- 我悟了,第一个参数不能带空格,不然调用不了(除非在task里就能调用)
local function ConvertMDL()
	fu.ForDir(flag.path, function(filePath)
		local name, format = fu.GetFile(filePath)
		if format:lower() == "mdx" then
			local cmd = path.model.tool .. ' \
		' .. fu.PathString(filePath)
			cmd = string.gsub(cmd, '[\n\t]', '') -- 命令行方便换行
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

-- 寻找[吐了,for循环中不能remove,得用while]
function SeekBlp(list)
	for _, seekPath in ipairs(addr) do
		if #list == 0 then
			print(gbk.toutf8("[BLP找完了,退出寻找过程]"))
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
print(gbk.toutf8("任务结束啦~"))
