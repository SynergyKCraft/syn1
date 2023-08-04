$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
$DomainName = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().DomainName

Write-Host "Fully Qualified Domain Name (FQDN): $FQDN"
Write-Host "Domain Name: $DomainName"
