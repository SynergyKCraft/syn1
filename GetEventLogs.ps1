#########################################################################
#
# Title: Get Event logs from Remote Computer
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to retrieve event logs from remote PC on 
#          remote domain.
#
#########################################################################
    function Get-RemoteEvents {
        param (
            [string]$domainName,
            [string]$computerName,
            [string]$logName,
            [int]$eventId
        )
    
        $computer = "${computerName}.${domainName}"
        $events = Get-WinEvent -ComputerName $computer -FilterHashtable @{LogName=$logName; ID=$eventId} -MaxEvents 10
    
        if ($events) {
            Write-Host "Events on $computer :"
            $events | ForEach-Object {
                Write-Host "Event ID: $($_.Id)"
                Write-Host "Message: $($_.Message)"
                # Add more information if required
            }
        }
        else {
            $errorMessage = if ($Error) { $Error[0].Exception.Message } else { "Unknown Error" }
            Write-Host "Error occurred: $errorMessage"
        }
    }
    
    $domainName = Read-Host "Enter the domain name of the computer (e.g., contoso)"
    $computerName = Read-Host "Enter the computer name (e.g., Server1)"
    $logName = "System"
    $eventId = 6008
    
    Get-RemoteEvents -domainName $domainName -computerName $computerName -logName $logName -eventId $eventId
    