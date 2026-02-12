# AutoAppsInstall01

This repository contains a PowerShell script that installs a predefined list of desktop applications using the Windows Package Manager (**winget**).

The script is intended for quick setup of a fresh Windows machine with common productivity and communication tools.

## Applications installed

The script currently installs:

- Adobe Acrobat Reader DC
- Screen Recorder (Microsoft Store)
- NAPS2 - Not Another PDF Scanner
- Doc Scan PDF Scanner (Microsoft Store)
- CapCut
- KeePassXC
- Total File Commander Pro (Microsoft Store)
- Signal Private Messenger (Desktop)
- WhatsApp (Desktop)
- Telegram Desktop

> Note: Availability of some applications may depend on your region, Windows version, or Microsoft Store configuration.

## Requirements

- Windows 10 or Windows 11.
- PowerShell running **as Administrator**.
- Internet connectivity.
- Windows Package Manager **winget**:
  - The script tries to detect `winget`.
  - If it is missing, it attempts to install **App Installer** from the Microsoft Store, which provides `winget`.
  - If automatic installation fails, you must install winget manually and then run the script again.[web:1][web:5][web:52]

For official information about winget, see the Microsoft documentation.[web:1][web:52]

## Usage

You can run the script directly with `Invoke-RestMethod` and `Invoke-Expression`:

```powershell
irm https://raw.githubusercontent.com/tehnium/AutoAppsInstall01/main/AutoAppsInstall01.ps1 | iex
