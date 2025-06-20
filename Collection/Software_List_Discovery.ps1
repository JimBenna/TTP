# Collect Software List Discovery
# Technic ID : T1059.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Collects IP Addreses and IP GeoLocation (T1059.001)"
Write-Output "==============================================================================="
#
$Installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate;
$Installed += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate;
$Installed | ?{ $_.DisplayName -ne $null } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize > $env:PUBLIC\exf\installed_Apps_List.txt;
Get-Hotfix | Sort InstalledOn | Format-Table -Autosize > $env:PUBLIC\exf\installed_hotfixes_list.txt;