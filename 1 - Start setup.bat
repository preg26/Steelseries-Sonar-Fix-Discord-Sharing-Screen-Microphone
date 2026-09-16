@echo off
setlocal

:: Vérifie les droits administrateur
net session >nul 2>&1

if %errorlevel% neq 0 (
    echo Demande des droits administrateur...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Nous sommes maintenant administrateur
cd /d "%~dp0"

echo.
echo === Installation Discord / Sonar ===
echo.

if not exist "%~dp0Installer_Tache_MuteDiscordSonar_SansFenetre.ps1" (
    echo ERREUR : Installer_Tache_MuteDiscordSonar_SansFenetre.ps1 introuvable.
    echo.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Installer_Tache_MuteDiscordSonar_SansFenetre.ps1"

echo.
echo === Fin de l'installation ===
pause