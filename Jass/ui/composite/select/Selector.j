#ifndef SelectIncluded
#define SelectIncluded

//! zinc

/*
选择UI
*/

library Selector requires Tooltip,ToastHint,Music {

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
        static integer uisTxt[];			//下方的文字
        static integer ui			= 0;	//UI整体框架
        static integer uiTitle		= 0;	//标题
        static integer uiFlash		= 0;	//刷新按钮图标
        static integer uiFlashTxt	= 0;	//刷新按钮文字
        static integer uiFlashBtn	= 0;	//刷新按钮
        static integer uiClose		= 0;	//关闭图标
        static integer uiCloseBtn	= 0;	//关闭图标按钮

        //重新布局1与6的位置(外部异步调用)
        method layout () {
            real resizeX = GetResizeRate();
            real offY;
            if (size > 5) { //大于5的情况
                offY = -0.021;
                DzFrameSetSize(ui,0.3196*resizeX,0.19); //[比例:1.598]
                DzFrameClearAllPoints(icon[1].ui);
                DzFrameClearAllPoints(icon[6].ui);
                DzFrameClearAllPoints(uiClose);
                DzFrameClearAllPoints(uiTitle);
                DzFrameClearAllPoints(ui);
                DzFrameSetPoint(icon[1].ui,ANCHOR_BOTTOM,ui,ANCHOR_CENTER,(SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * -2,SIZE_ICON_GAP_Y * 0.5 + offY);
                DzFrameSetPoint(icon[6].ui,ANCHOR_TOP,ui,ANCHOR_CENTER,(SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * (size - 6) * -0.5,SIZE_ICON_GAP_Y * -0.5 + offY);
                DzFrameSetPoint(uiClose,ANCHOR_CENTER,ui,ANCHOR_TOPRIGHT,-0.01*resizeX,-0.02 + offY);
                DzFrameSetPoint(uiTitle,ANCHOR_TOP,ui,ANCHOR_TOP,-0.008*resizeX,-0.027 + offY);
                DzFrameSetPoint(ui,ANCHOR_TOP,DzGetGameUI(),ANCHOR_CENTER,0,0.04);
            } else { //小于等于5的情况
                offY = -0.012;
                DzFrameClearAllPoints(icon[1].ui);
                DzFrameClearAllPoints(uiClose);
                DzFrameClearAllPoints(uiTitle);
                DzFrameClearAllPoints(ui);
                DzFrameSetPoint(icon[1].ui,ANCHOR_CENTER,ui,ANCHOR_CENTER,(SIZE_ICON_GAP_X+SIZE_ICON_SELECT) * resizeX * (size - 1) * -0.5,offY);
                DzFrameSetSize(ui,0.3196*resizeX,0.12);
                DzFrameSetPoint(uiClose,ANCHOR_CENTER,ui,ANCHOR_TOPRIGHT,-0.01*resizeX,-0.02+offY);
                DzFrameSetPoint(uiTitle,ANCHOR_TOP,ui,ANCHOR_TOP,-0.008*resizeX,-0.02+offY);
                DzFrameSetPoint(ui,ANCHOR_TOP,DzGetGameUI(),ANCHOR_CENTER,0,0);
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
                DzFrameShow(ui,true);
                DzFrameShow(uiFlash,false);//默认隐藏一下关闭
                DzFrameShow(uiClose,false);//默认隐藏一下刷新
                layout();//重新布局
                for (1 <= i <= 10) {
                    if (i > size) { //后面的全隐藏
                        DzFrameShow(icon[i].ui,false);
                    } else { //显示
                        DzFrameShow(icon[i].ui,true);
                        DzFrameShow(icon[i].shade,false);//默认隐藏下标
                        DzFrameShow(icon[i].shadow,false);//默认隐藏遮罩
                    }
                }
            }
            return this;
        }

        //[同步使用]不要异步
        method canClose () {
            if (GetLocalPlayer() == p) {
                DzFrameShow(uiClose,true);//显示一下关闭
            }
        }

        //[同步使用]设置一下刷新事件
        method flashCB (integer flash,code func) {
            this.fTimes = flash;
            if (trFlash != null) DestroyTrigger(trFlash);
            trFlash = CreateTrigger();
            TriggerAddCondition(trFlash, Condition(func));
            if (GetLocalPlayer() == p) {
                DzFrameShow(uiFlash,true);//显示一下刷新
                DzFrameSetText(uiFlashTxt,"刷新|cff00ff80("+I2S(flash)+")|r");
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
                DzFrameShow(ui,false);
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
            DzFrameSetSize(uiFlash,0.0724*resizeX,0.027); //[比例:2.684]
            DzFrameSetSize(uiClose,0.029*resizeX,0.029); //[比例:1.]
            for (1 <= i <= 10) { //位置的调整
                icon[i].size(SIZE_ICON_SELECT*resizeX,SIZE_ICON_SELECT);
                if ((i > 1 && i <= 5) || (i > 6)) { //2-5 与 6-10 的部分
                    DzFrameSetPoint(icon[i].ui,ANCHOR_LEFT,icon[i-1].ui,ANCHOR_RIGHT,SIZE_ICON_GAP_X * resizeX,0);
                    DzFrameSetPoint(icon[i].ui,ANCHOR_LEFT,icon[i-1].ui,ANCHOR_RIGHT,SIZE_ICON_GAP_X * resizeX,0);
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
                ui = CreateBackDrop(layer.ui2);
                DzFrameSetTexture(ui,"ui\\image\\bg_select.blp",0);
                uiTitle = NewTextXXL(ui);
                DzFrameSetText(uiTitle,"选择栏的标题");
                for (1 <= i <= SELECT_UI_MAX_COUNT) {
                    icon[i] = icon.create(ui,false,true);
                    uisTxt[i] = NewTextL(icon[i].ui); //图标下方的文字
                    DzFrameSetPoint(uisTxt[i],ANCHOR_TOP,icon[i].ui,ANCHOR_BOTTOM,0,-0.002);
                    DzFrameSetScriptByCode(icon[i].btn,FRAME_MOUSE_UP,function (){
                        integer ui = DzGetTriggerUIEventFrame();
                        integer i;
                        music[MUSIC_INDEX_BTN_CLICK].play();
                        for (1 <= i <= 10) {
                            if (ui == icon[i].btn) {
                                DzSyncData("SL","c"+I2S(i));
                                return;
                            }
                        }
                    },false);
                }
                uiFlash = CreateBackDrop(ui);
                DzFrameSetTexture(uiFlash,"UI\\image\\select_flash.blp",0);
                DzFrameSetPoint(uiFlash,ANCHOR_CENTER,ui,ANCHOR_BOTTOM,0,0);
                uiFlashTxt = NewTextXL(uiFlash);
                DzFrameSetPoint(uiFlashTxt,ANCHOR_CENTER,uiFlash,ANCHOR_CENTER,0,0);
                uiFlashBtn = CreateButton(uiFlash);
                DzFrameSetAllPoints(uiFlashBtn,uiFlash);
                DzFrameSetScriptByCode(uiFlashBtn,FRAME_MOUSE_UP,function (){
                    DzSyncData("SL","b");
                    music[MUSIC_INDEX_BTN_CLICK].play();
                },false);
                uiClose = CreateBackDrop(ui);
                DzFrameSetTexture(uiClose,"ui\\image\\select_close.blp",0);
                uiCloseBtn = CreateButton(uiClose);
                DzFrameSetAllPoints(uiCloseBtn,uiClose);
                DzFrameSetScriptByCode(uiCloseBtn,FRAME_MOUSE_ENTER,function (){
                    integer title = DetailUITitle("关闭选择");
                    DzFrameSetPoint(title,ANCHOR_BOTTOM,uiClose,ANCHOR_TOP,0,0.01);
                },false);
                DzFrameSetScriptByCode(uiCloseBtn,FRAME_MOUSE_LEAVE,function detailF.leave,false);
                DzFrameSetScriptByCode(uiCloseBtn,FRAME_MOUSE_UP,function (){
                    DzSyncData("SL","a");
                    music[MUSIC_INDEX_BTN_CLICK].play();
                },false);
                onResize();
                DzFrameShow(ui,false);
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
                                DzFrameSetText(uiFlashTxt,"刷新|cff00ff80("+I2S(SL[index].fTimes)+")|r");
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
