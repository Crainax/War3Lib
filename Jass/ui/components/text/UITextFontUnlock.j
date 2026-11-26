#ifndef UITextFontUnlockIncluded
#define UITextFontUnlockIncluded

// 短暂解开 Game.dll 的 32 ppem 上限，设置完立即恢复原指令。
// 只接受已核对的 1.27.0.52240。版本不符时返回 false，调用方继续走原生 DzFrameSetFont。
native MergeUnits takes integer qty, integer a, integer b, integer make returns boolean
native SetProduce takes integer qty, integer id, integer town returns boolean

library UITextFontUnlock
    // 仅核对过 kkapi_local_plugin.dll：DzFrameGetAlpha 读的是 frame+0xAC 的 4 字节。
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

    // 从游戏 UI 虚表沿对齐边界找回 Game.dll，并核对 PE 时间戳与镜像大小。
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

    // 只接受有限的普通 IEEE-754 编码，拒绝 NaN、无穷和非规格化数。
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

    // 注册表节点：+8 是名字，+12 是 native 地址。kind 0 = MergeUnits，1 = SetProduce。
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

    globals
        private integer patchBase = 0
        private integer mergeSlot = 0
        private integer produceSlot = 0
        private integer mergeOriginal = 0
        private integer produceOriginal = 0
        private integer patchState = 0
        private boolean patchBusy = false
    endglobals

    private function Original takes nothing returns boolean
        if patchBase == 0 or mergeSlot == 0 or produceSlot == 0 then
            return false
        endif
        return DzFontRead32(patchBase + 0xDA5AD) == 0x7E20F883 and DzFontRead32(patchBase + 0xDA5B1) == 0x0020B807 and DzFontRead32(patchBase + 0xDA5B5) == 0x1DEB0000 and DzFontRead32(patchBase + 0xE125E) == 0x7E20F883 and DzFontRead32(patchBase + 0xE1262) == 0x0020B807 and DzFontRead32(patchBase + 0xE1266) == 0x1DEB0000 and DzFontRead32(mergeSlot) == mergeOriginal and DzFontRead32(produceSlot) == produceOriginal
    endfunction

    // 第 4 个参数必须是可写的 4 字节。用调用方 frame+0xAC，读完后按进入时的透明度写回。
    private function Protect takes integer frame, integer address, integer protection returns integer
        local boolean ok
        local boolean restored
        local integer previous
        local integer alpha
        if frame == 0 or not DzFontWriteWord(mergeSlot, DzFontRead32(patchBase + 0x94E0F4)) then
            return 0
        endif
        set alpha = DzFrameGetAlpha(frame)
        set ok = MergeUnits(address, 4, protection, frame + 0xAC)
        set previous = DzFontRead32(frame + 0xAC)
        set restored = DzFontWriteWord(mergeSlot, mergeOriginal)
        call DzSetMemory(frame + 0xAC, 0.0)
        call DzFrameSetAlpha(frame, alpha)
        if not ok or not restored then
            return 0
        endif
        return previous
    endfunction

    private function FlushInstructions takes nothing returns boolean
        local boolean ok
        local boolean restored
        if not DzFontWriteWord(produceSlot, DzFontRead32(patchBase + 0x94E274)) then
            return false
        endif
        set ok = SetProduce(-1, 0, 0)
        set restored = DzFontWriteWord(produceSlot, produceOriginal)
        return ok and restored
    endfunction

    private function Patch takes integer frame, boolean enable returns boolean
        local integer word = 0xB8077E20
        local integer p1
        local integer p2
        local boolean ok1
        local boolean ok2
        local boolean flushed
        local integer expected = 0xEB20F883
        if enable then
            set word = 0xB807EB20
            set expected = 0x7E20F883
        endif
        if DzFontRead32(patchBase + 0xDA5AD) != expected or DzFontRead32(patchBase + 0xE125E) != expected or DzFontRead32(patchBase + 0xDA5B1) != 0x0020B807 or DzFontRead32(patchBase + 0xE1262) != 0x0020B807 or DzFontRead32(patchBase + 0xDA5B5) != 0x1DEB0000 or DzFontRead32(patchBase + 0xE1266) != 0x1DEB0000 then
            return false
        endif
        set p1 = Protect(frame, patchBase + 0xDA5AF, 0x40)
        if p1 == 0 then
            return false
        endif
        set ok1 = DzFontWriteWord(patchBase + 0xDA5AF, word)
        set p2 = Protect(frame, patchBase + 0xE1260, 0x40)
        if p2 == 0 then
            call DzFontWriteWord(patchBase + 0xDA5AF, 0xB8077E20)
            call Protect(frame, patchBase + 0xDA5AF, p1)
            call FlushInstructions()
            return false
        endif
        set ok2 = DzFontWriteWord(patchBase + 0xE1260, word)
        if not ok1 or not ok2 then
            call DzFontWriteWord(patchBase + 0xDA5AF, 0xB8077E20)
            call DzFontWriteWord(patchBase + 0xE1260, 0xB8077E20)
        endif
        set ok1 = Protect(frame, patchBase + 0xDA5AF, p1) == 0x40 and ok1
        set ok2 = Protect(frame, patchBase + 0xE1260, p2) == 0x40 and ok2
        set flushed = FlushInstructions()
        return ok1 and ok2 and flushed
    endfunction

    private function Ensure takes nothing returns boolean
        if patchState == 1 then
            return true
        endif
        if patchState == 2 then
            return false
        endif
        set patchBase = DzFontGameBase()
        if patchBase == 0 then
            return false
        endif
        set mergeSlot = DzFontFindNative(patchBase, 0)
        set produceSlot = DzFontFindNative(patchBase, 1)
        if mergeSlot == 0 or produceSlot == 0 then
            set patchState = 2
            return false
        endif
        set mergeOriginal = DzFontRead32(mergeSlot)
        set produceOriginal = DzFontRead32(produceSlot)
        if mergeOriginal != patchBase + 0x891F20 or produceOriginal != patchBase + 0x894950 or not Original() then
            set patchState = 2
            return false
        endif
        set patchState = 1
        return true
    endfunction

    // 同一次调用内解开、设置、恢复。字号已经写入时返回 true，调用方不要再设一次。
    function UITextFontUnlockSet takes integer frame, string fontPath, real size returns boolean
        local boolean enabled
        local boolean restored
        if patchBusy or frame == 0 or fontPath == null or fontPath == "" or size < 0.001 or size > 0.100 then
            return false
        endif
        if not Ensure() or not Original() then
            if patchState == 1 and not Original() then
                set patchState = 2
            endif
            return false
        endif
        set patchBusy = true
        set enabled = Patch(frame, true)
        if not enabled then
            set restored = Original()
            set patchBusy = false
            if not restored then
                set patchState = 2
            endif
            return false
        endif
        call DzFrameSetFont(frame, fontPath, size, 0)
        set restored = Patch(frame, false)
        set patchBusy = false
        if not restored or not Original() then
            set patchState = 2
        endif
        // 字号已经写进这个 frame。即使恢复失败也不返回 false，避免调用方再设一次。
        return true
    endfunction
endlibrary
#endif
