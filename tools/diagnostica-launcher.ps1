$ErrorActionPreference = "Stop"
$Root = Join-Path $env:USERPROFILE "OpenGOAL-Jak3-EchoIsles"
New-Item -ItemType Directory -Force -Path $Root | Out-Null
$Report = Join-Path $Root "diagnostica-launcher.txt"
$lines = New-Object System.Collections.Generic.List[string]
function AddLine([string]$s) { $lines.Add($s); Write-Host $s }
AddLine "DIAGNOSTICA OPENGOAL - ECHO ISLES"
AddLine ("Data: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
AddLine ""
AddLine "Controllo in sola lettura: non modifica il Launcher, il gioco o l'ISO."
AddLine ""

$candidates = @(
  (Join-Path $env:APPDATA "OpenGOAL-Launcher\settings.json"),
  (Join-Path $env:APPDATA "OpenGOAL Launcher\settings.json"),
  (Join-Path $env:APPDATA "open-goal-launcher\settings.json"),
  (Join-Path $env:APPDATA "OpenGOAL\Launcher\settings.json")
) | Select-Object -Unique

$settings = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $settings) {
  AddLine "ESITO: file settings.json del Launcher non trovato nei percorsi standard."
  AddLine "Percorsi controllati:"
  foreach ($p in $candidates) { AddLine (" - " + $p) }
  AddLine ""
  AddLine "Apri OpenGOAL Launcher una volta e ripeti il controllo."
  $lines | Set-Content -Path $Report -Encoding UTF8
  Read-Host "Premi INVIO per chiudere"
  exit 0
}

AddLine ("Configurazione trovata: " + $settings)
try {
  $cfg = Get-Content -LiteralPath $settings -Raw | ConvertFrom-Json
} catch {
  AddLine "ERRORE: impossibile leggere settings.json."
  AddLine $_.Exception.Message
  $lines | Set-Content -Path $Report -Encoding UTF8
  Read-Host "Premi INVIO per chiudere"
  exit 1
}

$install = [string]$cfg.installationDir
$activeVersion = [string]$cfg.activeVersion
AddLine ("Cartella installazione: " + $(if ($install) {$install} else {"NON CONFIGURATA"}))
AddLine ("Versione tooling attiva: " + $(if ($activeVersion) {$activeVersion} else {"NESSUNA"}))

if (-not $install) {
  AddLine "Il Launcher non ha ancora una cartella di installazione configurata."
} else {
  $bin = Join-Path $install "active\bin"
  AddLine ""
  AddLine ("Cartella strumenti: " + $bin)
  foreach ($exe in @("extractor.exe","goalc.exe","gk.exe")) {
    $p = Join-Path $bin $exe
    AddLine ("{0}: {1}" -f $exe, $(if (Test-Path $p) {"PRESENTE"} else {"ASSENTE"}))
  }

  $data = Join-Path $install "active\jak3\data"
  $isoData = Join-Path $data "iso_data\jak3"
  AddLine ""
  AddLine ("Dati Jak 3: " + $(if (Test-Path $data) {"PRESENTI"} else {"ASSENTI"}))
  AddLine ("Dati ISO PAL estratti (iso_data\jak3): " + $(if (Test-Path $isoData) {"PRESENTI"} else {"ASSENTI"}))
  if (Test-Path $isoData) {
    $count = (Get-ChildItem -LiteralPath $isoData -File -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
    AddLine ("File trovati nei dati ISO: " + $count)
  }
}

AddLine ""
AddLine "Nessun file del gioco è stato modificato. Nessuna ISO è stata copiata o caricata."
$lines | Set-Content -Path $Report -Encoding UTF8
AddLine ""
AddLine ("Report salvato in: " + $Report)
Read-Host "Invia il file diagnostica-launcher.txt e premi INVIO per chiudere"
