# Echo Isles - preparazione automatica Windows (nessuna installazione globale)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Root = Join-Path $env:USERPROFILE "OpenGOAL-Jak3-EchoIsles"
$Tools = Join-Path $Root "_tools"
$Checkout = Join-Path $Root "jak3-base"
$Temp = Join-Path $env:TEMP ("echo-isles-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $Tools,$Temp | Out-Null
$Log = Join-Path $Root "preparazione-echo-isles.log"
function Say($m) { Write-Host $m; Add-Content -Path $Log -Value $m }
try {
  New-Item -ItemType Directory -Force -Path $Root | Out-Null
  "Echo Isles - log preparazione $(Get-Date -Format s)" | Set-Content $Log
  Say "[1/5] Recupero strumenti portatili ufficiali..."
  $gitDir = Join-Path $Tools "mingit"
  $taskDir = Join-Path $Tools "task"
  if (!(Test-Path (Join-Path $gitDir "cmd\git.exe"))) {
    $rel = Invoke-RestMethod "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $asset = $rel.assets | Where-Object { $_.name -match '^MinGit-.*-64-bit\.zip$' } | Select-Object -First 1
    if (!$asset) { throw "Pacchetto MinGit x64 non trovato nella release ufficiale." }
    $zip = Join-Path $Temp "mingit.zip"
    Invoke-WebRequest $asset.browser_download_url -OutFile $zip
    New-Item -ItemType Directory -Force -Path $gitDir | Out-Null
    Expand-Archive $zip $gitDir -Force
  }
  if (!(Test-Path (Join-Path $taskDir "task.exe"))) {
    $rel = Invoke-RestMethod "https://api.github.com/repos/go-task/task/releases/latest"
    $asset = $rel.assets | Where-Object { $_.name -eq 'task_windows_amd64.zip' } | Select-Object -First 1
    if (!$asset) { throw "Eseguibile Task x64 non trovato nella release ufficiale." }
    $zip = Join-Path $Temp "task.zip"
    Invoke-WebRequest $asset.browser_download_url -OutFile $zip
    New-Item -ItemType Directory -Force -Path $taskDir | Out-Null
    Expand-Archive $zip $taskDir -Force
  }
  $env:PATH = "$(Join-Path $gitDir 'cmd');$(Join-Path $gitDir 'mingw64\bin');$(Join-Path $gitDir 'usr\bin');$taskDir;$env:PATH"
  Say "[2/5] Preparo il progetto base Jak 3 in una cartella separata..."
  if (!(Test-Path (Join-Path $Checkout ".git"))) {
    if (Test-Path $Checkout) { throw "La cartella $Checkout esiste ma non è un checkout Git. Non la sovrascrivo." }
    & (Join-Path $gitDir "cmd\git.exe") clone --depth 1 "https://github.com/whozghiar/jak3-mod-battle-of-spargus.git" $Checkout
    if ($LASTEXITCODE -ne 0) { throw "Download del progetto base non riuscito." }
  } else { Say "Checkout già presente: lo mantengo senza reset." }
  Say "[3/5] Scarico i file Echo Isles..."
  $modZip = Join-Path $Temp "echo-isles.zip"
  Invoke-WebRequest "https://github.com/ImpactSpine/jak3-echo-isles/archive/refs/heads/jak4-development.zip" -OutFile $modZip
  $unpack = Join-Path $Temp "mod"
  Expand-Archive $modZip $unpack -Force
  $src = Join-Path $unpack "jak3-echo-isles-jak4-development\custom_assets\jak3\levels\echo-isles"
  if (!(Test-Path $src)) { throw "I file Echo Isles non sono presenti nell'archivio scaricato." }
  $dst = Join-Path $Checkout "custom_assets\jak3\levels\echo-isles"
  New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
  if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
  Copy-Item $src $dst -Recurse
  Say "[4/5] Registro il livello e imposto Jak 3 PAL..."
  $gp = Join-Path $Checkout "goal_src\jak3\game.gp"
  if (!(Test-Path $gp)) { throw "Non trovo game.gp nel progetto base." }
  $txt = Get-Content $gp -Raw
  if ($txt -notmatch 'build-custom-level\s+"echo-isles"') {
    $anchor = '(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")'
    if (!$txt.Contains($anchor)) { throw "Il blocco di riferimento test-zone è cambiato: fermo la procedura senza modificare game.gp." }
    $insert = @'
(custom-level-cgo "TSZ.DGO" "test-zone/testzone.gd")

;; Echo Isles
(build-custom-level "echo-isles")
(goal-src "levels/echo-isles/echo-isles-obs.gc" "process-focusable")
(custom-level-cgo "EIS.DGO" "echo-isles/echo-isles.gd")
'@
    $txt = $txt.Replace($anchor,$insert.TrimEnd())
    Set-Content $gp $txt -Encoding UTF8
  }
  Push-Location $Checkout
  try {
    & (Join-Path $taskDir "task.exe") set-game-jak3
    if ($LASTEXITCODE -ne 0) { throw "Impostazione Jak 3 non riuscita." }
    & (Join-Path $taskDir "task.exe") set-decomp-pal
    if ($LASTEXITCODE -ne 0) { throw "Impostazione decompiler PAL non riuscita." }
    Say "[5/5] Preparazione completata."
    Say "Cartella progetto: $Checkout"
    Say "Log: $Log"
    Say "Non è stata eseguita alcuna estrazione o compilazione e nessun file del gioco installato dal Launcher è stato modificato."
    Say "Il prossimo passo è verificare il setup e individuare la procedura sicura per usare i dati PAL locali."
  } finally { Pop-Location }
} catch {
  Say "ERRORE: $($_.Exception.Message)"
  Say "Invia questo log per correggere il problema: $Log"
  Read-Host "Premi INVIO per chiudere"
  exit 1
} finally { Remove-Item $Temp -Recurse -Force -ErrorAction SilentlyContinue }
Read-Host "Preparazione terminata. Premi INVIO per chiudere"
