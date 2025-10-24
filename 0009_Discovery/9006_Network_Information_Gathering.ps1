# Network config Discovery
# Technic ID : T1016
Clear-Host
Write-Output "==============================================================================="
Write-Output "System Network Configuration Discovery (T1016)"
Write-Output "==============================================================================="
#
Start-Process -Filepath "cmd.exe" -ArgumentList "/c ipconfig /all >%PUBLIC%\exf\network_info.txt" -NoNewWindow -Wait
Start-Process -Filepath "cmd.exe" -ArgumentList "/c netsh interface show interface >>%PUBLIC%\exf\network_info.txt" -NoNewWindow -Wait
Start-Process -Filepath "cmd.exe" -ArgumentList "/c arp -a >>%PUBLIC%\exf\network_info.txt" -NoNewWindow -Wait
Start-Process -Filepath "cmd.exe" -ArgumentList "/c nbtstat -n >>%PUBLIC%\exf\network_info.txt" -NoNewWindow -Wait
Start-Process -Filepath "cmd.exe" -ArgumentList "/c net config >>%PUBLIC%\exf\network_info.txt" -NoNewWindow -Wait
