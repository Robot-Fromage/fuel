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
ECHO Building static-cpython

:::::::::::::::
:: Check install _install folder hierarchy
CALL _init_install.bat

:::::::::::::::
:: Check clean & update repo
CD "%EXTLIBS_DIR%\static-cpython\"
chgcolor %CGIT%
@ECHO ON
git clean -f -d -x
git checkout cmss_3.7
REM git submodule update --init --recursive
@ECHO OFF

:::::::::::::::
chgcolor %CRESET%

:::::::::::::::
:: Actual build commands
CALL "%EXTLIBS_DIR%\static-cpython\PCBuild\build.bat" -r -e -v -k -c Release    -p x64 -t Rebuild
CALL "%EXTLIBS_DIR%\static-cpython\PCBuild\build.bat" -r -e -v -k -c Debug      -p x64 -t Rebuild

:::::::::::::::
:: Install Commands
MKDIR "%EXTLIBS_DIR%\_install\include\static-cpython"

XCOPY /e /h /y "%EXTLIBS_DIR%\static-cpython\Include" "%EXTLIBS_DIR%\_install\include\static-cpython"
COPY "%EXTLIBS_DIR%\static-cpython\PC\pyconfig.h" "%EXTLIBS_DIR%\_install\include\static-cpython\pyconfig.h"

COPY "%EXTLIBS_DIR%\static-cpython\PCBuild\amd64\python37.lib" "%EXTLIBS_DIR%\_install\release_x64\lib\python37s.lib"
COPY "%EXTLIBS_DIR%\static-cpython\PCBuild\amd64\python37_d.lib" "%EXTLIBS_DIR%\_install\debug_x64\lib\python37s_d.lib"

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

