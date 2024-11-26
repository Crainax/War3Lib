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
