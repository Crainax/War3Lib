local function I3(a, b, c)
	if (a) then
		return b
	else
		return c
	end
end

local function Fact(n)
	if (n > 10) then
		return n
	elseif (n < 3) then
		return n * 2
	else
		return n * 3
	end
end

print("lua1.main")

-- local function mainX() print("lua1.main") end

-- s = "D:/War3/Maps/PhantomOrbit/edit/output.j"
-- s2 = string.gsub(s,"%.j",".i")
-- print(s2)

-- print(utf8.len("你大爷"))
-- print(string.sub("1231你大爷",2,7))
-- print(Fact(1))

-- local a , b , c , ret
-- a = true
-- b = 20.0
-- c = 10
-- ret = I3(a,b,c)
-- print("ret:" .. tostring(ret))

-- Account = { balance = 0,
-- 	withdraw = function (self,v)
-- 				self.balance = selef.balance - v
-- 			end

-- }

-- function Account:deposit( v )
-- 	self.balance = self.balance  + v
-- end

-- Account.deposit(Account,200)

-- -- 元类
-- Rectangle = {area = 0, length = 0, breadth = 0}

-- -- 派生类的方法 new
-- function Rectangle:new (o,length,breadth)
--   o = o or {}
--   setmetatable(o, self)
--   self.__index = self
--   self.length = length or 0
--   self.breadth = breadth or 0
--   self.area = length*breadth;
--   return o
-- end

-- -- 派生类的方法 printArea
-- function Rectangle:printArea ()
--   print("矩形面积为 ",self.area)
-- end

-- r = Rectangle:new(nil,10,20)
-- print (r.length)
-- r:printArea()

-- i = type(0):sub(-1):rep(4)
-- print(i)
-- print(i)
-- print("hehe",i)
-- print(type(0):sub(-1):rep(4))

-- b = "nimabz"
-- print(b:sub(-1))

