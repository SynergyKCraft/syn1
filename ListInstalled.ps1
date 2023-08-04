#########################################################################
#
# Title: List Installed Software
# Author: Ken Craft
# Website: SynergyTek.net
#
# Purpose: Toolbox Script to Get a list of installed software
#
#########################################################################

Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
  Select-Object DisplayName, Publisher, InstallDate, DisplayVersion
