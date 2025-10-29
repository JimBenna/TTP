# Download and installs PSTools
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Download and installs PSTools (T1105)"
Write-Output "==============================================================================="
#
$ArchiveFile = "PSTools.zip"
$DestinationDirectory = "$env:PUBLIC\PSTools"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $True };
$web = (New-Object System.Net.WebClient);
$result = $web.DownloadFile("https://download.sysinternals.com/files/PSTools.zip", "$ArchiveFile");
New-Item -ItemType "directory" $DestinationDirectory -Force;
$psdir=Get-Item "$DestinationDirectory" -Force;
$psdir.attributes="hidden";

if ([System.IO.File]::Exists("$ArchiveFile")) {
    Add-Type -Assembly 'System.IO.Compression.FileSystem';
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$ArchiveFile", "$DestinationDirectory");
    exit 0;
} 
else {
    Write-Output "The file ["$ArchiveFile"] does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;
};

