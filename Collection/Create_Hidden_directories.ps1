# Create Hidden directories
# Technic ID : T1134.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Create Hidden directories (T1134.001)"
Write-Output "==============================================================================="
New-Item -ItemType directory -Path "$env:PUBLIC\exf";
$hidden_dir=Get-Item "$env:PUBLIC\exf" -Force;
$hidden_dir.attributes="Hidden";
New-Item -ItemType directory -Path "$env:PUBLIC\Toolz";
$hidden_Toolz_dir=Get-Item "$env:PUBLIC\Toolz" -Force;
$hidden_Toolz_dir.attributes="Hidden";