#ifndef UTSimpleMouseMenuIncluded
#define UTSimpleMouseMenuIncluded
#undef OriginMapUnitTestMode
#define EmptyMapUnitTestMode
//! zinc
// Optional legacy Simple backup test. Not included by MouseMenu_Test or the new warehouse.
// Native Simple hit regions and hide behavior require manual verification before production reuse.
library UTSimpleMouseMenu requires SimpleMouseMenu, ItemBtns {
    private simpleMouseMenu sample = 0;
    private function onInit() {
        UnitTestAutoTimer(0.5, 0.0, function() {
            Trace("[SimpleMouseMenu] 备份测试：s1 打开向上菜单，s2 隐藏；检查原生面板点击区是否残留。默认不加载此备份。");
        }, null);
        UnitTestRegisterChatEvent(function() {
            string str = GetEventPlayerChatString();
            if (GetTriggerPlayer() != GetLocalPlayer()) { return; }
            if (str == "s1") {
                if (!sample.isExist()) {
                    sample = simpleMouseMenu.createSimple(itemBtns.slot[1], true, 0.14);
                    sample.onClick(function(integer index) { Trace("[SimpleMouseMenu] click " + I2S(index)); });
                } else { sample.show(false); }
                sample.AddMenuSimpleItem("备份选项一").AddMenuSimpleItem("备份选项二");
                sample.menuFrame.clearPoint().setAbsPoint(ANCHOR_BOTTOMLEFT, 0.45, 0.3);
                sample.show(true);
            } else if (str == "s2" && sample.isExist()) { sample.show(false); }
        });
    }
}
//! endzinc
#endif
