########################################################################
#
# Title: Script to Shorten Path Names
#
# CAUTION: USE AT OWN RISK! READ ALL COMMENTS BEFORE COMMITTING CHANGES
#
# Author: Ken Craft
# Company: Synergy Tek
#
# License: NONE - Private Use Only. Not For Public Use
#
########################################################################
#
# This Program is designed to shorten a File/Folder Path length by
# cutting off Characters of the path
# It is designed as a test, not for production
# Do not attempt to use in ANY production environment
# DISCLAIMER: Author and Company Not Responsible for Misuse of this
#             or any portion of this Script. Also not responsible for
#             unauthorized use. No one outside of the author has 
#             permission to run this script in a production environment
#
# Main Function for renaming all items.
# Accepts the two paramanters <path> and <max_length>
# <max_length> Applies to both folder and file names.
#
#
# EXAMPLE: 
# Max Length: 20
# Path C:\Users\ken.craft\OneDrive\Desktop\File Repository\Accounting\Clients\Edmondson Electric\Fiscal Year 2023\Profit and Loss Statements\Edmondson Aug 2023 P&L.qb
#
# This script will shorten the path to:
# C:\Users\ken.craft\OneDrive\Desktop\FileR\Accounting\Clients\EdmondsonE\FiscalYear2023\Profit\August2023\EdmondsonPnL09-23.qb
#
#
function Rename-ItemsShortenLength {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path,
        
        [Parameter(Mandatory=$true, Position=1)]
        [int]$MaxLength
    )

    if (-Not (Test-Path -Path $Path -PathType Container)) {
        Write-Host "Path '$Path' does not exist."
        return
    }

    $files = Get-ChildItem -Path $Path -Recurse -File
    $folders = Get-ChildItem -Path $Path -Recurse -Directory

    foreach ($file in $files) {
        Rename-FileShortenLength $file.FullName $MaxLength
    }

    foreach ($folder in $folders) {
        Rename-FolderShortenLength $folder.FullName $MaxLength
    }
}

function Rename-FileShortenLength {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FilePath,

        [Parameter(Mandatory=$true, Position=1)]
        [int]$MaxLength
    )

    $fileDir, $fileName = Split-Path -Path $FilePath -Leaf
    $newName = Shorten-String $fileName $MaxLength
    $newPath = Join-Path -Path $fileDir -ChildPath $newName

    if ($FilePath -ne $newPath) {
        try {
            Rename-Item -Path $FilePath -NewName $newName -ErrorAction Stop
            Write-Host "Renamed file: $FilePath => $newPath"
        }
        catch {
            Write-Host "Failed to rename file: $FilePath - $_"
        }
    }
}


function Rename-FolderShortenLength {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FolderPath,

        [Parameter(Mandatory=$true, Position=1)]
        [int]$MaxLength
    )

    $newName = Shorten-String (Split-Path -Path $FolderPath -Leaf) $MaxLength
    $parentDir = Split-Path -Path $FolderPath -Parent
    $newPath = Join-Path -Path $parentDir -ChildPath $newName

    if ($FolderPath -ne $newPath) {
        try {
            Rename-Item -Path $FolderPath -NewName $newName -ErrorAction Stop
            Write-Host "Renamed folder: $FolderPath => $newPath"
        }
        catch {
            Write-Host "Failed to rename folder: $FolderPath - $_"
        }
    }
}

function Shorten-String {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$String,

        [Parameter(Mandatory=$true, Position=1)]
        [int]$MaxLength
    )

    if ($String.Length -le $MaxLength) {
        return $String
    }

    $extension = [IO.Path]::GetExtension($String)
    $baseName = [IO.Path]::GetFileNameWithoutExtension($String)

    $truncLength = $MaxLength - $extension.Length
    $newName = $baseName.Substring(0, $truncLength)
    return "$newName$extension"
}

# Main script
if ($args.Length -ne 2) {
    Write-Host "Usage: PowerShell rename_script.ps1 <path> <max_length>"
}
else {
    $path = $args[0]
    $max_length = [int]$args[1]
    Rename-ItemsShortenLength $path $max_length
}
