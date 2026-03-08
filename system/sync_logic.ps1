$repoPath = "$PSScriptRoot\.."
$configPath = "$repoPath\config.ps1"
$lockFile = "$PSScriptRoot\lock.txt"
$repoSave = "$PSScriptRoot\save\world.sav"
$modpackFile = "$repoPath\modpack.smm"

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
git -C $repoPath pull origin main --quiet

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
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME is playing" --quiet
git -C $repoPath push origin main --quiet

# 4. Download Save
Write-Host "Downloading the latest save..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$targetFile = "$saveFolder\world_$PCNAME_$timestamp.sav"
if (Test-Path $repoSave) { Copy-Item $repoSave $targetFile -Force }

# 5. Modpack Check
if (Test-Path $modpackFile) {
    Write-Host ""
    Write-Host "📦 MODPACK DETECTED!" -ForegroundColor Yellow
    Write-Host " If mods were updated, please Import 'modpack.smm' inside SMM before playing." -ForegroundColor White
    Write-Host ""
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

# Stage the save, the lock, and the modpack (if it exists)
git -C $repoPath add system/save/world.sav system/lock.txt
if (Test-Path $modpackFile) {
    git -C $repoPath add modpack.smm
}

git -C $repoPath commit -m "🔓 UNLOCKED: $PCNAME saved the world" --quiet
git -C $repoPath push origin main --quiet

Write-Host "✅ Sync complete! Server is free for others. Safe to close." -ForegroundColor Green
Pause