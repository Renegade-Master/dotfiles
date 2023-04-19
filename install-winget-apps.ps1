<#
.SYNOPSIS
  This script uses Winget to install programs for the Windows Operating System.

.DESCRIPTION
  By firstly checking for (and installing if not present) Winget, this script will then install a set list of programs.

.LINK
  https://github.com/Renegade-Master/dotfiles/blob/master/package-managers/winget/installer.ps1

.EXAMPLE
  $ ./installer.ps1
#>

Param ()

[ Array ]$Applications = @(
    @{ Name = "Git"; Id = "Git.Git" }
    @{ Name = "GitHub CLI"; Id = "GitHub.cli" }
    @{ Name = "Windows PowerToys"; Id = "Microsoft.PowerToys" }
    @{ Name = "Windows Terminal"; Id = "Microsoft.WindowsTerminal" }
)


Function Test-AppInstalled {
    [ OutputType([ Boolean ]) ]
    Param (
        [ Parameter(Mandatory = $True) ]
        [ String ]$AppName
    )

    $listApp = winget list --exact -q $AppName
    If (![String]::Join("", $listApp).Contains($AppName)) {
        Return $True
    } Else {
        Return $False
    }
}


Function Install-Applications {
    ForEach ($App In $Applications) {
        If (Test-AppInstalled -AppName $App.Id) {
            Write-host "Installing:" $App.Name

            If ($null -ne $App.source) {
                #winget install --exact --silent $App.Id --source $App.Source
            } Else {
                #winget install --exact --silent $App.Id
            }
        } Else {
            Write-host "Skipping Install of " $App.Name
        }
    }
}


Function Install-WinGet {
    $ProgressPreference = "silentlyContinue"
    $DownloadLocation = "$( $env:LocalAppData )\\Temp"
    $LatestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
    $LatestWingetMsixBundle = $LatestWingetMsixBundleUri.Split("/")[-1]

    Write-Information "Downloading WinGet to temporary directory..."
    Invoke-WebRequest -Uri $LatestWingetMsixBundleUri -OutFile "$DownloadLocation\\$LatestWingetMsixBundle"
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile "$DownloadLocation\\Microsoft.VCLibs.x64.14.00.Desktop.appx"

    Add-AppxPackage "$DownloadLocation\\Microsoft.VCLibs.x64.14.00.Desktop.appx"
    Add-AppxPackage "$DownloadLocation\\$LatestWingetMsixBundle"
}


Function Test-WinGet {
    Try {
        If (Get-Command -CommandType Application winget) {
            Write-Host "WinGet already installed. Continuing..."
        }
    } Catch {
        Write-Host "WinGet is not installed. Installing now..."
        Install-WinGet
    }
}


## Main Method ##
Test-WinGet
#Install-Applications
