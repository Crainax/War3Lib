#ifndef SelectIncluded
#define SelectIncluded

//! zinc

/*
选择UI
*/

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/data/audio/MusicConstant.j" // UI常量

#define SELECT_UI_MAX_COUNT 12    //一页图标的数量
#define SIZE_ICON_SELECT    0.035 //图标大小
#define SIZE_ICON_GAP_X     0.01  //图标间隔(横)
#define SIZE_ICON_GAP_Y     0.015  //图标间隔(纵)
#define SIZE_OFFSET_X       0.008 //整体偏移
#define SIZE_OFFSET_Y       0.025 //整体偏移

//# dependency:resource/ui/image/select_left.blp
//# dependency:resource/ui/image/select_right.blp
//# dependency:resource/ui/image/select_close.blp
//# dependency:resource/ui/image/select_flash.blp
//# dependency:resource/ui/image/bg_select.blp

library Selector requires Tooltip,ToastHint,Music,Icon {


    private selectData currentSD; //回调参数
    private selectData currentSDAsync; //回调参数(异步调用)
    private integer currentPos; //点击位置
    private integer currentPosAsync; //点击位置(异步调用)
    private string currentContent; //当前文字(返回值)

    //当前触发的SelectData数据
    public function GetSelectData () -> selectData {
        return currentSD;
    }

    //当前触发的SelectData数据
    public function GetSelectDataAsync () -> selectData {
        return currentSDAsync;
    }

    //当前触发的UI的对应位置
    public function GetSelectPosAsync () -> integer {
        return currentPosAsync;
    }

    //当前触发的UI的对应位置
    public function GetSelectPos () -> integer {
        return currentPos;
    }

    //写入返回值
    public function CallbackSelectContent (string s) {
        currentContent = s;
    }

    //选择UI对应的数据(同步调用)
    public struct selectData {
        integer count;      //一共多少个选择
        string  title;      //标题
        string  btn1Text;   //按钮1文字
        trigger trRefName;  //映射关系:图标文字
        trigger trRefIcon;  //映射关系:图标
        trigger trEnter;    //按钮进入事件触发器
        trigger trLeave;    //按钮离开事件触发器
        trigger trClick;    //按钮点击事件触发器
        trigger trClose;    //右上角的关闭事件触发回调
        trigger trBtn1;     //按钮事件1(下方的)
        trigger trFail;     //UI创建失败的回调触发器
        selector uiSelector;  //绑定的选择UI

        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(selectData)

        static method create (integer count) -> thistype {
            thistype this = allocate();
            if (this <= 0) {return 0;}
            this.count = count;
            this.title = null;
            this.btn1Text = null;
            this.uiSelector = 0;
            return this;
        }

        //映射关系:图标文字
        method reflectName (code func)  -> nothing {
            if (!this.isExist()) {return;}
            if (trRefName == null) {trRefName = CreateTrigger();}
            TriggerAddCondition(trRefName, Condition(func));
        }

        //映射关系:图标
        method reflectIcon (code func)  -> nothing {
            if (!this.isExist()) {return;}
            if (trRefIcon == null) {trRefIcon = CreateTrigger();}
            TriggerAddCondition(trRefIcon, Condition(func));
        }

        //按钮进入事件触发器
        method registerEnter (code enter)  -> nothing {
            if (!this.isExist()) {return;}
            if (trEnter == null) {trEnter = CreateTrigger();}
            TriggerAddCondition(trEnter, Condition(enter));
        }

        //按钮离开事件触发器
        method registerLeave (code leave)  -> nothing {
            if (!this.isExist()) {return;}
            if (trLeave == null) {trLeave = CreateTrigger();}
            TriggerAddCondition(trLeave, Condition(leave));
        }

        //按钮点击事件触发器
        method registerClick (code click)  -> nothing {
            if (!this.isExist()) {return;}
            if (trClick == null) {trClick = CreateTrigger();}
            TriggerAddCondition(trClick, Condition(click));
        }

        //按钮关闭事件触发器
        method registerClose (code close)  -> nothing {
            if (!this.isExist()) {return;}
            if (trClose == null) {trClose = CreateTrigger();}
            TriggerAddCondition(trClose, Condition(close));
        }

        //按钮1事件触发器
        method registerBtn1 (code btn1)  -> nothing {
            if (!this.isExist()) {return;}
            if (trBtn1 == null) {trBtn1 = CreateTrigger();}
            TriggerAddCondition(trBtn1, Condition(btn1));
        }

        //创建失败的回调触发器
        method registerFail (code fail)  -> nothing {
            if (!this.isExist()) {return;}
            if (trFail == null) {trFail = CreateTrigger();}
            TriggerAddCondition(trFail, Condition(fail));
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            this.count = 0;
            if (trRefName != null) {DestroyTrigger(trRefName);trRefName = null;}
            if (trRefIcon != null) {DestroyTrigger(trRefIcon);trRefIcon = null;}
            if (trEnter != null) {DestroyTrigger(trEnter);trEnter = null;}
            if (trLeave != null) {DestroyTrigger(trLeave);trLeave = null;}
            if (trClose != null) {DestroyTrigger(trClose);trClose = null;}
            if (trBtn1 != null) {DestroyTrigger(trBtn1);trBtn1 = null;}
            if (trClick != null) {DestroyTrigger(trClick);trClick = null;}
            if (trFail != null) {DestroyTrigger(trFail);trFail = null;}
            if (uiSelector != 0) { //理论来说这里问题不大,因为其他玩家这个必是0
                uiSelector.destroy();uiSelector = 0;
            }
        }
    }

    //选择UI
    public struct selector {

        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(selector)

        selectData sd;                           //数据绑定
        icon       icon[SELECT_UI_MAX_COUNT];    //图标(最多12个)
        uiText     uisTxt[SELECT_UI_MAX_COUNT];  //下方的文字
        uiImage    uiMain;                       //UI整体框架（背景）
        uiText     uiTitle;                      //标题
        uiImage    uiBtn1Image;                  //刷新按钮图标
        uiText     uiBtn1Text;                   //刷新按钮文字
        uiBtn      uiBtn1Button;                 //刷新按钮
        uiImage    uiCloseImage;                 //关闭图标
        uiBtn      uiCloseButton;                //关闭图标按钮
        uiImage    uiPageUpImage;                //上一页图标
        uiImage    uiPageDownImage;              //下一页图标
        uiBtn      uiPageUpButton;               //上一页按钮
        uiBtn      uiPageDownButton;             //下一页按钮
        tooltip    uiTooltipClose;               //关闭按钮提示
        integer    currentPage;                  //当前页码
        integer    totalPage;                    //总页码

        //创建选择支持异步调用
        static method create (player p,selectData sd) -> thistype {
            integer i; integer createCount; integer row; integer col; integer colsInRow; integer rowCount; integer pos;
            real startX; real startY; real offsetX; real offsetY;
            thistype this = 0;
            if (!sd.isExist()) {
                BJDebugMsg("selector.create: selectData not exist");
                return 0;
            }
            if (GetLocalPlayer() != p) {return 0;}

            if (sd.uiSelector.isExist()) {
                BJDebugMsg("selector.create: selector already exist");
                return 0;
            }
            this = allocate();
            if (!this.isExist()) {
                //todo:创建失败的回调处理,但是600个理论不会失败吧,失败了这是异步情况要直接触发回调
                BJDebugMsg("selector.create: allocate failed");
                return 0;
            }

            sd.uiSelector = this;

            // 计算实际创建的图标数量和总页数
            if (sd.count > SELECT_UI_MAX_COUNT) {
                createCount = SELECT_UI_MAX_COUNT;
                totalPage = (sd.count + SELECT_UI_MAX_COUNT - 1) / SELECT_UI_MAX_COUNT; // 向上取整
            } else {
                createCount = sd.count;
                totalPage = 1;
            }
            currentPage = 1;
            this.sd = sd; //绑定数据

            uiMain = uiImage.create(DzGetGameUI())
                .setTexture("ui\\image\\bg_select.blp")
                .setPoint(ANCHOR_TOP, DzGetGameUI(), ANCHOR_CENTER, 0, 0.035)
                .exReSize(0.3196,0.19);
            uiTitle = uiText.create(uiMain.ui)
                .setFontSize(7)
                .setText(sd.title)
                .exRePoint(ANCHOR_TOP, uiMain.ui, ANCHOR_TOP, -SIZE_OFFSET_X, -0.025-SIZE_OFFSET_Y);

            // 计算行数：每行最多6个
            rowCount = (createCount + 5) / 6; // 向上取整

            // 创建图标并布局
            for (1 <= i <= createCount) {
                pos = i+(currentPage-1)*SELECT_UI_MAX_COUNT; //含页码的当前项
                // 计算当前图标所在行列（从0开始）
                row = (i - 1) / 6;
                col = ModuloInteger(i - 1, 6);

                // 计算当前行有多少个图标
                if (row == rowCount - 1) { // 最后一行
                    colsInRow = createCount - row * 6;
                } else {
                    colsInRow = 6;
                }

                // 计算当前行的起始X偏移（使该行居中）
                startX = 0.0 - (colsInRow - 1) * (SIZE_ICON_SELECT + SIZE_ICON_GAP_X) / 2.0;

                // 计算整体的起始Y偏移（使所有行垂直居中）
                startY = (rowCount - 1) * (SIZE_ICON_SELECT + SIZE_ICON_GAP_Y) / 2.0;

                // 计算当前图标的偏移量
                offsetX = startX + col * (SIZE_ICON_SELECT + SIZE_ICON_GAP_X) - SIZE_OFFSET_X;
                offsetY = startY - row * (SIZE_ICON_SELECT + SIZE_ICON_GAP_Y) - SIZE_OFFSET_Y;

                // 创建图标
                icon[i] = icon.create(uiMain.ui)
                    .enableResize()
                    .setSize(SIZE_ICON_SELECT, SIZE_ICON_SELECT)
                    .show(true);
                //居中排列
                icon[i].mainImage.exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_CENTER, offsetX, offsetY);

                currentSDAsync = sd;
                currentPosAsync = pos;
                TriggerEvaluate(sd.trRefIcon);
                // 图标
                icon[i].setTexture(currentContent);

                // 注册事件
                icon[i].getClickBtn()
                    .spEnter(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer pos = uiHashTable(frame).eventdata.get2();
                        currentSDAsync = sd;
                        currentPosAsync = pos;
                        TriggerEvaluate(sd.trEnter);
                        music[MUSIC_INDEX_BTN_OVER_1].play();
                    })
                    .spLeave(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer pos = uiHashTable(frame).eventdata.get2();
                        currentSDAsync = sd;
                        currentPosAsync = pos;
                        TriggerEvaluate(sd.trLeave);
                    })
                    .spClick(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        integer pos = uiHashTable(frame).eventdata.get2();
                        DzSyncData("Select", "D"+I2S(StringLength(R2SW(this.sd, 0, 1))) + R2SW(this.sd, 0, 1) + R2SW(pos, 0, 1));
                        music[MUSIC_INDEX_BTN_CLICK].play();
                    });
                uiHashTable(icon[i].getClickBtn().ui).eventdata.bind(this);
                uiHashTable(icon[i].getClickBtn().ui).eventdata.bind2(pos);

                if (sd.trRefName != null) {
                    uisTxt[i] = uiText.create(uiMain.ui)
                        .setFontSize(1)
                        .setPoint(ANCHOR_TOP, icon[i].mainImage.ui, ANCHOR_BOTTOM, 0, -0.002);
                    currentSDAsync = sd;
                    currentPosAsync = pos;
                    TriggerEvaluate(sd.trRefName);
                    // 创建文字
                    uisTxt[i].setText(currentContent);
                }
            }

            if (sd.trClose != null) { // 创建关闭按钮
                uiCloseImage = uiImage.create(uiMain.ui)
                    .exReSize(0.029,0.029)
                    .setTexture("ui\\image\\select_close.blp")
                    .exRePoint(ANCHOR_CENTER, uiMain.ui, ANCHOR_TOPRIGHT, -0.033,-0.048);
                uiCloseButton = uiBtn.create(uiCloseImage.ui)
                    .setAllPoint(uiCloseImage.ui)
                    .spEnter(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        if (uiTooltipClose != 0) { uiTooltipClose.destroy(); uiTooltipClose = 0; }
                        uiTooltipClose = tooltip.create().layoutTitle("关闭选择");
                        uiTooltipClose.setPoint(ANCHOR_BOTTOM, uiCloseImage.ui, ANCHOR_TOP, 0, 0.01);
                        music[MUSIC_INDEX_BTN_OVER_1].play();
                    })
                    .spLeave(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        if (uiTooltipClose != 0) { uiTooltipClose.destroy(); uiTooltipClose = 0; }
                    })
                    .spClick(function(integer frame) {
                        thistype this = uiHashTable(frame).eventdata.get();
                        DzSyncData("Select","C"+I2S(this.sd)); //触发数据传送
                        music[MUSIC_INDEX_BTN_CLICK].play();
                    });
                uiHashTable(uiCloseButton.ui).eventdata.bind(this);
            }


            return this;
        }
        method onDestroy () { //析构()
            integer i,j;
            if (!this.isExist()) {return;}
            // 销毁icon数组及下方文字
            for (1 <= j <= SELECT_UI_MAX_COUNT) {
                if (icon[j] != 0) {
                    icon[j].destroy();
                    icon[j] = 0;
                }
                if (uisTxt[j] != 0) {
                    uisTxt[j].destroy();
                    uisTxt[j] = 0;
                }
            }
            sd = 0; //绑定数据归0
            // 销毁UI框体以及其它UI组件
            if (uiTitle != 0) { uiTitle.destroy(); uiTitle = 0; }
            if (uiPageUpButton != 0) { uiPageUpButton.destroy(); uiPageUpButton = 0; }
            if (uiPageDownButton != 0) { uiPageDownButton.destroy(); uiPageDownButton = 0; }
            if (uiPageUpImage != 0) { uiPageUpImage.destroy(); uiPageUpImage = 0; }
            if (uiPageDownImage != 0) { uiPageDownImage.destroy(); uiPageDownImage = 0; }
            if (uiBtn1Button != 0) { uiBtn1Button.destroy(); uiBtn1Button = 0; }
            if (uiBtn1Text != 0) { uiBtn1Text.destroy(); uiBtn1Text = 0; }
            if (uiBtn1Image != 0) { uiBtn1Image.destroy(); uiBtn1Image = 0; }
            if (uiCloseButton != 0) { uiCloseButton.destroy(); uiCloseButton = 0; }
            if (uiCloseImage != 0) { uiCloseImage.destroy(); uiCloseImage = 0; }
            if (uiTooltipClose != 0) { uiTooltipClose.destroy(); uiTooltipClose = 0; }
            if (uiMainButton != 0) { uiMainButton.destroy(); uiMainButton = 0; }
            if (uiMain != 0) { uiMain.destroy(); uiMain = 0; }
        }

    }

    function onInit () {
        trigger t = CreateTrigger();
        DzTriggerRegisterSyncData(t,"Select",false);
        TriggerAddCondition(t, Condition(function () {
            string str = DzGetTriggerSyncData();
            player p = DzGetTriggerSyncPlayer();
            integer index = GetConvertedPlayerId(p);
            selectData sd; //对应的选择数据
            integer length; integer pos;

            if (SubStringBJ(str,1,1) == "C") { //关闭
                sd = S2I(SubStringBJ(str,2,StringLength(str)));
                if (sd.isExist() && sd.trClose != null) { //
                    currentSD = sd;
                    TriggerEvaluate(sd.trClose);
                }
            } else if (SubStringBJ(str,1,1) == "D") { //点击

                // 剔除了move前缀
                length = S2I(SubStringBJ(str, 2, 2));
                sd = S2I(SubStringBJ(str, 3, length + 2));
                pos = S2I(SubStringBJ(str, length + 3, StringLength(str)));

                if (sd.isExist() && sd.trClick != null) { //
                    currentSD = sd;
                    currentPos = pos;
                    TriggerEvaluate(sd.trClick);
                }
            }
            str = null;
            p = null;
        }));
        t = null;
    }

}
//! endzinc

#endif
