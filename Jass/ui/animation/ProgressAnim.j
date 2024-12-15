#ifndef ProgressAnimIncluded
#define ProgressAnimIncluded

/*
* 进度动画库
*
* 用于UISprite的进度动画控制,提供从一个值到另一个值的平滑过渡效果
*
* 使用方式:
* 1. 在UISprite中引入panimable模块
* 2. 调用animate方法创建动画
*
* 示例:
* sprite.animate(0, 1, 2.0, function(uiSprite sprite) { /*动画结束回调*/ });
*
* @requires UILifeCycle 生命周期管理
* @requires UIAnimTimer 动画计时器
* @requires UIHashTable 哈希表
* @requires UISprite 精灵组件
*
* @author 作者名
* @version 1.0.0
*/
#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc

library ProgressAnim requires UILifeCycle , UIAnimTimer,UIHashTable,UISprite {

	public type onProgressEnd extends function(uiSprite);

	/*
	进度动画效果
	*/
	public struct progAnim {
		static thistype  List [];      // 内容列表
		static integer size = 0;         // 现在有几个东西
		static uianim UIA = 0;          // 动画实例

		uiSprite sprite;                // [成员]绑定的sprite
		real from;                      // [成员]起始值
		real to;                        // [成员]目标值
		integer time;                   // [成员]持续时间
		integer now;                    // [成员]当前时间
		integer id;                     // [成员]绑定的ID
		onProgressEnd cb;               // [成员]结束回调

		STRUCT_SHARED_METHODS(progAnim)

		// 创建进度动画
		static method create (uiSprite sprite, real from, real to, integer time, onProgressEnd cb) -> thistype {
			thistype this = allocate();
			// 数据设置都放这
			this.sprite = sprite;
			this.from = from;
			this.to = to;
			this.time = time;
			this.now = 0;
			this.cb = cb;

			// 这里是初始化时的设置内容,不需要改
			if (this.id == 0) {
				size += 1;
				List[size] = this;
				this.id = size;
			}

			UIA.reg();
			return this;
		}

		method onDestroy() {
			// 数据解除都放这里
			if (sprite.isExist() && HaveSavedInteger(HASH_UI, sprite.ui, HASH_KEY_UI_PROGRESS_ANIM)) {
				RemoveSavedInteger(HASH_UI, sprite.ui, HASH_KEY_UI_PROGRESS_ANIM);
			}
			sprite = 0;
			cb = 0;

			if (id != 0) {
				List[id] = List[size];
				List[id].id = id;
				size -= 1;
				id = 0;
			}

			if(size <= 0) {
				UIA.unreg(); // 这里就删计时器
				BJDebugMsg("progAnim计时器已停止"); // 添加调试输出
			}
		}

		static method onInit() {
			// 初始化动画计时器
			UIA = uianim.create(function() {
				integer i;
				thistype this;
				real progress;

				if (size > 0) {
					for (1 <= i <= size) {
						this = List[i]; // 从结论来说i就是.id
						this.now += 1;

						if(this.now >= this.time) { // 删除的条件
							this.sprite.setProgress(this.to);
							if(this.cb != 0) {
								RemoveSavedInteger(HASH_UI,this.sprite.ui,HASH_KEY_UI_PROGRESS_ANIM); //因为会自动排泄,防止在回调删UI的时候继续再调用一次
								this.cb.evaluate(this.sprite);
							}
							this.destroy();
							i -= 1; // 正向遍历必须要保留这条
						} else {
							progress = this.from + (this.to - this.from) * (I2R(this.now) / this.time);
							this.sprite.setProgress(progress);
						}
					}
				}
			});

			// UI销毁时回调删除进度动画
			uiLifeCycle.registerDestroy(function() {
				integer ui = uiLifeCycle.agrsFrame;
				thistype this;
				if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_PROGRESS_ANIM)) {
					this = LoadInteger(HASH_UI, ui, HASH_KEY_UI_PROGRESS_ANIM);
					if (this.isExist()) { // 检查实例是否存在
						this.destroy();
					}
				}
			});
		}
	}

	// 进度动画模块
	public module panimable {
		method progAnimate(real from, real to, real duration, onProgressEnd cb) -> thistype {
			progAnim anim;
			if (!this.isExist()) { return this; }

			// 检查是否已存在progAnim实例
			if (HaveSavedInteger(HASH_UI, ui, HASH_KEY_UI_PROGRESS_ANIM)) {
				anim = LoadInteger(HASH_UI, ui, HASH_KEY_UI_PROGRESS_ANIM);
				// 更新动画参数
				anim.sprite = this;
				anim.from = from;
				anim.to = to;
				anim.time = R2I(duration * 50);
				anim.now = 0;
				anim.cb = cb;
			} else {
				// 创建新实例
				anim = progAnim.create(this, from, to, R2I(duration * 50), cb);
				SaveInteger(HASH_UI, ui, HASH_KEY_UI_PROGRESS_ANIM, anim);
			}

			return this;
		}
	}
}

//! endzinc

#endif

