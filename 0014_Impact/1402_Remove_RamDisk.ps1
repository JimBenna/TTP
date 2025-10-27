# Remove RamDisk
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Remove RamDisk (T1105)"
Write-Output "==============================================================================="
#
try
{
Remove-VirtualDisk -FriendlyName "RamDrive" -ErrorAction -Stop
}
catch 
{
    Write-Error "An error occured while removing RamDrive : $_"
}
