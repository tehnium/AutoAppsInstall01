# AutoAppsInstall02

A PowerShell “menu installer” that installs a curated set of Windows applications using **winget**, Microsoft Store (via winget), and a few direct download installers (MSI/EXE). It is designed for unattended / mostly silent setup.

## Requirements

- Windows 10/11
- PowerShell 5.1+
- Run PowerShell **as Administrator**
- Internet access
- **winget** installed (via Microsoft “App Installer”)

> Microsoft Store installs require Store availability and may be blocked by policy.

## Usage (latest release)

If you publish `AutoAppsInstall02.ps1` as a **Release asset**, you can run the latest release directly like this:

```powershell
irm https://github.com/tehnium/AutoAppsInstall01/releases/latest/download/AutoAppsInstall02.ps1 | iex
