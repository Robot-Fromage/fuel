:::::::::::::::
:: BUILD.BAT
:::::::::::::::
@ECHO OFF
:::::::::::::::
:: Init Shell
CALL "%~dp0..\_tools\_initextshell.bat"
:::::::::::::::
:: HEADER
chgcolor %CHEADER%
ECHO //////////
ECHO %0: START
:::::::::::::::
:: Init Fuel Dev Env Variables
CALL _initextenv.bat || goto :error
:::::::::::::::

:::::::::::::::
:: Test
chgcolor %CTEXT%
ECHO Rivet

:: Actually Init Env
CALL "%EXTLIBS_BUILD_WIN_TOOLS_MSVC_DIR%\_init_msvc.bat" || goto :error

:::::::::::::::
:: Check install _install folder hierarchy
CALL _init_install.bat

chgcolor %CRESET%

:::::::::::::::
:: Actual build commands
SET "OVERRIDE_WIN_SDK=$(WindowsTargetPlatformVersion)"
IF "%WINDOWS_VERSION%" == "7" SET "OVERRIDE_WIN_SDK=10.0.16299.0"
IF "%WINDOWS_VERSION%" == "10" SET "OVERRIDE_WIN_SDK=10.0.17134.0"

MSBUILD "%EXTLIBS_DIR%\Rivet\Windows\build\build.sln" /p:Configuration=Debug;WindowsTargetPlatformVersion="%OVERRIDE_WIN_SDK%" || goto :error
MSBUILD "%EXTLIBS_DIR%\Rivet\Windows\build\build.sln" /p:Configuration=Release;WindowsTargetPlatformVersion="%OVERRIDE_WIN_SDK%" || goto :error

:::::::::::::::
:: Install Commands
COPY "%EXTLIBS_DIR%\Rivet\Windows\build\x64\Release\rivet.lib" "%EXTLIBS_DIR%\_install\release_x64\lib\rivet.lib"
COPY "%EXTLIBS_DIR%\Rivet\Windows\build\x64\Debug\rivet-d.lib" "%EXTLIBS_DIR%\_install\debug_x64\lib\rivet-d.lib"

XCOPY /e /h /y "%EXTLIBS_DIR%\Rivet\include" "%EXTLIBS_DIR%\_install\include"
XCOPY /e /h /y "%EXTLIBS_DIR%\Rivet\resources" "%EXTLIBS_DIR%\_install\resources"

:::::::::::::::
:: Reaching End of the Script
GOTO :success

:::::::::::::::
:error
chgcolor %CERROR%
ECHO %0: ERROR
ECHO //////////
chgcolor %CRESET%
EXIT /B 1

:::::::::::::::
:success
chgcolor %CSUCCESS%
ECHO %0: SUCCESS
ECHO //////////
chgcolor %CRESET%
EXIT /B 0

