# Network Share Discovery
# Technic ID : T1135
Clear-Host
Write-Output "==============================================================================="
Write-Output "Network Share Discovery (T1135)"
Write-Output "==============================================================================="
#
Get-SmbShare | ConvertTo-Json >$env:PUBLIC\exf\smbshares.txt