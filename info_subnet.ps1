function Get-UsableHosts {
    param (
        [string]$SubnetMask
    )

    # Convert the subnet mask to binary and count the number of '1' bits
    $binaryMask = ($SubnetMask -split '\.') | ForEach-Object { [Convert]::ToString($_, 2).PadLeft(8, '0') }
    $onesCount = ($binaryMask -join '').ToCharArray() | Where-Object { $_ -eq '1' } | Measure-Object | Select-Object -ExpandProperty Count

    # Calculate the number of usable hosts
    $usableHosts = [math]::Pow(2, (32 - $onesCount)) - 2
    return $usableHosts
}

# Example usage
$subnetMask = "255.255.255.0"
$hosts = Get-UsableHosts -SubnetMask $subnetMask
Write-Output "The number of usable hosts for subnet mask $subnetMask is $hosts."
