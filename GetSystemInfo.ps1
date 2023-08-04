#########################################################################
#
# Title: Get System Information Script
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to Get system information on Windows Machine
#
#########################################################################

function Get-SystemInformation {
    param (
        [string]$computerName,
        [string]$domainName = $null
    )

    try {
        if (-not [string]::IsNullOrEmpty($domainName)) {
            $computer = "$computerName.$domainName"
        }
        else {
            $computer = $computerName
        }

        $systemInfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer
        $osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

        Clear-Host

        Write-Host "System Information for $computer"
        [PSCustomObject]@{
            'Computer Name' = $computer
            Manufacturer = $systemInfo.Manufacturer
            Model = $systemInfo.Model
            'Total Physical Memory (GB)' = [math]::Round($systemInfo.TotalPhysicalMemory / 1GB)
            'Number of Processors' = $systemInfo.NumberOfProcessors
            'Operating System' = $osInfo.Caption
            Version = $osInfo.Version
            'Build Number' = $osInfo.BuildNumber
            'Last Boot Up Time' = $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)
        } | Format-List
    }
    catch {
        Write-Host "Error occurred: $($_.Exception.Message)"
    }
}

$computerName = Read-Host "Enter the computer name (e.g., Server1)"
$domainName = Read-Host "Enter the domain name of the computer (optional, press Enter to skip)"

Get-SystemInformation -computerName $computerName -domainName $domainName
