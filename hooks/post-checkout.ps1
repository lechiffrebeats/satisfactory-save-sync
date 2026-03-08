$configPath = "$PSScriptRoot\..\config.ps1"

if (-not (Test-Path $configPath)) {
    Write-Host "config.ps1 not found! Please duplicate config.template.ps1, rename it, and add your SteamID." -ForegroundColor Red
    exit 1
}

. $configPath

$repoSave = "$PSScriptRoot\..\save\world.sav"
$targetDir = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

if (-not (Test-Path $repoSave)) {
    Write-Host "No save file found in the repository yet." -ForegroundColor Yellow
    exit 0
}

# Create the save folder if it doesn't exist yet
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$newfile = "$targetDir\world_$PCNAME_$timestamp.sav"

Copy-Item $repoSave $newfile -Force
Write-Host "✅ Save downloaded and copied to your Satisfactory folder: $newfile" -ForegroundColor Green