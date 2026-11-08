@echo off
setlocal
title Diagnostica OpenGOAL - Echo Isles
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\diagnostica-launcher.ps1"
if errorlevel 1 (
  echo.
  echo Si e verificato un errore. Controlla il messaggio sopra.
)
endlocal
