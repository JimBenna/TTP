# Emulates Execution tactics with PurpleShark
Clear-Host
Write-Output "==============================================================================="
Write-Output "Executes the following commands to emulate tactics : "
Write-Output "T1059.001 : Command and Scripting Interpreter: PowerShell"
Write-Output "T1059.003 : Command and Scripting Interpreter: Windows Command Shell"
Write-Output "T1059.005 : Command and Scripting Interpreter: Visual Basic"
Write-Output "T1059.007 : Command and Scripting Interpreter: JavaScript/JScript"
Write-Output "T1569.002 : System Services: Service Execution"
Write-Output "==============================================================================="
#
$PurpleTactics = "$env:PUBLIC\Toolz\purplesharp.exe";
$PurpleLogFile = "$env:PUBLIC\exf\PurpleReco.txt";
$Tactic = @("T1059.001", "T1059.003", "T1059.005", "T1059.007", "1569.002");

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
    Write-Output "The file $PurpleTactics does not exists !!!" | Out-File -FilePath "$PurpleLogFile" -Encoding ascii -Append;
    exit 1;
};