# Create RamDisk
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Create RamDisk (T1105)"
Write-Output "==============================================================================="
#
try
{
$RamDriveSize = 512MB
$RamDrive = New-VirtualDisk -FriendlyName "RamDrive" -Size $RamDriveSize -StoragePoolFriendlyName "Primordial"

if (-not $RamDrive)
{
throw "Creation of RamDrive failed. Maybe no sufficient memory available"
}
Intialize-Disk -Number $RamDrive.Number -PartitionStyle GPT -ErrorAction -Stop
New-Partition -DiskNumber $RamDrive.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel "RamDrive" -ErrorAction -Stop

write-host "RamDrive created and ready"
}
catch 
{
    Write-Error "An error occured during RamDrive createion: $_"
}
