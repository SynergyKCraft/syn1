#########################################################################
#
# Title: Get System Information Script (Azure Active Directory)
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to Get system information on Windows Machine from Azure Active Directory
#
#########################################################################

function Get-SystemInformation {
    param (
        [string]$computerName
    )

    try {
        $systemInfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computerName
        $osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computerName

        # Create a custom object to store system information
        [PSCustomObject]@{
            'Computer Name' = $computerName
            Manufacturer = $systemInfo.Manufacturer
            Model = $systemInfo.Model
            'Total Physical Memory (GB)' = [math]::Round($systemInfo.TotalPhysicalMemory / 1GB)
            'Number of Processors' = $systemInfo.NumberOfProcessors
            'Operating System' = $osInfo.Caption
            Version = $osInfo.Version
            'Build Number' = $osInfo.BuildNumber
            'Last Boot Up Time' = $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)
        }
    }
    catch {
        Write-Host "Error occurred: $($_.Exception.Message)"
    }
}

# Authenticate against Azure AD
Connect-AzureAD

# Get a list of Computer names from Azure AD
$computerNames = Get-AzureADDevice -All $true | Select-Object -ExpandProperty DisplayName

# Create an empty array to store the results
$results = @()

# Process each computer and collect the results
foreach ($computerName in $computerNames) {
    $result = Get-SystemInformation -computerName $computerName
    $results += $result
}

# Display the information on the screen in a table format
$results | Format-Table

# Save the results in a CSV file called "results.csv" in the same location as the script was launched
$results | Export-Csv -Path (Join-Path -Path $PSScriptRoot -ChildPath "results.csv") -NoTypeInformation
