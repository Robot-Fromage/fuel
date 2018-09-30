:::::::::::::::
:: CHECK_INSTALL.BAT
:::::::::::::::
@ECHO OFF
:::::::::::::::
:: Init Shell
CALL "%~dp0_tools\_initextshell.bat"
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
:: Checking installation directory status
chgcolor %CTEXT%
ECHO Checking installation directory status...

SET ERRORLEVEL=0

call:checkExist "%EXTLIBS_DIR%\_install\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\release_x64\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\release_x64\bin\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\release_x64\lib\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\debug_x64\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\debug_x64\bin\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\debug_x64\lib\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\resources\" || goto :error


:::::::::::::::
:: ARGS PARSING AVAILABLE BUILDS
SET INPUT_WHITELIST=%1
SET INPUT_WHITELIST=%INPUT_WHITELIST:"=%
SET "AVAILABLE_BUILDS="
setlocal EnableDelayedExpansion
SET "LOCAL_AVBUILDS="
FOR /F "tokens=* USEBACKQ" %%F IN (`DIR %~dp0 /a:d /B`) DO ( IF "%%F" neq "_tools" (
	IF "!LOCAL_AVBUILDS!" neq "" SET "LOCAL_AVBUILDS=!LOCAL_AVBUILDS!;"
	SET "LOCAL_AVBUILDS=!LOCAL_AVBUILDS!%%F"
) )
(
	endlocal
	SET AVAILABLE_BUILDS=%LOCAL_AVBUILDS%
)

:: ECHO TO_BUILD
chgcolor %CRESET%
ECHO TO_BUILD:%INPUT_WHITELIST%
ECHO AVAILABLE:%AVAILABLE_BUILDS%

:: CHECK INSTALL
FOR %%I in (%INPUT_WHITELIST%) DO (
	FOR %%J in (%AVAILABLE_BUILDS%) DO (
		IF %%I==%%J (
            ECHO CALL "%EXTLIBS_BUILD_WIN_DIR%\%%I\check.bat" || goto :error
            CALL "%EXTLIBS_BUILD_WIN_DIR%\%%I\check.bat" || goto :error
        )
	)
)

IF %ERRORLEVEL%==1 (
    goto :error
)
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

