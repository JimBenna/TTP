# Launch All scripts

Clear-Host
Write-Output "======================================================================================"
Write-Output "This scripts read a file and launch every scripts with a time wait between each script"
Write-Output "======================================================================================"
#
$InputFile="script_list.txt"
$CommandsArray = Get-Content -Path $InputFile

# Loops all commands that have been stored in the array
foreach ($Command in $CommandsArray)
{
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Noprofile -File $Command" -WindowStyle Hidden
    Start-Sleep -Seconds 10
}