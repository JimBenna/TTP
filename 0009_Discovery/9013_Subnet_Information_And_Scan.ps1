# Network config Discovery
# Technic ID : T1016
Clear-Host
Write-Output "==============================================================================="
Write-Output "System Network Configuration Discovery (T1016)"
Write-Output "==============================================================================="
#
$LogFile = "$env:PUBLIC\exf\network_gather_scan.txt"; 
$DestinationDirectory = "$env:PUBLIC\Toolz\fping_x64_4.2"
$BinaryFile = "fping.exe"
$FullPathBinary = "$DestinationDirectory" + "\" + "$BinaryFile"
$PSToolsDirectory = "$env:PUBLIC\Pstools"
$PSPingBinary = "psping64.exe"
$ExfDirectory = "$env:PUBLIC\exf\"
$FileNameMask = "Scan_with_if_"
$FileNameExtension = ".txt"
# Put connected Interfaces in an Array
$ResultIpIf = Get-NetIPInterface | Where-Object { $_.ConnectionState -eq 'Connected' }
#Write-Output "Result :" $ResultIpIf
$ConnectedInterfaceArray = @()
foreach ($Node in $ResultIpIf) {
    $ConnectedInterfaceArray += [pscustomobject]@{
        IfId     = $Node.ifIndex
        IfAlias  = $Node.InterfaceAlias
        IfIPType = $Node.AddressFamily
        IfDHCP   = $Node.Dhcp
    }
}



$ResultIpAdd = Get-NetIPAddress | Where-Object { $_.AddressState -eq 'Preferred' }
#Write-Output "Result :" $ResultIpAdd
$IPInterfaceArray = @()
foreach ($Node in $ResultIpAdd) {
    $IPInterfaceArray += [pscustomobject]@{
        IfId        = $Node.InterfaceIndex
        IfAlias     = $Node.InterfaceAlias
        IfIPType    = $Node.AddressFamily
        IfIPAddress = $Node.IPAddress
        IfPrefix    = $Node.PrefixLength

    }
}


$ResultNet = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
#Write-Output "Result :" $ResultNet
$NetInterfaceArray = @()
foreach ($Node in $ResultNet) {
    $NetInterfaceArray += [pscustomobject]@{
        IfId         = $Node.ifIndex
        IfName       = $Node.Name
        IfMacAddress = $Node.MacAddress
        IfLinkSpeed  = $Node.LinkSpeed


    }
}

$NetIpv4Array = Get-NetIPConfiguration |
Where-Object { $_.NetAdapter.Status -eq "Up" } |
ForEach-Object {
    $interface = $_
    # IPv4
    $interface.IPv4Address | ForEach-Object {
        $ip = $_.IPAddress
        $prefix = $_.PrefixLength
        $mask = [System.Net.IPAddress]::Parse(
            (0..3 | ForEach-Object {
                if ($_ -lt $prefix / 8) { [byte]255 }
                elseif ($prefix -gt $_ * 8) { [byte]([Math]::Pow(2, 8 - ($prefix % 8)) - 1) }
                else { [byte]0 }
            }) -join '.'
        )
        $ipBytes = [System.Net.IPAddress]::Parse($ip).GetAddressBytes()
        $maskBytes = $mask.GetAddressBytes()
        $networkBytes = for ($i = 0; $i -lt 4; $i++) {
            [byte]($ipBytes[$i] -band $maskBytes[$i])
        }
        $network = [System.Net.IPAddress]::new($networkBytes).ToString()
        [PSCustomObject]@{
            IfId      = $interface.NetAdapter.InterfaceIndex
            Interface = $interface.NetAdapter.InterfaceDescription
            Type      = "IPv4"
            IfAddress = $ip
            Prefix    = $prefix
            NetMask   = $mask
            Subnet    = "$network/$prefix"

        }
    }
    # IPv6
    #        $interface.IPv6Address | Where-Object { $_.IsLinkLocal -eq $false } | ForEach-Object {
    #            [PSCustomObject]@{
    #                IfId      = $interface.NetAdapter.InterfaceIndex
    #                Interface = $interface.NetAdapter.InterfaceDescription
    #                Type      = "IPv6"
    #                IfAddress =  $interface.NetAdapter.IPv6Address
    #                Subnet    = "$($_.IPAddress)/$($_.PrefixLength)"
    #            }
    #        }
} 
# $NetIpv4Array | Format-Table
# $NetIpv6Array | Format-Table


#$ConnectedInterfaceArray|Format-Table
#$IPInterfaceArray|format-table
#$NetInterfaceArray

# FUsion sur IfIndex et AddressFamily
$FusionnedArray = foreach ($IfIndexConnected in $ConnectedInterfaceArray) {
    $match = $IPInterfaceArray | Where-Object {
        $_.IfId -eq $IfIndexConnected.IfId -and $_.IfIPType -eq $IfIndexConnected.IfIPType
    }
    if ($match) {
        [PSCustomObject]@{
            IfIndex     = $IfIndexConnected.IfId
            IfIPFamily  = $IfIndexConnected.IfIPType
            IfName      = $IfIndexConnected.IfAlias
            IfIpAddress = $match.IfIPAddress
            IfPrefix    = $match.IfPrefix
        }
    }
}
$SortedArray = $FusionnedArray | Sort-Object IfIndex
$SortedArray | Format-Table -AutoSize | Out-File -FilePath "$LogFile" -Encoding ascii -Append
$SortedNetArray = $NetInterfaceArray | Sort-Object IfIndex
$SortedNetArray | Format-Table -AutoSize | Out-File -FilePath "$LogFile" -Encoding ascii -Append 
$SortedNetIpv4Array = $NetIpv4Array | Sort-Object IfIndex
$SortedNetIpv4Array | Format-Table -AutoSize | Out-File -FilePath "$LogFile" -Encoding ascii -Append

#Launch subnets scans
if ([System.IO.File]::Exists("$FullPathBinary")) {
    Write-Output "The file [$BinaryFile] exists in $DestinationDirectory" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
    $SortedNetIpv4Array | ForEach-Object {
        $Log_Scan = "$env:PUBLIC\exf\Scan_with_if_" + "$($_.ifAddress)" + ".txt"
        $CliParameters = "-4 -q -A -a -R -g " + "$($_.subnet)"
        Start-Process -Filepath $FullPathBinary -ArgumentList $CliParameters -RedirectStandardOutput $Log_Scan -WindowStyle Hidden -Wait
        Write-Output "The ouptut file [$Log_Scan] has been created" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
    }
    #    exit 0;

    # Checks if PSPING exists
    if ([System.IO.File]::Exists("$PSToolsDirectory\$PSPingBinary")) {
        Write-Output "The file [$PSPingBinary] has been found in  $PSToolsDirectory !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 


        # Avec compteurs et statistiques
        $TotalFiles = 0
        $TotalLines = 0
        Get-ChildItem -Path "$ExfDirectory" -Filter "$FileNameMask*$FileNameExtension" | ForEach-Object {
            $TotalFiles++
            Write-Output "`Analyze file named : $($_.Name)" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    
            $FileLinesNumber = Get-Content $_.FullName
            $TotalLines += $FileLinesNumber.Count
    
            $FileLinesNumber | ForEach-Object -Begin { $LineNumber = 1 } -Process {
                # Traitement avec numérotation
                Write-Output " Aanlyzing line [$LineNumber] : Scanning  $_" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
                $LineNumber++
            }
    
            Write-Output "Total of lines computed : $($FileLinesNumber.Count)" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;
        }

        Write-Output "`Process ended : $TotalFiles files computed, and $TotalLines lines" | Out-File -FilePath "$LogFile" -Encoding ascii -Append;

    }
    else {
        Write-Output "The file [$PSPingBinary] has not been found in  $PSToolsDirectory !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
        exit 2;   
    }


} 
else {
    Write-Output "The file [$BinaryFile] can not be found in  $DestinationDirectory !!!" | Out-File -FilePath "$LogFile" -Encoding ascii -Append; 
    exit 1;
}