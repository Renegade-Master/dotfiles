#!/usr/bin/env pwsh

Param (
    [ Parameter(Mandatory = $false) ]
    [ Switch ]$DryRun
)

$Config = @{
    "GitConfig" = @{
        "Main" = "$( $pwd.Path )/.gitconfig"
        "Windows" = "$( $env:HOME )\\.gitconfig"
        "Linux" = "$( $env:HOME )/.gitconfig"
    }
    "GitIgnore" = @{
        "Main" = "$( $pwd.Path )/.gitignore"
        "Windows" = "$( $env:HOME )/.gitignore"
        "Linux" = "$( $env:HOME )/.gitignore"
    }
    "HTOP" = @{
        "Main" = "$( $pwd.Path )/.config/htop/htoprc"
        "Windows" = "NOT_APPLICABLE"
        "Linux" = "$( $env:HOME )/.config/htop/htoprc"
    }
    "NVIM" = @{
        "Main" = "$( $pwd.Path )/.config/nvim/init.vim"
        "Windows" = "$( $env:LocalAppData )\\nvim\\init.vim"
        "Linux" = "$( $env:HOME )/.config/nvim/init.vim"
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
        "Windows" = "$( $env:HOME )\\.vimrc"
        "Linux" = "$( $env:HOME )/.vimrc"
    }
    "WindowsTerminal" = @{
        "Main" = "$( $pwd.Path )/terminals/windows-terminal/settings.json"
        "Windows" = "$( $env:LocalAppData )\\Packages\\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\\LocalState\\settings.json"
        "Linux" = "NOT_APPLICABLE"
    }
}


Function Link-ConfigurationFile {
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


Function Link-ConfigurationFiles {
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

        try {
            Link-ConfigurationFile -LinkFile $( $Config.$Replacement.$HostOs ) -TargetFile $( $Config.$Replacement.Main ) -DryRun $DryRun
        }
        catch [ Exception ] {
            $emessage = $_
            Write-Host "Error: $($Error[0].Exception.GetType().FullName)"
            Write-Host "E: $emessage"

            $continue = Read-Host "That didn't appear to work. Would you like to attempt to force the operation? Y/N"

            if ($continue -eq "Y" -or $continue -eq "y") {
                Link-ConfigurationFile -LinkFile $( $Config.$Replacement.$HostOs ) -TargetFile $( $Config.$Replacement.Main ) -DryRun $DryRun -Force
            }
        }
    }
}


## Main Method ##
Link-ConfigurationFiles -DryRun $DryRun
