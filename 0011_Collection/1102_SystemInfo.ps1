# Collects all system info command details in a file
# Technic ID : T1119
Clear-Host
Write-Output "==============================================================================="
Write-Output "Collects all system info command output in a file (T1119)"
Write-Output "==============================================================================="
#
$SystemInfoLogFile = "$env:PUBLIC\exf\system_info.txt";
Start-Process "systeminfo.exe" -ArgumentList "/fo list" -RedirectStandardOutput $SystemInfoLogFile -WindowStyle hidden -Wait