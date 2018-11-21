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
:: Backup
PUSHD "%CD%"

:::::::::::::::
:: Test
chgcolor %CTEXT%
ECHO Building opencv and opencv_python

:::::::::::::::
:: Check install _install folder hierarchy
CALL _init_install.bat

:::::::::::::::
chgcolor %CRESET%


:: INIT GIT CPYTHON
PUSHD "%CD%"
CD %EXTLIBS_DIR%
chgcolor %CGIT%
@ECHO ON
git submodule update --init --recursive cpython
@ECHO OFF
POPD
chgcolor %CRESET%

:::::::::::::::
:: PATCH: We want to trim any reference to python, python2 or python3 in PATH before building python and OPENCV to avoid conflicts
SET "BACKUP_PATH=%PATH%"
SET "BACKUP_PYTHON=%PYTHON%"
SET "BACKUP_PYTHON_PATH=%PYTHON_PATH%"
SET "BACKUP_PYTHON_LIB=%PYTHON_LIB%"
setlocal enabledelayedexpansion
SET "NEW_PATH="

SET SPYTHON3=\python3.exe
SET PYTHON3=python3.exe
SET SPYTHON2=\python2.exe
SET PYTHON2=python2.exe
SET SPYTHON=\python.exe
SET PYTHON=python.exe

for %%A in ("%BACKUP_PATH:;=";"%") do (
    IF NOT %%A=="" (
        set ENTRY=%%A
        set ENTRY=!ENTRY:"=%!
        IF EXIST !ENTRY!%SPYTHON3% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE IF EXIST !ENTRY!%PYTHON3% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE IF EXIST !ENTRY!%SPYTHON2% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE IF EXIST !ENTRY!%PYTHON2% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE IF EXIST !ENTRY!%SPYTHON% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE IF EXIST !ENTRY!%PYTHON% (
            ECHO Removing !ENTRY! from PATH
        ) ELSE (
            REM If the path does not contain a python or python2 or python3, we keep it
            SET NEW_PATH=!NEW_PATH!!ENTRY!;
        )
    )
)

(
    endlocal
    REM PATCH export out of local scope
    SET "EXPORT_PATH=%NEW_PATH%"
)

REM Set new PATH without pythons
SET PATH=%EXPORT_PATH%
REM Tests, if a python is found we go to error
ECHO Checking if python is cleared from PATH
CALL python && goto :error
CALL python2 && goto :error
CALL python3 && goto :error

:::::::::::::::
:: Actual build commands for opencv_python cpython
CALL "%EXTLIBS_DIR%\cpython\PCBuild\build.bat" -r -e -v -k -c Release    -p x64 -t Rebuild
CALL "%EXTLIBS_DIR%\cpython\PCBuild\build.bat" -r -e -v -k -c Debug      -p x64 -t Rebuild

:::::::::::::::
:: Install Commands
chgcolor %CTEXT%
ECHO Rebuilding and installing _install\openc_python
chgcolor %CRESET%
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\"
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\DLLs"
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\include"
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\Lib"
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\libs"
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\Tools"
for /R "%EXTLIBS_DIR%\cpython\PCBuild\amd64" %%f in (*.lib) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\libs"
for /R "%EXTLIBS_DIR%\cpython\PCBuild\amd64" %%f in (*.pyd) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\DLLs"
for /R "%EXTLIBS_DIR%\cpython\PCBuild\amd64" %%f in (*.dll) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\DLLs"
for /R "%EXTLIBS_DIR%\cpython\PCBuild\amd64" %%f in (*.exe) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\"
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python3.dll" "%EXTLIBS_DIR%\_install\opencv_python\"
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python3_d.dll" "%EXTLIBS_DIR%\_install\opencv_python\"
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python37.dll" "%EXTLIBS_DIR%\_install\opencv_python\"
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python37_d.dll" "%EXTLIBS_DIR%\_install\opencv_python\"
XCOPY /e /h /y "%EXTLIBS_DIR%\cpython\Lib" "%EXTLIBS_DIR%\_install\opencv_python\Lib"
XCOPY /e /h /y "%EXTLIBS_DIR%\cpython\Include" "%EXTLIBS_DIR%\_install\opencv_python\include"
XCOPY /e /h /y "%EXTLIBS_DIR%\cpython\Tools" "%EXTLIBS_DIR%\_install\opencv_python\Tools"
COPY "%EXTLIBS_DIR%\cpython\PC\pyconfig.h" "%EXTLIBS_DIR%\_install\opencv_python\include\pyconfig.h"
SET BAKE_7Z = "7z.exe" x "%EXTLIBS_DIR%\_dep\numpy.whm" -o "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\" -y
CALL 7z.exe x "%EXTLIBS_DIR%\_dep\numpy.whl" "-o%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\" -y

:: PREPARE PYTHON OPTION FOR CMAKE FOR OPENCV & Replace backslash with forward slash
SET OCVPY_DIR="%EXTLIBS_DIR%\_install\opencv_python"
SET OCVPY_DIR=%OCVPY_DIR:\=/%
SET OCVPY_DIR=%OCVPY_DIR:"=%
SET OCVPY_PYTHON3_EXECUTABLE="%OCVPY_DIR%/python.exe"
SET OCVPY_PYTHON3_INCLUDE_DIR="%OCVPY_DIR%/include"
SET OCVPY_PYTHON3_LIBRARY="%OCVPY_DIR%/libs/python37.lib"
SET OCVPY_PYTHON3_LIBRARY_DEBUG="%OCVPY_DIR%/libs/python37_d.lib"
SET OCVPY_PYTHON3_NUMPY_INCLUDE_DIRS="%OCVPY_DIR%/Lib/site-packages/numpy/core/include"
SET OCVPY_PYTHON3_PACKAGES_PATH="%OCVPY_DIR%/Lib/site-packages"

:: ADD TMP OPENCVPYTHON PATH VARS
IF DEFINED _INIT_TMP_PY_PATH_HH goto :TMP_PY_PATH_END
SET "PATH=%PATH%;%EXTLIBS_DIR%\_install\opencv_python"
SET "PATH=%PATH%;%EXTLIBS_DIR%\_install\opencv_python\Lib"
SET "PATH=%PATH%;%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages"
SET "PATH=%PATH%;%EXTLIBS_DIR%\_install\opencv_python\include"
:: DEF GUARD
SET _INITEXTSHELL_BAT_HH=1
:TMP_PY_PATH_END

:::::::::::::::
:: Create tmp dir for out of source build
chgcolor %CRESET%
CD "%EXTLIBS_DIR%"
:REPEATDEL
RMDIR /s /q "%EXTLIBS_DIR%\_tmp"
IF EXIST "%EXTLIBS_DIR%\_tmp" GOTO REPEATDEL
:REPEATCREATE
MKDIR "%EXTLIBS_DIR%\_tmp"
IF NOT EXIST "%EXTLIBS_DIR%\_tmp" GOTO REPEATCREATE

:::::::::::::::
:: Actual build commands
CD "%EXTLIBS_DIR%\_tmp" || goto :error

CALL cmake -G "Visual Studio 15 2017 Win64" -DPYTHON3_INCLUDE_DIR=%OCVPY_PYTHON3_INCLUDE_DIR% -DPYTHON3_LIBRARY=%OCVPY_PYTHON3_LIBRARY% -DPYTHON3_LIBRARY_DEBUG=%OCVPY_PYTHON3_LIBRARY_DEBUG% "%EXTLIBS_DIR%\opencv\" || goto :error
CALL cmake --build . --config Release || goto :error

REM This is a fix because shitty cmake parsing & opencv config does not allow to simply pass debug logation.
PUSHD "%CD%"
CD "%EXTLIBS_DIR%\_tmp\modules\python3\"
powershell -Command "(gc opencv_python3.vcxproj) -replace 'python37.lib', 'python37_d.lib' | Out-File opencv_python3.vcxproj"
POPD

CALL cmake --build . --config Debug || goto :error


:::::::::::::::
:: BACKUP Python PATH
SET PATH=%BACKUP_PATH%
SET PYTHON=%BACKUP_PYTHON%
SET PYTHON_PATH=%BACKUP_PYTHON_PATH%
SET PYTHON_LIB=%BACKUP_PYTHON_LIB%


:::::::::::::::
:: Install OPENCV
for /R "%EXTLIBS_DIR%\_tmp\lib\Release" %%f in (*.lib) do copy %%f "%EXTLIBS_DIR%\_install\release_x64\lib\"
for /R "%EXTLIBS_DIR%\_tmp\lib\Debug" %%f in (*.lib) do copy %%f "%EXTLIBS_DIR%\_install\debug_x64\lib\"
for /R "%EXTLIBS_DIR%\_tmp\bin\Release" %%f in (*.dll) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\"
for /R "%EXTLIBS_DIR%\_tmp\bin\Debug" %%f in (*.dll) do copy %%f "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\"
:: COPY PYTHON 37 DLL TO OPENCVPYTHON SITEPACKAGE
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python37.dll" "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\"
copy "%EXTLIBS_DIR%\cpython\PCBuild\amd64\python37_d.dll" "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\"
:: COPY PYTHON DLL TO INSTALL OPENCVPYTHON AND RENAME TO CV2
copy "%EXTLIBS_DIR%\_tmp\lib\python3\Release\cv2.cp37-win_amd64.pyd" "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\cv2.pyd"
copy "%EXTLIBS_DIR%\_tmp\lib\python3\Debug\cv2.cp37-win_amd64.pyd" "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\cv2_d.pyd"
:: OPENCVPYTHON TEST
call:checkMakeDir "%EXTLIBS_DIR%\_install\opencv_python\opencv_python_samples"
XCOPY /e /h /y "%EXTLIBS_DIR%\_dep\opencv_python_samples" "%EXTLIBS_DIR%\_install\opencv_python\opencv_python_samples\"
:: COPY OPENCV INCLUDE
call:checkMakeDir "%EXTLIBS_DIR%\_install\include\opencv"
call:checkMakeDir "%EXTLIBS_DIR%\_install\include\opencv_python_bindings"
FOR %%G IN ("%EXTLIBS_DIR%\_tmp\*.h*") DO copy %%G "%EXTLIBS_DIR%\_install\include\opencv\"
FOR %%G IN ("%EXTLIBS_DIR%\_tmp\opencv2\*.h*") DO copy %%G "%EXTLIBS_DIR%\_install\include\opencv\"
FOR %%G IN ("%EXTLIBS_DIR%\_tmp\modules\python_bindings_generator\*.h*") DO copy %%G "%EXTLIBS_DIR%\_install\include\opencv_python_bindings\"

::MORE COMPLEX INCLUDE FROM SCATTERED SOURCES
PUSHD "%CD%"
CD "%EXTLIBS_DIR%\opencv\modules"
for /f "delims=" %%D in ('dir /a:d /b') do (
    MKDIR "%EXTLIBS_DIR%\_install\include\opencv\%%D"
    XCOPY /e /h /y "%EXTLIBS_DIR%\opencv\modules\%%D\include\opencv2" "%EXTLIBS_DIR%\_install\include\opencv\"
)
POPD

:::::::::::::::
:: Reaching End of the Script
GOTO :success

:::::::::::::::
:: Dir processing
:checkMakeDir
IF NOT EXIST "%~1\" ( MKDIR "%~1" )
goto:EOF
:: Return

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

