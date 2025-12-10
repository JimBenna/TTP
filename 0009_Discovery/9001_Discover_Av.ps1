# Software Discovery
# Technic ID : T1518.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Software Discovery: Security Software Discovery (T1518.001)"
Write-Output "==============================================================================="
$output_file="$env:PUBLIC\exf\Machine_Protect_status.txt";
$osInfo =Get-CimInstance -ClassName Win32_OperatingSystem;
if ($osInfo.ProductType -eq 1)
    {
    Get-CimInstance -NameSpace "root\SecurityCenter2" -ClassName "AntiVirusProduct" | Out-File -Encoding ascii $output_file -Append 
    Get-MpComputerStatus | Out-File -Encoding ascii $output_file -Append
    }
else
    { 
    Write-Output "Sorry, unable to identify AV Software using wmic command as this command works only on Workstations\" | Out-File -FilePath "$output_file" -Append;
    }
