# ============================================================
# INSTALLATION - Mute Discord / SteelSeries Sonar
# Version sans fenetre PowerShell visible
# ============================================================

$ErrorActionPreference = "Stop"

$TaskName    = "Mute Discord - Sonar Microphone"
$WatcherPath = Join-Path $PSScriptRoot "MuteDiscordSonar.ps1"
$LauncherPath = Join-Path $PSScriptRoot "MuteDiscordSonarHidden.vbs"

Write-Host ""
Write-Host "=== Installation Discord / Sonar Watcher ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $WatcherPath)) {
    Write-Host "[ERREUR] MuteDiscordSonar.ps1 est introuvable :" -ForegroundColor Red
    Write-Host "         $WatcherPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Place les deux fichiers PS1 dans le meme dossier." -ForegroundColor Yellow
    exit 1
}

# Cree un petit lanceur Windows natif.
# WScript lance PowerShell avec le parametre 0 = fenetre totalement cachee.
$escapedWatcher = $WatcherPath.Replace('"', '""')
$vbs = @"
Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ""$escapedWatcher""", 0, False
"@

Set-Content -LiteralPath $LauncherPath -Value $vbs -Encoding ASCII

Write-Host "[OK] Lanceur invisible cree :" -ForegroundColor Green
Write-Host "     $LauncherPath"

# Supprime proprement une ancienne definition de la tache.
$oldTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($oldTask) {
    Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# La tache lance WScript, qui demarre le watcher sans console visible.
$Action = New-ScheduledTaskAction `
    -Execute "$env:WINDIR\System32\wscript.exe" `
    -Argument "`"$LauncherPath`""

$Trigger = New-ScheduledTaskTrigger -AtLogOn

$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Description "Lance le watcher Discord / SteelSeries Sonar sans fenetre visible." `
    -Force | Out-Null

Write-Host "[OK] Tache planifiee creee avec declencheur Logon." -ForegroundColor Green

# Demarre tout de suite pour eviter d'avoir a redemarrer Windows.
Start-ScheduledTask -TaskName $TaskName
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "=== Verification ===" -ForegroundColor Cyan

$task = Get-ScheduledTask -TaskName $TaskName
Write-Host ("Tache       : " + $task.TaskName)
Write-Host ("Declencheur : " + $task.Triggers.CimClass.CimClassName)
Write-Host ("Executable  : " + $task.Actions.Execute)
Write-Host ("Arguments   : " + $task.Actions.Arguments)

# Avec WScript, la tache peut revenir a Ready apres avoir lance le watcher.
# C'est NORMAL : le watcher PowerShell continue dans son propre processus cache.
$watcherEscaped = [regex]::Escape($WatcherPath)
$process = Get-CimInstance Win32_Process |
    Where-Object {
        $_.Name -eq "powershell.exe" -and
        $_.CommandLine -match $watcherEscaped
    }

Write-Host ""
if ($process) {
    Write-Host "[OK] Watcher PowerShell actif et cache. PID : $($process.ProcessId -join ', ')" -ForegroundColor Green
} else {
    Write-Host "[ATTENTION] Le processus watcher n'a pas ete detecte." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "IMPORTANT : avec cette version, la tache peut afficher READY." -ForegroundColor Yellow
Write-Host "C'est normal : WScript termine apres avoir lance le watcher cache." -ForegroundColor Yellow
Write-Host ""
Write-Host "Installation terminee." -ForegroundColor Cyan
