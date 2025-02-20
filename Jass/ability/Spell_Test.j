#ifndef UTSpellIncluded
#define UTSpellIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTSpell requires Spell {


	// 添加全局测试单位变量
	private unit testArchmage = null;
	private unit testFootman = null;

	private unit testSpell = null;
	private spell spSingle = 0;
	private spellData sds[];

	// 用于回调测试的全局变量
	private integer spellDataInitCount = 0;
	private integer spellDataDestroyCount = 0;
	private integer spellDestroyCount = 0;

	function Init () {
		sds[1] = spellData.byType('A001');

		//这是注册点击事件
		unitSelect.onSync(function() {
			//结论:EXGetUnitAbility获取百位动态技能
			//DzUnitFindAbility获取正常Handle技能,未学习的技能没有Handle,学习后的Handle不是最大的(代表不是新建的)
			//AInv这个物品栏技能不知道为什么步兵也有
			//删除再新建后,Handle会变
			unit u = unitSelect.argsSync;
			integer index;
			ability a = null,b = null;
			Trace("已选择单位:" + GetUnitName(u) +"("+I2S(GetHandleId(u)) +")");
			b = DzUnitFindAbility(u, 'AHbz');
			Trace(" AHbz: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHab');
			Trace(" AHab: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHwe');
			Trace(" AHwe: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AHmt');
			Trace(" AHmt: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'AInv');
			Trace(" AInv: " + I2S(GetHandleId(b)));
			b = DzUnitFindAbility(u, 'Adef');
			Trace(" Adef: " + I2S(GetHandleId(b)));
			u = null;
		});

		// 测试1: 回调函数测试
		UnitTestAutoTimer(0.1, 0, function() {
			spellData sd;
			spell sp;
			unit testUnit;

			Trace("开始测试1: spell回调函数测试");

			// 创建测试单位
			testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 0);

			// 创建spellData并注册回调
			sd = spellData.byType('AHbz');
			sd.spellType = SPELL_TYPE_ENTITY;
			sd.maxLevel = 1;

			sd.registerInit(function() {
				spellDataInitCount += 1;
				Trace("spellData初始化回调被调用, 当前计数: " + I2S(spellDataInitCount));
			});

			sd.registerDestroy(function() {
				spellDataDestroyCount += 1;
				Trace("spellData销毁回调被调用, 当前计数: " + I2S(spellDataDestroyCount));
			});

			// 创建spell实例
			sp = spell.entity(testUnit, 'AHbz', 1);

			// 注册spell的销毁回调
			sp.registerDestroy(function() {
				spellDestroyCount += 1;
				Trace("spell销毁回调被调用, 当前计数: " + I2S(spellDestroyCount));
			});

			// 验证初始化回调是否被调用
			assert.Integer(spellDataInitCount, 1, "spellData初始化回调应该被调用一次");

			// 销毁spell实例
			sp.destroy();

			// 验证销毁回调是否被调用
			assert.Integer(spellDataDestroyCount, 1, "spellData销毁回调应该被调用一次");
			assert.Integer(spellDestroyCount, 1, "spell销毁回调应该被调用一次");

			// 清理测试单位
			RemoveUnit(testUnit);
			testUnit = null;
		}, null);
	}

	//测试一下Japi获取的技能
	function TTestUTSpell1 (player p) {
		testArchmage = CreateUnit(p, 'Hamg', 0, 0, 270); // 在(0,0)位置创建大法师
		testFootman = CreateUnit(p, 'hfoo', 200, 0, 270); // 在(200,0)位置创建步兵
		SetHeroLevel(testArchmage, 10, true); // 将大法师升到10级
		Trace("已创建大法师和步兵用于测试");
	}
	function TTestUTSpell2 (player p) {
		if (testFootman != null) {
			UnitRemoveAbility(testFootman, 'Adef'); // 移除防御技能
			Trace("已移除步兵的防御技能");
		} else {
			Trace("错误：请先使用s1创建测试单位");
		}
	}
	function TTestUTSpell3 (player p) {
		if (testFootman != null) {
			UnitAddAbility(testFootman, 'Adef'); // 添加防御技能
			Trace("已给步兵添加防御技能");
		} else {
			Trace("错误：请先使用s1创建测试单位");
		}
	}
	function TTestUTSpell4 (player p) { //测试GetHashValue不会哈希碰撞
		timer t;
		t = CreateTimer();
		SaveInteger(HASH_TIMER, GetHandleId(t), 1, 1);  // 当前测试次数

		// 保存所有技能ID到哈希表中
		SaveInteger(HASH_TIMER, GetHandleId(t), 100, 'AAns');
		SaveInteger(HASH_TIMER, GetHandleId(t), 101, 'ACac');
		SaveInteger(HASH_TIMER, GetHandleId(t), 102, 'ACad');
		SaveInteger(HASH_TIMER, GetHandleId(t), 103, 'ACah');
		SaveInteger(HASH_TIMER, GetHandleId(t), 104, 'ACam');
		SaveInteger(HASH_TIMER, GetHandleId(t), 105, 'ACat');
		SaveInteger(HASH_TIMER, GetHandleId(t), 106, 'ACav');
		SaveInteger(HASH_TIMER, GetHandleId(t), 107, 'ACba');
		SaveInteger(HASH_TIMER, GetHandleId(t), 108, 'ACbb');
		SaveInteger(HASH_TIMER, GetHandleId(t), 109, 'ACbc');
		SaveInteger(HASH_TIMER, GetHandleId(t), 110, 'ACbf');
		SaveInteger(HASH_TIMER, GetHandleId(t), 111, 'ACbh');
		SaveInteger(HASH_TIMER, GetHandleId(t), 112, 'ACbk');
		SaveInteger(HASH_TIMER, GetHandleId(t), 113, 'ACbl');
		SaveInteger(HASH_TIMER, GetHandleId(t), 114, 'ACbn');
		SaveInteger(HASH_TIMER, GetHandleId(t), 115, 'ACbz');
		SaveInteger(HASH_TIMER, GetHandleId(t), 116, 'ACc2');
		SaveInteger(HASH_TIMER, GetHandleId(t), 117, 'ACc3');
		SaveInteger(HASH_TIMER, GetHandleId(t), 118, 'ACca');
		SaveInteger(HASH_TIMER, GetHandleId(t), 119, 'ACcb');
		SaveInteger(HASH_TIMER, GetHandleId(t), 120, 'ACce');
		SaveInteger(HASH_TIMER, GetHandleId(t), 121, 'ACch');
		SaveInteger(HASH_TIMER, GetHandleId(t), 122, 'ACcl');
		SaveInteger(HASH_TIMER, GetHandleId(t), 123, 'ACcn');
		SaveInteger(HASH_TIMER, GetHandleId(t), 124, 'ACcr');
		SaveInteger(HASH_TIMER, GetHandleId(t), 125, 'ACcs');
		SaveInteger(HASH_TIMER, GetHandleId(t), 126, 'ACct');
		SaveInteger(HASH_TIMER, GetHandleId(t), 127, 'ACcv');
		SaveInteger(HASH_TIMER, GetHandleId(t), 128, 'ACcw');
		SaveInteger(HASH_TIMER, GetHandleId(t), 129, 'ACcy');

		TimerStart(t, 0.1, true, function() {
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer testCount = LoadInteger(HASH_TIMER, id, 1);
			integer abilityId;
			unit testUnit;
			integer i;

			if (testCount <= 100) {
				testUnit = CreateUnit(Player(0), 'hfoo', 0, 0, 270);
				Trace("第" + I2S(testCount) + "个单位的测试结果:");

				// 先测试1-5的普通值
				Trace("普通值测试结果:");
				for (1 <= i <= 5) {
					Trace("数值" + I2S(i) + "的HashValue: " + I2S(GetHashValue(GetHandleId(testUnit), i)));
				}

				// 再测试所有技能
				Trace("技能测试结果:");
				for (0 <= i < 30) {
					abilityId = LoadInteger(HASH_TIMER, id, 100 + i);
					Trace("技能" + GetAbilityName(abilityId) + "的HashValue: " + I2S(GetHashValue(GetHandleId(testUnit), abilityId)));
				}

				testCount += 1;
				SaveInteger(HASH_TIMER, id, 1, testCount);
			} else {
				Trace("测试完成！");
				PauseTimer(t);
				FlushChildHashtable(HASH_TIMER, id);
				DestroyTimer(t);
			}
			t = null;
		});
		t = null;
	}

	integer count = 10;
	boolean toggle5 = false;
	function TTestUTSpell5 (player p) {
		integer i;
		unit u;
		group g;
		spell sp1;

		if (toggle5) {
			// 删除模式：遍历所有单位并删除技能实例
			g = CreateGroup();
			GroupEnumUnitsInRect(g, GetPlayableMapRect(), null);
			ForGroup(g, function() {
				unit u = GetEnumUnit();
				spell sp1 = spell.get(u, 'A001');
				if (sp1.isExist()) {
					sp1.destroy();
				}
				u = null;
			});
			DestroyGroup(g);
			g = null;
			Trace("已清理所有技能实例");
		} else {
			// 创建模式：随机创建10-20个带技能的单位
			Trace("准备创建 " + I2S(count) + " 个测试单位");
			for (0 <= i < count) {
				// 在随机位置创建单位
				u = CreateUnit(p, 'nsm1',
				GetRandomReal(-1000, 1000),
				GetRandomReal(-1000, 1000),
				GetRandomReal(0, 360));

				// 创建技能实例
				sp1 = spell.entity(u, 'A001', 1);
				sp1.registerDestroy(function () {
					Trace("技能ID:" + I2S(spell.ethis) + "被销毁了(群)");
				});
				if (sp1.isExist()) {
					Trace("创建第 " + I2S(i + 1) + " 个单位的技能实例成功");
				}
				u = null;
			}
			count -= 1;
			Trace("完成创建测试单位");
		}

		toggle5 = !toggle5;
	}
	function TTestUTSpell6 (player p) {}
	function TTestUTSpell7 (player p) {}
	function TTestUTSpell8 (player p) {}
	function TTestUTSpell9 (player p) {}
	function TTestUTSpell10 (player p) {}
	function TTestActUTSpell1 (string str) {
		player p;
		integer index;
		integer i;
		integer num;
		integer len;
		string paramS[];
		integer paramI[];
		real paramR[];

		p = GetTriggerPlayer();
		index = GetConvertedPlayerId(p);
		num = 0;
		len = StringLength(str);

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

		if (paramS[0] == "a") {
			// 原有的a指令逻辑
		} else if (paramS[0] == "b") {
			// 原有的b指令逻辑
		} else if (paramS[0] == "destroy") {
			// 销毁sp
			if (spSingle != 0) {
				spSingle.destroy();
				spSingle = 0;
				Trace("已销毁技能结构体sp");
			} else {
				Trace("错误：sp已经是空的了");
			}
		} else if (paramS[0] == "new") {
			// 销毁sp
			if (spSingle != 0) {
				spSingle.destroy();
			}
			RemoveUnit(testSpell);
			testSpell = CreateUnit(Player(0),'nsm1',0,0,0);
			spSingle = spell.entity(testSpell,'A001',1);
			spSingle.registerDestroy(function () {
				Trace("技能ID:" + I2S(spell.ethis) + "被销毁了(独)");
			});
			Trace("测试单位创建完成了");
		} else if (paramS[0] == "remove") {
			// 删除testSpell的'A001'技能
			if (testSpell != null) {
				UnitRemoveAbility(testSpell, 'A001');
				Trace("已移除testSpell的A001技能");
			} else {
				Trace("错误：testSpell不存在，请先创建测试单位");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Spell] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTSpell1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTSpell1(GetTriggerPlayer());
			else if(str == "s2") TTestUTSpell2(GetTriggerPlayer());
			else if(str == "s3") TTestUTSpell3(GetTriggerPlayer());
			else if(str == "s4") TTestUTSpell4(GetTriggerPlayer());
			else if(str == "s5") TTestUTSpell5(GetTriggerPlayer());
			else if(str == "s6") TTestUTSpell6(GetTriggerPlayer());
			else if(str == "s7") TTestUTSpell7(GetTriggerPlayer());
			else if(str == "s8") TTestUTSpell8(GetTriggerPlayer());
			else if(str == "s9") TTestUTSpell9(GetTriggerPlayer());
			else if(str == "s10") TTestUTSpell10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
