param([string]$Mode = "Modded")

# --- PATH & NAME SETUP ---
$systemPath  = $PSScriptRoot
$repoPath    = "$systemPath\.."
$repoName    = (Get-Item $repoPath).Name  # Dynamically gets the repo folder name
$configPath  = "$repoPath\config.ps1"
$lockFile    = "$systemPath\lock.txt"
$saveDir     = "$systemPath\save"

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

# 2. Find Files in system/save (Handles dynamic naming/timestamps)
$repoSaveFile = Get-ChildItem "$saveDir\*.sav" | Select-Object -First 1
$modpackFile  = Get-ChildItem "$saveDir\*.smmprofile" | Select-Object -First 1

if (-not $repoSaveFile) {
    Write-Host "🛑 ERROR: No .sav file found in system/save/!" -ForegroundColor Red
    Pause; exit
}

$saveFileName = $repoSaveFile.Name
$saveFolder   = "$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"
$targetFile   = "$saveFolder\$saveFileName"

# 3. Sync from Cloud
Write-Host "🛰️ Connecting to the grid: $repoName..." -ForegroundColor Cyan
$pullOutput = git -C $repoPath pull origin main | Out-String
Write-Host $pullOutput

# 4. Check Lobby Lock
$activePlayer = Get-Content $lockFile -Raw
if (![string]::IsNullOrWhiteSpace($activePlayer)) {
    Write-Host "`n🛑 LOBBY LOCKED! $activePlayer is currently in the world." -ForegroundColor Red
    Pause; exit
}

# 5. Lock & Download
Write-Host "🔓 World is free! Locking for $PCNAME..." -ForegroundColor Green
Set-Content -Path $lockFile -Value $PCNAME
git -C $repoPath add system/lock.txt
git -C $repoPath commit -m "🔒 LOCKED: $PCNAME" --quiet
git -C $repoPath push origin main --quiet

Write-Host "📥 Syncing save to game folder..." -ForegroundColor Cyan
if (-not (Test-Path $saveFolder)) { New-Item -Path $saveFolder -ItemType Directory | Out-Null }
Copy-Item $repoSaveFile.FullName $targetFile -Force 
Write-Host "✅ $saveFileName is ready." -ForegroundColor Green

# 6. Modpack Update Warning
if ($Mode -eq "Modded" -and $pullOutput -match ".smmprofile") {
    Write-Host "`n🚨 NEW MODPACK DETECTED in system/save/!" -ForegroundColor Yellow
    Write-Host "Please import the latest .smmprofile in the Mod Manager." -ForegroundColor White
    Pause
}

# 7. Launch Game
if ($Mode -eq "Vanilla") {
    Write-Host "🚀 Launching Vanilla..." -ForegroundColor Magenta
    Start-Process "steam://rungameid/526870"
} else {
    Write-Host "🚀 Launching Mod Manager..." -ForegroundColor Magenta
    $smmPath = "$env:LOCALAPPDATA\Programs\Satisfactory Mod Manager\Satisfactory Mod Manager.exe"
    if (Test-Path $smmPath) { Start-Process $smmPath }
}

# 8. Monitor Session
Write-Host "🎮 Monitoring $saveFileName... Do not close!" -ForegroundColor Yellow
while (-not (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 3 }
while (Get-Process -Name "FactoryGame*" -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 5 }

# 9. Upload & Unlock
Write-Host "📤 Game closed! Syncing back to cloud..." -ForegroundColor Cyan

# Copy the save back from Satisfactory to the Git folder
if (Test-Path $targetFile) {
    Copy-Item $targetFile $repoSaveFile.FullName -Force
}

Clear-Content -Path $lockFile

# Force Git to track everything in the save folder (fixes the "untracked" issue)
git -C $repoPath add "system/save/*"
git -C $repoPath add "system/lock.txt"

# Commit & Push
$commitMsg = "🔓 UNLOCKED: $PCNAME saved $saveFileName"
$status = git -C $repoPath status --porcelain
if ($status -match ".smmprofile") { $commitMsg += " 📦 (+ MODS)" }

git -C $repoPath commit -m "$commitMsg" --quiet
git -C $repoPath push origin main --quiet

Write-Host "✅ Sync complete! Server is free." -ForegroundColor Green
Pause