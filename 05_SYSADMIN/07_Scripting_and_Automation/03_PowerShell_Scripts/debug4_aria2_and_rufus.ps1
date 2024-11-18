# Rufus Variables
$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusReleaseName = "rufus-latest.exe"  # Placeholder, updated dynamically
$rufusPath = "$env:USERPROFILE\Downloads\$rufusReleaseName"

# aria2 Variables
$aria2ApiUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$aria2ReleaseName = "aria2-latest.zip"  # Placeholder, updated dynamically
$aria2ZipPath = "$env:USERPROFILE\Downloads\$aria2ReleaseName"
$aria2ExtractedDir = "$env:USERPROFILE\Downloads\aria2"
$aria2ExePath = "$aria2ExtractedDir\aria2c.exe"

# Function to install aria2 if needed
function Install-Aria2 {
    Write-Host "Fetching latest aria2 release..."
    $aria2Release = Invoke-RestMethod -Uri $aria2ApiUrl
    $aria2Asset = $aria2Release.assets | Where-Object { $_.name -match "aria2-[0-9.]+-win-64bit-build1.zip" }

    if ($aria2Asset) {
        $aria2Url = $aria2Asset.browser_download_url

        if (-not (Test-Path $aria2ZipPath)) {
            Write-Host "aria2 not found. Downloading and installing..."
            Invoke-WebRequest -Uri $aria2Url -OutFile $aria2ZipPath
            Write-Host "Extracting aria2..."
            Expand-Archive -Path $aria2ZipPath -DestinationPath $aria2ExtractedDir -Force

            # Locate aria2c.exe
            $aria2ExePathDir = Get-ChildItem -Path $aria2ExtractedDir -Recurse -Directory | Where-Object { $_.Name -match "aria2-[0-9.]+-win-64bit-build1" }

            if ($aria2ExePathDir) {
                $global:aria2ExePath = Join-Path -Path $aria2ExePathDir.FullName -ChildPath "aria2c.exe"
                Write-Host "Setting aria2c.exe path to: $global:aria2ExePath"

                if (Test-Path -LiteralPath $global:aria2ExePath) {
                    Write-Host "aria2c.exe found at: $global:aria2ExePath"
                } else {
                    Write-Host "aria2c.exe was not found or path is invalid."
                    exit 1
                }
            } else {
                Write-Host "Expected directory for aria2c.exe was not found."
                exit 1
            }
        } else {
            Write-Host "aria2 is already downloaded."
            $aria2ExePathDir = Get-ChildItem -Path $aria2ExtractedDir -Recurse -Directory | Where-Object { $_.Name -match "aria2-[0-9.]+-win-64bit-build1" }
            
            if ($aria2ExePathDir) {
                $global:aria2ExePath = Join-Path -Path $aria2ExePathDir.FullName -ChildPath "aria2c.exe"
                Write-Host "Setting aria2c.exe path to: $global:aria2ExePath"

                if (Test-Path -LiteralPath $global:aria2ExePath) {
                    Write-Host "aria2c.exe found at: $global:aria2ExePath"
                } else {
                    Write-Host "aria2c.exe was not found or path is invalid."
                    exit 1
                }
            } else {
                Write-Host "Expected directory for aria2c.exe was not found."
                exit 1
            }
        }
    } else {
        Write-Host "Could not detect the latest aria2 release. Please check the release page manually."
        exit 1
    }
}

# Function to download files using aria2
function Download-With-Aria2 {
    param (
        [string]$url,
        [string]$outputPath
    )

    if (-not (Test-Path $aria2ExePath)) {
        Write-Host "aria2 not found at $aria2ExePath, please ensure aria2 is installed."
        exit 1
    }

    $dirPath = [System.IO.Path]::GetDirectoryName($outputPath)
    $fileName = [System.IO.Path]::GetFileName($outputPath)
    $aria2Args = "--dir=""$dirPath"" --out=""$fileName"" ""$url"""

    Write-Host "Running aria2c with arguments: $aria2Args"

    try {
        Start-Process -FilePath $aria2ExePath -ArgumentList $aria2Args -NoNewWindow -Wait
        if (Test-Path $outputPath) {
            Write-Host "Download completed: $outputPath"
        } else {
            Write-Host "Failed to download: $outputPath"
            exit 1
        }
    } catch {
        Write-Host "Error downloading $url using aria2: $_"
        exit 1
    }
}

# Function to download and run Rufus
function Download-Rufus {
    Write-Host "Fetching latest Rufus release..."
    
    try {
        $rufusRelease = Invoke-RestMethod -Uri $rufusApiUrl
        Write-Host "Rufus release data fetched successfully."
    } catch {
        Write-Host "Error fetching Rufus release data: $_"
        exit 1
    }
    
    # Regex pattern to match Rufus executable and signature
    $rufusAsset = $rufusRelease.assets | Where-Object { $_.name -match "rufus-[0-9.]+.exe" }
    $rufusSigAsset = $rufusRelease.assets | Where-Object { $_.name -match "rufus-[0-9.]+.exe.sig" }

    if ($rufusAsset -and $rufusSigAsset) {
        $rufusUrl = $rufusAsset.browser_download_url
        $rufusSigUrl = $rufusSigAsset.browser_download_url

        Write-Host "Rufus URL: $rufusUrl"
        Write-Host "Rufus Signature URL: $rufusSigUrl"

        if (-not (Test-Path $rufusPath)) {
            Write-Host "Rufus not found. Downloading..."
            # Download Rufus executable
            Download-With-Aria2 -url $rufusUrl -outputPath $rufusPath

            # Download Rufus signature
            $rufusSigPath = "$rufusPath.sig"
            Download-With-Aria2 -url $rufusSigUrl -outputPath $rufusSigPath
        } else {
            Write-Host "Rufus is already downloaded."
        }
    } else {
        Write-Host "Could not detect the latest Rufus release. Please check the release page manually."
        exit 1
    }
}

# Function to run Rufus for burning ISO to USB
function Run-Rufus {
    if (-not (Test-Path $rufusPath)) {
        Download-Rufus
    }

    try {
        Write-Host "Launching Rufus..."
        Start-Process -FilePath $rufusPath -Wait
    } catch {
        Write-Host "Error launching Rufus: $_"
        exit 1
    }
}

# Execute the functions
Install-Aria2
Download-Rufus
Run-Rufus
