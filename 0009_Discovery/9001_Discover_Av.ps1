# Software Discovery
# Technic ID : T1518.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Software Discovery: Security Software Discovery (T1518.001)"
Write-Output "==============================================================================="
#
$output_file="$env:PUBLIC\exf\Av_products_list.txt";
$osInfo =Get-CimInstance -ClassName Win32_OperatingSystem;
if ($osInfo.ProductType -eq 1)
    {
    wmic NAMESPACE:\\root\SecurityCenter2 PATH AntiVirusProduct GET /value >$output_file; 
    }
else
    { 
    Write-Output "Sorry, unable to identify AV Software using wmic command as this command works only on Workstations\" | Out-File -FilePath "$output_file" -Append;
    }
Get-MpComputerStatus | Out-File -Encoding ascii $env:PUBLIC\exf\Windows_Defender_status.txt