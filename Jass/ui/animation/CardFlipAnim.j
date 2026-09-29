#ifndef CardFlipAnimIncluded
#define CardFlipAnimIncluded

//! zinc
/*
 * 播放矩形卡牌序列帧。growdata.max 是最后一帧的编号，首帧为 0。
 * 只创建本地 UI；底层 BaseAnim/UIAnimTimer 的经典句柄在全端初始化。
 */
library CardFlipAnim requires BaseAnim, GrowData, UIImage, UIHashTable {

    public struct cardFlipAnim [] {
        // parent 是定位参照；实际图片使用同一个 parent 创建。
        // holdTicks 以 0.02 秒为单位，播放完毕后保留末帧。
        static method play(player p, integer parent, growdata gd, real width, real height, real offsetX, real offsetY, integer holdTicks) {
            uiImage img;
            baseanim anim;
            integer lifeTicks;

            if (GetLocalPlayer() != p || parent == 0 || gd == 0 || gd.max <= 0 || gd.gap <= 0 || gd.path == "" || width <= 0.0 || height <= 0.0) {
                return;
            }
            if (holdTicks < 1) {holdTicks = 1;}

            img = uiImage.create(parent);
            img.setSize(width, height);
            img.setPoint(ANCHOR_CENTER, parent, ANCHOR_CENTER, offsetX, offsetY);

            anim = baseanim.create(img.ui);
            anim.addSequ(gd.path, gd.max, gd.gap, false);
            lifeTicks = gd.max * gd.gap + holdTicks + 1;
            anim.addLife(lifeTicks, function(baseanim finished) {
                integer ui = finished.ui;
                uiImage cardImage;
                if (uiHashTable(ui).ui.getType() != uiImage.typeid) {return;}
                cardImage = uiHashTable(ui).ui.get();
                cardImage.destroy();
            });
        }
    }
}
//! endzinc

#endif
