DISCORD + STEELSERIES SONAR

Automatic Discord mute on "SteelSeries Sonar - Microphone"


============================================================

INSTALLATION

============================================================


1. Make sure SteelSeries Sonar is installed and enabled.


2. Close Discord.


3. Double-click:

   1 - Start setup.bat


4. Windows will ask for administrator permission.

   Click "Yes".


5. Wait for the message confirming that the installation is complete.


6. You can close the window.


7. Start Discord normally.


That's it.


The script now runs automatically in the background.

It will also start automatically whenever Windows starts.



============================================================

CHECK THAT IT WORKS

============================================================


1. Start Discord.


2. Press:

   Windows + R


3. Type:

   sndvol


4. Press Enter.


5. Select the device:

   SteelSeries Sonar - Microphone


6. Discord should appear MUTED in this mixer.


The mute may take up to around 5 seconds after Discord starts
or restarts.



============================================================

IMPORTANT

============================================================


This script does NOT mute your microphone globally.


It only mutes Discord's audio session under:

   SteelSeries Sonar - Microphone


You can therefore still use your microphone in a game
or any other application.



============================================================

UNINSTALLATION

============================================================


1. Double-click:

   2 - Uninstall.bat


2. Accept the Windows administrator permission prompt.


3. Wait for the confirmation.


4. Close the window.


The automatic startup task and background watcher will then be removed.



============================================================

FILES

============================================================


1 - Start setup.bat

   -> Easy installer. This is the file you should use.


2 - Uninstall.bat

   -> Easy uninstaller.


MuteDiscordSonar.ps1

   -> Main script. Do not run it manually.


Installer_Tache_MuteDiscordSonar_SansFenetre.ps1

   -> Installs the Windows scheduled task.


Desinstaller_Tache_MuteDiscordSonar_SansFenetre.ps1

   -> Removes the Windows scheduled task.


MuteDiscordSonarHidden.vbs

   -> Allows the script to run without a visible terminal window.


UnmuteDiscordCapture.ps1

   -> Repair script only.

      Not needed for normal use.



============================================================

DO NOT

============================================================


Do not delete or move individual files after installation.


To remove the setup properly, always use:

   2 - Uninstall.bat