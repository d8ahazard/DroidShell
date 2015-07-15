@echo off
set PATH=%CD%;%PATH%;
java -jar -Duser.language=en "%~dp0\smali.jar" %1 %2 %3 %4 %5 %6 %7 %8 %9