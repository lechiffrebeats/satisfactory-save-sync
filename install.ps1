# Find the hidden Git hooks folder
$gitHooksDir = "$PSScriptRoot\.git\hooks"

if (-not (Test-Path $gitHooksDir)) {
    Write-Host "Error: .git folder not found. Are you running this inside a cloned repo?" -ForegroundColor Red
    Pause
    exit
}

# 1. Create the post-checkout hook (Runs AFTER clicking 'Pull')
$postCheckoutContent = @"
#!/bin/sh
exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\hooks\post-checkout.ps1"
"@
Set-Content -Path "$gitHooksDir\post-checkout" -Value $postCheckoutContent -Encoding ascii

# 2. Create the pre-commit hook (Runs BEFORE clicking 'Commit')
$preCommitContent = @"
#!/bin/sh
exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\hooks\pre-commit.ps1"
"@
Set-Content -Path "$gitHooksDir\pre-commit" -Value $preCommitContent -Encoding ascii

Write-Host "✅ Git hooks successfully installed!" -ForegroundColor Green
Pause