# ============================================================
# DESINSTALLATION - Mute Discord / SteelSeries Sonar
# Compatible avec le lanceur invisible WScript
# ============================================================

$TaskName     = "Mute Discord - Sonar Microphone"
$WatcherPath  = Join-Path $PSScriptRoot "MuteDiscordSonar.ps1"
$LauncherPath = Join-Path $PSScriptRoot "MuteDiscordSonarHidden.vbs"

Write-Host ""
Write-Host "=== Desinstallation Discord / Sonar Watcher ===" -ForegroundColor Cyan
Write-Host ""

# Supprime la tache planifiee.
$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($task) {
    Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "[OK] Tache planifiee supprimee." -ForegroundColor Green
} else {
    Write-Host "[INFO] Tache planifiee absente." -ForegroundColor Yellow
}

# Arrete le watcher cache, car il est detache de la tache WScript.
$watcherEscaped = [regex]::Escape($WatcherPath)
$processes = Get-CimInstance Win32_Process |
    Where-Object {
        $_.Name -eq "powershell.exe" -and
        $_.CommandLine -match $watcherEscaped
    }

foreach ($process in $processes) {
    Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] Watcher cache arrete. PID : $($process.ProcessId)" -ForegroundColor Green
}

# Supprime uniquement le lanceur genere.
if (Test-Path -LiteralPath $LauncherPath) {
    Remove-Item -LiteralPath $LauncherPath -Force
    Write-Host "[OK] Lanceur invisible supprime." -ForegroundColor Green
}

Write-Host ""
Write-Host "MuteDiscordSonar.ps1 est conserve." -ForegroundColor Cyan
Write-Host "Desinstallation terminee." -ForegroundColor Cyan
