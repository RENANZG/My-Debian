# Debug Variables (Update with absolute paths for testing)
$qubesIsoPath = "C:\Users\User\Downloads\Qubes-R4.2.3-x86_64.iso"
$qubesSigPath = "C:\Users\User\Downloads\Qubes-R4.2.3-x86_64.iso.asc"
$qubesGpgKeyId = "9C884DF3F81064A569A4A9FAE022E58F8E34D89F"
$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusPath = "C:\Users\User\Downloads\rufus-latest.exe"
$aria2Path = "C:\Users\User\Downloads\aria2\aria2-1.37.0-win-64bit-build1\aria2c.exe"

# Function to download Rufus
function Download-Rufus {
    Write-Host "Fetching latest Rufus release..."

    try {
        $rufusRelease = Invoke-RestMethod -Uri $rufusApiUrl
    } catch {
        Write-Host "Failed to fetch Rufus release info: $_"
        exit 1
    }

    if ($rufusRelease -and $rufusRelease.assets) {
        $rufusAsset = $rufusRelease.assets | Where-Object { $_.name -eq "rufus-4.5.exe" }

        if ($rufusAsset) {
            $rufusUrl = $rufusAsset.browser_download_url

            if (-not (Test-Path $rufusPath)) {
                Write-Host "Downloading Rufus from: $rufusUrl"
                Download-With-Aria2 -url $rufusUrl -outputPath $rufusPath

                if (Test-Path $rufusPath) {
                    Write-Host "Rufus downloaded successfully to: $rufusPath"
                } else {
                    Write-Host "Failed to download Rufus."
                    exit 1
                }
            } else {
                Write-Host "Rufus is already downloaded."
            }
        } else {
            Write-Host "Could not find the Rufus asset 'rufus-4.5.exe' in the latest release. Please check the release page manually."
            exit 1
        }
    } else {
        Write-Host "Invalid response from GitHub API. Please check the release page manually."
        exit 1
    }
}

# Function to check if GPG is installed
function Check-GPG {
    try {
        & gpg --version | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Function to verify ISO
function Verify-Qubes-ISO {
    Write-Host "Verifying Qubes ISO..."
    if (Test-Path $qubesSigPath) {
        try {
            & gpg --verify $qubesSigPath $qubesIsoPath
            Write-Host "The ISO is verified."
        } catch {
            Write-Host "ERROR! The ISO does not seem to be signed by the Qubes key. Something is wrong!"
            exit 1
        }
    } else {
        Write-Host "Signature file is missing. Cannot verify the ISO."
        exit 1
    }
}

# Function to display Rufus instructions
function Show-Rufus-Instructions {
    Write-Host "`n--------------------- Instructions for Rufus ---------------------"
    Write-Host "1. After Rufus opens, select your USB drive in the 'Device' dropdown list."
    Write-Host "   **Ensure you choose the correct USB drive to avoid data loss.**"
    Write-Host "2. In the 'Boot selection' section, click 'SELECT' and choose the Qubes ISO file: $qubesIsoPath"
    Write-Host "   **Keep the default settings for the rest of the options** (e.g., partition scheme, file system)."
    Write-Host "3. Click 'START' to begin creating the bootable USB drive."
    Write-Host "   **Wait for the process to complete, then safely eject the USB drive.**"
    Write-Host "4. Once Rufus finishes, you can boot from the USB drive to install Qubes OS."
    Write-Host "   **You can now proceed with the Qubes OS installation using the USB.**"
    Write-Host "---------------------------------------------------------------------"
}

# Function to test Rufus execution
function Test-Rufus-Execution {
    if (Test-Path $rufusPath) {
        Write-Host "Opening Rufus..."
        try {
            Start-Process -FilePath $rufusPath -NoNewWindow -Wait
            Write-Host "Rufus launched successfully."
        } catch {
            Write-Host "Error opening Rufus: $_"
            exit 1
        }
    } else {
        Write-Host "Rufus executable not found. Please make sure Rufus is downloaded."
        exit 1
    }
}

# Function to download files using aria2 (assuming you already have aria2 installed and configured)
function Download-With-Aria2 {
    param (
        [string]$url,
        [string]$outputPath
    )

    # Ensure aria2c is available
    if (-not (Test-Path $aria2Path)) {
        Write-Host "aria2c not found at $aria2Path, please ensure aria2 is installed."
        exit 1
    }

    $dirPath = [System.IO.Path]::GetDirectoryName($outputPath)
    $fileName = [System.IO.Path]::GetFileName($outputPath)
    $aria2Args = "--dir=`"$dirPath`" --out=`"$fileName`" `"$url`""

    Write-Host "Running aria2c with arguments: $aria2Args"

    try {
        Start-Process -FilePath $aria2Path -ArgumentList $aria2Args -NoNewWindow -Wait
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

# Run debug functions
Verify-Qubes-ISO
Show-Rufus-Instructions
Download-Rufus
Test-Rufus-Execution

Write-Host "Debug script complete."
