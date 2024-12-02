#ifndef ConsoleUIIncluded
#define ConsoleUIIncluded


#include "edit/UI/Base/OriginUI.j"
#include "edit/Base/UIBase.j"
#include "edit/Data/HeroStruct.j"

#include "edit/UI/DetailUI.j"
#include "edit/Hero/Modules/Attr.j" //[英雄模块]属性
// #include "edit/UI/UnitLifeUI.j" //这个可直接注释就关闭那个功能


//宏定义
//3W进入边界判定
#define START_ICON_3W_X           0.406
#define START_ICON_3W_Y           0.07
#define SIZE_ICON_3W_X            0.035
#define SIZE_ICON_3W_Y            0.035
//怪物技能进入边界判定
#define START_ICON_GUAI_SPELL_X   0.406
#define START_ICON_GUAI_SPELL_Y   0.085
#define SIZE_ICON_GUAI_SPELL_X    0.035
#define SIZE_ICON_GUAI_SPELL_Y    0.035
//原生UI的索引
#define INDEX_ORIGIN_UI_ITEM_1    1
#define INDEX_ORIGIN_UI_ITEM_2    2
#define INDEX_ORIGIN_UI_ITEM_3    3
#define INDEX_ORIGIN_UI_ITEM_4    4
#define INDEX_ORIGIN_UI_ITEM_5    5
#define INDEX_ORIGIN_UI_ITEM_6    6
#define INDEX_ORIGIN_UI_SPELL_0_0 7
#define INDEX_ORIGIN_UI_SPELL_0_1 8
#define INDEX_ORIGIN_UI_SPELL_0_2 9
#define INDEX_ORIGIN_UI_SPELL_0_3 10
#define INDEX_ORIGIN_UI_SPELL_1_0 11
#define INDEX_ORIGIN_UI_SPELL_1_1 12
#define INDEX_ORIGIN_UI_SPELL_1_2 13
#define INDEX_ORIGIN_UI_SPELL_1_3 14
#define INDEX_ORIGIN_UI_SPELL_2_0 15
#define INDEX_ORIGIN_UI_SPELL_2_1 16
#define INDEX_ORIGIN_UI_SPELL_2_2 17
#define INDEX_ORIGIN_UI_SPELL_2_3 18

//! zinc

/*
界面UI
//todo:做一下装备栏的文字及简单的逻辑
*/
library ConsoleUI requires UIBase,DetailUI,OriginUI,optional UnitLifeUI {

	public struct consoleF [] { //全是异步数据
		static integer itemPos = 0;
		static integer spellX = 0;
		static integer spellY = 0;
		static unit uS = null;
	}

	public integer UIOrigin[];	//原生UI
	integer UILogo		= 0;	//[UI]LOGO
	trigger trItems		= null;	//[接口组]物品图标进入
	trigger trSpells	= null;	//[接口组]技能图标进入
	trigger trSelect	= null;	//[接口组]单位选择事件(异步)
	trigger trUnselect	= null;	//[接口组]单位取消选择事件(异步)

	//注册物品图标进入事件
	public function RegItemUIEvent (code func) {
		if (trItems == null) {
			trItems = CreateTrigger();
		}
		TriggerAddCondition(trItems, Condition(func));
	}
	//注册技能图标进入事件
	public function RegSpellUIEvent (code func) {
		if (trSpells == null) {
			trSpells = CreateTrigger();
		}
		TriggerAddCondition(trSpells, Condition(func));
	}
	//注册单位选择事件(异步)
	public function RegSelectAynsc (code func) {
		if (trSelect == null) {
			trSelect = CreateTrigger();
		}
		TriggerAddCondition(trSelect, Condition(func));
	}
	//注册单位取消选择事件(异步)
	public function RegUnselectAynsc (code func) {
		if (trUnselect == null) {
			trUnselect = CreateTrigger();
		}
		TriggerAddCondition(trUnselect, Condition(func));
	}
	//鼠标进入物品总事件线
	public function OnUIItemEnter(integer pos) {
		consoleF.itemPos = pos;
		TriggerEvaluate(trItems);
	}
	//鼠标离开物品总事件线
	public function OnUIItemLeave() {
		consoleF.itemPos = 0;
		detailF.leave();
	}
	//鼠标进入技能总事件线
	public function OnUISpellEnter (integer row,integer column) {
		consoleF.spellX = row;
		consoleF.spellY = column;
		TriggerEvaluate(trSpells);
	}
	//鼠标离开技能总事件线
	public function OnUISpellLeave () {
		consoleF.spellX = 0;
		consoleF.spellY = 0;
		detailF.leave();
	}

	// 鼠标进入英雄的3W图标事件
	boolean BEnter3W = false;
	function OnHero3WEnter (integer index) {
		string title1   = "|cff00ccff力量:|r" + I2S(GetHeroStr(H[index],true)) + S3(MH[index].strPc> 0,"|cff00ff00(+" + I2S(R2I(MH[index].strPc * 100))+ "%)|r",null);
		string title2   = "|cff00ccff敏捷:|r" + I2S(GetHeroAgi(H[index],true)) + S3(MH[index].agiPc> 0,"|cff00ff00(+" + I2S(R2I(MH[index].agiPc * 100))+ "%)|r",null);
		string title3   = "|cff00ccff智力:|r" + I2S(GetHeroInt(H[index],true)) + S3(MH[index].intPc> 0,"|cff00ff00(+" + I2S(R2I(MH[index].intPc * 100))+ "%)|r",null);
		string content1 = \
		"每点力量增加|cffff99cc[" + R2SW(MH[index].strAtk,0,1) + "点]|r攻击力|r\n\
		根据力量增加|cffff99cc[" + I2S(R2I(MH[index].strAtkRate * 100))+ "%]|r普攻伤害增幅";
		string content2 = \
		"根据敏捷增加|cffff99cc[" + I2S(MH[index].agiPak)+ "个]|r物品栏容量|r\n\
		下一个需要敏捷达到|cffff99cc["+FormatNumber(GetAgiNextPackAgi(GetHeroAgi(H[index],true),I3(MH[index].isAgiHero(),MH[index].mainPower,0)))+"]|r来解锁";
		string content3 = \
		"每点智力增加|cffff99cc[" + R2SW(MH[index].intSP,0,1)+ "点]|r法强|r\n\
		根据智力增加|cffff99cc[" + I2S(R2I(MH[index].intSPRate * 100))+ "%]|r技能伤害增幅";
		string mContent = "|cffffff00 - 主属性(以下数值已提高" + I2S(MH[index].mainPower)+ "%)|r\n";
		//根据类型来设置
		if (MH[index].isStrHero()) {content1 = mContent + content1;}
		else if (MH[index].isAgiHero()) {content2 = mContent + content2;}
		else {content3 = mContent + content3;}
		DetailUICreate3x2(0.18,title1,content1,title2,content2,title3,content3);
		DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,0,0);
		title1 = null;title2 = null;title3 = null;content1 = null;content2 = null;content3 = null;mContent = null;
	}
	function OnHero3WLeave () {
		DetailUIDestroy();
		DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,.8,.1625);
	}
	function IsInHero3WUI() -> boolean {
		real x = GetMouseXEx();
		real y = GetMouseYEx();
		return x >= START_ICON_3W_X && x <= (START_ICON_3W_X + SIZE_ICON_3W_X) && y >= (START_ICON_3W_Y - SIZE_ICON_3W_X) && y <= START_ICON_3W_Y;
	}

	// 鼠标进入怪物技能的图标事件//todo:利用guai结构体重写
	boolean isEnterGSpell = false;
	function OnGuaiSpellEnter () {
		integer index = GetConvertedPlayerId(GetLocalPlayer());
		integer i;
		string sKeji  = EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(USelected[index])) + "].abilList");
		integer max   = (StringLength(sKeji) + 1 )/ 5;
		string skill;
		string abi;
		integer iAbi;
		if (max <= 0) {skill = "|cff999999该怪物没有技能。|r";}else {skill = "";} //技能预处理
		for (1 <= i <= max) {
			abi = SubStringBJ(sKeji,i * 5 - 4,i * 5 - 1);
			iAbi = YDWES2Id(abi);
			skill = skill + "|cffff9900技能" + I2S(i)+ "[" + GetAbilityName(iAbi)+ "]:|r\n";
			skill = skill + EXExecuteScript("(require'jass.slk').ability[" + I2S(iAbi) + "].Ubertip") + "\n"; //这里要不要加成Ubertip1要看是否是复制出来的
		}
		//todo:等级染色
		DetailUICreateGuai(0.2,\
		EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(USelected[index])) + "].Art"),\
		GetUnitName(USelected[index])+ " - |cffff9900[等级 " + I2S(GetUnitLevel(USelected[index]))+ "]|r",\
		"|cffffff0010金|r/|cff00ccff200经验|r","|cff00ff00你的英雄比该怪物高10级\n\n对其伤害+10000% | 受其伤害-99%|r",\
		skill);
		DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,0,0);
		sKeji = null;
		skill = null;
		abi = null;
	}
	function OnGuaiSpellLeave () {
		DetailUIDestroy();
		DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,.8,.1625);
	}
	function IsInGuaiSpellUI () -> boolean{
		real x = GetMouseXEx();
		real y = GetMouseYEx();
		return x >= START_ICON_GUAI_SPELL_X && x <= (START_ICON_GUAI_SPELL_X + SIZE_ICON_GUAI_SPELL_X) && y >= (START_ICON_GUAI_SPELL_Y - SIZE_ICON_GUAI_SPELL_X) && y <= START_ICON_GUAI_SPELL_Y;
	}

	function onInit ()  {
		integer i = 0;

		//隐藏各种小地图按钮
		for (0 <= i <= 4) {
			DzFrameClearAllPoints(DzFrameGetMinimapButton(i));
			DzFrameShow(DzFrameGetMinimapButton(i),false);
		}
		//小地图缩小
		DzFrameClearAllPoints(DzFrameGetMinimap());
		DzFrameSetPoint(DzFrameGetMinimap(), ANCHOR_BOTTOMLEFT, DzGetGameUI(), ANCHOR_BOTTOMLEFT, 0.0088, 0.004);
		DzFrameSetSize(DzFrameGetMinimap(), 0.109, 0.109);
		//物品介绍下移
		DzFrameClearAllPoints(DzFrameGetTooltip());
		DzFrameSetPoint(DzFrameGetTooltip(), ANCHOR_BOTTOM, DzGetGameUI(), ANCHOR_RIGHT, - 0.11, - 0.175);
		//创建一下平台LOGO
		UILogo = CreateBackDrop(DzGetGameUI());
		DzFrameSetTexture(UILogo,"ui\\image\\playform_logo.blp",0);
		DzFrameSetSize(UILogo, 0.08 * 4 / 3 * GetResizeRate(), 0.04);
		DzFrameSetPoint(UILogo, ANCHOR_CENTER, DzFrameGetMinimap(), ANCHOR_TOP, 0, 0.01);
		hardware.regResizeEvent(function (){
			DzFrameSetSize(UILogo,0.08 * 4 / 3 * GetResizeRate(), 0.04);
		});
		//黑边下移
		DzFrameEditBlackBorders(0.023,0.12);

		hardware.regUpdateEvent(function (){ //注册鼠标进入3W的事件
			integer index;
			unit u;
			if (IsInHero3WUI()) {
				if (!(BEnter3W)) { //进入事件[todo:可以加个幻影判断]
					u = GetRealSelectUnit();
					index = GetConvertedPlayerId(GetOwningPlayer(u));
					if (u == H[index]) {
						OnHero3WEnter(index);
						BEnter3W = true;
					}
					u = null;
				}
			} else if (BEnter3W) { // 离开事件
				OnHero3WLeave();
				BEnter3W = false;
			}
			if (IsInGuaiSpellUI()) { //注册鼠标进入怪物技能的事件
				if (IsUnitRace(USelected[GetConvertedPlayerId(GetLocalPlayer())], ConvertRace(8)) && !( isEnterGSpell)) { //进入事件[只看敌方怪物]
					OnGuaiSpellEnter();
					isEnterGSpell = true;
				}
			} else if (isEnterGSpell) { // 离开事件
				OnGuaiSpellLeave();
				isEnterGSpell = false;
			}

		});
		hardware.regUpdateEvent(function (){ //注册2个事件:选择单位,与不选择事件
			if (GetRealSelectUnit() != consoleF.uS) {
				TriggerEvaluate(trUnselect); //事件里用consoleF.uS来指代
				TriggerEvaluate(trSelect); //事件里用consoleF.uS来指代
				consoleF.uS = GetRealSelectUnit();
			}
		});

		//储存原始UI方便调用
		for (1 <= i <= 6) {UIOrigin[i]= DzFrameGetItemBarButton(i - 1);}
		UIOrigin[INDEX_ORIGIN_UI_SPELL_0_0] = DzFrameGetCommandBarButton(0,0);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_0_1] = DzFrameGetCommandBarButton(0,1);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_0_2] = DzFrameGetCommandBarButton(0,2);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_0_3] = DzFrameGetCommandBarButton(0,3);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_1_0] = DzFrameGetCommandBarButton(1,0);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_1_1] = DzFrameGetCommandBarButton(1,1);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_1_2] = DzFrameGetCommandBarButton(1,2);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_1_3] = DzFrameGetCommandBarButton(1,3);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_2_0] = DzFrameGetCommandBarButton(2,0);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_2_1] = DzFrameGetCommandBarButton(2,1);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_2_2] = DzFrameGetCommandBarButton(2,2);
		UIOrigin[INDEX_ORIGIN_UI_SPELL_2_3] = DzFrameGetCommandBarButton(2,3);

		//6+12个图标的事件
		DzFrameSetScriptByCode(UIOrigin[1],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(1);},false);
		DzFrameSetScriptByCode(UIOrigin[1],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);
		DzFrameSetScriptByCode(UIOrigin[2],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(2);},false);
		DzFrameSetScriptByCode(UIOrigin[2],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);
		DzFrameSetScriptByCode(UIOrigin[3],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(3);},false);
		DzFrameSetScriptByCode(UIOrigin[3],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);
		DzFrameSetScriptByCode(UIOrigin[4],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(4);},false);
		DzFrameSetScriptByCode(UIOrigin[4],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);
		DzFrameSetScriptByCode(UIOrigin[5],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(5);},false);
		DzFrameSetScriptByCode(UIOrigin[5],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);
		DzFrameSetScriptByCode(UIOrigin[6],FRAME_MOUSE_ENTER,function () {OnUIItemEnter(6);},false);
		DzFrameSetScriptByCode(UIOrigin[6],FRAME_MOUSE_LEAVE,function OnUIItemLeave, false);

		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_0],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(0,0);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_1],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(0,1);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_2],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(0,2);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_3],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(0,3);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_0],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(1,0);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_1],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(1,1);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_2],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(1,2);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_3],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(1,3);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_0],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(2,0);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_1],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(2,1);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_2],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(2,2);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_3],FRAME_MOUSE_ENTER,function () {OnUISpellEnter(2,3);},false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_0],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_1],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_2],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_0_3],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_0],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_1],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_2],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_1_3],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_0],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_1],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_2],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);
		DzFrameSetScriptByCode(UIOrigin[INDEX_ORIGIN_UI_SPELL_2_3],FRAME_MOUSE_LEAVE,function OnUISpellLeave,false);

	}
}

//! endzinc

#endif