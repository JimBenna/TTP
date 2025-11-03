# Launch WINPEAS : System Network Configuration Discovery
# Technic ID : T1016
Clear-Host
Write-Output "==============================================================================="
Write-Output "System Network Configuration Discovery (T1016)"
Write-Output "==============================================================================="
#
$WinPEAS = "$env:PUBLIC\Toolz\winPEASany_ofs.exe";
$exf_file ="$env:PUBLIC\exf\PEAS_networkinfo.txt"; 
if ([System.IO.File]::Exists("$WinPEAS"))
    {
        $CompleteCommand= "$WinPEAS"+" quiet networkinfo "+"log=$exf_file"; 
        Invoke-Expression  "$CompleteCommand";
        exit 0; 
    } 
else
    {
    Write-Output "The file $WinPEAS does not exists !!!" | Out-File -FilePath "$exf_file" -Encoding ascii -Append;
    exit 1; 
    };
