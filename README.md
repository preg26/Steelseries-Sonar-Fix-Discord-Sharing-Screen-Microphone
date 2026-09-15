DISCORD + STEELSERIES SONAR

Mute automatique de Discord sur "SteelSeries Sonar - Microphone"



============================================================

INSTALLATION

============================================================



1\. Vérifiez que SteelSeries Sonar est installé et activé.



2\. Fermez Discord.



3\. Double-cliquez sur :



&#x20;  1 - Start setup.bat



4\. Windows demande une autorisation administrateur.

&#x20;  Cliquez sur "Oui".



5\. Attendez le message confirmant que l'installation est terminée.



6\. Vous pouvez fermer la fenêtre.



7\. Lancez Discord normalement.



C'est terminé.



Le script fonctionne automatiquement en arrière-plan.

Il sera relancé automatiquement à chaque démarrage de Windows.





============================================================

VÉRIFIER QUE ÇA FONCTIONNE

============================================================



1\. Lancez Discord.



2\. Appuyez sur :



&#x20;  Windows + R



3\. Tapez :



&#x20;  sndvol



4\. Appuyez sur Entrée.



5\. Sélectionnez le périphérique :



&#x20;  SteelSeries Sonar - Microphone



6\. Discord doit apparaître en MUET dans ce mélangeur.



Le mute peut prendre jusqu'à environ 5 secondes après le lancement

ou le redémarrage de Discord.





============================================================

IMPORTANT

============================================================



Ce script ne mute PAS votre microphone globalement.



Il mute uniquement la session audio de Discord présente dans :



&#x20;  SteelSeries Sonar - Microphone



Vous pouvez donc toujours utiliser votre microphone dans un jeu

ou une autre application.





============================================================

DÉSINSTALLATION

============================================================



1\. Double-cliquez sur :



&#x20;  2 - Uninstall.bat



2\. Acceptez la demande administrateur Windows.



3\. Attendez la confirmation.



4\. Fermez la fenêtre.



Le lancement automatique et le watcher sont alors supprimés.





============================================================

FICHIERS

============================================================



1 - Start setup.bat

&#x20;  -> Installation facile. C'est celui à utiliser.



2 - Uninstall.bat

&#x20;  -> Désinstallation facile.



MuteDiscordSonar.ps1

&#x20;  -> Script principal. Ne pas lancer manuellement.



Installer\_Tache\_MuteDiscordSonar\_SansFenetre.ps1

&#x20;  -> Installation de la tâche Windows.



Desinstaller\_Tache\_MuteDiscordSonar\_SansFenetre.ps1

&#x20;  -> Suppression de la tâche Windows.



MuteDiscordSonarHidden.vbs

&#x20;  -> Permet au script de fonctionner sans fenêtre visible.



UnmuteDiscordCapture.ps1

&#x20;  -> Script de réparation uniquement.

&#x20;     Inutile pour l'utilisation normale.





============================================================

NE PAS FAIRE

============================================================



Ne supprimez ou ne déplacez pas individuellement les fichiers

après l'installation.



Pour supprimer proprement le système, utilisez toujours :



&#x20;  2 - Uninstall.bat

