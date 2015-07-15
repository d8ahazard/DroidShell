:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
@echo off
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
echo Deleting keys
Reg.exe delete "HKCR\.apk" /f 
Reg.exe delete "HKCR\.dcf" /f 
Reg.exe delete "HKCR\.dci" /f 
Reg.exe delete "HKCR\.dcp" /f 
Reg.exe delete "HKCR\.jar" /f 
echo HKCR...
Reg.exe delete "HKCR\Applications\decompile.exe\shell\Decompile\command" /f 
Reg.exe delete "HKCR\Applications\decompile.exe\shell\open\command" /f 
Reg.exe delete "HKCR\Applications\recompile.exe\shell\Compile and Clean" /f 
Reg.exe delete "HKCR\Applications\recompile.exe\shell\Compile and Sign" /f 
Reg.exe delete "HKCR\Applications\recompile.exe\shell\Compile_sign_clean" /f 
Reg.exe delete "HKCR\Applications\recompile.exe\shell\open\command" /f 
Reg.exe delete "HKCR\Applications\repackimg.bat\shell\open\command" /f 
Reg.exe delete "HKCR\Applications\unpackimg.bat\shell\open\command" /f 
echo HKCU...
Reg.exe delete "HKCU\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\apk_auto_file\shell\open\command" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcf_auto_file\shell\open\command" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dci_auto_file\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dci_auto_file\shell\open" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcp_auto_file\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\dcp_auto_file\shell\open" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\img_auto_file\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\img_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\img_auto_file\shell\open" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\jarfile\DefaultIcon" /f 
Reg.exe delete "HKCU\SOFTWARE\Classes\jarfile\shell\open" /f 
Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /f 
Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /f 
Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithList" /f 
Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\OpenWithProgids" /f 
Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.img\UserChoice" /f 
echo HKLM...
Reg.exe delete "HKLM\SOFTWARE\Classes\apk_auto_file\DefaultIcon" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\apk_auto_file\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\apk_auto_file\shell\open\command" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcf_auto_file\DefaultIcon" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile and Sign" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\Compile_sign_clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcf_auto_file\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dci_auto_file\DefaultIcon" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dci_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dci_auto_file\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcp_auto_file\DefaultIcon" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile and Sign" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\Compile_Sign_Clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\dcp_auto_file\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\img_auto_file\shell\Compile and Clean" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\img_auto_file\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\jarfile\DefaultIcon" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\jarfile\shell\open" /f 
Reg.exe delete "HKLM\SOFTWARE\Classes\jarfile\shell\open\command" /f
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v droidroot /f
taskkill /IM explorer.exe /F
start explorer.exe
echo Please reboot now.
pause
EXIT