# Define API URLs and file patterns
$aria2ApiUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$aria2FileNamePattern = 'aria2-.*win-64bit.*\.zip'  # Regex pattern for aria2 filename

$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusFileNamePattern = 'rufus-.*\.exe'  # Regex pattern for Rufus filename
$rufusSigFileNamePattern = 'rufus-.*\.exe\.sig'  # Regex pattern for Rufus signature filename

# Fetch and extract download URLs
$aria2ReleaseUrl = Get-LatestReleaseUrls -apiUrl $aria2ApiUrl -fileNamePattern $aria2FileNamePattern
$rufusReleaseUrl = Get-LatestReleaseUrls -apiUrl $rufusApiUrl -fileNamePattern $rufusFileNamePattern
$rufusSigUrl = Get-LatestReleaseUrls -apiUrl $rufusApiUrl -fileNamePattern $rufusSigFileNamePattern

# Define file paths
$downloadsPath = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'

$aria2ReleaseName = [System.IO.Path]::GetFileName($aria2ReleaseUrl)
$aria2ZipPath = Join-Path -Path $downloadsPath -ChildPath $aria2ReleaseName
$aria2ExtractedDir = Join-Path -Path $downloadsPath -ChildPath 'aria2'
$aria2ExePath = Join-Path -Path $aria2ExtractedDir -ChildPath 'aria2-1.37.0-win-64bit-build1\aria2c.exe'

$rufusReleaseName = [System.IO.Path]::GetFileName($rufusReleaseUrl)
$rufusPath = Join-Path -Path $downloadsPath -ChildPath $rufusReleaseName

$rufusSigName = [System.IO.Path]::GetFileName($rufusSigUrl)
$rufusSigPath = Join-Path -Path $downloadsPath -ChildPath $rufusSigName


# Helper function to get the latest release download URLs
function Get-LatestReleaseUrls {
    param (
        [string]$apiUrl,
        [string]$fileNamePattern
    )

    try {
        # Fetch latest release information
        $releaseInfo = Invoke-RestMethod -Uri $apiUrl -Headers @{Accept = 'application/vnd.github.v3+json'}

        # Loop through each asset and find matching file based on pattern
        foreach ($asset in $releaseInfo.assets) {
            if ($asset.name -match $fileNamePattern) {
                return $asset.browser_download_url
            }
        }

        throw "Failed to find asset with pattern $fileNamePattern"
    } catch {
        Write-Error "Error fetching release URLs: $($_.Exception.Message)"
        throw
    }
}

# Function to download a file
function Download-File {
    param (
        [string]$url,
        [string]$destinationPath
    )

    try {
        Write-Host "Downloading $url..."
        Invoke-WebRequest -Uri $url -OutFile $destinationPath -ErrorAction Stop
        Write-Host "Downloaded successfully: $destinationPath"
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Error ("Failed to download " + $url + ": " + $errorMessage)
        throw
    }
}

# Function to extract and verify the aria2 binary
function Verify-Aria2Extraction {
    param (
        [string]$extractedDir,
        [string]$expectedExePath
    )

    if (-not (Test-Path -Path $expectedExePath)) {
        throw "Failed to extract aria2. $expectedExePath does not exist."
    }

    Write-Host "aria2 downloaded and extracted successfully."
}

# Function to download Rufus signature
function Download-RufusSignature {
    param (
        [string]$apiUrl,
        [string]$signatureFileNamePattern,
        [string]$destinationPath
    )

    try {
        # Get signature URL
        $signatureUrl = Get-LatestReleaseUrls -apiUrl $apiUrl -fileNamePattern $signatureFileNamePattern
        # Download signature file
        Download-File -url $signatureUrl -destinationPath $destinationPath
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Error ("Failed to download Rufus signature: " + $errorMessage)
        throw
    }
}

# Remove existing extraction directory if it exists
if (Test-Path -Path $aria2ExtractedDir) {
    Write-Host "Removing existing extraction directory $aria2ExtractedDir..."
    Remove-Item -Path $aria2ExtractedDir -Recurse -Force
}

# Download and install aria2 if not already present
try {
    Write-Host "Downloading aria2 from $aria2ReleaseUrl..."
    Download-File -url $aria2ReleaseUrl -destinationPath $aria2ZipPath

    Write-Host "Extracting $aria2ZipPath..."
    Expand-Archive -Path $aria2ZipPath -DestinationPath $aria2ExtractedDir -Force -ErrorAction Stop
    Remove-Item -Path $aria2ZipPath -ErrorAction Stop

    # Verify extraction
    Verify-Aria2Extraction -extractedDir $aria2ExtractedDir -expectedExePath $aria2ExePath
} catch {
    Write-Error ("Failed to download or extract aria2: " + $_.Exception.Message)
}

# Download Rufus
try {
    Write-Host "Downloading Rufus from $rufusReleaseUrl..."
    Download-File -url $rufusReleaseUrl -destinationPath $rufusPath

    if (Test-Path -Path $rufusPath) {
        Write-Host "Rufus downloaded successfully."
    } else {
        throw "Failed to download Rufus. $rufusPath does not exist."
    }
} catch {
    Write-Error ("Failed to download Rufus: " + $_.Exception.Message)
}

# Download Rufus signature
Download-RufusSignature -apiUrl $rufusApiUrl -signatureFileNamePattern $rufusSigFileNamePattern -destinationPath $rufusSigPath
