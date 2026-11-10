#include <windows.h>
#include <stdio.h>
#include <string.h>

// Per-process LAN identity; active only with explicit child environment.
static char player[32], evidence[MAX_PATH];
static bool initialized = false;
static void note(const char* action) {
    FILE* f = nullptr;
    if (!fopen_s(&f, evidence, "a") && f) {
        fprintf(f, "%lu %s %s\n", GetTickCount(), action, player);
        fclose(f);
    }
}
static bool identityKey(HKEY key) {
    typedef LONG (WINAPI *QueryKey)(HANDLE,int,PVOID,ULONG,PULONG);
    static QueryKey get=(QueryKey)GetProcAddress(GetModuleHandleW(L"ntdll.dll"),"NtQueryKey");
    BYTE buffer[2048]; ULONG needed=0;
    if (!get || get(key,3,buffer,sizeof(buffer),&needed)<0) return false;
    DWORD bytes=*(DWORD*)buffer;
    if (bytes>sizeof(buffer)-sizeof(DWORD)-sizeof(wchar_t)) return false;
    wchar_t* name=(wchar_t*)(buffer+sizeof(DWORD)); name[bytes/2]=0;
    const wchar_t* suffix=L"\\Software\\Blizzard Entertainment\\Warcraft III\\String";
    size_t n=wcslen(name), s=wcslen(suffix);
    return n>=s && !_wcsicmp(name+n-s,suffix);
}
static LSTATUS WINAPI query(HKEY key, LPCSTR name, LPDWORD reserved,
    LPDWORD type, LPBYTE data, LPDWORD size) {
    if (!name || _stricmp(name, "userlocal") || !identityKey(key))
        return RegQueryValueExA(key, name, reserved, type, data, size);
    if (!size) return ERROR_INVALID_PARAMETER;
    DWORD required = (DWORD)strlen(player) + 1;
    if (type) *type = REG_BINARY;
    DWORD capacity = *size;
    *size = required;
    if (!data) return ERROR_SUCCESS;
    if (capacity < required) return ERROR_MORE_DATA;
    memcpy(data, player, required);
    note("NAME_READ");
    return ERROR_SUCCESS;
}
static LSTATUS WINAPI write(HKEY key, LPCSTR name, DWORD reserved,
    DWORD type, const BYTE* data, DWORD size) {
    if (name && !_stricmp(name, "userlocal") && identityKey(key)) {
        note("NAME_WRITE_SUPPRESSED");
        return ERROR_SUCCESS;
    }
    return RegSetValueExA(key, name, reserved, type, data, size);
}
static int patch(HMODULE module) {
    if (!module) return 0;
    BYTE* base = (BYTE*)module;
    auto dos = (IMAGE_DOS_HEADER*)base;
    auto nt = (IMAGE_NT_HEADERS*)(base + dos->e_lfanew);
    DWORD rva = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
    if (!rva) return 0;
    int count = 0;
    for (auto d = (IMAGE_IMPORT_DESCRIPTOR*)(base+rva); d->Name; ++d) {
        if (!d->OriginalFirstThunk) continue;
        auto names = (IMAGE_THUNK_DATA*)(base+d->OriginalFirstThunk);
        auto slots = (IMAGE_THUNK_DATA*)(base+d->FirstThunk);
        for (; names->u1.AddressOfData; ++names, ++slots) {
            if (IMAGE_SNAP_BY_ORDINAL(names->u1.Ordinal)) continue;
            const char* name = (char*)((IMAGE_IMPORT_BY_NAME*)(base+names->u1.AddressOfData))->Name;
            ULONG_PTR replacement = !strcmp(name,"RegQueryValueExA") ? (ULONG_PTR)query :
                !strcmp(name,"RegSetValueExA") ? (ULONG_PTR)write : 0;
            if (!replacement) continue;
            DWORD old;
            if (!VirtualProtect(&slots->u1.Function, sizeof(ULONG_PTR), PAGE_READWRITE, &old)) continue;
            InterlockedExchange((LONG*)&slots->u1.Function, (LONG)replacement);
            DWORD unused;
            VirtualProtect(&slots->u1.Function, sizeof(ULONG_PTR), old, &unused);
            ++count;
        }
    }
    return count;
}
extern "C" __declspec(dllexport) void Initialize() {
    if (initialized) return;
    initialized = true;
    DWORD n=GetEnvironmentVariableA("WAR3_LAN_PLAYER",player,sizeof(player));
    DWORD e=GetEnvironmentVariableA("WAR3_LAN_EVIDENCE",evidence,sizeof(evidence));
    if (!n || n>=sizeof(player) || !e || e>=sizeof(evidence)) return;
    if (strlen(player)!=5 || strncmp(player,"LanP",4) || player[4]<'1' || player[4]>'6') return;
    int count = patch(GetModuleHandleW(L"Game.dll"));
    count += patch(GetModuleHandleW(L"Storm.dll"));
    count += patch(GetModuleHandleW(nullptr));
    note(count >= 2 ? "HOOK_READY" : "HOOK_FAILED");
}
extern "C" __declspec(dllexport) const char* PluginName() { return "lan_player_name"; }
BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID) {
    if (reason==DLL_PROCESS_ATTACH) {
        DisableThreadLibraryCalls(instance);
        // KKWE may release plugins after inspection. Hooks must remain resident.
        HMODULE pinned;
        if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
            (LPCSTR)&Initialize, &pinned)) Initialize();
    }
    return TRUE;
}
