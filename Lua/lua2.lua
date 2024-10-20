
package.cpath = package.cpath .. ";./bin/?.dll"
local gbk = require "gbk"

-- function Sleep(n)
-- 	if n > 0 then
-- 		os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL")
-- 	end
-- end
-- print("start!")
-- Sleep(1)
-- print("end")
----------------------------------------------
-- local modules = {a = 1, b = 2}
-- function modules:Add()
--     return (self.a + self.b)
-- end
-- print(modules:Add())
----------------------------------------------
-- for i = 1, 20, 1 do
-- 	print(string.format("%02d", i))
-- end
----------------------------------------------
-- local name1 = [[D:/War3/创世UI/光效/看上的1/UI 界面 技能特效序列帧376套+赠品_349-352 边框 4组 中等大小_tx_item_blue_001.png]]
-- local name2 = [[D:/War3/创世UI/光效/看上的1/s (13).png]]

-- function string:gifIndex()
-- 	return tonumber(self:match("_(%d+)%.png$") or self:match("%((%d+)%)%.png$"))
-- end

-- local listName1 = tonumber(name1:gifIndex())
-- local listName2 = tonumber(name2:gifIndex())
-- print(gbk.toutf8(tostring(listName1)))
-- print(gbk.toutf8(tostring(listName2)))
----------------------------------------------
-- local name1 = [[UI 界面 技能特效序列帧376套+赠品_349-352 边框 4组 中等大小_tx_item_blue_001]]
-- local name2 = [[s (13)]]

-- function string:gifPrefix() return self:gsub('_%d+$', ''):gsub(' %(%d+%)$', '') end

-- local listName1 = name1:gifPrefix()
-- local listName2 = name2:gifPrefix()
-- print(gbk.toutf8(tostring(listName1)))
-- print(gbk.toutf8(tostring(listName2)))
----------------------------------------------
-- os.execute([[explorer D:\模型\创世轨迹\安徒生\output.txt]])
----------------------------------------------
-- local line = "14200: { 1.52588E-5, 7.62939E-6, 7.15256E-7 },"
-- local line = "9166: { -0.497088, 0.311569, 0.66951 },"
-- local line = "		10000: { 0.01, 0.0009002691, -0.0005617141 },"
-- local temp = line:gsub("%-?[0-9%.]+E%-%d+", "0"):gsub("%-?0%.0+%d+","0")
-- print(temp)
----------------------------------------------
-- local line = [[1333: { 0, 0, 0 },]]
local line = [[866: { 0, 0, -5.28552 },]]
-- local line = [[		1900: { -68.9546, 120.854, -0.386993 },]]
-- local line = [[		Linear,]]
local a, b, c = line:match("{%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*,%s*([0-9%-%.]+)%s*}")
if a and b and c then
	if tonumber(a) ~= 0 or tonumber(b) ~= 0 or tonumber(c) ~= 0 then
        print("hold")
	end
end