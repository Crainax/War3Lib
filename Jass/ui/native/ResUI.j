/*
* ResUI.j
*
* 资源UI系统
* 负责显示和管理玩家的资源数值显示
*
* 主要功能:
* - 在游戏界面顶部显示三种资源的UI
* - 提供资源数值显示的更新接口
*
* 依赖项:
* - UIBase
* - InchUtils
*
* 作者: [作者名]
* 创建时间: [创建日期]
* 最后修改: [最后修改日期]
*/

#ifndef ResUIIncluded
#define ResUIIncluded

#define RES_ICON_SIZE 0.015

// 资源UI区域定义
#define RES_Y 0.581
#define RES1_X 0.460
#define RES2_X 0.547
#define RES3_X 0.634

#define RES_WIDTH 0.077
#define RES_HEIGHT 0.0175

//! zinc


#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//# dependency:ui/image/black.blp

library ResUI requires UIImage,UIText,Hardware,UIExtendResize {

	// public constant boolean RES_UI_HIDE_3 = true;

	public struct resUI []{

		static uiImage uiRes1Icon = 0;
		static uiText  uiRes1Text = 0;
		static uiImage uiRes2Icon = 0;
		static uiText  uiRes2Text = 0;
		static uiImage uiRes3Icon = 0;
		static uiText  uiRes3Text = 0;

		private {
			static trigger trEnter1 = null;
			static trigger trLeave1 = null;
			static trigger trEnter2 = null;
			static trigger trLeave2 = null;
			static trigger trEnter3 = null;
			static trigger trLeave3 = null;

			// 记录鼠标是否在各个资源UI内
			static boolean isInRes1 = false;
			static boolean isInRes2 = false;
			static boolean isInRes3 = false;
		}

		// 设置进入事件,同步注册
		static method onEnter(integer pos,code func) {
			if (pos == 1) {
				if (trEnter1 == null) {
					trEnter1 = CreateTrigger();
				}
				TriggerAddCondition(trEnter1, Condition(func));
			} else if (pos == 2) {
				if (trEnter2 == null) {
					trEnter2 = CreateTrigger();
				}
				TriggerAddCondition(trEnter2, Condition(func));
			} else if (pos == 3) {
				if (trEnter3 == null) {
					trEnter3 = CreateTrigger();
				}
				TriggerAddCondition(trEnter3, Condition(func));
			}
		}
		// 设置进入事件,同步注册
		static method onLeave(integer pos,code func) {
			if (pos == 1) {
				if (trLeave1 == null) {
					trLeave1 = CreateTrigger();
				}
				TriggerAddCondition(trLeave1, Condition(func));
			} else if (pos == 2) {
				if (trLeave2 == null) {
					trLeave2 = CreateTrigger();
				}
				TriggerAddCondition(trLeave2, Condition(func));
			} else if (pos == 3) {
				if (trLeave3 == null) {
					trLeave3 = CreateTrigger();
				}
				TriggerAddCondition(trLeave3, Condition(func));
			}
		}

		private static method init() {
			uiImage bg;

			// Resource 1
			bg = uiImage.create(DzGetGameUI())
				.setSize(RES_WIDTH, RES_HEIGHT)
				.setAbsPoint(ANCHOR_BOTTOMLEFT,RES1_X, RES_Y)
				.setTexture("ui\\image\\black.blp");

			uiRes1Icon = uiImage.create(bg.ui)
				.exReSize(RES_ICON_SIZE, RES_ICON_SIZE)
				.setPoint(ANCHOR_LEFT, bg.ui, ANCHOR_LEFT, 0.002, 0);

			uiRes1Text = uiText.create(bg.ui)
				.setPoint(ANCHOR_RIGHT, bg.ui, ANCHOR_RIGHT, -0.005, 0)
				.setText("0");

			//每个地图
			static if (LIBRARY_DIY_RES__DiyResUIGold) {
				uiRes1Icon.setTexture(DIY_RES_UI_GOLD_STRING);
			} else {
				uiRes1Icon.setTexture("UI\\Feedback\\Resources\\ResourceGold.blp");
			}

			// Resource 2
			bg = uiImage.create(DzGetGameUI())
				.setSize(RES_WIDTH, RES_HEIGHT)
				.setAbsPoint(ANCHOR_BOTTOMLEFT,RES2_X, RES_Y)
				.setTexture("ui\\image\\black.blp");

			uiRes2Icon = uiImage.create(bg.ui)
				.exReSize(RES_ICON_SIZE, RES_ICON_SIZE)
				.setPoint(ANCHOR_LEFT, bg.ui, ANCHOR_LEFT, 0.002, 0);

			uiRes2Text = uiText.create(bg.ui)
				.setPoint(ANCHOR_RIGHT, bg.ui, ANCHOR_RIGHT, -0.005, 0)
				.setText("0");

			//每个地图
			static if (LIBRARY_DiyResUILumber) {
				uiRes2Icon.setTexture(DIY_RES_UI_LUMBER_STRING);
			} else {
				uiRes2Icon.setTexture("UI\\Feedback\\Resources\\ResourceLumber.blp");
			}

			static if (!RES_UI_HIDE_3) {
				bg = uiImage.create(DzGetGameUI())
					.setSize(RES_WIDTH, RES_HEIGHT)
					.setAbsPoint(ANCHOR_BOTTOMLEFT,RES3_X, RES_Y)
					.setTexture("ui\\image\\black.blp");

				uiRes3Icon = uiImage.create(bg.ui)
					.exReSize(RES_ICON_SIZE, RES_ICON_SIZE)
					.setPoint(ANCHOR_LEFT, bg.ui, ANCHOR_LEFT, 0.002, 0);

				uiRes3Text = uiText.create(bg.ui)
					.setPoint(ANCHOR_RIGHT, bg.ui, ANCHOR_RIGHT, -0.005, 0)
					.setText("0");

				//每个地图
				static if (LIBRARY_DiyResUISupply) {
					uiRes3Icon.setTexture(DIY_RES_UI_SUPPLY_STRING);
				} else {
					uiRes3Icon.setTexture("UI\\Feedback\\Resources\\ResourceSupply.blp");

				}

			}
		}

		static method onInit() {
			trigger tr = CreateTrigger();
			TriggerRegisterTimerEventSingle(tr, 0.0);
			TriggerAddCondition(tr, Condition(function() {
				resUI.init();
				DestroyTrigger(GetTriggeringTrigger());
			}));
			tr = null;

			hardware.regMoveEvent(function() {
				real x = hardware.getMouseX();
				real y = hardware.getMouseY();
				// 检查Res1
				if (x >= RES1_X && x <= RES1_X + RES_WIDTH &&
				y >= RES_Y) {
					// 添加调试输出
					if (!isInRes1) {
						isInRes1 = true;
						if (trEnter1 != null) {
							TriggerEvaluate(trEnter1);
						}
					}
				} else {
					if (isInRes1) {
						isInRes1 = false;
						if (trLeave1 != null) {
							TriggerEvaluate(trLeave1);
						}
					}
				}

				// 检查Res2
				if (x >= RES2_X && x <= RES2_X + RES_WIDTH &&
				y >= RES_Y) {
					if (!isInRes2) {
						isInRes2 = true;
						if (trEnter2 != null) {
							TriggerEvaluate(trEnter2);
						}
					}
				} else {
					if (isInRes2) {
						isInRes2 = false;
						if (trLeave2 != null) {
							TriggerEvaluate(trLeave2);
						}
					}
				}

				// 检查Res3
				static if (!RES_UI_HIDE_3) {
					if (x >= RES3_X && x <= RES3_X + RES_WIDTH &&
					y >= RES_Y) {
						if (!isInRes3) {
							isInRes3 = true;
							if (trEnter3 != null) {
								TriggerEvaluate(trEnter3);
							}
						}
					} else {
						if (isInRes3) {
							isInRes3 = false;
							if (trLeave3 != null) {
								TriggerEvaluate(trLeave3);
							}
						}
					}
				}
			});
		}
	}
}

//! endzinc

#endif
