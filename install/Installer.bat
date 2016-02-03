@echo off
:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
CLS
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


REM Run shell as admin (example) - put here code as   like
cd /d %~dp0/../
echo %CD%

if not exist "%programfiles%\Ext2Fsd" (
	echo Ext2FSD not found, installing.
	"%~dp0\ext2fsd.exe"
) else (echo Ext2FSD already exists.)

if not exist "%programfiles%\OSFMount" (
	echo OSFMount not found, installing.
	if %PROCESSOR_ARCHITECTURE%==x86 ("%~dp0\osfmount.exe") else ("%~dp0\osfmount_x64.exe")	
) else (echo OSFMount already exists.)

if not exist "%localappdata%\Programs\Python\Python35" (
	echo Python not found, installing.
	"%~dp0\python-3.5.1-amd64.exe"
) else (echo Python already exists.)


echo Creating Environment Variables (This takes a minute...)
if not "%DROIDROOT%"=="%CD%" (SETX /m droidroot "%CD%")
set "addpath"="%DROIDROOT%"
%droidroot%\install\setenv -a PATH "%PATH%;%droidroot%;%programfiles%\OSFMount"

echo Killing Explorer

taskkill /IM explorer.exe /F
echo Deleting current user settings.
echo Some errors here are normal.
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.apk\UserChoice /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcp\UserChoice /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dcf\UserChoice /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dci\UserChoice /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jar\UserChoice /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithProgids /va /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\UserChoice /va /f
Echo deleting old associations (if any)
Echo Errors here are not unusual
ftype jarfile=
ftype apk_auto_file=
ftype dcf_auto_file=
ftype dcp_auto_file=
ftype dci_auto_file=
ftype img_auto_file=
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
ftype nppfile="C:\Program Files (x86)\Notepad++\notepad++.exe %1"
echo Copying Custom Languages
copy "%~dp0\UserDefinelang.xml" "%appdata%\Notepad++\UserDefinelang.xml"
)
Ftype img_auto_file="%CD%\unpackimg.bat %1"
Ftype newimg="%CD%\undat.exe %1"

echo Importing registry associations
Reg.exe add "HKCR\.apk" /ve /t REG_SZ /d "apk_auto_file" /f
Reg.exe add "HKCR\.dcf" /ve /t REG_SZ /d "dcf_auto_file" /f
Reg.exe add "HKCR\.dci" /ve /t REG_SZ /d "dci_auto_file" /f
Reg.exe add "HKCR\.dcp" /ve /t REG_SZ /d "dcp_auto_file" /f
Reg.exe add "HKCR\.img" /ve /t REG_SZ /d "img_auto_file" /f
Reg.exe add "HKCR\.jar" /ve /t REG_SZ /d "jarfile" /f
Reg.exe add "HKCR\.list" /ve /t REG_SZ /d "newimg" /f

echo HKCR...
Reg.exe add "HKCR\Applications\decompile.bat\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
Reg.exe add "HKCR\Applications\decompile.bat\shell\Decompile to Java" /ve /t REG_SZ /d "Decompile to Java" /f
Reg.exe add "HKCR\Applications\decompile.bat\shell\Decompile to Java\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\" \"-s\"" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile and Sign" /ve /t REG_SZ /d "Compile And Sign" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile_sign_clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\Compile_sign_clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
Reg.exe add "HKCR\Applications\recompile.exe\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKCR\Applications\unpackimg.bat\shell\Mount\command" /ve /t REG_SZ /d "\"%CD%\unpackimg.bat\" \"%%1\" \"-m\"" /f
Reg.exe add "HKCR\Applications\unpackimg.bat\shell\open\command" /ve /t REG_SZ /d "\"%CD%\unpackimg.bat\" \"%%1\"" /f
Reg.exe add "HKCR\Applications\undat.exe\shell\open\command" /ve /t REG_SZ /d "\"%CD%\undat.exe\" \"%%1\"" /f

echo HKCU...
Reg.exe add "HKCU\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\apk.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open" /ve /t REG_SZ /d "Decompile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Decompile to Java" /ve /t REG_SZ /d "Decompile to Java" /f
Reg.exe add "HKCU\SOFTWARE\Classes\apk_auto_file\shell\Decompile to Java\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\" \"-s\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile And Sign" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dci_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\repackimg.bat\" \"%%1\" \"-c\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dci_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\repackimg.bat\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile and Sign" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\img_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\boot.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\img_auto_file\shell\Mount" /ve /t REG_SZ /d "Mount" /f
Reg.exe add "HKCU\SOFTWARE\Classes\img_auto_file\shell\Mount\command" /ve /t REG_SZ /d "\"%CD%\unpackimg.bat\" \"%%1\" \"-m\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\img_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\img_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\repackimg.bat\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\jarfile\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\apk.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\jarfile\shell\open" /ve /t REG_SZ /d "Decompile" /f
Reg.exe add "HKCU\SOFTWARE\Classes\jarfile\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
Reg.exe add "HKCU\SOFTWARE\Classes\newimg\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\dat.ico,0" /f
Reg.exe add "HKCU\SOFTWARE\Classes\newimg\shell\open" /ve /t REG_SZ /d "Unpack" /f
Reg.exe add "HKCU\SOFTWARE\Classes\newimg\shell\open\command" /ve /t REG_SZ /d "\"%CD%\undat.exe\" \"%%1\"" /f

Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /v "a" /t REG_SZ /d "unpackimg.bat" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /v "b" /t REG_SZ /d "unpackimg.bat" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /v "MRUList" /t REG_SZ /d "ba" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithProgids" /v "Windows.IsoFile" /t REG_NONE /d "" /f
echo HKLM...
Reg.exe add "HKLM\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\apk.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\apk_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\apk_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Decompile to Java" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\apk_auto_file\shell\Decompile to java\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\" \"-s\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile And Sign" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dci_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dci_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dci_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\android-icon.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean" /ve /t REG_SZ /d "Compile and Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign" /ve /t REG_SZ /d "Compile and Sign" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-s\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean" /ve /t REG_SZ /d "Compile/Sign/Clean" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\" \"-c\" \"-s\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\img_auto_file\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\boot.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\img_auto_file\shell\Mount" /ve /t REG_SZ /d "Mount" /f
Reg.exe add "HKLM\SOFTWARE\Classes\img_auto_file\shell\Mount\command" /ve /t REG_SZ /d "\"%CD%\unpackimg.bat\" \"%%1\" \"-m\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\img_auto_file\shell\open" /ve /t REG_SZ /d "Compile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\img_auto_file\shell\open\command" /ve /t REG_SZ /d "\"%CD%\recompile.exe\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\newimg\shell\open" /ve /t REG_SZ /d "Unpack" /f
Reg.exe add "HKLM\SOFTWARE\Classes\newimg\shell\open\command" /ve /t REG_SZ /d "\"%CD%\undat.exe\" \"%%1\"" /f
Reg.exe add "HKLM\SOFTWARE\Classes\jarfile\DefaultIcon" /ve /t REG_SZ /d "%CD%\install\apk.ico,0" /f
Reg.exe add "HKLM\SOFTWARE\Classes\jarfile\shell\open" /ve /t REG_SZ /d "Decompile" /f
Reg.exe add "HKLM\SOFTWARE\Classes\jarfile\shell\open\command" /ve /t REG_SZ /d "\"%CD%\decompile.bat\" \"%%1\"" /f
if exist %localappdata%\IconCache.db (
echo Clearing Icon Cache
DEL "%localappdata%\IconCache.db" /A
)
echo Restarting Explorer
start explorer.exe
echo Success!  A reboot may be necessary now.
pause
EXIT