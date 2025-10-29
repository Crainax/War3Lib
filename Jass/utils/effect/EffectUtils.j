#ifndef EffectUtilsIncluded
#define EffectUtilsIncluded

//! zinc
/*
特效工具库
*/
library EffectUtils {

    public function ShowEffectScale (string path, real x, real y,real scale){
        effect e = AddSpecialEffect(path, x, y);
        DzSetEffectScale(e, scale);
        DestroyEffect(e);
        e = null;
    }

}

//! endzinc
#endif
