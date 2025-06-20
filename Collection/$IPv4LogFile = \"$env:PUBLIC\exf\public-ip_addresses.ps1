$IPv4LogFile = \"$env:PUBLIC\exf\pub-ipv4.txt";
$IPv6LogFile = \"$env:PUBLIC\exf\pub-ipv6.txt";
try {
    $IPv4Address = Invoke-RestMethod -Uri http://whatismyip.akamai.com/
}
catch {
    $MessageIPV4Error = $_
}
try {
    $IPv6Address = Invoke-RestMethod -Uri http://ipv6.whatismyip.akamai.com/
}
catch {
    $MessageIPV6Error = $_
}
        
if ($IPv4Address) { 
    Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPv4Address" | Out-File -FilePath "$IPv4LogFile" 
}
else { 
    Write-Output "$MessageIPV4Error" | Out-File -FilePath "$IPv4LogFile"
}
if ($IPv6Address) {
    Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPv6Address" | Out-File -FilePath "$IPv6LogFile"
}
else {
    Write-Output "$MessageIPV6Error" | Out-File -FilePath "$IPv6LogFile"
}