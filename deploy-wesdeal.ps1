# Publish the WesDeal app to https://wesbridge.net/wesdeal/
#
# The app SOURCE lives in a separate repo/worktree (C:\Claude\WesDeal-app) that
# Cloudflare does NOT serve. Cloudflare serves THIS repo. So a deploy = build the
# app, copy its dist/ into ./wesdeal/, commit, and push (Cloudflare auto-deploys
# on push to main, ~10-30s).
#
# Run from anywhere:  pwsh C:\Claude\bridge-declarer-leaderboard\deploy-wesdeal.ps1
# Skip the rebuild (publish an existing dist):  ... deploy-wesdeal.ps1 -NoBuild

param([switch]$NoBuild)
$ErrorActionPreference = 'Stop'

$app    = 'C:\Claude\WesDeal-app'
$deploy = 'C:\Claude\bridge-declarer-leaderboard'
$dst    = Join-Path $deploy 'wesdeal'
$dist   = Join-Path $app 'dist'

if (-not $NoBuild) {
    Write-Host "==> building app in $app" -ForegroundColor Cyan
    Push-Location $app
    try { npm run build } finally { Pop-Location }
}
if (-not (Test-Path (Join-Path $dist 'index.html'))) {
    throw "No build found at $dist. Run without -NoBuild, or build the app first."
}

Write-Host "==> clean-copying dist -> wesdeal/" -ForegroundColor Cyan
Remove-Item -Recurse -Force (Join-Path $dst '*')
Copy-Item -Recurse -Force (Join-Path $dist '*') $dst

Write-Host "==> commit + push (triggers Cloudflare deploy)" -ForegroundColor Cyan
Push-Location $deploy
try {
    git add wesdeal
    if (git status --porcelain wesdeal) {
        git commit -q -m "wesdeal: publish app build $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push -q origin main
        Write-Host "==> pushed $(git rev-parse --short HEAD) — live in ~10-30s at https://wesbridge.net/wesdeal/" -ForegroundColor Green
    } else {
        Write-Host "==> no changes to publish (build identical to what's deployed)" -ForegroundColor Yellow
    }
} finally { Pop-Location }
