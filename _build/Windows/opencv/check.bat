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
ECHO Checking cpython

call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\include\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\include\pyconfig.h" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\include\code.h" || goto :error

call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\cvconfig.h" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\cv_cpu_config.h" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\opencv_modules.hpp" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\core.hpp" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\core\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv\core\mat.hpp" || goto :error

call:checkExist "%EXTLIBS_DIR%\_install\include\opencv_python_bindings\" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\include\opencv_python_bindings\pyopencv_custom_headers.h" || goto :error

call:checkExist "%EXTLIBS_DIR%\_install\release_x64\lib\opencv_core400.lib" || goto :error
call:checkExist "%EXTLIBS_DIR%\_install\debug_x64\lib\opencv_core400d.lib" || goto :error

call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\python.exe"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\python_d.exe"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\python37.dll"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\python37_d.dll"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\numpy"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\cv2.pyd"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\cv2_d.pyd"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\python37.dll"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\python37_d.dll"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\opencv_core400.dll"
call:checkExist "%EXTLIBS_DIR%\_install\opencv_python\Lib\site-packages\opencv_core400d.dll"

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

