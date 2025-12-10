# Launch All scripts
Clear-Host
Write-output "`n"
Write-output "`n"
Write-Output "======================================================================================"
Write-Output "This scripts read a file and launch every scripts with a time wait between each script"
Write-Output "======================================================================================"
#
$InputFile= $PSScriptRoot+"\scripts_list.txt"
$ParentDirectory = Split-Path -Path $PSScriptRoot -Parent
$CommandsArray = Get-Content -Path $InputFile
$PauseTimerInSeconds = "4"

# Loops all commands that have been stored in the array
foreach ($Command in $CommandsArray)
{
    $FullAccessScript=$ParentDirectory+$Command
    Write-Output "Runing script : $FullAccessScript"
    write-output "Parent Directory : $parentDirectory"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Noprofile -File $FullAccessScript" -WindowStyle Hidden -Wait
    Write-Output "Waiting $PauseTimerInSeconds before launching anhother script ..."
    Write-output "`n"
    Start-Sleep -Seconds $PauseTimerInSeconds
}