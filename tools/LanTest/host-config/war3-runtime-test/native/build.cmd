@echo off
setlocal
set "src=%~dp0"
set "work=%TEMP%\war3-visual-%RANDOM%-%RANDOM%"
mkdir "%work%" || exit /b 1
pushd "%work%" || exit /b 1
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars32.bat" || exit /b 1
copy /y "%src%capture.cpp" . >nul || exit /b 1
copy /y "%src%generate.py" . >nul || exit /b 1
dumpbin /nologo /exports "%SystemRoot%\SysWOW64\opengl32.dll" >exports.txt || exit /b 1
python generate.py || exit /b 1
ml /nologo /c /coff forward.asm || exit /b 1
cl /nologo /EHsc /O2 /MT /LD capture.cpp forward.obj /link /DEF:render.def /OUT:opengl32.dll || exit /b 1
if not exist "%src%..\assets" mkdir "%src%..\assets" || exit /b 1
copy /y opengl32.dll "%src%..\assets\opengl32.dll" >nul || exit /b 1
del capture.cpp generate.py exports.txt exports.inc forward.asm render.def forward.obj capture.obj capture.lib capture.exp opengl32.dll
popd
rd "%work%"
