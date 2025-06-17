$originalDir = Get-Location
$repoName = $args[0]

# Go up one directory
Set-Location ..

# Check if the repository directory exists
if (-Not (Test-Path -Path $repoName -PathType Container)) {
    Write-Host "Skipping $repoName (does not exist)"
} else {
    # Change to the repository directory
    Set-Location $repoName
    
    # Switch to the 'main' branch, fetch, and pull
    git switch main
    git fetch
    git pull
}

# Go back to the original directory
Set-Location $originalDir
