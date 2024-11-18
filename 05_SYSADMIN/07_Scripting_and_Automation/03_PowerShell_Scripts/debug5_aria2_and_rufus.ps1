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
        Write-Error "Failed to download $url: $($_.Exception.Message)"
        throw
    }
}

# Function to extract aria2 and verify its presence
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

# Function to use aria2 to download files
function Use-Aria2ToDownload {
    param (
        [string]$aria2ExePath,
        [string[]]$urls
    )

    if (-not (Test-Path -Path $aria2ExePath)) {
        throw "aria2c.exe not found at $aria2ExePath."
    }

    # Prepare arguments for aria2c
    $arguments = $urls | ForEach-Object { "--download=${_}" } -join " "
    
    $processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processStartInfo.FileName = $aria2ExePath
    $processStartInfo.Arguments = $arguments
    $processStartInfo.RedirectStandardOutput = $true
    $processStartInfo.RedirectStandardError = $true
    $processStartInfo.UseShellExecute = $false
    $processStartInfo.CreateNoWindow = $true

    $process = [System.Diagnostics.Process]::Start($processStartInfo)
    $process.WaitForExit()

    if ($process.ExitCode -ne 0) {
        throw "aria2c failed with exit code $($process.ExitCode). Error: $($process.StandardError.ReadToEnd())"
    }

    Write-Host "Files downloaded successfully using aria2c."
}

# Function to get the latest release URL for a file pattern
function Get-LatestReleaseUrls {
    param (
        [string]$apiUrl,
        [string]$fileNamePattern
    )

    try {
        $response = Invoke-WebRequest -Uri $apiUrl -UseBasicP 
        $releaseData = $response.Content | ConvertFrom-Json
        $assets = $releaseData.assets

        foreach ($asset in $assets) {
            if ($asset.name -match $fileNamePattern) {
                return $asset.browser_download_url
            }
        }
        
        throw "No asset found matching pattern $fileNamePattern"
    } catch {
        Write-Error "Failed to get latest release URLs: $($_.Exception.Message)"
        throw
    }
}

# Define URLs and patterns
$aria2ApiUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$aria2FileNamePattern = 'aria2-.*win-64bit.*\.zip'

$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusFileNamePattern = 'rufus-.*\.exe'
$rufusSigFileNamePattern = 'rufus-.*\.exe\.sig'

# Fetch and extract download URLs
$aria2ReleaseUrl = Get-LatestReleaseUrls -apiUrl $aria2ApiUrl -fileNamePattern $aria2FileNamePattern
$rufusReleaseUrl = Get-LatestReleaseUrls -apiUrl $rufusApiUrl -fileNamePattern $rufusFileNamePattern
$rufusSigUrl = Get-LatestReleaseUrls -apiUrl $rufusApiUrl -fileNamePattern $rufusSigFileNamePattern

# Define file paths
$downloadsPath = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'
$aria2ReleaseName = [System.IO.Path]::GetFileName($aria2ReleaseUrl)
$aria2ZipPath = Join-Path -Path $downloadsPath -ChildPath $aria2ReleaseName
$aria2ExtractedDir = Join-Path -Path $downloadsPath -ChildPath 'aria2'
$aria2ExePath = Join-Path -Path $aria2ExtractedDir -ChildPath 'aria2c.exe'

# Remove existing extraction directory if it exists
if (Test-Path -Path $aria2ExtractedDir) {
    Write-Host "Removing existing extraction directory $aria2ExtractedDir..."
    Remove-Item -Path $aria2ExtractedDir -Recurse -Force
}

# Download and install aria2
try {
    Write-Host "Downloading aria2 from $aria2ReleaseUrl..."
    Download-File -url $aria2ReleaseUrl -destinationPath $aria2ZipPath

    Write-Host "Extracting $aria2ZipPath..."
    Expand-Archive -Path $aria2ZipPath -DestinationPath $aria2ExtractedDir -Force -ErrorAction Stop
    Remove-Item -Path $aria2ZipPath -ErrorAction Stop

    # Verify extraction
    Verify-Aria2Extraction -extractedDir $aria2ExtractedDir -expectedExePath $aria2ExePath
} catch {
    Write-Error "Failed to download or extract aria2: $($_.Exception.Message)"
}

# Use aria2 to download Rufus and its signature
try {
    $rufusPath = Join-Path -Path $downloadsPath -ChildPath [System.IO.Path]::GetFileName($rufusReleaseUrl)
    $rufusSigPath = Join-Path -Path $downloadsPath -ChildPath [System.IO.Path]::GetFileName($rufusSigUrl)

    Write-Host "Using aria2 to download Rufus and its signature..."
    Use-Aria2ToDownload -aria2ExePath $aria2ExePath -urls @($rufusReleaseUrl, $rufusSigUrl)
} catch {
    Write-Error "Failed to download Rufus and its signature using aria2: $($_.Exception.Message)"
}
