param([string]$Mode = "Modded")

# --- PATH & NAME SETUP ---
$systemPath = $PSScriptRoot
$repoPath   = "$systemPath\.."
$repoName   = (Get-Item $repoPath).Name  # Automatically gets the folder name
$configPath = "$repoPath\config.ps1"
$lockFile   = "$systemPath\lock.txt"
$repoSave   = "$systemPath\save\$repoName.sav"
$modpackFile = "$repoPath\modpack.smmprofile"

# 1. Check Config
if (-not (Test-Path $configPath)) {
    Write-Host "🛑 ERROR: config.ps1 not found in the main folder!" -ForegroundColor Red
    Pause; exit
}
. $configPath

if ([string]::IsNullOrWhiteSpace($PCNAME) -or [string]::IsNullOrWhiteSpace($SteamID)) {
    Write-Host "🛑 ERROR: Your config.ps1 is empty! Add your SteamID and PCNAME." -ForegroundColor Red
    Pause; exit
}

$saveFolder = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

# 2. Sync from Cloud
Write-Host "🛰️ Connecting to the grid ($repoName)..." -ForegroundColor Cyan
$pullOutput = git -C $repoPath pull origin main | Out-String
Write-Host $pullOutput

# 3. Check Lobby Lock
$activePlayer = Get-Content $lockFile -Raw
if (![string]::IsNullOrWhiteSpace($activePlayer)) {
    Write-Host "`n==========================================================" -ForegroundColor Red
    Write-Host " 🛑 LOBBY LOCKED! DO NOT PLAY!" -ForegroundColor Red
    Write-Host " $activePlayer is currently in the world." -ForegroundColor Yellow
    Write-Host "==========================================================`n" -ForegroundColor Red
    Pause; exit
}

# 4. Lock & Download
Write-Host "🔓 World is free! Locking for $PCNAME..." -ForegroundColor Green
Set-Content -Path $lockFile -Value $PCNAME
git -C $repoPath add system/lock.txt
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME is playing" --quiet
git -C $repoPath push origin main --quiet

Write-Host "📥 Downloading $repoName.sav..." -ForegroundColor Cyan
$targetFile = "$saveFolder\$repoName.sav"
if (Test-Path $repoSave) { 
    Copy-Item $repoSave $targetFile -Force 
    # Local timestamped backup
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Copy-Item $repoSave "$saveFolder\$repoName`_$PCNAME`_$timestamp.sav" -Force 
}

# 5. Modpack Update Warning (Modded Only)
if ($Mode -eq "Modded" -and $pullOutput -match "modpack.smmprofile") {
    Write-Host "`n==========================================================" -ForegroundColor Red
    Write-Host " 🚨 NEW MODPACK DETECTED! 🚨" -ForegroundColor Yellow
    Write-Host " 1. Open SMM -> Click IMPORT." -ForegroundColor White
    Write-Host " 2. Select 'modpack.smmprofile' from the folder." -ForegroundColor White
    Write-Host "==========================================================`n" -ForegroundColor Red
    Write-Host "Press ENTER to continue to Mod Manager..." -ForegroundColor Cyan
    Pause
}

# 6. Launch
if ($Mode -eq "Vanilla") {
    Write-Host "🚀 Launching Vanilla (Steam)..." -ForegroundColor Magenta
    Start-Process "steam://rungameid/526870"
} else {
    Write-Host "🚀 Launching Mod Manager..." -ForegroundColor Magenta
    $smmPath = "$env:LOCALAPPDATA\Programs\Satisfactory Mod Manager\Satisfactory Mod Manager.exe"
    if (Test-Path $smmPath) { Start-Process $smmPath } else { Write-Host "SMM not found! Open it manually." -ForegroundColor Yellow }
}

# 7. Monitor Session
Write-Host "🎮 Game detected! Monitoring... (DO NOT CLOSE THIS WINDOW)" -ForegroundColor Yellow
while (-not (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 3 }
while (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }

# 8. Upload & Unlock
Write-Host "📤 Game closed! Syncing $repoName.sav to cloud..." -ForegroundColor Cyan
$latestSave = Get-ChildItem $saveFolder\$repoName*.sav | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestSave) { Copy-Item $latestSave.FullName $repoSave -Force }

Clear-Content -Path $lockFile
git -C $repoPath add "system/save/$repoName.sav" system/lock.txt

# Create custom commit message
$commitMsg = "🔓 UNLOCKED: $PCNAME saved the world"
if ($Mode -eq "Modded" -and (Test-Path $modpackFile)) {
    if (![string]::IsNullOrWhiteSpace((git -C $repoPath status --porcelain modpack.smmprofile))) {
        git -C $repoPath add modpack.smmprofile
        $commitMsg += " 📦 (+ MODPACK UPDATED)"
    }
}

git -C $repoPath commit -m "$commitMsg" --quiet
git -C $repoPath push origin main --quiet

Write-Host "✅ Sync complete! Server is free. Safe to close." -ForegroundColor Green
Pause