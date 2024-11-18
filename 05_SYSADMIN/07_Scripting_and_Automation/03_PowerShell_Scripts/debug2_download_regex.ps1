# Define the actual Qubes version you're downloading (e.g., 4.1.2)
$qubesVersion = "4.2.2"

# Define the base URL for Qubes downloads
$qubesBaseUrl = "https://mirrors.edge.kernel.org/qubes/iso/"

# File paths
$qubesIsoPath = "$env:USERPROFILE\Downloads\Qubes-R$($qubesVersion)-x86_64.iso"
$qubesSigPath = "$env:USERPROFILE\Downloads\Qubes-R$($qubesVersion)-x86_64.iso.asc"
$qubesDigestPath = "$env:USERPROFILE\Downloads\Qubes-R$($qubesVersion)-x86_64.iso.DIGESTS"

# Construct the correct URLs by inserting the version number
$qubesIsoUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso"
$qubesSigUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso.asc"
$qubesDigestUrl = "${qubesBaseUrl}Qubes-R${qubesVersion}-x86_64.iso.DIGESTS"

# Log URLs to confirm correctness
Write-Host "ISO URL: $qubesIsoUrl"
Write-Host "Signature URL: $qubesSigUrl"
Write-Host "Digest URL: $qubesDigestUrl"

# Function to download using aria2
function Download-With-Aria2 {
    param (
        [string]$url,
        [string]$outputPath
    )

    Write-Host "Starting download with aria2: $url"
    try {
        & "$aria2ExePath" --dir="$($env:USERPROFILE)\Downloads" --out="$(Split-Path -Path $outputPath -Leaf)" $url
        Write-Host "Download completed: $outputPath"
    } catch {
        Write-Host "Error during download with aria2: $_"
        exit 1
    }
}

# Download the Qubes ISO, signature, and digest using aria2
Download-With-Aria2 -url $qubesIsoUrl -outputPath $qubesIsoPath
Download-With-Aria2 -url $qubesSigUrl -outputPath $qubesSigPath
Download-With-Aria2 -url $qubesDigestUrl -outputPath $qubesDigestPath

# Verifying the ISO using gpg
Write-Host "Verifying Qubes ISO..."
try {
    if (gpg --verify $qubesSigPath $qubesIsoPath) {
        Write-Host "The ISO is verified."
    } else {
        Write-Host "ERROR! The ISO does not seem to be signed by the Qubes key. Something is wrong!"
        exit 1
    }
} catch {
    Write-Host "Error verifying ISO: $($_.Exception.Message)"
    exit 1
}

Write-Host "Qubes installation files are ready."
