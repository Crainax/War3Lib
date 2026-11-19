#ifndef UITextFontDzMemoryIncluded
#define UITextFontDzMemoryIncluded

// Research-only module, injected AFTER YDLua.j by the compiler's sorted paths.
// Cancel its bootstrap macro: this test runs JASS natives, no Lua VM entry.
#undef SetCameraBounds
#undef DzWriteLog
#define LoggerIncluded

native MergeUnits takes integer qty, integer a, integer b, integer make returns boolean
native SetProduce takes integer qty, integer id, integer town returns boolean

library UITextFontDzMemory
    // Verified ONLY for installed kkapi_local_plugin.dll (DzFrameGetAlpha +0xAC).
    function DzFontRead32 takes integer address returns integer
        return DzFrameGetAlpha(address - 0xAC)
    endfunction

    function DzFontPpem takes integer frame returns integer
        local integer ref = DzFontRead32(frame + 0x30)
        if ref == 0 then
            return 0
        endif
        set ref = DzFontRead32(ref + 0x20)
        if ref == 0 then
            return 0
        endif
        return DzFontRead32(ref + 0xA4)
    endfunction

    // vtable belongs to Game.dll. Walk down within the loaded image, never
    // probe arbitrary process addresses. Refuse unknown PE headers/builds.
    function DzFontGameBase takes nothing returns integer
        local integer vtable = DzFontRead32(DzGetGameUI())
        local integer base = vtable - ModuloInteger(vtable, 65536)
        local integer count = 0
        local integer pe
        loop
            exitwhen count > 205 or base <= 65536
            if DzFontRead32(base) == 0x00905A4D then
                set pe = DzFontRead32(base + 0x3C)
                if pe > 0 and pe < 4096 then
                    if DzFontRead32(base + pe) == 0x4550 and DzFontRead32(base + pe + 8) == 0x56BD0E1C and DzFontRead32(base + pe + 0x50) == 0xCD8000 then
                        return base
                    endif
                endif
                return 0
            endif
            set base = base - 65536
            set count = count + 1
        endloop
        return 0
    endfunction

    // Only finite normal IEEE-754 words; refuses NaN/Inf/subnormal encodings.
    function DzFontWriteWord takes integer address, integer bits returns boolean
        local integer magnitude = bits
        local integer exponent
        local real value
        local real sign = 1.0
        if bits < 0 then
            set magnitude = bits - 0x80000000
            set sign = -1.0
        endif
        set exponent = magnitude / 0x800000
        if exponent == 0 or exponent == 255 then
            return false
        endif
        set value = I2R(ModuloInteger(magnitude, 0x800000) + 0x800000) * sign
        set exponent = exponent - 150
        loop
            exitwhen exponent == 0
            if exponent > 0 then
                set value = value * 2.0
                set exponent = exponent - 1
            else
                set value = value / 2.0
                set exponent = exponent + 1
            endif
        endloop
        call DzSetMemory(address, value)
        return DzFontRead32(address) == bits
    endfunction

    // Registry linked pointer is entry+0x10: name +8, native address +12.
    function DzFontFindNative takes integer game, integer kind returns integer
        local integer env = DzFontRead32(game + 0xBE3740)
        local integer first
        local integer node
        local integer name
        local integer count = 0
        if env == 0 then
            return 0
        endif
        set env = DzFontRead32(env + 0x14)
        if env == 0 then
            return 0
        endif
        set first = DzFontRead32(env + 0x20)
        set node = first
        loop
            exitwhen node == 0 or count >= 10000
            set name = DzFontRead32(node + 8)
            if name > 65536 then
                if kind == 0 then
                    if DzFontRead32(name) == 0x6772654D and DzFontRead32(name + 4) == 0x696E5565 and ModuloInteger(DzFontRead32(name + 8), 0x1000000) == 0x00007374 then
                        return node + 12
                    endif
                elseif kind == 1 then
                    if DzFontRead32(name) == 0x50746553 and DzFontRead32(name + 4) == 0x75646F72 and ModuloInteger(DzFontRead32(name + 8), 0x1000000) == 0x6563 then
                        return node + 12
                    endif
                endif
            endif
            set node = DzFontRead32(node)
            set count = count + 1
            exitwhen node == first
        endloop
        return 0
    endfunction
endlibrary
#endif
