<#
.SYNOPSIS
    Installs a predefined list of applications using winget + direct download.

.DESCRIPTION
    Installs productivity and communication apps using winget (primary)
    or direct download (Noi). Skips already installed apps.

.NOTES
    Run as Administrator. Requires winget (App Installer from Microsoft Store).
#>

function Ensure-Winget {
    Write-Host "Checking for winget..." -ForegroundColor Cyan

    $wingetExists = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetExists) {
        Write-Host "winget is already installed." -ForegroundColor Green
        return $true
    }

    Write-Warning "winget is not installed. Please install 'App Installer' from Microsoft Store manually."
    Write-Error "winget is required. Install it and run again."
    return $false
}

if (-not (Ensure-Winget)) {
    exit 1
}

$apps = @(
    @{ Name = "Adobe Acrobat Reader DC";      Id = "Adobe.Acrobat.Reader.64-bit" }
    @{ Name = "Screen Recorder";             Id = "9pjmtj0wtctz";                  Source = "msstore" }
    @{ Name = "NAPS2 - Not Another PDF Scanner"; Id = "Cyanfish.NAPS2" }
    @{ Name = "Doc Scan PDF Scanner";        Id = "9pd0cd1vszng";                  Source = "msstore" }
    @{ Name = "CapCut";                      Id = "ByteDance.CapCut" }
    @{ Name = "KeePassXC";                   Id = "KeePassXCTeam.KeePassXC" }
    @{ Name = "Total File Commander Pro";    Id = "9n0kwg910ldh";                  Source = "msstore" }
    @{ Name = "Signal Private Messenger";    Id = "OpenWhisperSystems.Signal" }
    @{ Name = "WhatsApp";                    Id = "WhatsApp.WhatsApp" }
    @{ Name = "Telegram Desktop";            Id = "Telegram.TelegramDesktop" }
    @{ Name = "Betterbird";                  Id = "Betterbird.Betterbird" }
    # Noi - direct MSI download
    @{ Name = "Noi";                         DirectMSI = "https://github.com/lencx/Noi/releases/download/v1.1.0/Noi.msi" }
)

foreach ($app in $apps) {
    Write-Host "=== Installing $($app.Name)... ===" -ForegroundColor Cyan

    # Direct MSI install (Noi)
    if ($app.DirectMSI) {
        $msiPath = "$env:TEMP\Noi.msi"
        
        # Check if already installed (rough check via registry)
        $installed = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*Noi*" }
        if ($installed) {
            Write-Host "Noi is already installed, skipping." -ForegroundColor Yellow
            continue
        }

        Write-Host "Downloading Noi MSI..."
        Invoke-WebRequest -Uri $app.DirectMSI -OutFile $msiPath
        
        Write-Host "Installing Noi..."
        Start-Process "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait
        
        Remove-Item $msiPath -Force
        Write-Host "Successfully installed $($app.Name)." -ForegroundColor Green
        continue
    }

    # Winget apps
    $sourceArg = ""
    if ($app.Source -and $app.Source.Trim() -ne "") {
        $sourceArg = "-s `"$($app.Source)`""
    }

    # Check if already installed
    $existing = winget list -e --id $($app.Id) 2>$null
    if ($LASTEXITCODE -eq 0 -and $existing) {
        Write-Host "$($app.Name) is already installed, skipping." -ForegroundColor Yellow
        continue
    }

    # Build and execute winget command
    $cmd = "winget install -e --id `"$($app.Id)`" $sourceArg --accept-source-agreements --accept-package-agreements"
    
    Invoke-Expression $cmd

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Installation failed for $($app.Name) (ID: $($app.Id))."
    } else {
        Write-Host "Successfully installed $($app.Name)." -ForegroundColor Green
    }
}

Write-Host "`nAll done. Script finished." -ForegroundColor Green
