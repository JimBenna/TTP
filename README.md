# Purpose

A bunch of powershell scripts to test some Technics Tactics & Procedures.

The purpose of those scripts are to have a several steps testing purpose that simulates an attack.

# Reference

The Mitre  ATT&CK lists [13 tactics](https://attack.mitre.org/tactics/enterprise) up to now,
I have then created such numbers of directories to store the scripts, according to the tactics I have written script for.

On the top of each script I have put a coment to refer [to the technic](https://attack.mitre.org) it ought to refer to.

# Content

The scripts ought to be called in the following order.

| Step Number | Directory                | Script                                          | Fully tested | No more update needed | Comment |
|:---------:|:-----------------------|:---------------------------------------------|:------:|:-------------------:|:------|
| 01          | 0011_Collection          | 1100_Create_Hidden_directories.ps1              |     ✅    |          👍          | |
| 02          | 0012_Command-And-Control | 1201_Download_archive_with_curl.ps1             |     ✅    |          👍          | |
| 03          | 0004_Execution           | 4001_Exctract_archive.ps1                       |     ✅    |          👍          | |
| 04          | 0007_Defense-Evasion     | 7002_Patch_Amsi_dll.ps1                         |     ✅    |          👍          | |
| 05          | 0014_Impact              | 1401_Create_RamDisk.ps1                         |     ❗️     |          👎          |  Don't work at all |
| 06          | 0007_Defense-Evasion     | 7001_Impair_defenses.ps1                        |     ✅    |          👍          | |
| 07          | 0009_Discovery           | 9001_Discover_Av.ps1                            |     ❗️     |          👎          |Does not work |
| 08          | 0009_Discovery           | 9002_Discover_Domain_Controllers.ps1            |     ✅    |          👎          | Upgrade needed |
| 09          | 0009_Discovery           | 9003_Discover_domain_trust.ps1                  |     ✅    |          👎          | More logs needed |
| 10          | 0009_Discovery           | 9004_Identify_Host_fw.ps1                       |     ❗️     |          👎          | Does not work |
| 11          | 0009_Discovery           | 9005_Identify_local_users.ps1                   |     ✅    |          👍          | |
| 12          | 0009_Discovery           | 9006_Network_Information_Gathering.ps1          |     ✅    |          👎          | More logs needed |
| 13          | 0009_Discovery           | 9007_Network_Shares_discovery.ps1               |     ✅    |          👍          | |
| 14          | 0009_Discovery           | 9008_Process_discovery.ps1                      |     ✅    |          👍          | |
| 15          | 0011_Collection          | 1101_Collect_public_ip_addresses.ps1            |     ✅    |          👍          | |
| 16          | 0011_Collection          | 1102_SystemInfo.ps1                             |     ✅    |          👍          | |
| 17          | 0011_Collection          | 1103_Software_List_Discovery.ps1                |     ✅    |          👍          | |
| 18          | 0012_Command-And-Control | 1202_Download_Mimikatz.ps1                      |     ✅    |          👎          | |
| 19          | 0012_Command-And-Control | 1203_Download_And_Install_PSTools.ps1           |     ✅    |          👍          | |
| 20          | 0012_Command-And-Control | 1204_Download_Several_Compiled_Attack_Tools.ps1 |     ✅    |          👍          | |
| 21          | 0007_Defense-Evasion     | 7003_Donwload_Winpeas_Using_Bitsadmin.ps1       |     ❗️     |          👎          | Needs to use Pwsh |
| 22          | 0007_Defense-Evasion     | 7004_Donwload_SharPersist_Using_Bitsadmin.ps1   |     ✅    |          👍          | |
| 23          | 0001_Reconnaissance      | 1001_Client_configurations.ps1                  |     ✅    |          👍          | |
| 24          | 0008_Credential-access   | 8002_SharpKatz.ps1                              |     ✅    |          👎          | |
| 25          | 0008_Credential-access   | 8003_Better_SafetyKatz.ps1                      |     ✅    |          👎          | |
| 26          | 0009_Discovery           | 9009_Launch_Soron.ps1                           |     ✅    |          👍          | |
| 27          | 0009_Discovery           | 9014_Launch_moriarty.ps1                        |     ✅    |          👍          | |
| 28          | 0009_Discovery           | 9015_Launch_sharpEDRchecker.ps1                 |     ✅    |          👍          | |
| 29          | 0009_Discovery           | 9010_WinPEAS_Browser_info.ps1                   |     ✅    |          👍          | |
| 30          | 0009_Discovery           | 9011_WinPEAS_Network_info.ps1                   |     ✅    |          👍          | |
| 31          | 0009_Discovery           | 9012_WinPEAS_system_info.ps1                    |     ✅    |          👍          | |
| 32          | 0009_Discovery           | 9013_Subnet_Information_And_Scan.ps1            |     ✅    |          👍          | |
| 33          | 0008_Credential-access   | 8001_Packet_capture.ps1                         |     ✅    |          👎          | |
| 34          | 0008_Credential-access   | 8004_Purple_credz_access.ps1                    |     ✅    |          👍          | |
| 35          | 0004_Execution           | 4002_Transform_capture.ps1                      |     ✅    |          👍          | |
| 36          | 0004_Execution           | 4003_Purple_Exec.ps1                            |     ✅    |          👍          | |
| 37          | 0005_Persistence         | 5001_Add_Scheduled_task.ps1                     |     ❗️     |          👎          | |
| 38          | 0005_Persistence         | 5003_Add_service.ps1                            |     ❗️     |          👎          | |
| 39          | 0005_Persistence         | 5002_Add_Reg_Key.ps1                            |     ❗️     |          👎          | |
| 40          | 0005_Persistence         | 5004_Purple_persist.ps1                         |     ✅    |          👍          | |
| 41          | 0007_Defense-Evasion     | 7005_Purple_evasion.ps1                         |     ✅    |          👍          | |
| 42          | 0011_Collection          | 1104_Compress_Directory_Content.ps1             |     ✅    |          👍          | |
| 43          | 0013_Exfiltration        | 1301_Exfiltration_using_scp.ps1                 |     ❗️     |          👎          | |
| 44          | 0013_Exfiltration        | 1302_Exfiltration_over_ftp.ps1                  |     ❗️     |          👎          | |
| 45          | 0014_Impact              | 1402_Remove_RamDisk.ps1                         |     ❗️     |          👎          |Not working |
| 46          | 0014_Impact              | 1405_Download_note.ps1                          |     ✅    |          👍          | |
| 47          | 0014_Impact              | 1403_Change_BackGround.ps1                      |     ✅    |          👍          | |

# Usage
Please follow the following steps.

1. Copy the following command lines
```powershell
$StorageDir = "$env:PUBLIC\Pwsh_Test_Scripts"
New-Item -ItemType directory -Path $StorageDir
$DestinationFile = "$StorageDir\pwsh_archive_scripts.zip"
$DownloadURL="https://github.com/JimBenna/TTP/archive/refs/heads/main.zip"
Invoke-WebRequest -Uri $DownloadURL -OutFile $DestinationFile
Expand-Archive -Path $DestinationFile -DestinationPath $StorageDir👎

```

2. Paste those command lines in a powershell
3. Those commands will do thee following tasks.
* Create a directory
* Download the ZIP archive that contains all the scripts
* Extracts all the files from the archive


:information_source: You may have to adapt Script Execution policy to allow powershell scripts execution.
see [Microsoft article](https://learn.microsoft.com/) to get furter details.
```powershell
Get-ExecutionPolicy -List
```
And to correct this for Current user use 
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -scope CurrentUser
```