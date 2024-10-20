local backuper = require("lua.tools.Backuper")
local w3x = require("lua.compile.W3xLni")

if backuper.StartBackup() then
    print("备份结束,成功!")
    w3x.StartLNI()
    if arg[1] then
        print("开始还原文件!")
        backuper.StartRecover()
    end
else
    print("备份失败,停止LNI")
end
-- return modules
