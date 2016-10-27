@ECHO OFF
set CYGWIN=nodosfilewarning
set hideErrors=n
set rompath=%~dp1
if "%~1" == "" goto noargs
set "file=%~f1"
set "fullpath=%1"
set "originalfilename=%~n1"
set bin=%droidroot%\android_win_tools
set "errout= "
if "%hideErrors%" == "y" set "errout=2>nul"
echo Droidshell Image Upacker
echo based on Android Image Kitchen
echo by osm0sis @ xda-developers
echo roided out by Digitalhigh
cd %rompath%
echo Supplied image: %~nx1
echo Full path is: %1 or %fullpath%

set "line=%~nx1"
setlocal enabledelayedexpansion

set "pattern=system"
if "!line:%pattern%=!"=="!line!" (
	goto sysimg
)

set "pattern=data"
if "!line:%pattern%=!"=="!line!" (
	goto sysimg
)

set "pattern=vendor"
if "!line:%pattern%=!"=="!line!" (
	goto sysimg
)

set "pattern=TWRP"
if "!line:%pattern%=!"=="!line!" (
	goto bootimg
)

set "pattern=CWM"
if "!line:%pattern%=!"=="!line!" (
	goto bootimg
)

set "pattern=recovery"
if "!line:%pattern%=!"=="!line!" (
	goto bootimg
)

set "pattern=boot"
if "!line:%pattern%=!"=="!line!" (
	goto bootimg
)
goto :EOF

:bootimg
endlocal
if exist %rompath%%~n1\split_img\nul set "noclean=1"
if exist %rompath%%~n1\ramdisk\nul set "noclean=1"
if not "%noclean%" == "1" goto noclean
echo Removing old work folders and files . . .
echo.
echo About to call cleanup > C:\droidshell\log.txt
call cleanup.bat "%rompath%" "%~n1"

:noclean
echo Setting up work folders . . .
echo.
md split_img
md ramdisk

echo Splitting image to "/split_img/" . . .
echo.
cd split_img
%bin%\unpackbootimg -i "%~1"
if errorlevel == 1 call "%~p0\cleanup.bat" & goto error
echo.
%bin%\file -m %bin%\magic *-ramdisk.gz %errout% | %bin%\cut -d: -f2 %errout% | %bin%\cut -d" " -f2 %errout% > "%~nx1-ramdiskcomp"
for /f "delims=" %%a in ('type "%~nx1-ramdiskcomp"') do @set ramdiskcomp=%%a
if "%ramdiskcomp%" == "gzip" set "unpackcmd=gzip -dc" & set "compext=gz"
if "%ramdiskcomp%" == "lzop" set "unpackcmd=lzop -dc" & set "compext=lzo"
if "%ramdiskcomp%" == "lzma" set "unpackcmd=xz -dc" & set "compext=lzma"
if "%ramdiskcomp%" == "xz" set "unpackcmd=xz -dc" & set "compext=xz"
if "%ramdiskcomp%" == "bzip2" set "unpackcmd=bzip2 -dc" & set "compext=bz2"
if "%ramdiskcomp%" == "lz4" ( set "unpackcmd=lz4" & set "extra=stdout 2>nul" & set "compext=lz4"  ) else ( set "extra= " )
ren *ramdisk.gz *ramdisk.cpio.%compext%
cd ..

echo Unpacking ramdisk . . .
echo.
cd ramdisk
echo Compression used: %ramdiskcomp%
if "%compext%" == "" goto error
%bin%\%unpackcmd% "../split_img/%~nx1-ramdisk.cpio.%compext%" %extra% %errout% | %bin%\cpio -i %errout%
if errorlevel == 1 goto error
echo.
cd ..
md %rompath%%~n1\split_img 2> nul
md %rompath%%~n1\ramdisk 2> nul
xcopy %droidroot%\ramdisk %rompath%%~n1\ramdisk /s /e
xcopy %droidroot%\split_img %rompath%%~n1\split_img /s /e
rd /s /q %droidroot%\ramdisk > nul 2>&1
rd /s /q %droidroot%\split_img > nul 2>&1
echo %~dp1%~n1 > %~dp1\%~n1.dci
echo Done!
goto end

:sysimg
endlocal
echo Trying to unpack %~nx1.
SET HOUR=%time:~-11,2%
Call :TRIM %HOUR%
GOTO EOT
:TRIM
Set HOUR=%*
:EOT

SET DATESTMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%%HOUR%
SET FILENAME=%originalfilename%_%DATESTMP%
if exist %ROMPATH%%FILENAME% (
	echo Looks like we extracted this already today, appending time stamp.
	SET FILENAME=%originalfilename%_%DATESTMP%_%time:~-8,2%%time:~-5,2%
)
echo %1 %FILENAME% %DATESTMP% %originalfilename%
mkdir "%ROMPATH%%FILENAME%"
%droidroot%\Imgextractor.exe %fullpath% "%rompath%%filename%" -i

if exist %rompath%%filename%_statfile.txt (
	mv %rompath%%filename%_statfile.txt %ROMPATH%%FILENAME%\%ROMPATH%%FILENAME%_statfile.txt
	goto SUCCESS
)

:SUCCESS

echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "System image extracted to %rompath%%filename%." ,5 ,"Success!", 0 + 64)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
goto end
EXIT /b 0

:SUCCESS2
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "Boot image extracted!" ,5 ,"Success!", 0 + 64)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
goto end

:NOARGS
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "No image specified.  I can't just make one up, you know." ,5 ,"Mount failed!", 0 + 48)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
goto end


:end
echo.

