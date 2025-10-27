# Extract archive
# Technic ID : T1059.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Extract archive (T1059.001)"
Write-Output "==============================================================================="
#
$ArchiveFile = "$env:USERPROFILE\Documents\fake_Documents.zip";
$DestinationDirectory = "$env:USERPROFILE\Documents\";
$LogFile = "$env:PUBLIC\exf\extract_zip.log";
if ([System.IO.File]::Exists("$ArchiveFile")) {
    Add-Type -Assembly 'System.IO.Compression.FileSystem';
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$ArchiveFile", "$DestinationDirectory");
    exit 0;
} 
else {
    Write-Output "The file ["$ArchiveFile"] does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;
};