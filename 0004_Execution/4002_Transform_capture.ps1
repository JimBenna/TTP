# Transform ETL packets capture to PCAP
# Technic ID : T1059.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Transform ETL packets capture to PCAP (T1059.001)"
Write-Output "==============================================================================="
#
$etl_capture_file = "$env:PUBLIC\exf\capture.etl";
$pcap_file = "$env:PUBLIC\exf\capture.pcap";
$etl2pcapng_command = "$env:PUBLIC\Toolz\etl2pcapng.exe"
$exf_file = "$env:PUBLIC\exf\capture.txt";
$DownLoadSource = "https://github.com/microsoft/etl2pcapng/releases/latest/download/etl2pcapng.exe"
if ([System.IO.File]::Exists("$etl_capture_file")) {
    try {
        Start-BitsTransfer -Source $DownLoadSource -Destination $etl2pcapng_command -DisplayName "Donwload Program convert File" -Description "Downloading etl2pcapng from Microsoft" -Priority Foreground
        Write-Output "Downloaded the file from the URL : $DownLoadSource" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
        Write-Output "File has been stored in : $etl2pcapng_command" | Out-File -FilePath "$exf_file" -Encoding ascii -Append
    }
    catch {
        Write-Output "Error during Download : $($_.Exception.Message)" | Out-File -FilePath "$exf_file" -Encoding ascii -Append    
    }
    if ([System.IO.File]::Exists($etl2pcapng_command)) { 
        $convert = "$etl2pcapng_command" + " $etl_capture_file" + " $pcap_file";
        Invoke-Expression $convert | Out-File -FilePath "$exf_file"; 
        Add-Content -Path $exf_file "The file $etl_capture_file has been converted to $pcap_file. You can now read it with Wireshark";
        exit 0;
    }
    else {
        "The $etl2pcapng_command does not exists !!!" | Out-File -FilePath "$exf_file";
        exit 2; 
    };
} 
else {
    "The file $etl_capture_file does not exists !!!" | Out-File -FilePath "$exf_file";
    exit 1; 
};