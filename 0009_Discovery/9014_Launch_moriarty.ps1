# Scan for vulnerabilities
# Technic ID : T1083
Clear-Host
Write-Output "==============================================================================="
Write-Output "Search for vulns (T1083)"
Write-Output "==============================================================================="
#
$Moriarty = "$env:PUBLIC\Toolz\moriarty.exe";
$MoriartyLogFile = "$env:PUBLIC\exf\moriarty.txt";
if ([System.IO.File]::Exists("$Moriarty")) 
    {
        Write-Output "GREAT. The command $Moriarty has been found :-)" | Out-File -FilePath "$MoriartyLogFile"-Encoding ascii -Append;
        $ServiceCmd = "$Moriarty";
        Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$MoriartyLogFile" -Append -Encoding ascii;
        exit 0;
    }
else 
    {
        Write-Output "The command $Moriarty does not exists !!!" | Out-File -FilePath "$MoriartyLogFile" -Encoding ascii -Append;
        exit 1;
    };