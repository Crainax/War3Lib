#ifndef ImageBarAnimIncluded
#define ImageBarAnimIncluded

/*
* 图片进度条动画库
*
* 用于UIImageBar的进度动画控制,提供从一个值到另一个值的平滑过渡效果
*
* 使用方式:
* 1. 在UIImageBar中引入ibanimable模块
* 2. 调用animate方法创建动画
*
* 示例:
* imageBar.animate(0, 1, 2.0, function(uiImageBar bar) { /*动画结束回调*/ });
*
* @requires UILifeCycle 生命周期管理
* @requires UIAnimTimer 动画计时器
* @requires UIHashTable 哈希表
* @requires UIImageBar 图片进度条组件
*
* @version 1.0.0
*/
#include "Crainax/config/SharedMethod.h"
#include "Crainax/ui/constants/UIConstants.j"

//! zinc

library ImageBarAnim requires UILifeCycle, UIAnimTimer, UIHashTable, UIImageBar {

	public type onImageBarAnimEnd extends function(uiImageBar);

	private struct imageBarAnim {
		static thistype List[];
		static integer size = 0;
		static uianim UIA = 0;

		uiImageBar bar;                 // [成员]绑定的imageBar
		real from;                      // [成员]起始值
		real to;                        // [成员]目标值
		integer time;                   // [成员]持续时间

		integer now;                    // [成员]当前时间
		integer id;                     // [成员]绑定的ID
		onImageBarAnimEnd cb;           // [成员]结束回调

		static method create(uiImageBar bar, real from, real to, integer time, onImageBarAnimEnd cb) -> thistype {
			thistype this = allocate();
			this.bar = bar;
			this.from = from;
			this.to = to;
			this.time = time;
			this.now = 0;
			this.cb = cb;

			if (this.id == 0) {
				size += 1;
				List[size] = this;
				this.id = size;
			}

			UIA.reg();
			return this;
		}

		method onDestroy() {
			if (bar.isExist() && HaveSavedInteger(HASH_UI, bar.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM)) {
				RemoveSavedInteger(HASH_UI, bar.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM);
			}
			bar = 0;
			cb = 0;

			if (id != 0) {
				List[id] = List[size];
				List[id].id = id;
				size -= 1;
				id = 0;
			}

			if(size <= 0) {
				UIA.unreg();
				BJDebugMsg("UIA.unreg()");
			}
		}

		static method onInit() {
			UIA = uianim.create(function() {
				integer i;
				thistype this;
				real progress;

				if (size > 0) {
					for (1 <= i <= size) {
						this = List[i];
						this.now += 1;

						if(this.now >= this.time) {
							this.bar.setProgress(this.to);
							if(this.cb != 0) {
								RemoveSavedInteger(HASH_UI, this.bar.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM);
								this.cb.evaluate(this.bar);
							}
							this.destroy();
							i -= 1;
						} else {
							progress = this.from + (this.to - this.from) * (I2R(this.now) / this.time);
							this.bar.setProgress(progress);
						}
					}
				}
			});

			uiLifeCycle.registerDestroy(function() {
				integer ui = uiLifeCycle.agrsFrame;
				thistype this;
				if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_IMAGEBAR_ANIM)) {
					this = LoadInteger(HASH_UI, ui, HASH_KEY_UI_IMAGEBAR_ANIM);
					if (this.id != 0) {
						this.destroy();
					}
				}
			});
		}
	}

	public module ibanimable { // 绑定到其中的UIImage吧
		method animateIB(real from, real to, real duration, onImageBarAnimEnd cb) -> thistype {
			imageBarAnim anim;
			if (!this.isExist()) { return this; }

			if (HaveSavedInteger(HASH_UI, this.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM)) {
				anim = LoadInteger(HASH_UI, this.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM);
				anim.bar = this;
				anim.from = from;
				anim.to = to;
				anim.time = R2I(duration * 50);
				anim.now = 0;
				anim.cb = cb;
			} else {
				anim = imageBarAnim.create(this, from, to, R2I(duration * 50), cb);
				SaveInteger(HASH_UI, this.uiFill.ui, HASH_KEY_UI_IMAGEBAR_ANIM, anim);
			}

			return this;
		}
	}
}

//! endzinc

#endif

