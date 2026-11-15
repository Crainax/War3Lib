#ifndef UTUITextFontStyleIncluded
#define UTUITextFontStyleIncluded
#undef OriginMapUnitTestMode
#undef DzWriteLog
// inject: FontStyleShadow
library UTUITextFontStyle initializer Init requires UITextFontStyle, UnitTestFramwork
 globals
  private integer count = 0
  private string array lines
  private integer serial = 0
  private boolean failed = false
  private string activeFont = "Fonts\\FontStyle-SimHei.ttf"
 endglobals
 private function Check takes boolean ok, string label returns nothing
  call assert.Boolean(ok, label)
  if ok then
   set lines[count] = "PASS: " + label
  else
   set failed = true
   set lines[count] = "FAIL: " + label
  endif
  call BJDebugMsg(lines[count])
  set count = count + 1
 endfunction
 private function Text takes string template, string value, real x, real y, integer flag returns integer
  local integer f
  set serial = serial + 1
  set f = DzCreateFrameByTagName("TEXT", "FontStyle" + I2S(serial), DzGetGameUI(), template, serial)
  call Check(f != 0, "TEXT created " + I2S(serial))
  if f != 0 then
   call DzFrameSetFont(f, activeFont, 0.012, flag)
   call DzFrameSetText(f, value)
   call DzFrameSetAbsolutePoint(f, 3, x, y)
   call DzFrameShow(f, true)
  endif
  return f
 endfunction
 // One row per 0.020 UI units; 15 rows stay above the native HUD.
 private function Row takes string label, string value returns integer
  return Text("FSPlain", label + "  " + value, 0.035, 0.55 - I2R(serial) * 0.020, 0)
 endfunction
 private function Seed takes integer f, real dx, real dy, integer color returns nothing
  call Check(FontStyleShadow(f, dx, dy, color), "AddTextShadow accepted row " + I2S(serial))
 endfunction
 private function Outline takes string label, real radius, integer copies, string sample returns nothing
  local integer f = Row(label + " r=" + R2SW(radius, 1, 4) + " n=" + I2S(copies), sample)
  // Axis-aligned seed: its vector length equals radius, avoiding sqrt(2) ambiguity.
  call Seed(f, radius, 0.0, 0xFF000000)
  call Check(DzFrameDuplicateTextShadow(f, copies), "Duplicate accepted row " + I2S(serial))
 endfunction
 private function FontGroup takes string label, string path, string sample returns nothing
  local integer f
  set activeFont = path
  set f = Row(label + " 无描边", sample)
  call Outline(label, 0.0005, 8, sample)
  call Outline(label, 0.0010, 8, sample)
 endfunction
 private function Run takes nothing returns nothing
  local integer i = 0
  local string sample = "|cffff2020夕月心音|r的小小龙虾 Ag8000"
  call DestroyTimer(GetExpiredTimer())
  call DzLoadToc("ui\\UITextFontStyle.toc")
  call FontGroup("0 原字体", "Fonts\\dfst-m3u.ttf", sample)
  call FontGroup("1 SimHei", "Fonts\\FontStyle-SimHei.ttf", sample)
  call FontGroup("2 思源 Bold", "Fonts\\FontStyle-SourceHanSansCN-Bold.ttf", sample)
  call FontGroup("3 思源 Heavy", "Fonts\\FontStyle-SourceHanSansCN-Heavy.ttf", sample)
  call FontGroup("4 微软雅黑 Bold", "Fonts\\FontStyle-YaHeiBold.ttf", sample)
  call PreloadGenClear()
  call PreloadGenStart()
  set i = 0
  loop
   exitwhen i >= count
   call Preload(lines[i])
   set i = i + 1
  endloop
  if not failed then
   call Preload("[FONT_STYLE_V4_DONE] API acceptance only; visual pending")
  endif
  call PreloadGenEnd("War3Lib\\logs\\FontStyleV4-P1.log")
 endfunction
 private function Init takes nothing returns nothing
  call TimerStart(CreateTimer(), 2.0, false, function Run)
 endfunction
endlibrary
#endif
