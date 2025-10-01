#ifndef KKPREINCLUDE
#define KKPREINCLUDE


library LBKKPRE

    native DzFrameSetIgnoreTrackEvents takes integer frame, boolean ignore returns nothing 
    native DzFrameAddModel takes integer parent_frame returns integer 
    native DzFrameSetModel2 takes integer model_frame, string model_file, integer team_color_id returns nothing 
    native DzFrameAddModelEffect takes integer model_frame, string attach_point, string model_file returns integer 
    native DzFrameRemoveModelEffect takes integer model_frame, integer effect_frame returns nothing 
    native DzFrameSetModelAnimationByIndex takes integer model_frame, integer anim_index returns nothing 
    native DzFrameSetModelAnimation takes integer model_frame, string animation returns nothing 
    native DzFrameSetModelCameraSource takes integer model_frame, real x, real y, real z returns nothing 
    native DzFrameSetModelCameraTarget takes integer model_frame, real x, real y, real z returns nothing 
    native DzFrameSetModelSize takes integer model_frame, real size returns nothing 
    native DzFrameGetModelSize takes integer model_frame returns real 
    native DzFrameSetModelPosition takes integer model_frame, real x, real y, real z returns nothing
    native DzFrameSetModelX takes integer model_frame, real x returns nothing 
    native DzFrameGetModelX takes integer model_frame returns real 
    native DzFrameSetModelY takes integer model_frame, real y returns nothing 
    native DzFrameGetModelY takes integer model_frame returns real 
    native DzFrameSetModelZ takes integer model_frame, real z returns nothing 
    native DzFrameGetModelZ takes integer model_frame returns real 
    native DzFrameSetModelSpeed takes integer model_frame, real speed returns nothing 
    native DzFrameGetModelSpeed takes integer model_frame returns real 
    native DzFrameSetModelScale takes integer model_frame, real x, real y, real z returns nothing 
    native DzFrameSetModelMatReset takes integer model_frame returns nothing 
    native DzFrameSetModelRotateX takes integer model_frame, real x returns nothing 
    native DzFrameSetModelRotateY takes integer model_frame, real y returns nothing 
    native DzFrameSetModelRotateZ takes integer model_frame, real z returns nothing 
    native DzFrameSetModelColor takes integer model_frame, integer color returns nothing 
    native DzFrameGetModelColor takes integer model_frame returns integer
    native DzFrameSetModelTexture takes integer model_frame, string texture_file, integer replace_texutre_id returns nothing 
    native DzFrameSetModelParticle2Size takes integer model_frame, real scale returns nothing 
    native DzGetGlueUI takes nothing returns integer 
    native DzFrameGetMouse takes nothing returns integer 
    native DzFrameGetContext takes integer frame returns integer 
    native DzFrameGetName takes integer frame returns string 
    native DzFrameSetNameContext takes integer frame, string name, integer context returns nothing 
    native DzFrameSetTextFontSpacing takes integer text_frame, real spacing returns nothing 
    native KKCommandGetCooldownModel takes integer cmd_btn returns integer 
    native KKCommandSetCooldownModelSize takes integer cmd_btn, real size returns nothing 
    native KKCommandSetCooldownModelSize2 takes integer cmd_btn, real width, real height returns nothing 
    native DzGetPlayerLastSelectedItem takes player p returns item 
    native DzGetCacheModelCount takes nothing returns integer 
    native DzSetMaxFps takes integer max_fps returns nothing 
    
endlibrary

#endif

