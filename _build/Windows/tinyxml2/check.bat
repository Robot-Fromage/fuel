:::::::::::::::
:: CHECK.BAT
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
ECHO Checking tinyxml2

call:checkExist "%EXTLIBS_DIR%\_install\include\tinyxml2.h" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\debug_x64\lib\tinyxml2d.lib" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\release_x64\lib\tinyxml2.lib" || goto :error

:::::::::::::::
:: Reaching End of the Script
GOTO :success

:::::::::::::::
:: Check Processing
:checkExist
chgcolor %CRESET%
ECHO Checking path "%~1"
IF NOT EXIST "%~1" (
    SET ERRORLEVEL=1 
    goto :error
)
goto:EOF
:: Return

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

