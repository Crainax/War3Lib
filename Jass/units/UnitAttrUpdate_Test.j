#ifndef UTUnitAttrUpdateIncluded
#define UTUnitAttrUpdateIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc


// 依赖的资源
//# dependency:resource/ui/console/unitpanel/origin_agi.blp
//# dependency:resource/ui/console/unitpanel/origin_armor.blp
//# dependency:resource/ui/console/unitpanel/origin_attack.blp
//# dependency:resource/ui/console/unitpanel/origin_int.blp
//# dependency:resource/ui/console/unitpanel/origin_str.blp

//自动生成的文件
library UTUnitAttrUpdate requires UnitAttrUpdate {

	unitAttr uaSelect = 0;
	heroAttr haSelect = 0;
	function Init () {
		player p = Player(0);
		unit u = null;
		unitSelect.onSync(function() {
			unit u = unitSelect.argsSync;
			uaSelect = unitAttr.get(u);
			haSelect = heroAttr.get(u);
			u = null;
		});

		u = CreateUnit(p, 'Hmkg', 0, 0, 0);
		heroAttr.parse(u,MAIN_ATTR_STR); // 山丘之王:结构体化
		unitAttr.parse(u);
		u = CreateUnit(p, 'Edem', 0, 0, 0);
		heroAttr.parse(u,MAIN_ATTR_AGI); // 恶魔猎手:结构体化
		unitAttr.parse(u);
		u = CreateUnit(p, 'Hamg', 0, 0, 0);
		heroAttr.parse(u,MAIN_ATTR_INT); // 大魔法师:结构体化
		unitAttr.parse(u);
		u = CreateUnit(p, 'hfoo', 0, 0, 0); // 步兵:结构体化
		unitAttr.parse(u); // 使用步兵作为测试单位
		u = CreateUnit(p, 'nchg', 0, 0, 0); // 无结构化的兽族步兵
		u = CreateUnit(p, 'Ocb2', 0, 0, 0); // 牛头人酋长:无结构化
		u = CreateUnit(p, 'Emoo', 0, 0, 0); // 月之女祭司:无结构化
		u = CreateUnit(p, 'Hkal', 0, 0, 0); // 血魔法师:无结构化


		u = null;
		//InitUnitAttrUpdate
	}

	function TTestUTUnitAttrUpdate1 (player p) {}
	function TTestUTUnitAttrUpdate2 (player p) {}
	function TTestUTUnitAttrUpdate3 (player p) {}
	function TTestUTUnitAttrUpdate4 (player p) {}
	function TTestUTUnitAttrUpdate5 (player p) {}
	function TTestUTUnitAttrUpdate6 (player p) {}
	function TTestUTUnitAttrUpdate7 (player p) {}
	function TTestUTUnitAttrUpdate8 (player p) {}
	function TTestUTUnitAttrUpdate9 (player p) {}
	function TTestUTUnitAttrUpdate10 (player p) {}
	function TTestActUTUnitAttrUpdate1 (string str) {
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

		if (haSelect.isExist()) {
			if (paramS[0] == "str") {
				haSelect.setBaseStr(paramR[1]);
				BJDebugMsg("设置力量英雄基础力量为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addstr") {
				haSelect.addBaseStr(paramR[1]);
				BJDebugMsg("增加力量英雄基础力量: " + R2S(paramR[1]));
			} else if (paramS[0] == "strup") {
				haSelect.addStrRateUp(paramR[1]);
				BJDebugMsg("设置力量英雄力量增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "strdown") {
				haSelect.addStrRateDown(paramR[1]);
				BJDebugMsg("设置力量英雄力量减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "strbonus") {
				haSelect.addStrFixedBonus(paramR[1]);
				BJDebugMsg("设置力量英雄力量固定加成为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addstrbonus") {
				haSelect.addStrFixedBonus(paramR[1]);
				BJDebugMsg("增加力量英雄力量固定加成: " + R2S(paramR[1]));
			}
			// 敏捷相关命令
			else if (paramS[0] == "agi") {
				haSelect.setBaseAgi(paramR[1]);
				BJDebugMsg("设置英雄基础敏捷为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addagi") {
				haSelect.addBaseAgi(paramR[1]);
				BJDebugMsg("增加英雄基础敏捷: " + R2S(paramR[1]));
			} else if (paramS[0] == "agiup") {
				haSelect.addAgiRateUp(paramR[1]);
				BJDebugMsg("设置英雄敏捷增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "agidown") {
				haSelect.addAgiRateDown(paramR[1]);
				BJDebugMsg("设置英雄敏捷减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "agibonus") {
				haSelect.addAgiFixedBonus(paramR[1]);
				BJDebugMsg("设置英雄敏捷固定加成为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addagibonus") {
				haSelect.addAgiFixedBonus(paramR[1]);
				BJDebugMsg("增加英雄敏捷固定加成: " + R2S(paramR[1]));
			}
			// 智力相关命令
			else if (paramS[0] == "int") {
				haSelect.setBaseInt(paramR[1]);
				BJDebugMsg("设置英雄基础智力为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addint") {
				haSelect.addBaseInt(paramR[1]);
				BJDebugMsg("增加英雄基础智力: " + R2S(paramR[1]));
			} else if (paramS[0] == "intup") {
				haSelect.addIntRateUp(paramR[1]);
				BJDebugMsg("设置英雄智力增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "intdown") {
				haSelect.addIntRateDown(paramR[1]);
				BJDebugMsg("设置英雄智力减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "intbonus") {
				haSelect.addIntFixedBonus(paramR[1]);
				BJDebugMsg("设置英雄智力固定加成为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addintbonus") {
				haSelect.addIntFixedBonus(paramR[1]);
				BJDebugMsg("增加英雄智力固定加成: " + R2S(paramR[1]));
			}
			// 主属性相关命令
			else if (paramS[0] == "mainup") {
				haSelect.addMainAttrRateUp(paramR[1]);
				BJDebugMsg("设置力量英雄主属性增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "maindown") {
				haSelect.addMainAttrRateDown(paramR[1]);
				BJDebugMsg("设置力量英雄主属性减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "mainbonus") {
				haSelect.addMainAttrFixedBonus(paramR[1]);
				BJDebugMsg("设置力量英雄主属性固定加成为: " + R2S(paramR[1]));
			}
			// 次属性相关命令
			else if (paramS[0] == "subup") {
				haSelect.addSubAttrRateUp(paramR[1]);
				BJDebugMsg("设置力量英雄次属性增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "subdown") {
				haSelect.addSubAttrRateDown(paramR[1]);
				BJDebugMsg("设置力量英雄次属性减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "subbonus") {
				haSelect.addSubAttrFixedBonus(paramR[1]);
				BJDebugMsg("设置力量英雄次属性固定加成为: " + R2S(paramR[1]));
			}
			// 主属性基础值相关命令
			else if (paramS[0] == "mainadd") {
				haSelect.addMainAttrBase(paramR[1]);
				BJDebugMsg("增加力量英雄主属性基础值: " + R2S(paramR[1]));
			}
			// 次属性基础值相关命令
			else if (paramS[0] == "subadd") {
				haSelect.addSubAttrBase(paramR[1]);
				BJDebugMsg("增加力量英雄次属性基础值: " + R2S(paramR[1]));
			}
			// 切换主属性命令
			else if (paramS[0] == "switch") {
				if (paramI[1] >= 0 && paramI[1] <= 2) {
					haSelect.switchMainAttr(paramI[1]);
					BJDebugMsg("切换主属性类型为: " + I2S(paramI[1]));
				} else {
					BJDebugMsg("无效的主属性类型,请使用0(力量),1(敏捷),2(智力)");
				}
			}
		}

		if (uaSelect.isExist()) {
			// HP相关命令
			if (paramS[0] == "addhp") {
				// 增加基础HP
				uaSelect.addHP(paramR[1]);
				BJDebugMsg("增加基础HP: " + R2S(paramR[1]));
			} else if (paramS[0] == "hpup") {
				// 设置HP增幅
				uaSelect.addHPRateUp(paramR[1]);
				BJDebugMsg("设置HP增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "hpdown") {
				// 设置HP减幅
				uaSelect.addHPRateDown(paramR[1]);
				BJDebugMsg("设置HP减幅为: " + R2S(paramR[1]));
			}
			// MP相关命令
			else if (paramS[0] == "addmp") {
				// 增加基础MP
				uaSelect.addMP(paramR[1]);
				BJDebugMsg("增加基础MP: " + R2S(paramR[1]));
			} else if (paramS[0] == "mpup") {
				// 设置MP增幅
				uaSelect.addMPRateUp(paramR[1]);
				BJDebugMsg("设置MP增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "mpdown") {
				// 设置MP减幅
				uaSelect.addMPRateDown(paramR[1]);
				BJDebugMsg("设置MP减幅为: " + R2S(paramR[1]));
			}
			// 攻击力相关命令
			else if (paramS[0] == "atk") {
				// 设置基础攻击力
				uaSelect.setBaseAtk(paramR[1]);
				BJDebugMsg("设置基础攻击力为: " + R2S(paramR[1]));
			} else if (paramS[0] == "addatk") {
				// 增加基础攻击力
				uaSelect.addBaseAtk(paramR[1]);
				BJDebugMsg("增加基础攻击力: " + R2S(paramR[1]));
			} else if (paramS[0] == "atkup") {
				// 设置攻击力增幅
				uaSelect.addAtkRateUp(paramR[1]);
				BJDebugMsg("设置攻击力增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "atkdown") {
				// 设置攻击力减幅
				uaSelect.addAtkRateDown(paramR[1]);
				BJDebugMsg("设置攻击力减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "atkbonus") {
				// 设置固定加成
				uaSelect.addAtkFixedBonus(paramR[1]);
				BJDebugMsg("设置固定加成为: " + R2S(paramR[1]));
			}
			// 防御力相关命令
			else if (paramS[0] == "def") {
				// 设置基础防御力
				uaSelect.setBaseDef(paramR[1]);
				BJDebugMsg("设置基础防御力为: " + R2S(paramR[1]));
			} else if (paramS[0] == "adddef") {
				// 增加基础防御力
				uaSelect.addBaseDef(paramR[1]);
				BJDebugMsg("增加基础防御力: " + R2S(paramR[1]));
			} else if (paramS[0] == "defup") {
				// 设置防御力增幅
				uaSelect.addDefRateUp(paramR[1]);
				BJDebugMsg("设置防御力增幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "defdown") {
				// 设置防御力减幅
				uaSelect.addDefRateDown(paramR[1]);
				BJDebugMsg("设置防御力减幅为: " + R2S(paramR[1]));
			} else if (paramS[0] == "defbonus") {
				// 设置固定加成
				uaSelect.addDefFixedBonus(paramR[1]);
				BJDebugMsg("设置防御力固定加成为: " + R2S(paramR[1]));
			}
		}
		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UnitAttrUpdate] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitAttrUpdate1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitAttrUpdate1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitAttrUpdate2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitAttrUpdate3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitAttrUpdate4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitAttrUpdate5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitAttrUpdate6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitAttrUpdate7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitAttrUpdate8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitAttrUpdate9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitAttrUpdate10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
