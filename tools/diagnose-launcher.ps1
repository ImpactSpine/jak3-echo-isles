$ErrorActionPreference = "Stop"
$root = Join-Path $env:USERPROFILE "OpenGOAL-Jak3-EchoIsles"
New-Item -ItemType Directory -Force -Path $root | Out-Null
$report = Join-Path $root "diagnostica-launcher.txt"
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("Diagnostica OpenGOAL Launcher - sola lettura")
$lines.Add("Data: $(Get-Date -Format s)")
$lines.Add("")

$candidates = @(
  (Join-Path $env:APPDATA "OpenGOAL-Launcher\settings.json"),
  (Join-Path $env:APPDATA "OpenGOAL\settings.json")
)
$settings = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (!$settings) {
  $lines.Add("File settings.json non trovato nei percorsi standard:")
  $candidates | ForEach-Object { $lines.Add(" - $_") }
} else {
  $lines.Add("Settings: $settings")
  try {
    $cfg = Get-Content -Raw -LiteralPath $settings | ConvertFrom-Json
    $install = [string]$cfg.installationDir
    $active = [string]$cfg.activeVersion
    $lines.Add("Versione attiva: $active")
    $lines.Add("Cartella installazione: $install")
    if ($install) {
      $activeBin = Join-Path $install "active\bin"
      $versionBin = if ($active) { Join-Path (Join-Path (Join-Path $install "versions\official") $active) "" } else { "" }
      $lines.Add("")
      $lines.Add("Binari nella cartella attiva:")
      foreach ($name in @("extractor.exe","goalc.exe","gk.exe")) {
        $p = Join-Path $activeBin $name
        $lines.Add(("{0}: {1}" -f $name, (Test-Path $p)))
        if (Test-Path $p) { $lines.Add("  $p") }
      }
      if ($versionBin) {
        $lines.Add("")
        $lines.Add("Binari nella versione ufficiale:")
        foreach ($name in @("extractor.exe","goalc.exe","gk.exe")) {
          $p = Join-Path $versionBin $name
          $lines.Add(("{0}: {1}" -f $name, (Test-Path $p)))
          if (Test-Path $p) { $lines.Add("  $p") }
        }
      }
      $lines.Add("")
      $lines.Add("Cartelle dati Jak 3 candidate (solo verifica esistenza):")
      foreach ($rel in @("active\jak3\data","active\jak3\data\iso_data","active\jak3\data\iso_data\jak3","active\jak3\iso_data","active\data\jak3")) {
        $p = Join-Path $install $rel
        $lines.Add(("{0}: {1}" -f $p, (Test-Path $p)))
      }
    }
  } catch {
    $lines.Add("Errore lettura settings: $($_.Exception.Message)")
  }
}
$lines.Add("")
$lines.Add("Nessun file del Launcher o del gioco è stato modificato.")
$lines | Set-Content -LiteralPath $report -Encoding UTF8
Write-Host ($lines -join [Environment]::NewLine)
Write-Host ""
Write-Host "Report salvato in: $report"
Read-Host "Premi INVIO per chiudere"
