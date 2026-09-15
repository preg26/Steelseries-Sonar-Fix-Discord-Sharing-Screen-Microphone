@echo off
setlocal

:: Si le script n'est pas encore lance en administrateur, demande l'elevation UAC.
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell.exe -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -Verb RunAs -ArgumentList '/c ""%~f0"" elevated'"
    exit /b
)

cd /d "%~dp0"

if not exist "%~dp0Desinstaller_Tache_MuteDiscordSonar_SansFenetre.ps1" (
    echo.
    echo ERREUR : Desinstaller_Tache_MuteDiscordSonar_SansFenetre.ps1 introuvable.
    echo Les fichiers doivent etre places dans le meme dossier.
    echo.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Desinstaller_Tache_MuteDiscordSonar_SansFenetre.ps1"

echo.
pause
