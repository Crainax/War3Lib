#ifndef UTUIExtendDragIncluded
#define UTUIExtendDragIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

//自动生成的文件
library UTUIExtendDrag requires UIExtendDrag {

	uiBtn btn[];
	uiImage img[];
	integer btnCount = 0;
	integer imgCount = 0;

	function TTestUTUIExtendDrag1 (player p) {
		integer index;

		// 创建新的 img
		imgCount = imgCount + 1;
		index = imgCount;
		img[index] = uiImage.create(DzGetGameUI())
			.exReSize(0.1,0.1)
			.setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0.0, 0.0)
			.setTexture("ReplaceableTextures\\CommandButtons\\BTNHealOn.blp");

		// 创建对应的 btn
		btnCount = btnCount + 1;
		btn[btnCount] = uiBtn.create(img[index].ui)
			.setAllPoint(img[index].ui)
			.enableDrag(img[index].ui,0.1, 0.7, 0.2, 0.5);

		BJDebugMsg("创建了第 " + I2S(index) + " 个 img 和第 " + I2S(btnCount) + " 个 btn");
	}
	function TTestUTUIExtendDrag2 (player p) {
		// 删除所有 UI
		integer i;
		for (1 <= i <= btnCount) {
			if (btn[i] != 0 && btn[i].isExist()) {
				btn[i].destroy();
				btn[i] = 0;
			}
		}
		for (1 <= i <= imgCount) {
			if (img[i] != 0 && img[i].isExist()) {
				img[i].destroy();
				img[i] = 0;
			}
		}
		imgCount = 0;
		btnCount = 0;
		BJDebugMsg("已删除所有 UI");
	}
	function TTestUTUIExtendDrag3 (player p) {}
	function TTestUTUIExtendDrag4 (player p) {}
	function TTestUTUIExtendDrag5 (player p) {}
	function TTestUTUIExtendDrag6 (player p) {}
	function TTestUTUIExtendDrag7 (player p) {}
	function TTestUTUIExtendDrag8 (player p) {}
	function TTestUTUIExtendDrag9 (player p) {}
	function TTestUTUIExtendDrag10 (player p) {}
	function TTestActUTUIExtendDrag1 (string str) {
		player  p	 = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i,	 num = 0, len = StringLength(str); //获取范围式数字
		string  paramS [];							   //所有参数S
		integer paramI [];							   //所有参数I
		real	paramR [];							   //所有参数R
		integer pos;

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

		if (paramS[0] == "list") {
			// 输出当前所有 btn 和 img 数量
			BJDebugMsg("当前 img 数量: " + I2S(imgCount));
			BJDebugMsg("当前 btn 数量: " + I2S(btnCount));
			for (1 <= i <= imgCount) {
				BJDebugMsg("第 " + I2S(i) + " 个 img 位置: " + I2S(img[i]));
			}
		} else if (paramS[0] == "a") {
			// 删除指定位置的 UI
			if (num >= 2) {
				pos = paramI[1];
				if (pos >= 1 && pos <= imgCount && img[pos] != 0 && img[pos].isExist()) {
					img[pos].destroy();
					img[pos] = 0;
					BJDebugMsg("已删除第 " + I2S(pos) + " 个 img");
				} else {
					BJDebugMsg("第 " + I2S(pos) + " 个 img 不存在或已删除");
				}
				if (pos >= 1 && pos <= btnCount && btn[pos] != 0 && btn[pos].isExist()) {
					btn[pos].destroy();
					btn[pos] = 0;
					BJDebugMsg("已删除第 " + I2S(pos) + " 个 btn");
				} else {
					BJDebugMsg("第 " + I2S(pos) + " 个 btn 不存在或已删除");
				}
			} else {
				BJDebugMsg("用法: -a <索引>");
			}
		} else if (paramS[0] == "p") {
			// 设置第 pos 个控件的位置: -p <索引> <x> <y>
			if (num >= 4) {
				pos = paramI[1];
				if (pos >= 1 && pos <= btnCount && btn[pos] != 0 && btn[pos].isExist()) {
					btn[pos].setDragPosition(paramR[2], paramR[3]);
					BJDebugMsg("已设置第 " + I2S(pos) + " 个 btn 位置为 (" + R2S(paramR[2]) + ", " + R2S(paramR[3]) + ")");
				} else {
					BJDebugMsg("第 " + I2S(pos) + " 个 btn 不存在或已删除");
				}
			} else {
				BJDebugMsg("用法: -p <索引> <x> <y>");
			}
		} else if (paramS[0] == "b") {
			// 设置第 pos 个控件的边界: -b <索引> <left> <right> <bottom> <top>
			if (num >= 6) {
				pos = paramI[1];
				if (pos >= 1 && pos <= btnCount && btn[pos] != 0 && btn[pos].isExist()) {
					btn[pos].setDragBounds(paramR[2], paramR[3], paramR[4], paramR[5]);
					BJDebugMsg("已设置第 " + I2S(pos) + " 个 btn 边界");
				} else {
					BJDebugMsg("第 " + I2S(pos) + " 个 btn 不存在或已删除");
				}
			} else {
				BJDebugMsg("用法: -b <索引> <left> <right> <bottom> <top>");
			}
		} else if (paramS[0] == "g") {
			// 获取第 pos 个控件的当前位置: -g <索引>
			if (num >= 2) {
				pos = paramI[1];
				if (pos >= 1 && pos <= btnCount && btn[pos] != 0 && btn[pos].isExist()) {
					BJDebugMsg("第 " + I2S(pos) + " 个 btn 当前坐标: (" + R2S(btn[pos].getDragX()) + ", " + R2S(btn[pos].getDragY()) + ")");
				} else {
					BJDebugMsg("第 " + I2S(pos) + " 个 btn 不存在或已删除");
				}
			} else {
				BJDebugMsg("用法: -g <索引>");
			}
		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[UIExtendDrag] 单元测试已加载");
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUIExtendDrag1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUIExtendDrag1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUIExtendDrag2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUIExtendDrag3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUIExtendDrag4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUIExtendDrag5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUIExtendDrag6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUIExtendDrag7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUIExtendDrag8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUIExtendDrag9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUIExtendDrag10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#endif
