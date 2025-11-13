# Emulates Defense Evasion tactics with PurpleShark
Clear-Host
Write-Output "==============================================================================="
Write-Output "Executes the following commands to emulate tactics : "
Write-Output "T1220 XSL - Script Processing"
Write-Output "T1218.003 - Signed Binary Proxy Execution: CMSTP"
Write-Output "T1218.005 - Signed Binary Proxy Execution: Mshta"
Write-Output "T1140     - Deobfuscate/Decode Files or Information"
Write-Output "T1218.004 - Signed Binary Proxy Execution: InstallUtil"
Write-Output "T1218.009 - Signed Binary Proxy Execution: Regsvcs/Regasm"
Write-Output "T1218.010 - Signed Binary Proxy Execution: Regsvr32"
Write-Output "==============================================================================="
#
$PurpleTactics = "$env:PUBLIC\Toolz\purplesharp.exe";
$PurpleLogFile = "$env:PUBLIC\exf\Purple_Evasion.txt";
$Tactic = @("T1053.005", "T1218.003", "T1218.005", "T1140", "T1218.009", "T1218.010","T1218.004");

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