# Launch WINPEAS : System information Discovery
# Technic ID : T1082
Clear-Host
Write-Output "==============================================================================="
Write-Output "System information Discovery (T1082)"
Write-Output "==============================================================================="
#
$WinPEAS = "$env:PUBLIC\Toolz\winPEASany_ofs.exe";
$exf_file ="$env:PUBLIC\exf\PEAS_systeminfo.log"; 
if ([System.IO.File]::Exists("$WinPEAS"))
    {
        $CompleteCommand= "$WinPEAS"+" quiet systeminfo "+"log=$exf_file"; 
        Invoke-Expression  "$CompleteCommand";
        exit 0; 
    } 
else
    {
   Write-Output "The file $WinPEAS does not exists !!!" | Out-File -FilePath "$exf_file";
    exit 1; 
    };