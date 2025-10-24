# Scheduled Task
# Technic ID : T1053.005
Clear-Host
Write-Output "==============================================================================="
Write-Output "Scheduled Task/Job: Scheduled Task (T1053.005)"
Write-Output "==============================================================================="
#
Start-Process "cmd.exe" -ArgumentList "/c SCHTASKS /Create /SC DAILY /TN \"Launch Secret agent\" /ST 11:45 /TR \"<command>\"" -NoNewWindow -Wait