# Launch WINPEAS : Browser bookmark Discovery
# Technic ID : T1217
Clear-Host
Write-Output "==============================================================================="
Write-Output "Browser bookmark Discovery (T1217)"
Write-Output "==============================================================================="
#
$WinPEAS = "$env:PUBLIC\Toolz\winPEASany_ofs.exe";
$exf_file ="$env:PUBLIC\exf\PEAS_browserinfo.log"; 
if ([System.IO.File]::Exists("$WinPEAS"))
    {
        $CompleteCommand= "$WinPEAS"+" quiet browserinfo "+"log=$exf_file"; 
        Invoke-Expression  "$CompleteCommand";
        exit 0; 
    } 
else
    {
    "The file $WinPEAS does not exists !!!" | Out-File -FilePath "$exf_file";
    exit 1; 
    };