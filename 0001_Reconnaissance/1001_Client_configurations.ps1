# Launch SeatBelt : System information Discovery
# Technic ID : T1592.004
Clear-Host
Write-Output "==============================================================================="
Write-Output "Gather Victim Host Information: Client Configurations (T1592.004)"
Write-Output "==============================================================================="
#
$Seatbelt = "$env:PUBLIC\Toolz\Seatbelt.exe";
$SeatbeltLogFile = "$env:PUBLIC\exf\Seatbelt.log";
$SeatbeltULogFile = "$env:PUBLIC\exf\Seatbelt-user.log";
$SeatbeltSLogFile = "$env:PUBLIC\exf\Seatbelt-system.log"      ;
if ([System.IO.File]::Exists("$Seatbelt")) {
    Write-Output "GREAT. The command $Seatbelt has been found :-)" | Out-File -FilePath "$SeatbeltLogFile";
    $ServiceCmd = "$Seatbelt -group=user -outputfile=$SeatbeltULogFile";
    Invoke-Expression "$ServiceCmd";
    $ServiceCmd = "$Seatbelt -group=system -outputfile=$SeatbeltSLogFile";
    Invoke-Expression "$ServiceCmd";
    exit 0;
}
else {
    Write-Output "The command $Seatbelt does not exists !!!" | Out-File -FilePath "$SeatbeltLogFile";
    exit 1;
};