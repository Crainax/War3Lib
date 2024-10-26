library NFTSUTF8 initializer Init
    globals
        private hashtable ht=InitHashtable()
    endglobals
    private function chsize takes integer i returns integer
        if i==0 then
            return 1
        elseif i>240 then
            return 4
        elseif i>225 then
            return 3
        elseif i>192 then
            return 2
        else
            return 1
        endif
    endfunction
    function NFTSUTF8Len takes string s returns integer
        local integer len=0
        local integer index=1
        local integer i
        local integer ll=StringLength(s)
        loop
            exitwhen index>ll
            if HaveSavedInteger(ht,0,StringHash(SubString(s,index-1,index))) then
                set i=LoadInteger(ht,0,StringHash(SubString(s,index-1,index)))
            else
                set i=0
            endif
            set index=index+chsize(i)
            set len=len+1
        endloop
        return len
    endfunction
    function NFTSUTF8Sub takes string s,integer i1,integer i2 returns string
        local integer index=1
        local integer i
        local integer l
        local integer ll=StringLength(s)
        local integer si=i1
        local integer ei=i2
        loop
            exitwhen i1<=1
            if HaveSavedInteger(ht,0,StringHash(SubString(s,index-1,index))) then
                set i=LoadInteger(ht,0,StringHash(SubString(s,index-1,index)))
            else
                set i=0
            endif
            set index=index+chsize(i)
            set i1=i1-1
        endloop
        set l=index
        loop
            if i2>0 and l<=ll then
                if HaveSavedInteger(ht,0,StringHash(SubString(s,l-1,l))) then
                    set i=LoadInteger(ht,0,StringHash(SubString(s,l-1,l)))
                else
                    set i=0
                endif
                set l=l+chsize(i)
                set i2=i2-1
                if si==ei then
                    exitwhen true
                endif
            else
                exitwhen true
            endif
        endloop
        return SubString(s,index-1,l-1)
    endfunction
    private function Init takes nothing returns nothing
        local integer i
        local unit u
        <?
            local slk=require('slk')
            local str=""
            for i=192,255 do
                str=str..string.char(i)
            end
            local obj=slk.unit.ewsp:new("utf8")
                obj.Name=str
        ?>
        set u=CreateUnit(Player(13),'utf8',0,0,0)
        call ShowUnit(u,false)
        set i=192
        loop
            call SaveInteger(ht,0,StringHash(SubString(GetUnitName(u),i-192,i-191)),i)
            set i=i+1
            exitwhen i>255
        endloop
        call RemoveUnit(u)
        set u=null
    endfunction
endlibrary

