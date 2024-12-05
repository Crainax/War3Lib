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
			DzFrameSetPoint(uilayer.lv[1],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[2] = DzCreateFrameByTagName("BACKDROP","layer2",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[2],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[3] = DzCreateFrameByTagName("BACKDROP","layer3",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[3],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[4] = DzCreateFrameByTagName("BACKDROP","layer4",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[4],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[5] = DzCreateFrameByTagName("BACKDROP","layer5",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[5],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[6] = DzCreateFrameByTagName("BACKDROP","layer6",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[6],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
			uilayer.lv[7] = DzCreateFrameByTagName("BACKDROP","layer7",DzGetGameUI(),TEMPLATE_IMAGE,0);
			DzFrameSetPoint(uilayer.lv[7],ANCHOR_CENTER,DzGetGameUI(),ANCHOR_CENTER,0,0);
		}

    }
}

//! endzinc
#endif
