package.cpath = package.cpath .. ";./bin/?.dll"
local lfs = require "lfs"
local gbk = require "gbk"

local workPath = [[H:\素材\300_7\ui\icon\skin]] -- 处理的文件夹路径
local destPath = workPath .. "的提取" -- 目标的文件夹路径
local filetype1 = "bmp" -- 要提取的文件类型,可以写*来全部匹配
local filetype2 = "txt222222" -- 要提取的文件类型,可以写*来全部匹配
local count = 0

-- 递归遍历文件夹所有内容并提取到目标文件夹
local function executeFile(path, prefix)
	-- lfs.chdir(path)
	for file in lfs.dir((path)) do
		if file ~= "." and file ~= ".." then -- 遍历过程中会有这两个,本层和上一层,过滤掉
			-- print((path .. "/" .. file))
			local attr = lfs.attributes((path .. "/" .. file))
			if attr.mode == "file" and string.match(file, "%." .. filetype1 .. "$") or string.match(file, "%." .. filetype2 .. "$") then
				os.rename((path .. "/" .. file), (destPath .. "/" .. prefix .. "_" .. file))
				print(gbk.toutf8("提取成功:" .. destPath .. "/" .. prefix .. "_" .. file))
				-- print(destPath .. "/" .. prefix .. "_" .. file)
				count = count + 1
			end
			-- for key, value in pairs(attr) do print(key, value) end
			if attr.mode == "directory" then
				if prefix == "" then
					executeFile(path .. "/" .. file, file)
				else
					executeFile(path .. "/" .. file, prefix .. "_" .. file)
				end
			end
		end
	end
end

-- 我真的是吐了,还得转gbk。
lfs.mkdir((destPath))
executeFile(workPath, "")
print(gbk.toutf8("提取结束"))
os.rename(destPath, destPath .. "(" .. count .. "个)")
