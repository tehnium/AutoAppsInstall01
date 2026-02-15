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

powershell
irm https://raw.githubusercontent.com/tehnium/AutoAppsInstall01/main/AutoAppsInstall02.ps1 | iex
What it does
Detects OS architecture (x86 or x64) and prints/logs it.

Prompts you to select which package groups to install:

YNT (You Need This)

Develop

Optional (opt)

Remote (remote) (VNC)

Office (iyhl) (Click-to-Run bootstrapper, if you have a license)

For Office, prompts you to select:

0 = No Office

1 = en-us x86

2 = en-us x64

3 = ro-ro x86

4 = ro-ro x64

Installs silently where possible:

winget uses --silent --disable-interactivity plus agreement flags.

VFP runtimes install with /S and a response file (downloaded from VFPX/VFPRuntimeInstallers).

Noi installs via MSI (msiexec /quiet).

Skips packages already installed (based on winget list -e --id).

Logs to: %TEMP%\AutoAppsInstall01.log

Notes
Some installers may still show UI depending on vendor packaging.

If a winget package ID changes or becomes unavailable, the script logs a warning and continues.

Check logs at %TEMP%\AutoAppsInstall01.log for troubleshooting.

License
MIT License (see LICENSE).
