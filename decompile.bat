@echo off
Setlocal EnableDelayedExpansion
IF NOT EXIST %1 goto NOFILE
set PATH=%CD%;%PATH%;
if /I "%2"=="-s" goto DJ
java -jar %droidroot%\apktool.jar d -b -f %1
if errorlevel 1 goto NOOUT
for /f "delims=" %%a  in ("%1") do set "Extension=%%~xa"
if /I "%Extension%"==".apk" (echo %~n1 > %~n1.dcp) else (echo %~n1.jar.out > %~n1.dcf)
goto DONE

:NOFILE
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "No file specified.  How did you do that?" ,10 ,"File Not Found", 0)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo You Clicked OK
) else (
  echo The Message timed out.
)
del %tmp%\tmp.vbs
goto DONE

:NOTPKG
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "The file you specified is not a valid package.  Sorry." ,1000 ,"File Not Found", 0)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo You Clicked OK
) else (
  echo The Message timed out.
)
del %tmp%\tmp.vbs
goto DONE

:NOOUT
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "Decompile error detected!  Press OK to close, cancel to review." ,1000 ,"Decompile Failed", 1)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo Closing
) else (
  pause
)
del %tmp%\tmp.vbs
goto DONE

:DJ
echo Prepare to decompile...to JAVA
pause
dj.bat %1

:DONE