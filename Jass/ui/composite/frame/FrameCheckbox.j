#ifndef FrameCheckboxIncluded
#define FrameCheckboxIncluded
#include "Crainax/ui/constants/UIConstants.j"
//! zinc
//# dependency:resource/ui/frame/check-off.blp
//# dependency:resource/ui/frame/check-on.blp
//# dependency:resource/ui/frame/check-locked.blp
//# dependency:resource/ui/frame/check-locked-on.blp
library FrameCheckbox requires FrameTheme, UIImage, UIExtendResize, UIButton, UIExtendEvent, UIText, UIHashTable {
    public struct frameCheckbox {
        uiBtn root;
        private real width;
        boolean checked;
        boolean enabled;
        private uiImage mark;
        private uiText label;
        uiEvent changed; // 本地事件，参数是复选框实例。
        method getRoot() -> uiBtn { return root; }
        method getWidth() -> real { return width; }
        method getHeight() -> real { return 0.022; }
        method setPoint(integer anchor, integer relative, integer relativeAnchor, real x, real y) -> thistype {
            root.exRePoint(anchor,relative,relativeAnchor,x,y);
            return this;
        }
        method show(boolean visible) -> thistype { root.show(visible); return this; }
        method setWidth(real w) -> thistype {
            width = RMaxBJ(w,0.025);
            root.exReSize(width,0.022);
            return this;
        }
        method setText(string text) -> thistype { label.setText(text); return this; }
        method setChecked(boolean selected) -> thistype { return this.setState(selected,enabled); }
        method setEnabled(boolean active) -> thistype { return this.setState(checked,active); }
        method setState(boolean selected, boolean active) -> thistype {
            string name = "check-off";
            checked = selected;
            enabled = active;
            if (selected) { name = "check-on"; }
            if (!active) {
                name = "check-locked";
                if (selected) { name = "check-locked-on"; }
            }
            mark.setTexture(FrameTexture(name));
            label.setAlpha(255);
            if (!active) { label.setAlpha(110); }
            DzFrameSetEnable(root.ui,active);
            return this;
        }
        static method create(integer parent, string caption, real w) -> thistype {
            thistype this = allocate();
            root = uiBtn.createBlank(parent).exReSize(RMaxBJ(w,0.025),0.022);
            mark = uiImage.create(root.ui).exReSize(0.021,0.021).setPoint(ANCHOR_LEFT,root.ui,ANCHOR_LEFT,0,0);
            label = uiText.create(root.ui).setText(caption).exRePoint(ANCHOR_LEFT,mark.ui,ANCHOR_RIGHT,0.003,0);
            FrameFont(label,0.011);
            changed = 0;
            // 保留旧版原生事件语义；sp* 会额外修改共享鼠标状态及销毁时补发 leave。
            uiHashTable(root.ui).eventdata.bind(this);
            root.onClick(function() {
                thistype box = uiHashTable(DzGetTriggerUIEventFrame()).eventdata.get();
                if (box.enabled) {
                    box.setState(!box.checked,true);
                    if (box.changed != 0) { box.changed.evaluate(box); }
                }
            });
            this.setWidth(w);
            return this.setState(false,true);
        }
        method onDestroy() {
            changed = 0;
            enabled = false;
            label.destroy();
            label = 0;
            mark.destroy();
            mark = 0;
            root.destroy();
            root = 0;
        }
    }
}
//! endzinc
#endif
