#ifndef SelectIncluded
#define SelectIncluded

//! zinc

/*
选择UI
*/

library Selector requires Tooltip,ToastHint,Music,Icon {

    public struct selectF [] {
        static integer pos = 0; //选择事件:选中了哪个
        static selector this = 0; //东西
    }

    selector SL[]; //玩家的单例选择
    //选择UI
    public struct selector {

        #define SELECT_UI_MAX_COUNT 10    //一页图标的数量
        #define SIZE_ICON_SELECT    0.035 //图标大小
        #define SIZE_ICON_GAP_X     0.02  //图标间隔(横)
        #define SIZE_ICON_GAP_Y     0.02  //图标间隔(纵)

        player p;        //选择玩家
        boolean isClose; //可以关闭的选择
        integer fTimes;  //刷新次数
        integer size;    //选择项数量
        trigger trFlash; //[同步回调]刷新事件
        trigger trClick; //[同步回调]点击事件

        static icon icon[];					//图标
        static uiText uisTxt[];			//下方的文字
        static uiImage ui			= 0;	//UI整体框架（背景）
        static uiText uiTitle		= 0;	//标题
        static uiImage uiFlash		= 0;	//刷新按钮图标
        static uiText uiFlashTxt	= 0;	//刷新按钮文字
        static uiBtn uiFlashBtn	= 0;	//刷新按钮
        static uiImage uiClose		= 0;	//关闭图标
        static uiBtn uiCloseBtn	= 0;	//关闭图标按钮
        static tooltip closeTip	= 0;	//关闭按钮提示

        //重新布局1与6的位置(外部异步调用)
        method layout () {
            real resizeX = GetResizeRate();
            real offY;
            if (size > 5) { //大于5的情况
                offY = -0.021;
                ui.setSize(0.3196*resizeX,0.19); //[比例:1.598]
                icon[1].mainImage.clearPoint();
                icon[6].mainImage.clearPoint();
                uiClose.clearPoint();
                uiTitle.clearPoint();
                ui.clearPoint();
                icon[1].mainImage.setPoint(ANCHOR_BOTTOM, ui.ui, ANCHOR_CENTER, (SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * -2, SIZE_ICON_GAP_Y * 0.5 + offY);
                icon[6].mainImage.setPoint(ANCHOR_TOP, ui.ui, ANCHOR_CENTER, (SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * (size - 6) * -0.5, SIZE_ICON_GAP_Y * -0.5 + offY);
                uiClose.setPoint(ANCHOR_CENTER, ui.ui, ANCHOR_TOPRIGHT, -0.01*resizeX, -0.02 + offY);
                uiTitle.setPoint(ANCHOR_TOP, ui.ui, ANCHOR_TOP, -0.008*resizeX, -0.027 + offY);
                ui.setPoint(ANCHOR_TOP, DzGetGameUI(), ANCHOR_CENTER, 0, 0.04);
            } else { //小于等于5的情况
                offY = -0.012;
                icon[1].mainImage.clearPoint();
                uiClose.clearPoint();
                uiTitle.clearPoint();
                ui.clearPoint();
                icon[1].mainImage.setPoint(ANCHOR_CENTER, ui.ui, ANCHOR_CENTER, (SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * (size - 1) * -0.5, offY);
                ui.setSize(0.3196*resizeX,0.12);
                uiClose.setPoint(ANCHOR_CENTER, ui.ui, ANCHOR_TOPRIGHT, -0.01*resizeX, -0.02+offY);
                uiTitle.setPoint(ANCHOR_TOP, ui.ui, ANCHOR_TOP, -0.008*resizeX, -0.02+offY);
                ui.setPoint(ANCHOR_TOP, DzGetGameUI(), ANCHOR_CENTER, 0, 0);
            }
        }

        method isExist () -> boolean {return (this != null && si__select_V[this] == -1);}
        //创建选择,不能异步
        static method create (player p,integer size) -> thistype {
            integer i,index = GetConvertedPlayerId(p);
            thistype this = 0;
            if (SL[index].isExist()) return 0; //防重复创建,外面处理事件
            this = allocate();
            this.p = p;
            this.size = size;
            this.fTimes = 0;
            SL[index] = this;
            if (GetLocalPlayer() == p) { //异步显示UI
                ui.show(true);
                uiFlash.show(false);//默认隐藏一下关闭
                uiClose.show(false);//默认隐藏一下刷新
                layout();//重新布局
                for (1 <= i <= 10) {
                    if (i > size) { //后面的全隐藏
                        icon[i].show(false);
                    } else { //显示
                        icon[i].show(true);
                        icon[i].setShadow(false);
                        icon[i].setCornerText(null);
                    }
                }
            }
            return this;
        }

        //[同步使用]不要异步
        method canClose () {
            if (GetLocalPlayer() == p) {
                uiClose.show(true);//显示一下关闭
            }
        }

        //[同步使用]设置一下刷新事件
        method flashCB (integer flash,code func) {
            this.fTimes = flash;
            if (trFlash != null) DestroyTrigger(trFlash);
            trFlash = CreateTrigger();
            TriggerAddCondition(trFlash, Condition(func));
            if (GetLocalPlayer() == p) {
                uiFlash.show(true);//显示一下刷新
                uiFlashTxt.setText("刷新|cff00ff80("+I2S(flash)+")|r");
            }
        }

        //[同步使用]设置一下同步点击事件
        method clickCB (code func) {
            if (trClick != null) DestroyTrigger(trClick);
            trClick = CreateTrigger();
            TriggerAddCondition(trClick, Condition(func));
        }

        method onDestroy () { //析构
            integer i,index = GetConvertedPlayerId(p);
            SL[index] = 0;
            if (trFlash != null) {DestroyTrigger(trFlash);trFlash = null;}
            if (trClick != null) {DestroyTrigger(trClick);trClick = null;}
            if (GetLocalPlayer() == p) { //异步处理UI的析构
                ui.show(false);
                if (closeTip != 0) { closeTip.destroy(); closeTip = 0; }
                for (1 <= i <= size) {
                    icon[i].unGrow();
                }
            }
            this.p = null;
        }

        //窗口变化事件
        static method onResize () {
            real resizeX = GetResizeRate();
            integer i;
            integer index = GetConvertedPlayerId(GetLocalPlayer());
            uiFlash.setSize(0.0724*resizeX,0.027); //[比例:2.684]
            uiClose.setSize(0.029*resizeX,0.029); //[比例:1.]
            for (1 <= i <= 10) { //位置的调整
                icon[i].setSize(SIZE_ICON_SELECT*resizeX,SIZE_ICON_SELECT);
                if ((i > 1 && i <= 5) || (i > 6)) { //2-5 与 6-10 的部分
                    icon[i].mainImage.setPoint(ANCHOR_LEFT, icon[i-1].mainImage.ui, ANCHOR_RIGHT, SIZE_ICON_GAP_X * resizeX, 0);
                    icon[i].mainImage.setPoint(ANCHOR_LEFT, icon[i-1].mainImage.ui, ANCHOR_RIGHT, SIZE_ICON_GAP_X * resizeX, 0);
                }
            }
            if (SL[index].isExist()) {
                SL[index].layout();//重新布局
            }
        }

        static method onInit () { //注册一下事件
            //在游戏开始0.10秒后再调用
            trigger tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr,0.10);
            TriggerAddCondition(tr,Condition(function (){
                integer i;
                real resizeX = GetResizeRate();
                ui = uiImage.create(layer.ui2).setTexture("ui\\image\\bg_select.blp");
                uiTitle = uiText.create(ui.ui).setFontSize(5);
                uiTitle.setText("选择栏的标题");
                for (1 <= i <= SELECT_UI_MAX_COUNT) {
                    icon[i] = icon.create(ui.ui);
                    uisTxt[i] = uiText.create(icon[i].mainImage.ui).setFontSize(3); //图标下方的文字
                    uisTxt[i].setPoint(ANCHOR_TOP, icon[i].mainImage.ui, ANCHOR_BOTTOM, 0, -0.002);
                    // 绑定按键事件（逐一比较事件源，保持原有语义）
                    DzFrameSetScriptByCode(icon[i].getClickBtn().ui,FRAME_MOUSE_UP,function (){
                        integer uih = DzGetTriggerUIEventFrame();
                        integer k;
                        music[MUSIC_INDEX_BTN_CLICK].play();
                        for (1 <= k <= 10) {
                            if (uih == icon[k].getClickBtn().ui) {
                                DzSyncData("SL","c"+I2S(k));
                                return;
                            }
                        }
                    },false);
                }
                uiFlash = uiImage.create(ui.ui).setTexture("UI\\image\\select_flash.blp");
                uiFlash.setPoint(ANCHOR_CENTER, ui.ui, ANCHOR_BOTTOM, 0, 0);
                uiFlashTxt = uiText.create(uiFlash.ui).setFontSize(4);
                uiFlashTxt.setPoint(ANCHOR_CENTER, uiFlash.ui, ANCHOR_CENTER, 0, 0);
                uiFlashBtn = uiBtn.create(uiFlash.ui);
                DzFrameSetAllPoints(uiFlashBtn.ui, uiFlash.ui);
                DzFrameSetScriptByCode(uiFlashBtn.ui,FRAME_MOUSE_UP,function (){
                    DzSyncData("SL","b");
                    music[MUSIC_INDEX_BTN_CLICK].play();
                },false);
                uiClose = uiImage.create(ui.ui).setTexture("ui\\image\\select_close.blp");
                uiCloseBtn = uiBtn.create(uiClose.ui);
                DzFrameSetAllPoints(uiCloseBtn.ui, uiClose.ui);
                DzFrameSetScriptByCode(uiCloseBtn.ui,FRAME_MOUSE_ENTER,function (){
                    if (closeTip != 0) { closeTip.destroy(); closeTip = 0; }
                    closeTip = tooltip.create().layoutTitle("关闭选择");
                    closeTip.setPoint(ANCHOR_BOTTOM, uiClose.ui, ANCHOR_TOP, 0, 0.01);
                },false);
                DzFrameSetScriptByCode(uiCloseBtn.ui,FRAME_MOUSE_LEAVE,function (){
                    if (closeTip != 0) { closeTip.destroy(); closeTip = 0; }
                },false);
                DzFrameSetScriptByCode(uiCloseBtn.ui,FRAME_MOUSE_UP,function (){
                    DzSyncData("SL","a");
                    music[MUSIC_INDEX_BTN_CLICK].play();
                },false);
                onResize();
                ui.show(false);
                hardware.regResizeEvent(function thistype.onResize);
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;

            tr = CreateTrigger();
            DzTriggerRegisterSyncData(tr,"SL",false);
            TriggerAddCondition(tr, Condition(function () {
                string str = DzGetTriggerSyncData();
                player p = DzGetTriggerSyncPlayer();
                integer index = GetConvertedPlayerId(p);
                string flag = SubStringBJ(str,1,1);
                integer pos;
                if (SL[index].isExist()) {
                    if (flag == "a") { //关闭事件
                        SL[index].destroy();
                    }else if (flag == "b") { //刷新事件
                        if (SL[index].fTimes > 0) {
                            SL[index].fTimes -= 1;
                            if (SL[index].trFlash != null) {
                                selectF.this = SL[index];
                                TriggerEvaluate(SL[index].trFlash);
                                selectF.this = 0;
                            }
                            if (GetLocalPlayer() == SL[index].p) {
                                uiFlashTxt.setText("刷新|cff00ff80("+I2S(SL[index].fTimes)+")|r");
                            }
                        } else { //刷新次数不足
                            if (GetLocalPlayer() == SL[index].p) {
                                toastHint.createAtMouse(p, "没有刷新次数了!");
                                music[MUSIC_INDEX_ERROR].play();
                            }
                        }
                    }else if (flag == "c") { //点击按钮事件
                        pos = S2I(SubStringBJ(str,2,StringLength(str)));
                        if (pos <= SL[index].size) {
                            if (SL[index].trClick != null) {
                                selectF.this = SL[index];
                                selectF.pos = pos;
                                TriggerEvaluate(SL[index].trClick);
                                selectF.this = 0;
                                selectF.pos = 0;
                            }
                        }
                    }
                }
                str = null;
                flag = null;
                p = null;
            }));
            tr = null;
        }
    }
}
//! endzinc

#endif
