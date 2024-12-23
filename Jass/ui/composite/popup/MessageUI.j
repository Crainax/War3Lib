#ifndef MessageUIIncluded
#define MessageUIIncluded

#include "edit/Utils/InchUtils.j"
#include "edit/core/constant/Sound.j"



//! zinc



//-----------------------------
// 正下方的消息弹出
library MsgUIPop  requires UIBase,InchUtils,optional Sound {

	#define POP_ICON_SIZE			0.03		//图标的大小
	#define POP_UI_L_W_RATIO		0.29032		//弹出对象的长宽比 931:270
	#define POP_COUNTDOWN_START		40	 		//弹出来的总时长
	#define POP_COUNTDOWN_LEAST		100	 		//最少显示的时长
	#define POP_COUNTDOWN_END		40 			//消失的总时长
	//注册有关动效
	uianim UIA = 0;
	trigger Tr = null;
	integer ISize = 0;

	//这里是所有数组内容
	integer UI[];        //UI框架
	integer UIText[];    //UI标题
	integer UIIcon[];    //UI图标
	integer UIContent[]; //UI图标
	integer ICD[];       //当前运行到哪里了
	integer ITime[];     //总时长
	real RLength[];   //框架的长

	//最后一个是总时长，最短X秒，每50算一秒。
	//标题与图标二选一,倒数第2个参数是整个框架的长。
	public function NewPopUI (player p,string path,string title,string content,real length,real time ) {
		real resizeX;
		if (GetLocalPlayer() != p) {return;}
		if (UIA == 0) {UIA = uianim.create();}

		resizeX = GetResizeRate();

		ISize = ISize + 1;
		UI[ISize] = CreateBackDrop(DzGetGameUI());
		DzFrameSetTexture(UI[ISize],"ui\\image\\BG_PopUI.blp",0);
		UIContent[ISize] = NewTextL(UI[ISize]);
		DzFrameSetSize(UI[ISize],length,length / resizeX * POP_UI_L_W_RATIO); //内容限宽;
		DzFrameSetAbsolutePoint(UI[ISize],ANCHOR_BOTTOM,.4,.1375);

		if (path != null) { //创建图标
			UIIcon[ISize] = CreateBackDrop(UI[ISize]);
			DzFrameSetSize(UIIcon[ISize],POP_ICON_SIZE,POP_ICON_SIZE / resizeX);
			DzFrameSetTexture(UIIcon[ISize],path,0);
			DzFrameSetPoint(UIIcon[ISize],ANCHOR_TOP,UI[ISize],ANCHOR_TOP,0,- 0.012 / resizeX);
			DzFrameSetPoint(UIContent[ISize],ANCHOR_TOP,UIIcon[ISize],ANCHOR_BOTTOM,0,- 0.007 / resizeX);
		} else { //如果没图标那就有标题
			UIText[ISize] = NewTextXL(UI[ISize]);
			DzFrameSetText(UIText[ISize],title);
			DzFrameSetPoint(UIText[ISize],ANCHOR_TOP,UI[ISize],ANCHOR_TOP,0,- 0.018 / resizeX);
			DzFrameSetPoint(UIContent[ISize],ANCHOR_TOP,UIText[ISize],ANCHOR_BOTTOM,0,- 0.007 / resizeX);
		}

		//UIContent4个锚点都控住
		DzFrameSetPoint(UIContent[ISize],ANCHOR_BOTTOM,UI[ISize],ANCHOR_BOTTOM,0,0.005);
		DzFrameSetPoint(UIContent[ISize],ANCHOR_LEFT,UI[ISize],ANCHOR_LEFT,0.01,0.);
		DzFrameSetPoint(UIContent[ISize],ANCHOR_RIGHT,UI[ISize],ANCHOR_RIGHT,- 0.01,0.);
		DzFrameSetText(UIContent[ISize],content);

		ITime[ISize] = IMaxBJ(R2I(time * 50),POP_COUNTDOWN_START + POP_COUNTDOWN_LEAST + POP_COUNTDOWN_END); //持续时间不能低于框出来与消失的时间和
		ICD[ISize] = ITime[ISize];
		RLength[ISize] = length;

		//摆好了再测动画
		DzFrameSetAlpha(UIContent[ISize],0);
		if (UIText[ISize] != 0) {DzFrameSetAlpha(UIText[ISize],0);}
		if (UIIcon[ISize] != 0) {DzFrameSetAlpha(UIIcon[ISize],0);}
		DzFrameSetSize(UI[ISize],0,0);
		UIA.reg(Tr);
	}

	function onInit ( ) {
		Tr = CreateTrigger();
		TriggerAddCondition(Tr, Condition(function (){
			real r,l,resizeX = GetResizeRate();
			integer i;
			for (1 <= i <= ISize) {
				//处理 UData[i]
				ICD[i] = ICD[i] - 1;
				//阶段1：对话框[超速]进入，所有文字/图标[缓速]渐变进来
				if (ICD[i] >= (ITime[i] - POP_COUNTDOWN_START)) {
					r = (I2R(ITime[i] - ICD[i])) / POP_COUNTDOWN_START; //r是当前的进度比;
					l = EaseOutBack(r)* RLength[i];
					DzFrameSetSize(UI[i],l,l / resizeX * POP_UI_L_W_RATIO);
					if (UIText[i] != 0) {DzFrameSetAlpha(UIText[i],R2I(255 * EaseInExpo(r)));}
					if (UIIcon[i] != 0) {DzFrameSetAlpha(UIIcon[i],R2I(255 * EaseInExpo(r)));}
					if (UIContent[i] != 0) {DzFrameSetAlpha(UIContent[i],R2I(255 * EaseInExpo(r)));}
				}
				//阶段2：不动

				//阶段3：对话框[反弹]离开，所有文字/图标[急速]渐变褪去
				if (ICD[i] <= POP_COUNTDOWN_END) {
					l = (1.0 - EaseInBack(1.0 - (I2R(ICD[i]) / POP_COUNTDOWN_END)))* RLength[i];
					// l = (1.0 - EaseOutBounce(1.0 - (I2R(ICD[i]) / POP_COUNTDOWN_END)))* RLength[i]  //这个是弹跳式;
					DzFrameSetSize(UI[i],l,l / resizeX * POP_UI_L_W_RATIO);
					if (UIText[i] != 0) {DzFrameSetAlpha(UIText[i],255 - R2I(255 * EaseOutExpo(1.0 - I2R(ICD[i])/ POP_COUNTDOWN_END)));}
					if (UIIcon[i] != 0) {DzFrameSetAlpha(UIIcon[i],255 - R2I(255 * EaseOutExpo(1.0 - I2R(ICD[i])/ POP_COUNTDOWN_END)));}
					if (UIContent[i] != 0) {DzFrameSetAlpha(UIContent[i],255 - R2I(255 * EaseOutExpo(1.0 - I2R(ICD[i])/ POP_COUNTDOWN_END)));}
				}

				if (ICD[i] <= 0) {
					//这里清空[i]有关的数据
					if (UI[i] != 0) {DzDestroyFrame(UI[i]);}
					if (UIText[i] != 0 ) {DzDestroyFrame(UIText[i]);}
					if (UIIcon[i] != 0 ) {DzDestroyFrame(UIIcon[i]);}
					if (UIContent[i] != 0 ) {DzDestroyFrame(UIContent[i]);}

					//删除i对应的数据,互换尾部
					UI[i]        = UI[ISize];
					UIText[i]    = UIText[ISize];
					UIIcon[i]    = UIIcon[ISize];
					UIContent[i] = UIContent[ISize];
					ICD[i]       = ICD[ISize];
					ITime[i]     = ITime[ISize];
					RLength[i]   = RLength[ISize];

					UI[ISize]        = 0;
					UIText[ISize]    = 0;
					UIIcon[ISize]    = 0;
					UIContent[ISize] = 0;
					ICD[ISize]       = 0;
					ITime[ISize]     = 0;
					RLength[ISize]   = 0;

					ISize -=1;
					i     -=1;
				}

			}

			if (ISize <= 0) {UIA.unreg();} //数据都处理完了，停止计时器吧
		}));
	}
}

// 正上方的消息弹出
library MsgUIBC  requires UIBase,InchUtils,optional Sound {

	#define BROADCAST_ICON_SIZE				0.03    //图标的大小
	#define BROADCAST_UI_L_W_RATIO			0.23360 //弹出对象的长宽比 1143:267
	#define BROADCAST_COUNTDOWN_START		40      //出现的总时长
	#define BROADCAST_COUNTDOWN_LEAST		100     //最少显示的时长
	#define BROADCAST_COUNTDOWN_END			40      //消失的总时长
	//注册有关动效
	uianim UIA = 0;
	trigger Tr = null;
	integer ISize = 0;

	//这里是所有数组内容
	integer UI[];        //UI框架
	integer UIIcon[];    //UI图标
	integer UIContent[]; //UI内容
	integer ICD[];       //当前运行到哪里了
	integer ITime[];     //总时长
	real RLength[];      //UI总长


	//最后一个是总时长，最短X秒，每50算一秒。
	//标题与图标二选一,倒数第2个参数是整个框架的长。
	//最后一个参数可以加.代表继续向下的偏移.
	public function NewBroadcast (player p,string path,string content,real length,real time,real yOff)-> integer {
		real resizeX;
		if (GetLocalPlayer() != p) {return 0;}
		if (UIA == 0) {UIA = uianim.create();}

		resizeX = GetResizeRate();

		ISize = ISize + 1;
		UI[ISize] = CreateBackDrop(DzGetGameUI());
		DzFrameSetTexture(UI[ISize],"ui\\image\\BG_Broadcast.blp",0);
		UIContent[ISize] = NewTextMLeftXL(UI[ISize]);
		DzFrameSetSize(UI[ISize],length,length / resizeX * BROADCAST_UI_L_W_RATIO); //内容限宽;
		DzFrameSetAbsolutePoint(UI[ISize],ANCHOR_CENTER,.4,.535 - yOff);

		if (path != null) {
			UIIcon[ISize] = CreateBackDrop(UI[ISize]);
			DzFrameSetSize(UIIcon[ISize],BROADCAST_ICON_SIZE * length / 0.3,BROADCAST_ICON_SIZE * length / 0.3 / resizeX);
			DzFrameSetTexture(UIIcon[ISize],path,0);
			DzFrameSetPoint(UIIcon[ISize],ANCHOR_CENTER,UI[ISize],ANCHOR_LEFT,0.036 * length / 0.3,0);
			DzFrameSetPoint(UIContent[ISize],ANCHOR_LEFT,UIIcon[ISize],ANCHOR_RIGHT,0.025 * length / 0.3,0);
		}

		//UIContent4个锚点都控住
		DzFrameSetPoint(UIContent[ISize],ANCHOR_BOTTOM,UI[ISize],ANCHOR_BOTTOM,0,0.01 / resizeX);
		DzFrameSetPoint(UIContent[ISize],ANCHOR_TOP,UI[ISize],ANCHOR_TOP,0,- 0.01 / resizeX);
		DzFrameSetPoint(UIContent[ISize],ANCHOR_RIGHT,UI[ISize],ANCHOR_RIGHT,- 0.01 * length / 0.3,0.);
		DzFrameSetText(UIContent[ISize],content);

		//持续时间不能低于框出来与消失的时间和
		ITime[ISize]   = IMaxBJ(R2I(time * 50),BROADCAST_COUNTDOWN_START + BROADCAST_COUNTDOWN_LEAST + BROADCAST_COUNTDOWN_END);
		ICD[ISize]     = ITime[ISize];
		RLength[ISize] = length;

		//摆好了再测动画
		DzFrameSetAlpha(UIContent[ISize],0);
		if (UIIcon[ISize] != 0) {DzFrameSetAlpha(UIIcon[ISize],0);}
		//  DzFrameSetAlpha(UI[ISize],0);
		DzFrameSetSize(UI[ISize],length,0);
		UIA.reg(Tr);

		return UI[ISize];
	}

	function onInit () {
		Tr = CreateTrigger();
		TriggerAddCondition(Tr, Condition(function (){
			real r,l,resizeX = GetResizeRate();
			integer i;
			for (1 <= i <= ISize) {
				//处理 UData[i]
				ICD[i] = ICD[i] - 1;

				//阶段1：对话框[超速]进入，所有文字/图标[缓速]渐变进来
				if (ICD[i] >= (ITime[i] - BROADCAST_COUNTDOWN_START)) {
					r = (I2R(ITime[i] - ICD[i])) / BROADCAST_COUNTDOWN_START; //r是当前的进度比;
					l = EaseOutBounce(r)* RLength[i];  //这个是弹跳式;
					DzFrameSetSize(UI[i],RLength[i],l / resizeX * BROADCAST_UI_L_W_RATIO);
					if (UIIcon[i] != 0) {DzFrameSetAlpha(UIIcon[i],R2I(255 * EaseInExpo(r)));}
					if (UIContent[i] != 0) {DzFrameSetAlpha(UIContent[i],R2I(255 * EaseInExpo(r)));}
				}
				//阶段2：不动

				//阶段3：对话框[反弹]离开，所有文字/图标[急速]渐变褪去
				if (ICD[i] <= BROADCAST_COUNTDOWN_END) {
					l = (1.0 - EaseOutBounce(1.0 - (I2R(ICD[i]) / BROADCAST_COUNTDOWN_END)))* RLength[i];  //这个是弹跳式;
					DzFrameSetSize(UI[i],RLength[i],l / resizeX * BROADCAST_UI_L_W_RATIO);
					DzFrameSetAlpha(UI[i],255 - R2I(255 * EaseInExpo(1.0 - I2R(ICD[i])/ BROADCAST_COUNTDOWN_END)));
					if (UIIcon[i] != 0) {DzFrameSetAlpha(UIIcon[i],255 - R2I(255 * EaseOutExpo(1.0 - I2R(ICD[i])/ BROADCAST_COUNTDOWN_END)));}
					if (UIContent[i] != 0) {DzFrameSetAlpha(UIContent[i],255 - R2I(255 * EaseOutExpo(1.0 - I2R(ICD[i])/ BROADCAST_COUNTDOWN_END)));}
				}

				if (ICD[i] <= 0) {
					//这里清空[i]有关的数据
					if (UI[i] != 0) {DzDestroyFrame(UI[i]);}
					if (UIIcon[i] != 0 ) {DzDestroyFrame(UIIcon[i]);}
					if (UIContent[i] != 0 ) {DzDestroyFrame(UIContent[i]);}

					//删除i对应的数据,互换尾部
					UI[i]        = UI[ISize];
					UIIcon[i]    = UIIcon[ISize];
					UIContent[i] = UIContent[ISize];
					ICD[i]       = ICD[ISize];
					ITime[i]     = ITime[ISize];
					RLength[i]   = RLength[ISize];

					UI[ISize]        = 0;
					UIIcon[ISize]    = 0;
					UIContent[ISize] = 0;
					ICD[ISize]       = 0;
					ITime[ISize]     = 0;
					RLength[ISize]   = 0;

					ISize -= 1;
					i     -= 1;
				}

			}

			if (ISize <= 0) {UIA.unreg();} //数据都处理完了，停止计时器吧
		}));
	}
}

// 来怪了的提示
library MsgUIMst  requires UIBase,InchUtils,optional Sound {

	#define MST_COME_UI_LENGTH       0.4 //UI的长
	#define MST_COME_UI_WIDTH        0.2 //UI的宽
	#define MST_COME_UI_SCALE_RADIO  0.5 //虚化缩小时放大多少倍
	#define MST_COME_COUNTDOWN_START 40  //出现的总时长
	#define MST_COME_COUNTDOWN_LEAST 400 //显示的时长[此时不断闪烁]
	#define MST_COME_COUNTDOWN_END   40  //消失的总时长
	#define MST_COME_COUNTDOWN_TOTAL 480 //以上三个相加的总和
	#define MST_COME_COUNTDOWN_BLNK   80 //多少帧闪一个周期

	uianim  UIA     = 0;     //动效
	trigger Tr      = null;  //动效实现
	integer UI      = 0;     //UI框架
	integer UILeft  = 0;     //UI左图片
	integer UIRight = 0;     //UI右图片
	integer ICD     = 0;     //当前运行到哪里了


	//mstType，传1：BOSS,传2：精英怪物。
	public function ShowMstComeUI (integer mstType ) {
		real resizeX;

		if (ICD > 0) {return;}
		if (UIA == 0) {UIA = uianim.create();}

		resizeX = GetResizeRate();
		UI = CreateBackDrop(DzGetGameUI());
		UILeft = CreateBackDrop(UI);
		UIRight = CreateBackDrop(UI);

		if (mstType == 1) {
			//BOSS的图片
			DzFrameSetTexture(UILeft,"ui\\image\\BG_Mst_Boss_1.blp",0);
			DzFrameSetTexture(UIRight,"ui\\image\\BG_Mst_Boss_2.blp",0);
		} else if (mstType == 2) {
			//精英的图片
			DzFrameSetTexture(UILeft,"ui\\image\\BG_Mst_Crack_1.blp",0);
			DzFrameSetTexture(UIRight,"ui\\image\\BG_Mst_Crack_2.blp",0);
		} else {
			//普通进攻
			DzFrameSetTexture(UILeft,"ui\\image\\BG_Mst_Normal_1.blp",0);
			DzFrameSetTexture(UIRight,"ui\\image\\BG_Mst_Normal_2.blp",0);
		}
		DzFrameSetPoint(UI,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0.1);
		DzFrameSetPoint(UILeft,ANCHOR_RIGHT,UI,ANCHOR_CENTER,0,0);
		DzFrameSetPoint(UIRight,ANCHOR_LEFT,UI,ANCHOR_CENTER,0,0);
		DzFrameSetSize(UI,0.001,0.001);

		//持续时间不能低于框出来与消失的时间和
		ICD = MST_COME_COUNTDOWN_TOTAL;

		//摆好了再测动画
		//  DzFrameSetSize(UILeft,MST_COME_UI_LENGTH * 0.5 * (1.0 + MST_COME_UI_SCALE_RADIO),MST_COME_UI_WIDTH * (1.0 + MST_COME_UI_SCALE_RADIO) / resizeX);
		//  DzFrameSetSize(UIRight,MST_COME_UI_LENGTH * 0.5 * (1.0 + MST_COME_UI_SCALE_RADIO),MST_COME_UI_WIDTH * (1.0 + MST_COME_UI_SCALE_RADIO) / resizeX);
		DzFrameSetAlpha(UI,0);
		UIA.reg(Tr);
	}

	function onInit ( ) {
		Tr = CreateTrigger();
		TriggerAddCondition(Tr, Condition(function (){
			real r,l,resizeX = GetResizeRate();

			ICD = ICD - 1;
			//阶段1：虚化缩小进来
			if (ICD >= (MST_COME_COUNTDOWN_TOTAL - MST_COME_COUNTDOWN_START)) {
				r = (I2R(MST_COME_COUNTDOWN_TOTAL - ICD)) / MST_COME_COUNTDOWN_START; //r是当前的进度比;
				l = (1.0 - EaseInOutBack(r)) * MST_COME_UI_SCALE_RADIO + 1.0;
				DzFrameSetAlpha(UI,R2I(EaseOutExpo(r)* 255));
				DzFrameSetSize(UILeft,l * MST_COME_UI_LENGTH * 0.5,l * MST_COME_UI_WIDTH / resizeX);
				DzFrameSetSize(UIRight,l * MST_COME_UI_LENGTH * 0.5,l * MST_COME_UI_WIDTH / resizeX);
			} else if (ICD <= MST_COME_COUNTDOWN_END) {
				//阶段3：
				r = (1.0 - I2R(ICD)/ MST_COME_COUNTDOWN_END);
				l = EaseInOutBack(r) * MST_COME_UI_SCALE_RADIO + 1.0;
				DzFrameSetAlpha(UI,255 - R2I(255 * EaseInExpo(r)));
				DzFrameSetSize(UILeft,l * MST_COME_UI_LENGTH * 0.5,l * MST_COME_UI_WIDTH / resizeX);
				DzFrameSetSize(UIRight,l * MST_COME_UI_LENGTH * 0.5,l * MST_COME_UI_WIDTH / resizeX);
			} else {
				//阶段2：间歇式闪烁
				r = ModuloReal(0.5 + I2R(MST_COME_COUNTDOWN_TOTAL - ICD - MST_COME_COUNTDOWN_START) / (MST_COME_COUNTDOWN_BLNK),1.0);
				DzFrameSetAlpha(UI,R2I(InchCustom4(r) * 255));
			}

			if (ICD <= 0) {
				//数据都处理完了，停止计时器吧
				if (UI != 0) {
					DzDestroyFrame(UI);
					UI = 0;
				}
				if (UILeft != 0) {
					DzDestroyFrame(UILeft);
					UILeft = 0;
				}
				if (UIRight != 0) {
					DzDestroyFrame(UIRight);
					UIRight = 0;
				}
				UIA.unreg();
			}
		}));
	}
}


//副本的揭示
library MsgUIFuben  requires UIBase,MsgUIBC,InchUtils,optional Sound {

	#define FUBEN_UI_LENGTH       0.26                          //总UI的长
	#define FUBEN_UI_WIDTH        0.13                          //总UI的宽
	#define FUBEN_CHEST_UI_LENGTH FUBEN_UI_LENGTH * 1.2304      //宝箱UI的长
	#define FUBEN_CHEST_UI_WIDTH FUBEN_UI_LENGTH * 1.2304 * 0.5 //宝箱UI的宽
	#define FUBEN_COUNTDOWN_START 30                            //出现的总时长[简单的]
	#define FUBEN_COUNTDOWN_HOLD  200                           //缓慢移动的总时长[简单的]
	#define FUBEN_COUNTDOWN_END   30                            //消失的总时长[简单的]
	#define FUBEN_DISTANCE_START - 0.2                          //开始时的位置[中心点对齐]
	#define FUBEN_DISTANCE_HOLD_1 - 0.05                        //锚点距离1
	#define FUBEN_DISTANCE_HOLD_2 0.05                          //锚点距离2
	#define FUBEN_DISTANCE_END    0.2                           //结束后要移动到位置

	baseanim BAStart = 0;  //左进的动画
	baseanim BAHold  = 0;  //右出的动画
	baseanim BAEnd   = 0;  //中间缓动的动画
	integer  UI      = 0;  //UI框架
	integer  UIAlign = 0;  //UI移动时所锚的点
	integer  UIChest = 0;  //得到了几个宝箱

	//副本开始
	//副本失败离场(用同一个UI,单例同步运行,左进右出,中间缓) 0:进入 ,1离开(失败),2过关
	//副本成功离场(至多3颗星星的独立生命周期动画。展开背景。展开后再跳字，离场用一样的右出离场)
	//最后一个参数是几个宝箱[范围1-3]
	public function ShowFubenUI (player p, integer fbType,integer stars ) {
		real resizeX;

		if (p != GetLocalPlayer()) {return;}

		resizeX = GetResizeRate();

		//甚至不用删，注册个resize回调就行
		if (UI != 0) {
			DzDestroyFrame(UIAlign);
			DzDestroyFrame(UI);
			DzDestroyFrame(UIChest);
			BAStart.destroy();
			BAHold.destroy();
			BAEnd.destroy();
		}

		UIAlign = CreateBackDrop(DzGetGameUI());
		UI = CreateBackDrop(UIAlign);
		UIChest = CreateBackDrop(UI);
		BAStart = baseanim.create(UI);
		BAHold = baseanim.create(UI);
		BAEnd = baseanim.create(UI);

		DzFrameSetSize(UIAlign,0.001,0.001);
		DzFrameSetSize(UI,FUBEN_UI_LENGTH,FUBEN_UI_WIDTH / resizeX);
		DzFrameSetSize(UIChest,FUBEN_CHEST_UI_LENGTH,FUBEN_CHEST_UI_WIDTH / resizeX);
		DzFrameSetPoint(UIAlign,ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0.15);
		DzFrameSetPoint(UIChest,ANCHOR_CENTER,UI,ANCHOR_BOTTOM,0,0.1 * FUBEN_UI_WIDTH / resizeX);

		//这个可以不用删，反正是单例
		if (fbType == 1) { //副本失败的图片
			DzFrameSetTexture(UI,"ui\\image\\BG_Fuben_Fail.blp",0);
			DzFrameShow(UIChest,false); //不显示宝箱;
		} else if (fbType == 2) { //副本成功的图片
			stars = ILimit(stars,1,3);
			DzFrameSetTexture(UI,"ui\\image\\BG_Fuben_Pass.blp",0);
			DzFrameSetTexture(UIChest,"ui\\image\\BG_Fuben_Chest" + I2S(stars)+ ".blp",0);
			DzFrameShow(UIChest,true); //显示宝箱有几个;
		} else { //副本开始的图片
			DzFrameSetTexture(UI,"ui\\image\\BG_Fuben_Start.blp",0);
			DzFrameShow(UIChest,false); //不显示宝箱;
		}
		DzFrameShow(UI,true);
		//摆好了再测动画
		//  DzFrameSetPoint(UI,ANCHOR_CENTER,UIAlign,ANCHOR_CENTER,0,0.);
		DzFrameSetAlpha(UI,0);
		BAStart.addAlpha(0,255,FUBEN_COUNTDOWN_START);
		BAStart.addMove(UIAlign,FUBEN_DISTANCE_START,FUBEN_DISTANCE_HOLD_1 - FUBEN_DISTANCE_START,FUBEN_COUNTDOWN_START,0,ANCHOR_CENTER,ANCHOR_CENTER);
		BAHold.addDelay(FUBEN_COUNTDOWN_START);
		BAHold.addMove(UIAlign,FUBEN_DISTANCE_HOLD_1,FUBEN_DISTANCE_HOLD_2 - FUBEN_DISTANCE_HOLD_1,FUBEN_COUNTDOWN_HOLD,0,ANCHOR_CENTER,ANCHOR_CENTER);
		BAEnd.addDelay(FUBEN_COUNTDOWN_HOLD + FUBEN_COUNTDOWN_START);
		BAEnd.addAlpha(255,0,FUBEN_COUNTDOWN_END);
		BAEnd.addMove(UIAlign,FUBEN_DISTANCE_HOLD_2,FUBEN_DISTANCE_END - FUBEN_DISTANCE_HOLD_2,FUBEN_COUNTDOWN_END,0,ANCHOR_CENTER,ANCHOR_CENTER);
	}

	#define FUBEN_DONE_TIME         300 //总共持续的时间
	#define FUBEN_DONE_START_DELAY  18  //进场出现的延迟
	#define FUBEN_DONE_START_DURING 30  //进场出现持续时间
	#define FUBEN_DONE_END_DURING   18  //离场出现持续时间
	#define FUBEN_DONE_END_DELAY    200 //离场出现的延迟
	#define FUBEN_DOWN_SIZE_START   .4  //已达成框的起始长宽
	#define FUBEN_DOWN_SIZE_END     .15 //已达成框的最终长宽

	//显示对应的
	public function ShowFubenQuest (player p,string path,string content ) {
		//委托MsgBC来做
		integer bc = NewBroadcast(p,path,content,0.3,FUBEN_DONE_TIME * 0.02,0.08);
		real resizeX;
		integer ui;
		baseanim ba;
		baseanim ba2;
		if (bc != 0) {
			//这里开始就异步了
			ui = CreateBackDrop(DzGetGameUI());
			ba = baseanim.create(ui);
			ba2 = baseanim.create(ui);
			resizeX = GetResizeRate();

			DzFrameSetSize(ui,FUBEN_DOWN_SIZE_START,FUBEN_DOWN_SIZE_START / resizeX);
			DzFrameSetTexture(ui,"ui\\image\\fuben_Done.blp",0);
			DzFrameSetPoint(ui,ANCHOR_CENTER,bc,ANCHOR_CENTER,0,0);
			DzFrameSetAlpha(ui,0);
			ba.addDelay(FUBEN_DONE_START_DELAY);
			ba.addAlpha(0,255,FUBEN_DONE_START_DURING);
			ba.addZoom(FUBEN_DOWN_SIZE_START,FUBEN_DOWN_SIZE_END,FUBEN_DOWN_SIZE_START,FUBEN_DOWN_SIZE_END,30);
			ba.addLife(61,false);
			ba2.addDelay(FUBEN_DONE_END_DELAY);
			ba2.addAlpha(255,0,FUBEN_DONE_END_DURING);
			ba2.addLife(FUBEN_DONE_TIME + 1,true);
		}
	}


	//副本达成条件(1-3)独立事件,
	//动画:完成某个条件[判断UI是否存在,创建个一次性序列帧]
	//副本通关离场()
	function onInit ( ) {
		hardware.regResizeEvent(function (){
			real resizeX = GetResizeRate();
			if (UI != 0) {DzFrameSetSize(UI,FUBEN_UI_LENGTH,FUBEN_UI_WIDTH / resizeX);}
			if (UIChest != 0) {DzFrameSetSize(UIChest,FUBEN_CHEST_UI_LENGTH,FUBEN_CHEST_UI_WIDTH / resizeX);}
		});
	}


}

//消息UI集合
// Todo:还有个饼,用INCHUTILS来制作彩色动态文字
library MessageUI requires MsgUIHint,MsgUIPop,MsgUIBC,MsgUIMst,MsgUIFuben,optional MsgUIColorText {

}

//! endzinc


#endif


