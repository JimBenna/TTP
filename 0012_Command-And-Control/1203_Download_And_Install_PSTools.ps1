# Download and installs PSTools
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Download and installs PSTools (T1105)"
Write-Output "==============================================================================="
#$ArchiveFile = "PSTools.zip"
$DestinationDirectory = "$env:PUBLIC\PSTools"
$Full_Destination = "$env:PUBLIC\Toolz\$ArchiveFile"
$LogFile = "$env:PUBLIC\exf\pstools_down_extract.txt"; 
$DownloadURL = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$CompleteCommand = "Invoke-WebRequest -Uri" + " $DownloadURL" + " -outfile " + "$Full_Destination";
try {
    Invoke-Expression  "$CompleteCommand";
    Write-Output "Successfully downloaded [$ArchiveFile] to $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    New-Item -ItemType "directory" $DestinationDirectory -Force;
    $psdir = Get-Item "$DestinationDirectory" -Force;
    $psdir.attributes = "hidden";

    if ([System.IO.File]::Exists("$ArchiveFile")) {
        Add-Type -Assembly 'System.IO.Compression.FileSystem';
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$ArchiveFile", "$DestinationDirectory");
        Write-Output "The file [$ArchiveFile] has been extracted to  $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
        Get-ChildItem -Path $DestinationDirectory | Out-File -FilePath $LogFile -Encoding ascii -Append
        exit 0;
    } 
    else {
        Write-Output "The file [$ArchiveFile] does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
        exit 2;
    };

}
catch {
    Write-Output "The download of [$ArchiveFile] has failed : $($_.Exception.Message)" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;   
}