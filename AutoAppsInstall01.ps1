<#
.SYNOPSIS
    Installs a predefined list of applications using winget.

.DESCRIPTION
    This script installs several common desktop applications using the
    Windows Package Manager (winget). It first checks if winget is
    available and optionally tries to install it from Microsoft Store
    (App Installer) if missing.

.NOTES
    Run this script in an elevated PowerShell session (Run as Administrator).
#>

# -------------------------------
# Helper: Ensure winget is present
# -------------------------------
function Ensure-Winget {
    Write-Host "Checking for winget..." -ForegroundColor Cyan

    $wingetExists = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetExists) {
        Write-Host "winget is already installed." -ForegroundColor Green
        return $true
    }

    Write-Warning "winget is not installed. Attempting to install 'App Installer' from Microsoft Store (which provides winget)."

    # App Installer ProductId from Microsoft Store
    # See official docs and community references for this ID.
    $appInstallerId = "9NBLGGH4NNS1"  # App Installer (Microsoft Store)[web:5][web:52]

    # Try installing App Installer using msstore source
    try {
        winget install -e --id $appInstallerId --source msstore `
            --accept-source-agreements `
            --accept-package-agreements
    } catch {
        Write-Warning "Automatic App Installer / winget installation failed: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds 10

    $wingetExists = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetExists) {
        Write-Host "winget installation appears to be successful." -ForegroundColor Green
        return $true
    }

    Write-Error "winget is still not available. Please install it manually (App Installer from Microsoft Store or the official GitHub release) and run this script again."
    return $false
}

# Ensure winget exists before proceeding
if (-not (Ensure-Winget)) {
    exit 1
}

# -------------------------------
# Applications to install
# -------------------------------
$apps = @(
    @{ Name = "Adobe Acrobat Reader DC";      Id = "Adobe.Acrobat.Reader.64-bit";   Source = "winget" }
    @{ Name = "Screen Recorder";             Id = "9pjmtj0wtctz";                  Source = "msstore" }  # Screen recorder - Screen record & Screen capture
    @{ Name = "NAPS2 - Not Another PDF Scanner"; Id = "Cyanfish.NAPS2";           Source = "winget" }
    @{ Name = "Doc Scan PDF Scanner";        Id = "9pd0cd1vszng";                  Source = "msstore" }
    @{ Name = "CapCut";                      Id = "ByteDance.CapCut";              Source = "winget" }
    @{ Name = "KeePassXC";                   Id = "KeePassXCTeam.KeePassXC";       Source = "winget" }
    @{ Name = "Total File Commander Pro";    Id = "9n0kwg910ldh";                  Source = "msstore" }
    @{ Name = "Signal Private Messenger";    Id = "OpenWhisperSystems.Signal";     Source = "winget" }
    @{ Name = "WhatsApp";                    Id = "WhatsApp.WhatsApp";             Source = "winget" }
    @{ Name = "Telegram Desktop";            Id = "Telegram.TelegramDesktop";      Source = "winget" }
)

# -------------------------------
# Install loop
# -------------------------------
foreach ($app in $apps) {
    Write-Host "=== Installing $($app.Name)... ===" -ForegroundColor Cyan

    $sourceArg = ""
    if ($app.Source -and $app.Source.Trim() -ne "") {
        $sourceArg = "--source $($app.Source)"
    }

    # Check if already installed
    $existing = winget list -e --id $($app.Id) 2>$null

    if ($LASTEXITCODE -eq 0 -and $existing) {
        Write-Host "$($app.Name) is already installed, skipping." -ForegroundColor Yellow
        continue
    }

    winget install -e --id $($app.Id) $sourceArg `
        --accept-source-agreements `
        --accept-package-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Installation failed for $($app.Name) (ID: $($app.Id))."
    } else {
        Write-Host "Successfully installed $($app.Name)." -ForegroundColor Green
    }
}

Write-Host "All done. Script finished." -ForegroundColor Green

