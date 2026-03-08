# --- PATH SETUP ---
$systemPath = $PSScriptRoot
$repoPath = "$systemPath\.."
$configPath = "$repoPath\config.ps1"
$lockFile = "$systemPath\lock.txt"
$repoSave = "$systemPath\save\world.sav"
$modpackFile = "$repoPath\modpack.smmprofile"

# 1. Check Config
if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: config.ps1 not found in the main folder!" -ForegroundColor Red
    Pause
    exit
}
. $configPath

if ([string]::IsNullOrWhiteSpace($PCNAME) -or [string]::IsNullOrWhiteSpace($SteamID)) {
    Write-Host "ERROR: Your config.ps1 is empty! Please open it and add your SteamID and PCNAME." -ForegroundColor Red
    Pause
    exit
}

$saveFolder = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

# 2. Check Server Status
Write-Host "Checking server status..." -ForegroundColor Cyan

# We capture the output of the pull to see what changed!
$pullOutput = git -C $repoPath pull origin main | Out-String
Write-Host $pullOutput

$activePlayer = Get-Content $lockFile -Raw
if (![string]::IsNullOrWhiteSpace($activePlayer)) {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " 🛑 STOP! DO NOT PLAY!" -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " $activePlayer is currently playing and hasn't pushed yet!" -ForegroundColor Yellow
    Write-Host " Contact $activePlayer so they can finish syncing." -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host ""
    Pause
    exit
}

# 3. Lock the World
Write-Host "World is free! Locking the save for $PCNAME..." -ForegroundColor Green
Set-Content -Path $lockFile -Value $PCNAME
git -C $repoPath add system/lock.txt
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME is playing"
git -C $repoPath push origin main

# 4. Download Save
Write-Host "Downloading the latest save..." -ForegroundColor Cyan
$targetFile = "$saveFolder\world.sav"

if (Test-Path $repoSave) { 
    Copy-Item $repoSave $targetFile -Force 
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $backupFile = "$saveFolder\world_$PCNAME_$timestamp.sav"
    Copy-Item $repoSave $backupFile -Force 
}

# 5. Smart Modpack Check
if ($pullOutput -match "modpack.smmprofile") {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " 🚨 NEW MODPACK UPDATE DETECTED! 🚨" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host " A friend has changed the server mods!" -ForegroundColor White
    Write-Host " 1. Click IMPORT in the Mod Manager." -ForegroundColor Yellow
    Write-Host " 2. Select 'modpack.smmprofile' from the sync folder." -ForegroundColor Yellow
    Write-Host " 3. Wait for the download, THEN launch the game." -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press ENTER to open the Mod Manager..." -ForegroundColor Cyan
    Pause
}

# 6. Launch Mod Manager
Write-Host "Opening Satisfactory Mod Manager..." -ForegroundColor Magenta
$smmPath = "$env:LOCALAPPDATA\Programs\Satisfactory Mod Manager\Satisfactory Mod Manager.exe"

if (Test-Path $smmPath) {
    Start-Process $smmPath
} else {
    Write-Host "Could not find Mod Manager automatically. Please open it manually now!" -ForegroundColor Yellow
}

# 7. Wait for Game
Write-Host "Waiting for you to launch the game... (DO NOT CLOSE THIS WINDOW)" -ForegroundColor Yellow
while (-not (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue)) {
    Start-Sleep -Seconds 3
}

Write-Host "Game detected! Monitoring session..." -ForegroundColor Green
while (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 5
}

# 8. Upload & Unlock
Write-Host "Game closed! Uploading your new save..." -ForegroundColor Cyan
$latestSave = Get-ChildItem $saveFolder\*.sav | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestSave) { Copy-Item $latestSave.FullName $repoSave -Force }

Clear-Content -Path $lockFile

git -C $repoPath add system/save/world.sav system/lock.txt
if (Test-Path $modpackFile) {
    git -C $repoPath add modpack.smmprofile
}

git -C $repoPath commit -m "🔓 UNLOCKED: $PCNAME saved the world"
git -C $repoPath push origin main

Write-Host "✅ Sync complete! Server is free for others. Safe to close." -ForegroundColor Green
Pause