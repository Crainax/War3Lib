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


// 如果定义了 RES_UI_HIDE_X，则隐藏对应的资源UI
// 注释掉下面的定义来显示对应的资源UI
//#define RES_UI_HIDE_1
#define RES_UI_HIDE_2
#define RES_UI_HIDE_3

//# dependency:resource/ui/image/black.blp

library ResUI requires UIImage,UIText,Hardware,UIExtendResize {


	public struct resUI []{

		#ifndef RES_UI_HIDE_1
		static uiImage uiRes1Icon = 0;
		static uiText  uiRes1Text = 0;
		#endif

		#ifndef RES_UI_HIDE_2
		static uiImage uiRes2Icon = 0;
		static uiText  uiRes2Text = 0;
		#endif

		#ifndef RES_UI_HIDE_3
		static uiImage uiRes3Icon = 0;
		static uiText  uiRes3Text = 0;
		#endif

		private {
			#ifndef RES_UI_HIDE_1
			static trigger trEnter1 = null;
			static trigger trLeave1 = null;
			// 记录鼠标是否在各个资源UI内
			static boolean isInRes1 = false;
			#endif

			#ifndef RES_UI_HIDE_2
			static trigger trEnter2 = null;
			static trigger trLeave2 = null;
			static boolean isInRes2 = false;
			#endif

			#ifndef RES_UI_HIDE_3
			static trigger trEnter3 = null;
			static trigger trLeave3 = null;
			static boolean isInRes3 = false;
			#endif
		}

		// 设置进入事件,同步注册
		static method onEnter(integer pos,code func) {
			#ifndef RES_UI_HIDE_1
			if (pos == 1) {
				if (trEnter1 == null) {
					trEnter1 = CreateTrigger();
				}
				TriggerAddCondition(trEnter1, Condition(func));
			}
			#endif
			#ifndef RES_UI_HIDE_2
			if (pos == 2) {
				if (trEnter2 == null) {
					trEnter2 = CreateTrigger();
				}
				TriggerAddCondition(trEnter2, Condition(func));
			}
			#endif
			#ifndef RES_UI_HIDE_3
			if (pos == 3) {
				if (trEnter3 == null) {
					trEnter3 = CreateTrigger();
				}
				TriggerAddCondition(trEnter3, Condition(func));
			}
			#endif
		}
		// 设置离开事件,同步注册
		static method onLeave(integer pos,code func) {
			#ifndef RES_UI_HIDE_1
			if (pos == 1) {
				if (trLeave1 == null) {
					trLeave1 = CreateTrigger();
				}
				TriggerAddCondition(trLeave1, Condition(func));
			}
			#endif
			#ifndef RES_UI_HIDE_2
			if (pos == 2) {
				if (trLeave2 == null) {
					trLeave2 = CreateTrigger();
				}
				TriggerAddCondition(trLeave2, Condition(func));
			}
			#endif
			#ifndef RES_UI_HIDE_3
			if (pos == 3) {
				if (trLeave3 == null) {
					trLeave3 = CreateTrigger();
				}
				TriggerAddCondition(trLeave3, Condition(func));
			}
			#endif
		}

		// 设置资源文本
		static method setText(player p, integer pos, string text) {
			if (GetLocalPlayer() == p) {
				#ifndef RES_UI_HIDE_1
				if (pos == 1) {
					if (uiRes1Text != 0) {
						uiRes1Text.setText(text);
					}
					return;
				}
				#endif
				#ifndef RES_UI_HIDE_2
				if (pos == 2) {
					if (uiRes2Text != 0) {
						uiRes2Text.setText(text);
					}
					return;
				}
				#endif
				#ifndef RES_UI_HIDE_3
				if (pos == 3) {
					if (uiRes3Text != 0) {
						uiRes3Text.setText(text);
					}
					return;
				}
				#endif
			}
		}

		private static method init() {
			uiImage bg;

			#ifndef RES_UI_HIDE_1
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
			#endif

			#ifndef RES_UI_HIDE_2
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
			#endif

			#ifndef RES_UI_HIDE_3
			// Resource 3
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
			#endif
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
				#ifndef RES_UI_HIDE_1
				// 检查Res1
				if (x >= RES1_X && x <= RES1_X + RES_WIDTH &&
				y >= (RES_Y-0.004)) {
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
				#endif

				#ifndef RES_UI_HIDE_2
				// 检查Res2
				if (x >= RES2_X && x <= RES2_X + RES_WIDTH &&
				y >= (RES_Y-0.004)) {
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
				#endif

				#ifndef RES_UI_HIDE_3
				// 检查Res3
				if (x >= RES3_X && x <= RES3_X + RES_WIDTH &&
				y >= (RES_Y-0.004)) {
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
				#endif
			});
		}
	}
}

//! endzinc

#endif
