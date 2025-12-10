# Identify Firewalls and save list to a file
# Technic ID : T1518.001
Clear-Host
Write-Output "==============================================================================="
Write-Output "Software Discovery: Security Software Discovery (T1518.001)"
Write-Output "==============================================================================="
#
$results = @()

# ================================================================
# 1. Firewalls detected through Security Center (WMI)
# ================================================================
try {
    $fwProducts = Get-CimInstance -Namespace "root/SecurityCenter2" -Class FirewallProduct -ErrorAction Stop
    foreach ($fw in $fwProducts) {
        $results += [pscustomobject]@{
            Source = "SecurityCenter2"
            Name   = $fw.displayName
            Path   = $fw.pathToSignedProductExe
            State  = ("0x{0:X}" -f $fw.productState)
        }
    }
}
catch {
    Write-Host "Unable to request SecurityCenter2 (Only available on Windows client XP→11)." -ForegroundColor Yellow
}

# ================================================================
# 2. Firewall recognition through known product services
# ================================================================
$knownFirewallServices = @{
    "MpsSvc"              = "Windows Firewall"
    "vsmon"               = "ZoneAlarm Firewall"
    "Kaspersky Firewall"  = "Kaspersky Firewall"
    "McAfeeFirewall"      = "McAfee Personal Firewall"
    "mfefire"             = "McAfee Endpoint Security Firewall"
    "NortonFirewall"      = "Norton Firewall"
    "ComodoFW"            = "Comodo Firewall"
    "F-Secure Gatekeeper" = "F-Secure Firewall"
}

$allServices = Get-Service

foreach ($svc in $allServices) {
    if ($knownFirewallServices.ContainsKey($svc.Name)) {
        $results += [pscustomobject]@{
            Source = "Service"
            Name   = $knownFirewallServices[$svc.Name]
            Path   = "Service: $($svc.Name)"
            State  = $svc.Status
        }
    }
}

# ================================================================
# 3. Check in  registry installed programs
# ================================================================
$uninstallPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$keywords = "firewall", "internet security", "endpoint security", "security suite"

foreach ($path in $uninstallPaths) {
    foreach ($item in Get-ItemProperty $path -ErrorAction SilentlyContinue) {
        if ($item.DisplayName) {
            foreach ($k in $keywords) {
                if ($item.DisplayName -like "*$k*") {
                    $results += [pscustomobject]@{
                        Source = "Registry"
                        Name   = $item.DisplayName
                        Path   = $item.InstallLocation
                        State  = "Installed"
                    }
                }
            }
        }
    }
}

# ================================================================
# 4. Built-in firewall status (Windows Defender Firewall)
# ================================================================

$profiles = (netsh advfirewall show allprofiles)
$wfState = if ($profiles -match "State\s*ON") {"Enabled"} else {"Disabled"}

$results += [pscustomobject]@{
    Source = "Windows Firewall"
    Name   = "Windows Defender Firewall"
    Path   = "Builtin"
    State  = $wfState
}

# ================================================================
# 5. Displays output of result
# ================================================================

Write-Host "`n=== FIREWALL installed on the workstation ===" -ForegroundColor Green
$results | Sort-Object Name | Format-Table -AutoSize

# ================================================================
# 6. Output To txt file
# ================================================================

$outputPath = "$env:PUBLIC\exf"
$outputFile = "$outputPath\firewall_identification.txt"

# Create file if it does not exist
if (!(Test-Path $outputPath)) {
    New-Item -Path $outputPath -ItemType Directory | Out-Null
}

# write in understandable output
$results | Sort-Object Name | Out-String | Set-Content -Path $outputFile -Encoding UTF8

Write-Host "`nOutput Result saved in file : $outputFile" -ForegroundColor Green

return $results