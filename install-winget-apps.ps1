<#
.SYNOPSIS
  This script uses Winget to install programs for the Windows Operating System.

.DESCRIPTION
  By firstly checking for (and installing if not present) Winget, this script will then install a set list of programs.

.LINK
  https://github.com/Renegade-Master/dotfiles/blob/master/install-winget-apps.ps1

.EXAMPLE
  $ ./install-winget-apps.ps1
#>

Param ()

[ Array ]$Applications = @(
    @{ Name = "7-Zip"; Id = "7zip.7zip"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "BTOP 4 Win"; Id = "aristocratos.btop4win"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Bulk Crap Uninstaller"; Id = "Klocman.BulkCrapUninstaller"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Discord [Canary]"; Id = "Discord.Discord.Canary"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Discord [PTB]"; Id = "Discord.Discord.PTB"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "DisplayFusion"; Id = "BinaryFortress.DisplayFusion"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "EA Desktop"; Id = "ElectronicArts.EADesktop"; Interactive = $False; IgnoreHash = $True }
    @{ Name = "Epic Games Legendary"; Id = "derrod.legendary"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Epic Games Rare"; Id = "Dummerle.Rare"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "EpicGames Launcher"; Id = "EpicGames.EpicGamesLauncher"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Everything Cli"; Id = "voidtools.Everything.Cli"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Everything"; Id = "voidtools.Everything"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Explorer Patcher [Pre-Release]"; Id = "valinet.ExplorerPatcher.Prerelease"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Firefox Developer Edition"; Id = "Mozilla.Firefox.DeveloperEdition"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "foobar2000"; Id = "PeterPawlowski.foobar2000"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Foxit Reader"; Id = "Foxit.FoxitReader"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "FxSound"; Id = "FxSound.FxSound"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Git [Minimal]"; Id = "Git.MinGit"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "GitHub CLI"; Id = "GitHub.cli"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "GnuPG Gpg4win"; Id = "GnuPG.Gpg4win"; Interactive = $True; IgnoreHash = $False }
    @{ Name = "GOG Galaxy"; Id = "GOG.Galaxy"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Google.Drive"; Id = "Google.Drive"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Jellyfin Media Player"; Id = "Jellyfin.JellyfinMediaPlayer"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "JetBrains Mono Nerd Font"; Id = "DEVCOM.JetBrainsMonoNerdFont"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "JetBrains Toolbox"; Id = "JetBrains.Toolbox"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "JQ"; Id = "jqlang.jq"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "KeePassXC"; Id = "KeePassXCTeam.KeePassXC"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Keyviz"; Id = "mulaRahul.Keyviz"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Link Shell Extension"; Id = "HermannSchinagl.LinkShellExtension"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Microsoft Edge Developer Edition"; Id = "Microsoft.Edge.Dev"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Microsoft PowerShell 7"; Id = "Microsoft.PowerShell"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "MSI Afterburner"; Id = "Guru3D.Afterburner"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Neovim"; Id = "Neovim.Neovim"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "NexusMods Vortex"; Id = "NexusMods.Vortex"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Nvidia GeForce Experience"; Id = "Nvidia.GeForceExperience"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "OhMyPosh"; Id = "JanDeDobbeleer.OhMyPosh"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Ookla Speedtest CLI"; Id = "Ookla.Speedtest.CLI"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Open VPN"; Id = "OpenVPNTechnologies.OpenVPN"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "PotPlayer"; Id = "Daum.PotPlayer"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Proton Mail Bridge"; Id = "ProtonTechnologies.ProtonMailBridge"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "qBittorrent"; Id = "qBittorrent.qBittorrent"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "R2ModMan"; Id = "ebkr.r2modman"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "scrcpy"; Id = "Genymobile.scrcpy"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Steam"; Id = "Valve.Steam"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Sysinternals Suite"; Id = "9P7KNL5RWT25"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Thunderbird.Beta"; Id = "Mozilla.Thunderbird.Beta"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Twinkle Tray"; Id = "xanderfrangos.twinkletray"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Ubisoft Connect"; Id = "Ubisoft.Connect"; Interactive = $False; IgnoreHash = $True }
    @{ Name = "UniGetUI"; Id = "SomePythonThings.WingetUIStore"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "VMWare Workstation Pro"; Id = "VMware.WorkstationPro"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Voidtools Everything"; Id = "voidtools.Everything.Lite"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "VSCodium"; Id = "VSCodium.VSCodium"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Windows PowerToys"; Id = "Microsoft.PowerToys"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Windows Terminal"; Id = "Microsoft.WindowsTerminal"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Wireguard"; Id = "WireGuard.WireGuard"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "WizTree"; Id = "AntibodySoftware.WizTree"; Interactive = $False; IgnoreHash = $False }
    @{ Name = "Yubico Authenticator"; Id = "Yubico.Authenticator"; Interactive = $False; IgnoreHash = $False }
)


Function Test-AppInstalled {
    [ OutputType([ Boolean ]) ]
    Param (
        [ Parameter(Mandatory = $True) ]
        [ String ]$AppName
    )

    $listApp = winget list --exact -q $AppName
    If ([String]::Join("", $listApp).Contains($AppName)) {
        Return $True
    } Else {
        Return $False
    }
}


Function Install-Applications {
    ForEach ($App In $Applications) {
        Write-host "`nFound: $($App.Name)"

        $stringBuilder = New-Object -TypeName "System.Text.StringBuilder"
        [void]$stringBuilder.Append("--exact")

        # Add Flags for overridding behaviour
        If ($App.Interactive -eq $True) {
            [void]$stringBuilder.Append(" --interactive")
        }

        If ($App.IgnoreHash -eq $True) {
            [void]$stringBuilder.Append(" --ignore-security-hash")
        }

        If ($Null -ne $App.source) {
            [void]$stringBuilder.Append(" --source $($App.Source)")
        }

        $Flags = $stringBuilder.ToString()

        If (-Not (Test-AppInstalled -AppName $App.Id)) {
            Write-host "Installing: $($App.Name)"
            #Write-Host "Running: winget install $($Flags) --id=$($App.Id)"

            winget install $($Flags) --silent --id=$($App.Id)
        } Else {
            Write-host "Skipping Install of $($App.Name) as it is already installed"
            #Write-Host "Would have Run: winget install $($Flags) --id=$($App.Id)"
        }
    }
}


Function Install-WinGet {
    $ProgressPreference = "silentlyContinue"
    $DownloadLocation = "$env:TEMP"
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
Install-Applications
