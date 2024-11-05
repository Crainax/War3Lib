#ifndef MTIncluded
#define MTIncluded

#include "Crainax/core/constant/Variable.j"

//! zinc

//模型测试
library MT requires optional Variable {

	group g = null;
	//单位模型
	function UnitModel (player p,string path) {
		unit u = CreateUnit(Player(0),'Hamg',GetRandomReal(0,300),GetRandomReal(0,300),GetRandomReal(0,360));
		DzSetUnitModel(u,path);
		// 这个是下面的变化,是异步的
		if (GetConvertedPlayerId(p) == GetConvertedPlayerId(GetLocalPlayer())) {
			DzSetUnitPortrait(u,path);
			SetCinematicScene('Hamg',GetPlayerColor(Player(0)),"","",.01,0);
			EndCinematicScene();
		}
		GroupAddUnit(g,u);
		u = null;
	}
	//普通一次性特效
	#define Efx(path) DestroyEffect(AddSpecialEffect(path,GetRandomReal(-300,300),GetRandomReal(-300,300)))
	//绑定特效,并在5秒后删除
	function EfxB (string bind,string path) {
		timer t = CreateTimer();
		unit u = CreateUnit(Player(0),'Hblm',GetRandomReal(0,300),GetRandomReal(0,300),GetRandomReal(0,360));
		SaveEffectHandle(TITable,GetHandleId(t),1,AddSpecialEffectTargetUnitBJ(bind,u,path));
		SaveUnitHandle(TITable,GetHandleId(t),2,u);
		TimerStart(t,5.0,false,function (){
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			effect e = LoadEffectHandle(TITable,id,1);
			unit u = LoadUnitHandle(TITable,id,2);
			timer t2 = CreateTimer();
			DestroyEffect(e);
			SaveUnitHandle(TITable,GetHandleId(t2),1,u);
			TimerStart(t2,3.0,false,function (){
				timer t2 = GetExpiredTimer();
				integer id = GetHandleId(t2);
				unit u = LoadUnitHandle(TITable,id,1);
				RemoveUnit(u);
				PauseTimer(t2);
				FlushChildHashtable(TITable,id);
				DestroyTimer(t2);
				t2 = null;
				u = null;
			});
			t2 = null;
			PauseTimer(t);
			FlushChildHashtable(TITable,id);
			DestroyTimer(t);
			t = null;
			e = null;
			u = null;
		});
		t = null;
	}
	//测试弹幕
	function Danmu (string path) {
		timer  t     = CreateTimer();
		real   cx    = 0,                         cy = 0;
		real   dx    = GetRandomReal(-1200,1200), dy = GetRandomReal(-1200,1200);
		real   cz    = 0,                         dz = GetRandomReal(300,600);
		real   speed = 25.0;
		effect e     = AddSpecialEffect(path, cx,cy);
		// EXEffectMatScale(e,2.0,2.0,2.0);
		EXEffectMatRotateZ(e,GetFacing(cx,cy,dx,dy));
		SaveEffectHandle(TITable,GetHandleId(t),1,e);
		SaveReal(TITable,GetHandleId(t),2,cx);
		SaveReal(TITable,GetHandleId(t),3,cy);
		SaveReal(TITable,GetHandleId(t),4,dx);
		SaveReal(TITable,GetHandleId(t),5,dy);
		SaveReal(TITable,GetHandleId(t),6,cz);
		SaveReal(TITable,GetHandleId(t),7,dz);
		SaveReal(TITable,GetHandleId(t),8,speed*(RAbsBJ(dz-cz))/GetDistance(cx,cy,dx,dy));
		SaveReal(TITable,GetHandleId(t),9,speed); //帧速度,乘间隔就是秒速
		TimerStart(t,0.02,true,function (){
			timer   t     = GetExpiredTimer();
			integer id    = GetHandleId(t);
			effect  e     = LoadEffectHandle(TITable,id,1);
			real    cx    = LoadReal(TITable,id,2), cy = LoadReal(TITable,id,3);
			real    dx    = LoadReal(TITable,id,4), dy = LoadReal(TITable,id,5);
			real    cz    = LoadReal(TITable,id,6), dz = LoadReal(TITable,id,7);
			real    speed = LoadReal(TITable,id,9), zSpeed = LoadReal(TITable,id,8);
			real    angle = GetFacing(cx,cy,dx,dy);
			real    ncx   = YDWECoordinateX(cx + speed *CosBJ(angle)), ncy = YDWECoordinateY(cy + speed * SinBJ(angle)), ncz = zSpeed + cz;
			if (GetDistance(cx,cy,dx,dy) > speed) {
				//还行
				SaveReal(TITable,GetHandleId(t),2,ncx);
				SaveReal(TITable,GetHandleId(t),3,ncy);
				SaveReal(TITable,GetHandleId(t),6,ncz);
				EXSetEffectXY(e,ncx,ncy);
				EXSetEffectZ(e,ncz);
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
		e = null;
	}

	//UnitModel(p,"hero_singer.mdl");
	//Efx("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl");
	//EfxB("chest","Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorTarget.mdl");
	//Danmu("Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl");
	function TTestMT1 (player p) {
		UnitModel(p,"qiuti_antusheng.mdl");
		Efx("qiuti_antusheng.mdl");
		EfxB("chest","qiuti_antusheng.mdl");
		Danmu("qiuti_antusheng.mdl");
	}
	function TTestMT2 (player p) {
		UnitModel(p,"e_summon (7).mdl");
		Efx("e_summon (7).mdl");
		EfxB("chest","e_summon (7).mdl");
		Danmu("e_summon (7).mdl");
	}
	function TTestMT3 (player p) {
		UnitModel(p,"e_summon (6).mdl");
		Efx("e_summon (6).mdl");
		EfxB("chest","e_summon (6).mdl");
		Danmu("e_summon (6).mdl");
	}
	function TTestMT4 (player p) {
		UnitModel(p,"e_summon (5).mdl");
		Efx("e_summon (5).mdl");
		EfxB("chest","e_summon (5).mdl");
		Danmu("e_summon (5).mdl");
	}
	function TTestMT5 (player p) {
		UnitModel(p,"e_summon (4).mdl");
		Efx("e_summon (4).mdl");
		EfxB("chest","e_summon (4).mdl");
		Danmu("e_summon (4).mdl");
	}
	function TTestMT6 (player p) {
		UnitModel(p,"e_summon (3).mdl");
		Efx("e_summon (3).mdl");
		EfxB("chest","e_summon (3).mdl");
		Danmu("e_summon (3).mdl");
	}
	function TTestMT7 (player p) {
		UnitModel(p,"e_summon (2).mdl");
		Efx("e_summon (2).mdl");
		EfxB("chest","e_summon (2).mdl");
		Danmu("e_summon (2).mdl");
	}
	function TTestMT8 (player p) {
		UnitModel(p,"e_summon (1).mdl");
		Efx("e_summon (1).mdl");
		EfxB("chest","e_summon (1).mdl");
		Danmu("e_summon (1).mdl");
	}
	function TTestMT9 (player p) {
		UnitModel(p,"e_pet_blink.mdl");
		Efx("e_pet_blink.mdl");
		EfxB("chest","e_pet_blink.mdl");
		Danmu("e_pet_blink.mdl");
	}
	function TTestMT10 (player p) {
		UnitModel(p,"effect_roar_langhun.mdl");
		Efx("effect_roar_langhun.mdl");
		EfxB("chest","effect_roar_langhun.mdl");
		Danmu("effect_roar_langhun.mdl");
	}
	function TTestMT11 (player p) {
		UnitModel(p,"effect_langhun_f_target.mdl");
		Efx("effect_langhun_f_target.mdl");
		EfxB("chest","effect_langhun_f_target.mdl");
		Danmu("effect_langhun_f_target.mdl");
	}
	function TTestMT12 (player p) {
		UnitModel(p,"effect_knight_w_blast.mdl");
		Efx("effect_knight_w_blast.mdl");
		EfxB("chest","effect_knight_w_blast.mdl");
		Danmu("effect_knight_w_blast.mdl");
	}
	function TTestMT13 (player p) {
		UnitModel(p,"effect_knight_w_1.mdl");
		Efx("effect_knight_w_1.mdl");
		EfxB("chest","effect_knight_w_1.mdl");
		Danmu("effect_knight_w_1.mdl");
	}
	function TTestMT14 (player p) {
		UnitModel(p,"effect_knight_r.mdl");
		Efx("effect_knight_r.mdl");
		EfxB("chest","effect_knight_r.mdl");
		Danmu("effect_knight_r.mdl");
	}
	function TTestMT15 (player p) {
		UnitModel(p,"effect_knight_q_1.mdl");
		Efx("effect_knight_q_1.mdl");
		EfxB("chest","effect_knight_q_1.mdl");
		Danmu("effect_knight_q_1.mdl");
	}
	function TTestMT16 (player p) {
		UnitModel(p,"effect_knight_f.mdl");
		Efx("effect_knight_f.mdl");
		EfxB("chest","effect_knight_f.mdl");
		Danmu("effect_knight_f.mdl");
	}
	function TTestMT17 (player p) {
		// UnitModel(p,"effect_knight_e_impact.mdl");
		// Efx("effect_knight_e_impact.mdl");
		EfxB("chest","effect_knight_e_impact.mdl");
		// Danmu("effect_knight_e_impact.mdl");
	}
	function TTestMT18 (player p) {
		// UnitModel(p,"effect_knight_e.mdl");
		Efx("effect_knight_e.mdl");
		// EfxB("chest","effect_knight_e.mdl");
		// Danmu("effect_knight_e.mdl");
	}
	function TTestMT19 (player p) {
		//replace
	}
	function TTestMT20 (player p) {
		//replace
	}
	function TTestMT21 (player p) {
		//replace
	}
	function TTestMT22 (player p) {
		//replace
	}
	function TTestMT23 (player p) {
		//replace
	}
	function TTestMT24 (player p) {
		//replace
	}
	function TTestMT25 (player p) {
		//replace
	}
	function TTestMT26 (player p) {
		//replace
	}
	function TTestMT27 (player p) {
		//replace
	}
	function TTestMT28 (player p) {
		//replace
	}
	function TTestMT29 (player p) {
		//replace
	}
	function TTestMT30 (player p) {
		//replace
	}
	function TTestMT31 (player p) {
		//replace
	}
	function TTestMT32 (player p) {
		//replace
	}
	function TTestMT33 (player p) {
		//replace
	}
	function TTestMT34 (player p) {
		//replace
	}
	function TTestMT35 (player p) {
		//replace
	}
	function TTestMT36 (player p) {
		//replace
	}
	function TTestMT37 (player p) {
		//replace
	}
	function TTestMT38 (player p) {
		//replace
	}
	function TTestMT39 (player p) {
		//replace
	}
	function TTestMT40 (player p) {
		//replace
	}
	function TTestMT41 (player p) {
		//replace
	}
	function TTestMT42 (player p) {
		//replace
	}
	function TTestMT43 (player p) {
		//replace
	}
	function TTestMT44 (player p) {
		//replace
	}
	function TTestMT45 (player p) {
		//replace
	}
	function TTestMT46 (player p) {
		//replace
	}
	function TTestMT47 (player p) {
		//replace
	}
	function TTestMT48 (player p) {
		//replace
	}
	function TTestMT49 (player p) {
		//replace
	}
	function TTestMT50 (player p) {
		//replace
	}

	function DeleteUnits () {
		ForGroup(g,function () {
			RemoveUnit(GetEnumUnit());
		});
	}

	function onInit () {
		integer i;
		for (1 <= i <= 12) {
			CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() );
			SetCameraFieldForPlayer( ConvertedPlayer(i), CAMERA_FIELD_ZOFFSET, ( GetCameraTargetPositionZ() + 800.00 ), 0 );
		}
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (str == "t") DeleteUnits();

			if (str == "s1") TTestMT1(GetTriggerPlayer());
			else if(str == "s2") TTestMT2(GetTriggerPlayer());
			else if(str == "s3") TTestMT3(GetTriggerPlayer());
			else if(str == "s4") TTestMT4(GetTriggerPlayer());
			else if(str == "s5") TTestMT5(GetTriggerPlayer());
			else if(str == "s6") TTestMT6(GetTriggerPlayer());
			else if(str == "s7") TTestMT7(GetTriggerPlayer());
			else if(str == "s8") TTestMT8(GetTriggerPlayer());
			else if(str == "s9") TTestMT9(GetTriggerPlayer());
			else if(str == "s10") TTestMT10(GetTriggerPlayer());
			else if(str == "s11") TTestMT11(GetTriggerPlayer());
			else if(str == "s12") TTestMT12(GetTriggerPlayer());
			else if(str == "s13") TTestMT13(GetTriggerPlayer());
			else if(str == "s14") TTestMT14(GetTriggerPlayer());
			else if(str == "s15") TTestMT15(GetTriggerPlayer());
			else if(str == "s16") TTestMT16(GetTriggerPlayer());
			else if(str == "s17") TTestMT17(GetTriggerPlayer());
			else if(str == "s18") TTestMT18(GetTriggerPlayer());
			else if(str == "s19") TTestMT19(GetTriggerPlayer());
			else if(str == "s20") TTestMT20(GetTriggerPlayer());
			else if(str == "s21") TTestMT21(GetTriggerPlayer());
			else if(str == "s22") TTestMT22(GetTriggerPlayer());
			else if(str == "s23") TTestMT23(GetTriggerPlayer());
			else if(str == "s24") TTestMT24(GetTriggerPlayer());
			else if(str == "s25") TTestMT25(GetTriggerPlayer());
			else if(str == "s26") TTestMT26(GetTriggerPlayer());
			else if(str == "s27") TTestMT27(GetTriggerPlayer());
			else if(str == "s28") TTestMT28(GetTriggerPlayer());
			else if(str == "s29") TTestMT29(GetTriggerPlayer());
			else if(str == "s30") TTestMT30(GetTriggerPlayer());
			else if(str == "s31") TTestMT31(GetTriggerPlayer());
			else if(str == "s32") TTestMT32(GetTriggerPlayer());
			else if(str == "s33") TTestMT33(GetTriggerPlayer());
			else if(str == "s34") TTestMT34(GetTriggerPlayer());
			else if(str == "s35") TTestMT35(GetTriggerPlayer());
			else if(str == "s36") TTestMT36(GetTriggerPlayer());
			else if(str == "s37") TTestMT37(GetTriggerPlayer());
			else if(str == "s38") TTestMT38(GetTriggerPlayer());
			else if(str == "s39") TTestMT39(GetTriggerPlayer());
			else if(str == "s40") TTestMT40(GetTriggerPlayer());
			else if(str == "s41") TTestMT41(GetTriggerPlayer());
			else if(str == "s42") TTestMT42(GetTriggerPlayer());
			else if(str == "s43") TTestMT43(GetTriggerPlayer());
			else if(str == "s44") TTestMT44(GetTriggerPlayer());
			else if(str == "s45") TTestMT45(GetTriggerPlayer());
			else if(str == "s46") TTestMT46(GetTriggerPlayer());
			else if(str == "s47") TTestMT47(GetTriggerPlayer());
			else if(str == "s48") TTestMT48(GetTriggerPlayer());
			else if(str == "s49") TTestMT49(GetTriggerPlayer());
			else if(str == "s50") TTestMT50(GetTriggerPlayer());

		});

		g = CreateGroup();
	}

}
//! endzinc

#endif
