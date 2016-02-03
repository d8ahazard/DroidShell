
pause
set rompath=%~1
set file=%~2
cd %~p0
rd /s /q %droidroot%\ramdisk > nul 2>&1
rd /s /q %droidroot%\split_img > nul 2>&1
rd /s /q %rompath%%file%\ramdisk > nul 2>&1
rd /s /q %rompath%%file%\split_img > nul 2>&1
del *new.* > nul 2>&1
