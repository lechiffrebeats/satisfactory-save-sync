. "$PSScriptRoot/../config.ps1"

$repoSave="$PSScriptRoot/../save/world.sav"

$target="$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

$timestamp=Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$newfile="$target/world_$PCNAME_$timestamp.sav"

Copy-Item $repoSave $newfile -Force