# Discord + SteelSeries Sonar - Screen Share Microphone Echo Fix

A lightweight Windows fix for a **Discord + SteelSeries Sonar** issue where your own microphone can be heard a second time through your full-screen share.

When the issue occurs, people in your Discord call hear your voice normally through Discord **and again through the screen share**, creating an echo / double voice.

This project automates the known Windows volume mixer workaround and automatically reapplies it whenever Discord recreates its audio session.

### Key features

- Fixes the microphone echo / double voice during Discord full-screen sharing
- Automatically monitors and mutes the problematic Discord audio session
- Does **not** globally mute your microphone
- Your microphone remains available in games and other applications
- Automatically starts with Windows
- Runs silently in the background
- No third-party audio software required
- Uses native Windows tools and PowerShell
- Includes a clean installer and uninstaller

## Documentation

Choose your language:

### 🇬🇧 English

➡️ **[English documentation](README-EN.md)**

Installation, manual workaround test, verification and uninstallation instructions.

### 🇫🇷 Français

➡️ **[Documentation française](README-FR.md)**

Installation, test manuel du correctif, vérification et désinstallation.

---

## Quick explanation

The manual workaround consists of opening the classic Windows volume mixer:

```text
Windows + R → sndvol
```

Then selecting:

```text
SteelSeries Sonar - Microphone
```

and muting **Discord only** inside that mixer.

Unfortunately, Discord can recreate its audio session, causing Windows to lose this mute.

**This project automatically keeps that specific Discord session muted.**

For complete instructions and a manual test before installing anything, use one of the documentation links above.

---

## Compatibility

Designed for:

- Windows
- Discord Desktop
- SteelSeries GG / Sonar

---

## Open source

The project consists of readable PowerShell, Batch and Windows Script files.

You can inspect every script before running it. No external executable or third-party dependency is required.