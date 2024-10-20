local filePath = "D:\\War3\\Maps\\PhantomOrbit\\edit\\testmain.i"

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
        -- print("write ",line)
        line = string.gsub(line,"<%?='\\n'%?>","\n")
        file:write(line)
        file:write("\n")
    end
end
 
function main()
    -- print("start")
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
