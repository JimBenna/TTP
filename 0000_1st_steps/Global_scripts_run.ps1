# Launch All scripts
Clear-Host
Write-output "`n"
Write-output "`n"
Write-Output "======================================================================================"
Write-Output "This scripts reads a file and launch every scripts with a time wait between each script"
Write-Output "======================================================================================"
#
$InputFile= $PSScriptRoot+"\scripts_list.txt"
$ParentDirectory = Split-Path -Path $PSScriptRoot -Parent
$CommandsArray = Get-Content -Path $InputFile
$PauseTimerInSeconds = "4"
# Maximum numbers of seconds that script is allowed to run before being killed due to timeout
$MaxTimeoutSec=180
$LogPath = Join-Path $PSScriptRoot "ScriptLaunch.txt"
$ErrorLogPath = Join-Path $PSScriptRoot "ErrorScriptLaunch.txt"

$PwshExe = if ($PSVersionTable.PSEdition -eq 'Core') {'pwsh'} else  {'powershell.exe'}

# Loops all commands that have been stored in the array
foreach ($Command in $CommandsArray)
{
    $FullAccessScript=$ParentDirectory+$Command
    $Arguments = @(
    '-NoProfile', 
    '-ExecutionPolicy', 'Bypass',
    '-File',"`"$FullAccessScript`""
    )
    Write-Output "Runing script : $FullAccessScript"
    write-output "Parent Directory : $parentDirectory"
#    Start-Process -FilePath "powershell.exe" -ArgumentList "-Noprofile -File $FullAccessScript" -WindowStyle Hidden -Wait

    $Process = Start-Process -FilePath $PwshExe -ArgumentList $Arguments -RedirectStandardOutput $LogPath -RedirectStandardError $ErrorLogPath -PassThru -WindowStyle Hidden
    Write-Output "Started Process PID = $($Process.Id)"
    #Poll until exit but takes into account a max timeout
    $DeadLine = (Get-Date).AddSeconds($MaxTimeoutSec)
    while (-not $Process.HasExited -and (Get-Date) -lt $DeadLine)
    {
        Write-Output "$(Get-Date -Format HH:mm:ss) - PID : $($Process.Id) running ..."
        Start-Sleep -Seconds $PauseTimerInSeconds
    }
if (-not $Process.HasExited) {
    write-output "`n"
    Write-Output "Timeout reached ${MaxTimeoutSec} seconds. Killing PID $($Process.Id) ..."
    try {
        Stop-Process -Id $Process.Id -Force -ErrorAction Stop
    }
    catch {
        Write-Output "Failed to kill process : $_"
    }
}
else {
    write-host "Process $($Process.Id) ended with code $($Process.ExitCode)"
}



    #Displays Outputs
    Write-output "`n"
    Write-Output "----- STDOUT -----"; Get-Content $LogPath
    Write-Output "------------------";     
    Write-output "`n"
    Write-Output "--- STDERR ---"; Get-Content $ErrorLogPath
    Write-output "`n"
}