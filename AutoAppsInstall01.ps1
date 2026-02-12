<#
.SYNOPSIS
    Installs a predefined list of applications using winget.
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
)

foreach ($app in $apps) {
    Write-Host "=== Installing $($app.Name)... ===" -ForegroundColor Cyan

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

    # Build command: winget install -e --id ID [ -s SOURCE ]
    $cmd = "winget install -e --id `"$($app.Id)`" $sourceArg --accept-source-agreements --accept-package-agreements"
    
    Invoke-Expression $cmd

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Installation failed for $($app.Name) (ID: $($app.Id))."
    } else {
        Write-Host "Successfully installed $($app.Name)." -ForegroundColor Green
    }
}

Write-Host "All done. Script finished." -ForegroundColor Green
