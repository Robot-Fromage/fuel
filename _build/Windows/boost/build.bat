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
ECHO boost

:: Actually Init Env
CALL "%EXTLIBS_BUILD_WIN_TOOLS_MSVC_DIR%\_init_msvc.bat" || goto :error

:::::::::::::::
:: Check install _install folder hierarchy
CALL _init_install.bat

chgcolor %CRESET%

:::::::::::::::
:: Install Commands

XCOPY /e /h /y "%EXTLIBS_DIR%\boost" "%EXTLIBS_DIR%\_install\include"

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

