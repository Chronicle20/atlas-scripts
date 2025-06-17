param (
    [string]$RepoName
)

$OriginalDir = Get-Location

# Move up one directory
Set-Location ..

if (-not (Test-Path $RepoName -PathType Container)) {
    Write-Host "Skipping $RepoName (does not exist)"
} else {
    Set-Location $RepoName
    git config user.name "Chronicle20"
    git config user.email "a.chronicle.20@gmail.com"
    Set-Location ..
}

# Return to original directory
Set-Location $OriginalDir
