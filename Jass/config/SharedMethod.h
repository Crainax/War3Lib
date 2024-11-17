
// 结构体共用方法定义
#define STRUCT_SHARED_METHODS(structName) \
    method isExist () -> boolean {return (this != null && si__##structName##_V[this] == -1);}
