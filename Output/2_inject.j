#ifndef UIExtendResizeIncluded
#define UIExtendResizeIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/core/table/Hash_UIDefine.j" // UI哈希表定义
//! zinc
/*
扩展自适应大小方法
*/
library UIExtendResize requires Hardware ,UIUtils,UILifeCycle{

    public module extendResize {

        //注册一个大小重组器
        method exReSize (real width,real height)  -> thistype {
            resizer ser;
            if (!this.isExist()) {return this;}
            if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER)) {
                ser        = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER);
                ser.frame  = ui;
                ser.width  = width;
                ser.height = height;
            } else {
                ser = resizer.create(ui,width,height);
                SaveInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_RESIZER,ser);
            }
            DzFrameSetSize(ui,width*GetResizeRate(),height);
            return this;
        }

        method exRePoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY)  -> thistype {
            rePointer ptr;
            if (!this.isExist()) {return this;}
            if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER)) {
                ptr                = LoadInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER);
                ptr.frame          = ui;
                ptr.anchor         = anchor;
                ptr.relative       = relative;
                ptr.relativeAnchor = relativeAnchor;
                ptr.offsetX        = offsetX;
                ptr.offsetY        = offsetY;
            } else {
                ptr = rePointer.create(ui,anchor,relative,relativeAnchor,offsetX,offsetY);
                SaveInteger(HASH_UI,ui,HASH_KEY_UI_EXTEND_REPOINTER,ptr);
            }
            DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX*GetResizeRate(),offsetY);
            return this;
        }
    }

    //大小重组器
    public struct resizer {
        static  thistype List [];  //内容列表
        static  integer size = 0;  //现在有几个东西
        integer frame;             //[成员]绑定的内容
        real width;                 //[成员]注册宽度
        real height;                //[成员]注册高度
        integer uID;               //[成员]绑定的ID

        STRUCT_SHARED_METHODS(resizer)

        //注册一个对象进池里
        static method create (integer frame,real width,real height) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.width = width;
            this.height = height;

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        STRUCT_SHARED_PRINT(size,List)

        method onDestroy () {
            frame = 0; //数据解除都放这里

            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }

            if (size <= 0) {BJDebugMsg("UIExtendResize: 大小重组器已销毁");}

        }

    }

    //位置重组器
    public struct rePointer {
        static  thistype List [];  //内容列表
        static  integer size = 0;  //现在有几个东西
        integer frame;             //[成员]绑定的内容
        integer anchor;            //[成员]锚点
        integer relative;          //[成员]相对锚点
        integer relativeAnchor;    //[成员]相对锚点
        real    offsetX;           //[成员]偏移X
        real    offsetY;           //[成员]偏移Y
        integer uID;               //[成员]绑定的ID

        STRUCT_SHARED_METHODS(rePointer)


        //注册一个对象进池里
        static method create (integer frame,integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            thistype this = allocate();
            this.frame = frame;
            this.anchor = anchor;
            this.relative = relative;
            this.relativeAnchor = relativeAnchor;
            this.offsetX = offsetX;
            this.offsetY = offsetY;

            if (uID == 0) { //这里是初始化时的设置内容,不需要改
                size       += 1;
                List[size]  = this;
                uID         = size;
            }
            return this;
        }

        STRUCT_SHARED_PRINT(size,List)

        method onDestroy () {
            frame = 0; //数据解除都放这里

            if (uID != 0) {
                List[uID]      = List[size];
                List[uID].uID  = uID;
                size          -= 1;
                uID            = 0;
            }

        }

    }

    function onInit () {
        hardware.regResizeEvent(function () { //注册窗口大小变化事件
            real resizeX = GetResizeRate();
            integer i ;
            resizer ser;
            if (resizer.size > 0) {
                for (i = resizer.size; i >= 1; i -= 1) { //反向遍历可以删除下面的　i-= 1
                    ser = resizer.List[i]; //从结论来说i就是.uID
                    DzFrameSetSize(ser.frame,ser.width*resizeX,ser.height);
                }
            }
        });

        hardware.regResizeEvent(function () { //注册窗口大小变化事件
            real resizeX = GetResizeRate();
            integer i;
            rePointer ptr;
            if (rePointer.size > 0) {
                for (i = rePointer.size; i >= 1; i -= 1) { //反向遍历可以删除下面的　i-= 1
                    ptr = rePointer.List[i]; //从结论来说i就是.uID
                    DzFrameSetPoint(ptr.frame,ptr.anchor,ptr.relative,ptr.relativeAnchor,ptr.offsetX*resizeX,ptr.offsetY);
                }
            }
        });

        uiLifeCycle.registerDestroy(function () { //UI的销毁回调事件
            integer frame = uiLifeCycle.agrsFrame;
            resizer ser;
            rePointer ptr;
            if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_RESIZER)) {
                ser = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_RESIZER);
                if (ser.isExist()) {
                    ser.destroy();
                }
            }
            if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_REPOINTER)) {
                ptr = LoadInteger(HASH_UI,frame,HASH_KEY_UI_EXTEND_REPOINTER);
                if (ptr.isExist()) {
                    ptr.destroy();
                }
            }
        });
    }

}

//! endzinc
#endif

#ifndef UILayerIncluded
#define UILayerIncluded

#include "Crainax/ui/constants/UIConstants.j"

//! zinc
//UI层级
library UILayer requires UITocInit {

	public struct uilayer [] {

		static integer lv [];

		static method onInit () {
			uilayer.lv[1] = DzCreateFrameByTagName("BACKDROP","layer1",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[1],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[1],UI_STRING_PATH_BLANK,0);
			uilayer.lv[2] = DzCreateFrameByTagName("BACKDROP","layer2",uilayer.lv[1],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[2],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[2],UI_STRING_PATH_BLANK,0);
			uilayer.lv[3] = DzCreateFrameByTagName("BACKDROP","layer3",uilayer.lv[2],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[3],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[3],UI_STRING_PATH_BLANK,0);
			uilayer.lv[4] = DzCreateFrameByTagName("BACKDROP","layer4",uilayer.lv[3],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[4],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[4],UI_STRING_PATH_BLANK,0);
			uilayer.lv[5] = DzCreateFrameByTagName("BACKDROP","layer5",uilayer.lv[4],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[5],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[5],UI_STRING_PATH_BLANK,0);
			uilayer.lv[6] = DzCreateFrameByTagName("BACKDROP","layer6",uilayer.lv[5],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[6],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[6],UI_STRING_PATH_BLANK,0);
			uilayer.lv[7] = DzCreateFrameByTagName("BACKDROP","layer7",uilayer.lv[6],TEMPLATE_IMAGE,0);
			DzFrameSetAllPoints(uilayer.lv[7],DzGetGameUI());
			DzFrameSetTexture(uilayer.lv[7],UI_STRING_PATH_BLANK,0);
		}

    }
}

//! endzinc
#endif

#ifndef MapBoundsUtilsIncluded
#define MapBoundsUtilsIncluded

//! zinc
// 地图边界工具库
library MapBoundsUtils {

    public struct mapBounds {
        static real maxX = 0.;
        static real minX = 0.;
        static real maxY = 0.;
        static real minY = 0.;

        // 限制X坐标在地图范围内
        static method X (real x) -> real {
            return RMinBJ(RMaxBJ(x, mapBounds.minX), mapBounds.maxX);
        }
        // 限制Y坐标在地图范围内
        static method Y (real y) -> real {
            return RMinBJ(RMaxBJ(y, mapBounds.minY), mapBounds.maxY);
        }

        // 初始化
        static method onInit () {
            mapBounds.minX = GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT);
            mapBounds.minY = GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM);
            mapBounds.maxX = GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT);
            mapBounds.maxY = GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP);
        }

    }

}
//! endzinc

#endif

#ifndef BaseAnimIncluded
#define BaseAnimIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/core/table/Hash_UIDefine.j" // UI哈希表键值定义

//! zinc
/*
基础的UI动画效果
*/
library BaseAnim requires UITocInit,UIHashTable,UILifeCycle,UIAnimTimer{

	// 生命周期结束时调用
	public type onLifeEnd extends function(baseanim);

	/*
	常用的动画效果
	整合到这里
	这里的动画不负责创建与删除,自行解决
	算了还是不用UI为键了，哈希表式的还没做
	*/
	public struct baseanim {


		static thistype DList[] , MList[] , AList[] , ZList[] , SList[] , BList[] , LList[];
		static integer DNum = 0 , MNum = 0 , ANum = 0 , ZNum = 0 , SNum = 0 , BNum = 0 , LNum = 0;
		static uianim UIA = 0; //利用上述创建的uianim特定个例
		static integer size = 0; //统计数量

		integer ui; //结构成员

		STRUCT_SHARED_METHODS(baseanim)

		//创建与删除
		static method create (integer ui) -> thistype {
			thistype this = allocate();
			this.ui = ui;
			SaveInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM,this);
			size += 1; //统计数量++
			return this;
		}

		integer dID,dTime,dNow; //延迟组
		//动画延迟
		method addDelay (integer time) {
			if (time <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.dTime = time;
			this.dNow = 0;
			if (dID == 0) { //这里是初始化时的设置内容,不需要改
				DNum        = DNum + 1;
				DList[DNum] = this;
				dID         = DNum;
			}
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delDelay () {
			//数据解除都放这里
			if (dID != 0) {
				DList[dID]      = DList[DNum];
				DList[dID].dID  = dID;
				DNum           -= 1;
				dID             = 0;
			}
		}

		integer align,mTime,mNow,anchor1,anchor2,mID; //移动组
		real dist,off,angle; //移动组
		//线性移动
		// @param align 需要对齐的UI
		// @param off 初始的对应anchor的偏移
		// @param dist 距离（加上面的off)
		// @param time 时间(0.02为一帧)
		// @param angle 角度
		// @param anchor1 本体的锚点
		// @param anchor2 需要对齐的UI的锚点
		method addMove (integer align,real off,real dist,integer time,real angle,integer anchor1,integer anchor2) {
			if (dist <= 0. || !(isExist())) {return;}
			//数据设置都放这
			this.align   = align;
			this.dist    = dist;
			this.off     = off;
			this.mTime   = time;
			this.mNow    = 0;
			this.angle   = angle;
			this.anchor1 = anchor1;
			this.anchor2 = anchor2;
			if (mID == 0) { //这里是初始化时的设置内容,不需要改
				MNum = MNum + 1;
				MList[MNum]= this;
				mID = MNum;
			}
			DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*off,SinBJ(angle)*off);
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delMove () {
			//数据解除都放这里
			if (mID != 0) {
				MList[mID]= MList[MNum];
				MList[mID].mID =mID;
				MNum = MNum - 1;
				mID = 0;
			}
		}

		//透明组
		integer aID,aStart,aTar,aTime,aNow;
		//透明度(0-255)
		// @param start 开始透明度
		// @param tar 目标透明度
		// @param time 时间(0.02为一帧)
		method addAlpha (integer start,integer tar,integer time) {
			if (time <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.aStart = start;
			this.aTar   = tar;
			this.aTime  = time;
			this.aNow   = 0;
			if (aID == 0) { //这里是初始化时的设置内容,不需要改
				ANum        = ANum + 1;
				AList[ANum] = this;
				aID         = ANum;
			}
			DzFrameSetAlpha(ui,start); //这个不能设置的原因是有可能有2个一起设置，存在延迟;
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delAlpha () {
			if (aID != 0) {
				AList[aID]      = AList[ANum];
				AList[aID].aID  = aID;
				ANum           -= 1;
				aID             = 0;
			}
		}

		//放大组[垃圾scale还是用size香]
		integer zID,zTime,zNow;
		real zStartX,zTarX,zStartY,zTarY;
		//放大
		// @param startX 开始X
		// @param tarX 目标X
		// @param startY 开始Y
		// @param tarY 目标Y
		// @param time 时间(0.02为一帧)
		method addZoom (real startX,real tarX,real startY,real tarY,integer time) {
			if (time <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.zStartX = startX;
			this.zTarX   = tarX;
			this.zStartY = startY;
			this.zTarY   = tarY;
			this.zTime   = time;
			this.zNow    = 0;
			if (zID == 0) { //这里是初始化时的设置内容,不需要改
				ZNum        = ZNum + 1;
				ZList[ZNum] = this;
				zID         = ZNum;
			}
			DzFrameSetSize(ui,startX,startY);
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delZoom () {
			//数据解除都放这里
			if (zID != 0) {
				ZList[zID]      = ZList[ZNum];
				ZList[zID].zID  = zID;
				ZNum           -= 1;
				zID             = 0;
			}
		}

		//序列组(永恒序列/一次性序列)
		string sPath;    //路径
		integer sID;     //ID
		integer sMax;    //最大帧数
		integer sPos;    //当前帧
		integer sGap;    //帧间隔
		integer sGapPos; //帧间隔指针
		boolean sLoop;   //是否循环

		//序列帧已经自动从0开始了。
		// @param path 路径 (帧图片取名要这种格式: xxx_0.blp)
		// @param maxFrame 最大帧数
		// @param interval 帧间隔
		// @param isL 是否循环
		method addSequ (string path,integer maxFrame,integer interval,boolean isL) {
			if (maxFrame <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.sPath   = path;      //路径;
			this.sMax    = maxFrame;  //最大帧数;
			this.sPos    = 0;         //当前帧;
			this.sGap    = interval;  //帧间隔;
			this.sGapPos = 0;         //帧间隔;
			this.sLoop   = isL;       //是否循环;
			if (sID == 0) { //这里是初始化时的设置内容,不需要改
				SNum        = SNum + 1;
				SList[SNum] = this;
				sID         = SNum;
			}
			DzFrameSetTexture(ui,sPath + "0.blp",0);
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delSequ () {
			//数据解除都放这里
			sPath = null;
			if (sID != 0) {
				SList[sID]      = SList[SNum];
				SList[sID].sID  = sID;
				SNum           -= 1;
				sID             = 0;
			}
		}

		//闪烁组
		integer bID,bPeriod,bTime,bStart;
		boolean bOrient;
		//闪烁组,Time是周期，取消后记得在外面设置Alpha回255
		// @param start 开始透明度
		// @param period 周期(0.02为一帧)
		method addBlink (integer start,integer period) {
			if (period <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.bStart  = start;
			this.bOrient = false;
			this.bPeriod = period;
			this.bTime   = 0;
			if (bID == 0) { //这里是初始化时的设置内容,不需要改
				BNum        = BNum + 1;
				BList[BNum] = this;
				bID         = BNum;
			}
			DzFrameSetAlpha(ui,start);
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delBlink () {
			//数据解除都放这里
			if (bID != 0) {
				BList[bID]      = BList[BNum];
				BList[bID].bID  = bID;
				BNum           -= 1;
				bID             = 0;
			}
		}
		//生命周期组
		integer lID,lPeriod,lTime;
		onLifeEnd lCB;
		// @param period 生命周期时长(0.02为一帧)
		// @param lCB 生命周期结束时调用,设成0则不调用,自动排泄ba
		method addLife (integer period,onLifeEnd lCB) {
			if (period <= 0 || !(isExist())) {return;}
			//数据设置都放这
			this.lPeriod = period;
			this.lTime   = 0;
			this.lCB     = lCB;
			//这里是初始化时的设置内容,不需要改
			if (lID == 0) {
				LNum        = LNum + 1;
				LList[LNum] = this;
				lID         = LNum;
			}
			UIA.reg(); //Add了后就调用了这个自动开始
		}
		private method delLife () {
			//数据解除都放这里
			lTime = 0;
			if (lID != 0) {
				//这里开始删ui
				if (ui != 0 && lCB != 0) {
					RemoveSavedInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM); //因为会自动排泄,防止在回调删UI的时候继续再调用一次
					lCB.evaluate(this);
				}
				LList[lID]      = LList[LNum];
				LList[lID].lID  = lID;
				LNum           -= 1;
				lID             = 0;
			}
		}

		//析构,手动调用或者生命周期结束时自动调用
		method onDestroy () {
			if (!isExist()) {return;}
			delDelay();
			delMove();
			delZoom();
			delAlpha();
			delSequ();
			delBlink();
			delLife();
			if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM)) {
				RemoveSavedInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM);
			}
			ui = 0;
			size -= 1; //统计数量--
		}

		//查看当前的东西
		static method toString () -> string {
			string s = "";
			s +="[DNum]" + I2S(DNum) + "->";
			s +="[MNum]" + I2S(MNum) + "->";
			s +="[ANum]" + I2S(ANum) + "->";
			s +="[ZNum]" + I2S(ZNum) + "->";
			s +="[SNum]" + I2S(SNum) + "->";
			s +="[BNum]" + I2S(BNum) + "->";
			s +="[LNum]" + I2S(LNum);
			return s;
		}

		static method onInit () {
			UIA = uianim.create(function (){
				integer i ,this;
				real r;
				if ( DNum > 0 ){ //延迟组先行动
					for (1 <= i <= DNum) {
						//从结论来说i就是dID
						this = DList[i];
						dNow = dNow + 1;
						if (dNow >= dTime) { //结束了
							DList[i]     = DList[DNum];
							DList[i].dID = i;
							DNum         = DNum - 1;
							dID          = 0;
							i            = i - 1;
						}
					}
				}
				if ( MNum > 0 ) { //移动
					for (1 <= i <= MNum) {
						//从结论来说i就是mID
						this = MList[i];
						if (dID == 0) {
							if (mNow >= mTime) { //结束了
								DzFrameClearAllPoints(ui);
								DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*(off +dist),SinBJ(angle)*(off +dist));
								MList[i]     = MList[MNum];
								MList[i].mID = i;
								MNum         = MNum - 1;
								i            = i - 1;
								mID         = 0;
							} else {
								mNow = mNow + 1;
								DzFrameClearAllPoints(ui);
								DzFrameSetPoint(ui,anchor1,align,anchor2,CosBJ(angle)*(off +dist * mNow / mTime),SinBJ(angle)*(off +dist * mNow / mTime));
							}
						} //还在延迟中不进行操作
					}
				}
				if ( ANum > 0 ) { //透明度
					for (1 <= i <= ANum) {
						//从结论来说i就是aID
						this = AList[i];
						if (dID == 0) { // 结束了
							if (aNow >= aTime) {
								DzFrameSetAlpha(ui,aTar);
								if (aTar <= 0) {DzFrameShow(ui,false);}
								AList[i]     = AList[ANum];
								AList[i].aID = i;
								ANum         = ANum - 1;
								i            = i - 1;
								aID          = 0;
							} else {
								aNow = aNow + 1;
								DzFrameSetAlpha(ui,R2I(aStart + (aTar - aStart) * (I2R(aNow)/ aTime)));
							}
						} //还在延迟中不进行操作
					}
				}
				if ( ZNum > 0 ){ //放大组
					for (1 <= i <= ZNum) {
						//从结论来说i就是aID
						this = ZList[i];
						if (dID == 0) { // 结束了
							if (zNow >= zTime) {
								//DzFrameSetScale(ui,zTar);
								DzFrameSetSize(ui,zTarX,zTarY);
								ZList[i]     = ZList[ZNum];
								ZList[i].zID = i;
								ZNum         = ZNum - 1;
								i            = i - 1;
								zID          = 0;
							} else {
								zNow = zNow + 1;
								DzFrameSetSize(ui,zStartX + (zTarX -zStartX) * (I2R(zNow)/ zTime),zStartY + (zTarY -zStartY) * (I2R(zNow)/ zTime));
							}
						} //还在延迟中不进行操作
					}
				}

				if ( SNum > 0 ){ //序列帧
					for (1 <= i <= SNum) {
						//从结论来说i就是sID
						this = SList[i];
						if (dID == 0) {
							sGapPos = sGapPos + 1;
							if (sGapPos >= sGap) { //几帧一绘
								sGapPos  = 0;
								sPos    +=  1;
								if (sPos > sMax) { // 结束了,且不循环
									sPos = 0;
									if (!sLoop) { //不循环
										DzFrameSetTexture(ui,sPath + I2S(sMax)+ ".blp",0);
										SList[i]     = SList[SNum];
										SList[i].sID = i;
										SNum         = SNum - 1;
										i            = i - 1;
										sID          = 0;
									} else {
										DzFrameSetTexture(ui,sPath + "0.blp",0);
									}
								} else {
									DzFrameSetTexture(ui,sPath + I2S(sPos)+ ".blp",0); //正常绘帧
								}
							}
						}//还在延迟中不进行操作
					}
				}

				if ( BNum > 0 ){ //闪烁组
					for (1 <= i <= BNum) {
						//从结论来说i就是aID
						this = BList[i];
						if (dID == 0) {
							if (bOrient) { //变透明
								bTime -= 1;
							} else { //实体化
								bTime += 1;
							}
							if (bTime >= R2I(bPeriod * 0.5) || bTime <= 0) {
								bOrient = !bOrient;
							}
							DzFrameSetAlpha(ui,R2I(255 * (I2R(bTime)/ bPeriod * 2)));
						}//还在延迟中不进行操作
					}
				}
				if ( LNum > 0 ) { //生命周期[不受延迟组影响]
					for (1 <= i <= LNum) {
						//从结论来说i就是dID
						this   = LList[i];
						lTime += 1;
						//结束了
						if (lTime >= lPeriod) {
							destroy();
							i -= 1;
						}
					}
				}

				if (DNum <= 0 && MNum <= 0 && ANum <= 0 && ZNum <= 0 && SNum <= 0 && BNum <= 0 && LNum <= 0 ) {
					UIA.unreg(); //这里就删计时器吧
					BJDebugMsg("baseanim停止了");
				}
			});
			// UI销毁时回调删除基础动画(UI销毁时会自动调用),但是不需要再删ba了,
			uiLifeCycle.registerDestroy(function (){
				integer ui = uiLifeCycle.agrsFrame;
				thistype this;
				if (HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM)) {
					this = LoadInteger(HASH_UI,ui,HASH_KEY_UI_BASEANIM);
					if (this.isExist()) {
						this.destroy();
					}
				}
			});
		}
	}

}

//! endzinc
#endif


#ifndef UIUtilsIncluded
#define UIUtilsIncluded

//窗口的大小
#define WINDOW_PRESENT_WIDTH  0.80
#define WINDOW_PRESENT_HEIGHT 0.60

//! zinc
/*
UI工具库
*/
library UIUtils requires BzAPI{

	//获得现在的X / Y比例
	//主要用于UI缩放
	public function GetResizeRate () -> real {
		if (DzGetWindowWidth() > 0) return DzGetWindowHeight()/ 600.0 * 800.0 / DzGetWindowWidth();
		else return 1.0;
	}

	// 获取鼠标位置X(绝对坐标)[修正版]
	public function GetMouseXEx () -> real {
		integer width = DzGetClientWidth();
		if (width > 0) return DzGetMouseXRelative()* WINDOW_PRESENT_WIDTH / width;
		else return 0.1;
	}

	// 获取鼠标位置Y(绝对坐标)[修正版]
	public function GetMouseYEx () -> real {
		integer height = DzGetClientHeight();
		if (height > 0) return WINDOW_PRESENT_HEIGHT - DzGetMouseYRelative()* WINDOW_PRESENT_HEIGHT / height;
		else return 0.1;
	}

	// 限制一个值是在一定区域内以防UI超出这个区域
	public function GetFixedMouseX (real min,real max) -> real {
		return RLimit(GetMouseXEx(),min,max);
	}

	// 限制一个值是在一定区域内以防UI超出这个区域
	public function GetFixedMouseY (real min,real max) -> real {
		return RLimit(GetMouseYEx(),min,max);
	}

}

//! endzinc
#endif

#ifndef UISpriteIncluded
#define UISpriteIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
模型UI组件
*/
library UISprite requires STRUCT_SHARED_REQUIRE_UI {


    public struct uiSprite {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiSprite)

        // 可选引入进度动画模块
        optional module panimable;

        // 创建模型
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SPRITE",STRING_SPRITE + I2S(id),parent,TEMPLATE_SPRITE,0);
            STRUCT_SHARED_UI_ONCREATE(uiSprite)
            return this;
        }

        // 设置模型(目前只做平面型就行了,后面2个0固定了)
        // @param path: 模型路径
        // @param modelType: 模型类型(0 = SPRITE（精灵/图标）,1 = MODEL（3D模型）,2 = STATUSBAR（状态条）)
        // @param flag: 标志(0 = 普通显示,1 = 允许选择模型,2 = 使用鼠标移动模型,4 = 添加模型动画控制器),要位运算
        method setModel(string path,integer modelType,integer flag) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetModel(ui,path,modelType,flag);
            return this;
        }

        // 设置缩放
        // @param scale: 缩放比例
        method setScale (real scale) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScale(ui,scale);
            return this;
        }

        // 设置动画
        // @param animate: 动画ID,一般为0
        // @param auto: 是否自动播放
        method setAnimate(integer animate,boolean auto) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAnimate(ui,animate,auto);
            return this;
        }

        // 设置进度
        method setProgress(real progress) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAnimateOffset(ui,progress);
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiSprite)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}

//! endzinc
#endif

#ifndef UIIdIncluded
#define UIIdIncluded

//! zinc

/*
ID复用器
*/
// 使用常量定义父键，使代码更清晰
#define RECYCLE_POOL  1  // 存储回收的ID
#define ID_STATUS     2  // 存储ID状态

library UIId {

    public struct uiId []{
        static hashtable ht;
        static integer nextId;
        static integer recycleCount;

        static method onInit () {
            thistype.ht = InitHashtable();
            thistype.nextId = 1;
            thistype.recycleCount = 0;
        }

        static method get ()  -> integer {
            integer id;

            // 如果有已回收的ID，优先使用
            if (recycleCount > 0) {
                // 获取最后一个回收的ID
                id = LoadInteger(ht, RECYCLE_POOL, recycleCount - 1);
                // 从回收池中删除这个ID
                RemoveSavedInteger(ht, RECYCLE_POOL, recycleCount - 1);
                // 从状态表中删除
                RemoveSavedBoolean(ht, ID_STATUS, id);
                recycleCount = recycleCount - 1;
                return id;
            }

            // 如果没有可复用的ID，返回新的ID
            id = nextId;
            nextId = nextId + 1;
            return id;
        }

        static method recycle (integer id) {
            // 快速检查ID是否已经在回收池中
            if (!HaveSavedBoolean(ht, ID_STATUS, id)) {
                // 将ID存入回收池
                SaveInteger(ht, RECYCLE_POOL, recycleCount, id);
                // 标记该ID已被回收
                SaveBoolean(ht, ID_STATUS, id, true);
                recycleCount = recycleCount + 1;
            }
        }

        // 获取回收池中ID的数量
        static method getRecycledCount() -> integer {
            return recycleCount;
        }

        // 获取当前正在使用的ID数量
        static method getActiveCount() -> integer {
            // 最大ID减去已回收的ID数量
            return (nextId - 1) - recycleCount;
        }

    }
}

#undef RECYCLE_POOL
#undef ID_STATUS

//! endzinc
#endif



#ifndef UIHashTableIncluded
#define UIHashTableIncluded

//! zinc
/*
UI哈希表通用函数
*/

#include "Crainax/core/table/Hash_UIDefine.j"

library UIHashTable {

    public hashtable HASH_UI = InitHashtable();  // UI结构哈希表
    integer frame = 0;

    //对外接口,方便链式调用
    public function uiHashTable (integer f) -> uiHT {
        frame = f;
        return uiHT[0];
    }

    //私有
    struct uiHT [] {
        uiHTEvent eventdata;  //方便链式调用  uiHashTable(frame).eventdata.bind(8174);
        uiHTFrame ui       ;  //方便链式调用  uiHashTable(frame).ui.bind(8174);
    }

    // 子结构体函数
    struct uiHTFrame [] {
        // 绑定UI实例到frame
        method bind (integer typeID,integer ui) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_TYPE,typeID);
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_UI,ui);
        }

        // 从frame获取UI实例
        method get () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_UI);
        }

        // 从frame获取UI类型
        method getType () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_TYPE);
        }
    }

    // 子结构体函数
    struct uiHTEvent [] {
        method bind (integer value) {
            SaveInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA,value);
        }

        method get () -> integer {
            return LoadInteger(HASH_UI,frame,HASH_KEY_UI_EVENT_DATA);
        }
    }

}

//! endzinc
#endif

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


#ifndef IconIncluded
#define IconIncluded


#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量


//===========================================================================
// Icon.j
//===========================================================================
//
// 模块描述：
//   实现了魔兽争霸3中通用的图标UI组件，支持图标显示、数字标记、
//   按钮功能、流光特效等特性。
//
// 作者：[你的名字]
// 创建日期：[创建日期]
// 最后修改：[最后修改日期]
//
// 依赖项：
//   - UIBase
//   - UIAnim
//   - GrowData
//   - UIText
//   - UIImage
//   - UIButton
//   - UISprite
//
// 使用示例：
//   icon myIcon = icon.create(parentFrame, true, true);
//   myIcon.size(0.04, 0.04);
//
//===========================================================================

//# dependency:ui/model/cooldown_center.mdx


//! zinc
/*
[按钮]整合到了一起
*/
library Icon requires BaseAnim, GrowData, UIText, UIImage, UIButton,UISprite,ProgressAnim,UIExtendResize,UILayer{

    public struct icon {
        // UI组件
        uiImage mainImage;      // 主图标图片
        uiImage shadowImage;    // 图标暗遮罩
        uiImage cornerShade;    // 角落文字背景
        uiImage glowImage;      // 流光特效图片
        uiText cornerText;      // 角落文字
        uiBtn clickBtn;      // 点击按钮
        uiSprite cdSprite;      // CD显示精灵
        integer parent; // 父级UI()

        // 动画相关
        baseanim glowAnim;    // 流光动画
        growdata gd;          // 流光数据

        // 尺寸
        real sizeX;
        real sizeY;
        boolean isResize;

        // 是否是原生
        boolean isSimple;
        integer spAnchor;
        integer spRelative;
        integer spRelativeAnchor;
        real spOffsetX;
        real spOffsetY;
        uiImage cdSpriteImage; // 用于CD显示的辅助图片
        STRUCT_SHARED_METHODS(icon)

        // 私有的初始化方法
        private method init() {
            // 初始化所有成员为0
            mainImage     = 0;
            shadowImage   = 0;
            cornerShade   = 0;
            cornerText    = 0;
            clickBtn      = 0;
            glowImage     = 0;
            cdSprite      = 0;
            cdSpriteImage = 0;

            // 动画相关
            glowAnim = 0;
            gd       = 0;

            // 尺寸初始化为0
            sizeX    = 0.04;
            sizeY    = 0.04;
        }

        // 普通创建方法
        static method create(integer parent) -> thistype {
            thistype this = allocate();
            this.init();
            this.parent = parent;
            isSimple    = false;

            // 创建必需组件
            mainImage = uiImage.create(parent)
                .setClip(true);
            mainImage.show(false);

            return this;
        }

        // 从现有UI创建图标(parent是后面创建东西的parent)
        static method fromExistingUI(uiImage existingImage,integer parent) -> thistype {
            thistype this = allocate();
            this.init();
            this.parent      = parent;
            isSimple         = true;
            spAnchor         = 0;
            spRelative       = 0;
            spRelativeAnchor = 0;
            spOffsetX        = 0;
            spOffsetY        = 0;

            // 绑定现有图片
            mainImage = existingImage;

            return this;
        }

        // 从现有UI创建图标(parent是后面创建东西的parent)
        static method createSimple(integer parent) -> thistype {
            return fromExistingUI(uiImage.createSimple(parent),parent);
        }

        // 更新流光尺寸
        private method updateGlowSize () {
            if (glowImage.isExist()) {
                if (isResize) {
                    glowImage.exReSize(sizeX * gd.scale, sizeY * gd.scale);
                } else {
                    glowImage.setSize(sizeX * gd.scale, sizeY * gd.scale);
                }
            }
        }

        // 加入流光效果
        method grow(growdata gd) -> thistype {
            if (!this.isExist()) {return this;}
            if (!glowImage.isExist()) {
                if (isSimple) {
                    glowImage = uiImage.create(uilayer.lv[1]); // 创建流光图片 -> 到最底层
                } else {
                    glowImage = uiImage.create(this.parent);
                }
                glowImage.setPoint(ANCHOR_CENTER, mainImage.ui, ANCHOR_CENTER, 0, 0);

                this.updateGlowSize();
            }
            glowImage.show(true); // 显示流光
            if (gd != this.gd) {
                this.gd = gd;
            }
            if (!glowAnim.isExist()) {
                glowAnim = baseanim.create(glowImage.ui);
                glowAnim.addSequ(gd.path, gd.max, gd.gap, true);
            }
            this.updateGlowSize();
            return this;
        }

        // 取消流光
        method unGrow() -> thistype {
            if (!this.isExist()) {return this;}
            if (glowImage.isExist()) { //
                glowImage.destroy();
                glowImage = 0;
            }
            if (glowAnim.isExist()) {
                glowAnim.destroy();
                glowAnim = 0;
            }
            return this;
        }

        // 设置尺寸
        method setSize(real x, real y) -> thistype {
            if (!this.isExist()) {return this;}
            if (sizeX <= 0 || sizeY <= 0) {return this;}
            if (isResize) {
                mainImage.exReSize(x, y);
            } else {
                mainImage.setSize(x, y);
            }
            sizeX = x;
            sizeY = y;
            this.updateGlowSize();
            return this;
        }

        method enableResize() -> thistype {
            if (!this.isExist()) {return this;}
            isResize = true;
            setSize(sizeX, sizeY);
            return this;
        }

        // 设置数字
        method setCornerText(string value) -> thistype {
            real padding;
            if (!this.isExist()) {return this;}

            // 如果value为null,隐藏cornerText和cornerShade
            if (value == null) {
                if (cornerText.isExist()) {
                    cornerText.show(false);
                    cornerShade.show(false);
                }
                return this;
            }

            // 创建或更新cornerText
            if (!cornerText.isExist()) {
                if (isSimple) {
                    cornerShade = uiImage.createCornerBorder(uilayer.lv[1]);
                    cornerText = uiText.create(cornerShade.ui);
                } else {
                    cornerShade = uiImage.createCornerBorder(this.parent);
                    cornerText = uiText.create(cornerShade.ui);
                }
                cornerText.setFontSize(2)
                    .setPoint(ANCHOR_BOTTOMRIGHT, mainImage.ui, ANCHOR_BOTTOMRIGHT, -0.003,0.003);
                padding = 0.003;
                cornerShade.setPoint(ANCHOR_TOPLEFT, cornerText.ui, ANCHOR_TOPLEFT, -padding, padding)
                    .setPoint(ANCHOR_BOTTOMRIGHT, cornerText.ui, ANCHOR_BOTTOMRIGHT, padding, -padding);
            }
            cornerText.setText(value);
            cornerText.show(true);
            cornerShade.show(true);
            return this;
        }

        // 设置图标暗遮罩
        method setShadow(boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            if (!shadowImage.isExist() && flag) {
                if (isSimple) {
                    shadowImage = uiImage.create(uilayer.lv[1]);
                } else {
                    shadowImage = uiImage.create(mainImage.ui);
                }
                shadowImage.setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp")
                    .setAllPoint(mainImage.ui);
            }
            if (shadowImage.isExist()) {
                shadowImage.show(flag);
            }
            return this;
        }

        // CD显示相关方法
        // func回调函数中的eventdata.get时是返回这个icon本体
        method startCooldown(real duration,onProgressEnd func) -> thistype {
            if (!this.isExist()) {return this;}
            if (!cdSprite.isExist()) {
                if (isSimple) {
                    cdSpriteImage = uiImage.create(uilayer.lv[1])
                        .setTexture(UI_STRING_PATH_BLANK)
                        .setAllPoint(mainImage.ui)
                        .setClip(true);
                    cdSprite = uiSprite.create(cdSpriteImage.ui);
                } else {
                    cdSprite = uiSprite.create(mainImage.ui);
                }
                cdSprite.setPoint(ANCHOR_CENTER,mainImage.ui,ANCHOR_CENTER,0,0)
                    .setSize(0.001,0.001)
                    .setModel("ui\\model\\cooldown_center.mdx",0,0)
                    .setAnimate(0,false);
                uiHashTable(cdSprite).eventdata.bind(this);
            }
            cdSprite.progAnimate(0,1,duration,func);
            cdSprite.setScale(sizeY / 0.038);
            return this;
        }

        // 获取按钮,然后再在外面设按钮相关的事件
        method getClickBtn() -> uiBtn {
            if (!this.isExist()) {return 0;}
            if (!clickBtn.isExist()) {
                if (isSimple) { //原生
                    if (parent != 0) {
                        clickBtn = uiBtn.createSimple(parent)
                            .setAllPoint(mainImage.ui);
                    } else {
                        BJDebugMsg("parent is 0");
                    }
                } else { //非原生
                    clickBtn = uiBtn.create(mainImage.ui)
                        .setAllPoint(mainImage.ui);
                }
            }
            return clickBtn;
        }

        // 设置图标贴图
        method setTexture(string path) -> thistype {
            if (!this.isExist()) {return this;}
            mainImage.setTexture(path);
            return this;
        }

        // 设置位置(顺便存位置)
        // 原生的话1个点就行, 不要设太多点
        method setPoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            if (isSimple) {
                mainImage.clearPoint()
                    .setPoint(anchor,relative,relativeAnchor,offsetX,offsetY);
                this.spAnchor         = anchor;
                this.spRelative       = relative;
                this.spRelativeAnchor = relativeAnchor;
                this.spOffsetX        = offsetX;
                this.spOffsetY        = offsetY;
            } else {
                mainImage.setPoint(anchor,relative,relativeAnchor,offsetX,offsetY);

            }
            return this;
        }

        // 显示/隐藏整个图标(Simple无效)
        method show(boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            if (isSimple) { //原生就移到屏幕外
                if (flag) { //显示
                    mainImage.clearPoint()
                        .setPoint(spAnchor,spRelative,spRelativeAnchor,spOffsetX,spOffsetY);
                } else { //隐藏
                    mainImage.clearPoint()
                        .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, -0.8, 0.0);
                }
            } else { //非原生才能用这个函数
                mainImage.show(flag);
                if (glowImage.isExist()) {
                    glowImage.show(flag);
                }
            }
            return this;
        }

        method onDestroy() {
            if (glowAnim.isExist()) { glowAnim.destroy(); glowAnim = 0; }
            if (cdSprite.isExist()) { cdSprite.destroy(); cdSprite = 0; }
            if (cdSpriteImage.isExist()) { cdSpriteImage.destroy(); cdSpriteImage = 0; }
            if (shadowImage.isExist()) { shadowImage.destroy(); shadowImage = 0; }
            if (cornerShade.isExist()) { cornerShade.destroy(); cornerShade = 0; }
            if (cornerText.isExist()) { cornerText.destroy(); cornerText = 0; }
            if (clickBtn.isExist()) { clickBtn.destroy(); clickBtn = 0; }
            if (glowImage.isExist()) { glowImage.destroy(); glowImage = 0; }
            if (mainImage.isExist()) { mainImage.destroy(); mainImage = 0; }
        }
    }
}

//! endzinc
#endif

#ifndef HardwareIncluded
#define HardwareIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
结构体
硬件事件(按/滑/帧事件)
*/
library Hardware requires BzAPI {

	public struct hardware []{
		// 注册一个左键抬起事件
		static method regLeftUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_LEFT,FRAME_EVENT_KEY_UP,false,func);
		}
		// 注册一个左键按下事件
		static method regLeftDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_LEFT,FRAME_EVENT_KEY_PRESSED,false,func);
		}
		// 注册一个右键按下事件
		static method regRightDownEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_RIGHT,FRAME_EVENT_KEY_PRESSED,false,func);
		}
		// 注册一个右键抬起事件
		static method regRightUpEvent (code func) {
			DzTriggerRegisterMouseEventByCode(null,FRAME_MOUSE_RIGHT,FRAME_EVENT_KEY_UP,false,func);
		}
		// 注册一个滚轮事件,不能异步注册
		static method regWheelEvent (code func) {
			if (trWheel == null) {trWheel = CreateTrigger();}
			TriggerAddCondition(trWheel, Condition(func));
		}
		// 注册一个绘制事件,不能异步注册
		static method regUpdateEvent (code func) {
			if (trUpdate == null) {trUpdate = CreateTrigger();}
			TriggerAddCondition(trUpdate, Condition(func));
		}
		// 注册一个窗口变化事件,不能异步注册
		static method regResizeEvent (code func) {
			if (trResize == null) {trResize = CreateTrigger();}
			TriggerAddCondition(trResize, Condition(func));
		}
		// 注册一个鼠标移动事件,不能异步注册
		static method regMoveEvent (code func) {
			if (trMove == null) {trMove = CreateTrigger();}
			TriggerAddCondition(trMove, Condition(func));
		}

		// 获取鼠标的实数坐标X(0-0.8)
		static method getMouseX ()  -> real {
			integer width = DzGetClientWidth();
			if (width > 0) return DzGetMouseXRelative()* 0.8 / width;
			else return 0.1;
		}

		// 获取鼠标的实数坐标Y(0-0.6)
		static method getMouseY ()  -> real {
			integer height = DzGetClientHeight();
			if (height > 0) return 0.6 - DzGetMouseYRelative()* 0.6 / height;
			else return 0.1; // 防止除以0
		}

		private {
			static trigger trWheel = null;
			static trigger trUpdate = null;
			static trigger trResize = null;
			static trigger trMove = null;
		}

		static method onInit () {
			// 滚轮事件
			DzTriggerRegisterMouseWheelEventByCode(null,false,function (){
				TriggerEvaluate(trWheel);
			});
			// 帧绘制事件
			DzFrameSetUpdateCallbackByCode(function (){
				TriggerEvaluate(trUpdate);
			});
			// 窗口大小变化事件
			DzTriggerRegisterWindowResizeEventByCode(null, false, function (){
				 TriggerEvaluate(trResize);
			});
			// 鼠标移动事件
			DzTriggerRegisterMouseMoveEventByCode(null, false, function (){
				 TriggerEvaluate(trMove);
			});
		}
	}
}

//! endzinc
#endif

#ifndef UITocInitIncluded
#define UITocInitIncluded

//! zinc
/*
Toc初始化,才能使用UI功能
*/
library UITocInit requires BzAPI,LBKKAPI {

  function onInit ()  {
		DzLoadToc("ui\\Crainax.toc");
		DzFrameEnableClipRect(false);
  }
}

//! endzinc
#endif

#ifndef UIImageIncluded
#define UIImageIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
图片UI组件
*/

//# dependency:UI\Widgets\ToolTips\Human\human-tooltip-background2.blp
//# dependency:UI\Widgets\ToolTips\Human\human-tooltip-border2.blp

library UIImage requires UIId,UITocInit,UIBaseModule,UIImageModule {

    public struct uiImage {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiImage)

        module uiImageModule;  // UI图片的共用方法

        // 创建图片
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建工具提示背景图片(种类1)
        // parent: 父级框架
        static method createToolTips (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_TOOLTIPS,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建工具提示背景图片(种类2)
        // parent: 父级框架
        static method createToolTips2 (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_TOOLTIPS2,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建边角(图标系的)
        // parent: 父级框架
        static method createCornerBorder (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BACKDROP",STRING_IMAGE + I2S(id),parent,TEMPLATE_IMAGE_CORNER_BORDER,0);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 创建一个用在原生Frame里的图片,这种图片是不能destroy的!
        // parent: 父级框架
        static method createSimple (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            DzCreateFrameByTagName("SIMPLEFRAME", STRING_IMAGE + I2S(id), parent, TEMPLATE_SIMPLE_IMAGE, id);
            ui = DzSimpleTextureFindByName(TEMPLATE_SIMPLE_IMAGE_CHILD, id);
            DzFrameClearAllPoints(ui);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }

        // 绑定原生图片
        // name: 图片名称(fdf写的image的名字)
        // index: 图片索引(在外部创建时的填写的ID最后一个参数)
        static method bindSimple (string name, integer index) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzSimpleTextureFindByName(name, index);
            STRUCT_SHARED_UI_ONCREATE(uiImage)
            return this;
        }


        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiImage)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif

#ifndef UIAnimTimerIncluded
#define UIAnimTimerIncluded


#include "Crainax/config/SharedMethod.h" // 结构体共用方法

//! zinc
/*
UI动画核心(计时器部分)
*/
library UIAnimTimer {

	//动画计时器事件
	//随便建,但是要reg与unreg才会生效[建只占用个int]影响不大
    //不需要destroy
	public struct uianim {

		//静态成员[trigNum]
		static thistype UIAList[];
		static integer size = 0;
		trigger trig;
		integer trID; //这个是动画在列表中的ID

        STRUCT_SHARED_METHODS(uianim)

        //这个只能同步创建,不能异步创建
		static method create (code fun) -> thistype {
			thistype this = allocate();
            trig = CreateTrigger();
            TriggerAddCondition(trig, Condition(fun));
			return this;
        }

		//动画启动,可重复调用
		method reg () {
            if (!this.isExist()) {return;}
			if (trID == 0) {
				size = size + 1;
				UIAList[size]= this;
				trID = size;
			}
		}
		//关
		method unreg () {
			if (trID != 0) {
				//这个其实就是将List的[2]设成5  假设2是删  5是最长
				//然后实例5的trID设成了2(之后再新建的话又是5了  这个基本也是独立)
				//但是实例[2]本身的内容已经被清除 循环读的是List不受影响(虽然List[5]还是5但是无影响)
				UIAList[trID]= UIAList[size];
				UIAList[trID].trID =trID;
				size = size - 1;
				trID = 0;
			}
		}

        //共享打印方法
        STRUCT_SHARED_PRINT(size,UIAList)

		static method onInit (){
			timer t = CreateTimer();
			TimerStart(t,0.02,true,function () { //计时器运行中
				integer i , this;
				if (size > 0) {
					for (1 <= i <= size) {
						this = UIAList[i];
						TriggerEvaluate(trig); //这里可以设置一个静态成员来传参获得是第几个uia
					}
				}
			});
			t = null;
		}
	}

}

//! endzinc
#endif

#ifndef UIBaseModuleIncluded
#define UIBaseModuleIncluded

//控件的共用基本方法

//! zinc
library UIBaseModule requires UIUtils {
    // 定义共用的方法结构
    public module uiBaseModule {
        // 设置位置
        method setPoint (integer anchor, integer relative, integer relativeAnchor, real offsetX, real offsetY) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetPoint(ui,anchor,relative,relativeAnchor,offsetX,offsetY);
            return this;
        }

        // 大小完全对齐父框架
        method setAllPoint (integer relative) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAllPoints(ui,relative);
            return this;
        }

        //绝对位置
        method setAbsPoint (integer anchor, real x, real y) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAbsolutePoint(ui,anchor,x,y);
            return this;
        }

        // 清除所有位置
        method clearPoint () -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameClearAllPoints(ui);
            return this;
        }

        // 设置大小
        method setSize (real width, real height) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetSize(ui,width,height);
            return this;
        }

        // 设置大小(校正后的),只显示一次,此时改窗口大小不会变化
        method setSizeFix (real width, real height) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetSize(ui,width*GetResizeRate(),height);
            return this;
        }

        // 显示控件
        // 参数: boolean flag 是否显示
        method show (boolean flag) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameShow(ui,flag);
            return this;
        }

        //透明度(0-255)
        method setAlpha (integer value) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetAlpha(ui,value);
            return this;
        }

        optional module extendResize; //扩展自适应大小方法
    }
}
//! endzinc

#endif


#ifndef UILifeCycleIncluded
#define UILifeCycleIncluded

//! zinc
/*
UI生命周期管理器
负责管理UI组件的创建和销毁事件
*/
library UILifeCycle {

    public struct uiLifeCycle [] {

        static integer agrsUI     = 0;
        static integer agrsTypeID = 0;
        static integer agrsFrame  = 0;
        private {
            static trigger trCreate = null;
            static trigger trDestroy = null;
        }

        // 注册创建回调
        static method registerCreate(code func) {
            TriggerAddCondition(trCreate, Condition(func));
        }

        // 注册销毁回调
        static method registerDestroy(code func) {
            TriggerAddCondition(trDestroy, Condition(func));
        }

        static method onCreateCB(integer ui,integer typeID,integer frame) {
            agrsUI = ui;
            agrsTypeID = typeID;
            agrsFrame = frame;
            TriggerEvaluate(trCreate);
        }

        static method onDestroyCB(integer ui,integer typeID,integer frame) {
            agrsUI = ui;
            agrsTypeID = typeID;
            agrsFrame = frame;
            TriggerEvaluate(trDestroy);
        }

        static method onInit () {
            trCreate = CreateTrigger();
            trDestroy = CreateTrigger();
        }

    }
}
//! endzinc
#endif

#ifndef GrowDataIncluded
#define GrowDataIncluded

//! zinc
/*
图标流光的数据
*/
#define ICONGROW_1       1  //蓝光长时等待型
#define ICONGROW_2       2  //双火环绕型
#define ICONGROW_3       3  //闪电流光型
#define ICONGROW_4       4  //紫抛光
#define ICONGROW_5       5  //辰龙流光
#define ICONGROW_6       6  //泛绿光
#define ICONGROW_7       7  //品质-白
#define ICONGROW_8       8  //品质-绿
#define ICONGROW_9       9  //品质-蓝
#define ICONGROW_10      10 //偏折组-1红光
#define ICONGROW_11      11 //品质-紫
#define ICONGROW_12      12 //品质-橙
#define ICONGROW_13      13 //品质-红
#define ICONGROW_14      14 //[IG新2]光彩组-1红
#define ICONGROW_15      15 //[IG新2]偏折组-2黄光
#define ICONGROW_16      16 //[IG新2]偏折组-3紫光
#define ICONGROW_17      17 //[IG新2]偏折组-4蓝光
#define ICONGROW_18      18 //[IG新2]光彩组-2蓝
#define ICONGROW_BTN     19 //[IG新2]光彩按钮
#define ICONGROW_20      20 //[IG新2]光彩组-3绿
#define ICONGROW_21      21 //[IG新2]光彩组-4橙
#define GIF_UPGRADE      22 //异度下的强化成功
#define GIF_SHAKEWAVE1   23 //异度下的小型冲击波
#define GIF_STAR         24 //异度下的星星获得
#define SEQ_LOADING      25 //Loading圖
#define GIF_BUFF         26 //BUFF:提高
#define GIF_ICON_FLASH   27 //最常用的那个刷新动画
#define GIF_ICON_FLASH_2 28 //第二常用的刷新动画
#define GIF_ICON_CLICK   29 //点击动画
#define GIF_ICON_LEVELUP 30 //升级动画

library GrowData {

    public struct growdata [] {

        public {
            integer max;//帧数周期
            integer gap;//播放间隔
            real scale; //UI放大的倍数
            string path;//文件路径
        }
        static method onInit () {

            #define GROWDATA_DEFINE(index, maxValue, gapValue, scaleValue, pathValue) \
                thistype[index].max = maxValue; \
                thistype[index].gap = gapValue; \
                thistype[index].scale = scaleValue; \
                thistype[index].path = pathValue;

            //# check: growdata[1]
            //# sequence: ui/icongrow/ig1_{0-63}.blp
            GROWDATA_DEFINE(ICONGROW_1, 63, 2, 2.65, "ui\\icongrow\\ig1_")
            //# endcheck

            //# check: growdata[2]
            //# sequence: ui/icongrow/ig2_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_2, 11, 3, 1.4, "ui\\icongrow\\ig2_")
            //# endcheck

            //# check: growdata[3]
            //# sequence: ui/icongrow/ig3_{0-13}.blp
            GROWDATA_DEFINE(ICONGROW_3, 13, 3, 1.48, "ui\\icongrow\\ig3_")
            //# endcheck

            //# check: growdata[4]
            //# sequence: ui/icongrow/ig4_{0-14}.blp
            GROWDATA_DEFINE(ICONGROW_4, 14, 3, 1.25, "ui\\icongrow\\ig4_")
            //# endcheck

            //# check: growdata[5]
            //# sequence: ui/icongrow/ig5_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_5, 15, 4, 1.66, "ui\\icongrow\\ig5_")
            //# endcheck

            //# check: growdata[6]
            //# sequence: ui/icongrow/ig6_{0-23}.blp
            GROWDATA_DEFINE(ICONGROW_6, 23, 3, 1.8, "ui\\icongrow\\ig6_")
            //# endcheck

            //# check: growdata[7]
            //# sequence: ui/icongrow/ig7_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_7, 11, 4, 2.0, "ui\\icongrow\\ig7_")
            //# endcheck

            //# check: growdata[8]
            //# sequence: ui/icongrow/ig8_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_8, 11, 4, 2.0, "ui\\icongrow\\ig8_")
            //# endcheck

            //# check: growdata[9]
            //# sequence: ui/icongrow/ig9_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_9, 11, 4, 2.0, "ui\\icongrow\\ig9_")
            //# endcheck

            //# check: growdata[10]
            //# sequence: ui/icongrow/ig10_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_10, 15, 3, 1.22, "ui\\icongrow\\ig10_")
            //# endcheck

            //# check: growdata[11]
            //# sequence: ui/icongrow/ig11_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_11, 11, 4, 2.0, "ui\\icongrow\\ig11_")
            //# endcheck

            //# check: growdata[12]
            //# sequence: ui/icongrow/ig12_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_12, 11, 4, 2.0, "ui\\icongrow\\ig12_")
            //# endcheck

            //# check: growdata[13]
            //# sequence: ui/icongrow/ig13_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_13, 11, 4, 2.0, "ui\\icongrow\\ig13_")
            //# endcheck

            //# check: growdata[15]
            //# sequence: ui/efx/ig104_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_15, 15, 3, 1.22, "ui\\efx\\ig104_")
            //# endcheck

            //# check: growdata[16]
            //# sequence: ui/efx/ig107_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_16, 15, 3, 1.22, "ui\\efx\\ig107_")
            //# endcheck

            //# check: growdata[17]
            //# sequence: ui/efx/ig103_{0-15}.blp
            GROWDATA_DEFINE(ICONGROW_17, 15, 3, 1.22, "ui\\efx\\ig103_")
            //# endcheck

            //# check: growdata[19]
            //# sequence: ui/efx/ig102_{0-11}.blp
            GROWDATA_DEFINE(ICONGROW_BTN, 11, 3, 1.3, "ui\\efx\\ig102_")
            //# endcheck

            //# check: growdata[14]
            //# sequence: ui/efx/ig101_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_14, 9, 3, 1.49, "ui\\efx\\ig101_")
            //# endcheck

            //# check: growdata[18]
            //# sequence: ui/efx/ig100_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_18, 9, 3, 1.38, "ui\\efx\\ig100_")
            //# endcheck

            //# check: growdata[20]
            //# sequence: ui/efx/ig105_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_20, 9, 3, 1.49, "ui\\efx\\ig105_")
            //# endcheck

            //# check: growdata[21]
            //# sequence: ui/efx/ig106_{0-9}.blp
            GROWDATA_DEFINE(ICONGROW_21, 9, 3, 1.49, "ui\\efx\\ig106_")
            //# endcheck

            //# check: growdata[22]
            //# sequence: ui/gif/gif1_{0-16}.blp
            GROWDATA_DEFINE(GIF_UPGRADE, 16, 3, 3.5, "ui\\gif\\gif1_")
            //# endcheck

            //# check: growdata[23]
            //# sequence: ui/gif/gif2_{0-14}.blp
            GROWDATA_DEFINE(GIF_SHAKEWAVE1, 14, 2, 2.5, "ui\\gif\\gif2_")
            //# endcheck

            //# check: growdata[24]
            //# sequence: ui/gif/gif3_{0-17}.blp
            GROWDATA_DEFINE(GIF_STAR, 17, 2, 3.5, "ui\\gif\\gif3_")
            //# endcheck

            //# check: growdata[25]
            //# sequence: ui/efx/ig109_{0-23}.blp
            GROWDATA_DEFINE(SEQ_LOADING, 23, 3, 3.5, "ui\\efx\\ig109_")
            //# endcheck

            //# check: growdata[26]
            //# sequence: ui/efx/ig108_{0-41}.blp
            GROWDATA_DEFINE(GIF_BUFF, 41, 1, 3.0, "ui\\efx\\ig108_")
            //# endcheck

            //# check: growdata[27]
            //# sequence: ui/efx/ig110_{0-15}.blp
            GROWDATA_DEFINE(GIF_ICON_FLASH, 15, 3, 1.38, "ui\\efx\\ig110_")
            //# endcheck

            //# check: growdata[28]
            //# sequence: ui/efx/ig111_{0-10}.blp
            GROWDATA_DEFINE(GIF_ICON_FLASH_2, 10, 3, 1.8, "ui\\efx\\ig111_")
            //# endcheck

            //# check: growdata[29]
            //# sequence: ui/efx/ig112_{0-13}.blp
            GROWDATA_DEFINE(GIF_ICON_CLICK, 13, 1, 1.7, "ui\\efx\\ig112_")
            //# endcheck

            //# check: growdata[30]
            //# sequence: ui/efx/ig113_{0-16}.blp
            GROWDATA_DEFINE(GIF_ICON_LEVELUP, 16, 3, 2.1, "ui\\efx\\ig113_")
            //# endcheck
        }
    }
}

//! endzinc
#endif
#ifndef UIExtendEventIncluded
#define UIExtendEventIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量
#include "Crainax/core/table/Hash_UIDefine.j"

//! zinc
/*
扩展按下和右键事件
*/
library UIExtendEvent requires Hardware,UIHashTable,UILifeCycle {

    //UI的扩充事件回调事件(参数是Frame不是UI结构实例)
    public type uiEvent extends function(integer);

    public struct uiEventState []{
        static boolean rcStart = false;   // 是否开始右键点击
        static integer uiId = 0;         // 点击开始时的UI(判断是否进入过UI)
    }

    public module extendEvent {

        //注册按下事件,只适用于非Simple类型的
        method exLeftDown (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN,func);
            return this;
        }
        //注册抬起事件,只适用于非Simple类型的
        method exLeftUp (uiEvent func)  -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP,func);
            return this;
        }

        // 鼠标进入事件(右键前提强化版)
        method spEnter (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_ENTER,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_ENTER,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                uiEventState.uiId = frame; //修改为使用结构体的静态成员
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_ENTER)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_ENTER);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }
        // 鼠标离开事件(右键前提强化版)
        method spLeave (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_LEAVE,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_LEAVE,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                uiEventState.uiId = 0; //修改为使用结构体的静态成员
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_LEAVE)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_LEAVE);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }

        // 鼠标点击事件,其实这个不是必须项,只是为了统一写法硬加的
        method spClick (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_CLICK,fun);
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOWN,function () {
                integer frame = DzGetTriggerUIEventFrame();
                uiEvent func;
                if (HaveSavedInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_CLICK)) {
                    func = LoadInteger(HASH_UI,frame,HASH_KEY_UI_SIMPLE_EVENT_CLICK);
                    func.evaluate(frame);
                }
            },false);
            return this;
        }

        // 鼠标右键点击事件
        method spRightClick (uiEvent fun) -> thistype {
            if (!this.isExist()) {return this;}
            SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK,fun);
            return this;
        }


        // 下面这批不适Simple的所以全部删除了
        // //注册右键按下事件
        // method exRightDown (uiEvent func)  -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN,func);
        //     return this;
        // }
        // //注册右键抬起事件
        // method exRightUp (uiEvent func)  -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP,func);
        //     return this;
        // }
        // //注册右键点击事件（精确判断）
        // method exRightClick (uiEvent func) -> thistype {
        //     if (!this.isExist()) {return this;}
        //     SaveInteger(HASH_UI,this.ui,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK,func);
        //     return this;
        // }
    }

    function onInit () {
        hardware.regLeftDownEvent(function () { //注册左键按下事件
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;}
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_DOWN);
                func.evaluate(currentUI);
            }
        });
        hardware.regLeftUpEvent(function () { //注册左键抬起事件,在click事件之前触发
            integer currentUI;
            uiEvent func;
            if (!DzIsMouseOverUI()) {return;} //如果鼠标不在游戏内，就不响应该事件
            currentUI = DzGetMouseFocus();
            if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP)) {
                func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_LEFT_UP);
                func.evaluate(currentUI);
            }
        });
        hardware.regRightDownEvent(function () {
            if (uiEventState.uiId != 0) {
                uiEventState.rcStart = true;
            }
        });
        hardware.regRightUpEvent(function () {
            uiEvent func;
            if (uiEventState.rcStart && uiEventState.uiId != 0) {
                if (HaveSavedInteger(HASH_UI,uiEventState.uiId,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK)) {
                    func = LoadInteger(HASH_UI,uiEventState.uiId,HASH_KEY_UI_SIMPLE_EVENT_RIGHT_CLICK);
                    func.evaluate(uiEventState.uiId);
                }
            }
            uiEventState.rcStart = false;
        });
        // UI销毁时如果鼠标正在上面,则触发一次离开事件,不然会引进只进不出的错误
        uiLifeCycle.registerDestroy(function (){
            integer ui = uiLifeCycle.agrsFrame;
            uiEvent func;
            if (uiEventState.uiId == ui && HaveSavedInteger(HASH_UI,ui,HASH_KEY_UI_SIMPLE_EVENT_LEAVE)) {
                func = LoadInteger(HASH_UI,uiEventState.uiId,HASH_KEY_UI_SIMPLE_EVENT_LEAVE);
                func.evaluate(uiEventState.uiId);
            }
            uiEventState.uiId = 0;
        });
        // hardware.regRightDownEvent(function () { //注册右键按下事件
        //     integer currentUI;
        //     uiEvent func;
        //     if (!DzIsMouseOverUI()) {
        //         return;
        //     }
        //     currentUI = DzGetMouseFocus();

        //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN)) {
        //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_DOWN);
        //         func.evaluate(currentUI);
        //     }

        //     // 新增的click判断逻辑
        //     rcStartOnUI = true;
        //     rcStartUI = currentUI;
        // });
        // hardware.regRightUpEvent(function () { //注册右键抬起事件
        //     integer currentUI;
        //     uiEvent func;
        //     if (!DzIsMouseOverUI()) {
        //         return;
        //     }
        //     currentUI = DzGetMouseFocus();

        //     if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP)) {
        //         func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_UP);
        //         func.evaluate(currentUI);
        //     }

        //     // 新增的click判断逻辑
        //     if (rcStartOnUI && currentUI == rcStartUI) {
        //         if (HaveSavedInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK)) {
        //             func = LoadInteger(HASH_UI,currentUI,HASH_KEY_UI_EXTEND_EVENT_RIGHT_CLICK);
        //             func.evaluate(currentUI);
        //         }
        //     }

        //     rcStartOnUI = false;
        //     rcStartUI = 0;
        // });
    }
}

//! endzinc
#endif

#ifndef UIEventModuleIncluded
#define UIEventModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI事件的共用方法
*/
library UIEventModule {
    // 定义共用的方法结构
    public module uiEventModule {
        // 鼠标进入事件
        method onMouseEnter (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_ENTER,fun,false);
            return this;
        }
        // 鼠标离开事件
        method onMouseLeave (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_LEAVE,fun,false);
            return this;
        }
        // 鼠标松开事件,和点击一样,基本可以当相同事件
        // method onMouseUp (code fun) -> thistype {
        //     if (!this.isExist()) {return this;}
        //     DzFrameSetScriptByCode(ui,FRAME_MOUSE_UP,fun,false);
        //     return this;
        // }
        // 鼠标点击事件(效果和FRAME_MOUSE_UP一样,注释掉上面这个了)
        method onMouseClick (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOWN,fun,false);
            return this;
        }
        // 鼠标滚轮事件
        method onMouseWheel (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_WHEEL,fun,false);
            return this;
        }
        // 鼠标双击事件
        method onMouseDoubleClick (code fun) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetScriptByCode(ui,FRAME_MOUSE_DOUBLECLICK,fun,false);
            return this;
        }

        optional module extendEvent;  //扩展事件
    }

}

//! endzinc
#endif

#ifndef UIButtonIncluded
#define UIButtonIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/

//# dependency:ui\image\textbutton_highlight.blp

library UIButton requires UIId,UITocInit,UIBaseModule,UIEventModule {

    public struct uiBtn {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiBtn)

        module   uiEventModule;      // UI事件的共用方法
        optional module extendDrag;  //扩展拖动(只有button能用,其他就不放进去了)

        // 创建一个不带声音的
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_NORMAL_BUTTON,0); //有高亮无声音的图标
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        //普通带声效系
        static method createSound (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_NORMAL_BUTTON,0); //有高亮有声音的图标
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        //右键菜单系
        static method createRC (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("GLUEBUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_TEXT_BUTTON,0); //配合异度下的菜单使用,要导入:ui\image\textbutton_highlight.blp
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        // 创建空白按钮
        // parent: 父级框架
        static method createBlank (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("BUTTON",STRING_BUTTON + I2S(id),parent,TEMPLATE_BLANK_BUTTON,0);
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }

        // 创建一个用在原生Frame里的按钮,这种按钮是不能destroy的!
        // parent: 父级框架
        static method createSimple (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("SIMPLEBUTTON", STRING_BUTTON + I2S(id), parent, TEMPLATE_SIMPLE_BUTTON, id);
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }


        //绑定原生的Button成为SimpleButton,注意不能删除哦
        // 不能用bindSimple,因为没有dzfindSimpleButton函数,只能用这个
        static method bindCreated (integer frame) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = frame;
            STRUCT_SHARED_UI_ONCREATE(uiBtn)
            return this;
        }


        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiBtn)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}



//! endzinc
#endif

#ifndef KKAPIINCLUDE 
#define KKAPIINCLUDE 

library LBKKAPI 
        globals 
                string MOVE_TYPE_NONE = "none" //没有（无视碰撞）  
                string MOVE_TYPE_FOOT = "foot" //步行  
                string MOVE_TYPE_HORSE = "horse" //骑马  
                string MOVE_TYPE_FLY = "fly" //飞行（还具有空中视野，也可以设置飞行高度）  
                string MOVE_TYPE_HOVER = "hover" //浮空（不会踩中地雷）  
                string MOVE_TYPE_FLOAT = "float" //漂浮（只能在深水里活动）  
                string MOVE_TYPE_AMPH = "amph" //两栖  
                string MOVE_TYPE_UNBUILD = "unbuild" //不可建造  
                constant integer DEFENSE_TYPE_LIGHT = 0 
		constant integer DEFENSE_TYPE_MEDIUM = 1 
		constant integer DEFENSE_TYPE_LARGE = 2 
		constant integer DEFENSE_TYPE_FORT = 3 
		constant integer DEFENSE_TYPE_NORMAL = 4 
		constant integer DEFENSE_TYPE_HERO = 5 
		constant integer DEFENSE_TYPE_DIVINE = 6 
		constant integer DEFENSE_TYPE_NONE = 7 
        endglobals 

        native DzGetSelectedLeaderUnit takes nothing returns unit 
        native DzIsChatBoxOpen takes nothing returns boolean 
        native DzSetUnitPreselectUIVisible takes unit whichUnit, boolean visible returns nothing 
        native DzSetEffectAnimation takes effect whichEffect, integer index, integer flag returns nothing 
        native DzSetEffectPos takes effect whichEffect, real x, real y, real z returns nothing 
        native DzSetEffectVertexColor takes effect whichEffect, integer color returns nothing 
        native DzSetEffectVertexAlpha takes effect whichEffect, integer alpha returns nothing 
        native DzSetEffectModel takes effect whichEffect, string model returns nothing
        native DzSetEffectTeamColor takes effect whichHandle, integer playerId returns nothing
        native DzFrameSetClip takes integer whichframe, boolean enable returns nothing 
        native DzChangeWindowSize takes integer width, integer height returns boolean 
        native DzPlayEffectAnimation takes effect whichEffect, string anim, string link returns nothing 
        native DzBindEffect takes widget parent, string attachPoint, effect whichEffect returns nothing 
        native DzUnbindEffect takes effect whichEffect returns nothing 
        native DzSetWidgetSpriteScale takes widget whichUnit, real scale returns nothing 
        native DzSetEffectScale takes effect whichHandle, real scale returns nothing 
        native DzGetEffectVertexColor takes effect whichEffect returns integer 
        native DzGetEffectVertexAlpha takes effect whichEffect returns integer 
        native DzGetItemAbility takes item whichEffect, integer index returns ability 
        native DzFrameGetChildrenCount takes integer whichframe returns integer 
        native DzFrameGetChild takes integer whichframe, integer index returns integer 
        native DzUnlockBlpSizeLimit takes boolean enable returns nothing 
        native DzGetActivePatron takes unit store, player p returns unit 
        native DzGetLocalSelectUnitCount takes nothing returns integer 
        native DzGetLocalSelectUnit takes integer index returns unit 
        native DzGetJassStringTableCount takes nothing returns integer 
        native DzModelRemoveFromCache takes string path returns nothing 
        native DzModelRemoveAllFromCache takes nothing returns nothing 
        native DzFrameGetInfoPanelSelectButton takes integer index returns integer 
        native DzFrameGetInfoPanelBuffButton takes integer index returns integer 
        native DzFrameGetPeonBar takes nothing returns integer 
        native DzFrameGetCommandBarButtonNumberText takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonNumberOverlay takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonCooldownIndicator takes integer whichframe returns integer 
        native DzFrameGetCommandBarButtonAutoCastIndicator takes integer whichframe returns integer 
        native DzToggleFPS takes boolean show returns nothing 
        native DzGetFPS takes nothing returns integer 
        native DzFrameWorldToMinimapPosX takes real x, real y returns real 
        native DzFrameWorldToMinimapPosY takes real x, real y returns real 
        native DzWidgetSetMinimapIcon takes unit whichunit, string path returns nothing 
        native DzWidgetSetMinimapIconEnable takes unit whichunit, boolean enable returns nothing 
        native DzFrameGetWorldFrameMessage takes nothing returns integer 
        native DzSimpleMessageFrameAddMessage takes integer whichframe, string text, integer color, real duration, boolean permanent returns nothing 
        native DzSimpleMessageFrameClear takes integer whichframe returns nothing 
        //转换屏幕坐标到世界坐标  
        native DzConvertScreenPositionX takes real x, real y returns real 
        native DzConvertScreenPositionY takes real x, real y returns real 
        //监听建筑选位置  
        native DzRegisterOnBuildLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnBuildOrderId takes nothing returns integer 
        native DzGetOnBuildOrderType takes nothing returns integer 
        native DzGetOnBuildAgent takes nothing returns widget 
        //监听技能选目标  
        native DzRegisterOnTargetLocal takes code func returns nothing 
        //等于0时是结束事件  
        native DzGetOnTargetAbilId takes nothing returns integer 
        native DzGetOnTargetOrderId takes nothing returns integer 
        native DzGetOnTargetOrderType takes nothing returns integer 
        native DzGetOnTargetAgent takes nothing returns widget 
        native DzGetOnTargetInstantTarget takes nothing returns widget 
        // 打开QQ群链接  
        native DzOpenQQGroupUrl takes string url returns boolean 
        native DzFrameEnableClipRect takes boolean enable returns nothing 
        native DzSetUnitName takes unit whichUnit, string name returns nothing 
        native DzSetUnitPortrait takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitDescription takes unit whichUnit, string value returns nothing 
        native DzSetUnitMissileArc takes unit whichUnit, real arc returns nothing 
        native DzSetUnitMissileModel takes unit whichUnit, string modelFile returns nothing 
        native DzSetUnitProperName takes unit whichUnit, string name returns nothing 
        native DzSetUnitMissileHoming takes unit whichUnit, boolean enable returns nothing 
        native DzSetUnitMissileSpeed takes unit whichUnit, real speed returns nothing 
        native DzSetEffectVisible takes effect whichHandle, boolean enable returns nothing 
        native DzReviveUnit takes unit whichUnit, player whichPlayer, real hp, real mp, real x, real y returns nothing 
        native DzGetAttackAbility takes unit whichUnit returns ability 
        native DzAttackAbilityEndCooldown takes ability whichHandle returns nothing 
        native EXSetUnitArrayString takes integer uid, integer id, integer n, string name returns boolean 
        native EXSetUnitInteger takes integer uid, integer id, integer n returns boolean 
        function DzSetHeroTypeProperName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 61, 0, name) 
                call EXSetUnitInteger(uid, 61, 1) 
        endfunction 
        function DzSetUnitTypeName takes integer uid, string name returns nothing 
                call EXSetUnitArrayString(uid, 10, 0, name) 
                call EXSetUnitInteger(uid, 10, 1) 
        endfunction 
        function DzIsUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns boolean 
                return ConvertAttackType(R2I(GetUnitState(whichUnit, ConvertUnitState(16 + 19 * index)))) == attackType 
        endfunction 
        function DzSetUnitAttackType takes unit whichUnit, integer index, attacktype attackType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(16 + 19 * index), GetHandleId(attackType)) 
        endfunction 
        function DzIsUnitDefenseType takes unit whichUnit, integer defenseType returns boolean 
                return R2I(GetUnitState(whichUnit, ConvertUnitState(0x50))) == defenseType 
        endfunction 
        function DzSetUnitDefenseType takes unit whichUnit, integer defenseType returns nothing 
                call SetUnitState(whichUnit, ConvertUnitState(0x50), defenseType) 
        endfunction 

        // 地形装饰物
        native DzDoodadCreate takes integer id, integer var, real x, real y, real z, real rotate, real scale returns integer 
        native DzDoodadGetTypeId takes integer doodad returns integer 
        native DzDoodadSetModel takes integer doodad, string modelFile returns nothing 
        native DzDoodadSetTeamColor takes integer doodad, integer color returns nothing 
        native DzDoodadSetColor takes integer doodad, integer color returns nothing 
        native DzDoodadGetX takes integer doodad returns real 
        native DzDoodadGetY takes integer doodad returns real 
        native DzDoodadGetZ takes integer doodad returns real 
        native DzDoodadSetPosition takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixRotate takes integer doodad, real angle, real axisX, real axisY, real axisZ returns nothing 
        native DzDoodadSetOrientMatrixScale takes integer doodad, real x, real y, real z returns nothing 
        native DzDoodadSetOrientMatrixResize takes integer doodad returns nothing 
        native DzDoodadSetVisible takes integer doodad, boolean enable returns nothing 
        native DzDoodadSetAnimation takes integer doodad, string animName, boolean animRandom returns nothing 
        native DzDoodadSetTimeScale takes integer doodad, real scale returns nothing 
        native DzDoodadGetTimeScale takes integer doodad returns real 
        native DzDoodadGetCurrentAnimationIndex takes integer doodad returns integer 
        native DzDoodadGetAnimationCount takes integer doodad returns integer 
        native DzDoodadGetAnimationName takes integer doodad, integer index returns string 
        native DzDoodadGetAnimationTime takes integer doodad, integer index returns integer 
        // 解锁JASS字节码限制
        native DzUnlockOpCodeLimit takes boolean enable returns nothing
        // 设置剪切板内容
        native DzSetClipboard takes string content returns boolean
        //删除装饰物
        native DzDoodadRemove takes integer doodad returns nothing
        //移除科技等级
        native DzRemovePlayerTechResearched takes player whichPlayer, integer techid, integer removelevels returns nothing
        
        // 查找单位技能
        native DzUnitFindAbility takes unit whichUnit, integer abilcode returns ability
        // 修改技能数据-字符串
        native DzAbilitySetStringData takes ability whichAbility, string key, string value returns nothing
                
        // 启用/禁用技能
        native DzAbilitySetEnable takes ability whichAbility, boolean enable, boolean hideUI returns nothing
        // 设置单位移动类型
        native DzUnitSetMoveType takes unit whichUnit, string moveType returns nothing
        // 获取控件宽度
        native DzFrameGetWidth takes integer frame returns real
        native DzFrameSetAnimateByIndex takes integer frame, integer index, integer flag returns nothing
        native DzSetUnitDataCacheInteger takes integer uid, integer id,integer index,integer v returns nothing
        native DzUnitUIAddLevelArrayInteger takes integer uid, integer id,integer lv,integer v returns nothing

        function KKWESetUnitDataCacheInteger takes integer uid,integer id,integer v returns nothing
                call DzSetUnitDataCacheInteger( uid, id, 0, v)
        endfunction

        function KKWEUnitUIAddUpgradesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 94, id, v)
        endfunction

        function KKWEUnitUIAddBuildsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 100, id, v)
        endfunction

        function KKWEUnitUIAddResearchesIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 112, id, v)
        endfunction

        function KKWEUnitUIAddTrainsIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 106, id, v)
        endfunction

        function KKWEUnitUIAddSellsUnitIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 118, id, v)
        endfunction

        function KKWEUnitUIAddSellsItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 124, id, v)
        endfunction

        function KKWEUnitUIAddMakesItemIds takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 130, id, v)
        endfunction

        function KKWEUnitUIAddRequiresUnitCode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction

        function KKWEUnitUIAddRequiresTechcode takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 166, id, v)
        endfunction

        function KKWEUnitUIAddRequiresAmounts takes integer uid,integer id,integer v returns nothing
                call DzUnitUIAddLevelArrayInteger( uid, 172, id, v)
        endfunction

         // 设置道具模型
        native DzItemSetModel takes item whichItem, string file returns nothing
        // 设置道具颜色
        native DzItemSetVertexColor takes item whichItem, integer color returns nothing
        // 设置道具透明度
        native DzItemSetAlpha takes item whichItem, integer color returns nothing
        // 设置道具头像
        native DzItemSetPortrait takes item whichItem, string modelPath returns nothing

endlibrary



// [DzSetUnitMoveType]  
// title = "设置单位移动类型[NEW]"  
// description = "设置 ${单位} 的移动类型：${movetype} "  
// comment = ""  
// category = TC_KKPRE  
// [[.args]]  
// type = unit  
// [[.args]]  
// type = MoveTypeName  
// default = MoveTypeName01  


#endif 


#ifndef UIImageModuleIncluded
#define UIImageModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI图片的共用方法
*/

library UIImageModule {
    // 定义共用的方法结构
    public module uiImageModule {
        // 设置图片路径
        method setTexture (string path) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetTexture(this.ui,path,0);
            return this;
        }

        // 设置图片控件视口,防止模型超出范围
        method setClip (boolean clip) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetClip(this.ui,clip);
            return this;
        }


    }

}


//! endzinc
#endif

#ifndef UnitTestFramworkIncluded
#define UnitTestFramworkIncluded

/*
单元测试框架(注入)
*/

//! zinc
library UnitTestFramwork {

	//单元测试总
	trigger TUnitTest = null;

    //注册单元测试事件(聊天内容),自动注入
    public function UnitTestRegisterChatEvent (code func) {
        TriggerAddAction(TUnitTest, func);
    }

    function onInit ()  {
        //在游戏开始0.1秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.1);
        TriggerAddCondition(tr,Condition(function (){
            integer i;
            for (1 <= i <= 12) {
				SetPlayerName(ConvertedPlayer(i),"测试员" + I2S(i)+ "号");
                CreateFogModifierRectBJ( true, ConvertedPlayer(i), FOG_OF_WAR_VISIBLE, GetPlayableMapRect() ); //迷雾全关
            }
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

		TUnitTest = CreateTrigger();
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(0), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(1), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(2), "", false );
		TriggerRegisterPlayerChatEvent(TUnitTest, Player(3), "", false );
    }
}

//! endzinc
#endif



#ifndef BZAPIINCLUDE
#define BZAPIINCLUDE

library BzAPI
    //hardware
    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    //plus
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzGetLocale takes nothing returns string
    native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
    //sync
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    //native DzGetPushContext takes nothing returns string
    native DzSyncDataImmediately takes string prefix, string data returns nothing   
    //gui
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
    native DzFrameSetPriority takes integer frame, integer priority returns nothing
    native DzFrameSetParent takes integer frame, integer parent returns nothing
    native DzFrameGetHeight takes integer frame returns real
    native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
    native DzFrameGetParent takes integer frame returns integer
    native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
    native DzFrameGetName takes integer frame returns string
    native DzGetClientWidth takes nothing returns integer
    native DzGetClientHeight takes nothing returns integer
    native DzFrameIsVisible takes integer frame returns boolean
        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）
    native DzFrameAddText takes integer frame, string text returns nothing
    // 沉默单位-禁用技能
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    // 禁用攻击
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    // 禁用道具
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    // 刷新小地图
    native DzUpdateMinimap takes nothing returns nothing
    // 修改单位alpha
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    // 设置单位是否可以选中
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    // 修改单位是否可以被设置为目标
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    // 保存内存数据
    native DzSaveMemoryCache takes string cache returns nothing
    // 读取内存数据
    native DzGetMemoryCache takes nothing returns string
    // 设置加速倍率
    native DzSetSpeed takes real ratio returns nothing
    // 转换世界坐标为屏幕坐标-异步
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    // 转换世界坐标为屏幕坐标-获取转换后的X坐标
    native DzGetConvertWorldPositionX takes nothing returns real
    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标
    native DzGetConvertWorldPositionY takes nothing returns real
    // 创建command button
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
    function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction

    function DzTriggerRegisterKeyEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
    endfunction

    function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseMoveEvent(trg, true, null)
    endfunction

    function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseWheelEvent(trg, true, null)
    endfunction

    function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterWindowResizeEvent(trg, true, null)
    endfunction

    function DzF2I takes integer i returns integer
        return i
    endfunction

    function DzI2F takes integer i returns integer
        return i
    endfunction

    function DzK2I takes integer i returns integer
        return i
    endfunction

    function DzI2K takes integer i returns integer
        return i
    endfunction

    function DzTriggerRegisterMallItemSyncData takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIA", true)
    endfunction

    //玩家消耗/使用商城道具事件
    function DzTriggerRegisterMallItemConsumeEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIC", true)
    endfunction

    //玩家删除商城道具事件
    function DzTriggerRegisterMallItemRemoveEvent takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMID", true)
    endfunction

    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction

    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction

    

endlibrary

#endif /// YDWEAddAIOrderIncluded

#ifndef UnitPanelIncluded
#define UnitPanelIncluded

//! zinc
/*
单位面板的控制
*/

// https://tieba.baidu.com/p/6580193364?pid=131079515410&cid=0&red_tag=2120364315#131079515410
// https://tieba.baidu.com/p/8067593125?pid=145736219847&cid=145742891494#145742891494
// http://bbs.mvprpg.com/forum.php?mod=viewthread&tid=493042&extra=

/*
4，原生框架及 置父类型
SIMPLEFRAME：框架
单位面板：SimpleInfoPanelUnitDetail  ID：0

英雄属性：SimpleInfoPanelIconHero  ID：6

攻击：SimpleInfoPanelIconDamage  ID：0
防御：SimpleInfoPanelIconArmor   ID：2

经验框：SimpleHeroLevelBar  ID：0
经验条：SimpleProgressIndicator  ID：0

建造页面：SimpleInfoPanelBuildingDetail   ID：1
建造物名称：SimpleBuildingNameValue  ID：1
建造列队条：SimpleBuildTimeIndicator   ID：1


未知：SimpleInfoPanelIconArmor  ID：2

SimpleFontString：
单位名称：SimpleNameValue   ID：0

种类即英雄等级：SimpleClassValue   ID：0

建造行动标签：SimpleBuildingActionLabel   ID：1

SimpleTexture：
建造列队背景：SimpleBuildQueueBackdrop   ID：1
单位图标：InfoPanelIconBackdrop     ID：0为攻击1，1为攻击2，2为防御
面板科技等级：InfoPanelIconLevel    ID：0为攻击1，1为攻击2，2为防御
单位基础数值：InfoPanelIconValue    ID：0为攻击1，1为攻击2，2为防御
基础数值标签：InfoPanelIconLabel    ID：0为攻击1，1为攻击2，2为防御

注意：原版的面板框架并不支持所有的类型置父


能支持的只有
SIMPLEFRAME
SIMPLESTATUSBAR
SIMPLECHECKBOX
SIMPLEBUTTON
TEXTAREA
这些类型。
*/

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

library UnitPanel requires UIButton,UIText,UIImage,UIExtendEvent,Icon {


    public struct unitPanel []{

        static icon iconAttack  = 0; static icon iconArmor    = 0;
        static icon iconHero    = 0; static icon iconBuilding = 0;
        static icon iconMonster = 0;

        static uiText textAttack   = 0; static uiText  textAttackValue  = 0;  //攻击相关
        static uiText textArmor    = 0; static uiText textArmorValue    = 0;  //防御相关
        static uiText textStr      = 0; static uiText  textStrValue     = 0;  //力量
        static uiText textAgi      = 0; static uiText  textAgiValue     = 0;  //敏捷
        static uiText textInt      = 0; static uiText  textIntValue     = 0;  //智力
        static uiText textBuilding = 0; static uiText textBuildingValue = 0;

        // 事件触发器
        private {
            static trigger trAttackEnter   = null; static trigger trAttackLeave        = null;
            static trigger trAttackClick   = null; static trigger trAttackRightClick   = null;
            static trigger trArmorEnter    = null; static trigger trArmorLeave         = null;
            static trigger trArmorClick    = null; static trigger trArmorRightClick    = null;
            static trigger trHeroEnter     = null; static trigger trHeroLeave          = null;
            static trigger trHeroClick     = null; static trigger trHeroRightClick     = null;
            static trigger trBuildingEnter = null; static trigger trBuildingLeave      = null;
            static trigger trBuildingClick = null; static trigger trBuildingRightClick = null;
            static trigger trMonsterEnter  = null; static trigger trMonsterLeave       = null;
            static trigger trMonsterClick  = null; static trigger trMonsterRightClick  = null;
        }

        #define onUnitPanelTrigger(name,evt) \
        static method on##name##evt (code func) { \
        if (tr##name##evt == null) tr##name##evt = CreateTrigger(); \
        TriggerAddCondition(tr##name##evt, Condition(func)); }

        #define onUnitPanelAllEvents(name) \
        onUnitPanelTrigger(name,Enter) CRNL \
        onUnitPanelTrigger(name,Leave) CRNL \
        onUnitPanelTrigger(name,Click) CRNL \
        onUnitPanelTrigger(name,RightClick) CRNL

        // 使用新的宏一次性生成每个部分的所有事件
        onUnitPanelAllEvents(Attack)
        onUnitPanelAllEvents(Armor)
        onUnitPanelAllEvents(Hero)
        onUnitPanelAllEvents(Building)
        onUnitPanelAllEvents(Monster)

        #undef onUnitPanelTrigger
        #undef onUnitPanelAllEvents

        // 地图初始化
        private static method mapInit () {
            integer parent,child;
            uiBtn btn;

            //攻击小框架相关
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2); //防御的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upAttack", parent, "单位面板框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconAttack = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.006)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp");
            btn = iconAttack.getClickBtn()
                .spEnter(function(integer frame) {if (trAttackEnter != null) TriggerEvaluate(trAttackEnter);})
                .spLeave(function(integer frame) {if (trAttackLeave != null) TriggerEvaluate(trAttackLeave);})
                .spClick(function(integer frame) {if (trAttackClick != null) TriggerEvaluate(trAttackClick);})
                .spRightClick(function(integer frame) {if (trAttackRightClick != null) TriggerEvaluate(trAttackRightClick);});
            textAttack = uiText.bindSimple("单位面板属性名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconAttack.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("攻击:");
            textAttackValue = uiText.bindSimple("单位面板数值", 0)
                .setPoint(ANCHOR_BOTTOMLEFT, iconAttack.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("0");

            //防御小框架相关
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upArmor", parent, "单位面板框架", 1);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconArmor = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 1), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.0295, -0.037)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNDarkSummoning.blp");
            btn = iconArmor.getClickBtn()
                .spEnter(function(integer frame) {if (trArmorEnter != null) TriggerEvaluate(trArmorEnter);})
                .spLeave(function(integer frame) {if (trArmorLeave != null) TriggerEvaluate(trArmorLeave);})
                .spClick(function(integer frame) {if (trArmorClick != null) TriggerEvaluate(trArmorClick);})
                .spRightClick(function(integer frame) {if (trArmorRightClick != null) TriggerEvaluate(trArmorRightClick);});
            textArmor = uiText.bindSimple("单位面板属性名", 1)
                .setPoint(ANCHOR_TOPLEFT, iconArmor.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("防御:");
            textArmorValue = uiText.bindSimple("单位面板数值", 1)
                .setPoint(ANCHOR_BOTTOMLEFT, iconArmor.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("20");

            //英雄属性三围
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6); //英雄属性的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upHero", parent, "英雄三围框架", 0);
            DzFrameClearAllPoints( child ); //这条必不可少,不然会杂糅在一起
            iconHero = icon.fromExistingUI(uiImage.bindSimple("英雄三围图标", 0), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNJanggo.blp");
            btn = iconHero.getClickBtn()
                .spEnter(function(integer frame) {if (trHeroEnter != null) TriggerEvaluate(trHeroEnter);})
                .spLeave(function(integer frame) {if (trHeroLeave != null) TriggerEvaluate(trHeroLeave);})
                .spClick(function(integer frame) {if (trHeroClick != null) TriggerEvaluate(trHeroClick);})
                .spRightClick(function(integer frame) {if (trHeroRightClick != null) TriggerEvaluate(trHeroRightClick);});

            //力量
            textStr = uiText.bindSimple("英雄力量名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, 0.027)
                .setText("力量:");
            textStrValue = uiText.bindSimple("英雄力量值", 0)
                .setPoint(ANCHOR_TOPLEFT, textStr.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("10");

            //敏捷
            textAgi = uiText.bindSimple("英雄敏捷名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, 0.006)
                .setText("敏捷:");
            textAgiValue = uiText.bindSimple("英雄敏捷值", 0)
                .setPoint(ANCHOR_TOPLEFT, textAgi.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("20");

            //智力
            textInt = uiText.bindSimple("英雄智力名", 0)
                .setPoint(ANCHOR_TOPLEFT, iconHero.mainImage.ui, ANCHOR_CENTER, 0.017, -0.015)
                .setText("智力:");
            textIntValue = uiText.bindSimple("英雄智力值", 0)
                .setPoint(ANCHOR_TOPLEFT, textInt.ui, ANCHOR_BOTTOMLEFT, 0.005, -0.001)
                .setText("30");

            //建筑小框架相关
            parent = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7); //建筑的父框架
            child = DzCreateFrameByTagName("SIMPLEFRAME", "upBuilding", parent, "单位面板框架", 2);
            DzFrameClearAllPoints(child);
            iconBuilding = icon.fromExistingUI(uiImage.bindSimple("单位面板图标", 2), parent)
                .setSize(0.027, 0.027)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNTownHall.blp");
            btn = iconBuilding.getClickBtn()
                .spEnter(function(integer frame) {if (trBuildingEnter != null) TriggerEvaluate(trBuildingEnter);})
                .spLeave(function(integer frame) {if (trBuildingLeave != null) TriggerEvaluate(trBuildingLeave);})
                .spClick(function(integer frame) {if (trBuildingClick != null) TriggerEvaluate(trBuildingClick);})
                .spRightClick(function(integer frame) {if (trBuildingRightClick != null) TriggerEvaluate(trBuildingRightClick);});
            textBuilding = uiText.bindSimple("单位面板属性名", 2)
                .setPoint(ANCHOR_TOPLEFT, iconBuilding.mainImage.ui, ANCHOR_TOPRIGHT, 0.003, -0.003)
                .setText("防护罩:");
            textBuildingValue = uiText.bindSimple("单位面板数值", 2)
                .setPoint(ANCHOR_BOTTOMLEFT, iconBuilding.mainImage.ui, ANCHOR_BOTTOMRIGHT, 0.008, 0.003)
                .setText("1");

            //怪物属性框架
            iconMonster = icon.createSimple(DzSimpleFrameFindByName("SimpleInfoPanelIconRank", 3))
                .setSize(0.027, 0.027)
            // .setPoint(ANCHOR_CENTER, DzGetGameUI(), ANCHOR_CENTER, 0,0)
                .setPoint(ANCHOR_CENTER, DzFrameGetPortrait(), ANCHOR_RIGHT, 0.1235, -0.02)
                .setTexture("ReplaceableTextures\\CommandButtons\\BTNSkeletonArcher.blp");
            btn = iconMonster.getClickBtn()
                .spEnter(function(integer frame) {if (trMonsterEnter != null) TriggerEvaluate(trMonsterEnter);})
                .spLeave(function(integer frame) {if (trMonsterLeave != null) TriggerEvaluate(trMonsterLeave);})
                .spClick(function(integer frame) {if (trMonsterClick != null) TriggerEvaluate(trMonsterClick);})
                .spRightClick(function(integer frame) {if (trMonsterRightClick != null) TriggerEvaluate(trMonsterRightClick);});
        }

        // 友方建筑单位的金币之类的东西(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutBuilding (){
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconAlly", 7);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        // 怪物的科技原生面板(会频繁重置,需要在选择单位时就重新处理)
        static method moveOutMonster () {
            integer ui = DzSimpleFrameFindByName("SimpleInfoPanelIconRank", 3);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        //把所有原生UI移走
        static method moveOutAll () {
            integer ui;
            // 攻击1
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 0);
            DzFrameSetSize( ui, 0.03, 0.03 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 攻击2
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 1);
            DzFrameSetSize( ui, 0.03, 0.03 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 护甲
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 2);
            DzFrameSetSize( ui, 0.001, 0.001 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 食物
            ui = DzSimpleTextureFindByName("InfoPanelIconBackdrop", 4);
            DzFrameSetSize( ui, 0.001, 0.001 );
            DzFrameClearAllPoints( ui );
            DzFrameSetAbsolutePoint( ui, 4, 0.80, -0.60 );
            // 英雄三围面板
            ui = DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6);
            DzFrameSetSize( ui, 0.02, 0.02 );
            DzFrameClearAllPoints( ui );
            DzFrameSetPoint( ui, 4, DzGetGameUI(), 4, 0.80, -0.60 );
        }

        //初始化单位按钮面板
        private static method onInit () {
            //在游戏开始0.0秒后再调用
            trigger tr = CreateTrigger();
            TriggerRegisterTimerEventSingle(tr,0.0);
            TriggerAddCondition(tr,Condition(function (){
                moveOutAll(); // 把所有原生UI移走
                mapInit(); // 初始化单位按钮面板
                DestroyTrigger(GetTriggeringTrigger());
            }));
            tr = null;
        }


    }


}

//! endzinc
#endif

#ifndef UITextModuleIncluded
#define UITextModuleIncluded

#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
UI文本的共用方法
*/

#define FONT_SIZE_HUGE   0.015 // 特大号
#define FONT_SIZE_LARGE  0.012 // 大号
#define FONT_SIZE_MEDIUM 0.011 // 中号
#define FONT_SIZE_NORMAL 0.01  // 标准
#define FONT_SIZE_SMALL  0.009 // 小号
#define FONT_SIZE_TINY   0.008 // 特小号
#define FONT_SIZE_MINI   0.006 // 迷你号


library UITextModule {
    // 定义共用的方法结构
    public module uiTextModule {

        // 设置标准字体大小
        // size: 1=迷你号, 2=特小号, 3=小号, 4=标准, 5=中号, 6=大号, 7=特大号
        method setFontSize (integer size) -> thistype {
            real fontSize = FONT_SIZE_NORMAL;
            if (!this.isExist()) {return this;}

            if (size == 1) {
                fontSize = FONT_SIZE_MINI;
            } else if (size == 2) {
                fontSize = FONT_SIZE_TINY;
            } else if (size == 3) {
                fontSize = FONT_SIZE_SMALL;
            } else if (size == 4) {
                fontSize = FONT_SIZE_NORMAL;
            } else if (size == 5) {
                fontSize = FONT_SIZE_MEDIUM;
            } else if (size == 6) {
                fontSize = FONT_SIZE_LARGE;
            } else if (size == 7) {
                fontSize = FONT_SIZE_HUGE;
            }

            DzFrameSetFont(ui, "fonts\\zt.ttf", fontSize, 0);
            return this;
        }

        // 设置对齐方式(前提要先定好大小,不然无处对齐)
        // align: 可以使用0-8的简单数字,或TEXT_ALIGN_*常量
        // 0=左上, 1=顶部居中, 2=右上
        // 3=左中, 4=居中, 5=右中
        // 6=左下, 7=底部居中, 8=右下
        method setAlign (integer align) -> thistype {
            integer finalAlign = align;

            if (!this.isExist()) {return this;}

            // 如果输入0-8,转换为对应的组合值
            if (align >= 0 && align <= 8) {
                if (align == 0) {
                    finalAlign = 9;       // 左上
                } else if (align == 1) {
                    finalAlign = 17;      // 顶部居中
                } else if (align == 2) {
                    finalAlign = 33;      // 右上
                } else if (align == 3) {
                    finalAlign = 10;      // 左中
                } else if (align == 4) {
                    finalAlign = 18;      // 居中
                } else if (align == 5) {
                    finalAlign = 34;      // 右中
                } else if (align == 6) {
                    finalAlign = 12;      // 左下
                } else if (align == 7) {
                    finalAlign = 20;      // 底部居中
                } else if (align == 8) {
                    finalAlign = 36;      // 右下
                }
            }

            DzFrameSetTextAlignment(ui, finalAlign);
            return this;
        }

        // 设置文本内容
        method setText (string text) -> thistype {
            if (!this.isExist()) {return this;}
            DzFrameSetText(ui,text);
            return this;
        }

    }

}

#undef FONT_SIZE_HUGE
#undef FONT_SIZE_LARGE
#undef FONT_SIZE_MEDIUM
#undef FONT_SIZE_NORMAL
#undef FONT_SIZE_SMALL
#undef FONT_SIZE_TINY
#undef FONT_SIZE_MINI


//! endzinc
#endif

#ifndef UITextIncluded
#define UITextIncluded

#include "Crainax/config/SharedMethod.h" // 结构体共用方法
#include "Crainax/ui/constants/UIConstants.j" // UI常量

//! zinc
/*
文字UI组件
*/
library UIText requires STRUCT_SHARED_REQUIRE_UI,UITextModule {


    public struct uiText {
        // UI组件内部共享方法及成员
        STRUCT_SHARED_INNER_UI(uiText)

        // UI控件的共用方法
        module uiTextModule;   // UI文本的共用方法

        // 创建文本
        // parent: 父级框架
        static method create (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzCreateFrameByTagName("TEXT",STRING_TEXT + I2S(id),parent,TEMPLATE_TEXT,0);
            STRUCT_SHARED_UI_ONCREATE(uiText)
            return this;
        }

        // 创建一个用在原生Frame里的文本,这种文本是不能destroy的!
        // parent: 父级框架
        static method createSimple (integer parent) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            DzCreateFrameByTagName("SIMPLEFRAME", STRING_TEXT + I2S(id), parent, TEMPLATE_SIMPLE_TEXT, id);
            ui = DzSimpleFontStringFindByName(TEMPLATE_SIMPLE_TEXT_CHILD, id);
            DzFrameClearAllPoints(ui);
            STRUCT_SHARED_UI_ONCREATE(uiText)
            return this;
        }

        // 绑定原生文本
        // name: 文本名称(fdf写的text的名字)
        // index: 文本索引(在外部创建时的填写的ID最后一个参数)
        static method bindSimple (string name, integer index) -> thistype {
            thistype this = allocate();
            id = uiId.get();
            ui = DzSimpleFontStringFindByName(name, index);
            DzFrameClearAllPoints(ui);
            STRUCT_SHARED_UI_ONCREATE(uiText)
            return this;
        }

        method onDestroy () {
            if (!this.isExist()) {return;}
            STRUCT_SHARED_UI_ONDESTROY(uiText)
            DzDestroyFrame(ui);
            uiId.recycle(id);
        }
    }
}

//! endzinc
#endif

#ifndef UnitTestUIRulerIncluded
#define UnitTestUIRulerIncluded

/*
用来测量UI组件的尺寸
*/

#include "Crainax/input/constant/KeyConstants.j"
#include "Crainax/ui/constants/UIConstants.j" // UI常量


//! zinc
library UnitTestUIRuler requires UIImage,UIText,UIUtils,Hardware,Keyboard {

	//单元测试总
	trigger TUnitTest = null;
    boolean isShowRuler = false; //是否显示尺子
    uiImage imageAnchor = 0; //锚点,按下Ctrl再点击鼠标左键定锚
    real anchorPosX = 0; //锚点X坐标
    real anchorPosY = 0; //锚点Y坐标
    uiImage imageRuler[]; //尺子(4把常规的)+一把锚点尺
    uiText textRuler[]; //尺子上的文字

    //触发UI尺子调用这条就行了
    public function InitTestUIRuler () {
        DoNothing();
    }

    function onInit ()  {
        integer i;
        trigger tr = CreateTrigger();

        // 初始化锚点在地图中心
        anchorPosX = 0.4;
        anchorPosY = 0.3;

        imageAnchor = uiImage.create(DzGetGameUI()) //锚点钉
            .setSize(0.005,0.005)
            .show(false)
            .setAbsPoint(ANCHOR_CENTER, anchorPosX, anchorPosY) // 设置初始位置
            .setTexture("UI\\MiniMap\\minimap-gold.blp");

        for (1 <= i <= 5) {
            imageRuler[i] = uiImage.create(DzGetGameUI());
            textRuler[i] = uiText.create(DzGetGameUI()) //上
                .setAlign(4)
                .show(false)
                .setText("0.000");
        }

        // 创建尺子图像
        for (1 <= i <= 2) { //上下
            imageRuler[i].setPoint(ANCHOR_TOP, textRuler[i].ui, ANCHOR_TOP, 0, 0)
                .setPoint(ANCHOR_BOTTOM, textRuler[i].ui, ANCHOR_BOTTOM, 0, 0)
                .setSize(0.01, 0.01)
                .show(false)
                .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        }

        // 创建尺子图像
        for (3 <= i <= 4) { //左右
            imageRuler[i].setAllPoint(textRuler[i].ui)
                .show(false)
                .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        }

        // 创建锚点到鼠标的尺子
        imageRuler[5].show(false)
            .setAlpha(100)
            .setTexture("UI\\Widgets\\EscMenu\\Human\\editbox-background.blp");
        textRuler[5].setPoint(ANCHOR_CENTER, imageRuler[5].ui, ANCHOR_CENTER, 0, 0)
            .setSize(0.1, 0);


        // ESC键切换显示/隐藏
        keyboard.regKeyUpEvent(KEY_ESC, function (){
            integer i;
            isShowRuler = !isShowRuler;
            if (isShowRuler) {
                imageAnchor.show(true);
                for (1 <= i <= 5) {
                    imageRuler[i].show(true);
                    textRuler[i].show(true);
                }
            } else {
                imageAnchor.show(false);
                for (1 <= i <= 5) {
                    imageRuler[i].show(false);
                    textRuler[i].show(false);
                }
            }
        });

        // 添加鼠标点击事件
        hardware.regLeftUpEvent(function() {
            real mouseX;
            real mouseY;

            if (!isShowRuler) return;

            if (DzIsKeyDown(KEY_CONTROL)) {
                mouseX = GetMouseXEx();
                mouseY = GetMouseYEx();
                imageAnchor.setAbsPoint(ANCHOR_CENTER, mouseX, mouseY);
                anchorPosX = mouseX; // 记录锚点位置
                anchorPosY = mouseY;
                BJDebugMsg("参考物位置: " + R2SW(mouseX, 7, 3) + " " + R2SW(mouseY, 7, 3));
            } else {
                // 添加打印边距信息
                mouseX = GetMouseXEx();
                mouseY = GetMouseYEx();
                BJDebugMsg("距离边界: " +
                "左=" + R2SW(mouseX, 7, 3) +
                " 右=" + R2SW(0.8 - mouseX, 7, 3) +
                " 上=" + R2SW(0.6 - mouseY, 7, 3) +
                " 下=" + R2SW(mouseY, 7, 3));
            }
        });

        // 鼠标移动事件
        hardware.regMoveEvent(function (){
            real mouseX, mouseY, dx, dy, width, height;

            mouseX = GetMouseXEx();
            mouseY = GetMouseYEx();

            if (!isShowRuler) return;

            // 更新上尺子
            textRuler[1].setAbsPoint(ANCHOR_TOP, mouseX, 0.6);
            textRuler[1].setAbsPoint(ANCHOR_BOTTOM, mouseX, mouseY + 0.005);
            textRuler[1].setText(R2SW(0.6 - mouseY, 7, 3));

            // 更新下尺子
            textRuler[2].setAbsPoint(ANCHOR_TOP, mouseX, mouseY - 0.005);
            textRuler[2].setAbsPoint(ANCHOR_BOTTOM, mouseX, 0);
            textRuler[2].setText(R2SW(mouseY, 7, 3));

            // 更新左尺子
            textRuler[3].setAbsPoint(ANCHOR_LEFT, 0, mouseY);
            textRuler[3].setAbsPoint(ANCHOR_RIGHT, mouseX - 0.005, mouseY);
            textRuler[3].setText(R2SW(mouseX, 7, 3));

            // 更新右尺子
            textRuler[4].setAbsPoint(ANCHOR_LEFT, mouseX + 0.005, mouseY);
            textRuler[4].setAbsPoint(ANCHOR_RIGHT, 0.8, mouseY);
            textRuler[4].setText(R2SW(0.8 - mouseX, 7, 3));

            // 计算x,y偏移并更新文本
            dx = mouseX - anchorPosX;
            dy = mouseY - anchorPosY;

            // 计算尺子的宽高(尺子绝对值)
            width = I2R(IAbsBJ(R2I(dx * 1000))) / 1000;
            height = I2R(IAbsBJ(R2I(dy * 1000))) / 1000;

            // 根据鼠标位置设置锚点和尺寸
            if (mouseX >= anchorPosX) {
                if (mouseY >= anchorPosY) {
                    // 鼠标在右上
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_TOP_RIGHT, mouseX, mouseY)
                        .setSize(width, height);
                } else {
                    // 鼠标在右下
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_BOTTOM_RIGHT, mouseX, mouseY)
                        .setSize(width, height);
                }
            } else {
                if (mouseY >= anchorPosY) {
                    // 鼠标在左上
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_TOP_LEFT, mouseX, mouseY)
                        .setSize(width, height);
                } else {
                    // 鼠标在左下
                    imageRuler[5].clearPoint()
                        .setAbsPoint(ANCHOR_BOTTOM_LEFT, mouseX, mouseY)
                        .setSize(width, height);
                }
            }

            textRuler[5].setText("x:" + R2SW(dx, 7, 3) + " y:" + R2SW(dy, 7, 3));
        });

        //在游戏开始0.1秒后再调用
        TriggerRegisterTimerEventSingle(tr,0.1);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("[已注入UI尺子,按下Ctrl+点击设置锚点,按下Esc开启/关闭尺子]");
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;
    }
}

//! endzinc
#endif



#ifndef MathUtilsIncluded
#define MathUtilsIncluded

//! zinc
/*
* 数学工具库
* 作者：AI Assistant
*
* 提供了一些常用的数学函数，包括实数到整数的转换、除法、实数相加、值限制、四舍五入以及射线与地图边界的交点计算。
*/

library MathUtils {

    // 实转整 带概率进1的
    // 将实数转换为整数，若小数部分大于随机数则进1
    public function R2IRandom (real value) -> integer {
        if (GetRandomReal(0,1.0) <= ModuloReal(value,1.0)) {
            return R2I(value) + 1;
        }
        return R2I(value);
    }

    // 进行整数除法，若能整除则结果减1
    public function Divide1 (integer i1,integer i2) -> integer {
        if (ModuloInteger(i1,i2) == 0) {
            return i1/i2 - 1;
        }
        return i1/i2;
    }

    // 实现特殊的数值叠加计算，主要用于游戏中各种加成效果的叠加
    // 该函数可以避免简单线性相加导致的数值溢出，保证叠加后的效果符合递减收益原则
    //
    // 特点：
    // - 正数叠加时使用概率学公式：1-(1-a1)*(1-a2)
    // - 负数叠加时使用衰减公式：1-(1-a1)/(1+a2)
    // - 当第二个参数绝对值>=1.0时，直接返回第一个参数
    //
    // 适用场景：
    // - 技能冷却缩减叠加（CDR）
    // - 暴击率、闪避率等概率性属性叠加
    // - 移速加成等需要控制上限的属性叠加
    //
    // 参数说明：
    // a1: 第一个数值，通常表示当前已有的加成效果
    // a2: 第二个数值，表示要叠加的新加成效果
    // 返回值: 叠加后的最终效果值
    //
    // 使用示例：
    // real currentCDR = 0.4;    // 当前40%冷却缩减
    // real newCDR = 0.5;        // 新装备50%冷却缩减
    // real finalCDR = RealAdd(currentCDR, newCDR);  // 结果约为0.7，即70%冷却缩减
    //
    // 注意事项：
    // 1. 虽然函数支持任意实数输入，但建议输入值在[-1.0, 1.0]范围内
    // 2. 当|a2| >= 1.0时，函数会直接返回a1值
    // 3. 该函数满足结合律，但不满足交换律，建议将已有效果作为第一个参数
    // 4. 已测试过可以在用负数叠加后,使用负数的绝对值进行恢复
    public function RealAdd ( real a1,real a2 ) -> real {
        if (RAbsBJ(a2) >= 1.0) {return a1;}
        if (a2 >= 0) {return 1.0-(1.0-a1)*(1.0-a2);}
        else {return 1.0-(1.0-a1)/(1.0+a2);}
    }

    // 最小最大值限制
    // 限制整数在[min, max]范围内
    public function ILimit ( integer target,integer min,integer max ) -> integer {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }

    // 最小最大值限制
    // 限制实数在[min, max]范围内
    public function RLimit ( real target,real min,real max ) -> real {
        if (target < min) {return min;}
        else if (target > max) {return max;}
        else {return target;}
    }

    // 四舍五入法实数转整数
    // 将实数四舍五入为整数
    public function R2IM (real r)  -> integer {
        if (ModuloReal(r,1.0) >= 0.5) return R2I(r)+1;
        else return R2I(r);
    }

    // 计算射线与地图边界的交点
    // 计算从给定点出发的射线与地图边界的交点
    public struct radiationEnd {
        static real x = 0,y = 0;

        // 一个坐标沿着某个方向的边缘值
        // 计算从点(x1,y1)出发，沿angle角度方向的射线与地图边界的交点
        static method cal (real x1,real y1,real angle) {
            real x2  = 0; //相交点
            real y2  = 0; //相交点
            real a = ModuloReal(angle,360); //求余数
            real tan;
            x = 0;
            y = 0;

            // 处理特殊角度
            if (a == 0) { // 正右方
                x = mapBounds.maxX;
                y = y1;
                return;
            }
            if (a == 90) { // 正上方
                x = x1;
                y = mapBounds.maxY;
                return;
            }
            if (a == 180) { // 正左方
                x = mapBounds.minX;
                y = y1;
                return;
            }
            if (a == 270) { // 正下方
                x = x1;
                y = mapBounds.minY;
                return;
            }

            // 处理一般角度
            if (a < 90) { //第一象限
                tan = TanBJ(a);
                x2 = (mapBounds.maxY - y1) / tan + x1;
                y2 = (mapBounds.maxX - x1) * tan + y1;
                if (x2 <= mapBounds.maxX) { //取这个
                    x = x2;
                    y = mapBounds.maxY;
                } else {
                    x = mapBounds.maxX;
                    y = y2;
                }
            } else if(a < 180) { //第二象限
                tan = TanBJ(a);
                x2 = (mapBounds.maxY - y1) / tan + x1;
                y2 = (mapBounds.minX - x1) * tan + y1;
                if (x2 >= mapBounds.minX) { //取这个
                    x = x2;
                    y = mapBounds.maxY;
                } else {
                    x = mapBounds.minX;
                    y = y2;
                }
            } else if(a < 270) { //第三象限
                tan = TanBJ(a);
                x2 = (mapBounds.minY - y1) / tan + x1;
                y2 = (mapBounds.minX - x1) * tan + y1;
                if (x2 >= mapBounds.minX) { //取这个
                    x = x2;
                    y = mapBounds.minY;
                } else {
                    x = mapBounds.minX;
                    y = y2;
                }
            } else { //第四象限
                tan = TanBJ(a);
                x2 = (mapBounds.minY - y1) / tan + x1;
                y2 = (mapBounds.maxX - x1) * tan + y1;
                if (x2 <= mapBounds.maxX) { //取这个
                    x = x2;
                    y = mapBounds.minY;
                } else {
                    x = mapBounds.maxX;
                    y = y2;
                }
            }
        }
    }

}

//! endzinc
#endif

#ifndef KeyboardIncluded
#define KeyboardIncluded

#include "Crainax/input/constant/KeyConstants.j"

//! zinc
/*
键盘的输入事件监听
*/
library Keyboard requires BzAPI{

    public struct keyboard[] {
        private {
            static trigger trsDown[];  // 按下事件
            static trigger trsUp[];    // 抬起事件
            static boolean isDown[];   // 是否按下
        }
        // 注册一个键盘事件
        static method regKeyDownEvent (integer keyCode, code func) {
            if (trsDown[keyCode] == null) {
                trsDown[keyCode] = CreateTrigger();
                DzTriggerRegisterKeyEventByCode(null,keyCode,KEYBORAD_PRESSED,false,function () {
                    integer triggerKey = DzGetTriggerKey();
                    if (!isDown[triggerKey]) {
                        isDown[triggerKey] = true;
                        TriggerEvaluate(trsDown[triggerKey]);
                    }
                });
            }
            TriggerAddCondition(trsDown[keyCode], Condition(func));
        }
        // 注册一个键盘事件
        static method regKeyUpEvent (integer keyCode, code func) {
            if (trsUp[keyCode] == null) {
                trsUp[keyCode] = CreateTrigger();
                DzTriggerRegisterKeyEventByCode(null,keyCode,KEYBORAD_UP,false,function () {
                    integer triggerKey = DzGetTriggerKey();
                    isDown[triggerKey] = false;
                    TriggerEvaluate(trsUp[triggerKey]);
                });
            }
            TriggerAddCondition(trsUp[keyCode], Condition(func));
        }

    }
}

//! endzinc
#endif

//===========================================================================
//
// - |cff00ff00单元测试地图|r -
//
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Sun Nov 27 05:00:30 2022
//   Map Author: Crainax
//
//===========================================================================
//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************
globals
    // Generated
    rect gg_rct_Wave1 = null
    rect gg_rct_Wave2 = null
    rect gg_rct_Wave3 = null
    rect gg_rct_Wave4 = null
    rect gg_rct_Base = null
    rect gg_rct_BaseBack = null
    rect gg_rct_Home1 = null
    rect gg_rct_Home2 = null
    rect gg_rct_Home3 = null
    rect gg_rct_Home4 = null
    rect gg_rct_Fuben1 = null
    rect gg_rct_Fuben2 = null
    rect gg_rct_Fuben3 = null
    rect gg_rct_Fuben4 = null
    rect gg_rct_Fuben5 = null
    rect gg_rct_Fuben6 = null
    rect gg_rct_Fuben7 = null
    rect gg_rct_Fuben8 = null
    trigger gg_trg_______u = null
    unit gg_unit_hcas_0011 = null
endglobals
function InitGlobals takes nothing returns nothing
endfunction
//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************
//===========================================================================
function CreateBuildingsForPlayer8 takes nothing returns nothing
    local player p = Player(8)
    local unit u
    local integer unitID
    local trigger t
    local real life
    set gg_unit_hcas_0011 = CreateUnit( p, 'hcas', -64.0, -1984.0, 270.000 )
endfunction
//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
    call CreateBuildingsForPlayer8( )
endfunction
//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction
//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings( )
    call CreatePlayerUnits( )
endfunction
//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************
function CreateRegions takes nothing returns nothing
    local weathereffect we
    set gg_rct_Wave1 = Rect( -5088.0, 3168.0, -4448.0, 3968.0 )
    set gg_rct_Wave2 = Rect( -1568.0, 3360.0, -928.0, 4160.0 )
    set gg_rct_Wave3 = Rect( 1312.0, 3584.0, 1952.0, 4384.0 )
    set gg_rct_Wave4 = Rect( 4320.0, 3232.0, 4960.0, 4032.0 )
    set gg_rct_Base = Rect( -320.0, -2304.0, 192.0, -1664.0 )
    set gg_rct_BaseBack = Rect( -320.0, -3328.0, 160.0, -2848.0 )
    set gg_rct_Home1 = Rect( -10496.0, 1440.0, -8128.0, 3776.0 )
    set gg_rct_Home2 = Rect( 7712.0, 1568.0, 10080.0, 3904.0 )
    set gg_rct_Home3 = Rect( -10464.0, -3680.0, -8096.0, -1344.0 )
    set gg_rct_Home4 = Rect( 7712.0, -3552.0, 10080.0, -1216.0 )
    set gg_rct_Fuben1 = Rect( -11872.0, 7968.0, -8224.0, 11584.0 )
    set gg_rct_Fuben2 = Rect( -5472.0, 8000.0, -1824.0, 11616.0 )
    set gg_rct_Fuben3 = Rect( 1184.0, 8000.0, 4832.0, 11616.0 )
    set gg_rct_Fuben4 = Rect( 7712.0, 7968.0, 11360.0, 11584.0 )
    set gg_rct_Fuben5 = Rect( -11872.0, -11328.0, -8224.0, -7712.0 )
    set gg_rct_Fuben6 = Rect( -5472.0, -11328.0, -1824.0, -7712.0 )
    set gg_rct_Fuben7 = Rect( 1184.0, -11328.0, 4832.0, -7712.0 )
    set gg_rct_Fuben8 = Rect( 7712.0, -11328.0, 11360.0, -7712.0 )
endfunction
//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//TESH.scrollpos=0
//TESH.alwaysfold=0
// 当前构建版本
// 当前的平台分包
    // 单元测试
    // lua_print: 单元测试
//函数入口
// 用原始地图测试
// 用空地图测试
//===========================================================================
// UnitPanel_Test.j
//===========================================================================
// 文件描述：单位面板测试模块
// 创建日期：未知
// 修改记录：
//   - 实现了单位属性面板的测试功能
//   - 包含攻击、护甲等属性的显示和交互
//
// 主要功能：
//   - 创建并测试单位属性面板UI
//   - 提供属性图标和数值显示
//   - 实现鼠标悬停和点击事件
//   - 包含单元测试用例
//===========================================================================
// 用原始地图测试
/*
UI哈希表定义
*/
// 0 - 1亿这里用
// 锚点常量
// 事件常量
//鼠标点击事件
//Index名:
//默认原生图片路径
//模板名
//TEXT对齐常量:(uiText.setAlign)
//! zinc
//自动生成的文件
library UTUnitPanel requires UnitPanel,UnitTestUIRuler {
	public function Init2 () {
		hardware.regUpdateEvent(function () {
			if (IsUnitAlly(DzGetSelectedLeaderUnit(), GetLocalPlayer()) && GetOwningPlayer(DzGetSelectedLeaderUnit()) != GetLocalPlayer() && IsUnitType(DzGetSelectedLeaderUnit(), UNIT_TYPE_STRUCTURE)) {
				unitPanel.moveOutBuilding();
			} else if (GetUnitTypeId(DzGetSelectedLeaderUnit()) == 'hsor' || GetUnitTypeId(DzGetSelectedLeaderUnit()) == 'hmpr') {
				unitPanel.moveOutMonster();
			}
		});
	}
	// 初始化测试内容
	function Init () {
		unitPanel.on/**/Attack/**/Enter(function () {BJDebugMsg("Attack" + " " + "Enter");}); <?='\n'?> unitPanel.on/**/Attack/**/Leave(function () {BJDebugMsg("Attack" + " " + "Leave");}); <?='\n'?> unitPanel.on/**/Attack/**/Click(function () {BJDebugMsg("Attack" + " " + "Click");}); <?='\n'?> unitPanel.on/**/Attack/**/RightClick(function () {BJDebugMsg("Attack" + " " + "RightClick");}); <?='\n'?>
		unitPanel.on/**/Armor/**/Enter(function () {BJDebugMsg("Armor" + " " + "Enter");}); <?='\n'?> unitPanel.on/**/Armor/**/Leave(function () {BJDebugMsg("Armor" + " " + "Leave");}); <?='\n'?> unitPanel.on/**/Armor/**/Click(function () {BJDebugMsg("Armor" + " " + "Click");}); <?='\n'?> unitPanel.on/**/Armor/**/RightClick(function () {BJDebugMsg("Armor" + " " + "RightClick");}); <?='\n'?>
		unitPanel.on/**/Hero/**/Enter(function () {BJDebugMsg("Hero" + " " + "Enter");}); <?='\n'?> unitPanel.on/**/Hero/**/Leave(function () {BJDebugMsg("Hero" + " " + "Leave");}); <?='\n'?> unitPanel.on/**/Hero/**/Click(function () {BJDebugMsg("Hero" + " " + "Click");}); <?='\n'?> unitPanel.on/**/Hero/**/RightClick(function () {BJDebugMsg("Hero" + " " + "RightClick");}); <?='\n'?>
		unitPanel.on/**/Building/**/Enter(function () {BJDebugMsg("Building" + " " + "Enter");}); <?='\n'?> unitPanel.on/**/Building/**/Leave(function () {BJDebugMsg("Building" + " " + "Leave");}); <?='\n'?> unitPanel.on/**/Building/**/Click(function () {BJDebugMsg("Building" + " " + "Click");}); <?='\n'?> unitPanel.on/**/Building/**/RightClick(function () {BJDebugMsg("Building" + " " + "RightClick");}); <?='\n'?>
		unitPanel.on/**/Monster/**/Enter(function () {BJDebugMsg("Monster" + " " + "Enter");}); <?='\n'?> unitPanel.on/**/Monster/**/Leave(function () {BJDebugMsg("Monster" + " " + "Leave");}); <?='\n'?> unitPanel.on/**/Monster/**/Click(function () {BJDebugMsg("Monster" + " " + "Click");}); <?='\n'?> unitPanel.on/**/Monster/**/RightClick(function () {BJDebugMsg("Monster" + " " + "RightClick");}); <?='\n'?>
		Init2();
	}
	function TTestUTUnitPanel1 (player p) { //给两个图标加一下grow看看效果
unitPanel.iconAttack.grow(growdata[ICONGROW_14]);
		unitPanel.iconArmor.grow(growdata[ICONGROW_18]);
	}
	function TTestUTUnitPanel2 (player p) { //移除所有原生UI到屏幕外
unitPanel.iconAttack.setCornerText("Lv.1");
		unitPanel.iconArmor.setCornerText("1级");
	}
	function TTestUTUnitPanel3 (player p) {
		unitPanel.iconAttack.startCooldown(3.0,0);
		unitPanel.iconArmor.startCooldown(5.0,0);
	}
	function TTestUTUnitPanel4 (player p) {
		unitPanel.iconArmor.startCooldown(0,0);
	}
	function TTestUTUnitPanel5 (player p) {
		unitPanel.moveOutBuilding();
		unitPanel.moveOutMonster();
		BJDebugMsg("移走");
	}
	function TTestUTUnitPanel6 (player p) {}
	function TTestUTUnitPanel7 (player p) {}
	function TTestUTUnitPanel8 (player p) {}
	function TTestUTUnitPanel9 (player p) {}
	function TTestUTUnitPanel10 (player p) {}
	function TTestActUTUnitPanel1 (string str) {
		player p = GetTriggerPlayer();
		integer index = GetConvertedPlayerId(p);
		integer i, num = 0, len = StringLength(str); //获取范围式数字
string paramS []; //所有参数S
integer paramI []; //所有参数I
real	paramR []; //所有参数R
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
			unit hero,building,witch1,priest1,witch2,priest2;
			real x = 0, y = 0;
			integer i = 0;
			// 为玩家1创建测试英雄
			hero = CreateUnit(Player(0), 'Hamg', 0, 0, 270); // 创建大法师在坐标(0,0)
SetHeroLevel(hero, 10,true);
			// 为玩家1创建女巫和牧师
			witch1 = CreateUnit(Player(0), 'hsor', 200, 200, 270); // 创建女巫
priest1 = CreateUnit(Player(0), 'hmpr', 200, -200, 270); // 创建牧师

			// 在地图远角创建玩家2的女巫和牧师
			witch2 = CreateUnit(Player(11), 'hsor', 5000, 5000, 270); // 创建玩家12的女巫
priest2 = CreateUnit(Player(11), 'hmpr', 5000, -5000, 270); // 创建玩家12的牧师

			// 创建一个建筑单位用于测试12个技能
			building = CreateUnit(Player(0), 'hcas', 400, 0, 270); // 创建人族城堡

			// 为建筑添加12个技能
			UnitAddAbility(building, 'AHbz'); // 暴风雪
UnitAddAbility(building, 'AHwe'); // 水元素
UnitAddAbility(building, 'AHab'); // 闪现
UnitAddAbility(building, 'AHmt'); // 群体传送
UnitAddAbility(building, 'AHfs'); // 烈焰风暴
UnitAddAbility(building, 'AHbn'); // 驱逐魔法
UnitAddAbility(building, 'AHdr'); // 吸取魔法
UnitAddAbility(building, 'AHpx'); // 凤凰
UnitAddAbility(building, 'AHad'); // 奥术光环
UnitAddAbility(building, 'AHav'); // 化身
UnitAddAbility(building, 'AHcs'); // 寒冰护甲
UnitAddAbility(building, 'AHfa'); // 烈焰护甲

			// 添加8个预选的技能
			UnitAddAbility(hero, 'ACbc'); // 火焰呼吸
UnitAddAbility(hero, 'ACbf'); // 霜冻闪电
UnitAddAbility(hero, 'ACpy'); // 变形术
UnitAddAbility(hero, 'AOhx'); // 妖术
UnitAddAbility(hero, 'ACdv'); // 吞噬
UnitAddAbility(hero, 'ACen'); // 诱捕
UnitAddAbility(hero, 'ANr3'); // 混乱之雨
UnitAddAbility(hero, 'AOhw'); // 医疗波
BJDebugMsg("[UnitPanel] 单元测试已加载");
			Init();
			DestroyTrigger(GetTriggeringTrigger());
		}));
		//在游戏开始0.1秒后再调用
		tr = CreateTrigger();
		TriggerRegisterTimerEventSingle(tr,0.1);
		TriggerAddCondition(tr,Condition(function (){
			DestroyTrigger(GetTriggeringTrigger());
		}));
		tr = null;
		UnitTestRegisterChatEvent(function () {
			string str = GetEventPlayerChatString();
			integer i = 1;
			if (SubStringBJ(str,1,1) == "-") {
				TTestActUTUnitPanel1(SubStringBJ(str,2,StringLength(str)));
				return;
			}
			if (str == "s1") TTestUTUnitPanel1(GetTriggerPlayer());
			else if(str == "s2") TTestUTUnitPanel2(GetTriggerPlayer());
			else if(str == "s3") TTestUTUnitPanel3(GetTriggerPlayer());
			else if(str == "s4") TTestUTUnitPanel4(GetTriggerPlayer());
			else if(str == "s5") TTestUTUnitPanel5(GetTriggerPlayer());
			else if(str == "s6") TTestUTUnitPanel6(GetTriggerPlayer());
			else if(str == "s7") TTestUTUnitPanel7(GetTriggerPlayer());
			else if(str == "s8") TTestUTUnitPanel8(GetTriggerPlayer());
			else if(str == "s9") TTestUTUnitPanel9(GetTriggerPlayer());
			else if(str == "s10") TTestUTUnitPanel10(GetTriggerPlayer());
		});
		InitTestUIRuler();
	}
}
//! endzinc
// lua_print: 空白地图
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************
//===========================================================================
// Trigger: 简介
//===========================================================================
function Trig_______uActions takes nothing returns nothing
    // 欢迎使用世界编辑器，开始你的地图创造之旅。
    // 你可以从dz.163.com获取最新编辑器咨询。
    // 当你的地图意外损坏时，你可以在backups目录找到你最近26次保存的地图。
    // 任何疑问请加官方作者群：QQ35063417。
    // 本次更新添加判断玩家是否为平台AI玩家，现在平台已经添加虚拟玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
endfunction
//===========================================================================
function InitTrig_______u takes nothing returns nothing
    set gg_trg_______u = CreateTrigger()
    call DoNothing()
    call TriggerAddAction(gg_trg_______u, function Trig_______uActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_______u( )
endfunction
//***************************************************************************
//*
//*  Players
//*
//***************************************************************************
function InitCustomPlayerSlots takes nothing returns nothing
    // Player 0
    call SetPlayerStartLocation( Player(0), 0 )
    call ForcePlayerStartLocation( Player(0), 0 )
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), false )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )
    // Player 1
    call SetPlayerStartLocation( Player(1), 1 )
    call ForcePlayerStartLocation( Player(1), 1 )
    call SetPlayerColor( Player(1), ConvertPlayerColor(1) )
    call SetPlayerRacePreference( Player(1), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(1), false )
    call SetPlayerController( Player(1), MAP_CONTROL_USER )
    // Player 2
    call SetPlayerStartLocation( Player(2), 2 )
    call ForcePlayerStartLocation( Player(2), 2 )
    call SetPlayerColor( Player(2), ConvertPlayerColor(2) )
    call SetPlayerRacePreference( Player(2), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(2), false )
    call SetPlayerController( Player(2), MAP_CONTROL_USER )
    // Player 3
    call SetPlayerStartLocation( Player(3), 3 )
    call ForcePlayerStartLocation( Player(3), 3 )
    call SetPlayerColor( Player(3), ConvertPlayerColor(3) )
    call SetPlayerRacePreference( Player(3), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(3), false )
    call SetPlayerController( Player(3), MAP_CONTROL_USER )
    // Player 4
    call SetPlayerStartLocation( Player(4), 4 )
    call ForcePlayerStartLocation( Player(4), 4 )
    call SetPlayerColor( Player(4), ConvertPlayerColor(4) )
    call SetPlayerRacePreference( Player(4), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(4), false )
    call SetPlayerController( Player(4), MAP_CONTROL_COMPUTER )
    // Player 5
    call SetPlayerStartLocation( Player(5), 5 )
    call ForcePlayerStartLocation( Player(5), 5 )
    call SetPlayerColor( Player(5), ConvertPlayerColor(5) )
    call SetPlayerRacePreference( Player(5), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(5), false )
    call SetPlayerController( Player(5), MAP_CONTROL_COMPUTER )
    // Player 6
    call SetPlayerStartLocation( Player(6), 6 )
    call ForcePlayerStartLocation( Player(6), 6 )
    call SetPlayerColor( Player(6), ConvertPlayerColor(6) )
    call SetPlayerRacePreference( Player(6), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(6), false )
    call SetPlayerController( Player(6), MAP_CONTROL_COMPUTER )
    // Player 7
    call SetPlayerStartLocation( Player(7), 7 )
    call ForcePlayerStartLocation( Player(7), 7 )
    call SetPlayerColor( Player(7), ConvertPlayerColor(7) )
    call SetPlayerRacePreference( Player(7), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(7), false )
    call SetPlayerController( Player(7), MAP_CONTROL_COMPUTER )
    // Player 8
    call SetPlayerStartLocation( Player(8), 8 )
    call ForcePlayerStartLocation( Player(8), 8 )
    call SetPlayerColor( Player(8), ConvertPlayerColor(8) )
    call SetPlayerRacePreference( Player(8), RACE_PREF_NIGHTELF )
    call SetPlayerRaceSelectable( Player(8), false )
    call SetPlayerController( Player(8), MAP_CONTROL_COMPUTER )
    // Player 9
    call SetPlayerStartLocation( Player(9), 9 )
    call ForcePlayerStartLocation( Player(9), 9 )
    call SetPlayerColor( Player(9), ConvertPlayerColor(9) )
    call SetPlayerRacePreference( Player(9), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(9), false )
    call SetPlayerController( Player(9), MAP_CONTROL_COMPUTER )
    // Player 10
    call SetPlayerStartLocation( Player(10), 10 )
    call ForcePlayerStartLocation( Player(10), 10 )
    call SetPlayerColor( Player(10), ConvertPlayerColor(10) )
    call SetPlayerRacePreference( Player(10), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(10), false )
    call SetPlayerController( Player(10), MAP_CONTROL_COMPUTER )
    // Player 11
    call SetPlayerStartLocation( Player(11), 11 )
    call ForcePlayerStartLocation( Player(11), 11 )
    call SetPlayerColor( Player(11), ConvertPlayerColor(11) )
    call SetPlayerRacePreference( Player(11), RACE_PREF_UNDEAD )
    call SetPlayerRaceSelectable( Player(11), false )
    call SetPlayerController( Player(11), MAP_CONTROL_COMPUTER )
endfunction
function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_013
    call SetPlayerTeam( Player(0), 0 )
    call SetPlayerTeam( Player(1), 0 )
    call SetPlayerTeam( Player(2), 0 )
    call SetPlayerTeam( Player(3), 0 )
    call SetPlayerTeam( Player(4), 0 )
    call SetPlayerTeam( Player(5), 0 )
    call SetPlayerTeam( Player(6), 0 )
    call SetPlayerTeam( Player(7), 0 )
    call SetPlayerTeam( Player(8), 0 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateAllyBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateAllyBJ( Player(8), Player(7), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(7), true )
    call SetPlayerAllianceStateVisionBJ( Player(6), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(7), Player(8), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(6), true )
    call SetPlayerAllianceStateVisionBJ( Player(8), Player(7), true )
    // Force: TRIGSTR_014
    call SetPlayerTeam( Player(9), 1 )
    call SetPlayerTeam( Player(10), 1 )
    call SetPlayerTeam( Player(11), 1 )
    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateAllyBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateAllyBJ( Player(11), Player(10), true )
    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(10), true )
    call SetPlayerAllianceStateVisionBJ( Player(9), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(10), Player(11), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(9), true )
    call SetPlayerAllianceStateVisionBJ( Player(11), Player(10), true )
endfunction
function InitAllyPriorities takes nothing returns nothing
    call SetStartLocPrioCount( 0, 3 )
    call SetStartLocPrio( 0, 0, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 1, 3 )
    call SetStartLocPrio( 1, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 2, 3 )
    call SetStartLocPrio( 2, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrioCount( 3, 3 )
    call SetStartLocPrio( 3, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 2, 2, MAP_LOC_PRIO_HIGH )
endfunction
//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************
//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds( -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -13568.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 13312.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 13568.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -13824.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "NorthrendDay" )
    call SetAmbientNightSound( "NorthrendNight" )
    call SetMapMusic( "Music", true, 0 )
    call CreateRegions( )
    call CreateAllUnits( )
    call InitBlizzard( )
    call InitGlobals( )
    call InitCustomTriggers( )
endfunction
//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************
function config takes nothing returns nothing
    call SetMapName( "TRIGSTR_1232" )
    call SetMapDescription( "TRIGSTR_1234" )
    call SetPlayers( 12 )
    call SetTeams( 12 )
    call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )
    call DefineStartLocation( 0, 0.0, 0.0 )
    call DefineStartLocation( 1, 0.0, 0.0 )
    call DefineStartLocation( 2, 0.0, 0.0 )
    call DefineStartLocation( 3, 0.0, 0.0 )
    call DefineStartLocation( 4, 0.0, 0.0 )
    call DefineStartLocation( 5, 0.0, 0.0 )
    call DefineStartLocation( 6, 0.0, 0.0 )
    call DefineStartLocation( 7, 0.0, 0.0 )
    call DefineStartLocation( 8, 0.0, 0.0 )
    call DefineStartLocation( 9, 0.0, 0.0 )
    call DefineStartLocation( 10, 0.0, 0.0 )
    call DefineStartLocation( 11, 0.0, 0.0 )
    // Player setup
    call InitCustomPlayerSlots( )
    call InitCustomTeams( )
    call InitAllyPriorities( )
endfunction
/**/
