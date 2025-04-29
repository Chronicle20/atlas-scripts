param (
    [string]$RepoName
)

$GitBaseUrl = "git@gh-chronicle20:Chronicle20"
$OriginalDir = Get-Location

# Move one directory up
Set-Location ..

if (Test-Path $RepoName) {
    Write-Host "Skipping $RepoName (already exists)"
} else {
    Write-Host "Cloning $RepoName..."
    git clone "$GitBaseUrl/$RepoName.git"
}

# Return to original directory
Set-Location $OriginalDir
