#!/usr/bin/env pwsh

$Config = @{
    "UserConfig" = @{
	"Main" = "$($pwd.Path)/.usrrc"
        "Windows" = "NOT_APPLICABLE"
	"Linux" = "$($env:HOME)/.usrrc"
    }
    "Vim" = @{
	"Main" = "$($pwd.Path)/.vimrc"
        "Windows" = "$($env:HOME)/.vimrc"
        "Linux" = "$($env:HOME)/.vimrc"
    }
    "Tmux" = @{
	"Main" = "$($pwd.Path)/.tmux.conf"
	"Windows" = "NOT_APPLICABLE"
	"Linux" = "$($env:HOME)/.tmux.conf"
}

Function Link-ConfigurationFile {
    Param (
        [Parameter(Mandatory=$true)]
	[String]$LinkFile,

	[Parameter(Mandatory=$true)]
	[String]$TargetFile,

	[Parameter(Mandatory=$false)]
	[Switch]$DryRun
    )

    if ($DryRun) {
	Write-Host "Dry Run TRUE"
	New-Item -Type SymbolicLink -Path $LinkFile -Target $TargetFile -WhatIf
    } else {
	Write-Host "Dry Run FALSE"
	New-Item -Type SymbolicLink -Path $LinkFile -Target $TargetFile -WhatIf
    }
}


Function Link-ConfigurationFiles {
    $HostOs = "DEFAULT"
    
    if ($PSVersionTable.OS.Contains("Windows")) {
	$HostOs = "Windows"
    }

    if ($PSVersionTable.OS.Contains("Linux")) {
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

        Write-Host "`nLinking $($Replacement): [$($Config.$Replacement.$HostOs)] to [$($Config.$Replacement.Main)]."

        Link-ConfigurationFile -LinkFile $($Config.$Replacement.$HostOs) -TargetFile $($Config.$Replacement.Main) -DryRun
    }
}

## Main Method ##
Link-ConfigurationFiles

