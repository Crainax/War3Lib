local lu = require('luaunit')
local inject_code = require('Lua.compile.Inject')

-- 模拟 lfs 和 io 模块
local mock_lfs = {
    dir = function(path)
        return coroutine.wrap(function()
            if path == "D:/WE/KKWE_Plugin/jass" then
                coroutine.yield("test.cfg")
                coroutine.yield("subdir")
            elseif path == "D:/WE/KKWE_Plugin/jass/subdir" then
                coroutine.yield("nested.cfg")
            end
        end)
    end,
    attributes = function(path, attr)
        if attr == "mode" then
            return path:match("subdir$") and "directory" or "file"
        elseif attr == "modification" then
            return os.time()
        end
    end
}

local mock_io = {
    lines = function(path)
        if path:match("test.cfg$") then
            return coroutine.wrap(function()
                coroutine.yield("[general]")
                coroutine.yield("TestFunction1")
                coroutine.yield("[new]")
                coroutine.yield("TestFunction2")
            end)
        elseif path:match("nested.cfg$") then
            return coroutine.wrap(function()
                coroutine.yield("[old]")
                coroutine.yield("TestFunction3")
            end)
        end
    end,
    load = function(path)
        return "-- Test content for " .. path, nil
    end
}

-- 替换真实的 lfs 和 io 模块
_G.lfs = mock_lfs
_G.io = mock_io

-- 测试用例
TestInjectCode = {}

function TestInjectCode:setUp()
    inject_code.new_table = {}
    inject_code.old_table = {}
end

function TestInjectCode:test_scan()
    inject_code:initialize()
    lu.assertEquals(#inject_code.new_table, 2)
    lu.assertEquals(#inject_code.old_table, 2)
    lu.assertNotNil(inject_code.new_table["TestFunction1"])
    lu.assertNotNil(inject_code.new_table["TestFunction2"])
    lu.assertNotNil(inject_code.old_table["TestFunction1"])
    lu.assertNotNil(inject_code.old_table["TestFunction3"])
end

function TestInjectCode:test_detect()
    inject_code:initialize()
    local path = {input = "test_script.j"}
    _G.io.load = function() return "function TestFunction1()\nend\nfunction TestFunction2()\nend", nil end
    local result = inject_code:detect(path)
    lu.assertEquals(#result, 1)
    lu.assertNotNil(result["D:/WE/KKWE_Plugin/jass/test.j"])
end

function TestInjectCode:test_do_inject()
    inject_code:initialize()
    local path = {inject = "test_output.j"}
    local tbl = {["D:/WE/KKWE_Plugin/jass/test.j"] = true}
    local mock_file = {write = function() end, close = function() end}
    _G.io.open = function() return mock_file, nil end
    local result = inject_code:do_inject(path, tbl)
    lu.assertEquals(result, 0)
end

-- 运行测试
lu.run()
