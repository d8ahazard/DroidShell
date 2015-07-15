@echo off
SETLOCAL EnableDelayedExpansion
REM First, type our recompile file to a variable
for /f "delims=" %%x in ('type %1') do set "z=%%x"
REM Check to make sure it's real, then recompile
if NOT EXIST ".\%z%" (goto NOFILE)
java -jar %~dp0\apktool.jar b %z%
REM Make sure it worked
if errorlevel 1 GOTO NOOUT
REM Move into the proper position
cd %z%
cd build\apk
REM Check what we built, set the right file extension
echo %~x1
if %~x1==.dcp (
	set "ex=.apk"
	del AndroidManifest.xml
) else (
	set ex=.jar
	set z2=!z:~0,-9!
)
REM Remove some spaces
for /l %%a in (1,1,100) do if "!z:~-1!"==" " set z=!z:~0,-1!
for /l %%a in (1,1,100) do if "!ex:~-1!"==" " set ex=!ex:~0,-1!
REM Build a path
if %ex%==.apk (set ppath=%z%%ex%) ELSE (set ppath=%z2%%ex%)
echo %ppath%
if NOT EXIST "../../../%ppath%" (goto NOZIP)
%~dp0\7za a -tzip ../../../%ppath% *.* -r
cd ../../..
if %2=="-c" (goto CLEANUP) else (goto DONE)
:NOFILE
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "Nothing to recompile!" ,10 ,"File Not Found", 0)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo You Clicked OK
) else (
  echo The Message timed out.
)
del %tmp%\tmp.vbs
goto DONE

:NOZIP
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "Destination archive (jar or zip) not found!" ,10 ,"File Not Found", 0)) >> %tmp%\tmp.vbs
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
echo WScript.Quit (WshShell.Popup( "Compile error detected!  Press OK to close, cancel to review." ,30 ,"Compile Failed", 1)) >> %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo Closing
) else (
  pause
)
del %tmp%\tmp.vbs
goto DONE

:CLEANUP
del /Q %1
rmdir /S /Q %z%
:DONE