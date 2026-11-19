#ifndef UITextFontStyleIncluded
#define UITextFontStyleIncluded
// Test-only module, injected after YDLua.j. Keep this experiment pure JASS.
#undef SetCameraBounds
#undef DzWriteLog
#define LoggerIncluded
library UITextFontStyle
    // Caller supplies an unshadowed TEXT. Offsets are UI units, not screen pixels.
    function FontStyleShadow takes integer frame, real dx, real dy, integer color returns boolean
        return DzFrameAddTextShadow(frame, dx, dy, color)
    endfunction
endlibrary
#endif
