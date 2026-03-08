$repoPath = $PSScriptRoot
$configPath = "$repoPath\config.ps1"
$lockFile = "$repoPath\lock.txt"
$repoSave = "$repoPath\save\world.sav"

. $configPath
$saveFolder = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

Write-Host "Syncing with the server..." -ForegroundColor Cyan
git -C $repoPath pull origin main

$activePlayer = Get-Content $lockFile -Raw
if (![string]::IsNullOrWhiteSpace($activePlayer)) {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " STOP! DO NOT PLAY!" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " $activePlayer is currently hosting the world right now!" -ForegroundColor Yellow
    Write-Host " If you launch a local save, you will split the timeline." -ForegroundColor Yellow
    Write-Host " Open Satisfactory normally and join their session." -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host ""
    exit
}

Write-Host "World is free! Locking the save for $PCNAME..." -ForegroundColor Green
Set-Content -Path $lockFile -Value $PCNAME
git -C $repoPath add $lockFile
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME is playing"
git -C $repoPath push origin main

Write-Host "Downloading the latest save..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$targetFile = "$saveFolder\world_$PCNAME_$timestamp.sav"
Copy-Item $repoSave $targetFile -Force

Write-Host "Starting Satisfactory..." -ForegroundColor Magenta
# Launches Satisfactory via Steam (Epic users: open the game manually)
Start-Process "steam://rungameid/526870" 

Write-Host "Monitoring game... (DO NOT CLOSE THIS WINDOW)" -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Script waits here while the game is running
while (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 5
}

Write-Host "Game closed! Uploading your new save..." -ForegroundColor Cyan
$latestSave = Get-ChildItem $saveFolder\*.sav | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Copy-Item $latestSave.FullName $repoSave -Force

Clear-Content -Path $lockFile
git -C $repoPath add $repoSave $lockFile
git -C $repoPath commit -m "🔓 UNLOCKED: $PCNAME saved the world"
git -C $repoPath push origin main

Write-Host "Sync complete! Safe to close." -ForegroundColor Green