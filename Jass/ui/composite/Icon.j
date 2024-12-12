#ifndef IconIncluded
#define IconIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法


//===========================================================================
// Icon.j
//===========================================================================
//
// 模块描述：
//   实现了魔兽争霸3中通用的图标UI组件，支持图标显示、数字标记、
//   按钮功能、流光特效等特性。
//
// 作者：[你的名字]
// 创建日期：[创建日期]
// 最后修改：[最后修改日期]
//
// 依赖项：
//   - UIBase
//   - UIAnim
//   - GrowData
//   - UIText
//   - UIImage
//   - UIButton
//   - UISprite
//
// 使用示例：
//   icon myIcon = icon.create(parentFrame, true, true);
//   myIcon.size(0.04, 0.04);
//
//===========================================================================


//! zinc
/*
[按钮]整合到了一起
*/
library Icon requires BaseAnim, GrowData, UIText, UIImage, UIButton,UISprite {

    public struct icon {
        // UI组件
        uiImage mainImage;      // 主图标图片
        uiImage shadowImage;    // 图标暗遮罩
        uiImage cornerShade;    // 角落文字背景
        uiImage glowImage;      // 流光特效图片
        uiText cornerText;      // 角落文字
        uiBtn clickBtn;      // 点击按钮
        uiSprite cdSprite;      // CD显示精灵

        // 动画相关
        baseanim glowAnim;    // 流光动画
        growdata gd;          // 流光数据

        // 尺寸
        real sizeX;
        real sizeY;
        boolean isResize;

        STRUCT_SHARED_METHODS(icon)

        // 私有的初始化方法
        private method init() {
            // 初始化所有成员为0
            mainImage   = 0;
            shadowImage = 0;
            cornerShade = 0;
            cornerText  = 0;
            clickBtn    = 0;
            glowImage   = 0;
            cdSprite    = 0;

            // 动画相关
            glowAnim = 0;
            gd       = 0;

            // 尺寸初始化为0
            sizeX    = 0;
            sizeY    = 0;
            isResize = false;
        }

        // 普通创建方法
        static method create(integer parent) -> thistype {
            thistype this = allocate();
            this.init();

            // 设置默认尺寸
            sizeX = 0.04;
            sizeY = 0.04;

            // 创建必需组件
            mainImage = uiImage.create(parent);
            mainImage.show(false);

            return this;
        }

        // 从现有UI创建图标
        static method fromExistingUI(uiImage existingImage) -> thistype {
            thistype this = allocate();
            this.init();

            // 绑定现有图片
            mainImage = existingImage;
            if (mainImage.isExist()) {
                sizeX = DzFrameGetWidth(mainImage.ui);
                sizeY = DzFrameGetHeight(mainImage.ui);
            }

            return this;
        }

        // 加入流光效果
        method grow(integer parent, growdata gd) {
            if (!glowImage.isExist()) {
                glowImage = uiImage.create(parent)
                    .setPoint(ANCHOR_CENTER, mainImage.ui, ANCHOR_CENTER, 0, 0);
                glowAnim = baseanim.create(glowImage.ui);
                glowImage.setSize(sizeX * gd.scale, sizeY * gd.scale);
                glowAnim.addSequ(gd.path, gd.max, gd.gap, true);
                this.gd = gd;
            } else {
                if (gd != this.gd) { //如果流光数据不一样，则更新流光数据,如果一样则不更新,怕影响初始帧
                    glowAnim.addSequ(gd.path, gd.max, gd.gap, true);
                    glowImage.setSize(sizeX * gd.scale, sizeY * gd.scale);
                    this.gd = gd;
                }
            }
        }

        // 取消流光
        method unGrow() {
            if (glowImage.isExist()) {
                glowImage.destroy();
                glowImage = 0;
                glowAnim.destroy();
                glowAnim = 0;
            }
        }

        // 设置尺寸
        method setSize(real x, real y) {
            if (!this.isExist()) {return;}
            mainImage.setSize(x, y);
            if (glowImage.isExist()) {
                glowImage.setSize(x * gd.scale, y * gd.scale);
            }
            sizeX = x;
            sizeY = y;
        }

        //todo:设置自适应尺寸
        method setReSize() {
            isResize = true; //这个不可逆
        }

        // 设置数字
        method setCornerText(string value) {
            real padding;
            if (!this.isExist()) {return;}
            if (!cornerText.isExist()) {
                cornerShade = uiImage.createCornerBorder(mainImage.ui);
                cornerText = uiText.create(cornerShade.ui)
                    .setFontSize(2)
                    .setPoint(ANCHOR_BOTTOMRIGHT, mainImage.ui, ANCHOR_BOTTOMRIGHT, -0.003,0.003);
                // 自动调整背景大小以适应文本
                padding = 0.003;
                cornerShade.setPoint(ANCHOR_TOPLEFT, cornerText.ui, ANCHOR_TOPLEFT, -padding, padding)
                    .setPoint(ANCHOR_BOTTOMRIGHT, cornerText.ui, ANCHOR_BOTTOMRIGHT, padding, -padding);
            }

            cornerText.setText(value);

        }

        // 显示/隐藏数字
        method showCornerText(boolean flag) {
            if (!this.isExist()) {return;}
            if (cornerText.isExist()) {
                cornerText.show(flag);
                cornerShade.show(flag);
            }
        }

        // 设置图标暗遮罩
        method setShadow(boolean flag) {
            if (!this.isExist()) {return;}
            if (!shadowImage.isExist() && flag) {
                shadowImage = uiImage.create(mainImage.ui)
                    .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
                    .setAllPoint(mainImage.ui);
            }
            if (shadowImage.isExist()) {
                shadowImage.show(flag);
            }
        }

        // CD显示相关方法
        method startCooldown(real duration) {
            if (!this.isExist()) {return;}
            if (!cdSprite.isExist()) {
                cdSprite = uiSprite.create(mainImage.ui)
                    .setPoint(ANCHOR_CENTER,mainImage.ui,ANCHOR_CENTER,0,0)
                    .setSize(0.001,0.001)  //测试过无论设置成什么都不影响ping的大小
                    .setModel("ui\\model\\ping2.mdx",0,0);
            }
            //todo: 完成CD动画
        }

        // 获取按钮,然后再在外面设按钮相关的事件
        method getClickBtn() -> uiBtn {
            if (!this.isExist()) {return 0;}
            if (!clickBtn.isExist()) {
                clickBtn = uiBtn.create(mainImage.ui)
                    .setAllPoint(mainImage.ui);
            }
            return clickBtn;
        }

        // 设置图标贴图
        method setTexture(string path) {
            if (!this.isExist()) {return;}
            mainImage.setTexture(path);
        }

        // 显示/隐藏整个图标
        method show(boolean flag) {
            if (!this.isExist()) {return;}
            mainImage.show(flag);
        }

        method onDestroy() {
            if (mainImage.isExist()) { mainImage.destroy(); mainImage = 0; }
            if (shadowImage.isExist()) { shadowImage.destroy(); shadowImage = 0; }
            if (cornerShade.isExist()) { cornerShade.destroy(); cornerShade = 0; }
            if (cornerText.isExist()) { cornerText.destroy(); cornerText = 0; }
            if (clickBtn.isExist()) { clickBtn.destroy(); clickBtn = 0; }
            if (glowImage.isExist()) { glowImage.destroy(); glowImage = 0; }
            if (glowAnim.isExist()) { glowAnim.destroy(); glowAnim = 0; }
            if (cdSprite.isExist()) { cdSprite.destroy(); cdSprite = 0; }
        }
    }
}

//! endzinc
#endif
