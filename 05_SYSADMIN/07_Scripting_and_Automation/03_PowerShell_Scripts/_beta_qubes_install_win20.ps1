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
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

######################
# Variables
######################

# Base Variables
$downloadPath = "$env:USERPROFILE\Downloads"
$qubesBaseUrl = "https://ftp.qubes-os.org/iso"
$qubesVersionRegex = "Qubes-R(\d+\.\d+\.\d+)-x86_64"
$qubesIsoPath = "$downloadPath\Qubes.iso"
$qubesSigPath = "$downloadPath\Qubes.sig"

# aria2 Variables
$aria2BaseUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$aria2ReleaseName = "aria2-latest.zip"
$aria2ZipPath = "$downloadPath\$aria2ReleaseName"
$aria2ExtractedDir = "$downloadPath\aria2"
$aria2ExePath = "$aria2ExtractedDir\aria2c.exe"

# Gpg4win Variables
$gpg4winBaseUrl = "https://files.gpg4win.org"
$gpg4winReleaseName = "gpg4win-latest.exe"
$gpg4winPath = "$downloadPath\$gpg4winReleaseName"
$gpg4winSigPath = "$downloadPath\gpg4win-latest.exe.sig"

# Rufus Variables
$rufusBaseUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$rufusReleaseName = "rufus-latest.exe"
$rufusPath = "$downloadPath\$rufusReleaseName"

######################
# Functions
######################

# Check if the script is running with admin privileges
if (-not ([bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    exit 1
}

# Function to verify the hash of downloaded files
function Verify-Hash {
    param (
        [string]$filePath,
        [string]$hashUrl
    )
    Write-Host "Verifying hash for $filePath..."

    # Download hash from the URL
    $expectedHash = Invoke-RestMethod -Uri $hashUrl -UseBasicParsing

    # Calculate the hash of the downloaded file
    $actualHash = Get-FileHash -Algorithm SHA256 -Path $filePath | Select-Object -ExpandProperty Hash

    if ($expectedHash -eq $actualHash) {
        Write-Host "Hash verification successful for $filePath"
    } else {
        Write-Host "Hash verification failed for $filePath. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Function to install aria2 if needed
function Install-Aria2 {
    Write-Host "Fetching latest aria2 release..."
    $aria2Release = Invoke-RestMethod -Uri $aria2BaseUrl
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
                Write-Host "aria2c.exe found at: $global:aria2ExePath"
            } else {
                Write-Host "aria2c.exe was not found or path is invalid." -ForegroundColor Red
                exit 1
            }
        }
    } else {
        Write-Host "Could not detect the latest aria2 release. Exiting." -ForegroundColor Red
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
        Write-Host "aria2 not found, please ensure aria2 is installed." -ForegroundColor Red
        exit 1
    }

    $dirPath = [System.IO.Path]::GetDirectoryName($outputPath)
    $fileName = [System.IO.Path]::GetFileName($outputPath)

    # Correctly escape paths and construct the argument string
    $aria2Args = @(
        "--dir=$dirPath",
        "--out=$fileName",
        "$url"
    )

    Write-Host "Running aria2c for: $url"

    Start-Process -FilePath $global:aria2ExePath -ArgumentList $aria2Args -NoNewWindow -Wait

    if (-not (Test-Path $outputPath)) {
        Write-Host "Download failed for $outputPath. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Function to install Gpg4win if needed
function Install-Gpg4win {
    Write-Host "Fetching latest Gpg4win release..."
    $gpg4winUrl = "$gpg4winBaseUrl/gpg4win-4.3.1.exe"
    $gpg4winSigUrl = "$gpg4winBaseUrl/gpg4win-4.3.1.exe.sig"

    if (-not (Test-Path $gpg4winPath)) {
        Write-Host "Gpg4win not found. Downloading..."
        Download-With-Aria2 -url $gpg4winUrl -outputPath $gpg4winPath
        Write-Host "Gpg4win downloaded successfully."

        Write-Host "Downloading Gpg4win signature..."
        Download-With-Aria2 -url $gpg4winSigUrl -outputPath $gpg4winSigPath

        Write-Host "Verifying Gpg4win signature..."
        $gpgStatus = Start-Process -FilePath "gpg" -ArgumentList "--verify $gpg4winSigPath $gpg4winPath" -NoNewWindow -Wait -PassThru
        if ($gpgStatus.ExitCode -eq 0) {
            Write-Host "Gpg4win signature verified successfully."
        } else {
            Write-Host "Gpg4win signature verification failed. Exiting." -ForegroundColor Red
            exit 1
        }

        Write-Host "Installing Gpg4win..."
        Start-Process -FilePath $gpg4winPath -ArgumentList "/silent" -NoNewWindow -Wait
        Write-Host "Gpg4win installation complete."
    } else {
        Write-Host "Gpg4win already exists. Skipping installation."
    }
}

# Function to download Rufus and verify it
function Download-Rufus {
    Write-Host "Fetching latest Rufus release..."
    $rufusRelease = Invoke-RestMethod -Uri $rufusBaseUrl
    $rufusAsset = $rufusRelease.assets | Where-Object { $_.name -match "rufus-[0-9.]+.exe" }

    if ($rufusAsset) {
        $rufusUrl = $rufusAsset.browser_download_url

        if (-not (Test-Path $rufusPath)) {
            Write-Host "Rufus not found. Downloading..."
            Download-With-Aria2 -url $rufusUrl -outputPath $rufusPath
            Write-Host "Rufus downloaded successfully."
        } else {
            Write-Host "Rufus already exists. Skipping download."
        }
    } else {
        Write-Host "Could not detect the latest Rufus release. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Download the Qubes ISO and signature files
function Download-QubesIsoAndSig {
    Write-Host "Fetching latest Qubes OS version info..."
    $qubesIsoList = Invoke-WebRequest -Uri $qubesBaseUrl -UseBasicParsing

    # Use regex to find all Qubes ISO versions
    $qubesIsoUrls = @()
    $qubesSigUrls = @()
    if ($qubesIsoList.Content -match $qubesVersionRegex) {
        # Capture all versions
        $matches = [regex]::Matches($qubesIsoList.Content, $qubesVersionRegex)
        foreach ($match in $matches) {
            $version = $match.Groups[1].Value
            $qubesIsoUrls += "$qubesBaseUrl/Qubes-R$version-x86_64.iso"
            $qubesSigUrls += "$qubesBaseUrl/Qubes-R$version-x86_64.iso.asc"
        }

        # Get the last stable version (assuming it's the latest one listed)
        $latestIsoUrl = $qubesIsoUrls | Sort-Object -Descending | Select-Object -First 1
        $latestSigUrl = $qubesSigUrls | Sort-Object -Descending | Select-Object -First 1

        Write-Host "Latest Qubes OS Version URL: $latestIsoUrl"

        if (-not (Test-Path $qubesIsoPath)) {
            Write-Host "Downloading Qubes OS ISO..."
            Download-With-Aria2 -url $latestIsoUrl -outputPath $qubesIsoPath
        } else {
            Write-Host "Qubes ISO already exists. Skipping download."
        }

        if (-not (Test-Path $qubesSigPath)) {
            Write-Host "Downloading Qubes OS Signature..."
            Download-With-Aria2 -url $latestSigUrl -outputPath $qubesSigPath
        } else {
            Write-Host "Qubes Signature already exists. Skipping download."
        }
    } else {
        Write-Host "Could not determine the latest Qubes version. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Verify Qubes OS ISO signature
function Verify-QubesIsoSignature {
    Write-Host "Verifying Qubes OS ISO signature..."

    # Import the GPG key for verification
    $qubesGpgKeyId = "2DAB3C0B4D3F2827"  # Update with the correct key ID if needed
    $gpgImportStatus = Start-Process -FilePath "gpg" -ArgumentList "--keyserver https://keys.openpgp.org --recv-keys $qubesGpgKeyId" -NoNewWindow -Wait -PassThru

    if ($gpgImportStatus.ExitCode -ne 0) {
        Write-Host "Failed to import Qubes OS signing key. Exiting." -ForegroundColor Red
        exit 1
    }

    # Verify the ISO signature
    $gpgStatus = Start-Process -FilePath "gpg" -ArgumentList "--verify $qubesSigPath $qubesIsoPath" -NoNewWindow -Wait -PassThru
    if ($gpgStatus.ExitCode -eq 0) {
        Write-Host "Qubes OS ISO signature verified successfully."
    } else {
        Write-Host "Qubes OS ISO signature verification failed. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Function to display instructions for using Rufus
function Show-RufusInstructions {
    param (
        [string]$qubesIsoPath
    )

    Write-Host "-------------------------- Instructions for Rufus -------------------------" -ForegroundColor Cyan
    Write-Host " 1. After Rufus opens, select your USB drive in the 'Device' dropdown list." -ForegroundColor Yellow
    Write-Host "    **Ensure you choose the correct USB drive to avoid data loss.**" -ForegroundColor Red
    Write-Host " 2. In the 'Boot selection' section, click 'SELECT' and choose the Qubes ISO file: $qubesIsoPath" -ForegroundColor Yellow
    Write-Host "    **Keep the default settings for the rest of the options** (e.g., partition scheme, file system)." -ForegroundColor Green
    Write-Host " 3. Click 'START' to begin creating the bootable USB drive." -ForegroundColor Yellow
    Write-Host "    **Wait for the process to complete, then safely eject the USB drive.**" -ForegroundColor Green
    Write-Host " 4. Once Rufus finishes, you can boot from the USB drive to install Qubes OS." -ForegroundColor Yellow
    Write-Host "    **You can now proceed with the Qubes OS installation using the USB.**" -ForegroundColor Green
    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Cyan
}

# Function to run Rufus for burning ISO to USB
function Run-Rufus {
    if (-not (Test-Path $rufusPath)) {
        Download-Rufus
    }

    try {
        Write-Host "Launching Rufus..." -ForegroundColor Green
        Start-Process -FilePath $rufusPath -Wait
    } catch {
        Write-Host "Error launching Rufus: $_" -ForegroundColor Red
        exit 1
    }
}

######################
# Main Execution Steps
######################

Install-Aria2
Install-Gpg4win
Download-Rufus
Download-QubesIsoAndSig
Verify-QubesIsoSignature
Show-RufusInstructions
Run-Rufus

# Final instructions after Rufus closes
Write-Host "Qubes OS ISO creation process completed!" -ForegroundColor Green
Write-Host "You can now boot Qubes OS from the USB drive." -ForegroundColor Yellow
