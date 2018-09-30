:::::::::::::::
:: BUILDALL.BAT
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
:: Init fuel Dev Env Variables
CALL _initextenv.bat || goto :error
:::::::::::::::

:::::::::::::::
:: Backup
PUSHD "%CD%"

:::::::::::::::
:: SHUT ASK
SET SILENT_ASK=1

:: README
chgcolor %CTEXT% & TYPE "%~dp0README.txt" & CALL _ask_confirm.bat || goto :error

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

:: CHECK
CALL "%EXTLIBS_BUILD_WIN_TOOLS_GIT_DIR%\_checkgitstatus.bat" || goto :error

:: Make Qt symlink for this install setup ( symlink is ignored in gitignore )
mklink /D "%EXTLIBS_DIR%/Qt" "%QTDIR%"

:: INIT GIT
PUSHD "%CD%" & CD %EXTLIBS_DIR%
chgcolor %CGIT%
FOR %%I in (%INPUT_WHITELIST%) DO (
	FOR %%J in (%AVAILABLE_BUILDS%) DO (
		IF %%I==%%J (
            ECHO git submodule update --init --recursive %%I
            git submodule update --init --recursive %%I
        )
	)
)
POPD

:: INIT INSTALL
CALL _init_install.bat

:: INIT ENV
CALL "%EXTLIBS_BUILD_WIN_TOOLS_MSVC_DIR%\_init_msvc.bat" || goto :error

:: Build
FOR %%I in (%INPUT_WHITELIST%) DO (
	FOR %%J in (%AVAILABLE_BUILDS%) DO (
		IF %%I==%%J (
            ECHO CALL "%EXTLIBS_BUILD_WIN_DIR%\%%I\build.bat" || goto :error
            CALL "%EXTLIBS_BUILD_WIN_DIR%\%%I\build.bat" || goto :error
        )
	)
)

:: Check
CALL "%EXTLIBS_BUILD_WIN_DIR%\check_install.bat" %1 || goto:error

:::::::::::::::
:: Reaching End of the Script
GOTO :success

:::::::::::::::
:error
POPD
chgcolor %CERROR%
ECHO %0: ERROR
ECHO //////////
chgcolor %CRESET%
EXIT /B 1

:::::::::::::::
:success
POPD
chgcolor %CSUCCESS%
ECHO %0: SUCCESS
ECHO //////////
chgcolor %CRESET%
EXIT /B 0

