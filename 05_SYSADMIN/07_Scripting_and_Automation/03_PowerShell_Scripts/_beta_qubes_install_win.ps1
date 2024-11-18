########################################################################
# File Name    : qubes_install_win.ps1
# Description  : This script downloads the latest Qubes OS ISO, verifies
#                its signature, and writes it to a selected USB drive on
#                a Windows system using Rufus Portable.
#                The script lists connected USB drives and prompts for 
#                selection. Ensure you choose the correct drive to avoid 
#                data loss.
# Dependencies : PowerShell, Gpg4win, Rufus Portable
# Usage        : • Download and install Gpg4win from https://gpg4win.org
#                • Set execution policy:
#                  Set-ExecutionPolicy Bypass -Scope Process -Force
#                • Execute the script in PowerShell:
#                  C:\Users\User\Downloads\qubes_install_win.ps1
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Variables
$qubesBaseUrl = "https://www.qubes-os.org/downloads/"
$qubesMirrorUrl = "https://mirrors.edge.kernel.org/qubes/iso/"
$qubesKeyUrl = "https://keys.qubes-os.org/keys/qubes-release-4-signing-key.asc"
$rufusPortableUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5p.exe"
$rufusPath = "$env:USERPROFILE\Downloads\rufus-portable.exe"

# Paths for ISO, signature, and GPG key
$qubesIsoPath = "$env:USERPROFILE\Downloads\qubes-latest.iso"
$qubesSigPath = "$env:USERPROFILE\Downloads\qubes-latest.iso.asc"
$qubesKeyPath = "$env:USERPROFILE\Downloads\qubes-release-signing-key.asc"

# Function to download files
function Download-File {
    param (
        [string]$url,
        [string]$outputPath
    )

    Write-Host "Downloading $url..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
    } catch {
        Write-Host "Error downloading $url: $_"
        exit 1
    }
}

# Fetch the latest Qubes OS version using regex
$qubesPage = Invoke-WebRequest -Uri $qubesBaseUrl
$regex = [regex] "Qubes-R([0-9.]+)-x86_64.iso"
$matches = $regex.Matches($qubesPage.Content)

if ($matches.Count -eq 0) {
    Write-Host "Could not detect the latest version of Qubes OS."
    exit 1
}

# Get the latest version
$latestVersion = $matches | Sort-Object -Property Value -Descending | Select-Object -First 1 -ExpandProperty Value
Write-Host ("Latest Qubes OS version detected: " + $latestVersion)

# Construct URLs for ISO and signature
$qubesIsoUrl = "$qubesMirrorUrl$latestVersion"
$qubesSigUrl = "$qubesMirrorUrl$latestVersion.asc"

# Print constructed URLs for verification
Write-Host "Constructed ISO URL: $qubesIsoUrl"
Write-Host "Constructed Signature URL: $qubesSigUrl"

# Download Qubes ISO, signature, and signing key
Download-File -url $qubesIsoUrl -outputPath $qubesIsoPath
Download-File -url $qubesSigUrl -outputPath $qubesSigPath
Download-File -url $qubesKeyUrl -outputPath $qubesKeyPath

# Verify Qubes ISO signature
Write-Host "Verifying Qubes ISO..."
try {
    & gpg --import $qubesKeyPath 2>&1 | Write-Host
    & gpg --verify $qubesSigPath $qubesIsoPath 2>&1 | Write-Host

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Qubes ISO signature verification succeeded."
    } else {
        Write-Host "ERROR! The ISO signature verification failed!"
        exit 1
    }
} catch {
    Write-Host "Error during ISO verification: $_"
    exit 1
}

# Function to check if Rufus Portable is installed
function Check-RufusPortable {
    return Test-Path $rufusPath
}

# Download Rufus Portable if not present
if (-not (Check-RufusPortable)) {
    Write-Host "Fetching Rufus Portable..."
    Download-File -url $rufusPortableUrl -outputPath $rufusPath
}

# List connected USB drives
$usbDrives = Get-WmiObject -Query "SELECT * FROM Win32_DiskDrive WHERE MediaType='Removable Media'"
if ($usbDrives.Count -eq 0) {
    Write-Host "No USB drives found. Please insert a USB drive and try again."
    exit
}

# Display USB drives and prompt user to select one
for ($i = 0; $i -lt $usbDrives.Count; $i++) {
    Write-Host "$i: $($usbDrives[$i].DeviceID) - $($usbDrives[$i].Model)"
}

$usbIndex = Read-Host "Select the USB drive index to use"
if ($usbIndex -ge 0 -and $usbIndex -lt $usbDrives.Count) {
    $selectedUsbDrive = $usbDrives[$usbIndex].DeviceID

    # Confirm USB drive erasure
    $confirmation = Read-Host "Warning: $selectedUsbDrive will be erased. Do you wish to continue? (y/n)"
    if ($confirmation -ne 'y') {
        Write-Host "Operation cancelled."
        exit
    }

    # Launch Rufus Portable
    Write-Host "Launching Rufus Portable..."
    Start-Process -FilePath $rufusPath -NoNewWindow -Wait
    Write-Host "Please follow the instructions below in Rufus:"
    
    Write-Host "1. Select the Qubes ISO file located at: $qubesIsoPath"
    Write-Host "2. Select the target USB drive: $selectedUsbDrive"
    Write-Host "3. After selecting the USB drive, press 'START'."
    Write-Host "4. IMPORTANT: Ensure to select 'Write in DD Image mode' when prompted."

    Write-Host "Once Rufus completes, Qubes OS will be successfully written to the USB drive."
} else {
    Write-Host "Invalid selection."
    exit 1
}

Write-Host "Qubes OS installation to USB drive completed."
