# File and Directory Discovery
# Technic ID : T1083
Clear-Host
Write-Output "==============================================================================="
Write-Output "File and Directory Discovery (T1083)"
Write-Output "==============================================================================="
#
$Sauron = "$env:PUBLIC\Toolz\SauronEye.exe";
$SauronEyeLogFile = "$env:PUBLIC\exf\SauronEye.log";
if ([System.IO.File]::Exists("$Sauron")) 
    {
        Write-Output "GREAT. The command $Sauron has been found :-)" | Out-File -FilePath "$SauronEyeLogFile";
        $ServiceCmd = "$Sauron --filetypes .txt .doc .docx .xls --contents --keywords password pass* Pas* -v -s";
        Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$SauronEyeLogFile" -Append;
        exit 0;
    }
else 
    {
        Write-Output "The command $Sauron does not exists !!!" | Out-File -FilePath "$SauronEyeLogFile";
        exit 1;
    };