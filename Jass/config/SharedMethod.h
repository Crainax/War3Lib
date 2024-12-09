#ifndef SharedMethodIncluded
#define SharedMethodIncluded

#define CRNL <?='\n'?>

// 结构体共用方法定义
#define STRUCT_SHARED_METHODS(structName) \
    method isExist () -> boolean {return (this != null && si__##structName##_V[this] == -1);}

//共享打印方法
#define STRUCT_SHARED_PRINT(size,list)	static method toString () -> string { CRNL \
        string s = I2S(size) + "个:"; CRNL \
        integer i; CRNL \
        for (1 <= i <= size) { CRNL \
            s += "[" + I2S(i) + "]|r" + I2S(list[i]) + "->"; CRNL \
        } CRNL \
        s += "/"; CRNL \
        return s; CRNL \
    }

// UI组件内部共享方法及成员
#define STRUCT_SHARED_INNER_UI(structName) \
    integer ui; CRNL \
    integer id; CRNL \
    STRUCT_SHARED_METHODS(structName) CRNL \
    optional module uiLifeCycle; CRNL \
    module uiBaseModule;


// UI组件依赖库
#define STRUCT_SHARED_REQUIRE_UI UIId, UITocInit, UIBaseModule, optional UILifeCycle

// UI组件创建时共享调用
#define STRUCT_SHARED_UI_ONCREATE(structName) \
    static if (LIBRARY_UILifeCycle) {uiLifeCycle.onCreateCB(this,thistype.typeid,ui);} CRNL \
    static if (LIBRARY_UIHashTable) {uiHashTable(ui).ui.bind(thistype.typeid,this); }

// UI组件销毁时共享调用
#define STRUCT_SHARED_UI_ONDESTROY(structName) \
    static if (LIBRARY_UILifeCycle) {uiLifeCycle.onDestroyCB(this,thistype.typeid,ui);} CRNL \
    static if (LIBRARY_UIHashTable) { FlushChildHashtable(HASH_UI, ui); }

#endif

