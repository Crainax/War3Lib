#ifndef SharedMethodIncluded
#define SharedMethodIncluded


// 结构体共用方法定义
#define STRUCT_SHARED_METHODS(structName) \
    method isExist () -> boolean {return (this != null && si__##structName##_V[this] == -1);}

//共享打印方法
#define STRUCT_SHARED_PRINT(size,list)	static method toString () -> string { \
        string s = I2S(size) + "个:"; \
        integer i; \
        for (1 <= i <= size) { \
            s += "[" + I2S(i) + "]|r" + I2S(list[i]) + "->"; \
        } \
        s += "/"; \
        BJDebugMsg(s); \
    }

#endif

