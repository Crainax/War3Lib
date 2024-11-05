#ifndef UTEffectUtilsIncluded
#define UTEffectUtilsIncluded

#include "edit/core/constant/Variable.j"
#include "d:/War3/Maps/PhantomOrbit/edit/Utils/EffectUtils.j"
// #include "edit/Base/UIBase.j"
#include "edit/Utils/LuaUtils.j"
// #include "UnitTest_HeroStruct.j" //测试模块
// #include "UnitTest_GuaiStruct.j" //测试模块[创建怪物们]
// #include "edit/Event/EventAll.j" //事件

// #include "edit/ChatEvent.j" //通用聊天事件
// #include "edit/Utils/modules/EffectStat.j"

//! zinc

//blp
//blp
//blp
//自动生成的文件
library UTEffectUtils requires optional EffectUtils,Variable,optional LuaUtils,optional UTHeroStruct,optional ChatEvent { //blp
	//blp
	//blp

	#ifdef TestMode

	//blp
	//blp
	//blp
	//blp
	//blp
	function TTestUTEffectUtils1 (player p) {
		MemoryLeakShow();
		StructShow();
		GetLocalizedHotkey("yd_leak_monitor::create_report");
		DumpAllString("PO_stringTT.txt");
	}
	//blp
	//blp
	//blp
	function TTestUTEffectUtils2 (player p) { //测试一下纯直线弹幕
		missile ms;
		integer i;
		for (1 <= i <= 10) {
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",GetRandomReal(-2000,2000),GetRandomReal(-2000,2000),0,GetRandomReal(-2000,2000),GetRandomReal(-2000,2000),0,GetRandomReal(30,100),function(){
				BJDebugMsg("到达地点咯!");
			});
		}
	}
	function TTestUTEffectUtils3 (player p) { //測試一下向上飞的直线弹幕
		missile ms;
		integer i;
		real x;
		real y;
		for (1 <= i <= 10) {
			// ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",0,0,0,GetRandomReal(-1000,2000),GetRandomReal(-1000,2000),GetRandomReal(2000,3000),GetRandomReal(10,30),function(){
			// 	BJDebugMsg("飞天咯!");
			// });
			x = GetRandomReal(-1000,2000);
			y = GetRandomReal(-1000,2000);
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",x,y,0,x,y,GetRandomReal(2000,3000),GetRandomReal(30,100),function(){
				BJDebugMsg("飞天咯!");
			});
			EXEffectMatRotateY(ms.e,270);
			// EXEffectMatRotateY(ms.e,90);
		}
	}
	function TTestUTEffectUtils4 (player p) { //測試一下向下飞的直线弹幕
		missile ms;
		integer i;
		real x;
		real y;
		for (1 <= i <= 10) {
			// ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",GetRandomReal(-1000,2000),GetRandomReal(-1000,2000),GetRandomReal(2000,3000),0,0,0,GetRandomReal(10,30),function(){
			// 	BJDebugMsg("落地咯!");
			// });
			x = GetRandomReal(-1000,2000);
			y = GetRandomReal(-1000,2000);
			ms = missile.reg("units\\human\\phoenix\\phoenix.mdl",x,y,GetRandomReal(2000,3000),x,y,0,GetRandomReal(30,100),function(){
				BJDebugMsg("落地咯!");
			});
			EXEffectMatRotateY(ms.e,90);
		}
	}
	effect ef = null;
	function TTestUTEffectUtils5 (player p) { //研究一下特效X轴旋转
		timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateX(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils6 (player p) { //研究一下特效Y轴旋转
		timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateY(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils7 (player p) { //研究一下特效Z轴旋转:就是普通的
		timer t;
		if (ef == null) {
			ef = AddSpecialEffect("units\\human\\phoenix\\phoenix.mdl", 0,0 );
			EXSetEffectZ(ef,100);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.02,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 360) {
				EXEffectMatRotateZ(ef,1.0);
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	unit    u1   = null;
	unit    u2   = null;
	trigger trSY = null;
	function TTestUTEffectUtils8 (player p) { //贝塞尔
		timer t;
		if (trSY == null) {
			trSY = CreateTrigger();
			TriggerAddCondition(trSY, Condition(function () {
				if (GetIssuedOrderId() == String2OrderIdBJ("smart")) {
					DzSetUnitPosition(GetTriggerUnit(),GetOrderPointX(),GetOrderPointY());
				}
			}));
		}
		if (u1 == null) {
			u1 = CreateUnit(p,'Hpal',0,0,0);
			TriggerRegisterUnitEvent(trSY,u1,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		if (u2 == null) {
			u2 = CreateUnit(p,'Ewar',1000,1000,0);
			TriggerRegisterUnitEvent(trSY,u2,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.1,true,function (){
			timer t2;
			timer   t      = GetExpiredTimer();
			integer id     = GetHandleId(t);
			integer i      = LoadInteger(TITable,id,1);
			real    angle  = GetFacing(GetUnitX(u1),GetUnitY(u1),GetUnitX(u2),GetUnitY(u2));
			real    ux     = GetUnitX(u1) - 60 * CosBJ(angle);
			real    uy     = GetUnitY(u1) - 60 * SinBJ(angle);
			real    uz     = GetUnitFlyHeight(u1) + 80;
			real    x1     = GetUnitX(u1) - 1 * CosBJ(angle);
			real    y1     = GetUnitY(u1) - 1 * SinBJ(angle);
			real    angle2 = GetFacing(GetUnitX(u1),GetUnitY(u1),x1,y1);
			integer random = GetRandomInt(1,10);
			real    ex     = CosBJ(90-(18*random+angle2)) * 1000 + x1;
			real    ey     = SinBJ(90-(18*random+angle2)) * 1000 + y1;
			real    ez     = 600;
			effect  e      = AddSpecialEffect("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", ux,uy );
			EXSetEffectZ(e,uz);
			if (i <= 100) {
				t2 = CreateTimer();
				SaveReal(TITable,GetHandleId(t2),1,0.0);
				SaveReal(TITable,GetHandleId(t2),2,ux);
				SaveReal(TITable,GetHandleId(t2),3,uy);
				SaveReal(TITable,GetHandleId(t2),4,uz);
				SaveReal(TITable,GetHandleId(t2),5,ex);
				SaveReal(TITable,GetHandleId(t2),6,ey);
				SaveReal(TITable,GetHandleId(t2),7,ez);
				SaveEffectHandle(TITable,GetHandleId(t2),8,e);
				TimerStart(t2,0.03,true,function (){
					timer   t2 = GetExpiredTimer();
					integer id = GetHandleId(t2);
					real    cd = LoadReal(TITable,id,1);
					real    ux = LoadReal(TITable,id,2);
					real    uy = LoadReal(TITable,id,3);
					real    uz = LoadReal(TITable,id,4);
					real    ex = LoadReal(TITable,id,5);
					real    ey = LoadReal(TITable,id,6);
					real    ez = LoadReal(TITable,id,7);
					effect  e  = LoadEffectHandle(TITable,id,8);
					real nx,ny,nz; //当前单位的位置
					real tx,ty,tz; //
					real txi,tyi; //下一步的位置,求出角度
					if (cd <= 0.98) {
						nx  = GetUnitX(u2);
						ny  = GetUnitY(u2);
						nz  = GetUnitFlyHeight(u2) + 50;
						cd += 0.02;
						tx  = Pow((1-cd),2)*ux + 2 *cd * (1-cd)*ex  + Pow(cd,2)*nx;
						ty  = Pow((1-cd),2)*uy + 2 *cd * (1-cd)*ey  + Pow(cd,2)*ny;
						tz  = Pow((1-cd),2)*uz + 2 *cd * (1-cd)*ez  + Pow(cd,2)*nz;
						EXSetEffectZ(e,tz);
						EXSetEffectXY(e,tx,ty);
						EXEffectMatReset(e);
						txi = Pow((1-(cd+0.02)),2)*ux + 2 *(cd+0.02) * (1-(cd+0.02))*ex  + Pow((cd+0.02),2)*nx;
						tyi = Pow((1-(cd+0.02)),2)*uy + 2 *(cd+0.02) * (1-(cd+0.02))*ey  + Pow((cd+0.02),2)*ny;
						EXEffectMatRotateZ(e,GetFacing(tx,ty,txi,tyi));
						SaveReal(TITable,id,1,cd);
					} else {
						DestroyEffect(e);
						PauseTimer(t2);
						FlushChildHashtable(TITable,id);
						DestroyTimer(t2);
					}
					t2 = null;
					e  = null;
				});
				t2 = null;

				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				DestroyEffect(e);
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
			e = null;
		});
		t = null;

	}
	function TTestUTEffectUtils9 (player p) { //测试一下umissile
		timer t;
		if (trSY == null) {
			trSY = CreateTrigger();
			TriggerAddCondition(trSY, Condition(function () {
				if (GetIssuedOrderId() == String2OrderIdBJ("smart")) {
					DzSetUnitPosition(GetTriggerUnit(),GetOrderPointX(),GetOrderPointY());
				}
			}));
		}
		if (u1 == null) {
			u1 = CreateUnit(p,'Hpal',0,0,0);
			TriggerRegisterUnitEvent(trSY,u1,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		if (u2 == null) {
			u2 = CreateUnit(p,'Ewar',1000,1000,0);
			TriggerRegisterUnitEvent(trSY,u2,EVENT_UNIT_ISSUED_POINT_ORDER);
		}
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.1,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			if (i <= 100) {
				umissile.reg("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl",GetUnitX(u1),GetUnitY(u1),GetUnitFlyHeight(u1),u2,function(){
					BJDebugMsg("击中了哦.");
				});
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	integer fra[];
	function TTestUTEffectUtils10 (player p) { //测试一下穿刺
		pierce pe;
		integer i;
		integer index = GetConvertedPlayerId(p);
		ForGroup(GetUnitsInRectAll(GetPlayableMapRect()),function () {
			if (GetUnitTypeId(GetEnumUnit()) == 'nmam') {
				RemoveUnit(GetEnumUnit());
			}
		});
		// for (1 <= i <= 10) {
		pe = pierce.reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl",GetRandomReal(-2000,-1000),GetRandomReal(-2000,-1000),GetRandomReal(1000,2000),GetRandomReal(1000,2000),100,450,function(){ //帧事件与单位
			pierce pe = pierce.ethis;
			if (CountUnitsInGroup(efut.g) > 0) {
				ForGroup(efut.g,function () {
					pierce pe = pierce.ethis;
					integer index = 1;
					if (IsEnemy2(Player(0),GetEnumUnit())) {
						BJDebugMsg(pd[index].name +"的敌人:"+GetUnitName(GetEnumUnit()));
						KillUnit(GetEnumUnit());
					} else if (IsAlly(Player(0),GetEnumUnit())) {
						BJDebugMsg(pd[index].name +"的队友:"+GetUnitName(GetEnumUnit()));
						SetUnitState(GetEnumUnit(),UNIT_STATE_LIFE,100);
					} else {
						BJDebugMsg("已经死亡的:"+GetUnitName(GetEnumUnit()));
					}
				});
			}
			fra[pe] = ModuloInteger(fra[pe],3)+1;
			if (ModuloInteger(fra[pe],3) == 0) {
				DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", pe.x,pe.y ));
			}
		},
		function(){ //结束事件
			pierce pe = pierce.ethis;
			BJDebugMsg("结束啦!!");
		});
		// pe.h = MH[index];
		fra[pe]= 0;
		EXEffectMatScale(pe.e,3.0,3.0,3.0);
		EXSetEffectZ(pe.e,200);
		// }

		for (1 <= i <= 20) { //创建几个单位
			CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE),'nmam',GetRandomReal(-200,200),GetRandomReal(-200,200),0);
			CreateUnit(Player(0),'nmam',GetRandomReal(-200,200),GetRandomReal(-200,200),0);
		}
	}

	real xLi = 0.;
	real yLi = 0.;
	function TTestUTEffectUtils11 (player p) { //测试一下边界点
		timer t;
		t = CreateTimer();
		SaveInteger(TITable,GetHandleId(t),1,1);
		TimerStart(t,0.05,true,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer i = LoadInteger(TITable,id,1);
			pierce pe;
			if (i <= 720) {
				//每个角度各来一发
				limitXY.cal(xLi,yLi,i*0.5);
				pe = pierce.reg("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl",xLi,
				yLi,YDWECoordinateX(limitXY.x),YDWECoordinateY(limitXY.y),100,450,function(){ //帧事件与单位
					pierce pe = pierce.ethis;
					if (CountUnitsInGroup(efut.g) > 0) {
						ForGroup(efut.g,function () {
							pierce pe = pierce.ethis;
							BJDebugMsg("单位名字:"+GetUnitName(GetEnumUnit()));
						});
					}
				},
				function(){ //结束事件
					pierce pe = pierce.ethis;
					BJDebugMsg("光波("+I2S(pe)+")结束啦:"+R2S(pe.x)+","+R2S(pe.y));
				});
				i += 1;
				SaveInteger(TITable,id,1,i);
			} else {
				PauseTimer(t);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}
	function TTestUTEffectUtils12 (player p) {

	}
	function TTestUTEffectUtils13 (player p) {

	}
	function TTestUTEffectUtils14 (player p) {

	}
	function TTestUTEffectUtils15 (player p) {

	}
	function TTestUTEffectUtils16 (player p) {

	}
	function TTestUTEffectUtils17 (player p) {

	}
	function TTestUTEffectUtils18 (player p) {

	}
	function TTestUTEffectUtils19 (player p) {

	}
	function TTestUTEffectUtils20 (player p) {

	}

	function TTestActUTEffectUtils1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		for (0 <= i <= len - 1) {
			if (SubString(str,i,i+1) == " ") {
				paramS[num]= SubString(str,0,i);
				paramI[num]= S2I(paramS[num]);
				paramR[num]= S2R(paramS[num]);
				num = num + 1;
				str = SubString(str,i + 1,len);
				len = StringLength(str);
				i = -1;
			}
		}
		paramS[num]= str;
		paramI[num]= S2I(paramS[num]);
		paramR[num]= S2R(paramS[num]);
		num = num + 1;

		if (paramS[0] == "x") { //测试一下混合的特效
			EXEffectMatRotateX(ef,paramR[1]);
		} else if (paramS[0] == "y") {
			EXEffectMatRotateY(ef,paramR[1]);
		} else if (paramS[0] == "z") {
			EXEffectMatRotateZ(ef,paramR[1]);
		} else if (paramS[0] == "height") { //高度
			EXSetEffectZ(ef,paramR[1]);
		} else if (paramS[0] == "reset") { //恢复
			EXEffectMatReset(ef);
			EXEffectMatScale(ef,2.0,2.0,2.0);
		} else if (paramS[0] == "xl") { //设置一下s11的初始位置
			xLi = paramR[1];
			BJDebugMsg("xLi"+":"+R2S(xLi));
		} else if (paramS[0] == "yl") { //设置一下s11的初始位置
			yLi = paramR[1];
			BJDebugMsg("yLi"+":"+R2S(yLi));
		}

		p = null;
	}
	//blpend
	//blpend
	//blpend
	#endif

	function onInit () {

		integer i;
		for (1 <= i <= 16) {
			CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() );
		}

		#ifdef TestMode
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTEffectUtils1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTEffectUtils1(GetTriggerPlayer());
			else if(str == "s2") TTestUTEffectUtils2(GetTriggerPlayer());
			else if(str == "s3") TTestUTEffectUtils3(GetTriggerPlayer());
			else if(str == "s4") TTestUTEffectUtils4(GetTriggerPlayer());
			else if(str == "s5") TTestUTEffectUtils5(GetTriggerPlayer());
			else if(str == "s6") TTestUTEffectUtils6(GetTriggerPlayer());
			else if(str == "s7") TTestUTEffectUtils7(GetTriggerPlayer());
			else if(str == "s8") TTestUTEffectUtils8(GetTriggerPlayer());
			else if(str == "s9") TTestUTEffectUtils9(GetTriggerPlayer());
			else if(str == "s10") TTestUTEffectUtils10(GetTriggerPlayer());
			else if(str == "s11") TTestUTEffectUtils11(GetTriggerPlayer());
			else if(str == "s12") TTestUTEffectUtils12(GetTriggerPlayer());
			else if(str == "s13") TTestUTEffectUtils13(GetTriggerPlayer());
			else if(str == "s14") TTestUTEffectUtils14(GetTriggerPlayer());
			else if(str == "s15") TTestUTEffectUtils15(GetTriggerPlayer());
			else if(str == "s16") TTestUTEffectUtils16(GetTriggerPlayer());
			else if(str == "s17") TTestUTEffectUtils17(GetTriggerPlayer());
			else if(str == "s18") TTestUTEffectUtils18(GetTriggerPlayer());
			else if(str == "s19") TTestUTEffectUtils19(GetTriggerPlayer());
			else if(str == "s20") TTestUTEffectUtils20(GetTriggerPlayer());

		}));
		#endif
	}

}
//! endzinc

#endif
