#include <windows.h>
#include <GL/gl.h>
#include <stdio.h>
#include <vector>
#include <string>
static HMODULE gl;
static INIT_ONCE init = INIT_ONCE_STATIC_INIT;
#include "exports.inc"

static BOOL CALLBACK loadGL(PINIT_ONCE, PVOID, PVOID*) {
    wchar_t system[MAX_PATH];
    if (!GetSystemDirectoryW(system, MAX_PATH)) return FALSE;
    gl = LoadLibraryW((std::wstring(system) + L"\\opengl32.dll").c_str());
    if (!gl) return FALSE;
    for (unsigned i = 0; i < count; ++i) {
        targets[i] = GetProcAddress(gl, names[i]);
        if (!targets[i]) return FALSE;
    }
    return TRUE;
}
extern "C" void __cdecl prepareGL() {
    if (!InitOnceExecuteOnce(&init, loadGL, NULL, NULL)) RaiseFailFastException(NULL,NULL,0);
}
template<class T> static T api(const char* name) {
    return reinterpret_cast<T>(GetProcAddress(gl,name));
}
static bool exportFrame(const std::wstring& dir) {
    GLint viewport[4], prevBuffer;
    auto get = api<decltype(&glGetIntegerv)>("glGetIntegerv");
    get(GL_VIEWPORT, viewport);
    int w = viewport[2], h = viewport[3];
    if (w<1 || h<1 || w>10000 || h>10000) return false;
    std::vector<unsigned char> rgb(size_t(w)*h*3);
    get(GL_READ_BUFFER,&prevBuffer);
    auto buffer=api<decltype(&glReadBuffer)>("glReadBuffer");
    auto pixelStore=api<decltype(&glPixelStorei)>("glPixelStorei");
    api<decltype(&glPushClientAttrib)>("glPushClientAttrib")(GL_CLIENT_PIXEL_STORE_BIT);
    pixelStore(GL_PACK_ALIGNMENT,1);
    pixelStore(GL_PACK_ROW_LENGTH,0);
    pixelStore(GL_PACK_SKIP_ROWS,0);
    pixelStore(GL_PACK_SKIP_PIXELS,0);
    buffer(GL_BACK);
    api<decltype(&glReadPixels)>("glReadPixels")(viewport[0],viewport[1],w,h,GL_RGB,GL_UNSIGNED_BYTE,rgb.data());
    buffer(prevBuffer);
    api<decltype(&glPopClientAttrib)>("glPopClientAttrib")();
    const auto tmp=dir+L"\\render.tmp";
    FILE* file=nullptr;
    if (_wfopen_s(&file,tmp.c_str(),L"wb") || !file) return false;
    fprintf(file,"P6\n%d %d\n255\n",w,h);
    for(int y=h-1;y>=0;--y)
        if(fwrite(rgb.data()+size_t(y)*w*3,3,w,file)!=size_t(w)) {fclose(file);return false;}
    if(fclose(file)!=0) return false;
    return MoveFileExW(tmp.c_str(),(dir+L"\\render.ppm").c_str(),MOVEFILE_REPLACE_EXISTING)!=0;
}
extern "C" BOOL WINAPI captureSwap(HDC dc, UINT planes) {
    prepareGL();
    static bool done=false;
    static ULONGLONG check=0;
    if (!done && (planes & WGL_SWAP_MAIN_PLANE) && GetTickCount64() >= check) {
        check=GetTickCount64()+100;
        wchar_t dir[1024];
        DWORD n=GetEnvironmentVariableW(L"WAR3_FRAME_DIRECTORY",dir,1024);
        if(n && n<1024 && GetFileAttributesW((std::wstring(dir)+L"\\capture.request").c_str())!=INVALID_FILE_ATTRIBUTES)
            done=exportFrame(dir);
    }
    return api<BOOL(WINAPI*)(HDC,UINT)>("wglSwapLayerBuffers")(dc,planes);
}
