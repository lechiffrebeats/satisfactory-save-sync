. "$PSScriptRoot/../config.ps1"

$saveFolder="$env:LOCALAPPDATA\FactoryGame\Saved\SaveGames\$SteamID"

$latest=Get-ChildItem $saveFolder *.sav | Sort-Object LastWriteTime -Descending | Select-Object -First 1

Copy-Item $latest.FullName "$PSScriptRoot/../save/world.sav" -Force