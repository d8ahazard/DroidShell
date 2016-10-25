@echo off
set PATH=%CD%;%PATH%;
FOR /f "tokens=*" %%G IN ('dir /b %~dp0\signapk*.jar') DO set SIGNAPK=%%G
java -jar -Duser.language=en "%~dp0\%SIGNAPK%" "%~dp0\cert\cert.pem" "%~dp0\cert\key.pk8" %1 %~dp1%~n1-signed%~x1