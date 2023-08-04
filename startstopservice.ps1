#########################################################################
#
# Title: Start/Stop/Restart a Service
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to List/Start/Stop/Restart Services
#
#########################################################################

function Get-RunningServices {
    $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
    Write-Host "Running Services:"
    $index = 1
    foreach ($service in $runningServices) {
        Write-Host "$index. $($service.Name)"
        $index++
    }
    Write-Host "0. Cancel"
    return $runningServices
}

function Get-ServiceToStartStopRestart {
    $runningServices = Get-RunningServices
    $serviceIndex = Read-Host "Enter the number of the service you want to start/stop/restart (or 0 to cancel)"
    if ($serviceIndex -eq 0) {
        Write-Host "Operation canceled. Exiting script."
        exit
    }
    elseif ($serviceIndex -ge 1 -and $serviceIndex -le $runningServices.Count) {
        return $runningServices[$serviceIndex - 1]
    }
    else {
        Write-Host "Invalid input. Please enter a valid number or 0 to cancel."
        Get-ServiceToStartStopRestart
    }
}

function Start-Stop-RestartService {
    $selectedService = Get-ServiceToStartStopRestart
    $action = Read-Host "Do you want to start, stop, or restart the service? (start/stop/restart)"
    if ($action -eq 'start') {
        Start-Service -Name $selectedService.Name
        Write-Host "Service $($selectedService.Name) started successfully."
    }
    elseif ($action -eq 'stop') {
        Stop-Service -Name $selectedService.Name
        Write-Host "Service $($selectedService.Name) stopped successfully."
    }
    elseif ($action -eq 'restart') {
        Restart-Service -Name $selectedService.Name
        Write-Host "Service $($selectedService.Name) restarted successfully."
    }
    else {
        Write-Host "Invalid action. Please enter 'start', 'stop', 'restart', or 0 to cancel."
        Start-Stop-RestartService
    }
}

Start-Stop-RestartService
