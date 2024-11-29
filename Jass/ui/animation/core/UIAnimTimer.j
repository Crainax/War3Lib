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
			trig = null;
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
