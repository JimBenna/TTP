# Identify Firewalls and save list to a file
# Technic ID : T1518.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Software Discovery: Security Software Discovery (T1518.001)"
Write-Output "==============================================================================="
#
$output_file = "$env:PUBLIC\exf\firewall_identification.txt\"; 
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem;
if ($osInfo.ProductType -eq 1)
{
    $NameSpace = Get-WmiObject -Namespace "root" -Class "__Namespace\" | Select Name | Out-String -Stream | Select-String "SecurityCenter";
    $SecurityCenter = $NameSpace | Select-Object -First 1; 
    Get-WmiObject -Namespace "root\$SecurityCenter" -Class AntiVirusProduct | Select DisplayName, InstanceGuid, PathToSignedProductExe, PathToSignedReportingExe, ProductState, Timestamp | Format-List >$output_file;
}
else
{
    Write-Output "This command only works on a Workstation, and you're launching that on a server, so no output is expected" | Out-File -FilePath "$output_file" -Append;
}