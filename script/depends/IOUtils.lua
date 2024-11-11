iou = {} -- 不能用局部

local path = {
	['test'] = [[D:\War3\Maps\PhantomOrbit\logs\TestFile.txt]], --
	['test2'] = [[D:\War3\Maps\PhantomOrbit\logs\TestFile2.txt]] --
}

iou.Read = function(p)
	local file = io.open(path.test)
	if file then
		local line = file:read()
		while line do
			print(line)
			line = file:read()
		end
		file:close()
	else
		print("没打开成功.")
	end
end

-- 目前来说无法写[无写的权限]
iou.WriteOver = function(content)
	local fileWrite, msg = io.open(path.test2, "wb")
	if fileWrite then
		for i = 1, 20 do
			fileWrite:write(content .. i .. '\n')
		end
		fileWrite:close()
		print("写了哦.")
	else
		print("失败." .. tostring(msg))
	end
end

-- iou.WriteOver("你妈BBBDFLKJSDF")

