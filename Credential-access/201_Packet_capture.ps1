# Packet Capture
# Technic ID : T1040
Clear-Host
Write-Output "==============================================================================="
Write-Output "Packets capture (T1040)"
Write-Output "==============================================================================="
#
$Destination_file="$env:PUBLIC\exf\capture.etl";
Invoke-Expression "netsh trace start capture=yes tracefile=$Destination_file";
Start-Sleep -s 60;
Invoke-Expression "netsh trace stop";