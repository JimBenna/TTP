# Add Reg Keys
# Group Policy MOdification
# Technic ID : T1484.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Add Regsitry keys (Group Policy Modification)  (T1484.001)"
Write-Output "==============================================================================="
################ [ GLOBAL VARIABLES ] ################
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff K"
$LogFile = "$env:PUBLIC\exf\Group_modificaiton_policy.txt";
################ [ Main Script Execution ] ################
Write-Output "`n" | Out-File -FilePath "$LogFile" -Encoding utf8 -Force
Write-Output "Add Regsitry keys (Group Policy Modification)" | Out-File -FilePath "$LogFile" -Encoding utf8 -Append
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name GroupPolicyRefreshTimeDC -PropertyType DWord -Value 0 -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name GroupPolicyRefreshTimeOffsetDC -PropertyType DWord -Value 0 -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name GroupPolicyRefreshTime -PropertyType DWord -Value 0 -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name GroupPolicyRefreshTimeOffset -PropertyType DWord -Value 0 -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name EnableSmartScreen -PropertyType DWord -Value 0 -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name ShellSmartScreenLevel -Force