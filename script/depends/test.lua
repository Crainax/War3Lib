local japi = require("jass.japi")
local jass = require("jass.common")
local g = require("jass.globals")
local hook = require("jass.hook")
local bignum = require("jass.bignum")
local dbg = require("jass.debug")


-- 创建一个测试函数
local function test_bignum()
    -- 创建新的大数
    local num1 = bignum.new('123456789123456789')
    local num2 = bignum.new('987654321987654321')

    -- 测试hex转换
    print("num1的十六进制表示: " .. bignum.hex(num1)) -- 没东西
    print(num1) -- 显示123456789123456789
    print(tostring(num1)) -- 显示123456789123456789
    print(type(num1)) -- 显示userdata

    -- 测试bin转换
    print("num1的二进制表示: " .. bignum.bin(num1))

    -- 测试sha1
    print("num1的SHA1值: " .. bignum.sha1(num1))

    -- 在游戏中也显示一些信息
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 60, "大数测试完成，请查看控制台输出")
end

-- test_bignum()




local tr = jass.CreateTrigger()
jass.TriggerRegisterTimerEvent(tr, 0.5,false)
jass.TriggerAddCondition(tr,jass.Condition(function ()
    print("1111")
end))
print("tr: " .. tr)
print("tr's type: " .. type(tr))


g.trr = jass.CreateTrigger()
jass.TriggerAddCondition(g.trr, jass.Condition(function()
    print("cccc")
end))
print("g.trr: " .. g.trr)
print("g.trr's type: " .. type(g.trr))

print(table.unpack(dbg.functiondef(jass.GetUnitX)))  -- 打印 R H
-- print(table.unpack(dbg.globaldef(g.testhaha))) -- 直接报错


