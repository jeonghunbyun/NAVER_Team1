# Cursor agents & skills restore script
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$projectDest = Join-Path $env:USERPROFILE "Desktop\AD_AGENCY\.cursor"
$personalDest = Join-Path $env:USERPROFILE ".cursor\skills\my-agency"
$projectSrc = Join-Path $Root "project\AD_AGENCY\.cursor"
$personalSrc = Join-Path $Root "personal\.cursor\skills\my-agency"

New-Item -ItemType Directory -Force -Path (Join-Path $projectDest "agents") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $projectDest "skills") | Out-Null
New-Item -ItemType Directory -Force -Path $personalDest | Out-Null

Copy-Item (Join-Path $projectSrc "agents\*") (Join-Path $projectDest "agents\") -Recurse -Force
Copy-Item (Join-Path $projectSrc "skills\*") (Join-Path $projectDest "skills\") -Recurse -Force
Copy-Item "$personalSrc\*" $personalDest -Recurse -Force

Write-Host "Restored to:" -ForegroundColor Green
Write-Host "  $projectDest"
Write-Host "  $personalDest"
Write-Host "Restart Cursor or open a new Agent chat to apply."
