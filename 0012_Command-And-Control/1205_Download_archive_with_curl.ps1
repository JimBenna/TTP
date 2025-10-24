# Downloads fake documents archive
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Command and Control : Ingress Tool Transfer (T1105)"
Write-Output "==============================================================================="
#
$DestinationFile = "$env:USERPROFILE\Documents\fake_Documents.zip";
$DownloadURL="https://github.com/JimBenna/fakedocs/raw/main/fake_Documents.zip";
$CompleteCommand= "curl"+" $DownloadURL"+" -outfile "+"$DestinationFile";
Invoke-Expression  $CompleteCommand;