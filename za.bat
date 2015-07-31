@echo off
copy %1 %~n1_orig.apk
del %1
zipalign.exe -v 4 %~n1_orig.apk %1
