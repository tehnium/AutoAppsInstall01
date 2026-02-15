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

irm https://github.com/tehnium/AutoAppsInstall01/releases/latest/download/AutoAppsInstall02.ps1 | iex


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

List all pkgs:
-------------------------------------------------------
ynt:
Adobe Acrobat Reader DC,
Chrome,
Firefox,
Brave,
Betterbird,
NOI AI,
jre8x86,
jre8x64,
7-Zip,
WinRAR,
VC Redist x64 2015+,
VC Redist x86 2015+,
VC Redist x64 2013,
VC Redist x86 2013,
VC Redist x64 2012,
VC Redist x86 2012,
VC Redist x64 2010,
VC Redist x86 2010,
VC Redist x64 2008,
VC Redist x86 2008,
VC Redist x64 2005,
VC Redist x86 2005,
VFPRuntimeInstallers,
Total File Commander Pro,
Screen Recorder,
NAPS2,
Doc Scan PDF Scanner,
CapCut,
KeePassXC,
Telegram Desktop,
Signal Private Messenger (Desktop),
VLC,
K-Lite Codecs,
LibreOffice,
Google Drive for Desktop,
.NET Desktop Runtime 10,
.NET Desktop Runtime 10 x64,
 ASP.NET Core Runtime 10,
 ASP.NET Core Runtime 10 x64,
XnView,
Inkscape,
ShareX,
Revo Uninstaller,
WinDirStat,

develop:
Python x64 3,
FileZilla,
Notepad++,
WinSCP,
PuTTY,
WinMerge,
ADB tools,
scrcpy,
Visual Studio Code,
Cursor,

O365AppsBasicRetail

0-no,

1-iyhl_en_us,

2-iyhl_en_us_x64,

3-iyhl_en_ro,

4-iyhl_ro_x64,


remote:
UltraVNC

opt
Blender,
HandBrake,

----------------------------------------------------------------------------

Notes
Some installers may still show UI depending on vendor packaging.

If a winget package ID changes or becomes unavailable, the script logs a warning and continues.

Check logs at %TEMP%\AutoAppsInstall01.log for troubleshooting.

After the script has finished running, check the task manager under the startup programs section and disable any programs you do not want to start with Windows.

License
MIT License (see LICENSE).
