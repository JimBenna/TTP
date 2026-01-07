# Scheduled Task
# Technic ID : T1053.005
Clear-Host
Write-Output "==============================================================================="
Write-Output "Scheduled Task/Job: Scheduled Task (T1053.005)"
Write-Output "==============================================================================="
$TaskName = "Shutdown Workstation"
$PsShutdown = "$env:PUBLIC\PsTools\psshutdown64.exe";
$Parameters = "-accepteula -k -f";
$PsShutLogFile = "$env:PUBLIC\exf\Scheduled_task.txt";
$RunTask = $PsShutdown+" "+$Parameters

if ([System.IO.File]::Exists("$PsShutdown")) {
    Write-Output "GREAT. The command $PsShutdown has been found :-)" | Out-File -FilePath "$PsShutLogFile"-Encoding ascii -Append;
    try {
            $ServiceCmd = "C:\Windows\System32\schtasks.exe /Create /SC DAILY /TN '$TaskName' /ST 21:45 /TR '$RunTask'";
            Write-Output "Launch command : " $ServiceCmd  | Out-File -FilePath "$PsShutLogFile" -Append -Encoding ascii;
            Invoke-Expression "$ServiceCmd"  | Out-File -FilePath "$PsShutLogFile" -Append -Encoding ascii;
            exit 0;
        }
    catch {
        Write-Output "Error while excecuting command $ServiceCmd error code : $($_.Exception.Message)" | Out-File -FilePath "$PsShutLogFile" -Encoding ascii -Append;
        exit 2;      
        }                        
    }
else {
    Write-Output "The command $PsShutdown does not exists !!!" | Out-File -FilePath "$PsShutLogFile" -Encoding ascii -Append;
    exit 1;
    }