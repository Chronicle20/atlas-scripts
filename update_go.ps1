param (
    [string]$RepoName
)

$ErrorActionPreference = "Stop"

if (-not $RepoName) {
    Write-Host "Usage: .\update-go-version.ps1 <repo-name>"
    exit 1
}

# Save current location and jump to parent (where the repos are expected)
Push-Location

# Assume the repo is a sibling folder (../$RepoName)
$repoPath = Join-Path (Get-Location).Path "..\$RepoName"

if (-not (Test-Path $repoPath -PathType Container)) {
    Write-Host "Skipping $RepoName (does not exist at $repoPath)"
    Pop-Location
    exit 0
}

Set-Location $repoPath

# === Configuration ===
$NewVersion = "1.24.2"
$BranchName = "update/go-$NewVersion"

# === Step 0: Create update branch ===
git checkout -b $BranchName

# === Step 1: Find go.mod and update version ===
$goModFile = Get-ChildItem -Recurse -Filter "go.mod" | Select-Object -First 1

if (-not $goModFile) {
    Write-Host "❌ go.mod not found in $RepoName"
    Pop-Location
    exit 1
}

$modDir = $goModFile.Directory.FullName
$goModPath = $goModFile.FullName
$goSumPath = Join-Path $modDir "go.sum"

Write-Host "✅ Found go.mod at $goModPath"
Write-Host "🔧 Updating Go version to $NewVersion"

(Get-Content $goModPath) `
    -replace '^go\s+\d+(\.\d+){1,2}', "go $NewVersion" `
    | Set-Content $goModPath

# === Step 2: Run go mod tidy and build in module directory ===
Push-Location $modDir
go clean -modcache
Remove-Item go.sum -ErrorAction SilentlyContinue
go mod tidy
go mod download
go build ./...
go test ./...
Pop-Location

# === Step 3: Commit changes ===
git add $goModPath
if (Test-Path $goSumPath) {
    git add $goSumPath
}

git commit -m "Update Go version to $NewVersion"

# === Step 4: Push the branch ===
git push -u origin $BranchName

Write-Host "`n✅ Go version updated and pushed to branch '$BranchName' in '$RepoName'"

# Return to original directory
Pop-Location
