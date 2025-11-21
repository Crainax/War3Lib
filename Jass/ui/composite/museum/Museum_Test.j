#ifndef UTMuseumIncluded
#define UTMuseumIncluded

// 用原始地图测试
#undef OriginMapUnitTestMode

//! zinc

// 自动生成的文件
#define TEST_ALBUM_TOTAL          16
#define ALBUM_A_SUBBTN_COUNT      5
#define ALBUM_A_SUBBTN_WIDTH      0.07
#define ALBUM_A_SUBBTN_HEIGHT     0.024
#define ALBUM_A_SUBBTN_INDICATOR_WIDTH     0.016
#define ALBUM_A_SUBBTN_GAP_X      0.010
#define ALBUM_A_SUBBTN_OFFSET_Y  -0.015
#define ALBUM_A_SUBBTN_SELECTED_SCALE 1.12
#define ALBUM_A_SUBBTN_FONT_NORMAL    6
#define ALBUM_A_SUBBTN_FONT_SELECTED  7

#define ALBUM_A_ICON_COLS         12
#define ALBUM_A_ICON_ROWS         6
#define ALBUM_A_ICON_GAP_X        0.005
#define ALBUM_A_ICON_GAP_Y        0.005
#define ALBUM_A_ICON_START_Y     -0.065
#define ALBUM_A_ICON_SIZE         0.030
#define ALBUM_A_ICON_MAX         (ALBUM_A_ICON_COLS * ALBUM_A_ICON_ROWS)

#define ALBUM_A_PAGE_TEXT_OFFSET_Y 0.015
#define ALBUM_A_PAGE_BTN_SIZE      0.02
#define ALBUM_A_PAGE_BTN_OFFSET_X  0.03

#define ALBUM_A_SEARCH_ICON_OFFSET_X 0.020
#define ALBUM_A_SEARCH_ICON_OFFSET_Y 0.020
#define ALBUM_A_SEARCH_ICON_SIZE     0.022
#define ALBUM_A_SEARCH_EDIT_OFFSET_X 0.040
#define ALBUM_A_SEARCH_EDIT_OFFSET_Y 0.020
#define ALBUM_A_SEARCH_BOX_WIDTH     0.04
#define ALBUM_A_SEARCH_BOX_HEIGHT    0.03

//# dependency:resource/ui/image/arrow_down_101x72.blp
//# dependency:resource/ui/image/select_left.blp
//# dependency:resource/ui/image/select_right.blp
//# dependency:resource/ui/image/museum_search.blp

library UTMuseum requires Museum,Keyboard,UIEditbox,Icon {

	private struct albumAUI [] {
		private static uiImage   contentArea = 0;
		private static uiImage   tabBg[];
		private static uiBtn     tabBtn[];
		private static uiText    tabLabel[];
		private static uiImage   subTabIndicator = 0; // 指示当前选中的子按钮
		private static real      tabPosX[];
		private static string    tabNames[];
		private static integer   tabCounts[];
		private static integer   currentIdx = 0;
		private static integer   lastIdx = 0;

		private static icon      iconSlots[];
		private static integer   iconSlotValue[];
		private static integer   totalCount = 0;
		private static integer   page = 1;
		private static integer   pageCount = 1;

		private static uiText    pageText = 0;
		private static uiImage   pagePrevImage = 0;
		private static uiBtn     pagePrevBtn = 0;
		private static uiImage   pageNextImage = 0;
		private static uiBtn     pageNextBtn = 0;

		private static uiImage   searchIcon = 0;
		private static uiEditbox searchBox = 0;
		private static integer   searchLevel = 1;

		private static method ensureData() {
			if (tabNames[1] != null) { return; }
			tabNames[1] = "|cff00ff00普通品质|r";
			tabNames[2] = "|cff00ccff稀有品质|r";
			tabNames[3] = "|cffff00ff史诗品质|r";
			tabNames[4] = "|cffff9900传说品质|r";
			tabNames[5] = "|cffff0000神话品质|r";

			tabCounts[1] = 12;
			tabCounts[2] = 36;
			tabCounts[3] = 48;
			tabCounts[4] = 65;
			tabCounts[5] = 75;
		}

		private static method getParent() -> uiImage {
			contentArea = museumUI.getContentArea();
			return contentArea;
		}


		private static method refreshIcons() {
			integer perPage; integer startIdx; integer endIdx; integer i; integer actual;
			if (currentIdx < 1 || currentIdx > ALBUM_A_SUBBTN_COUNT) {
				currentIdx = 1;
			}
			totalCount = tabCounts[currentIdx];
			perPage = ALBUM_A_ICON_COLS * ALBUM_A_ICON_ROWS;
			if (perPage <= 0) { perPage = 1; }
			pageCount = (totalCount + perPage - 1) / perPage;
			if (pageCount <= 0) { pageCount = 1; }

			if (page > pageCount) { page = pageCount; }
			if (page < 1) { page = 1; }

			startIdx = (page - 1) * perPage + 1;
			endIdx = startIdx + perPage - 1;
			if (endIdx > totalCount) { endIdx = totalCount; }

			for (1 <= i <= ALBUM_A_ICON_MAX) {
				actual = startIdx + i - 1;
				if (actual <= endIdx) {
					iconSlotValue[i] = actual;
					iconSlots[i].setTexture("ReplaceableTextures\\CommandButtons\\BTNSell.blp")
						.show(true);
				} else {
					iconSlotValue[i] = 0;
					iconSlots[i].show(false);
				}
			}

			if (pageCount > 1) {
				pageText.setText("第 " + I2S(page) + "/" + I2S(pageCount) + " 页")
					.show(true);
				pagePrevImage.show(true);
				pageNextImage.show(true);
			} else {
				pageText.show(false);
				pagePrevImage.show(false);
				pageNextImage.show(false);
			}
		}

		private static method changePage(integer delta) {
			if (pageCount <= 1) { return; }
			page += delta;
			if (page < 1) { page = pageCount; }
			if (page > pageCount) { page = 1; }
			albumAUI.refreshIcons();
		}

		private static method createTabs() {
			integer i;
			real totalWidth;
			real startX;
			real posX;

			totalWidth = ALBUM_A_SUBBTN_COUNT * ALBUM_A_SUBBTN_WIDTH + (ALBUM_A_SUBBTN_COUNT - 1) * ALBUM_A_SUBBTN_GAP_X;
			startX = 0.0 - totalWidth / 2.0 + ALBUM_A_SUBBTN_WIDTH / 2.0;

			for (1 <= i <= ALBUM_A_SUBBTN_COUNT) {
				posX = startX + (i - 1) * (ALBUM_A_SUBBTN_WIDTH + ALBUM_A_SUBBTN_GAP_X);
				tabPosX[i] = posX;

				tabBg[i] = uiImage.create(contentArea.ui)
					.exReSize(ALBUM_A_SUBBTN_WIDTH, ALBUM_A_SUBBTN_HEIGHT)
					.setTexture("ui\\image\\select_flash.blp")
					.exRePoint(ANCHOR_TOP, contentArea.ui, ANCHOR_TOP, posX, ALBUM_A_SUBBTN_OFFSET_Y);

				tabBtn[i] = uiBtn.create(tabBg[i].ui)
					.setAllPoint(tabBg[i].ui)
					.spEnter(function(integer frame) {
						music[MUSIC_INDEX_BTN_OVER_1].play();
					})
					.spClick(function(integer frame) {
						integer idx;
						idx = uiHashTable(frame).eventdata.get();
						music[MUSIC_INDEX_BTN_CLICK].play();
						albumAUI.selectTab(idx, true);
					});
				uiHashTable(tabBtn[i].ui).eventdata.bind(i);

				tabLabel[i] = uiText.create(tabBg[i].ui)
					.setAllPoint(tabBg[i].ui)
					.setAlign(4)
					.setFontSize(ALBUM_A_SUBBTN_FONT_NORMAL)
					.setText(tabNames[i]);
			}

			// 创建子按钮的选中指示箭头（初始隐藏，比例与左侧 Tab 一致，高度使用子按钮高度）
			if (subTabIndicator == 0) {
				subTabIndicator = uiImage.create(contentArea.ui)
					.exReSize(ALBUM_A_SUBBTN_INDICATOR_WIDTH , ALBUM_A_SUBBTN_INDICATOR_WIDTH * 101.0 / 72.0)
					.setTexture("ui\\image\\arrow_down_101x72.blp")
					.exRePoint(ANCHOR_BOTTOM, tabBg[1].ui, ANCHOR_TOP, 0.0, 0.002);
				subTabIndicator.show(false);
			}
		}

		private static method createIconSlots() {
			integer i; integer col; integer row;
			real totalWidth; real startX; real posX; real posY;
			real stepX; real stepY;

			totalWidth = ALBUM_A_ICON_COLS * ALBUM_A_ICON_SIZE + (ALBUM_A_ICON_COLS - 1) * ALBUM_A_ICON_GAP_X;
			startX = 0.0 - totalWidth / 2.0 + ALBUM_A_ICON_SIZE / 2.0;
			stepX = ALBUM_A_ICON_SIZE + ALBUM_A_ICON_GAP_X;
			stepY = ALBUM_A_ICON_SIZE + ALBUM_A_ICON_GAP_Y;

			for (1 <= i <= ALBUM_A_ICON_MAX) {
				col = ModuloInteger(i - 1, ALBUM_A_ICON_COLS);
				row = (i - 1) / ALBUM_A_ICON_COLS;
				posX = startX + col * stepX;
				posY = ALBUM_A_ICON_START_Y - row * stepY;

				iconSlots[i] = icon.create(contentArea.ui)
					.enableResize()
					.setSize(ALBUM_A_ICON_SIZE, ALBUM_A_ICON_SIZE)
					.setTexture("ui\\image\\select_flash.blp")
					.setPoint(ANCHOR_TOP, contentArea.ui, ANCHOR_TOP, posX, posY)
					.show(false);

				iconSlots[i].getClickBtn()
					.spClick(function(integer frame) {
						integer slot; integer actual; integer cat;
						slot = uiHashTable(frame).eventdata.get();
						actual = albumAUI.iconSlotValue[slot];
						if (actual > 0) {
							cat = albumAUI.currentIdx;
							BJDebugMsg("[图鉴A] " + albumAUI.tabNames[cat] + " 分类 点击条目 #" + I2S(actual));
						}
					});
				uiHashTable(iconSlots[i].getClickBtn().ui).eventdata.bind(i);
			}
		}

		private static method createFooter() {
			pageText = uiText.create(contentArea.ui)
				.setAlign(4)
				.setFontSize(6)
				.setPoint(ANCHOR_BOTTOM, contentArea.ui, ANCHOR_BOTTOM, 0.0, ALBUM_A_PAGE_TEXT_OFFSET_Y)
				.show(false);

			pagePrevImage = uiImage.create(contentArea.ui)
				.exReSize(ALBUM_A_PAGE_BTN_SIZE, ALBUM_A_PAGE_BTN_SIZE)
				.setTexture("ui\\image\\select_left.blp")
				.exRePoint(ANCHOR_RIGHT, pageText.ui, ANCHOR_LEFT, -ALBUM_A_PAGE_BTN_OFFSET_X, 0.0)
				.show(false);

			pagePrevBtn = uiBtn.create(pagePrevImage.ui)
				.setAllPoint(pagePrevImage.ui)
				.spEnter(function(integer frame) {
					if (albumAUI.pageCount > 1) {
						music[MUSIC_INDEX_BTN_OVER_1].play();
					}
				})
				.spClick(function(integer frame) {
					albumAUI.changePage(-1);
				});

			pageNextImage = uiImage.create(contentArea.ui)
				.exReSize(ALBUM_A_PAGE_BTN_SIZE, ALBUM_A_PAGE_BTN_SIZE)
				.setTexture("ui\\image\\select_right.blp")
				.exRePoint(ANCHOR_LEFT, pageText.ui, ANCHOR_RIGHT, ALBUM_A_PAGE_BTN_OFFSET_X, 0.0)
				.show(false);

			pageNextBtn = uiBtn.create(pageNextImage.ui)
				.setAllPoint(pageNextImage.ui)
				.spEnter(function(integer frame) {
					if (albumAUI.pageCount > 1) {
						music[MUSIC_INDEX_BTN_OVER_1].play();
					}
				})
				.spClick(function(integer frame) {
					albumAUI.changePage(1);
				});

			searchIcon = uiImage.create(contentArea.ui)
				.exReSize(ALBUM_A_SEARCH_ICON_SIZE, ALBUM_A_SEARCH_ICON_SIZE)
				.setTexture("ui\\image\\museum_search.blp")
				.exRePoint(ANCHOR_LEFT, contentArea.ui, ANCHOR_BOTTOMLEFT, ALBUM_A_SEARCH_ICON_OFFSET_X, ALBUM_A_SEARCH_ICON_OFFSET_Y);

			searchBox = uiEditbox.create(contentArea.ui)
				.setSize(ALBUM_A_SEARCH_BOX_WIDTH, ALBUM_A_SEARCH_BOX_HEIGHT)
				.setFontSize(4)
				.setPoint(ANCHOR_LEFT, contentArea.ui, ANCHOR_BOTTOMLEFT, ALBUM_A_SEARCH_EDIT_OFFSET_X, ALBUM_A_SEARCH_EDIT_OFFSET_Y)
				.setText("1");
		}

		private static method selectTab(integer idx, boolean triggerRefresh) {
			integer i; real scale;
			if (idx == currentIdx && !triggerRefresh) { return; }

			currentIdx = idx;
			lastIdx = idx;

			for (1 <= i <= ALBUM_A_SUBBTN_COUNT) {
				if (tabBg[i] != 0) {
					scale = R3(i == currentIdx, ALBUM_A_SUBBTN_SELECTED_SCALE, 1.0);
					tabBg[i].exReSize(ALBUM_A_SUBBTN_WIDTH * scale, ALBUM_A_SUBBTN_HEIGHT * scale)
						.exRePoint(ANCHOR_TOP, contentArea.ui, ANCHOR_TOP, tabPosX[i], ALBUM_A_SUBBTN_OFFSET_Y);
					if (tabLabel[i] != 0) {
						tabLabel[i].setFontSize(I3(i == currentIdx, ALBUM_A_SUBBTN_FONT_SELECTED, ALBUM_A_SUBBTN_FONT_NORMAL));
					}
				}
			}

			// 将指示箭头移动到当前选中的子按钮顶部中央
			if (subTabIndicator != 0 && currentIdx >= 1 && currentIdx <= ALBUM_A_SUBBTN_COUNT && tabBg[currentIdx] != 0) {
				subTabIndicator.exRePoint(ANCHOR_BOTTOM, tabBg[currentIdx].ui, ANCHOR_TOP, 0.0, 0.002);
				subTabIndicator.show(true);
			} else if (subTabIndicator != 0) {
				subTabIndicator.show(false);
			}

			page = I3(page < 1, 1, page);
			if (triggerRefresh) {
				albumAUI.refreshIcons();
			}
		}

		public static method init() {
			if (albumAUI.getParent() == 0) { return; }
			albumAUI.ensureData();
			if (tabBg[1] == 0) {
				albumAUI.createTabs();
			}
			if (iconSlots[1] == 0) {
				albumAUI.createIconSlots();
			}
			if (pageText == 0) {
				albumAUI.createFooter();
			}
			if (lastIdx < 1 || lastIdx > ALBUM_A_SUBBTN_COUNT) {
				lastIdx = 1;
			}
			albumAUI.selectTab(lastIdx, true);
		}

		public static method destroy1() {
			integer i;

			for (1 <= i <= ALBUM_A_SUBBTN_COUNT) {
				if (tabBtn[i] != 0) { tabBtn[i].destroy(); tabBtn[i] = 0; }
				if (tabLabel[i] != 0) { tabLabel[i].destroy(); tabLabel[i] = 0; }
				if (tabBg[i] != 0) { tabBg[i].destroy(); tabBg[i] = 0; }
			}
			if (subTabIndicator != 0) { subTabIndicator.destroy(); subTabIndicator = 0; }

			for (1 <= i <= ALBUM_A_ICON_MAX) {
				if (iconSlots[i] != 0) {
					iconSlots[i].destroy();
					iconSlots[i] = 0;
				}
				iconSlotValue[i] = 0;
			}

			if (pageText != 0) { pageText.destroy(); pageText = 0; }
			if (pagePrevBtn != 0) { pagePrevBtn.destroy(); pagePrevBtn = 0; }
			if (pagePrevImage != 0) { pagePrevImage.destroy(); pagePrevImage = 0; }
			if (pageNextBtn != 0) { pageNextBtn.destroy(); pageNextBtn = 0; }
			if (pageNextImage != 0) { pageNextImage.destroy(); pageNextImage = 0; }

			if (searchBox != 0) { searchBox.destroy(); searchBox = 0; }
			if (searchIcon != 0) { searchIcon.destroy(); searchIcon = 0; }

			contentArea = 0;
			page = 1;
			pageCount = 1;
			totalCount = 0;
			currentIdx = 0;
		}
	}

	// 初始化若干测试用的图鉴 Tab（添加到 TEST_ALBUM_TOTAL 个）
	function InitTabs() {
		museumData md[]; integer i; string title;

		for (1 <= i <= TEST_ALBUM_TOTAL) {
			if (i == 1) {
				title = "查询装备";
			} else {
				title = "测试图鉴" + I2S(i);
			}

			md[i] = museumData.registerAlbum(title);
			if (i == 1) {
				md[i].registerClick(function () -> boolean {
					museumData cur;
					cur = museumData.getCallbackData();
					albumAUI.init();
					return true;
				});
				md[i].registerClose(function () -> boolean {
					museumData cur;
					cur = museumData.getCallbackData();
					albumAUI.destroy1();
					return true;
				});
			} else {
				md[i].registerClick(function () -> boolean {
					museumData cur;
					cur = museumData.getCallbackData();
					BJDebugMsg("[Museum] 打开: " + cur.name);
					return true;
				});
				md[i].registerClose(function () -> boolean {
					museumData cur;
					cur = museumData.getCallbackData();
					BJDebugMsg("[Museum] 关闭: " + cur.name);
					return true;
				});
			}
		}
	}

	function Init () {
		UnitTestAutoTimer(0.1, 2.0, function() {
			//start,这里是0.1秒后调用的内容
			}, function() {
			//end,这里是2秒后调用的内容
		});
		UnitTestAutoTimer(0.1, 2.0, function() {
			//assert.Boolean(true, "测试1");
		},null);

		// 初始化测试用的图鉴 Tab
		InitTabs();

		// 注册 F2 按键，用于切换博物馆 UI 的开启/关闭
		keyboard.regKeyDownEvent(KEY_F2, function (){
			player lp;
			lp = GetLocalPlayer();

			if (!museumUI.isShow()) {
				museumUI.show(lp);
			} else {
				museumUI.hide(lp);
			}

			lp = null;
		});
		keyboard.regKeyUpEvent(KEY_F2, null);

	}

	function TTestUTMuseum1 (player p) {

	}
	function TTestUTMuseum2 (player p) {
		// 保留空实现（原来用于 s2：关闭），现在主要通过 F2 切换
	}
	function TTestUTMuseum3 (player p) {}
	function TTestUTMuseum4 (player p) {}
	function TTestUTMuseum5 (player p) {}
	function TTestUTMuseum6 (player p) {}
	function TTestUTMuseum7 (player p) {}
	function TTestUTMuseum8 (player p) {}
	function TTestUTMuseum9 (player p) {}
	function TTestUTMuseum10 (player p) {}
	function TTestActUTMuseum1 (string str) {
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

		if (paramS[0] == "a") {

		} else if (paramS[0] == "b") {

		}

		p = null;
	}

	function onInit () {
		//在游戏开始0.0秒后再调用
		trigger tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.5);
		TriggerAddCondition(tr,Condition(function (){
			BJDebugMsg("[Museum] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;

		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;

			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTMuseum1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTMuseum1(GetTriggerPlayer());
			else if(str == "s2") TTestUTMuseum2(GetTriggerPlayer());
			else if(str == "s3") TTestUTMuseum3(GetTriggerPlayer());
			else if(str == "s4") TTestUTMuseum4(GetTriggerPlayer());
			else if(str == "s5") TTestUTMuseum5(GetTriggerPlayer());
			else if(str == "s6") TTestUTMuseum6(GetTriggerPlayer());
			else if(str == "s7") TTestUTMuseum7(GetTriggerPlayer());
			else if(str == "s8") TTestUTMuseum8(GetTriggerPlayer());
			else if(str == "s9") TTestUTMuseum9(GetTriggerPlayer());
			else if(str == "s10") TTestUTMuseum10(GetTriggerPlayer());
		});

	}

}
//! endzinc

#undef TEST_ALBUM_TOTAL
#undef ALBUM_A_SUBBTN_COUNT
#undef ALBUM_A_SUBBTN_WIDTH
#undef ALBUM_A_SUBBTN_HEIGHT
#undef ALBUM_A_SUBBTN_GAP_X
#undef ALBUM_A_SUBBTN_OFFSET_Y
#undef ALBUM_A_SUBBTN_SELECTED_SCALE
#undef ALBUM_A_SUBBTN_FONT_NORMAL
#undef ALBUM_A_SUBBTN_FONT_SELECTED
#undef ALBUM_A_ICON_COLS
#undef ALBUM_A_ICON_ROWS
#undef ALBUM_A_ICON_GAP_X
#undef ALBUM_A_ICON_GAP_Y
#undef ALBUM_A_ICON_START_Y
#undef ALBUM_A_ICON_SIZE
#undef ALBUM_A_ICON_MAX
#undef ALBUM_A_PAGE_TEXT_OFFSET_Y
#undef ALBUM_A_PAGE_BTN_SIZE
#undef ALBUM_A_PAGE_BTN_OFFSET_X
#undef ALBUM_A_SEARCH_ICON_OFFSET_X
#undef ALBUM_A_SEARCH_ICON_OFFSET_Y
#undef ALBUM_A_SEARCH_ICON_SIZE
#undef ALBUM_A_SEARCH_EDIT_OFFSET_X
#undef ALBUM_A_SEARCH_EDIT_OFFSET_Y
#undef ALBUM_A_SEARCH_BOX_WIDTH
#undef ALBUM_A_SEARCH_BOX_HEIGHT

#endif
