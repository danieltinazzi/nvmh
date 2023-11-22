param(
    [string]$targetVersion
)

# Set the base path to AppData\Roaming\nvm
$basePath = [System.IO.Path]::Combine($env:APPDATA, "nvm")

$defaultVersionFolder = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -like 'real_*' } | Select-Object -First 1

if ($defaultVersionFolder) {
    $defaultVersion = $defaultVersionPath.Name -replace '^real_'
} else {
    Write-Error "Error: No default version found."
    exit 1
}

# Check if the folder named like defaultVersion exists
$defaultVersionPath = Join-Path $basePath $defaultVersion
if (-not (Test-Path $defaultVersionPath -PathType Container)) {
    Write-Error "Error: Default version '$defaultVersion' is not installed."
    exit 1
}

$realDefaultVersionPath = Join-Path $basePath "real_$defaultVersion"
if (-not (Test-Path $realDefaultVersionPath -PathType Container)) {
    # Rename the folder named defaultVersion, naming it "real_" + defaultVersion
    Rename-Item -Path $defaultVersionPath -NewName "real_$defaultVersion"
}

# Delete the folder named defaultVersion
Remove-Item -Path $defaultVersionPath -Recurse -Force

if ($targetVersion -eq $defaultVersion) {
    $targetVersion = "real_$targetVersion"
}
$targetVersionPath = Join-Path $basePath $targetVersion

# Make a junction from targetVersion to defaultVersion
New-Item -Path $defaultVersionPath -ItemType Junction -Value $targetVersionPath

Write-Host "Switched to $defaultVersion."
