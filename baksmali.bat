@echo off
set PATH=%CD%;%PATH%;
FOR /f "tokens=*" %%G IN ('dir /b %~dp0\baksmali-*.jar') DO set BAKSMALI=%%G
java -jar -Duser.language=en "%~dp0\%BAKSMALI%" %1 %2 %3 %4 %5 %6 %7 %8 %9