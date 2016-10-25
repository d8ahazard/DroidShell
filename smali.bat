@echo off
set PATH=%CD%;%PATH%;
FOR /f "tokens=*" %%G IN ('dir /b %~dp0\smali-*.jar') DO set BAKSMALI=%%G
java -jar -Duser.language=en "%~dp0\%SMALI%" %1 %2 %3 %4 %5 %6 %7 %8 %9