@echo off

REM
REM dex2jar - Tools to work with android .dex and java .class files
REM Copyright (c) 2009-2013 Panxiaobo
REM 
REM Licensed under the Apache License, Version 2.0 (the "License");
REM you may not use this file except in compliance with the License.
REM You may obtain a copy of the License at
REM 
REM      http://www.apache.org/licenses/LICENSE-2.0
REM 
REM Unless required by applicable law or agreed to in writing, software
REM distributed under the License is distributed on an "AS IS" BASIS,
REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM See the License for the specific language governing permissions and
REM limitations under the License.
REM

REM call d2j_invoke.bat to setup java environment
java -jar %droidroot%\apktool.jar d -s -f %1
echo path is %~dp1%1.out
7za e %1 *.dex -y -o%~dp1%1.out\
call apktool d -s -f %1
cd %~dp1%1.out\
call %droidroot%\d2j-dex2jar .\*.dex --force
del /Q *.dex
call jd-cli %~dp1%1.out\ .\*-dex2jar.jar -od .\src\
del /Q *-dex2jar.jar
del /Q *-error.zip
del /Q .\original