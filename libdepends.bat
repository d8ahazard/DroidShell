@echo off
set PATH=%CD%;%PATH%;
%droidroot%\ndk-depends %1 > %~dp1%~n1_depends.txt