#ifndef UITocInitIncluded
#define UITocInitIncluded

//! zinc
/*
Toc初始化,才能使用UI功能
*/
library UITocInit requires BzAPI {

  function onInit ()  {
		DzLoadToc("ui\\PhantomOrbit.toc");
  }
}

//! endzinc
#endif
