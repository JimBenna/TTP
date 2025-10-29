# Domain Trust Discovery
# Technic ID : T1018
Clear-Host
Write-Output "==============================================================================="
Write-Output "Remote system discovery (T1018)"
Write-Output "Identify the remote domain controllers and save the information to a file"
Write-Output "==============================================================================="
#
Start-Process -Filepath "cmd.exe" -ArgumentList "/c nltest /dsgetdc:$env:USERDOMAIN >$env:PUBLIC\exf\Domain_controllers.txt" -WindowStyle Hidden -Wait
