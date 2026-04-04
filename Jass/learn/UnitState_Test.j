#ifndef UTUnitStateIncluded
#define UTUnitStateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUnitState requires UnitState {

	// 测试单位
	private unit myPeasant = null;      // 我方农民
	private unit enemyPeasant = null;   // 敌方农民
	private unit testHero = null;       // 测试用英雄
	private unit testFootman = null;    // 测试用步兵

	function Init () {
		player p; player enemyP;  // 局部变量声明在前
		//sdfkjsdjklfslkfslkfdl

		// 创建我方农民（玩家1）以及测试步兵
		p = Player(0);
		myPeasant = CreateUnit(p, 'hpea', 0.0, 0.0, 270.0);
		testFootman = CreateUnit(p, 'hfoo', 200.0, 0.0, 270.0);
		p = null;

		// 创建敌方农民（玩家2）
		enemyP = Player(10);
		enemyPeasant = CreateUnit(enemyP, 'hpea', 500.0, 0.0, 270.0);
		enemyP = null;

		BJDebugMsg("[UnitState] 测试单位已创建：我方农民和敌方农民");
	}

	function TTestUTUnitState1 (player p) {
		unit summonedPeasant; player enemyP; integer pid;  // 局部变量声明在前

		if (myPeasant == null || enemyPeasant == null) {
			BJDebugMsg("[UnitState] 错误：测试单位未初始化");
			return;
		}

		pid = GetConvertedPlayerId(p);
		// 获取敌方玩家（如果当前是玩家1，则敌方是玩家2，否则敌方是玩家1）
		if (pid == 1) {
			enemyP = ConvertedPlayer(11);
		} else {
			enemyP = ConvertedPlayer(1);
		}

		// 召唤敌方农民
		summonedPeasant = CreateUnit(enemyP, 'hpea', GetUnitX(myPeasant) + 200.0, GetUnitY(myPeasant), 270.0);

		// 添加沉默技能 'A02o'
		UnitAddAbility(summonedPeasant, 'A02o');
		UnitAddAbility(myPeasant, 'A02o');

		// 对我方农民释放沉默（852075 是沉默技能 ACsi 的 OrderId）
		IssueTargetOrderById(summonedPeasant, 852075, myPeasant);

		BJDebugMsg("[UnitState] 已召唤敌方农民并对我方农民释放沉默");

		// 清理句柄
		summonedPeasant = null;
		enemyP = null;
	}
	function TTestUTUnitState2 (player p) {}
	function TTestUTUnitState3 (player p) {}
	function TTestUTUnitState4 (player p) {}
	function TTestUTUnitState5 (player p) {}
	function TTestUTUnitState6 (player p) {}
	function TTestUTUnitState7 (player p) {}
	function TTestUTUnitState8 (player p) {}
	function TTestUTUnitState9 (player p) {}
	function TTestUTUnitState10 (player p) {}
	function TTestActUTUnitState1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		integer soundId = 0;						   //武器声音序号
		unit u1 = null;								 //用于临时创建单位
		unit u2 = null;
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

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		} else if (paramS[0] == "createam") {
			if (testHero != null) {
				RemoveUnit(testHero);
			}
			testHero = CreateUnit(p, 'Hamg', 0.0, 0.0, 270.0);
			BJDebugMsg("[UnitState] 大法师创建成功!");

		} else if (paramS[0] == "model") {
			if (testHero != null) {
				DzSetUnitModel(testHero, "units\\nightelf\\HeroDemonHunter\\HeroDemonHunter.mdl");
				DzSetUnitPortrait(testHero, "units\\nightelf\\HeroDemonHunter\\HeroDemonHunter_portrait.mdl");
				BJDebugMsg("[UnitState] 模型改为恶魔猎手");
			}
		} else if (paramS[0] == "modelret") {
			if (testHero != null) {
				DzSetUnitModel(testHero, "units\\human\\HeroArchMage\\HeroArchMage.mdl");
				DzSetUnitPortrait(testHero, "units\\human\\HeroArchMage\\HeroArchMage_portrait.mdl");
				BJDebugMsg("[UnitState] 模型还原为大法师");
			}
		} else if (paramS[0] == "name") {
			if (testHero != null) {
				DzSetUnitName(testHero, "测试法神");
				BJDebugMsg("[UnitState] 英雄名字修改为: 测试法神");
			}
		} else if (paramS[0] == "proper") {
			if (testHero != null) {
				DzSetUnitProperName(testHero, "狂野法师");
				BJDebugMsg("[UnitState] 英雄称谓修改为: 狂野法师");
			}
		} else if (paramS[0] == "missile") {
			if (testHero != null) {
				DzSetUnitMissileModel(testHero, "Abilities\\Weapons\\DemonHunterMissile\\DemonHunterMissile.mdl");
				DzSetUnitMissileSpeed(testHero, 500);
				BJDebugMsg("[UnitState] 投射物改为恶魔猎手飞镖, 速度降低到500");
			}
		} else if (paramS[0] == "missileret") {
			if (testHero != null) {
				DzSetUnitMissileModel(testHero, "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl");
				DzSetUnitMissileSpeed(testHero, 900);
				BJDebugMsg("[UnitState] 投射物还原为水弹(或类似), 速度900");
			}

			// -------获取单位原生属性测试-------
		} else if (paramS[0] == "getsounds") {
			u1 = CreateUnit(p, 'Hpal', -200.0, -200.0, 270.0);
			u2 = CreateUnit(p, 'uaco', -400.0, -200.0, 270.0);

			// 查武器声音 0x22
			soundId = R2I(GetUnitState(u1, ConvertUnitState(0x22)));
			Trace("[UnitState] 圣骑士('Hpal') 武器声音(0x22): " + I2S(soundId));
			soundId = R2I(GetUnitState(u2, ConvertUnitState(0x22)));
			Trace("[UnitState] 侍僧('uaco') 武器声音(0x22): " + I2S(soundId));

			// 查武器类型 0x58
			soundId = R2I(GetUnitState(u1, ConvertUnitState(0x58)));
			Trace("[UnitState] 圣骑士('Hpal') 武器类型(0x58): " + I2S(soundId));
			soundId = R2I(GetUnitState(u2, ConvertUnitState(0x58)));
			Trace("[UnitState] 侍僧('uaco') 武器类型(0x58): " + I2S(soundId));

			// -------步兵武器声音测试-------
		} else if (paramS[0] == "metalchop") {
			if (testFootman != null) {
				// 3 = Metal Heavy Chop
				SetUnitState(testFootman, ConvertUnitState(0x22), 8);
				BJDebugMsg("[UnitState] 步兵攻击声音已修改为: 金属重击 (Metal Heavy Chop / 序号:8)");
			}
		} else if (paramS[0] == "woodbash") {
			if (testFootman != null) {
				// 10 = Wood Light Bash
				SetUnitState(testFootman, ConvertUnitState(0x22), 14);
				BJDebugMsg("[UnitState] 步兵攻击声音已修改为: 木头轻音 (Wood Light Bash / 序号:14)");
			}
		} else if (paramS[0] == "createfoot") {
			// 手动重新创建人族步兵 'hfoo'
			if (testFootman != null) {
				RemoveUnit(testFootman);
			}
			testFootman = CreateUnit(p, 'hfoo', 200.0, 0.0, 270.0);
			BJDebugMsg("[UnitState] 步兵已手动重新创建!");

		} else if (paramS[0] == "weaponsound") {
			// 通过 EXSetUnitInteger 修改单位攻击1的武器声音
			// UNIT_STATE_ATTACK1_WEAPON_SOUND = 0x22
			// WC3 内置声音枚举（部分）:
			//   0  = unk / none
			//   1  = Metal Light Chop
			//   2  = Metal Medium Chop
			//   3  = Metal Heavy Chop
			//   4  = Metal Light Slice
			//   5  = Metal Medium Slice
			//   6  = Metal Heavy Slice
			//   7  = Metal Medium Bash
			//   8  = Metal Heavy Bash
			//   9  = Metal Heavy Crush
			//  10  = Wood Light Bash
			//  11  = Wood Medium Bash
			//  12  = Wood Heavy Bash
			//  13  = Wood Light Slice
			//  14  = Wood Medium Slice
			//  15  = Wood Heavy Slice
			if (testFootman != null) {
				soundId = paramI[1];
				// 使用 SetUnitState + ConvertUnitState，与项目改攻击类型/护甲的方式一致
				// UNIT_STATE_ATTACK1_WEAPON_SOUND = 0x22 = 34
				SetUnitState(testFootman, ConvertUnitState(0x22), I2R(soundId));
				BJDebugMsg("[UnitState] 步兵攻击1声音已修改为序号: " + I2S(soundId) + " (请让步兵攻击来测听)");
			} else {
				BJDebugMsg("[UnitState] 错误：请先用 -createfoot 创建步兵");
			}

			// -------步兵变远程攻击测试-------
		} else if (paramS[0] == "ranged") {
			// 组合：改攻击范围 + 武器类型 + 加弹道模型 → 让步兵"像弓箭手"
			if (testFootman != null) {
				// 攻击1 范围改为 600 (0x16)
				SetUnitState(testFootman, ConvertUnitState(0x16), 600.0);
				// 攻击1 武器类型改为箭矢 5.0 (0x58)
				// (内置约定：1=普通 2=立即 3=炮火 4=炮线 5=箭矢 6=溅射 7=弹射 8=箭线)
				SetUnitState(testFootman, ConvertUnitState(0x58), 5.0);
				// 攻击1 武器声音改为 0.0 (0x22) (0=无声音，去掉刀切声)
				SetUnitState(testFootman, ConvertUnitState(0x22), 0.0);
				// 设置弹道模型（用恶魔猎手飞镖等）
				DzSetUnitMissileModel(testFootman, "Abilities\\Weapons\\DemonHunterMissile\\DemonHunterMissile.mdl");
				DzSetUnitMissileSpeed(testFootman, 800);
				// 同时改攻击范围为 600（保证AI也生效）
				SetUnitAcquireRange(testFootman, 600.0);
				BJDebugMsg("[UnitState] 步兵变远程: 范围600, 武器类型=箭矢(5), 已去除近战音效");
			} else {
				BJDebugMsg("[UnitState] 错误：请先用 -createfoot 创建步兵");
			}

		} else if (paramS[0] == "rangeret") {
			// 还原步兵为近战
			if (testFootman != null) {
				SetUnitState(testFootman, ConvertUnitState(0x16), 90.0);
				// 攻击1 武器类型还原为普通 1.0
				SetUnitState(testFootman, ConvertUnitState(0x58), 1.0);
				// 攻击1 武器声音还原为 7.0 (默认的 Metal Medium Bash，或者你需要的其他音效)
				SetUnitState(testFootman, ConvertUnitState(0x22), 7.0);
				DzSetUnitMissileModel(testFootman, "");
				SetUnitAcquireRange(testFootman, 250.0);
				BJDebugMsg("[UnitState] 步兵还原近战: 范围90, 武器类型=普通(1), 恢复近战音效");
			} else {
				BJDebugMsg("[UnitState] 错误：请先用 -createfoot 创建步兵");
			}

			// 可选：单独测试修改武器类型
		} else if (paramS[0] == "weapontype") {
			if (testFootman != null) {
				SetUnitState(testFootman, ConvertUnitState(0x58), I2R(paramI[1]));
				BJDebugMsg("[UnitState] 步兵武器类型已设置: " + I2S(paramI[1]));
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("|cff00ffff[UnitState] 单元测试已加载|r");
			BJDebugMsg("  |cff00ff00-createam|r (创建测试大法师)");
			BJDebugMsg("  |cffffff00-model|r / |cffffff00-modelret|r (修改/还原模型与头像)");
			BJDebugMsg("  |cffffff00-name|r (修改名字)");
			BJDebugMsg("  |cffffff00-proper|r (修改称谓)");
			BJDebugMsg("  |cffffff00-missile|r / |cffffff00-missileret|r (修改/还原投射物与速度)");
			BJDebugMsg("  |cffffff00-metalchop|r (修改声音为金属重击)");
			BJDebugMsg("  |cffffff00-woodbash|r (修改声音为木头打击)");
			BJDebugMsg("  |cffffff00-weaponsound N|r (或者手动指定声音序号N)");
			BJDebugMsg("  |cffffff00-ranged|r / |cffffff00-rangeret|r (步兵变远程/还原近战，带静音辅助)");
			BJDebugMsg("  |cff00ff00-getsounds|r (创建圣骑士和侍僧，并Trace打印他们的数据)");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitState1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitState1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitState2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitState3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitState4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitState5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitState6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitState7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitState8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitState9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitState10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
