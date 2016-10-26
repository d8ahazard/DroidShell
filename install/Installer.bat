@echo off
:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::

ECHO.
ECHO =============================
ECHO DroidShell Installer
ECHO =============================

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
setlocal & pushd .

cd /d %~dp0/../

echo Searching user directory for android SDK.
for /r %homepath% %%a in (*.txt) do if "%%~nxa"=="SDK Readme.txt" set p=%%~dpa
if defined p (
echo Sdk found in %p%.
set tempvar=%p%
goto moveon
) 

echo SDK not found in users directory, doing a full search. (Be patient, this takes a moment)
for /r C:\ %%a in (*.txt) do if "%%~nxa"=="SDK Readme.txt" set p=%%~dpa
if defined p (
echo Sdk found in %p%.
set tempvar=%p%
goto moveon
)

:nosdk
echo SDK not found, downloading platform-tools.  Please accept the license in a few moments.
.\sdk_tools\android update sdk --no-ui --filter platform-tools
if exist %cd%\platform-tools (set tempvar="%CD%\platform-tools")

:moveon
set "tempvar=%tempvar:"=%"
set adbpath=%tempvar%

echo Creating Environment Variables (This takes a minute...)
if not "%DROIDROOT%"=="%CD%" (SETX /m droidroot "%CD%")

echo %adbpath%

%droidroot%\install\setenv -a PATH "%PATH%;%droidroot%;%adbpath%;%programfiles%\OSFMount"

if not exist "%localappdata%\Programs\Python\Python35" (
	echo Python not found, installing.
	"%~dp0\python-3.5.1-amd64.exe"
) else (echo Python already exists.)

if not exist "%programfiles%\grepWin" (
	echo GrepWin not found, installing.
	"%~dp0\grepWin-1.6.15-x64.msi /q"
) else (echo GrepWin is already installed.)

if not exist "%programfiles%\Beyond Compare 4" (
	echo Beyond Compare not found, installing.
	wget http://www.scootersoftware.com/BCompare-4.1.9.21719_x64.msi
	"%~\dp0\Bcompare-4.1.9.21719_x64.msi /q"
)
echo Killing Explorer

%systemroot%\system32\taskkill /IM explorer.exe /F
echo Deleting current user settings.
echo Some errors here are normal.

%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\UserChoice /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\UserChoice /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\UserChoice /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\UserChoice /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\UserChoice /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithProgids /va /f
%systemroot%\system32\reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\UserChoice /va /f

%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\apk_auto_file\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\dcf_auto_file\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\dcp_auto_file\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\dci_auto_file\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\img_auto_file\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\jarfile\ /va /f
%systemroot%\system32\reg delete HKCU\SOFTWARE\Classes\newimg\ /va /f

Echo deleting old associations (if any)
Echo Errors here are not unusual
ftype jarfile=
ftype apk_auto_file=
ftype dcf_auto_file=
ftype dcp_auto_file=
ftype dci_auto_file=
ftype img_auto_file=
ftype newimg=

echo Making some associations
assoc .jar=jarfile
assoc .img=img_auto_file
assoc .apk=apk_auto_file
assoc .dcf=dcf_auto_file
assoc .dci=dci_auto_file
assoc .dcp=dcp_auto_file
assoc .list=newimg

if exist "C:\Program Files (x86)\Notepad++\Notepad++.exe" (

	echo Notepad++ found, associating.
	Assoc .xml=nppfile
	Assoc .prop=nppfile
	Assoc .conf=nppfile
	Assoc .config=nppfile
	Assoc .smali=nppfile
	Assoc .lca=nppfile
	Assoc .log=nppfile
	ftype nppfile="C:\Program Files (x86)\Notepad++\notepad++.exe %1"
	echo Copying Custom Languages
	copy "%~dp0\UserDefinelang.xml" "%appdata%\Notepad++\UserDefinelang.xml"

)

echo Importing registry associations
%systemroot%\system32\reg add "HKCR\.apk" /ve /t REG_SZ /d "apk_auto_file" /f
%systemroot%\system32\reg add "HKCR\.dcf" /ve /t REG_SZ /d "dcf_auto_file" /f
%systemroot%\system32\reg add "HKCR\.dci" /ve /t REG_SZ /d "dci_auto_file" /f
%systemroot%\system32\reg add "HKCR\.dcp" /ve /t REG_SZ /d "dcp_auto_file" /f
%systemroot%\system32\reg add "HKCR\.img" /ve /t REG_SZ /d "img_auto_file" /f
%systemroot%\system32\reg add "HKCR\.jar" /ve /t REG_SZ /d "jarfile" /f
%systemroot%\system32\reg add "HKCR\.list" /ve /t REG_SZ /d "newimg" /f

echo HKCR...
%systemroot%\system32\reg add "HKCR\Applications\unpackimg.bat\DefaultIcon" /ve /t REG_SZ /d "C:\DroidShell\install\dat.ico,0" /f
%systemroot%\system32\reg add "HKCR\Applications\unpackimg.bat\shell\open\command" /ve /t REG_SZ /d "\"C:\DroidShell\unpackimg.bat\" \"%%1\"" /f

%systemroot%\system32\reg add "HKCR\jarfile" /ve /t REG_SZ /d "Executable Jar File" /f
%systemroot%\system32\reg add "HKCR\jarfile\DefaultIcon" /ve /t REG_SZ /d "C:\DroidShell\install\jar.ico,0" /f
%systemroot%\system32\reg add "HKCR\jarfile\shell\open" /ve /t REG_SZ /d "Decompile" /f
%systemroot%\system32\reg add "HKCR\jarfile\shell\open\command" /ve /t REG_SZ /d "\"C:\DroidShell\decompile.bat\" \"%%1\"" /f

echo HKCU...
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\apk.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open" /ve /t REG_SZ /d "Decompile" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Decompile to Java" /ve /t REG_SZ /d "Decompile to Java" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Decompile to Java\command" /ve /t REG_SZ /d "\"%CD%\dj.bat\" \"%%1\" \"-s\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Sign" /ve /t REG_SZ /d "Sign" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Sign\command" /ve /t REG_SZ /d "\"%CD%\signapk.bat\" \"%%1\" \"-s\"" /f

%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile And Sign" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f

%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dci_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\repackimg.bat\" \"%%1\" \"-c\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\repackimg.bat\" \"%%1\"" /f

%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile and Sign" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f

%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\img_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\boot.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\img_auto_file\shell\Extract" /ve /t REG_SZ /d "Mount" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\img_auto_file\shell\Extract\command" /ve /t REG_SZ /d "\"%CD%\unpackimg.bat\" \"%%1\" \"-m\"" /f

%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\jarfile\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\jar.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\jarfile\shell\open" /ve /t REG_SZ /d "Decompile" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\jarfile\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\newimg\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\dat.ico,0" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\newimg\shell\open" /ve /t REG_SZ /d "Unpack" /f
%systemroot%\system32\reg add "HKCU\SOFTWARE\Classes\newimg\shell\open\command" /ve /t REG_SZ /d "\"%CD%\undat.exe\" \"%%1\"" /f

%systemroot%\system32\reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /v "a" /t REG_SZ /d "unpackimg.bat" /f
%systemroot%\system32\reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\OpenWithList" /v "b" /t REG_SZ /d "repackimg.bat" /f

if exist %localappdata%\IconCache.db (
echo Clearing Icon Cache
DEL "%localappdata%\IconCache.db" /A
)
echo Restarting Explorer
start explorer.exe
echo Success!  A reboot may be necessary now.
pause
EXIT