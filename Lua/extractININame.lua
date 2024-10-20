local filePath = "D:/War3/Maps/PhantomOrbit/lua/edit.ini"

-- 提取文件里的Name

function ReadFile(file)
    assert(file,"file open failed")
    local fileTab = {}
    local line = file:read()
    while line do
        -- print("get line",line)
        table.insert(fileTab,line)
        line = file:read()
    end
    return fileTab
end
 
function WriteFile(file,fileTab)
    assert(file,"file open failed")
    for i,line in ipairs(fileTab) do
        -- print(i,line)
        if (string.match(line,"Name") or string.match(line,"%[()()()()")) then
	        file:write(line)
	        file:write("\n")
        end
    end
end
 
function main()
    print("start")
    local fileRead = io.open(filePath)
    if fileRead then
        local tab = ReadFile(fileRead)
        fileRead:close()
        -- table.remove(tab,1)
        local fileWrite = io.open(filePath,"w")
        if fileWrite then
            WriteFile(fileWrite,tab)
            fileWrite:close()
        end
    end
end
 
main()
s1 = "   Missilespeed = 0"
s2 = "   Name = \"影遁\""
s3 = "[Sshm]"
s4 = "[AAns]"

-- if (string.match(s3,"%[()()()()")) then
