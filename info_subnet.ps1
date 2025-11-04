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


try {
    # Get all network interfaces that are currently connected (Status = Up)
    $connectedInterfaces = Get-NetIPInterface |
        Where-Object { $_.ConnectionState -eq 'Connected' }

    if (-not $connectedInterfaces) {
        Write-Host "No connected network interfaces found."
    }
    else {
        foreach ($iface in $connectedInterfaces) {
            Write-Host "Interface Name : $($iface.InterfaceAlias)"
            Write-Host "Interface Index: $($iface.ifIndex)"
            Write-Host "Address Family : $($iface.AddressFamily)"
            Write-Host "----------------------------------------"
        }
    }
}
catch {
    Write-Error "Error retrieving network interfaces: $_"
}

Get-NetIPAddress
Get-NetIPConfiguration

Get-NetIPInterface -AddressFamily IPv4 |
    Where-Object { $_.ConnectionState -eq 'Connected' } |
    Select-Object InterfaceAlias, ifIndex

fping -g <subnet> -a -q
fping -4 -g 172.16.16.0/24 -a -q -s -R


# Put connected Interfaces in an Array
 $ResultIpIf = Get-NetIPInterface | Where-Object { $_.ConnectionState -eq 'Connected' }
 Write-Output "Result :" $ResultIpIf
 $ConnectedInterfaceArray = @()
    foreach ($Node in $ResultIpIf) {
       $ConnectedInterfaceArray += [pscustomobject]@{
            IfId            = $Node.ifIndex
            IfAlias         = $Node.InterfaceAlias
            IfIPType        = $Node.AddressFamily
            IfDHCP          = $Node.Dhcp
        }
    }



    $ResultIpAdd = Get-NetIPAddress | Where-Object { $_.AddressState -eq 'Preferred' }
 #Write-Output "Result :" $ResultIpAdd
 $IPInterfaceArray = @()
    foreach ($Node in $ResultIpAdd) {
       $IPInterfaceArray += [pscustomobject]@{
            IfId            = $Node.InterfaceIndex
            IfAlias         = $Node.InterfaceAlias
            IfIPType        = $Node.AddressFamily
            IfIPAddress     = $Node.IPAddress
            IfPrefix        = $Node.PrefixLength

        }
    }
$IPInterfaceArray

$ResultNet = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
 #Write-Output "Result :" $ResultNet
 $NetInterfaceArray = @()
    foreach ($Node in $ResultNet) {
        $NetInterfaceArray += [pscustomobject]@{
            IfId              = $Node.ifIndex
            IfName         = $Node.Name
            IfMacAddress         = $Node.MacAddress
            IfLinkSpeed          = $Node.LinkSpeed


        }
    }
 $NetInterfaceArray
#Extract InterfaceID from Array of connect Interfaces
 $SearchedIfId = $ConnectedInterfaceArray | ForEach-Object {$_.IfId}
  # $SearchedIfId

  #Search common information in both tables.

  $FusionnedArray = foreach ($FoundIndex in $SearchedIfId)
  {
    $found = $IPInterfaceArray | Where-Object {$_.IfId -eq $FoundIndex} & $_
    if ($found)
    {
        $found
    }
    else {
    write-host "$FoundIndex has not been found in $IPInterfaceArray.IfId"
     }
    }
