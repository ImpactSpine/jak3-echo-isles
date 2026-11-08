@echo off
title Jak 4 - Echo Isles Setup
set SCRIPT=%~dp0setup-echo-isles.ps1
if not exist "%SCRIPT%" (
  echo File setup-echo-isles.ps1 non trovato.
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
