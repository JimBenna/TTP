# Identify Local Users
# Technic ID : T1518.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Account Discovery: Local Account (T1087.001)"
Write-Output "==============================================================================="
#
Get-WmiObject -Class Win32_UserAccount >$env:PUBLIC\exf\local_users.txt