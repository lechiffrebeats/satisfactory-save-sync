param([string]$Mode = "Modded")

# --- PATH & NAME SETUP ---
$systemPath = $PSScriptRoot
$repoPath   = "$systemPath\.."
$repoName   = (Get-Item $repoPath).Name  # Dynamically detects the current folder name
$configPath = "$repoPath\config.ps1"
$lockFile   = "$systemPath\lock.txt"
$saveDir    = "$systemPath\save"
$repoSave   = "$saveDir\$repoName.sav"
$modpackFile = "$repoPath\modpack.smmprofile"

# Ensure save directory exists locally for the push
if (-not (Test-Path $saveDir)) { New-Item -Path $saveDir -ItemType Directory | Out-Null }

# 1. Check Config
if (-not (Test-Path $configPath)) {
    Write-Host "🛑 ERROR: config.ps1 not found!" -ForegroundColor Red
    Pause; exit
}
. $configPath

if ([string]::IsNullOrWhiteSpace($PCNAME) -or [string]::IsNullOrWhiteSpace($SteamID)) {
    Write-Host "🛑 ERROR: config.ps1 is incomplete!" -ForegroundColor Red
    Pause; exit
}

$saveFolder = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

# 2. Sync from Cloud
Write-Host "🛰️ Connecting to the grid: $repoName..." -ForegroundColor Cyan
$pullOutput = git -C $repoPath pull origin main | Out-String
Write-Host $pullOutput

# 3. Check Lobby Lock
$activePlayer = Get-Content $lockFile -Raw
if (![string]::IsNullOrWhiteSpace($activePlayer)) {
    Write-Host "`n🛑 LOBBY LOCKED! $activePlayer is currently in the world." -ForegroundColor Red
    Pause; exit
}

# 4. Lock & Download
Write-Host "🔓 World is free! Locking for $PCNAME..." -ForegroundColor Green
Set-Content -Path $lockFile -Value $PCNAME
git -C $repoPath add system/lock.txt
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME" --quiet
git -C $repoPath push origin main --quiet

Write-Host "📥 Downloading $repoName.sav..." -ForegroundColor Cyan
$targetFile = "$saveFolder\$repoName.sav"
if (Test-Path $repoSave) { 
    Copy-Item $repoSave $targetFile -Force 
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Copy-Item $repoSave "$saveFolder\$repoName`_$PCNAME`_$timestamp.sav" -Force 
}

# 5. Modpack Update Warning
if ($Mode -eq "Modded" -and $pullOutput -match "modpack.smmprofile") {
    Write-Host "`n🚨 NEW MODPACK DETECTED! Import 'modpack.smmprofile' now." -ForegroundColor Yellow
    Pause
}

# 6. Launch Game
if ($Mode -eq "Vanilla") {
    Write-Host "🚀 Launching Vanilla..." -ForegroundColor Magenta
    Start-Process "steam://rungameid/526870"
} else {
    Write-Host "🚀 Launching Mod Manager..." -ForegroundColor Magenta
    $smmPath = "$env:LOCALAPPDATA\Programs\Satisfactory Mod Manager\Satisfactory Mod Manager.exe"
    if (Test-Path $smmPath) { Start-Process $smmPath }
}

# 7. Monitor Session
Write-Host "🎮 Monitoring $repoName... Do not close!" -ForegroundColor Yellow
while (-not (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 3 }
while (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }

# 8. Upload & Unlock
Write-Host "📤 Game closed! Syncing to cloud..." -ForegroundColor Cyan
$latestSave = Get-ChildItem "$saveFolder\$repoName*.sav" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestSave) { Copy-Item $latestSave.FullName $repoSave -Force }

Clear-Content -Path $lockFile

# Force stage the specific save file and lock
git -C $repoPath add "system/save/$repoName.sav"
git -C $repoPath add "system/lock.txt"

# Commit & Push
$commitMsg = "🔓 UNLOCKED: $PCNAME saved $repoName"
if ($Mode -eq "Modded" -and (Test-Path $modpackFile)) {
    git -C $repoPath add modpack.smmprofile
    $commitMsg += " 📦 (+ MODS)"
}

git -C $repoPath commit -m "$commitMsg" --quiet
git -C $repoPath push origin main --quiet

Write-Host "✅ Sync complete!" -ForegroundColor Green
Pause