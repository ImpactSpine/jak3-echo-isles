$ErrorActionPreference = "SilentlyContinue"
$Root = Join-Path $env:USERPROFILE "OpenGOAL-Jak3-EchoIsles"
New-Item -ItemType Directory -Force -Path $Root | Out-Null
$Report = Join-Path $Root "diagnostica-toolchain.txt"
$lines = New-Object System.Collections.Generic.List[string]
function AddLine([string]$s) { $lines.Add($s); Write-Host $s }
AddLine "DIAGNOSTICA TOOLCHAIN C++ - ECHO ISLES"
AddLine ("Data: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
AddLine "Controllo in sola lettura: non installa, modifica o elimina nulla."
AddLine ""
foreach ($name in @("cmake","ninja","clang","clang++","clang-cl","cl","git","python","py")) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($cmd) { AddLine ("{0}: PRESENTE - {1}" -f $name,$cmd.Source) }
  else { AddLine ("{0}: NON TROVATO nel PATH" -f $name) }
}
AddLine ""
$pf86 = [Environment]::GetFolderPath("ProgramFilesX86")
$vswhere = Join-Path $pf86 "Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vswhere) {
  $vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  if ($vs) {
    AddLine ("Visual Studio C++: PRESENTE - " + $vs)
    $vcvars = Join-Path $vs "VC\Auxiliary\Build\vcvars64.bat"
    AddLine ("vcvars64.bat: " + $(if (Test-Path $vcvars) {"PRESENTE"} else {"ASSENTE"}))
  } else { AddLine "Visual Studio C++: NON TROVATO" }
} else { AddLine "vswhere: NON TROVATO (Visual Studio C++ non verificabile)" }
AddLine ""
$ram = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
AddLine ("RAM fisica: {0:N1} GB" -f ($ram.TotalPhysicalMemory/1GB))
AddLine ("RAM libera al controllo: {0:N1} GB" -f ($os.FreePhysicalMemory/1MB/1024))
$drive = Get-PSDrive -Name (Get-Item $env:USERPROFILE).PSDrive.Name
AddLine ("Spazio libero sul disco del profilo: {0:N1} GB" -f ($drive.Free/1GB))
AddLine ""
AddLine "NOTA: il Launcher ha già extractor.exe, goalc.exe e gk.exe; questo controllo riguarda gli strumenti C++ del progetto sorgente."
$lines | Set-Content -Path $Report -Encoding UTF8
AddLine ""
AddLine ("Report salvato in: " + $Report)
Read-Host "Invia diagnostica-toolchain.txt in chat e premi INVIO per chiudere"
