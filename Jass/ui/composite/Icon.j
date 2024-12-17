#ifndef IconIncluded
#define IconIncluded


#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量


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

//# dependency:ui/model/cooldown_center.mdx


//! zinc
/*
[按钮]整合到了一起
*/
library Icon requires  GrowData, UIText, UIImage, UIButton,UISprite,ProgressAnim,UIExtendResize,UILayer{

    public struct icon {
        // UI组件
        uiImage mainImage;      // 主图标图片
        uiImage shadowImage;    // 图标暗遮罩
        uiImage cornerShade;    // 角落文字背景
        uiImage glowImage;      // 流光特效图片
        uiText cornerText;      // 角落文字
        uiBtn clickBtn;      // 点击按钮
        uiSprite cdSprite;      // CD显示精灵
        integer parent; // 父级

        // 动画相关
        baseanim glowAnim;    // 流光动画
        growdata gd;          // 流光数据

        // 尺寸
        real sizeX;
        real sizeY;
        boolean isResize;

        // 是否是原生
        boolean isSimple;
        integer spAnchor;
        integer spRelative;
        integer spRelativeAnchor;
        real spOffsetX;
        real spOffsetY;
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
            sizeX    = 0.04;
            sizeY    = 0.04;
        }

        // 普通创建方法
        static method create(integer parent) -> thistype {
            thistype this = allocate();
            this.init();
            this.parent = parent;
            isSimple    = false;

            // 创建必需组件
            mainImage = uiImage.create(parent)
                .setClip(true);
            mainImage.show(false);

            return this;
        }

        // 从现有UI创建图标(parent是后面创建东西的parent)
        static method fromExistingUI(uiImage existingImage,integer parent) -> thistype {
            thistype this = allocate();
            this.init();
            this.parent      = parent;
            isSimple         = true;
            spAnchor         = 0;
            spRelative       = 0;
            spRelativeAnchor = 0;
            spOffsetX        = 0;
            spOffsetY        = 0;

            // 绑定现有图片
            mainImage = existingImage;

            return this;
        }

        // 从现有UI创建图标(parent是后面创建东西的parent)
        static method createSimple(integer parent) -> thistype {
            return fromExistingUI(uiImage.createSimple(parent),parent);
        }

        // 更新流光尺寸
        private method updateGlowSize () {
            if (glowImage.isExist()) {
                if (isResize) {
                    glowImage.exReSize(sizeX * gd.scale, sizeY * gd.scale);
                } else {
                    glowImage.setSize(sizeX * gd.scale, sizeY * gd.scale);
                }
            }
        }

        // 加入流光效果
        method grow( growdata gd) -> thistype {
            if (!this.isExist()) {return this;}
            if (!glowImage.isExist()) {
                if (isSimple) {
                    glowImage = uiImage.createSimple(this.parent);
                } else {
                    glowImage = uiImage.create(this.parent);
                }
                glowImage.setPoint(ANCHOR_CENTER, mainImage.ui, ANCHOR_CENTER, 0, 0);

                this.updateGlowSize();
            }
            glowImage.show(true); // 显示流光
            if (gd != this.gd) {
                this.gd = gd;
            }
            if (!glowAnim.isExist()) {
                glowAnim = baseanim.create(glowImage.ui);
                glowAnim.addSequ(gd.path, gd.max, gd.gap, true);
            }
            this.updateGlowSize();
            return this;
        }

        // 取消流光
        method unGrow() -> thistype {
            if (!this.isExist()) {return this;}
            if (glowImage.isExist()) { //
                glowImage.show(false);
            }
            if (glowAnim.isExist()) {
                glowAnim.destroy();
                glowAnim = 0;
            }
            return this;
        }

        // 设置尺寸
        method setSize(real x, real y) -> thistype {
            if (!this.isExist()) {return this;}
            if (sizeX <= 0 || sizeY <= 0) {return this;}
            if (isResize) {
                mainImage.exReSize(x, y);
            } else {
                mainImage.setSize(x, y);
            }
            sizeX = x;
            sizeY = y;
            this.updateGlowSize();
            return this;
        }

        method enableResize() -> thistype {
            if (!this.isExist()) {return this;}
            isResize = true;
            setSize(sizeX, sizeY);
            return this;
        }

        // 设置数字
        method setCornerText(string value) -> thistype {
            real padding;
            if (!this.isExist()) {return this;}
            if (!cornerText.isExist()) {
                if (isSimple) {
                    cornerShade = uiImage.createCornerBorder(mainImage.ui);
                } else {
                    cornerShade = uiImage.createCornerBorder(this.parent);
                    cornerText = uiText.create(cornerShade.ui);
                }
                cornerText.setFontSize(2)
                    .setPoint(ANCHOR_BOTTOMRIGHT, mainImage.ui, ANCHOR_BOTTOMRIGHT, -0.003,0.003);
                padding = 0.003;
                cornerShade.setPoint(ANCHOR_TOPLEFT, cornerText.ui, ANCHOR_TOPLEFT, -padding, padding)
                    .setPoint(ANCHOR_BOTTOMRIGHT, cornerText.ui, ANCHOR_BOTTOMRIGHT, padding, -padding);
            }
            cornerText.setText(value);
            return this;
        }

        // 显示/隐藏数字
        method showCornerText(boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            if (cornerText.isExist()) {
                cornerText.show(flag);
                cornerShade.show(flag);
            }
            return this;
        }

        // 设置图标暗遮罩
        method setShadow(boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            if (!shadowImage.isExist() && flag) {
                shadowImage = uiImage.create(mainImage.ui)
                    .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
                    .setAllPoint(mainImage.ui);
            }
            if (shadowImage.isExist()) {
                shadowImage.show(flag);
            }
            return this;
        }

        // CD显示相关方法
        // func回调函数中的eventdata.get时是返回这个icon本体
        method startCooldown(real duration,onProgressEnd func) -> thistype {
            if (!this.isExist()) {return this;}
            if (!cdSprite.isExist()) {
                cdSprite = uiSprite.create(mainImage.ui)
                    .setPoint(ANCHOR_CENTER,mainImage.ui,ANCHOR_CENTER,0,0)
                    .setSize(0.001,0.001)
                    .setModel("ui\\model\\cooldown_center.mdx",0,0)
                    .setAnimate(0,false);
                uiHashTable(cdSprite).eventdata.bind(this);
            }
            cdSprite.progAnimate(0,1,duration,func);
            cdSprite.setScale(sizeY / 0.038);
            return this;
        }

        // 获取按钮,然后再在外面设按钮相关的事件
        method getClickBtn() -> uiBtn {
            if (!this.isExist()) {return 0;}
            if (!clickBtn.isExist()) {
                if (isSimple) { //原生
                    if (parent != 0) {
                        clickBtn = uiBtn.createSimple(parent)
                            .setAllPoint(mainImage.ui);
                    } else {
                        BJDebugMsg("parent is 0");
                    }
                } else { //非原生
                    clickBtn = uiBtn.create(mainImage.ui)
                        .setAllPoint(mainImage.ui);
                }
            }
            return clickBtn;
        }

        // 设置图标贴图
        method setTexture(string path) -> thistype {
            if (!this.isExist()) {return this;}
            mainImage.setTexture(path);
            return this;
        }

        // 设置位置(顺便存位置)
        // 原生的话1个点就行, 不要设太多点
        method setPoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            if (isSimple) {
                mainImage.clearPoint()
                    .setPoint(anchor,relative,relativeAnchor,offsetX,offsetY);
                this.spAnchor         = anchor;
                this.spRelative       = relative;
                this.spRelativeAnchor = relativeAnchor;
                this.spOffsetX        = offsetX;
                this.spOffsetY        = offsetY;
            } else {
                mainImage.setPoint(anchor,relative,relativeAnchor,offsetX,offsetY);

            }
            return this;
        }

        // 显示/隐藏整个图标(Simple无效)
        method show(boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            if (isSimple) { //原生就移到屏幕外
                if (flag) { //显示
                    mainImage.clearPoint()
                        .setPoint(spAnchor,spRelative,spRelativeAnchor,spOffsetX,spOffsetY);
                } else { //隐藏
                    mainImage.clearPoint()
                        .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, -0.8, 0.0);
                }
            } else { //非原生才能用这个函数
                mainImage.show(flag);
                if (glowImage.isExist()) {
                    glowImage.show(flag);
                }
            }
            return this;
        }

        method onDestroy() {
            if (glowAnim.isExist()) { glowAnim.destroy(); glowAnim = 0; }
            if (cdSprite.isExist()) { cdSprite.destroy(); cdSprite = 0; }
            if (shadowImage.isExist()) { shadowImage.destroy(); shadowImage = 0; }
            if (cornerShade.isExist()) { cornerShade.destroy(); cornerShade = 0; }
            if (cornerText.isExist()) { cornerText.destroy(); cornerText = 0; }
            if (clickBtn.isExist()) { clickBtn.destroy(); clickBtn = 0; }
            if (glowImage.isExist()) { glowImage.destroy(); glowImage = 0; }
            if (mainImage.isExist()) { mainImage.destroy(); mainImage = 0; }
        }
    }
}

//! endzinc
#endif
