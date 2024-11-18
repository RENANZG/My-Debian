########################################################################
# File Name    : qubes_install_win.ps1
# Description  : This script downloads the latest Qubes OS ISO, verifies 
#                its signature using GPG (via Gpg4win), and writes it to 
#                a selected USB drive on a Windows system. 
#                The script automatically downloads and installs Gpg4win 
#                for signature verification, aria2 for robust downloads,
#                and Rufus Portable to write the ISO to the USB drive.
# Dependencies : PowerShell, Gpg4win, aria2, Rufus Portable
# Usage        : • Open PowerShell with administrative privileges:
#                   - Right-click on the Start menu, and select
#                      'Windows PowerShell (Admin)'
#                • In PowerShell, set the execution policy
#                   Set-ExecutionPolicy Bypass -Scope Process -Force
#                • Run the script from the folder where you downloaded
#                  it, change the name of the username "User": 
#                   C:\Users\User\Downloads\qubes_install_win.ps1
#                • Follow the on-screen instructions to verify the ISO 
#                  and write it to your USB drive.
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Qubes Variables
$qubesBaseUrl = "https://ftp.qubes-os.org/iso/"
$qubesVersionRegex = "Qubes-R(\d+\.\d+\.\d+)-x86_64"
$qubesIsoPath = "$env:USERPROFILE\Downloads\Qubes.iso"
$qubesSigPath = "$env:USERPROFILE\Downloads\Qubes.sig"
$qubesGpgKeyId = "9C884DF3F81064A569A4A9FAE022E58F8E34D89F"

# aria2 Variables
$aria2ApiUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$aria2ReleaseName = "aria2-latest.zip"  # Placeholder, updated dynamically
$aria2ZipPath = "$env:USERPROFILE\Downloads\$aria2ReleaseName"
$aria2ExtractedDir = "$env:USERPROFILE\Downloads\aria2"
$aria2ExePath = "$aria2ExtractedDir\aria2c.exe"

# Gpg4win Variables
$gpg4winApiUrl = "https://api.github.com/repos/gpg4win/gpg4win/releases/latest"
$gpg4winReleaseName = "gpg4win-latest.exe"  # Placeholder, updated dynamically
$gpg4winPath = "$env:USERPROFILE\Downloads\$gpg4winReleaseName"

# Rufus Variables
$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusReleaseName = "rufus-latest.exe"  # Placeholder, updated dynamically
$rufusPath = "$env:USERPROFILE\Downloads\$rufusReleaseName"

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

# Function to check if GPG is installed
function Check-GPG {
    try {
        & gpg --version | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Install Gpg4win if needed
function Install-Gpg4win {
    Write-Host "Fetching latest Gpg4win release..."
    $gpg4winRelease = Invoke-RestMethod -Uri $gpg4winApiUrl -UseBasicParsing
    $gpg4winAsset = $gpg4winRelease.assets | Where-Object { $_.name -match "gpg4win-[0-9.]+.exe" }

    if ($gpg4winAsset) {
        $gpg4winUrl = $gpg4winAsset.browser_download_url

        if (-not (Test-Path $gpg4winPath)) {
            Write-Host "Gpg4win not found. Downloading and installing..."
            Download-With-Aria2 -url $gpg4winUrl -outputPath $gpg4winPath

            if (Test-Path $gpg4winPath) {
                Write-Host "Gpg4win downloaded successfully to: $gpg4winPath"
                Write-Host "Installing Gpg4win..."
                Start-Process -FilePath $gpg4winPath -ArgumentList "/silent" -NoNewWindow -Wait
                Write-Host "Gpg4win installation complete."
            } else {
                Write-Host "Failed to download Gpg4win."
                exit 1
            }
        } else {
            Write-Host "Gpg4win is already downloaded."
        }
    } else {
        Write-Host "Could not detect the latest Gpg4win release. Please check the release page manually."
        exit 1
    }
}

# Function to download files using aria2
function Download-With-Aria2 {
    param (
        [string]$url,
        [string]$outputPath
    )

    if (-not (Test-Path $global:aria2ExePath)) {
        Write-Host "aria2 not found, please ensure aria2 is installed."
        exit 1
    }

    $dirPath = [System.IO.Path]::GetDirectoryName($outputPath)
    $fileName = [System.IO.Path]::GetFileName($outputPath)
    $aria2Args = "--dir=""$dirPath"" --out=""$fileName"" ""$url"""

    Write-Host "Running aria2c with arguments: $aria2Args"

    try {
        Start-Process -FilePath $global:aria2ExePath -ArgumentList $aria2Args -NoNewWindow -Wait
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

# Function to check if the key is already imported
function Is-Key-Imported {
    param (
        [string]$keyId
    )

    $output = & gpg --list-keys --fingerprint | Select-String -Pattern $keyId
    return $output -ne $null
}

# Function to download and run Rufus
function Download-Rufus {
    Write-Host "Fetching latest Rufus release..."
    
    # Get the latest Rufus release data from GitHub API
    $rufusRelease = Invoke-RestMethod -Uri $rufusApiUrl
    
    # Regex pattern to match Rufus executable and signature
    $rufusAsset = $rufusRelease.assets | Where-Object { $_.name -match "rufus-[0-9.]+.exe" }
    $rufusSigAsset = $rufusRelease.assets | Where-Object { $_.name -match "rufus-[0-9.]+.exe.sig" }

    if ($rufusAsset -and $rufusSigAsset) {
        $rufusUrl = $rufusAsset.browser_download_url
        $rufusSigUrl = $rufusSigAsset.browser_download_url

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

# Function to get the latest Qubes OS version
function Get-LatestQubesVersion {
    Write-Host "Fetching latest Qubes OS version..."
    $htmlContent = Invoke-WebRequest -Uri $qubesBaseUrl
    $matches = [regex]::Matches($htmlContent.Content, $qubesVersionRegex)

    if ($matches.Count -gt 0) {
        $latestVersion = ($matches | Sort-Object { [version]$_.Groups[1].Value } -Descending)[0].Groups[1].Value
        Write-Host "Latest Qubes Version: $latestVersion"
        return $latestVersion
    } else {
        Write-Host "No Qubes versions found. Exiting."
        exit 1
    }
}

# Start the script flow by installing Aria2 and Gpg4win, downloading the necessary files
Install-Aria2

if (-not (Check-GPG)) {
    Install-Gpg4win
}

# Fetch and process the latest Qubes OS version, signatures, Rufus, etc.
$qubesVersion = Get-LatestQubesVersion
$qubesIsoUrl = "$qubesBaseUrl/Qubes-R$qubesVersion-x86_64.iso"
$qubesSigUrl = "$qubesBaseUrl/Qubes-R$qubesVersion-x86_64.iso.asc"

Download-With-Aria2 -url $qubesIsoUrl -outputPath $qubesIsoPath
Download-With-Aria2 -url $qubesSigUrl -outputPath $qubesSigPath

# Instructions to use Rufus
Write-Host "--------------------- Instructions for Rufus ---------------------"
Write-Host " 1. After Rufus opens, select your USB drive in the 'Device' dropdown list."
Write-Host "    **Ensure you choose the correct USB drive to avoid data loss.**"
Write-Host " 2. In the 'Boot selection' section, click 'SELECT' and choose the Qubes ISO file: $qubesIsoPath"
Write-Host "    **Keep the default settings for the rest of the options** (e.g., partition scheme, file system)."
Write-Host " 3. Click 'START' to begin creating the bootable USB drive."
Write-Host "    **Wait for the process to complete, then safely eject the USB drive.**"
Write-Host " 4. Once Rufus finishes, you can boot from the USB drive to install Qubes OS."
Write-Host "    **You can now proceed with the Qubes OS installation using the USB.**"
Write-Host "---------------------------------------------------------------------"

# Finally, run Rufus to burn the ISO
Run-Rufus

Write-Host "Process complete. You can now boot Qubes OS from the USB drive."
