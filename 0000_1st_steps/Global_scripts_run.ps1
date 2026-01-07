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

$LogPath = Join-Path $PSScriptRoot "ScriptLaunch.txt"
$ErrorLogPath = Join-Path $PSScriptRoot "ErrorScriptLaunch.txt"



# Loops all commands that have been stored in the array
foreach ($Command in $CommandsArray)
{
    $FullAccessScript=$ParentDirectory+$Command
    $Arguments = @(
    '-NoProfile', 
    '-ExecutionPolicy', 'Bypass',
    '-WindowStyle', 'Hidden',
    '-File',"`"$FullAccessScript`""
    )
    Write-Output "Runing script : $FullAccessScript"
    write-output "Parent Directory : $parentDirectory"
#    Start-Process -FilePath "powershell.exe" -ArgumentList "-Noprofile -File $FullAccessScript" -WindowStyle Hidden -Wait

    $proc = Start-Process -FilePath "Powershell.exe" -ArgumentList $Arguments -RedirectStandardOutput $LogPath -RedirectStandardError $ErrorLogPath -PassThru 
    Write-Output "Started Process PID=$($proc.Id)"
    #Poll until exit
    while (-not $proc.HasExited)
    {
        Write-Output "$(Get-Date -Format HH:mm:ss) - PID : $($proc.Id) running ..."
        Start-Sleep -Seconds $PauseTimerInSeconds
        Write-output "`n"
    }
    Write-Output "Process has exited with code $($proc.ExitCode)"
    Write-Output "Process has exited after $($proc.ExitTime)"

    #Displays Outputs
    Write-Output "--- STDOUT ---"; Get-Content $LogPath
    Write-Output "--- STDERR ---"; Get-Content $ErrorLogPath
}