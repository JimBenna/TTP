# Process Discovery
# Technic ID : T1057
Clear-Host
Write-Output "==============================================================================="
Write-Output "Process Discovery (T1057)"
Write-Output "==============================================================================="
#
Start-Process -Filepath "cmd.exe" -ArgumentList "/c tasklist /m  >> $env:PUBLIC\exf\Process_list.txt" -NoNewWindow -Wait
