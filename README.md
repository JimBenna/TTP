# Purpose

A bunch of powershell scripts to test some Technics tactics and Procedure.

The purpose of those scripts are to have a several steps testing purpose that simulates an attack.

# Reference

The Mitre | ATT&CK lists [13 tactics](https:||attack.mitre.org|tactics|enterprise|) up to now,
I have then created such numbers of directories to store the scripts, according to the tactics I have written script for.

On the top of each script I have put a coment to refer [to the technic](https:||attack.mitre.org|) it ought to refer to.

# Content

| Directory                | Script                                          | Fully tested | No more update needed |
| :----------------------- | :---------------------------------------------- | :----------: | :-------------------: |
| 0001_Reconnaissance      | 1001_Client_configurations.ps1                  |      ✅      |          👎          |
| 0004_Execution           | 4001_Exctract_archive.ps1                       |      ✅      |          👍          |
| 0004_Execution           | 4002_Transform_capture.ps1                      |     ❗️     |          👎          |
| 0005_Persistence         | 5001_Add_Scheduled_task.ps1                     |     ❗️     |          👎          |
| 0005_Persistence         | 5002_Add_Reg_Key.ps1                            |     ❗️     |          👎          |
| 0005_Persistence         | 5003_Add_service.ps1                            |     ❗️     |          👎          |
| 0007_Defense-Evasion     | 7001_Impair_defenses.ps1                        |     ❗️     |          👎          |
| 0007_Defense-Evasion     | 7002_Patch_Amsi_dll.ps1                         |     ❗️     |          👎          |
| 0007_Defense-Evasion     | 7003_Donwload_Winpeas_Using_Bitsadmin.ps1       |     ❗️     |          👎          |
| 0007_Defense-Evasion     | 7004_Donwload_SharPersist_Using_Bitsadmin.ps1   |     ❗️     |          👎          |
| 0008_Credential-access   | 8001_Packet_capture.ps1                         |     ❗️     |          👎          |
| 0008_Credential-access   | 8002_SharpKatz.ps1                              |     ❗️     |          👎          |
| 0009_Discovery           | 9001_Discover_Av.ps1                            |     ❗️     |          👎          |
| 0009_Discovery           | 9002_Discover_Domain_Controllers.ps1            |     ❗️     |          👎          |
| 0009_Discovery           | 9003_Discover_domain_trust.ps1                  |     ❗️     |          👎          |
| 0009_Discovery           | 9004_Identify_Host_fw.ps1                       |     ❗️     |          👎          |
| 0009_Discovery           | 9005_Identify_local_users.ps1                   |     ❗️     |          👎          |
| 0009_Discovery           | 9006_Network_Information_Gathering.ps1          |     ❗️     |          👎          |
| 0009_Discovery           | 9007_Network_Shares_discovery.ps1               |     ❗️     |          👎          |
| 0009_Discovery           | 9008_Process_discovery.ps1                      |     ❗️     |          👎          |
| 0009_Discovery           | 9009_Launch_Soron.ps1                           |     ❗️     |          👎          |
| 0009_Discovery           | 9010_WinPEAS_Browser_info.ps1                   |     ❗️     |          👎          |
| 0009_Discovery           | 9011_WinPEAS_Network_info.ps1                   |     ❗️     |          👎          |
| 0009_Discovery           | 9012_WinPEAS_system_info.ps1                    |     ❗️     |          👎          |
| 0011_Collection          | 1100_Create_Hidden_directories.ps1              |     ❗️     |          👎          |
| 0011_Collection          | 1101_Collect_public_ip_addresses.ps1            |     ❗️     |          👎          |
| 0011_Collection          | 1102_SystemInfo.ps1                             |     ❗️     |          👎          |
| 0011_Collection          | 1103_Software_List_Discovery.ps1                |     ❗️     |          👎          |
| 0011_Collection          | 1104_Compress_Directory_Content.ps1             |     ❗️     |          👎          |
| 0012_Command-And-Control | 1201_Download_archive_with_curl.ps1             |     ❗️     |          👎          |
| 0012_Command-And-Control | 1202_Download_Mimikatz.ps1                      |     ❗️     |          👎          |
| 0012_Command-And-Control | 1203_Download_And_Install_PSTools.ps1           |     ❗️     |          👎          |
| 0012_Command-And-Control | 1204_Download_Several_Compiled_Attack_Tools.ps1 |     ❗️     |          👎          |
| 0013_Exfiltration        | 1301_Exfiltration_using_scp.ps1                 |     ❗️     |          👎          |
| 0013_Exfiltration        | 1302_Exfiltration_over_ftp.ps1                  |     ❗️     |          👎          |
| 0014_Impact              | 1401_Create_RamDisk.ps1                         |     ❗️     |          👎          |
| 0014_Impact              | 1402_Remove_RamDisk.ps1                         |     ❗️     |          👎          |
| 0014_Impact              | 1403_Change_BackGround.ps1                      |     ❗️     |          👎          |
