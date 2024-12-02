#ifndef UTUITextIncluded
#define UTUITextIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

/*
* UIText组件测试文件
* 测试命令说明：
* s1 - 测试创建文本并设置基本属性
* s2 - 测试文本对齐方式(9种对齐方式)
* s3 - 测试文本内容设置
* s4 - 测试文本销毁还有大量创建删除
* s5 - 测试UI移动,还有到边界的显示情况
* -align <数字> - 设置当前文本对齐方式(0-8)
* -text <文本> - 设置当前文本内容
* -destroy - 销毁当前文本和自动测试计时器
*/
library UTUIText requires UIText {

	private uiText currentText = 0; // 当前操作的文本对象
	private timer playerTimers[]; // 每个玩家的计时器

	// 在library UTUIText的开头添加这些全局变量
	private struct TestData {
		integer count;        // 当前文本数量
		integer operationCount;   // 操作次数
		static uiText texts[];    // 存储文本数组，假设最多100个
	}
	private TestData playerTestData[16];  // 每个玩家的测试数据

	// 测试基本创建和属性设置
	function TTestUTUIText1 (player p) {
		if (GetLocalPlayer() == p) {
			currentText = uiText.create(DzGetGameUI())
				.setPoint(ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,currentText.id*0.01,currentText.id*0.01)
				.setText("这是一个测试文本"+I2S(currentText.id));
			BJDebugMsg("创建了一个文本UI，使用标准字体大小");
		}

	}

	// 测试文本对齐
	function TTestUTUIText2 (player p) {
		timer t;

		if (GetLocalPlayer() == p) {
			// 创建文本并设置位置和大小
			currentText = uiText.create(DzGetGameUI())
				.setAllPoint(DzGetGameUI())
				.setText("测试对齐方式\n当前对齐: 左上\n每秒切换一次对齐方式");
		}

		// 创建计时器循环切换对齐方式
		t = CreateTimer();
		SaveInteger(HASH_TIMER, GetHandleId(t), 1, 0); // 保存当前对齐方式索引
		TimerStart(t, 1.0, true, function() {
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer alignIndex = LoadInteger(HASH_TIMER, id, 1);
			string alignName = "";

			// 循环切换9种对齐方式
			alignIndex = ModuloInteger(alignIndex + 1, 9);
			SaveInteger(HASH_TIMER, id, 1, alignIndex);

			if (currentText != 0) {
				currentText.setAlign(alignIndex);

				// 更新对齐方式说明文本
				if (alignIndex == 0) alignName = "左上";
				else if (alignIndex == 1) alignName = "顶部居中";
				else if (alignIndex == 2) alignName = "右上";
				else if (alignIndex == 3) alignName = "左中";
				else if (alignIndex == 4) alignName = "居中";
				else if (alignIndex == 5) alignName = "右中";
				else if (alignIndex == 6) alignName = "左下";
				else if (alignIndex == 7) alignName = "底部居中";
				else if (alignIndex == 8) alignName = "右下";

				currentText.setText("测试对齐方式\n当前对齐: " + alignName + I2S(alignIndex) + "\n每秒切换一次对齐方式");
			}

			alignName = null;
			t = null;
		});

		BJDebugMsg("创建了一个文本UI，将自动切换对齐方式");
		BJDebugMsg("使用-destroy命令可以停止演示");

		t = null;
	}

	// 测试文本内容设置
	function TTestUTUIText3 (player p) {
		timer t;

		// 创建文本并设置位置和大小
		currentText = uiText.create(DzGetGameUI())
		.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0, 0)
		.setText("测试字体大小\n当前大小: 标准(4)\n每秒切换一次大小");

		// 创建计时器循环切换字体大小
		t = CreateTimer();
		SaveInteger(HASH_TIMER, GetHandleId(t), 1, 4); // 保存当前字体大小索引，从4(标准)开始
		TimerStart(t, 1.0, true, function() {
			timer t = GetExpiredTimer();
			integer id = GetHandleId(t);
			integer sizeIndex = LoadInteger(HASH_TIMER, id, 1);
			string sizeName = "";

			// 在1-7之间循环切换字体大小
			sizeIndex = ModuloInteger(sizeIndex, 7) + 1;
			SaveInteger(HASH_TIMER, id, 1, sizeIndex);

			if (currentText != 0) {
				currentText.setFontSize(sizeIndex);

				// 更新字体大小说明文本
				if (sizeIndex == 1) sizeName = "迷你";
				else if (sizeIndex == 2) sizeName = "特小";
				else if (sizeIndex == 3) sizeName = "小";
				else if (sizeIndex == 4) sizeName = "标准";
				else if (sizeIndex == 5) sizeName = "中";
				else if (sizeIndex == 6) sizeName = "大";
				else if (sizeIndex == 7) sizeName = "特大";

				currentText.setText("测试字体大小\n当前大小: " + sizeName + "(" + I2S(sizeIndex) + ")\n每秒切换一次大小");
			}

			sizeName = null;
			t = null;
		});

		BJDebugMsg("创建了一个文本UI，将自动切换字体大小");
		BJDebugMsg("使用-destroy命令可以停止演示");

		t = null;
	}

	// 测试大量创建和销毁,ID回收机制,支持异步了
	function TTestUTUIText4 (player p) {
		timer t;
		integer index = GetConvertedPlayerId(p);

		// 如果该玩家已有计时器在运行，先停止它
		if (playerTimers[index] != null) {
			PauseTimer(playerTimers[index]);
			DestroyTimer(playerTimers[index]);
		}

		// 重置该玩家的测试数据
		playerTestData[index] = TestData.create();
		t = CreateTimer();
		playerTimers[index] = t;

		TimerStart(t, 0.1, true, function() {
			timer t = GetExpiredTimer();
			integer i;
			player p;
			integer index;
			TestData data;
			real randX;
			real randY;
			uiText tempText;
			integer randomIndex;

			// 通过计时器找到对应的玩家
			for (0 <= i < 16) {
				if (playerTimers[i] == t) {
					index = i;
					p = Player(i - 1);
					break;
				}
			}

			data = playerTestData[index];

			// 50%概率创建新的uitext
			if (GetRandomInt(0, 1) == 0) {
				randX = GetRandomReal(-0.2, 0.2);
				randY = GetRandomReal(-0.2, 0.2);

				if (GetLocalPlayer() == p) {
					tempText = uiText.create(DzGetGameUI())
						.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, randX, randY);

					data.texts[data.count] = tempText;
					data.count += 1;
					tempText.setText("序号:" + I2S(tempText.id) + "\nTotal:" + I2S(data.count));
				}


				// 50%概率删除一个已存在的uitext
			} else if (data.count > 0) {
				if (GetLocalPlayer() == p) {
					randomIndex = ILimit(data.count/2,0,data.count);
					tempText = data.texts[randomIndex];

					if (tempText != 0) {
						tempText.destroy();
					}

					// 整理数组
					data.count -= 1;
					if (randomIndex < data.count) {
						data.texts[randomIndex] = data.texts[data.count];
					}
					data.texts[data.count] = 0;
				}

			}

			if (GetLocalPlayer() == p) {
				// 更新操作次数
				data.operationCount += 1;

				// 每100次操作输出一次统计信息
				if (ModuloInteger(data.operationCount, 100) == 0) {
					DisplayTimedTextToPlayer(p, 0, 0, 10, "===统计信息===");
					DisplayTimedTextToPlayer(p, 0, 0, 10, "总操作次数: " + I2S(data.operationCount));
					DisplayTimedTextToPlayer(p, 0, 0, 10, "当前文本数: " + I2S(data.count));
				}
			}



			p = null;
			t = null;
		});

		DisplayTimedTextToPlayer(p, 0, 0, 10, "开始自动测试UIText创建和销毁");
		DisplayTimedTextToPlayer(p, 0, 0, 10, "使用-destroy命令可以停止测试");
		DisplayTimedTextToPlayer(p, 0, 0, 10, "每100次操作会输出一次统���信息");

		t = null;
	}

	private uiText anchorTxt = 0;
	//测试大量ID创建删除
	function TTestUTUIText5 (player p) {
		timer t;
		integer index = GetConvertedPlayerId(p);

		// 如果该玩家已有计时器在运行，先停止它
		if (playerTimers[index] != null) {
			PauseTimer(playerTimers[index]);
			DestroyTimer(playerTimers[index]);
		}

		anchorTxt = uiText.create(DzGetGameUI())
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, -0.1)
			.setAlign(1)
			.setText("锚点文本");

		// 创建文本UI
		if (GetLocalPlayer() == p) {
			currentText = uiText.create(DzGetGameUI())
				.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, -0.5, 0)
				.setText("移动的文本");
		}

		// 创建计时器控制移动
		t = CreateTimer();
		playerTimers[index] = t;

		// 保存移动方向 (1为向右, -1为向左)
		SaveInteger(HASH_TIMER, GetHandleId(t), 0, 1);
		// 保存当前X坐标
		SaveReal(HASH_TIMER, GetHandleId(t), 1, -0.5);
		SaveInteger(HASH_TIMER, GetHandleId(t), 2, 1);

		TimerStart(t, 0.03, true, function() {
			timer t = GetExpiredTimer();
			integer direction = LoadInteger(HASH_TIMER, GetHandleId(t), 0);
			real currentX = LoadReal(HASH_TIMER, GetHandleId(t), 1);
			integer anchors = LoadInteger(HASH_TIMER, GetHandleId(t), 2);

			// 更新位置
			currentX = currentX + 0.01 * direction;

			// 检查边界并改变方向
			if (currentX >= 0.5) {
				direction = -1;
				currentX = 0.5;
			} else if (currentX <= -0.5) {
				direction = 1;
				currentX = -0.5;
			}

			if (anchors == 1) {
				SaveInteger(HASH_TIMER, GetHandleId(t), 2, 0);
			} else {
				SaveInteger(HASH_TIMER, GetHandleId(t), 2, 1);
			}

			// 保存新的状态
			SaveInteger(HASH_TIMER, GetHandleId(t), 0, direction);
			SaveReal(HASH_TIMER, GetHandleId(t), 1, currentX);

			// 更新文本位置
			if (currentText != 0) {
				if (anchors == 1) {
					currentText.setPoint(ANCHOR_CENTER, anchorTxt.ui, ANCHOR_CENTER, currentX, 0);
				} else {
					currentText.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, currentX, 0);
				}
			}

			t = null;
		});

		DisplayTextToPlayer(p, 0, 0, "开始测试文本UI横向移动");
		DisplayTextToPlayer(p, 0, 0, "使用-destroy命令可以停止测试");

		t = null;
	}

	// 保留空函数以维持原有架构
	function TTestUTUIText6 (player p) {}
	function TTestUTUIText7 (player p) {}
	function TTestUTUIText8 (player p) {}
	function TTestUTUIText9 (player p) {}
	function TTestUTUIText10 (player p) {}

	// 处理命令参数
	function TTestActUTUIText1 (string str) {
		player  p     = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,    num = 0, len = StringLength(str);
		string  paramS [];
		integer paramI [];
		real    paramR [];


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

		// 命令处理
		if (paramS[0] == "align") {
			if (currentText != 0) {
				currentText.setAlign(paramI[0])
				.setText("当前对齐: " + paramS[0]);
				BJDebugMsg("设置对齐方式为: " + paramS[0]);
			}
		} else if (paramS[0] == "text") {
			if (currentText != 0) {
				currentText.setText(paramS[1]);
				BJDebugMsg("设置文本内容为: " + paramS[1]);
			}
		} else if (paramS[0] == "destroy") {
			BJDebugMsg("停止");
			if (currentText != 0) {
				currentText.destroy();
				currentText = 0;
				BJDebugMsg("销毁当前文本UI");
			}
			// 停止并清理计时器和测试数据
			if (playerTimers[index] != null) {
				PauseTimer(playerTimers[index]);
				DestroyTimer(playerTimers[index]);
				playerTimers[index] = null;
				TestData.destroy(playerTestData[index]);
				DisplayTextToPlayer(p, 0, 0, "停止自动测试");
			}
		} else if (paramS[0] == "size") {
			if (currentText != 0) {
				currentText.setFontSize(paramI[1]);
				BJDebugMsg("设置字体大小为: " + I2S(paramI[1]) + " (1=迷你,2=特小,3=小,4=标准,5=中,6=大,7=特大)");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.5秒后加载
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIText] 单元测试已加载");
			BJDebugMsg("使用s1-s5测试不同功能");
			BJDebugMsg("-align <0-8> 设置对齐");
			BJDebugMsg("-text <内容> 设置文本");
			BJDebugMsg("-destroy 销毁文本");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;


		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIText1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIText1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIText2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIText3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIText4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIText5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIText6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIText7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIText8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIText9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIText10(GetTriggerPlayer());
		});
	}
}
//! endzinc

#endif
