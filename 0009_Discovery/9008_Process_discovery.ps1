# Process Discovery
# Technic ID : T1057
Clear-Host
Write-Output "==============================================================================="
Write-Output "Process Discovery (T1057)"
Write-Output "==============================================================================="
#
$ProcessInfoLogFile = "$env:PUBLIC\exf\Process_list.txt";
Start-Process -Filepath "cmd.exe" -ArgumentList "/c tasklist /m" -RedirectStandardOutput $ProcessInfoLogFile  -WindowStyle Hidden -Wait
