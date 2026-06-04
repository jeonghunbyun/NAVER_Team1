# Sync latest agents/skills FROM local Cursor INTO this backup repo
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$projectSrc = Join-Path $env:USERPROFILE "Desktop\AD_AGENCY\.cursor"
$personalSrc = Join-Path $env:USERPROFILE ".cursor\skills\my-agency"
$projectDest = Join-Path $Root "project\AD_AGENCY\.cursor"
$personalDest = Join-Path $Root "personal\.cursor\skills\my-agency"

Copy-Item (Join-Path $projectSrc "agents\*") (Join-Path $projectDest "agents\") -Recurse -Force
Copy-Item (Join-Path $projectSrc "skills\*") (Join-Path $projectDest "skills\") -Recurse -Force
Copy-Item "$personalSrc\*" $personalDest -Recurse -Force

Write-Host "Synced from local Cursor into backup repo." -ForegroundColor Green
Write-Host "Run: git add -A; git commit -m 'Update agents and skills'; git push"
