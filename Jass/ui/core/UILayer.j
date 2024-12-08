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
