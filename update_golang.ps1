param (
    [string]$repoName,
    [string]$goVersion = "1.24.4"
)

# Store the original directory
$originalDir = Get-Location

# Go up one directory to find the repo
Set-Location ..

# Check if the directory exists
if (-Not (Test-Path -Path $repoName -PathType Container)) {
    # If folder doesn't exist, write log and return to the original directory
    Write-Host "[$(Get-Date)] ERROR: The folder '$repoName' does not exist." | Out-File -Append "repo-script-log.txt"
    Set-Location $originalDir
    return
} else {
    # Change to the repository folder
    Set-Location $repoName
    Write-Host "[$(Get-Date)] Successfully changed to folder '$repoName'."

    # Switch to the main branch and pull the latest changes
    git switch main
    git fetch
    git pull

    # Create a new branch called "go-version-update"
    git checkout -b go-version-update
    
    # Store the current directory as the root directory of the repository
    $repoRootDir = Get-Location

    # Find the directory containing the go.mod file
    $goModDir = Get-ChildItem -Recurse -Filter 'go.mod' | Select-Object -First 1

    if ($goModDir) {
        # Change to the directory containing the go.mod file
        Set-Location $goModDir.DirectoryName
        Write-Host "[$(Get-Date)] Found go.mod in: $($goModDir.DirectoryName), changing to that directory."

        # Execute 'go mod edit' to update Go version
        Write-Host "[$(Get-Date)] Running 'go mod edit -go $goVersion'."
        go mod edit -go $goVersion

        # Run 'go mod tidy' to clean up the dependencies
        Write-Host "[$(Get-Date)] Running 'go mod tidy'."
        go mod tidy

        # Add changes to go.mod and go.sum
        git add go.mod go.sum

        # Return to the root of the repository
        Set-Location $repoRootDir

        # Commit the changes
        Write-Host "[$(Get-Date)] Committing changes to the branch 'go-version-update'."
        git commit -m "Update Go version to $goVersion"
    } else {
        # No go.mod file found, log it
        Write-Host "[$(Get-Date)] ERROR: No go.mod file found in the repository."
        Write-Host "[$(Get-Date)] ERROR: No go.mod file found in the repository." | Out-File -Append "repo-script-log.txt"
        
        # Return to the root of the repository
        Set-Location $repoRootDir
    }

    # Update pull-request.yml with the new Go version
    $prYmlPath = Get-ChildItem -Recurse -Filter 'pull-request.yml' | Select-Object -First 1
    if ($prYmlPath) {
        Write-Host "[$(Get-Date)] Found 'pull-request.yml' at: $($prYmlPath.FullName)"
        
        # Read the content of the file
        $ymlContent = Get-Content $prYmlPath.FullName

        # Define the old Go version regex to match (e.g., 1.24.2)
        $oldGoVersionPattern = '\d+\.\d+\.\d+'

        # Replace the old Go version with the new one
        $newYmlContent = $ymlContent -replace $oldGoVersionPattern, $goVersion

        # Write the updated content back to the file
        Set-Content $prYmlPath.FullName $newYmlContent

        Write-Host "[$(Get-Date)] Updated Go version in pull-request.yml to $goVersion."

        # Stage the changes to the pull-request.yml file
        git add $prYmlPath.FullName

        # Commit the change to pull-request.yml
        Write-Host "[$(Get-Date)] Committing changes to 'pull-request.yml'."
        git commit -m "Update Go version in pull-request.yml to $goVersion"
    } else {
        Write-Host "[$(Get-Date)] No pull-request.yml file found in the repository."
    }

    # Update Dockerfiles with the new Go version (Dockerfile, Dockerfile.debug, Dockerfile.dev)
    $dockerFiles = Get-ChildItem -Recurse -Filter 'Dockerfile*' | Where-Object { $_.Name -match '^Dockerfile' }
    if ($dockerFiles) {
        foreach ($dockerFile in $dockerFiles) {
            Write-Host "[$(Get-Date)] Found '$($dockerFile.Name)', updating Go version."

            # Read the content of the Dockerfile
            $dockerContent = Get-Content $dockerFile.FullName

            # Define the old Go version regex to match (e.g., 1.24.2)
            $dockerOldGoVersionPattern = 'golang:\d+\.\d+\.\d+-alpine\d+\.\d+'

            # Replace the old Go version with the new one
            $dockerNewContent = $dockerContent -replace $dockerOldGoVersionPattern, "golang:$goVersion-alpine3.21"

            # Write the updated content back to the Dockerfile
            Set-Content $dockerFile.FullName $dockerNewContent

            Write-Host "[$(Get-Date)] Updated Go version in '$($dockerFile.Name)' to $goVersion."

            # Stage the changes to the Dockerfile
            git add $dockerFile.FullName

            # Commit the change to the Dockerfile
            Write-Host "[$(Get-Date)] Committing changes to '$($dockerFile.Name)'."
            git commit -m "Update Go version in $($dockerFile.Name) to $goVersion"
        }
    } else {
        Write-Host "[$(Get-Date)] No Dockerfile(s) found in the repository."
    }

    # Return to the original directory where the script was executed
    Set-Location $originalDir
}
