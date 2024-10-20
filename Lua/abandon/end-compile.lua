local filePath = "D:/War3/Maps/PhantomOrbit/edit/AllJass.h"

--编译完成后,改回undef
function ReadFile(file)
    assert(file,"file open error!")
    local fileTab = {}
    local line = file:read()
    while line do
        table.insert(fileTab,line)
        line = file:read()
    end
    return fileTab
end

function WriteFile(file,fileTab)
    assert(file,"file open failed!")
    for i, line in ipairs(fileTab) do
        if (string.match(line,"^%s*#undef%s*CompileTestLibraryIncluced") or string.match(line,"^%s*#define%s*CompileTestLibraryIncluced")) then
            file:write("#undef CompileTestLibraryIncluced")
        else
            file:write(line)
        end
        file:write("\n")
    end
end

function main()
    print"end-compile Start!"
    local fileRead = io.open(filePath)
    if fileRead then
        local tab = ReadFile(fileRead)
        fileRead:close()
        local fileWrite = io.open(filePath,"w")
        if fileWrite then
            WriteFile(fileWrite,tab)
            fileWrite:close()
        end
    end
end

main()
