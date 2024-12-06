@echo off
set SCRIPT_DIR=%~dp0
set VERSION=1.1.0.0
::
powershell -command "Expand-Archive -Force '%SCRIPT_DIR%target\LREditionDetails-%VERSION%_win.zip' '%HOMEDRIVE%%HOMEPATH%'"
pause

