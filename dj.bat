@echo off
java -jar %droidroot%\apktool.jar d -s -f %1
for /f "delims=" %%a  in ("%1") do set "Extension=%%~xa"
if /I "%Extension%"==".apk" (set outpath="%~dp1%~n1_j") else (set outpath="%~dp1%1.out_j")
7za e %1 *.dex -y -o%outpath%\
call apktool d -s -f %1
cd %outpath%
call %droidroot%\d2j-dex2jar .\*.dex --force
del /Q *.dex
call jd-cli %outpath%\ .\*-dex2jar.jar -od .\src\
del /Q *-dex2jar.jar
del /Q *-error.zip
del /Q .\original