#ifndef DetailUIIncluded
#define DetailUIIncluded

#include "edit/Data/GrowData.j"
#include "edit/Data/HeroData.j"
#include "edit/Data/SpellStruct.j"
#include "edit/Data/ItemStruct.j"
#include "edit/Item/Module/ItemDesc.j"

//! zinc
/*
描述UI
*/
library DetailUI requires herodatastruct,itemdatastruct,spellstruct {

	//销毁所有描述UI
	public function DetailUIDestroy () {
		integer i;
		if (detailF.multi) {return;} //创建多个

		//标准的
		if (Frame != 0) {
			DzDestroyFrame(Frame);
			Frame = 0;

			//如果有主视窗再删子元素
			if (Title1 != 0) {DzDestroyFrame(Title1);Title1 = 0;}
			if (Content1 != 0) {DzDestroyFrame(Content1);Content1 = 0;}
			if (Title2 != 0) {DzDestroyFrame(Title2);Title2 = 0;}
			if (Content2 != 0) {DzDestroyFrame(Content2);Content2 = 0;}
			if (Title3 != 0) {DzDestroyFrame(Title3);Title3 = 0;}
			if (Content3 != 0) {DzDestroyFrame(Content3);Content3 = 0;}
		}
		//怪物的Frame
		if (Guai != 0) {
			DzDestroyFrame(Guai);
			Guai = 0;
			//子元素
			if (GuaiWraper != 0) {DzDestroyFrame(GuaiWraper);GuaiWraper = 0;}
			if (GuaiWIcon != 0) {DzDestroyFrame(GuaiWIcon);GuaiWIcon = 0;}
			if (GuaiWName != 0) {DzDestroyFrame(GuaiWName);GuaiWName = 0;}
			if (GuaiWLevel != 0) {DzDestroyFrame(GuaiWLevel);GuaiWLevel = 0;}
			if (GuaiContent1 != 0) {DzDestroyFrame(GuaiContent1);GuaiContent1 = 0;}
			if (GuaiContent2 != 0) {DzDestroyFrame(GuaiContent2);GuaiContent2 = 0;}
			if (GuaiDivider1 != 0) {DzDestroyFrame(GuaiDivider1);GuaiDivider1 = 0;}
			if (GuaiDivider2 != 0) {DzDestroyFrame(GuaiDivider2);GuaiDivider2 = 0;}
		}
		//英雄的Frame
		if (Hero != 0) {
			DzDestroyFrame(Hero);
			Hero = 0;
			//子元素
			if (HeroTop != 0) {DzDestroyFrame(HeroTop);HeroTop = 0;}
			if (HeroBottom != 0) {DzDestroyFrame(HeroBottom);HeroBottom = 0;}
			if (HeroMiddle != 0) {DzDestroyFrame(HeroMiddle);HeroMiddle = 0;}
			if (HeroWraper != 0) {DzDestroyFrame(HeroWraper);HeroWraper = 0;}
			if (HeroWAvatar != 0) {DzDestroyFrame(HeroWAvatar);HeroWAvatar = 0;}
			if (HeroWName != 0) {DzDestroyFrame(HeroWName);HeroWName = 0;}
			if (HeroWTeam != 0) {DzDestroyFrame(HeroWTeam);HeroWTeam = 0;}
			if (HeroContent != 0) {DzDestroyFrame(HeroContent);HeroContent = 0;}
			if (HeroWraper2 != 0) {DzDestroyFrame(HeroWraper2);HeroWraper2 = 0;}
			if (HeroContent2 != 0) {DzDestroyFrame(HeroContent2);HeroContent2 = 0;}
			if (HeroSpell1 != 0) {DzDestroyFrame(HeroSpell1);HeroSpell1 = 0;}
			if (HeroSpell2 != 0) {DzDestroyFrame(HeroSpell2);HeroSpell2 = 0;}
			if (HeroSpell3 != 0) {DzDestroyFrame(HeroSpell3);HeroSpell3 = 0;}
			if (HeroSpell4 != 0) {DzDestroyFrame(HeroSpell4);HeroSpell4 = 0;}
			if (HeroContent3 != 0) {DzDestroyFrame(HeroContent3);HeroContent3 = 0;}
			if (HeroDivider1 != 0) {DzDestroyFrame(HeroDivider1);HeroDivider1 = 0;}
			if (HeroDivider2 != 0) {DzDestroyFrame(HeroDivider2);HeroDivider2 = 0;}
			if (HeroDivider3 != 0) {DzDestroyFrame(HeroDivider3);HeroDivider3 = 0;}
			if (HeroGrowAvatar != 0) {DzDestroyFrame(HeroGrowAvatar);HeroGrowAvatar = 0;BAHeroAvatar.destroy();BAHeroAvatar = 0;}
			if (HeroGrowSpell1 != 0) {DzDestroyFrame(HeroGrowSpell1);HeroGrowSpell1 = 0;BAHeroSpell1.destroy();BAHeroSpell1 = 0;}
			if (HeroGrowSpell2 != 0) {DzDestroyFrame(HeroGrowSpell2);HeroGrowSpell2 = 0;BAHeroSpell2.destroy();BAHeroSpell2 = 0;}
			if (HeroGrowSpell3 != 0) {DzDestroyFrame(HeroGrowSpell3);HeroGrowSpell3 = 0;BAHeroSpell3.destroy();BAHeroSpell3 = 0;}
			if (HeroGrowSpell4 != 0) {DzDestroyFrame(HeroGrowSpell4);HeroGrowSpell4 = 0;BAHeroSpell4.destroy();BAHeroSpell4 = 0;}
		}
		for (1 <= i <= ItemNum) { //清除物品有关
			if (Item[i] != 0) {
				DzDestroyFrame(Item[i]);Item[i] = 0;
				if (ItemTop[i] != 0) {DzDestroyFrame(ItemTop[i]);ItemTop[i] = 0;}
				if (ItemBottom[i] != 0) {DzDestroyFrame(ItemBottom[i]);ItemBottom[i] = 0;}
				if (ItemMiddle[i] != 0) {DzDestroyFrame(ItemMiddle[i]);ItemMiddle[i] = 0;}
				if (ItemStar[i] != 0) {DzDestroyFrame(ItemStar[i]);ItemStar[i] = 0;}
				if (ItemName[i] != 0) {DzDestroyFrame(ItemName[i]);ItemName[i] = 0;}
				if (ItemWraper[i] != 0) {DzDestroyFrame(ItemWraper[i]);ItemWraper[i] = 0;}
				if (ItemWW[i] != 0) {DzDestroyFrame(ItemWW[i]);ItemWW[i] = 0;}
				if (ItemWAvatar[i] != 0) {DzDestroyFrame(ItemWAvatar[i]);ItemWAvatar[i] = 0;}
				if (ItemWIcon1[i] != 0) {DzDestroyFrame(ItemWIcon1[i]);ItemWIcon1[i] = 0;}
				if (ItemWPrice1[i] != 0) {DzDestroyFrame(ItemWPrice1[i]);ItemWPrice1[i] = 0;}
				if (ItemWIcon2[i] != 0) {DzDestroyFrame(ItemWIcon2[i]);ItemWIcon2[i] = 0;}
				if (ItemWPrice2[i] != 0) {DzDestroyFrame(ItemWPrice2[i]);ItemWPrice2[i] = 0;}
				if (ItemWHint[i] != 0) {DzDestroyFrame(ItemWHint[i]);ItemWHint[i] = 0;}
				if (ItemContent[i] != 0) {DzDestroyFrame(ItemContent[i]);ItemContent[i] = 0;}
				if (ItemDivider1[i] != 0) {DzDestroyFrame(ItemDivider1[i]);ItemDivider1[i] = 0;}
				if (ItemW2[i] != 0) {DzDestroyFrame(ItemW2[i]);ItemW2[i] = 0;}
				if (ItemW2Desc[i] != 0) {DzDestroyFrame(ItemW2Desc[i]);ItemW2Desc[i] = 0;}
				if (ItemW2Divider1[i] != 0) {DzDestroyFrame(ItemW2Divider1[i]);ItemW2Divider1[i] = 0;}
				if (ItemW2Divider2[i] != 0) {DzDestroyFrame(ItemW2Divider2[i]);ItemW2Divider2[i] = 0;}
				if (ItemW2Divider3[i] != 0) {DzDestroyFrame(ItemW2Divider3[i]);ItemW2Divider3[i] = 0;}
				if (ItemW2Divider4[i] != 0) {DzDestroyFrame(ItemW2Divider4[i]);ItemW2Divider4[i] = 0;}
				if (ItemContent2[i] != 0) {DzDestroyFrame(ItemContent2[i]);ItemContent2[i] = 0;}
				if (ItemGrowIcon[i] != 0) {DzDestroyFrame(ItemGrowIcon[i]);ItemGrowIcon[i] = 0;BAItemIcon[i].destroy();BAItemIcon[i] = 0;}
			}
		}
		ItemNum = 0;
		//升级Frame的
		if (Upgrade != 0) {
			DzDestroyFrame(Upgrade);
			Upgrade = 0;
			//子元素
			if (UpTop != 0) {DzDestroyFrame(UpTop);UpTop = 0;}
			if (UpBottom != 0) {DzDestroyFrame(UpBottom);UpBottom = 0;}
			if (UpRes[1] != 0) {DzDestroyFrame(UpRes[1]);UpRes[1] = 0;}
			if (UpRes[2] != 0) {DzDestroyFrame(UpRes[2]);UpRes[2] = 0;}
			if (UpIRes[1] != 0) {DzDestroyFrame(UpIRes[1]);UpIRes[1] = 0;}
			if (UpIRes[2] != 0) {DzDestroyFrame(UpIRes[2]);UpIRes[2] = 0;}
			if (UpIRes[3] != 0) {DzDestroyFrame(UpIRes[3]);UpIRes[3] = 0;}
		}
		if (Arrow != 0) {DzDestroyFrame(Arrow);Arrow = 0;}//箭头与加号
		for (1 <= i <= SpellNum) { //清除技能有关
			if (Spell[i] != 0) {
				DzDestroyFrame(Spell[i]);Spell[i] = 0;
				if (SpellTop[i] != 0) {DzDestroyFrame(SpellTop[i]);SpellTop[i] = 0;}
				if (SpellBottom[i] != 0) {DzDestroyFrame(SpellBottom[i]);SpellBottom[i] = 0;}
				if (SpellMiddle[i] != 0) {DzDestroyFrame(SpellMiddle[i]);SpellMiddle[i] = 0;}
				if (SpellWraper[i] != 0) {DzDestroyFrame(SpellWraper[i]);SpellWraper[i] = 0;}
				if (SpellWAvatar[i] != 0) {DzDestroyFrame(SpellWAvatar[i]);SpellWAvatar[i] = 0;}
				if (SpellWName[i] != 0) {DzDestroyFrame(SpellWName[i]);SpellWName[i] = 0;}
				if (SpellWLevel[i] != 0) {DzDestroyFrame(SpellWLevel[i]);SpellWLevel[i] = 0;}
				if (SpellFromIcon[i] != 0) {DzDestroyFrame(SpellFromIcon[i]);SpellFromIcon[i] = 0;}
				if (SpellFromName[i] != 0) {DzDestroyFrame(SpellFromName[i]);SpellFromName[i] = 0;}
				if (SpellWraper2[i] != 0) {DzDestroyFrame(SpellWraper2[i]);SpellWraper2[i] = 0;}
				if (SpellManaIcon[i] != 0) {DzDestroyFrame(SpellManaIcon[i]);SpellManaIcon[i] = 0;}
				if (SpellMana[i] != 0) {DzDestroyFrame(SpellMana[i]);SpellMana[i] = 0;}
				if (SpellContent[i] != 0) {DzDestroyFrame(SpellContent[i]);SpellContent[i] = 0;}
				if (SpellDivider1[i] != 0) {DzDestroyFrame(SpellDivider1[i]);SpellDivider1[i] = 0;}
				if (SpellDivider2[i] != 0) {DzDestroyFrame(SpellDivider2[i]);SpellDivider2[i] = 0;}
				if (SpellGrowAva[i] != 0) {DzDestroyFrame(SpellGrowAva[i]);SpellGrowAva[i] = 0;BASpellAvatar[i].destroy();BASpellAvatar[i] = 0;}
			}
		}
		SpellNum = 0;
	}

	#define LAYER_DETAIL_UI DzGetGameUI()
	public struct detailF [] {
		static boolean multi   = false; //创建多个
		static integer result2 = 0; //多返回值
		static boolean bAgrs1  = false; //参数1
		static integer parent  = 0; //创建的锚点

		//劳模:离开事件
		static method leave () {
			DetailUIDestroy();
			DzFrameSetAbsolutePoint(DzFrameGetTooltip(),ANCHOR_BOTTOMRIGHT,.8,.1625);
		}

		static method onInit () {
			detailF.parent = LAYER_DETAIL_UI; //默认最前面
		}
	}


	integer Frame    = 0;  //主视窗
	integer Title1   = 0;  //控件元素
	integer Content1 = 0;
	integer Title2   = 0;
	integer Content2 = 0;
	integer Title3   = 0;
	integer Content3 = 0;
	//1个标题(无描述)-> Title1;
	//居中显示,无宽;
	//与其他DetailUI共用一套销毁逻辑
	public function DetailUITitle ( string title ) -> integer {

		DetailUIDestroy();
		Frame  = CreateToolTips(detailF.parent);
		Title1 = NewTextXL(Frame);

		DzFrameSetText(Title1,title);
		DzFrameSetPoint(Frame,ANCHOR_TOP,Title1,ANCHOR_TOP,0,0.01); //外框的锚定
		DzFrameSetPoint(Frame,ANCHOR_BOTTOM,Title1,ANCHOR_BOTTOM,0,- 0.01);
		DzFrameSetPoint(Frame,ANCHOR_LEFT,Title1,ANCHOR_LEFT,- 0.012,0);
		DzFrameSetPoint(Frame,ANCHOR_RIGHT,Title1,ANCHOR_RIGHT,0.01,0);

		return Title1;
	}

	//1个标题1个描述
	//标题一起左,内容左对齐
	//不适应窗口,会移到右下角.
	public function DetailUICreate1x1 ( real width,string title,string desc ) {
		real resizeX;

		DetailUIDestroy();
		Frame    = CreateToolTips(detailF.parent);
		Title1   = NewTextLeftXL(Frame);
		Content1 = NewTextLeftL(Frame);

		resizeX = 1;//GetResizeRate()
		DzFrameSetText(Title1,title);
		DzFrameSetText(Content1,desc);
		DzFrameSetSize(Content1,width * resizeX,0);
		DzFrameSetSize(Title1,width * resizeX,0);
		DzFrameSetAbsolutePoint(Content1,ANCHOR_BOTTOMRIGHT,.786,.1375);//以底描述为基准
		DzFrameSetPoint(Title1,ANCHOR_BOTTOMLEFT,Content1,ANCHOR_TOPLEFT,0,0.005);//标题在底描述上面
		DzFrameSetPoint(Frame,ANCHOR_TOP,Title1,ANCHOR_TOP,0,0.01); //外框的锚定
		DzFrameSetPoint(Frame,ANCHOR_BOTTOM,Content1,ANCHOR_BOTTOM,0,- 0.01);
		DzFrameSetPoint(Frame,ANCHOR_LEFT,Content1,ANCHOR_LEFT,- 0.012 * resizeX,0);
		DzFrameSetPoint(Frame,ANCHOR_RIGHT,Content1,ANCHOR_RIGHT,0.01 * resizeX,0);
	}

	//3个标题3个描述
	//全部都是左对齐
	//不适应窗口
	public function DetailUICreate3x2 (real width, string title1,string desc1,string title2,string desc2,string title3,string desc3) {
		real resizeX;

		DetailUIDestroy();
		Frame    = CreateToolTips(detailF.parent);
		Title1   = NewTextLeftXL(Frame);
		Content1 = NewTextLeftL(Frame);
		Title2   = NewTextLeftXL(Frame);
		Content2 = NewTextLeftL(Frame);
		Title3   = NewTextLeftXL(Frame);
		Content3 = NewTextLeftL(Frame);

		DzFrameSetAbsolutePoint(Content3,ANCHOR_BOTTOMRIGHT,.786,.1375);
		DzFrameSetPoint(Title3,ANCHOR_BOTTOMLEFT,Content3,ANCHOR_TOPLEFT,0,0.005);
		DzFrameSetPoint(Content2,ANCHOR_BOTTOMLEFT,Title3,ANCHOR_TOPLEFT,0,0.005);
		DzFrameSetPoint(Title2,ANCHOR_BOTTOMLEFT,Content2,ANCHOR_TOPLEFT,0,0.005);
		DzFrameSetPoint(Content1,ANCHOR_BOTTOMLEFT,Title2,ANCHOR_TOPLEFT,0,0.005);
		DzFrameSetPoint(Title1,ANCHOR_BOTTOMLEFT,Content1,ANCHOR_TOPLEFT,0,0.005);

		DzFrameSetText(Title1,title1);
		DzFrameSetText(Title2,title2);
		DzFrameSetText(Title3,title3);
		DzFrameSetText(Content1,desc1);
		DzFrameSetText(Content2,desc2);
		DzFrameSetText(Content3,desc3);

		resizeX = 1;//GetResizeRate()
		DzFrameSetSize(Content1,width * resizeX,0);
		DzFrameSetSize(Content2,width * resizeX,0);
		DzFrameSetSize(Content3,width * resizeX,0);
		DzFrameSetPoint(Frame,ANCHOR_TOP,Title1,ANCHOR_TOP,0,0.01);
		DzFrameSetPoint(Frame,ANCHOR_BOTTOM,Content3,ANCHOR_BOTTOM,0,- 0.01);
		DzFrameSetPoint(Frame,ANCHOR_LEFT,Content1,ANCHOR_LEFT,- 0.012 * resizeX,0);
		DzFrameSetPoint(Frame,ANCHOR_RIGHT,Content1,ANCHOR_RIGHT,0.01 * resizeX,0);
	}

	integer Guai         = 0;
	integer GuaiWraper   = 0;
	integer GuaiWIcon    = 0;
	integer GuaiWName    = 0;
	integer GuaiWLevel   = 0;
	integer GuaiContent1 = 0;
	integer GuaiContent2 = 0;
	integer GuaiDivider1 = 0;
	integer GuaiDivider2 = 0;
	//怪物的技能查看
	//不需要适应窗口
	public function DetailUICreateGuai (real width,string art,string name,string level,string desc1,string desc2) {
		real resizeX;

		DetailUIDestroy();

		//创建UI
		resizeX         = GetResizeRate();
		Guai         = CreateToolTips(detailF.parent);
		GuaiWraper   = CreateBackDrop(Guai);
		GuaiWIcon    = CreateBackDrop(Guai);
		GuaiWName    = NewTextLeftXL(Guai);
		GuaiWLevel   = NewTextLeftXL(Guai);
		GuaiContent1 = NewTextOrigin(Guai,0.0114);  //介于XL和L之间
		GuaiContent2 = NewTextLeftL(Guai);
		GuaiDivider1 = CreateBackDrop(Guai);
		GuaiDivider2 = CreateBackDrop(Guai);

		//分隔线
		DzFrameSetSize(GuaiDivider1,width * 0.9 * resizeX,0.0008);
		DzFrameSetTexture(GuaiDivider1,"ui\\image\\divider_gray.blp",0);
		DzFrameSetSize(GuaiDivider2,width * 0.9 * resizeX,0.0008);
		DzFrameSetTexture(GuaiDivider2,"ui\\image\\divider_gray.blp",0);

		//设置一下大小
		DzFrameSetSize(GuaiContent1,width * resizeX,0);
		DzFrameSetSize(GuaiContent2,width * resizeX,0);
		DzFrameSetSize(GuaiWraper,width * resizeX,0.05);
		DzFrameSetSize(GuaiWIcon,0.035 * resizeX,0.035);
		//DzFrameSetSize(GuaiWName,width * resizeX,0);
		//DzFrameSetSize(GuaiWLevel,width * resizeX,0);

		//设置一下控件的位置
		DzFrameSetAbsolutePoint(GuaiContent2,ANCHOR_BOTTOMRIGHT,.786,.1375);
		DzFrameSetPoint(GuaiContent1,ANCHOR_BOTTOMLEFT,GuaiContent2,ANCHOR_TOPLEFT,0,0.01);
		DzFrameSetPoint(GuaiWraper,ANCHOR_BOTTOMLEFT,GuaiContent1,ANCHOR_TOPLEFT,0,0.01);
		DzFrameSetPoint(GuaiDivider2 ,ANCHOR_BOTTOM,GuaiContent2,ANCHOR_TOP,0,0.005);
		DzFrameSetPoint(GuaiDivider1 ,ANCHOR_BOTTOM,GuaiContent1,ANCHOR_TOP,0,0.005);
		DzFrameSetPoint(GuaiWIcon,ANCHOR_LEFT,GuaiWraper,ANCHOR_LEFT,0.004 * resizeX,0);
		DzFrameSetPoint(GuaiWName,ANCHOR_TOP,GuaiWraper,ANCHOR_TOP,0,- 0.008);
		DzFrameSetPoint(GuaiWName,ANCHOR_LEFT,GuaiWIcon,ANCHOR_RIGHT,0.005 * resizeX,0);
		DzFrameSetPoint(GuaiWName,ANCHOR_RIGHT,GuaiWraper,ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(GuaiWLevel,ANCHOR_TOP,GuaiWraper,ANCHOR_CENTER,0,- 0.005);
		DzFrameSetPoint(GuaiWLevel,ANCHOR_BOTTOM,GuaiWraper,ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(GuaiWLevel,ANCHOR_LEFT,GuaiWIcon,ANCHOR_RIGHT,0.005 * resizeX,0);

		//外框的大小
		DzFrameSetPoint(Guai,ANCHOR_TOP,GuaiWraper,ANCHOR_TOP,0,0.01);
		DzFrameSetPoint(Guai,ANCHOR_BOTTOM,GuaiContent2,ANCHOR_BOTTOM,0,- 0.01);
		DzFrameSetPoint(Guai,ANCHOR_LEFT,GuaiContent2,ANCHOR_LEFT,- 0.012 * resizeX,0);
		DzFrameSetPoint(Guai,ANCHOR_RIGHT,GuaiContent2,ANCHOR_RIGHT,0.01 * resizeX,0);


		DzFrameShow(Guai,true);

		DzFrameSetTexture(GuaiWIcon,art,0);
		DzFrameSetText(GuaiWName,name);
		DzFrameSetText(GuaiWLevel,level);
		DzFrameSetText(GuaiContent1,desc1);
		DzFrameSetText(GuaiContent2,desc2);
	}


	#define DETAILUI_HERO_ICON_SIZE 0.035
	integer  Hero           = 0;
	integer  HeroTop        = 0;
	integer  HeroBottom     = 0;
	integer  HeroMiddle     = 0;
	integer  HeroWraper     = 0;
	integer  HeroWAvatar    = 0;
	integer  HeroWName      = 0;
	integer  HeroWTeam      = 0;
	integer  HeroContent    = 0;
	integer  HeroWraper2    = 0;
	integer  HeroContent2   = 0;
	integer  HeroSpell1     = 0;
	integer  HeroSpell2     = 0;
	integer  HeroSpell3     = 0;
	integer  HeroSpell4     = 0;
	integer  HeroContent3   = 0;
	integer  HeroDivider1   = 0;
	integer  HeroDivider2   = 0;
	integer  HeroDivider3   = 0;
	integer  HeroGrowAvatar = 0;
	integer  HeroGrowSpell1 = 0;
	integer  HeroGrowSpell2 = 0;
	integer  HeroGrowSpell3 = 0;
	integer  HeroGrowSpell4 = 0;
	baseanim BAHeroAvatar   = 0;
	baseanim BAHeroSpell1   = 0;
	baseanim BAHeroSpell2   = 0;
	baseanim BAHeroSpell3   = 0;
	baseanim BAHeroSpell4   = 0;
	//英雄的窗口
	public function DetailUIHero (real width,herodata hd,growdata gdAvatar,growdata gdSpell1,growdata gdSpell2,growdata gdSpell3,growdata gdSpell4){
		real resizeX   = GetResizeRate();
		real fWidth    = width + 0.02 ;                                 //整体框架的大小
		real iconWidth = RMinBJ(DETAILUI_HERO_ICON_SIZE,width * 0.2) ;  //技能图标的长宽
		real iconGap   = width * 0.03;                                  //技能图标的间距

		DetailUIDestroy();

		//创建UI
		Hero         = CreateBackDrop(detailF.parent); //整体Frame
		HeroTop      = CreateBackDrop(Hero);          //上框图片
		HeroBottom   = CreateBackDrop(Hero);          //下框图片
		HeroMiddle   = CreateBackDrop(Hero);          //中框图片
		HeroWraper   = CreateBackDrop(Hero);          //最上方的包裹块
		HeroWAvatar  = CreateBackDrop(Hero);          //英雄图标
		HeroWName    = NewTextLeftXL(Hero);           //英雄名字
		HeroWTeam    = NewTextLeftXL(Hero);           //英雄阵营
		HeroContent  = NewTextLeftML(Hero);           //英雄的天赋技能介绍
		HeroWraper2  = CreateBackDrop(Hero);          //英雄技能包裹块
		HeroSpell1   = CreateBackDrop(Hero);          //技能图标1
		HeroSpell2   = CreateBackDrop(Hero);          //技能图标2
		HeroSpell3   = CreateBackDrop(Hero);          //技能图标3
		HeroSpell4   = CreateBackDrop(Hero);          //技能图标4
		HeroContent2 = NewTextLeftXL(Hero);           //英雄的小技能名字列表
		HeroContent3 = NewTextML(Hero);               //英雄的额外
		HeroDivider1 = CreateBackDrop(Hero);          //分割线[名字-天赋]
		HeroDivider2 = CreateBackDrop(Hero);          //分割线[天赋-4技能]
		HeroDivider3 = CreateBackDrop(Hero);          //分割线[4技能-额外]

		//图片渲染
		DzFrameSetTexture(HeroTop,"ui\\tooltips\\BG_DetailTop.tga",0);
		DzFrameSetTexture(HeroBottom,"ui\\tooltips\\BG_DetailBottom.tga",0);
		DzFrameSetTexture(HeroMiddle,"ui\\tooltips\\BG_DetailMiddle.tga",0);
		DzFrameSetTexture(HeroDivider1,"ui\\image\\divider_gray.blp",0);
		DzFrameSetTexture(HeroDivider2,"ui\\image\\divider_gray.blp",0);
		DzFrameSetTexture(HeroDivider3,"ui\\image\\divider_gray.blp",0);

		//设置一下大小
		DzFrameSetSize(Hero,0.001,0.001);
		DzFrameSetSize(HeroTop,fWidth * resizeX,fWidth * 0.125);
		DzFrameSetSize(HeroBottom,fWidth * resizeX,fWidth * 0.125);
		//-------------标题----------------
		DzFrameSetSize(HeroWraper,width * resizeX,0.05);
		DzFrameSetSize(HeroWAvatar,DETAILUI_HERO_ICON_SIZE * resizeX,DETAILUI_HERO_ICON_SIZE);
		//-------------文字----------------
		DzFrameSetSize(HeroContent,width * 0.85 * resizeX,0);
		DzFrameSetSize(HeroContent2,width * 0.85 * resizeX,0);
		DzFrameSetSize(HeroContent3,width * resizeX,0);
		//-------------技能图标----------------
		DzFrameSetSize(HeroSpell1,iconWidth * resizeX,iconWidth);
		DzFrameSetSize(HeroSpell2,iconWidth * resizeX,iconWidth);
		DzFrameSetSize(HeroSpell3,iconWidth * resizeX,iconWidth);
		DzFrameSetSize(HeroSpell4,iconWidth * resizeX,iconWidth);
		//-------------分割线----------------
		DzFrameSetSize(HeroDivider1,width * 0.9 * resizeX,0.0008);
		DzFrameSetSize(HeroDivider2,width * 0.9 * resizeX,0.0008);
		DzFrameSetSize(HeroDivider3,width * 0.9 * resizeX,0.0008);

		//设置一下控件的位置[由下向上]
		DzFrameSetAbsolutePoint(HeroContent3,ANCHOR_BOTTOMRIGHT,.786,.1375);
		DzFrameSetPoint(HeroDivider3 ,ANCHOR_BOTTOM,HeroContent3,ANCHOR_TOP,0,0.01);
		//-----------------------------
		DzFrameSetPoint(HeroContent2,ANCHOR_BOTTOM,HeroContent3,ANCHOR_TOP,0,0.02);
		DzFrameSetPoint(HeroSpell3,ANCHOR_BOTTOMLEFT,HeroContent2,ANCHOR_TOP,0.5 * iconGap * resizeX,0.005);
		DzFrameSetPoint(HeroSpell2,ANCHOR_BOTTOMRIGHT,HeroContent2,ANCHOR_TOP,-0.5 * iconGap * resizeX,0.005);
		DzFrameSetPoint(HeroSpell4,ANCHOR_LEFT,HeroSpell3,ANCHOR_RIGHT,iconGap * resizeX,0);
		DzFrameSetPoint(HeroSpell1,ANCHOR_RIGHT,HeroSpell2,ANCHOR_LEFT,-1 * iconGap * resizeX,0);
		DzFrameSetPoint(HeroWraper2,ANCHOR_BOTTOM,HeroContent2,ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(HeroWraper2,ANCHOR_LEFT,HeroSpell1,ANCHOR_LEFT,0,0);
		DzFrameSetPoint(HeroWraper2,ANCHOR_RIGHT,HeroSpell4,ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(HeroWraper2,ANCHOR_TOP,HeroSpell1,ANCHOR_TOP,0,0);
		DzFrameSetPoint(HeroDivider2 ,ANCHOR_BOTTOM,HeroWraper2,ANCHOR_TOP,0,0.01);
		//-----------------------------
		DzFrameSetPoint(HeroContent,ANCHOR_BOTTOM,HeroWraper2,ANCHOR_TOP,0,0.02);
		DzFrameSetPoint(HeroDivider1 ,ANCHOR_BOTTOM,HeroContent,ANCHOR_TOP,0,0.01);
		//-----------------------------
		DzFrameSetPoint(HeroWraper,ANCHOR_BOTTOM,HeroContent,ANCHOR_TOP,0,0.02);
		DzFrameSetPoint(HeroWAvatar,ANCHOR_LEFT,HeroWraper,ANCHOR_LEFT,0.004 * resizeX,0);
		DzFrameSetPoint(HeroWName,ANCHOR_TOP,HeroWraper,ANCHOR_TOP,0,- 0.008);
		DzFrameSetPoint(HeroWName,ANCHOR_LEFT,HeroWAvatar,ANCHOR_RIGHT,0.005 * resizeX,0);
		DzFrameSetPoint(HeroWName,ANCHOR_RIGHT,HeroWraper,ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(HeroWTeam,ANCHOR_TOP,HeroWraper,ANCHOR_CENTER,0,- 0.005);
		DzFrameSetPoint(HeroWTeam,ANCHOR_BOTTOM,HeroWraper,ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(HeroWTeam,ANCHOR_LEFT,HeroWAvatar,ANCHOR_RIGHT,0.005 * resizeX,0);

		//描述外框的大小
		DzFrameSetPoint(HeroTop,ANCHOR_TOP,HeroWraper,ANCHOR_TOP,0,0.01);
		DzFrameSetPoint(HeroBottom,ANCHOR_BOTTOM,HeroContent3,ANCHOR_BOTTOM,0,-0.01);
		DzFrameSetPoint(HeroMiddle,ANCHOR_TOPLEFT,HeroTop,ANCHOR_BOTTOMLEFT,0,0);
		DzFrameSetPoint(HeroMiddle,ANCHOR_BOTTOMRIGHT,HeroBottom,ANCHOR_TOPRIGHT,0,0);

		//流光特效的附着
		if (gdAvatar != 0) {
			HeroGrowAvatar = CreateBackDrop(Hero);
			BAHeroAvatar = baseanim.create(HeroGrowAvatar);
			DzFrameSetSize(HeroGrowAvatar,DETAILUI_HERO_ICON_SIZE * resizeX * gdAvatar.scale,DETAILUI_HERO_ICON_SIZE * gdAvatar.scale);
			DzFrameSetPoint(HeroGrowAvatar,ANCHOR_CENTER,HeroWAvatar,ANCHOR_CENTER,0,0);
			BAHeroAvatar.addSequ(gdAvatar.path,gdAvatar.max,gdAvatar.gap,true);
		}
		if (gdSpell1 != 0) {
			HeroGrowSpell1 = CreateBackDrop(Hero);
			BAHeroSpell1 = baseanim.create(HeroGrowSpell1);
			DzFrameSetSize(HeroGrowSpell1,DETAILUI_HERO_ICON_SIZE * resizeX * gdSpell1.scale,DETAILUI_HERO_ICON_SIZE * gdSpell1.scale);
			DzFrameSetPoint(HeroGrowSpell1,ANCHOR_CENTER,HeroSpell1,ANCHOR_CENTER,0,0);
			BAHeroSpell1.addSequ(gdSpell1.path,gdSpell1.max,gdSpell1.gap,true);
		}
		if (gdSpell2 != 0) {
			HeroGrowSpell2 = CreateBackDrop(Hero);
			BAHeroSpell2 = baseanim.create(HeroGrowSpell2);
			DzFrameSetSize(HeroGrowSpell2,DETAILUI_HERO_ICON_SIZE * resizeX * gdSpell2.scale,DETAILUI_HERO_ICON_SIZE * gdSpell2.scale);
			DzFrameSetPoint(HeroGrowSpell2,ANCHOR_CENTER,HeroSpell2,ANCHOR_CENTER,0,0);
			BAHeroSpell2.addSequ(gdSpell2.path,gdSpell2.max,gdSpell2.gap,true);
		}
		if (gdSpell3 != 0) {
			HeroGrowSpell3 = CreateBackDrop(Hero);
			BAHeroSpell3 = baseanim.create(HeroGrowSpell3);
			DzFrameSetSize(HeroGrowSpell3,DETAILUI_HERO_ICON_SIZE * resizeX * gdSpell3.scale,DETAILUI_HERO_ICON_SIZE * gdSpell3.scale);
			DzFrameSetPoint(HeroGrowSpell3,ANCHOR_CENTER,HeroSpell3,ANCHOR_CENTER,0,0);
			BAHeroSpell3.addSequ(gdSpell3.path,gdSpell3.max,gdSpell3.gap,true);
		}
		if (gdSpell4 != 0) {
			HeroGrowSpell4 = CreateBackDrop(Hero);
			BAHeroSpell4 = baseanim.create(HeroGrowSpell4);
			DzFrameSetSize(HeroGrowSpell4,DETAILUI_HERO_ICON_SIZE * resizeX * gdSpell4.scale,DETAILUI_HERO_ICON_SIZE * gdSpell4.scale);
			DzFrameSetPoint(HeroGrowSpell4,ANCHOR_CENTER,HeroSpell4,ANCHOR_CENTER,0,0);
			BAHeroSpell4.addSequ(gdSpell4.path,gdSpell4.max,gdSpell4.gap,true);
		}

		//数据的读取设置
		DzFrameSetTexture(HeroWAvatar,hd.getAvatar(),0);
		DzFrameSetTexture(HeroSpell1,hd.spell[1].getArt(),0);
		DzFrameSetTexture(HeroSpell2,hd.spell[2].getArt(),0);
		DzFrameSetTexture(HeroSpell3,hd.spell[3].getArt(),0);
		DzFrameSetTexture(HeroSpell4,hd.spell[4].getArt(),0);
		DzFrameSetText(HeroWName,hd.name);
		DzFrameSetText(HeroWTeam,hd.getTeamName());
		DzFrameSetText(HeroContent,"天赋技能:[|cff00b7ff"+hd.talent.getName()+"|r]\n\
		"+hd.talent.getDesc());
		DzFrameSetText(HeroContent2,"Q位技能:[" + hd.spell[1].getPrefixColor() + hd.spell[1].getName()+"|r]\n\
		W位技能:[" + hd.spell[2].getPrefixColor() + hd.spell[2].getName() + "|r]\n\
		E位技能:[" + hd.spell[3].getPrefixColor() + hd.spell[3].getName() + "|r]\n\
		R位技能:[" + hd.spell[4].getPrefixColor() + hd.spell[4].getName() + "|r]");
		DzFrameSetText(HeroContent3,hd.unlock);

		// DzFrameShow(Hero,true);
	}

	#define ICON_SIZE_AVATAR 0.035 //物品的图标大小
	#define ICON_SIZE_RES    0.015 //物品的资源大小
	integer  ItemNum = 0; //当前的数量
	integer  Item          [];
	integer  ItemTop       [];
	integer  ItemBottom    [];
	integer  ItemMiddle    [];
	integer  ItemStar      []; //名字与星星
	integer  ItemName      [];
	integer  ItemWraper    []; //上部分整体
	integer  ItemWW        []; //资源小区
	integer  ItemWAvatar   [];
	integer  ItemWIcon1    [];
	integer  ItemWPrice1   [];
	integer  ItemWIcon2    [];
	integer  ItemWPrice2   [];
	integer  ItemWHint     [];
	integer  ItemContent   []; //中间的介绍段
	integer  ItemDivider1  [];
	integer  ItemW2        []; //介绍分割线有关
	integer  ItemW2Desc    [];
	integer  ItemW2Divider1[];
	integer  ItemW2Divider2[];
	integer  ItemW2Divider3[];
	integer  ItemW2Divider4[];
	integer  ItemContent2  []; //物品介绍
	integer  ItemGrowIcon  []; //动效有关
	baseanim BAItemIcon    [];
	//创建一个Item的描述
	function DetailUIItemO (integer index,real width,integer star,growdata grow) {
		integer i;
		string s;
		real resizeX = GetResizeRate();
		real fWidth  = width + 0.02 ;    //整体框架的大小

		DetailUIDestroy();
		ItemNum = IMaxBJ(index,ItemNum);

		//创建UI
		Item[index]           = CreateBackDrop(detailF.parent); //整体Frame
		ItemTop[index]        = CreateBackDrop(Item[index] );  //上框图片
		ItemBottom[index]     = CreateBackDrop(Item[index] );  //下框图片
		ItemMiddle[index]     = CreateBackDrop(Item[index] );  //中框图片
		ItemStar[index]       = NewTextM      (Item[index] );  //装备星星[可隐藏]
		ItemName[index]       = NewTextLeftXXL(Item[index] );  //装备名字
		ItemWraper[index]     = CreateBackDrop(Item[index] );  //最上方的包裹块
		ItemWW[index]         = CreateBackDrop(Item[index] );  //资源小区的包裹
		ItemWAvatar[index]    = CreateBackDrop(Item[index] );  //装备图标
		ItemWIcon1[index]     = CreateBackDrop(Item[index] );  //装备资源图标1
		ItemWPrice1[index]    = NewTextLeftL  (Item[index] );  //装备资源价格1
		ItemWIcon2[index]     = CreateBackDrop(Item[index] );  //装备资源图标2
		ItemWPrice2[index]    = NewTextLeftL  (Item[index] );  //装备资源价格2
		ItemWHint[index]      = NewTextLeftML (Item[index] );  //装备资源下面的文字提示
		ItemContent[index]    = NewTextML     (Item[index] );  //装备的中间段文字提示
		ItemDivider1[index]   = CreateBackDrop(Item[index] );  //分割线1
		ItemW2[index]         = CreateBackDrop(Item[index] );  //装备的下部分割线包裹块
		ItemW2Desc[index]     = NewTextLeftML (Item[index] );  //物品介绍4个字
		ItemW2Divider1[index] = CreateBackDrop(Item[index] );  //分割线2-左线
		ItemW2Divider2[index] = CreateBackDrop(Item[index] );  //分割线2-左标
		ItemW2Divider3[index] = CreateBackDrop(Item[index] );  //分割线2-右标
		ItemW2Divider4[index] = CreateBackDrop(Item[index] );  //分割线2-右线
		ItemContent2[index]   = NewTextLeftL  (Item[index] );   //物品介绍全文

		//图片渲染
		DzFrameSetTexture(ItemTop[index],"ui\\tooltips\\ItemDetail_top.tga",0);
		DzFrameSetTexture(ItemBottom[index],"ui\\tooltips\\ItemDetail_bottom.tga",0);
		DzFrameSetTexture(ItemMiddle[index],"ui\\tooltips\\ItemDetail_middle.tga",0);
		DzFrameSetTexture(ItemDivider1[index],"ui\\tooltips\\ItemDetail_Divider_White.tga",0);
		DzFrameSetTexture(ItemW2Divider1[index],"ui\\tooltips\\ItemDetail_Divider_1.tga",0);
		DzFrameSetTexture(ItemW2Divider2[index],"ui\\tooltips\\ItemDetail_Divider_2.tga",0);
		DzFrameSetTexture(ItemW2Divider3[index],"ui\\tooltips\\ItemDetail_Divider_4.tga",0);
		DzFrameSetTexture(ItemW2Divider4[index],"ui\\tooltips\\ItemDetail_Divider_3.tga",0);

		//设置一下大小
		DzFrameSetSize(Item[index],0.001,0.001);
		DzFrameSetSize(ItemTop[index],fWidth * resizeX,fWidth * 0.25);
		DzFrameSetSize(ItemBottom[index],fWidth * resizeX,fWidth * 0.25);
		//-------------标题----------------
		DzFrameSetSize(ItemWraper[index],width * resizeX,0.04);
		DzFrameSetSize(ItemWAvatar[index],ICON_SIZE_AVATAR * resizeX,ICON_SIZE_AVATAR);
		DzFrameSetSize(ItemWIcon1[index],ICON_SIZE_RES * resizeX,ICON_SIZE_RES);
		DzFrameSetSize(ItemWIcon2[index],ICON_SIZE_RES * resizeX,ICON_SIZE_RES);
		//-------------文字----------------
		DzFrameSetSize(ItemContent[index],width * 0.85 * resizeX,0);
		DzFrameSetSize(ItemContent2[index],width * resizeX,0);
		//-------------分割线----------------
		DzFrameSetSize(ItemDivider1[index],width * 0.9 * resizeX,0.005); //上部分割
		DzFrameSetSize(ItemW2Divider1[index],width * 0.16 * resizeX,width * 0.1); //1与4是动态
		DzFrameSetSize(ItemW2Divider4[index],width * 0.16 * resizeX,width * 0.1); //1与4是动态
		DzFrameSetSize(ItemW2Divider2[index],width * 0.2 * resizeX,width * 0.1); //这2个固定依附,1与4是动态
		DzFrameSetSize(ItemW2Divider3[index],width * 0.2 * resizeX,width * 0.1); //这2个固定依附,1与4是动态

		//设置一下控件的位置[由下向上]
		DzFrameSetAbsolutePoint(ItemContent2[index],ANCHOR_BOTTOMRIGHT,.786,.1375);
		//-------------分割部分-------------
		DzFrameSetPoint(ItemW2Desc[index] ,ANCHOR_BOTTOM,ItemContent2[index],ANCHOR_TOP,0,0.01);
		DzFrameSetPoint(ItemW2Divider1[index],ANCHOR_RIGHT,ItemW2Divider2[index],ANCHOR_LEFT,0,0);
		DzFrameSetPoint(ItemW2Divider2[index],ANCHOR_RIGHT,ItemW2Desc[index],ANCHOR_LEFT,0,0);
		DzFrameSetPoint(ItemW2Divider3[index],ANCHOR_LEFT,ItemW2Desc[index],ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(ItemW2Divider4[index],ANCHOR_LEFT,ItemW2Divider3[index],ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(ItemW2[index],ANCHOR_BOTTOM,ItemW2Desc[index],ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(ItemW2[index],ANCHOR_TOP,ItemW2Desc[index],ANCHOR_TOP,0,0);
		DzFrameSetPoint(ItemW2[index],ANCHOR_LEFT,ItemW2Divider1[index],ANCHOR_LEFT,0,0);
		DzFrameSetPoint(ItemW2[index],ANCHOR_RIGHT,ItemW2Divider4[index],ANCHOR_RIGHT,0,0);
		DzFrameSetText(ItemW2Desc[index],"物品介绍");
		//-----------------------------
		DzFrameSetPoint(ItemContent[index],ANCHOR_BOTTOM,ItemW2[index],ANCHOR_TOP,0,0.005);
		//-----------------------------
		DzFrameSetPoint(ItemDivider1[index],ANCHOR_BOTTOM,ItemContent[index],ANCHOR_TOP,0,0.005);
		DzFrameSetPoint(ItemWW[index],ANCHOR_TOP,ItemWraper[index],ANCHOR_TOP,0,-0.005);
		DzFrameSetPoint(ItemWW[index],ANCHOR_BOTTOM,ItemWraper[index],ANCHOR_CENTER,0,0.005);
		DzFrameSetPoint(ItemWW[index],ANCHOR_LEFT,ItemWAvatar[index],ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(ItemWW[index],ANCHOR_RIGHT,ItemWraper[index],ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(ItemWraper[index],ANCHOR_BOTTOM,ItemContent[index],ANCHOR_TOP,0,0.02);
		DzFrameSetPoint(ItemWAvatar[index],ANCHOR_LEFT,ItemWraper[index],ANCHOR_LEFT,0.004 * resizeX,0);
		DzFrameSetPoint(ItemWIcon1[index],ANCHOR_LEFT,ItemWW[index],ANCHOR_LEFT,0.005 * resizeX,0);
		DzFrameSetPoint(ItemWPrice1[index],ANCHOR_LEFT,ItemWIcon1[index],ANCHOR_RIGHT,0.002 * resizeX,0);
		DzFrameSetPoint(ItemWIcon2[index],ANCHOR_LEFT,ItemWW[index],ANCHOR_CENTER,0.005 * resizeX,0);
		DzFrameSetPoint(ItemWPrice2[index],ANCHOR_LEFT,ItemWIcon2[index],ANCHOR_RIGHT,0.002 * resizeX,0);
		DzFrameSetPoint(ItemWHint[index],ANCHOR_TOP,ItemWraper[index],ANCHOR_CENTER,0,- 0.005);
		DzFrameSetPoint(ItemWHint[index],ANCHOR_BOTTOM,ItemWraper[index],ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(ItemWHint[index],ANCHOR_LEFT,ItemWAvatar[index],ANCHOR_RIGHT,0.005 * resizeX,0);
		DzFrameSetPoint(ItemWHint[index],ANCHOR_RIGHT,ItemWraper[index],ANCHOR_RIGHT,0,0);
		//------------名字与星星-------------
		DzFrameSetPoint(ItemName[index],ANCHOR_BOTTOM,ItemWraper[index],ANCHOR_TOP,0,0.005);
		DzFrameSetPoint(ItemStar[index],ANCHOR_BOTTOM,ItemName[index],ANCHOR_TOP,0,0.005);

		//描述外框的大小
		DzFrameSetPoint(ItemBottom[index],ANCHOR_BOTTOM,ItemContent2[index],ANCHOR_BOTTOM,0,-0.01);
		DzFrameSetPoint(ItemMiddle[index],ANCHOR_TOPLEFT,ItemTop[index],ANCHOR_BOTTOMLEFT,0,0);
		DzFrameSetPoint(ItemMiddle[index],ANCHOR_BOTTOMRIGHT,ItemBottom[index],ANCHOR_TOPRIGHT,0,0);

		if (star > 1) { //星级分支
			DzFrameSetText(ItemStar[index],"|cffffff00"+RepeatString("★",star,5,15)); //
			DzFrameShow(ItemStar[index],true);
			DzFrameSetPoint(ItemTop[index],ANCHOR_TOP,ItemStar[index],ANCHOR_TOP,0,0.01);
		} else {
			DzFrameShow(ItemStar[index],false);
			DzFrameSetPoint(ItemTop[index],ANCHOR_TOP,ItemName[index],ANCHOR_TOP,0,0.01);
		}

		if (grow != 0) { //流光特效的附着
			ItemGrowIcon[index] = CreateBackDrop(Item[index]);
			BAItemIcon[index] = baseanim.create(ItemGrowIcon[index]);
			DzFrameSetSize(ItemGrowIcon[index],DETAILUI_HERO_ICON_SIZE * resizeX * grow.scale,DETAILUI_HERO_ICON_SIZE * grow.scale);
			DzFrameSetPoint(ItemGrowIcon[index],ANCHOR_CENTER,ItemWAvatar[index],ANCHOR_CENTER,0,0);
			BAItemIcon[index].addSequ(grow.path,grow.max,grow.gap,true);
		}
	}

	//抽离:设置一下货币
	function EItemRes (integer index,integer gold,integer lumber) {
		if (gold > 0) { //能卖钱
			DzFrameSetTexture(ItemWIcon1[index],"ui\\image\\res_gold.blp",0); //出售的价钱图标
			DzFrameSetText(ItemWPrice1[index],FormatLarge(gold)); //出售的价钱
			if (lumber > 0) {
				DzFrameSetTexture(ItemWIcon2[index],"ui\\image\\res_gem.blp",0); //出售的价钱图标
				DzFrameSetText(ItemWPrice2[index],FormatLarge(lumber)); //出售的价钱
			}
		} else if (lumber > 0) { //不能卖钱但是能卖木头
			DzFrameSetTexture(ItemWIcon1[index],"ui\\image\\res_gem.blp",0); //出售的价钱图标
			DzFrameSetText(ItemWPrice1[index],FormatLarge(lumber)); //出售的价钱
			DzFrameShow(ItemWIcon2[index],false);
			DzFrameShow(ItemWPrice2[index],false);
		} else { //什么都卖不了
			DzFrameShow(ItemWIcon1[index],false);
			DzFrameShow(ItemWPrice1[index],false);
			DzFrameShow(ItemWIcon2[index],false);
			DzFrameShow(ItemWPrice2[index],false);
		}
	}

	//抽离:以ItemID创建一个
	function EItem (integer index,integer id,boolean itCon) -> integer {
		integer gold,lumber;
		boolean usable,dropable,sellable;
		string hint = "|cffffa600";
		DetailUIItemO(index,0.18,0,0);

		gold = GetItemGoldCost(id);
		lumber = GetItemGemCost(id);
		usable = GetItemSLKUsable(id);
		dropable = GetItemSLKDroppable(id);
		sellable = GetItemSLKSellable(id);
		//数据的读取设置
		DzFrameSetTexture(ItemWAvatar[index],GetItemSLKArt(id),0);
		EItemRes(index,gold,lumber);
		if (sellable) {
			hint += "可出售/";
			DzFrameSetText(ItemContent[index],"|cffffd000将物品扔在商品以卖出|r");
		}
		if (!dropable) {
			hint += "不可丢弃/";
		}
		if (usable) {
			hint += "消耗品/";
			DzFrameSetText(ItemContent[index],"|cffffd000点击左键使用该物品|r");
		}
		DzFrameSetText(ItemWHint[index],hint); //钱下面的小字
		DzFrameSetText(ItemName[index],GetItemSLKName(id));
		if (itCon) DzFrameSetText(ItemContent2[index],GetItemSLKUbertip(id));

		detailF.result2 = ItemW2[index];
		return ItemContent2[index];
	}
	//创建一个Item的描述(以物品的ID)
	public function DetailUIItemID (integer index,integer id) -> integer {
		return EItem(index,id,true);
	}

	//创建一个Item的描述(以itemdata为主)
	public function DetailUIItemData (integer index,itemdata id) -> integer {
		DetailUIItemO(index,0.18,0,0);

		if (id.trDesc != null) {
			EItem(index,id.iID,false);
			DzFrameSetText(ItemContent2[index],id.getDesc()); //重写一下内容接口
		} else DetailUIItemID(index,id.iID); //物品ID来代理获取

		detailF.result2 = ItemW2[index];
		return ItemContent2[index];
	}
	//创建一个Item的描述(以Item结构体)
	public function DetailUIItem (integer index,items is) -> integer {
		DetailUIItemO(index,0.18,is.star,is.grow);

		//数据的读取设置
		DzFrameSetTexture(ItemWAvatar[index],is.data.getAvatar(),0); //头像不变
		if (is.hRes) { //HOOK了卖的资源
			EItemRes(index,is.gold,is.gem); //默认金与钻(如果涉及其他货币再想办法吧)
		} else EItemRes(index,GetItemGoldCost(is.data.iID),GetItemGemCost(is.data.iID)); //不Hook的情况下用物品的原生价钱
		DzFrameSetText(ItemWHint[index],is.getHint()); //钱下面的小字,并同时返回小提示
		DzFrameSetText(ItemName[index],is.getName()); //涉及到名字
		DzFrameSetText(ItemContent2[index],is.getDesc()); //重写一下内容接口
		DzFrameSetText(ItemContent[index],isdF.content); //在获取hint的时候一并获取中间部分的文字

		isdF.content = null; //这个玩意清空一下,以防干扰下次获取.
		detailF.result2 = ItemW2[index];
		return ItemContent2[index];
	}

	integer Upgrade  = 0;
	integer UpTop    = 0;
	integer UpBottom = 0;
	integer UpRes[];
	integer UpIRes[];
	//升级时的金钱与木头需求小框
	function FUp (integer res1,integer res2,integer res3,string name) -> integer{
		integer index = GetConvertedPlayerId(GetLocalPlayer());
		real resizeX = GetResizeRate();
		string s[];
		integer count = 0;
		integer i;
		integer res[];
		integer pRes[];
		boolean b = true; //是否可以升级

		DetailUIDestroy();
		Upgrade   = CreateToolTips(detailF.parent);
		UpTop     = NewTextL(Upgrade);
		UpBottom  = NewTextL(Upgrade);

		if (res1 > 0) {
			count += 1;
			s[count] = "ui\\image\\res_gold.blp";
			res[count] = res1;
			pRes[count] = pd[index].gold;
		}
		if (res2 > 0) {
			count += 1;
			s[count] = "ui\\image\\res_gem.blp";
			res[count] = res2;
			pRes[count] = pd[index].gem;
		}
		if (res3 > 0) {
			count += 1;
			s[count] = "ui\\image\\res_kill.blp";
			res[count] = res3;
			pRes[count] = pd[index].kill;
		}

		for (1 <= i <= count) {
			UpRes[i]  = NewTextLeftL(Upgrade);
			UpIRes[i] = CreateBackDrop(Upgrade);
			DzFrameSetTexture(UpIRes[i],s[i],0); //设置信息
			DzFrameSetSize(UpIRes[i],0.015,0.015);
			DzFrameSetPoint(UpIRes[i],ANCHOR_RIGHT,UpRes[i],ANCHOR_LEFT,-0.004 * resizeX,0);
			if (pRes[i] < res[i]) { //资源不够
				b = false;
				DzFrameSetText(UpRes[i],"|cffff0000"+I2S(res[i])+"|r");
			} else {
				DzFrameSetText(UpRes[i],"|cff00ff6a"+I2S(res[i])+"|r");
			}
		}
		for (1 <= i <= count) {
			if (i == count) DzFrameSetPoint(UpRes[i],ANCHOR_BOTTOM,UpBottom,ANCHOR_TOP,0.005 * resizeX,0.005); //设置对应关系
			else DzFrameSetPoint(UpRes[i],ANCHOR_BOTTOM,UpRes[i+1],ANCHOR_TOP,0,0.005); //设置对应关系
		}

		DzFrameSetAbsolutePoint(UpBottom,ANCHOR_BOTTOMRIGHT,.786,.1375);
		if (count > 0) DzFrameSetPoint(UpTop,ANCHOR_BOTTOM,UpRes[1],ANCHOR_TOP,-0.005 * resizeX,0.005);
		else DzFrameSetPoint(UpTop,ANCHOR_BOTTOM,UpBottom,ANCHOR_TOP,-0.005 * resizeX,0.005);

		if (b) {
			DzFrameSetText(UpTop,"|cff00ff6a"+ name +"花费:|r");
			DzFrameSetText(UpBottom,"|cff00ff6a点击进行"+ name +"|r");
		} else {
			DzFrameSetText(UpTop,"|cffff0000"+ name +"花费:|r");
			DzFrameSetText(UpBottom,"|cffff0000资源不足,无法"+ name +"|r");
		}

		DzFrameSetPoint(Upgrade,ANCHOR_TOP,UpTop,ANCHOR_TOP,0,0.01);
		DzFrameSetPoint(Upgrade,ANCHOR_BOTTOM,UpBottom,ANCHOR_BOTTOM,0,- 0.01);
		DzFrameSetPoint(Upgrade,ANCHOR_LEFT,UpBottom,ANCHOR_LEFT,- 0.012 * resizeX,0);
		DzFrameSetPoint(Upgrade,ANCHOR_RIGHT,UpBottom,ANCHOR_RIGHT,0.01 * resizeX,0);
		detailF.result2 = UpTop;
		s[1] = null;
		s[2] = null;
		return UpBottom;
	}

	public function DetailUIUpgrade (integer res1,integer res2,integer res3) -> integer{
		return FUp(res1,res2,res3,"升级");
	}
	public function DetailUIMerge (integer res1,integer res2,integer res3) -> integer{
		return FUp(res1,res2,res3,"融合");
	}

	integer Arrow = 0;
	//右箭头
	public function DetailUISymbolArrow (boolean size) -> integer {
		Arrow = CreateBackDrop(detailF.parent);
		if (size) DzFrameSetSize(Arrow,0.07,0.05);
		DzFrameSetTexture(Arrow,"UI\\detail_arrow.blp",0);
		return Arrow;
	}

	#define DUI_SPELL_ICON_SIZE 0.035
	#define DUI_SPELLMINI_ICON_SIZE 0.0175 //来自的图标大小
	#define DUI_MANA_ICON_SIZE 0.012 //魔法
	integer  SpellNum        = 0; //当前的数量
	integer  Spell           [];
	integer  SpellTop        [];
	integer  SpellBottom     [];
	integer  SpellMiddle     [];
	integer  SpellWraper     [];
	integer  SpellWAvatar    [];
	integer  SpellWName      [];
	integer  SpellWLevel     [];
	integer  SpellFromIcon   [];
	integer  SpellFromName   [];
	integer  SpellWraper2    [];
	integer  SpellManaIcon   [];
	integer  SpellMana       [];
	integer  SpellContent    [];
	integer  SpellDivider1   [];
	integer  SpellDivider2   [];
	integer  SpellGrowAva    [];
	baseanim BASpellAvatar   [];
	function DetailUISpellO (integer index,real width,growdata gd,boolean showFrom){
		integer i;
		string s;
		real resizeX = GetResizeRate();
		real fWidth  = width + 0.02 ;    //整体框架的大小

		DetailUIDestroy();
		SpellNum = IMaxBJ(index,SpellNum);

		//创建UI
		Spell[index]         = CreateBackDrop(detailF.parent); //整体Frame
		SpellTop[index]      = CreateBackDrop(Spell[index]);  //上框图片
		SpellBottom[index]   = CreateBackDrop(Spell[index]);  //下框图片
		SpellMiddle[index]   = CreateBackDrop(Spell[index]);  //中框图片
		SpellWraper[index]   = CreateBackDrop(Spell[index]);  //最上方的包裹块
		SpellWAvatar[index]  = CreateBackDrop(Spell[index]);  //技能图标
		SpellWName[index]    = NewTextLeftXL (Spell[index]);  //技能名字
		SpellWLevel[index]   = NewTextLeftXL (Spell[index]);  //技能阵营
		SpellFromIcon[index] = CreateBackDrop(Spell[index]);  //技能来自于
		SpellFromName[index] = NewTextLeftL  (Spell[index]);  //技能来自于
		SpellWraper2[index]  = CreateBackDrop(Spell[index]);  //技能技能包裹块
		SpellManaIcon[index] = CreateBackDrop(Spell[index]);  //蓝耗的图标
		SpellMana[index]     = NewTextLeftML (Spell[index]);  //蓝耗的显示
		SpellContent[index]  = NewTextLeftL  (Spell[index]);  //英雄的小技能名字列表
		SpellDivider1[index] = CreateBackDrop(Spell[index]);  //分割线[名字-天赋]
		SpellDivider2[index] = CreateBackDrop(Spell[index]);  //分割线[天赋-4技能]

		//图片渲染
		DzFrameSetTexture(SpellTop[index],"ui\\tooltips\\BG_DetailTop.tga",0);
		DzFrameSetTexture(SpellBottom[index],"ui\\tooltips\\BG_DetailBottom.tga",0);
		DzFrameSetTexture(SpellMiddle[index],"ui\\tooltips\\BG_DetailMiddle.tga",0);
		DzFrameSetTexture(SpellDivider2[index],"ui\\image\\divider_gray.blp",0);
		DzFrameSetTexture(SpellManaIcon[index],"UI\\Widgets\\ToolTips\\Human\\ToolTipManaIcon.blp",0);

		//设置一下大小
		DzFrameSetSize(Spell[index],0.001,0.001);
		DzFrameSetSize(SpellTop[index],fWidth * resizeX,fWidth * 0.125);
		DzFrameSetSize(SpellBottom[index],fWidth * resizeX,fWidth * 0.125);
		//-------------标题----------------
		DzFrameSetSize(SpellWraper[index],width * resizeX,0.04);
		DzFrameSetSize(SpellWAvatar[index],DUI_SPELL_ICON_SIZE * resizeX,DUI_SPELL_ICON_SIZE);
		//-------------文字内容----------------
		DzFrameSetSize(SpellFromIcon[index],DUI_SPELLMINI_ICON_SIZE * resizeX,DUI_SPELLMINI_ICON_SIZE);
		DzFrameSetSize(SpellManaIcon[index],DUI_MANA_ICON_SIZE * resizeX,DUI_MANA_ICON_SIZE);
		DzFrameSetSize(SpellContent[index],width * 1.0 * resizeX,0);
		//-------------分割线----------------
		DzFrameSetSize(SpellDivider1[index],width * 0.9 * resizeX,0.0008);
		DzFrameSetSize(SpellDivider2[index],width * 0.9 * resizeX,0.0008);

		//设置一下控件的位置[由下向上]
		DzFrameSetAbsolutePoint(SpellContent[index],ANCHOR_BOTTOMRIGHT,.786,.1375);
		DzFrameSetPoint(SpellManaIcon[index],ANCHOR_BOTTOMLEFT,SpellContent[index],ANCHOR_TOPLEFT,0.005 * resizeX,0.005);
		DzFrameSetPoint(SpellMana[index],ANCHOR_LEFT,SpellManaIcon[index],ANCHOR_RIGHT,0.005*resizeX,0);
		DzFrameSetPoint(SpellDivider2[index] ,ANCHOR_BOTTOM,SpellContent[index],ANCHOR_TOP,0,(DUI_MANA_ICON_SIZE + 0.015));
		//-----------------------------
		DzFrameSetPoint(SpellWraper[index],ANCHOR_BOTTOM,SpellDivider2[index],ANCHOR_TOP,0,0.001);
		DzFrameSetPoint(SpellWAvatar[index],ANCHOR_LEFT,SpellWraper[index],ANCHOR_LEFT,0.004 * resizeX,0);
		DzFrameSetPoint(SpellWName[index],ANCHOR_TOP,SpellWraper[index],ANCHOR_TOP,0,- 0.008);
		DzFrameSetPoint(SpellWName[index],ANCHOR_LEFT,SpellWAvatar[index],ANCHOR_RIGHT,0.007 * resizeX,0);
		DzFrameSetPoint(SpellWName[index],ANCHOR_RIGHT,SpellWraper[index],ANCHOR_RIGHT,0,0);
		DzFrameSetPoint(SpellWLevel[index],ANCHOR_TOP,SpellWraper[index],ANCHOR_CENTER,0,- 0.005);
		DzFrameSetPoint(SpellWLevel[index],ANCHOR_BOTTOM,SpellWraper[index],ANCHOR_BOTTOM,0,0);
		DzFrameSetPoint(SpellWLevel[index],ANCHOR_LEFT,SpellWAvatar[index],ANCHOR_RIGHT,0.007 * resizeX,0);
		DzFrameSetPoint(SpellDivider1[index],ANCHOR_BOTTOM,SpellWraper[index],ANCHOR_TOP,0,0.005);
		if (showFrom) { //显示英雄属于谁
			DzFrameSetTexture(SpellDivider1[index],"ui\\image\\divider_gray.blp",0);
			DzFrameSetPoint(SpellFromName[index],ANCHOR_BOTTOM,SpellDivider1[index],ANCHOR_TOP,0.01 * resizeX,0.01);
			DzFrameSetPoint(SpellFromIcon[index],ANCHOR_RIGHT,SpellFromName[index],ANCHOR_LEFT,-0.005*resizeX,0);

			//描述外框的大小
			DzFrameSetPoint(SpellTop[index],ANCHOR_TOP,SpellFromName[index],ANCHOR_TOP,-0.01 * resizeX,0.015);
		} else {  // 不显示英雄属于
			DzFrameSetPoint(SpellTop[index],ANCHOR_TOP,SpellWraper[index],ANCHOR_TOP,0,0.01);
		}
		DzFrameSetPoint(SpellBottom[index],ANCHOR_BOTTOM,SpellContent[index],ANCHOR_BOTTOM,0,-0.01);
		DzFrameSetPoint(SpellMiddle[index],ANCHOR_TOPLEFT,SpellTop[index],ANCHOR_BOTTOMLEFT,0,0);
		DzFrameSetPoint(SpellMiddle[index],ANCHOR_BOTTOMRIGHT,SpellBottom[index],ANCHOR_TOPRIGHT,0,0);

		//流光特效的附着
		if (gd != 0) {
			SpellGrowAva[index] = CreateBackDrop(Spell[index]);
			BASpellAvatar[index] = baseanim.create(SpellGrowAva[index]);
			DzFrameSetSize(SpellGrowAva[index],DUI_SPELL_ICON_SIZE * resizeX * gd.scale,DUI_SPELL_ICON_SIZE * gd.scale);
			DzFrameSetPoint(SpellGrowAva[index],ANCHOR_CENTER,SpellWAvatar[index],ANCHOR_CENTER,0,0);
			BASpellAvatar[index].addSequ(gd.path,gd.max,gd.gap,true);
		}
	}

	//技能的窗口(原始数据)
	public function DetailUISpellData (integer index,spelldata sd,growdata gd,boolean showFrom) -> integer{
		integer cost = sd.getCost();
		DetailUISpellO(index,0.2,gd,showFrom);

		//数据的读取设置
		DzFrameSetTexture(SpellWAvatar[index],sd.getArt(),0);
		DzFrameSetText(SpellWName[index],sd.getColorName());
		DzFrameSetText(SpellWLevel[index],"Lv.1");
		if (showFrom) {
			DzFrameSetTexture(SpellFromIcon[index],sd.from.getAvatar(),0); //来自哪个英雄
			DzFrameSetText(SpellFromName[index],"来自"+sd.from.name+"的"+sd.getPrefixColor()+"["+sd.getHotkey()+"技能]|r");
		}
		if (cost == 0) { //如果是被动技能
			DzFrameClearAllPoints(SpellDivider2[index]);
			DzFrameShow(SpellManaIcon[index],false);
			DzFrameShow(SpellMana[index],false);
			DzFrameSetPoint(SpellDivider2[index] ,ANCHOR_BOTTOM,SpellContent[index],ANCHOR_TOP,0,0.01);
		} else DzFrameSetText(SpellMana[index],"|cff0084ff"+I2S(cost)+"|r");
		DzFrameSetText(SpellContent[index],sd.getDesc());

		return SpellContent[index];
	}

	//技能的窗口(动态数据)
	public function DetailUISpell (integer index,spell s,boolean showFrom) -> integer {
		integer cost = s.getCostResult();
		DetailUISpellO(index,0.2,s.grow,showFrom);

		//数据的读取设置
		DzFrameSetTexture(SpellWAvatar[index],s.data.getArt(),0);
		DzFrameSetText(SpellWName[index],s.data.getColorName());
		DzFrameSetText(SpellWLevel[index],"Lv."+I2S(s.level));
		if (showFrom) {
			DzFrameSetTexture(SpellFromIcon[index],s.data.from.getAvatar(),0); //来自哪个英雄
			DzFrameSetText(SpellFromName[index],"来自"+s.data.from.name+"的"+s.data.getPrefixColor()+"["+s.data.getHotkey()+"技能]|r");
		}
		if (cost == 0) { //如果是被动技能
			DzFrameClearAllPoints(SpellDivider2[index]);
			DzFrameShow(SpellManaIcon[index],false);
			DzFrameShow(SpellMana[index],false);
			DzFrameSetPoint(SpellDivider2[index] ,ANCHOR_BOTTOM,SpellContent[index],ANCHOR_TOP,0,0.01);
		} else DzFrameSetText(SpellMana[index],"|cff0084ff"+I2S(cost)+"|r");
		DzFrameSetText(SpellContent[index],s.getDesc()); //预览在

		return SpellContent[index];
	}


}

//! endzinc
#endif
