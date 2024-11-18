# Function to list all drives with details
function List-AllDrives {
    # Retrieve all drives and format them into a custom object with manual index assignment
    $drives = [System.IO.DriveInfo]::GetDrives() | ForEach-Object -Begin { $index = 0 } -Process {
        [PSCustomObject]@{
            Index  = $index
            Name   = $_.Name
            Type   = if ($_.DriveType -eq 'Removable') {'Removable'} else {'Fixed'}
            Format = $_.DriveFormat
            Label  = $_.VolumeLabel
        }
        $index++
    }
    return $drives
}

# Main Script
Write-Host "Starting drive test..."
$allDrives = List-AllDrives

# Debugging Step: Check the value of $allDrives to ensure it's populated
Write-Host "Debug: Checking `\$allDrives after function call..."
if ($allDrives -ne $null) {
    Write-Host "Debug: `\$allDrives content:"
    $allDrives | Format-Table -AutoSize  # Display as a formatted table for better clarity
}

# Check if there are valid drives
if ($allDrives -ne $null -and $allDrives.Count -gt 0) {
    Write-Host "Debug: All Drives count: $($allDrives.Count)"
    Write-Host "Available Drives:"
    $allDrives | ForEach-Object {
        Write-Host ("[" + $_.Index + "] Drive: " + $_.Name + " - Type: " + $_.Type + " - Format: " + $_.Format + " - Label: " + $_.Label)
    }

    # Initialize $parsedSelection
    $parsedSelection = 0  # Initialize with a default value

    $userSelection = Read-Host "Please enter the number of the drive to write Tails to"
    if ([int]::TryParse($userSelection, [ref]$parsedSelection) -and $parsedSelection -ge 0 -and $parsedSelection -lt $allDrives.Count) {
        $selectedDrive = $allDrives[$parsedSelection]
        Write-Host ("Selected Drive: " + $selectedDrive.Name)

        # Write Tails ISO to the selected drive using dd
        $driveLetter = $selectedDrive.Name.TrimEnd('\')
        Write-Host "Drive Letter: $driveLetter"
        
        # Example paths; replace these with your actual paths
        $ddPath = "$env:USERPROFILE\Downloads\ddrelease64.exe"
        $tailsIsoPath = "$env:USERPROFILE\Downloads\tails.iso"
        
        Write-Host "Writing Tails to the drive using dd..."
        $ddCommand = "& `"$ddPath`" if=`"$tailsIsoPath`" of=`"$driveLetter`" bs=4M --progress"
        Write-Host "Running command: $ddCommand"
        Invoke-Expression $ddCommand
        
        Write-Host "Tails has been successfully written to the selected drive."
    } else {
        Write-Host "Invalid selection."
    }
} else {
    Write-Host "No drives to select from. Exiting."
}
