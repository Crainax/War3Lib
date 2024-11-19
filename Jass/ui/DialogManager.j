#ifndef DialogsIncluded
#define DialogsIncluded

#include "Crainax/config/SharedMethod.h"

//! zinc
//===========================================================================
// DialogUtils.j
//===========================================================================
// 对话框工具库
//
// 功能特性:
// - 支持动态创建和销毁对话框
// - 支持内容分页显示(每页最多8条)
// - 支持上一页/下一页导航
// - 支持ESC快捷键退出
// - 支持标题和内容的动态绑定
// - 单例模式确保每个玩家只有一个活动对话框
//
// 使用示例:
// dialogs dl = dialogs.create(Player(0), "测试标题", 10);
// dl.refTitle(function yourTitleHandler);
// dl.onClick(function yourClickHandler);
// dl.show();
//
// 作者: Crainax
// 最后修改: 2024-11-18
// 注意:对话框很容易被卡掉,用的话当能被取消情况下使用
//===========================================================================
library DialogManager {

    #define DIALOGS_COUNT_CONTENT 8  //每页最多显示
    #define DIALOGS_COUNT_MAX     11 //加上3个后的最大

    type funTitle extends function(dlgMgr,integer) -> string;  // 标题生成函数指针类型

    public struct dlgCtx [] {
        static dlgMgr dlThis = 0;    //当前的对话框
        static integer pos    = 0;    //当前的位置[点击/遍历获取]
    }

    public dlgMgr DL[]; //单例
    public struct dlgMgr {

        trigger trClickO;				//点击事件[绑定创建]
        trigger trClick;				//点击事件回调
        funTitle titleRef;				//标题生成函数指针
        trigger trBind;					//对话框绑定数据->位置映射
        player p;						//对应谁
        dialog d;						//对话框本身
        button btn[DIALOGS_COUNT_MAX];	//最多8个(+3个翻页/退出)
        integer num;					//内容数量
        integer page;					//当前页码
        string title;					//对话框的标题
        boolean esc;					//是否带退出页面

        STRUCT_SHARED_METHODS(dlgMgr)

        //计算对话框的总页数
        //返回: (内容数-1)/每页显示数 + 1
        private method maxCount () -> integer {
            return (num - 1) / DIALOGS_COUNT_CONTENT + 1;
        }

        //显示对话框内容
        //根据当前页码显示对应的按钮内容
        //如果页数>1则显示翻页按钮
        //如果开启esc则显示退出按钮
        method show () {
            integer i,pos,max = maxCount();
            for (1 <= i <= DIALOGS_COUNT_CONTENT) {
                pos = i + (page-1) * DIALOGS_COUNT_CONTENT;
                if (pos <= num) {
                    btn[i] = DialogAddButton(d, titleRef.evaluate(this,pos), 0);
                }
            }
            if (max > 1) {
                btn[DIALOGS_COUNT_CONTENT+1] = DialogAddButton(d,"上一页",0);
                btn[DIALOGS_COUNT_CONTENT+2] = DialogAddButton(d,"下一页",0);
            }
            if (esc) {
                btn[DIALOGS_COUNT_CONTENT+3] = DialogAddButton(d,"退出|cffff6800(Esc)|r",512 );
            }

            if (max > 1) DialogSetMessage( d, title + "("+I2S(page)+"/"+I2S(max)+")");
            else DialogSetMessage( d, title);
            DialogDisplay( p, d, true );
        }

        //清除对话框当前显示的所有按钮
        //通常在切换页面前调用
        private method clear () {
            DialogClear(d);
        }

        //创建一个新的对话框实例
        //参数: p - 目标玩家
        //      title - 对话框标题
        //      num - 内容总条数
        //返回: 新创建的对话框实例
        //注意: 会自动销毁该玩家已存在的对话框
        static method create (player p,string title,integer num) -> thistype {
            integer index = GetConvertedPlayerId(p);
            thistype this;
            if (DL[index].isExist()) DL[index].destroy(); //销毁之前的,保证单例
            this = allocate();
            DL[index] = this;
            this.trClickO = CreateTrigger();
            this.d = DialogCreate();
            this.p = p;
            this.num = num;
            this.title = title;
            this.page = 1;
            this.esc = false;
            // SaveInteger(UNTable,GetHandleId(.d),1,this);
            TriggerRegisterDialogEvent( trClickO, d );
            TriggerAddCondition(trClickO,Condition(function (){ //点击事件
                thistype this = 0;
                integer index,i;
                boolean find = false; //是否匹配成功
                for (1 <= index <= 12) {
                    if (DL[index].d == GetClickedDialog()) { //匹配玩家成功
                        for (1 <= i <= DIALOGS_COUNT_MAX) {
                            if (DL[index].btn[i] == GetClickedButton()) { //匹配按钮成功
                                this = DL[index];
                                find = true;
                                break;
                            }
                        }
                    }
                    if (find) break;
                }
                if (!find || !this.isExist()) {BJDebugMsg("未捕捉的点击事件");return;} //未捕捉到的点击事件
                if (i >= 1 && i <= DIALOGS_COUNT_CONTENT) { //如果点击的是对应按钮
                    dlgCtx.pos = i + (page-1) * DIALOGS_COUNT_CONTENT; //点击位置,包含页数
                    dlgCtx.dlThis = this;
                    TriggerEvaluate(trClick);
                } else if (i == DIALOGS_COUNT_CONTENT + 1) { //点击的是上一页
                    if (page <= 1) page = maxCount();
                    else page -= 1;
                    clear(); //清除现有
                    show(); //再重新生成下一页
                } else if (i == DIALOGS_COUNT_CONTENT + 2) { //点击的是下一页
                    if (page >= maxCount()) page = 1;
                    else page += 1;
                    clear(); //清除现有
                    show(); //再重新生成下一页
                } else if (i == DIALOGS_COUNT_CONTENT + 3) { //点击的是退出
                    destroy();
                }

            }));
            return this;
        }

        //设置按钮点击事件的回调函数
        //参数: onClick - 点击事件处理函数
        //注意: 会替换掉之前设置的回调
        method onClick (code onClick) {
            if (trClick != null) {DestroyTrigger(trClick);}
            trClick = CreateTrigger();
            TriggerAddCondition(trClick,Condition(onClick));
        }

        //设置标题内容的生成函数
        //参数: titleRef - 标题生成函数(integer -> string)
        method refTitle (funTitle titleRef) {
            this.titleRef = titleRef;
        }

        //销毁对话框实例
        //清理所有相关资源:
        //- 触发器(点击/标题/绑定)
        //- 按钮数组
        //- 对话框本体
        //- 玩家引用
        //- 单例记录
        method onDestroy () {
            integer i;
            integer index = GetConvertedPlayerId(p);
            DestroyTrigger(trClickO);
            DestroyTrigger(trClick);
            trClickO = null;
            trClick = null;
            titleRef = 0;  // 清除函数指针
            for (1 <= i <= DIALOGS_COUNT_MAX) {
                btn[i] = null;
            }
            DialogDisplay( p, d, false );
            DialogClear(d);
            DialogDestroy(d);
            d = null;
            p = null;
            title = null;
            DL[index] = 0;
        }

    }

}

//! endzinc

#endif
