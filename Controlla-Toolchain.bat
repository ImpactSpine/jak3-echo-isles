@echo off
setlocal
title Controllo toolchain C++ - Echo Isles
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\diagnostica-toolchain.ps1"
endlocal
