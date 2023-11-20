param(
    [string]$targetVersion
)

# Get the environment variable named "defaultVersion"
$defaultVersion = [System.Environment]::GetEnvironmentVariable("defaultVersion", [System.EnvironmentVariableTarget]::User)

# Set the base path to AppData\Roaming\nvm
$basePath = [System.IO.Path]::Combine($env:APPDATA, "nvm")

# Check if the folder named like defaultVersion exists
$defaultVersionPath = Join-Path $basePath $defaultVersion
if (-not (Test-Path $defaultVersionPath -PathType Container)) {
    Write-Error "Error: Folder '$defaultVersion' does not exist."
    exit 1
}

# Check if the folder named like "real_" + defaultVersion exists
$realDefaultVersionPath = Join-Path $basePath "real_$defaultVersion"
if (-not (Test-Path $realDefaultVersionPath -PathType Container)) {
    # Make a copy of the folder named defaultVersion, naming it "real_" + defaultVersion
    Copy-Item -Path $defaultVersionPath -Destination $realDefaultVersionPath -Recurse
}

# Delete the folder named defaultVersion
Remove-Item -Path $defaultVersionPath -Recurse -Force

# Copy the folder named "real_" + version naming it as version
$realTargetVersionPath = Join-Path $basePath "real_$version"
$targetVersionPath = Join-Path $basePath "real_$version"

Copy-Item -Path $realTargetVersionPath -Destination $targetVersionPath -Recurse

Write-Host "Folders updated successfully."
