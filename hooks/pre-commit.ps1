$configPath = "$PSScriptRoot\..\config.ps1"

if (-not (Test-Path $configPath)) {
    Write-Host "config.ps1 not found! Please configure it first." -ForegroundColor Red
    exit 1
}

. $configPath

$saveFolder = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"
$repoSave = "$PSScriptRoot\..\save\world.sav"
$repoSaveDir = "$PSScriptRoot\..\save"

# Create the save folder in the repo if it doesn't exist
if (-not (Test-Path $repoSaveDir)) {
    New-Item -ItemType Directory -Path $repoSaveDir | Out-Null
}

# Find the absolute newest save file in the Satisfactory folder
$latest = Get-ChildItem -Path "$saveFolder\*.sav" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latest) {
    Copy-Item $latest.FullName $repoSave -Force
    
    # Tell Git to include the newly updated save file in this commit
    git add "save/world.sav"
    Write-Host "✅ Latest save ($($latest.Name)) copied to repo and ready to push." -ForegroundColor Green
} else {
    Write-Host "No local saves found in $saveFolder." -ForegroundColor Yellow
}