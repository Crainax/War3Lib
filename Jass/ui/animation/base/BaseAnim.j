#ifndef BaseAnimIncluded
#define BaseAnimIncluded

//! zinc
/*
基础的UI动画效果
*/
library BaseAnim {

	/*
	常用的动画效果
	整合到这里
	这里的动画不负责创建与删除,自行解决
	算了还是不用UI为键了，哈希表式的还没做
	*/
	public struct baseanim {

        // 生命周期结束时调用
        public type onLifeEnd extends function(thistype);

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
        // @param off 偏移
        // @param dist 距离
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
			// DzFrameSetAlpha(ui,start) //这个不能设置的原因是有可能有2个一起设置，存在延迟;
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
        // @param lCB 生命周期结束时调用
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
			delDelay();
			delMove();
			delZoom();
			delAlpha();
			delSequ();
			delBlink();
			delLife();
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
								//DzFrameSetScale(ui,.zStart + (zTar -.zStart) * (I2R(zNow)/ zTime));
								DzFrameSetSize(ui,zStartX + (zTarX -zStartX) * (I2R(zNow)/ zTime),zStartY + (zTarY -zStartY) * (I2R(zNow)/ zTime));
							}
						} //还在延迟中不进行操作
					}
				}
				//blp
				//blp

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

				//blpend
				//blpend

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
						if (lTime >= lPeriod) {destroy();}
					}
				}

				if (DNum <= 0 && MNum <= 0 && ANum <= 0 && ZNum <= 0 && SNum <= 0 && BNum <= 0 && LNum <= 0 ) {
					UIA.unreg(); //这里就删计时器吧
                    Trace("baseanim停止了");
				}
			});
		}
	}

}

//! endzinc
#endif

