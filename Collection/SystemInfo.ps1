# Collects all system info command details in a file
# Technic ID : T1119
Clear-Host
Write-Output "==============================================================================="
Write-Output "Collects IP Addreses and IP GeoLocation (T1119)"
Write-Output "==============================================================================="
#
systeminfo /fo list >%PUBLIC%\exf\systeminfo.txt