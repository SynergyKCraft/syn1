#########################################################################
#
# Title: Check Disk Space
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to Check Available disk Space on all drives
#
#########################################################################

Get-Volume | Select-Object DriveLetter, FileSystemLabel, @{Name="Capacity(GB)"; Expression={$_.Size / 1GB -as [int]}}, @{Name="FreeSpace(GB)"; Expression={$_.FreeSpace / 1GB -as [int]}}
