#ifndef UTUITextFontDzMemoryIncluded
#define UTUITextFontDzMemoryIncluded
#undef OriginMapUnitTestMode
#undef DzWriteLog
// DzFontResearchIsolate 只让这个单测取消 Lua 启动。字号解锁在 UITextFontUnlock。
//# dependency:resource/ui/slider/nandu_slider_bg.blp
//# dependency:resource/ui/slider/nandu_slider_button.blp

library UTUITextFontDzMemory initializer Init requires UITextFontUnlock, UITextFontDzMemory, UnitTestFramwork
    globals
        private integer sample = 0
        private integer slider = 0
        private integer base = 0
        private integer mergeSlot = 0
        private integer produceSlot = 0
        private integer mergeOriginal = 0
        private integer produceOriginal = 0
        private integer phase = 0
        private integer lastSlider = 400
        private integer lineCount = 0
        private string array lines
        private string font = "Fonts\\dfst-m3u.ttf"
        private boolean ready = false
        private boolean busy = false
        private boolean failed = false
        private boolean testing = true
    endglobals

    private function Log takes string message returns nothing
        call BJDebugMsg("[DzFontJass] " + message)
        call DzWriteLog("[DzFontJass] " + message)
        if lineCount < 1000 then
            set lines[lineCount] = "[DzFontJass] " + message
            set lineCount = lineCount + 1
        endif
    endfunction

    private function Check takes boolean ok, string message returns nothing
        if testing or not ok then
            call assert.Boolean(ok, "[DzFontJass] " + message)
            if ok then
                call Log("PASS: " + message)
            else
                set failed = true
                call Log("FAIL: " + message)
            endif
        endif
    endfunction

    private function FlushLog takes nothing returns nothing
        local integer i = 0
        call PreloadGenClear()
        call PreloadGenStart()
        loop
            exitwhen i >= lineCount
            call Preload(lines[i])
            set i = i + 1
        endloop
        call PreloadGenEnd("War3Lib\\logs\\DzFontSlider-P1.log")
    endfunction

    private function Original takes nothing returns boolean
        if base == 0 or mergeSlot == 0 or produceSlot == 0 then
            return false
        endif
        return DzFontRead32(base + 0xDA5AD) == 0x7E20F883 and DzFontRead32(base + 0xDA5B1) == 0x0020B807 and DzFontRead32(base + 0xDA5B5) == 0x1DEB0000 and DzFontRead32(base + 0xE125E) == 0x7E20F883 and DzFontRead32(base + 0xE1262) == 0x0020B807 and DzFontRead32(base + 0xE1266) == 0x1DEB0000 and DzFontRead32(mergeSlot) == mergeOriginal and DzFontRead32(produceSlot) == produceOriginal
    endfunction

    // 解开、设字、恢复都在 UITextFontUnlockSet 同一次调用内完成。
    private function ScopedSet takes real size returns boolean
        local boolean ok
        if busy or failed or not ready or size < 0.001 or size > 0.100 then
            return false
        endif
        if not Original() then
            call Check(false, "patch ownership conflict; refusing font change")
            return false
        endif
        set busy = true
        set ok = UITextFontUnlockSet(sample, font, size)
        set busy = false
        call Check(ok and Original(), "setter returns with original 24 code bytes and native entries")
        return ok and Original()
    endfunction

    // Local UI state only. No units, sync storage, random calls or timer creation.
    private function OnUpdate takes nothing returns nothing
        local integer value
        local boolean ok
        if not ready or busy or failed or slider == 0 then
            return
        endif
        set value = R2I(DzFrameGetValue(slider) + 0.5)
        if value == lastSlider then
            return
        endif
        set lastSlider = value
        set ok = ScopedSet(I2R(value) / 10000.0)
        if ok and not testing then
            call BJDebugMsg("字号 " + R2SW(I2R(value) / 10000.0, 0, 4) + " / ppem " + I2S(DzFontPpem(sample)))
        endif
    endfunction

    private function SetSlider takes integer value returns nothing
        call DzFrameSetValue(slider, I2R(value))
        // Test drives the same handler as real dragging; no mouse emulation.
        call OnUpdate()
    endfunction

    private function Step takes nothing returns nothing
        if failed then
            call FlushLog()
            call DestroyTimer(GetExpiredTimer())
            return
        endif
        if phase == 0 then
            call Check(DzFontPpem(sample) == 32, "one TEXT baseline 0.04 capped at ppem 32")
            set ready = true
            set lastSlider = 0
            call SetSlider(400)
            call Check(DzFontPpem(sample) > 32, "slider handler immediately creates large font")
            call Check(Original(), "original code before first callback returns")
        elseif phase == 1 then
            call Log("slider 0.0400 ppem=" + I2S(DzFontPpem(sample)))
            call Check(DzFontPpem(sample) > 32 and Original(), "large TEXT survives rendering with original code")
            call SetSlider(800)
        elseif phase == 2 then
            call Log("slider 0.0800 ppem=" + I2S(DzFontPpem(sample)))
            call Check(DzFontPpem(sample) > 100 and Original(), "second slider value stays large after restore")
            call DzFrameSetFont(sample, font, 0.041, 0)
        elseif phase == 3 then
            call Check(DzFontPpem(sample) == 32, "ordinary fresh request still capped after scoped setter")
            call SetSlider(10)
        elseif phase == 4 then
            call Check(DzFontPpem(sample) > 0 and DzFontPpem(sample) < 32, "slider lower endpoint works")
            call SetSlider(1000)
        elseif phase == 5 then
            call Check(DzFontPpem(sample) > 200 and Original(), "slider upper endpoint works with restored code")
            call SetSlider(400)
        else
            call Check(sample != 0 and slider != 0 and Original(), "single TEXT and slider ready; no persistent patch")
            call Log("[DZ_FONT_SLIDER_DONE] drag slider 0.0010..0.1000; step 0.0001; chat -font 0.04")
            call FlushLog()
            set testing = false
            call DestroyTimer(GetExpiredTimer())
            return
        endif
        set phase = phase + 1
        call FlushLog()
        call TimerStart(GetExpiredTimer(), 1.0, false, function Step)
    endfunction

    private function Chat takes nothing returns nothing
        local string message = GetEventPlayerChatString()
        local real size
        if not ready or failed then
            return
        endif
        set size = S2R(SubString(message, 6, StringLength(message)))
        if size < 0.001 or size > 0.100 then
            call BJDebugMsg("用法: -font 0.04，范围 0.001..0.100")
            return
        endif
        call SetSlider(R2I(size * 10000.0 + 0.5))
    endfunction

    private function Probe takes nothing returns nothing
        local boolean ok
        call DzLoadToc("ui\\Crainax.toc")
        set sample = DzCreateFrameByTagName("TEXT", "DzFontSingleText", DzGetGameUI(), "T1", 0)
        set slider = DzCreateFrameByTagName("SLIDER", "DzFontSizeSlider", DzGetGameUI(), "SB1H", 0)
        call Check(sample != 0 and slider != 0, "one TEXT and horizontal slider created")
        if failed then
            call FlushLog()
            return
        endif
        call DzFrameSetAbsolutePoint(sample, 4, 0.4, 0.40)
        call DzFrameSetText(sample, "Ag中")
        call DzFrameSetFont(sample, font, 0.04, 0)
        call DzFrameShow(sample, true)
        call DzFrameSetSize(slider, 0.32, 0.012)
        call DzFrameSetAbsolutePoint(slider, 4, 0.4, 0.22)
        call DzFrameSetMinMaxValue(slider, 10.0, 1000.0)
        call DzFrameSetStepValue(slider, 1.0)
        call DzFrameSetValue(slider, 400.0)
        call DzFrameShow(slider, true)
        set base = DzFontGameBase()
        call Check(base != 0, "Game.dll PE build matches 1.27.0.52240")
        if base != 0 then
            set mergeSlot = DzFontFindNative(base, 0)
            set produceSlot = DzFontFindNative(base, 1)
            call Check(mergeSlot != 0 and produceSlot != 0, "AI natives are registered in the running VM")
        endif
        if failed then
            call FlushLog()
            return
        endif
        set mergeOriginal = DzFontRead32(mergeSlot)
        set produceOriginal = DzFontRead32(produceSlot)
        call Check(mergeOriginal == base + 0x891F20 and produceOriginal == base + 0x894950, "native function addresses match verified build")
        call Check(Original(), "both full clamp blocks and native entries initially original")
        set ok = DzFontWriteWord(sample + 0xAC, DzFontRead32(base + 0x94E0F4))
        call DzSetMemory(sample + 0xAC, 0.0)
        call DzFrameSetAlpha(sample, 255)
        call Check(ok, "pointer bits roundtrip through real on owned frame")
        call Log("GameBase=" + I2S(base) + " mergeSlot=" + I2S(mergeSlot) + " produceSlot=" + I2S(produceSlot))
        call DzFrameSetUpdateCallbackByCode(function OnUpdate)
        call FlushLog()
        call TimerStart(GetExpiredTimer(), 1.0, false, function Step)
    endfunction

    private function Init takes nothing returns nothing
        local trigger chat = CreateTrigger()
        call DzFontResearchIsolate()
        call TriggerRegisterPlayerChatEvent(chat, Player(0), "-font", false)
        call TriggerAddAction(chat, function Chat)
        call TimerStart(CreateTimer(), 2.0, false, function Probe)
        set chat = null
    endfunction
endlibrary
#endif
