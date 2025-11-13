# Emulates Credential Access tactics with PurpleShark
Clear-Host
Write-Output "==============================================================================="
Write-Output "Executes the following commands to emulate tactics : "
Write-Output "T1003.001 - OS Credential Dumping: LSASS Memory"
Write-Output "==============================================================================="
#
$PurpleTactics = "$env:PUBLIC\Toolz\purplesharp.exe";
$PurpleLogFile = "$env:PUBLIC\exf\Purple_Credz.txt";
$Tactic = @("T1003.001");

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