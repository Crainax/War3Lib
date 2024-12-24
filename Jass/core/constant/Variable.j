#ifndef VariableIncluded
#define VariableIncluded

#include "Constant.j"
//! zinc
/*
公用变量
*/
#define PLAYER_NAME "剡无荒之迹"
library Variable requires Constant {

	//玩家信息
	public struct pd [] {
		integer gold;	//金币
		integer gem;	//宝石
		integer kill;	//杀怪
		string name;	//名字

		integer goldRate;	//金币获取率,除100
		integer goldNega;	//金币负获取率,除100
		integer gemRate;	//结晶获取率,除100
		integer gemNega;	//结晶负获取率,除100
		integer killExtra;	//不用除100,单纯加减
		integer killNega;	//不用除100,单纯加减
		//以后再说:要不要金币与宝石突破上限

		optional module auraAfter; //引用
	}
	//主英雄
	public unit H[];
	public unit USelected[]; //正在选择的单位[同步]

	//几个矩形区域
	public rect RHome[];
	public rect RFuben[];

	function onInit ()  {
		//在游戏开始0.1秒后再调用
		integer i = 1;
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.2);
		TriggerAddCondition(tr,Condition(function (){
			integer i;
			for (1 <= i <= MAX_PLAYER_COUNT) {
				pd[i].name = GetPlayerName(ConvertedPlayer(i));
			}
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;


	}
}

//! endzinc
#endif

