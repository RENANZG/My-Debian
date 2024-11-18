########################################################################
# File Name    : qubes_install_win.ps1
# Description  : This script downloads the latest Qubes OS ISO, verifies 
#                its signature using gpg (via Gpg4win), and writes it to 
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

# Variables
$rufusApiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$aria2ApiUrl = "https://api.github.com/repos/aria2/aria2/releases/latest"
$qubesBaseUrl = "https://mirrors.edge.kernel.org/qubes/iso/"
$qubesVersionRegex = "Qubes-R([0-9.]+)-x86_64"

# Rufus Variables
$rufusReleaseName = "rufus-latest.exe"  # Placeholder, updated dynamically
$rufusPath = "$env:USERPROFILE\Downloads\$rufusReleaseName"

# aria2 Variables
$aria2ReleaseName = "aria2-latest.zip"  # Placeholder, updated dynamically
$aria2ZipPath = "$env:USERPROFILE\Downloads\$aria2ReleaseName"
$aria2ExtractedDir = "$env:USERPROFILE\Downloads\aria2"
$aria2ExePath = ""

# ISO Variables
$qubesIsoPath = "$env:USERPROFILE\Downloads\Qubes.iso"
$qubesSigPath = "$env:USERPROFILE\Downloads\Qubes.sig"
$qubesDigestPath = "$env:USERPROFILE\Downloads\Qubes.DIGESTS"

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
    $aria2Args = "--dir=`"$dirPath`" --out=`"$fileName`" `"$url`""

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

# Function to install aria2
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

# Function to fetch the latest Qubes OS version using regex
function Get-LatestQubesVersion {
    $htmlContent = Invoke-WebRequest -Uri $qubesBaseUrl
    $matches = [regex]::Matches($htmlContent.Content, $qubesVersionRegex)
    if ($matches.Count -gt 0) {
        $latestVersion = $matches[0].Groups[1].Value
        Write-Host "Latest Qubes Version: $latestVersion"
        return $latestVersion
    } else {
        Write-Host "No Qubes versions found. Exiting."
        exit 1
    }
}

# Fetch the latest Qubes version dynamically
$qubesVersion = Get-LatestQubesVersion

# Construct URLs for ISO, signature, and digest
$qubesIsoUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso"
$qubesSigUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso.asc"
$qubesDigestUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso.DIGESTS"

# Debug the URLs
Write-Host "Qubes ISO URL: $qubesIsoUrl"
Write-Host "Qubes Signature URL: $qubesSigUrl"
Write-Host "Qubes Digest URL: $qubesDigestUrl"

# Define output paths
$qubesIsoPath = "$env:USERPROFILE\Downloads\Qubes-R${qubesVersion}-x86_64.iso"
$qubesSigPath = "$env:USERPROFILE\Downloads\Qubes-R${qubesVersion}-x86_64.iso.asc"
$qubesDigestPath = "$env:USERPROFILE\Downloads\Qubes-R${qubesVersion}-x86_64.iso.DIGESTS"

# Install aria2 if needed
Install-Aria2

# Download the Qubes ISO, signature, and digest using aria2
Download-With-Aria2 -url $qubesIsoUrl -outputPath $qubesIsoPath
Download-With-Aria2 -url $qubesSigUrl -outputPath $qubesSigPath
Download-With-Aria2 -url $qubesDigestUrl -outputPath $qubesDigestPath

# Verify the ISO
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

# Instructions to use Rufus
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

# Launch Rufus
Write-Host "Opening Rufus..."
Start-Process -FilePath $rufusPath -NoNewWindow -Wait

Write-Host "Process complete. You can now boot Qubes OS from the USB drive."
