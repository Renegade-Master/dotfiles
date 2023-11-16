<#
.SYNOPSIS
  This script is used to create SymbolicLinks from the configuration files in this repository to their OS respective locations.

.DESCRIPTION
  By creating SymbolicLinks from the configuration files in this repository to their OS respective locations, the expected development environment is created.

.LINK
  https://github.com/Renegade-Master/dotfiles

.PARAMETER DryRun
  If present, the script will not actually create the SymbolicLinks.
  This is useful for viewing the potentially affected files.

.EXAMPLE
  $ ./install-shortcuts.ps1

.EXAMPLE
  $ ./install-shortcuts.ps1 -DryRun
#>
Param (
    [ Parameter(Mandatory = $false) ]
    [ Switch ]$DryRun
)

[ Hashtable ]$Config = @{
    "Fleet" = @{
        "Main" = "$( $pwd.Path )/editors/fleet/settings.json"
        "Windows" = "$( $env:USERPROFILE )\\.fleet\\settings.json"
        "Linux" = "$( $env:HOME )/.fleet/settings.json"
    }
    "GitConfig" = @{
        "Main" = "$( $pwd.Path )/.gitconfig"
        "Windows" = "$( $env:USERPROFILE )\\.gitconfig"
        "Linux" = "$( $env:HOME )/.gitconfig"
    }
    "GitIgnore" = @{
        "Main" = "$( $pwd.Path )/.gitignore"
        "Windows" = "$( $env:USERPROFILE )\\.gitignore"
        "Linux" = "$( $env:HOME )/.gitignore"
    }
    "HTOP" = @{
        "Main" = "$( $pwd.Path )/.config/htop/htoprc"
        "Windows" = "NOT_APPLICABLE"
        "Linux" = "$( $env:HOME )/.config/htop/htoprc"
    }
    "NuShell CONFIG" = @{
        "Main" = "$( $pwd.Path )/.config/nushell/config.nu"
        "Windows" = "$( $env:AppData )\\nushell\\config.nu"
        "Linux" = "NOT_APPLICABLE"
    }
    "NuShell ENV" = @{
        "Main" = "$( $pwd.Path )/.config/nushell/env.nu"
        "Windows" = "$( $env:AppData )\\nushell\\env.nu"
        "Linux" = "NOT_APPLICABLE"
    }
    "NVIM" = @{
        "Main" = "$( $pwd.Path )/editors/nvim/"
        "Windows" = "$( $env:LocalAppData )\\nvim\\"
        "Linux" = "$( $env:HOME )/.config/nvim/"
    }
    "PowerShell" = @{
        "Main" = "$( $pwd.Path )/.config/powershell/Microsoft.PowerShell_profile.ps1"
        "Windows" = "$Profile"
        "Linux" = "$Profile"
    }
    "Tmux" = @{
        "Main" = "$( $pwd.Path )/.tmux.conf"
        "Windows" = "NOT_APPLICABLE"
        "Linux" = "$( $env:HOME )/.tmux.conf"
    }
    "UserConfig" = @{
        "Main" = "$( $pwd.Path )/.usrrc"
        "Windows" = "NOT_APPLICABLE"
        "Linux" = "$( $env:HOME )/.usrrc"
    }
    "Vim" = @{
        "Main" = "$( $pwd.Path )/.vimrc"
        "Windows" = "$( $env:USERPROFILE )\\.vimrc"
        "Linux" = "$( $env:HOME )/.vimrc"
    }
    "WindowsTerminal" = @{
        "Main" = "$( $pwd.Path )/terminals/windows-terminal/settings.json"
        "Windows" = "$( $env:LocalAppData )\\Packages\\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\\LocalState\\settings.json"
        "Linux" = "NOT_APPLICABLE"
    }
    "Winget" = @{
        "Main" = "$( $pwd.Path )/package-managers/winget/settings.json"
        "Windows" = "$( $env:LocalAppData )\\Packages\\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\\LocalState\\settings.json"
        "Linux" = "NOT_APPLICABLE"
    }
}


<#
.SYNOPSIS
  Take a Target and Source file, and create a SymbolicLink from the Source to the Target.

.PARAMETER LinkFile
  The Source file to link the Target reference to.

.PARAMETER TargetFile
  The Target file that the Reference will link to.

.PARAMETER DryRun
  When set to true, will add '-WhatIf' to New-Item command.

.PARAMETER Force
  When set to true, will add '-Force' to New-Item command.

.EXAMPLE
  New-ConfigurationFile -LinkFile "$( $env:USERPROFILE )\\.gitconfig" -TargetFile "$( $pwd.Path )/.gitconfig"

.EXAMPLE
  New-ConfigurationFile -LinkFile "$( $env:USERPROFILE )\\.gitconfig" -TargetFile "$( $pwd.Path )/.gitconfig" -DryRun $true
#>
Function New-ConfigurationFile {
    Param (
        [ Parameter(Mandatory = $true) ]
        [ String ]$LinkFile,

        [ Parameter(Mandatory = $true) ]
        [ String ]$TargetFile,

        [ Parameter(Mandatory = $false) ]
        [ Boolean ]$DryRun,

        [ Parameter(Mandatory = $false) ]
        [ Switch ]$Force
    )

    Write-Host "Executing command: [ New-Item -Type SymbolicLink -Path $LinkFile -Target $TargetFile ]"

    if ($DryRun -and $Force) {
        New-Item -Type SymbolicLink -Path "$LinkFile" -Target "$TargetFile" -Force -WhatIf
    } elseif ($DryRun) {
        New-Item -Type SymbolicLink -Path "$LinkFile" -Target "$TargetFile" -WhatIf
    } elseif ($Force) {
        New-Item -Type SymbolicLink -Path "$LinkFile" -Target "$TargetFile" -Force
    } else {
        New-Item -Type SymbolicLink -Path "$LinkFile" -Target "$TargetFile"
    }
}


Function New-ConfigurationFiles {
    Param (
        [ Parameter(Mandatory = $false) ]
        [ Boolean ]$DryRun
    )
    $HostOs = "DEFAULT"

    if ( $PSVersionTable.OS.Contains("Windows")) {
        $HostOs = "Windows"
    }

    if ( $PSVersionTable.OS.Contains("Linux")) {
        $HostOs = "Linux"
    }

    if ($HostOs -eq "DEFAULT") {
        Throw "E: Host Operating System indeterminate. [$PSVersionTable]"
    }

    Write-Host "Linking $HostOs configuration files..."
    ForEach ($Replacement in $Config.Keys) {
        $app = $Config.$Replacement

        if ($app.$HostOs -eq "NOT_APPLICABLE") {
            continue
        }

        Write-Host "`nLinking $( $Replacement ): [$( $Config.$Replacement.$HostOs )] to [$( $Config.$Replacement.Main )]."

        New-ConfigurationFile `
            -LinkFile $( $Config.$Replacement.$HostOs ) `
            -TargetFile $( $Config.$Replacement.Main ) `
            -DryRun $DryRun `
            -ErrorAction SilentlyContinue -ErrorVariable ProcessError

        if ($ProcessError) {
            Write-Error "Error: $ProcessError"

            $continue = Read-Host "That didn't appear to work. Would you like to attempt to force the operation? Y/N"

            if ($continue -eq "Y" -or $continue -eq "y") {
                New-ConfigurationFile `
                    -LinkFile $( $Config.$Replacement.$HostOs ) `
                    -TargetFile $( $Config.$Replacement.Main ) `
                    -DryRun $DryRun `
                    -Force
            }
        }
    }
}


## Main Method ##
New-ConfigurationFiles -DryRun $DryRun
