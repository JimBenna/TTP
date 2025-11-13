# Emulates Persistence tactics with PurpleShark
Clear-Host
Write-Output "==============================================================================="
Write-Output "Executes the following commands to emulate tactics : "
Write-Output "T1053.005 Scheduled Task/Job: Scheduled Task"
Write-Output "T1136.001 - Create Account: Local Account"
Write-Output "T1543.003 - Create or Modify System Process: Windows Service"
Write-Output "T1547.001 - Boot or Logon Autostart Execution: Registry Run Keys"
Write-Output "T1546.003 - Event Triggered Execution: Windows Management Instrumentation Event Subscription"
Write-Output "==============================================================================="
#
$PurpleTactics = "$env:PUBLIC\Toolz\purplesharp.exe";
$PurpleLogFile = "$env:PUBLIC\exf\PurpleReco.txt";
$Tactic = @("T1053.005", "T1136.001", "T1543.003", "T1547.001", "T1546.003");

if ([System.IO.File]::Exists("$PurpleTactics")) {
    Write-Output "GREAT. The command $PurpleTactics has been found :-)" | Out-File -FilePath "$PurpleLogFile"-Encoding ascii -Append;
    try {
        foreach ($Command in $Tactic) {
            $ServiceCmd = "$PurpleTactics /t" + " " + $Command;
            Write-Output "Launch command : " $ServiceCmd  | Out-File -FilePath "$PurpleLogFile" -Append -Encoding ascii;
            Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$PurpleLogFile" -Append -Encoding ascii;
        }
    }
    catch {
        Write-Output "Error while excecuting command $ServiceCmd error code : $($_.Exception.Message)" | Out-File -FilePath "$PurpleLogFile" -Encoding ascii -Append;
        exit 2;      
    }                        
    exit 0;
}
else {
    Write-Output "The command $SharpKatz does not exists !!!" | Out-File -FilePath "$SharpKatzLogFile" -Encoding ascii -Append;
    exit 1;
};