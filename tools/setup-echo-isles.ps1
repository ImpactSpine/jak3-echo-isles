#requires -Version 5.1
<#
Echo Isles bootstrap for Windows.
- Clones a separate Jak 3 development checkout (does not touch the user's Launcher install).
- Downloads this project's jak4-development branch and overlays only Echo Isles source assets.
- Registers the custom level in goal_src/jak3/game.gp, idempotently.
- Selects Jak 3 + PAL decompiler configuration.
- Does NOT extract copyrighted assets, compile, or launch the game automatically.
#>

$ErrorActionPreference = "Stop"
$BaseUrl = "https://github.com/whozghiar/jak3-mod-battle-of-spargus.git"
$ModZip = "https://github.com/ImpactSpine/jak3-echo-isles/archive/refs/heads/jak4-development.zip"
$InstallRoot = Join-Path $env:USERPROFILE "OpenGOAL-Jak3-EchoIsles"
$TempRoot = Join-Path $env:TEMP ("echo-isles-" + [guid]::NewGuid().ToString("N"))
$ModArchive = Join-Path $TempRoot "echo-isles.zip"

function Require-Command([string]$Name) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Comando '$Name' non trovato. Installa Git for Windows e Task (go-task) e poi rilancia questo script."
  }
}

Require-Command "git"
Require-Command "task"
New-Item -ItemType Directory -Force -Path $TempRoot | Out-Null

if (-not (Test-Path (Join-Path $InstallRoot ".git"))) {
  if (Test-Path $InstallRoot) {
    throw "La cartella '$InstallRoot' esiste ma non è un checkout Git. Rinominala o scegli un'altra cartella prima di procedere."
  }
  git clone $BaseUrl $InstallRoot
  if ($LASTEXITCODE -ne 0) { throw "Clone del progetto base non riuscito." }
} else {
  Write-Host "Checkout già presente: non eseguo pull o reset per non sovrascrivere modifiche locali."
}

Invoke-WebRequest -Uri $ModZip -OutFile $ModArchive
Expand-Archive -LiteralPath $ModArchive -DestinationPath $TempRoot -Force
$Extracted = Get-ChildItem $TempRoot -Directory | Where-Object { $_.Name -like "jak3-echo-isles-*" } | Select-Object -First 1
if (-not $Extracted) { throw "Archivio Echo Isles non estratto correttamente." }

$SourceLevel = Join-Path $Extracted.FullName "custom_assets\jak3\levels\echo-isles"
$TargetLevel = Join-Path $InstallRoot "custom_assets\jak3\levels\echo-isles"
if (-not (Test-Path $SourceLevel)) { throw "Cartella sorgente Echo Isles non trovata nell'archivio." }
New-Item -ItemType Directory -Force -Path (Split-Path $TargetLevel) | Out-Null
if (Test-Path $TargetLevel) {
  $Backup = "$TargetLevel.backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
  Move-Item $TargetLevel $Backup
  Write-Host "Backup della cartella Echo Isles esistente: $Backup"
}
Copy-Item $SourceLevel $TargetLevel -Recurse

$GameProject = Join-Path $InstallRoot "goal_src\jak3\game.gp"
if (-not (Test-Path $GameProject)) { throw "Non trovo goal_src\jak3\game.gp nel checkout." }
$GameText = Get-Content -LiteralPath $GameProject -Raw
if ($GameText -notmatch 'build-custom-level\s+"echo-isles"') {
  $Anchor = '(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")'
  if (-not $GameText.Contains($Anchor)) { throw "Blocco test-zone atteso non trovato in game.gp: nessuna modifica automatica applicata." }
  $Insert = @'
(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")

;; Echo Isles — first playable-area integration fixture
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
'@
  $GameText = $GameText.Replace($Anchor, $Insert.TrimEnd())
  Set-Content -LiteralPath $GameProject -Value $GameText -Encoding UTF8
}

Push-Location $InstallRoot
try {
  task set-game-jak3
  if ($LASTEXITCODE -ne 0) { throw "Selezione target Jak 3 fallita." }
  task set-decomp-pal
  if ($LASTEXITCODE -ne 0) { throw "Selezione configurazione PAL fallita." }
  Write-Host ""
  Write-Host "Preparazione completata. Cartella di sviluppo: $InstallRoot"
  Write-Host "Ora esegui 'task settings' e verifica GAME=jak3 e DECOMP_CONFIG=pal."
  Write-Host "NON eseguire ancora task extract o compilazioni: prima controlliamo il risultato e sistemiamo il GLB (vertex colors)."
} finally {
  Pop-Location
  Remove-Item $TempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
