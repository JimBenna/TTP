# Domain Trust Discovery
# Technic ID : T1482
Clear-Host
Write-Output "==============================================================================="
Write-Output "Domain Trust Discovery with encoded command (T1482)"
Write-Output "==============================================================================="
#
Start-Process -Filepath "powershell.exe" -ArgumentList "-EncodedCommand bgBsAHQAZQBzAHQAIAAvAGQAbwBtAGEAaQBuAF8AdAByAHUAcwB0AHMA" -WindowStyle Hidden -Wait