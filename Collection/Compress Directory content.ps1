# Compress Directory content
# Technic ID : T1560.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Collects Software List and HotFixes deployend on the host (T1560.001)"
Write-Output "==============================================================================="
#
$source_dir="$env:PUBLIC\exf\";
$destination_dir="$env:PUBLIC\";
$archive_name="data.zip";
$full_name=$source_dir+$archive_name;
Compress-archive -Path $source_dir -DestinationPath $full_name -CompressionLevel Optimal;