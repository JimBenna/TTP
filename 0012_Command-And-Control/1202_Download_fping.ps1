# Downloads fake documents archive
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Command and Control : Ingress Tool Transfer (T1105)"
Write-Output "==============================================================================="
#
$ArchiveFile = "fping.zip"
$DestinationDirectory = "$env:PUBLIC\Toolz"
$Full_Destination = "$DestinationDirectory"+"\"+"$ArchiveFile"
$LogFile = "$env:PUBLIC\exf\fping_down_extract.txt"; 
$DownloadURL = "https://github.com/dexit/fping-windows/releases/download/fping-4-2-win-binary/fping_x64_4.2.zip"
$CompleteCommand = "Invoke-WebRequest -Uri" + " $DownloadURL" + " -outfile " + "$Full_Destination";
try {
    Invoke-Expression  "$CompleteCommand";
    Write-Output "Successfully downloaded [$ArchiveFile] to $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 

    if ([System.IO.File]::Exists("$Full_Destination")) {
        Add-Type -Assembly 'System.IO.Compression.FileSystem';
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$Full_Destination", "$DestinationDirectory");
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