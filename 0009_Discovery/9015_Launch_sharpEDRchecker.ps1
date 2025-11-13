# Identify EDR
# Technic ID : T1083
Clear-Host
Write-Output "==============================================================================="
Write-Output "Identify EDR (T1083)"
Write-Output "==============================================================================="
#
$EdrChecker = "$env:PUBLIC\Toolz\SharpEdrChecker.exe";
$EdrCheckerLogFile = "$env:PUBLIC\exf\EdrChecker.txt";
if ([System.IO.File]::Exists("$EdrChecker")) 
    {
        Write-Output "GREAT. The command $EdrChecker has been found :-)" | Out-File -FilePath "$EdrCheckerLogFile"-Encoding ascii -Append;
        $ServiceCmd = "$EdrChecker";
        Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$EdrCheckerLogFile" -Append -Encoding ascii;
        exit 0;
    }
else 
    {
        Write-Output "The command $EdrChecker does not exists !!!" | Out-File -FilePath "$EdrCheckerLogFile" -Encoding ascii -Append;
        exit 1;
    };