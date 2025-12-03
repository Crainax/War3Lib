#ifndef UTUnitAttrShowIncluded
#define UTUnitAttrShowIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//# dependency:resource/ui/console/unitpanel/yidu_str.blp
//# dependency:resource/ui/console/unitpanel/yidu_agi.blp
//# dependency:resource/ui/console/unitpanel/yidu_int.blp
//# dependency:resource/ui/console/unitpanel/yidu_Atk.blp
//# dependency:resource/ui/console/unitpanel/yidu_Def.blp

#include "japi/YDWEJapiScript.j"


//! zinc

//自动生成的文件
library UTUnitAttrShow requires UnitAttrShow, UnitUtils {


	// 创建普通测试单位
	private function CreateTestUnit(player p) {
		if (testUnit != null) {
			RemoveUnit(testUnit);
		}
		testUnit = CreateUnit(p, 'hfoo', 0, 0, 0);
		InitAllUnitAttr(testUnit);
		SelectUnit(testUnit, true);
		UnitAddAbility(testUnit, 'A02o');
		BJDebugMsg("已创建普通测试单位");
	}

	// 创建英雄测试单位
	private function CreateTestHero(player p) {
		if (testHero != null) {
			RemoveUnit(testHero);
		}
		testHero = CreateUnit(p, 'Hpal', 0, 0, 0);
		InitAllUnitAttr(testHero);
		SelectUnit(testHero, true);
		UnitAddAbility(testHero, 'A02o');
		BJDebugMsg("已创建英雄测试单位");
	}

	function Init () {
		player p;
		p = Player(0);
		BJDebugMsg("=== UnitAttrShow测试系统已加载 ===");
		BJDebugMsg("测试命令说明:");
		BJDebugMsg("-unit : 创建普通测试单位");
		BJDebugMsg("-hero : 创建英雄测试单位");
		BJDebugMsg("-atk [value] : 设置攻击力");
		BJDebugMsg("-addatk [value] : 增加攻击力");
		BJDebugMsg("-atkup [value] : 增加攻击增幅(小数,如0.2=20%)");
		BJDebugMsg("-atkdown [value] : 增加攻击减幅(小数)");
		BJDebugMsg("-atkbonus [value] : 增加攻击定值");
		BJDebugMsg("-def [value] : 设置防御力");
		BJDebugMsg("-adddef [value] : 增加防御力");
		BJDebugMsg("-defup [value] : 增加防御增幅(小数,如0.2=20%)");
		BJDebugMsg("-defdown [value] : 增加防御减幅(小数)");
		BJDebugMsg("-defbonus [value] : 增加防御定值");
		BJDebugMsg("-hp [value] : 设置生命最大值");
		BJDebugMsg("-addhp [value] : 增加生命最大值");
		BJDebugMsg("-hpup [value] : 增加生命增幅(小数,如0.2=20%)");
		BJDebugMsg("-hpdown [value] : 增加生命减幅(小数)");
		BJDebugMsg("-hpbonus [value] : 增加生命定值");
		BJDebugMsg("-mp [value] : 设置魔法最大值");
		BJDebugMsg("-addmp [value] : 增加魔法最大值");
		BJDebugMsg("-mpup [value] : 增加魔法增幅(小数,如0.2=20%)");
		BJDebugMsg("-mpdown [value] : 增加魔法减幅(小数)");
		BJDebugMsg("-mpbonus [value] : 增加魔法定值");
		BJDebugMsg("-str [value] : 设置虚拟力量(英雄)");
		BJDebugMsg("-addstr [value] : 增加虚拟力量(英雄)");
		BJDebugMsg("-strup [value] : 增加虚拟力量增幅(小数,如0.2=20%)");
		BJDebugMsg("-strdown [value] : 增加虚拟力量减幅(小数)");
		BJDebugMsg("-strbonus [value] : 增加虚拟力量定值");
		BJDebugMsg("-agi [value] : 设置虚拟敏捷(英雄)");
		BJDebugMsg("-addagi [value] : 增加虚拟敏捷(英雄)");
		BJDebugMsg("-agiup [value] : 增加虚拟敏捷增幅(小数,如0.2=20%)");
		BJDebugMsg("-agidown [value] : 增加虚拟敏捷减幅(小数)");
		BJDebugMsg("-agibonus [value] : 增加虚拟敏捷定值");
		BJDebugMsg("-int [value] : 设置虚拟智力(英雄)");
		BJDebugMsg("-addint [value] : 增加虚拟智力(英雄)");
		BJDebugMsg("-intup [value] : 增加虚拟智力增幅(小数,如0.2=20%)");
		BJDebugMsg("-intdown [value] : 增加虚拟智力减幅(小数)");
		BJDebugMsg("-intbonus [value] : 增加虚拟智力定值");
		BJDebugMsg("-main [value] : 增加主属性数值");
		BJDebugMsg("-mainup [value] : 增加主属性增幅(小数)");
		BJDebugMsg("-maindown [value] : 增加主属性减幅(小数)");
		BJDebugMsg("-mainbonus [value] : 增加主属性定值");
		BJDebugMsg("-sub [value] : 增加次属性数值");
		BJDebugMsg("-subup [value] : 增加次属性增幅(小数)");
		BJDebugMsg("-subdown [value] : 增加次属性减幅(小数)");
		BJDebugMsg("-subbonus [value] : 增加次属性定值");
		BJDebugMsg("-maintype [0/1/2] : 设置主属性类型(0=力,1=敏,2=智)");
		BJDebugMsg("-invul : 添加无敌状态");
		BJDebugMsg("-noinvul : 移除无敌状态");
		BJDebugMsg("-magic : 添加魔免状态");
		BJDebugMsg("-nomagic : 移除魔免状态");
		BJDebugMsg("-silence : 添加沉默状态");
		BJDebugMsg("-nosilence : 移除沉默状态");

		// 自动创建测试单位
		UnitTestAutoTimer(0.1, 0, function() {
			CreateTestUnit(Player(0));
			CreateTestHero(Player(0));
		}, null);

		// 在 (2000, 2000) 位置创建玩家11的英雄和步兵，方便测试沉默
		UnitTestAutoTimer(0.2, 0, function() {
			player enemyP; unit enemyUnit; unit enemyHero;
			enemyP = Player(11);
			// 创建敌方步兵
			enemyUnit = CreateUnit(enemyP, 'hfoo', 2000.0, 2000.0, 270.0);
			InitAllUnitAttr(enemyUnit);
			// 创建敌方英雄
			enemyHero = CreateUnit(enemyP, 'Hpal', 2000.0, 2050.0, 270.0);
			InitAllUnitAttr(enemyHero);
			BJDebugMsg("已在 (2000, 2000) 位置创建玩家11的步兵和英雄，用于测试沉默");
			enemyUnit = null;
			enemyHero = null;
			enemyP = null;
		}, null);

		p = null;
	}

	private unit testUnit = null;
	private unit testHero = null;

	function TTestUTUnitAttrShow1 (player p) {
		CreateTestUnit(p);
	}

	function TTestUTUnitAttrShow2 (player p) {
		CreateTestHero(p);
	}

	function TTestUTUnitAttrShow3 (player p) {
		//unitAttrShow
	}
	function TTestUTUnitAttrShow4 (player p) {}
	function TTestUTUnitAttrShow5 (player p) {}
	function TTestUTUnitAttrShow6 (player p) {}
	function TTestUTUnitAttrShow7 (player p) {}
	function TTestUTUnitAttrShow8 (player p) {}
	function TTestUTUnitAttrShow9 (player p) {}
	function TTestUTUnitAttrShow10 (player p) {}

	function TTestActUTUnitAttrShow1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		unit    u;
		integer currentStr;
		integer currentAgi;
		integer currentInt;
		boolean removed;
		integer defBonusValue;
		integer mainType;

		// 解析参数
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

		// 获取当前选中的单位
		u = unitSelect.currentU[index];
		if (u == null) {
			BJDebugMsg("请先选择一个单位");
			p = null;
			return;
		}

		// 创建单位命令
		if (paramS[0] == "unit") {
			CreateTestUnit(p);
			p = null;
			return;
		} else if (paramS[0] == "hero") {
			CreateTestHero(p);
			p = null;
			return;
		}

		// 攻击力相关命令
		if (paramS[0] == "atk") {
			// 设置攻击力
			if (num >= 2) {
				SetUnitAttack(u, ParseReal(paramS[1]));
				BJDebugMsg("设置攻击力为: " + FormatNumber(ParseReal(paramS[1])));
			}
		} else if (paramS[0] == "addatk") {
			// 增加攻击力
			if (num >= 2) {
				AddUnitAttack(u, ParseReal(paramS[1]));
				BJDebugMsg("增加攻击力: " + FormatNumber(ParseReal(paramS[1])));
				BJDebugMsg("当前攻击力: " + FormatNumber(GetUnitAttack(u)));
			}
		} else if (paramS[0] == "atkup") {
			// 增加攻击增幅
			if (num >= 2) {
				AddUnitAttackUpPercent(u, paramR[1]);
				BJDebugMsg("增加攻击增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前攻击倍率: " + R2S(GetUnitAttackFinalPercent(u)));
				BJDebugMsg("当前攻击力: " + FormatNumber(GetUnitAttack(u)));
			}
		} else if (paramS[0] == "atkdown") {
			// 增加攻击减幅
			if (num >= 2) {
				AddUnitAttackDownPercent(u, paramR[1]);
				BJDebugMsg("增加攻击减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前攻击倍率: " + R2S(GetUnitAttackFinalPercent(u)));
				BJDebugMsg("当前攻击力: " + FormatNumber(GetUnitAttack(u)));
			}
		} else if (paramS[0] == "atkbonus") {
			// 增加攻击定值
			if (num >= 2) {
				AddUnitAttackBonus(u, paramR[1]);
				BJDebugMsg("增加攻击定值: " + FormatNumber(paramR[1]));
				BJDebugMsg("当前攻击力: " + FormatNumber(GetUnitAttack(u)));
			}
		}
		// 防御力相关命令
		else if (paramS[0] == "def") {
			// 设置防御力
			if (num >= 2) {
				SetUnitDefense(u, paramR[1]);
				BJDebugMsg("设置防御力为: " + R2S(paramR[1]));
			}
		} else if (paramS[0] == "adddef") {
			// 增加防御力
			if (num >= 2) {
				AddUnitDefense(u, paramR[1]);
				BJDebugMsg("增加防御力: " + R2S(paramR[1]));
				BJDebugMsg("当前防御力: " + R2S(GetUnitDefense(u)));
			}
		} else if (paramS[0] == "defup") {
			// 增加防御增幅
			if (num >= 2) {
				AddUnitDefenseUpPercent(u, paramR[1]);
				BJDebugMsg("增加防御增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前防御倍率: " + R2S(GetUnitDefenseFinalPercent(u)));
				BJDebugMsg("当前防御力: " + R2S(GetUnitDefense(u)));
			}
		} else if (paramS[0] == "defdown") {
			// 增加防御减幅
			if (num >= 2) {
				AddUnitDefenseDownPercent(u, paramR[1]);
				BJDebugMsg("增加防御减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前防御倍率: " + R2S(GetUnitDefenseFinalPercent(u)));
				BJDebugMsg("当前防御力: " + R2S(GetUnitDefense(u)));
			}
		} else if (paramS[0] == "defbonus") {
			// 增加防御定值
			if (num >= 2) {
				defBonusValue = R2I(paramR[1]);
				AddUnitDefenseBonus(u, defBonusValue);
				BJDebugMsg("增加防御定值: " + I2S(defBonusValue));
				BJDebugMsg("当前防御力: " + R2S(GetUnitDefense(u)));
			}
		}
		// 生命值相关命令
		else if (paramS[0] == "hp") {
			// 设置生命最大值
			if (num >= 2) {
				SetUnitHP(u, ParseReal(paramS[1]));
				BJDebugMsg("设置生命最大值为: " + FormatNumber(ParseReal(paramS[1])));
				BJDebugMsg("当前生命最大值: " + FormatNumber(GetUnitHP(u)));
			}
		} else if (paramS[0] == "addhp") {
			// 增加生命最大值
			if (num >= 2) {
				AddUnitHP(u, ParseReal(paramS[1]));
				BJDebugMsg("增加生命最大值: " + FormatNumber(ParseReal(paramS[1])));
				BJDebugMsg("当前生命最大值: " + FormatNumber(GetUnitHP(u)));
			}
		} else if (paramS[0] == "hpup") {
			// 增加生命增幅
			if (num >= 2) {
				AddUnitHPUpPercent(u, paramR[1]);
				BJDebugMsg("增加生命增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前生命倍率: " + R2S(GetUnitHPFinalPercent(u)));
				BJDebugMsg("当前生命最大值: " + FormatNumber(GetUnitHP(u)));
			}
		} else if (paramS[0] == "hpdown") {
			// 增加生命减幅
			if (num >= 2) {
				AddUnitHPDownPercent(u, paramR[1]);
				BJDebugMsg("增加生命减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前生命倍率: " + R2S(GetUnitHPFinalPercent(u)));
				BJDebugMsg("当前生命最大值: " + FormatNumber(GetUnitHP(u)));
			}
		} else if (paramS[0] == "hpbonus") {
			// 增加生命定值
			if (num >= 2) {
				AddUnitHPBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加生命定值: " + FormatNumber(ParseReal(paramS[1])));
				BJDebugMsg("当前生命最大值: " + FormatNumber(GetUnitHP(u)));
			}
		}
		// 魔法值相关命令
		else if (paramS[0] == "mp") {
			// 设置魔法最大值
			if (num >= 2) {
				SetUnitMP(u, paramR[1]);
				BJDebugMsg("设置魔法最大值为: " + FormatNumber(paramR[1]));
				BJDebugMsg("当前魔法最大值: " + FormatNumber(GetUnitMP(u)));
			}
		} else if (paramS[0] == "addmp") {
			// 增加魔法最大值
			if (num >= 2) {
				AddUnitMP(u, paramR[1]);
				BJDebugMsg("增加魔法最大值: " + FormatNumber(paramR[1]));
				BJDebugMsg("当前魔法最大值: " + FormatNumber(GetUnitMP(u)));
			}
		} else if (paramS[0] == "mpup") {
			// 增加魔法增幅
			if (num >= 2) {
				AddUnitMPUpPercent(u, paramR[1]);
				BJDebugMsg("增加魔法增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前魔法倍率: " + R2S(GetUnitMPFinalPercent(u)));
				BJDebugMsg("当前魔法最大值: " + FormatNumber(GetUnitMP(u)));
			}
		} else if (paramS[0] == "mpdown") {
			// 增加魔法减幅
			if (num >= 2) {
				AddUnitMPDownPercent(u, paramR[1]);
				BJDebugMsg("增加魔法减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前魔法倍率: " + R2S(GetUnitMPFinalPercent(u)));
				BJDebugMsg("当前魔法最大值: " + FormatNumber(GetUnitMP(u)));
			}
		} else if (paramS[0] == "mpbonus") {
			// 增加魔法定值
			if (num >= 2) {
				AddUnitMPBonus(u, paramR[1]);
				BJDebugMsg("增加魔法定值: " + FormatNumber(paramR[1]));
				BJDebugMsg("当前魔法最大值: " + FormatNumber(GetUnitMP(u)));
			}
		}
		// 虚拟三维属性相关命令（BigInteger 英雄）
		else if (paramS[0] == "str") {
			if (num >= 2) {
				SetUnitStr(u, ParseReal(paramS[1]));
				BJDebugMsg("设置虚拟力量基础值为: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟力量: " + R2S(GetUnitStr(u)));
			}
		} else if (paramS[0] == "addstr") {
			if (num >= 2) {
				AddUnitStr(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟力量基础值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟力量: " + R2S(GetUnitStr(u)));
			}
		} else if (paramS[0] == "strup") {
			if (num >= 2) {
				AddUnitStrUpPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟力量增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟力量倍率: " + R2S(GetUnitStrFinalPercent(u)));
			}
		} else if (paramS[0] == "strdown") {
			if (num >= 2) {
				AddUnitStrDownPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟力量减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟力量倍率: " + R2S(GetUnitStrFinalPercent(u)));
			}
		} else if (paramS[0] == "strbonus") {
			if (num >= 2) {
				AddUnitStrBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟力量定值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟力量: " + R2S(GetUnitStr(u)));
			}
		} else if (paramS[0] == "agi") {
			if (num >= 2) {
				SetUnitAgi(u, ParseReal(paramS[1]));
				BJDebugMsg("设置虚拟敏捷基础值为: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟敏捷: " + R2S(GetUnitAgi(u)));
			}
		} else if (paramS[0] == "addagi") {
			if (num >= 2) {
				AddUnitAgi(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟敏捷基础值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟敏捷: " + R2S(GetUnitAgi(u)));
			}
		} else if (paramS[0] == "agiup") {
			if (num >= 2) {
				AddUnitAgiUpPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟敏捷增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟敏捷倍率: " + R2S(GetUnitAgiFinalPercent(u)));
			}
		} else if (paramS[0] == "agidown") {
			if (num >= 2) {
				AddUnitAgiDownPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟敏捷减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟敏捷倍率: " + R2S(GetUnitAgiFinalPercent(u)));
			}
		} else if (paramS[0] == "agibonus") {
			if (num >= 2) {
				AddUnitAgiBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟敏捷定值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟敏捷: " + R2S(GetUnitAgi(u)));
			}
		} else if (paramS[0] == "int") {
			if (num >= 2) {
				SetUnitInt(u, ParseReal(paramS[1]));
				BJDebugMsg("设置虚拟智力基础值为: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟智力: " + R2S(GetUnitInt(u)));
			}
		} else if (paramS[0] == "addint") {
			if (num >= 2) {
				AddUnitInt(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟智力基础值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟智力: " + R2S(GetUnitInt(u)));
			}
		} else if (paramS[0] == "intup") {
			if (num >= 2) {
				AddUnitIntUpPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟智力增幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟智力倍率: " + R2S(GetUnitIntFinalPercent(u)));
			}
		} else if (paramS[0] == "intdown") {
			if (num >= 2) {
				AddUnitIntDownPercent(u, paramR[1]);
				BJDebugMsg("增加虚拟智力减幅: " + R2S(paramR[1]));
				BJDebugMsg("当前虚拟智力倍率: " + R2S(GetUnitIntFinalPercent(u)));
			}
		} else if (paramS[0] == "intbonus") {
			if (num >= 2) {
				AddUnitIntBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加虚拟智力定值: " + R2S(ParseReal(paramS[1])));
				BJDebugMsg("当前虚拟智力: " + R2S(GetUnitInt(u)));
			}
		}
		// 主 / 次属性相关命令
		else if (paramS[0] == "main") {
			if (num >= 2) {
				AddUnitMainAttrValue(u, ParseReal(paramS[1]));
				BJDebugMsg("增加主属性数值: " + R2S(ParseReal(paramS[1])));
			}
		} else if (paramS[0] == "mainup") {
			if (num >= 2) {
				AddUnitMainAttrUpPercent(u, paramR[1]);
				BJDebugMsg("增加主属性增幅: " + R2S(paramR[1]));
			}
		} else if (paramS[0] == "maindown") {
			if (num >= 2) {
				AddUnitMainAttrDownPercent(u, paramR[1]);
				BJDebugMsg("增加主属性减幅: " + R2S(paramR[1]));
			}
		} else if (paramS[0] == "mainbonus") {
			if (num >= 2) {
				AddUnitMainAttrBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加主属性定值: " + R2S(ParseReal(paramS[1])));
			}
		} else if (paramS[0] == "sub") {
			if (num >= 2) {
				AddUnitSubAttrValue(u, ParseReal(paramS[1]));
				BJDebugMsg("增加次属性数值: " + R2S(ParseReal(paramS[1])));
			}
		} else if (paramS[0] == "subup") {
			if (num >= 2) {
				AddUnitSubAttrUpPercent(u, paramR[1]);
				BJDebugMsg("增加次属性增幅: " + R2S(paramR[1]));
			}
		} else if (paramS[0] == "subdown") {
			if (num >= 2) {
				AddUnitSubAttrDownPercent(u, paramR[1]);
				BJDebugMsg("增加次属性减幅: " + R2S(paramR[1]));
			}
		} else if (paramS[0] == "subbonus") {
			if (num >= 2) {
				AddUnitSubAttrBonus(u, ParseReal(paramS[1]));
				BJDebugMsg("增加次属性定值: " + R2S(ParseReal(paramS[1])));
			}
		} else if (paramS[0] == "maintype") {
			if (num >= 2) {
				SetUnitMainAttrType(u, paramI[1]);
				mainType = GetUnitMainAttrType(u);
				BJDebugMsg("当前主属性类型: " + I2S(mainType));
			}
		}
		// 无敌相关命令
		else if (paramS[0] == "invul") {
			// 添加无敌技能
			if (GetUnitAbilityLevel(u, 'Avul') == 0) {
				UnitAddAbility(u, 'Avul');
				BJDebugMsg("已添加无敌状态");
			} else {
				BJDebugMsg("单位已经有无敌状态");
			}
		} else if (paramS[0] == "noinvul") {
			// 移除无敌技能
			if (GetUnitAbilityLevel(u, 'Avul') > 0) {
				UnitRemoveAbility(u, 'Avul');
				BJDebugMsg("已移除无敌状态");
			} else {
				BJDebugMsg("单位没有无敌状态");
			}
		}
		// 魔免相关命令
		else if (paramS[0] == "magic") {
			// 添加魔免技能（优先使用 Amim，如果没有则使用 MAGIC_IMMUNITY_SPELL_ID）
			if (GetUnitAbilityLevel(u, 'Amim') == 0 && GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) == 0) {
				UnitAddAbility(u, 'Amim');
				BJDebugMsg("已添加魔免状态");
			} else {
				BJDebugMsg("单位已经有魔免状态");
			}
		} else if (paramS[0] == "nomagic") {
			// 移除魔免技能
			removed = false;
			if (GetUnitAbilityLevel(u, 'Amim') > 0) {
				UnitRemoveAbility(u, 'Amim');
				removed = true;
			}
			if (GetUnitAbilityLevel(u, MAGIC_IMMUNITY_SPELL_ID) > 0) {
				UnitRemoveAbility(u, MAGIC_IMMUNITY_SPELL_ID);
				removed = true;
			}
			if (removed) {
				BJDebugMsg("已移除魔免状态");
			} else {
				BJDebugMsg("单位没有魔免状态");
			}
		}

		u = null;
		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitAttrShow] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttrShow1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitAttrShow1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitAttrShow2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitAttrShow3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitAttrShow4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitAttrShow5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitAttrShow6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitAttrShow7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitAttrShow8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitAttrShow9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitAttrShow10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
