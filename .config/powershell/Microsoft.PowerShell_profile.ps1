using namespace System.Collections.Generic

# PowerShell User Configuration File #

# Most of these commands are only supported by PowerShell Core
if ($PSVersionTable.PSEdition -ne "Core") {
    exit
}

## Modules

# NOTE
# If may be helpful to set PSGallery as a Trusted Source:
#   Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

### Install Modules by adding their names to this list
[List[string]] $Modules = [List[string]]@("oh-my-posh", "NetworkingDsc", "Watch")

# Add Windows specific modules
if ($PSVersionTable.OS.Contains("Windows")) {
    $Modules.Add("PSWindowsUpdate")
}

### Install Modules
$InstallTime = Measure-Command {
    foreach ($module in $Modules) {
        if ( -Not(Get-Module -ListAvailable -Name $module) ) {
            Install-Module -Scope CurrentUser $module
        }
    }
}
Write-Host "Install Time: $($InstallTime.Minutes)m $($InstallTime.Seconds)s $($InstallTime.Milliseconds)ms"

### Import Modules
$ImportTime = Measure-Command {
    foreach ($module in $Modules) {
        Import-Module $module
    }
}
Write-Host "Import Time: $($ImportTime.Minutes)m $($ImportTime.Seconds)s $($ImportTime.Milliseconds)ms"

### Update Modules
Function Update-All {
    $UpdateTime = Measure-Command {
        # Update the OS
        if ($PSVersionTable.OS.Contains("Windows")) {
            # Update Windows (if a reboot is not scheduled)
            if ($(Get-WURebootStatus).RebootRequired -eq $false) {
                Write-Host "`n--- Updating ---"
                Write-Host "$(Get-WindowsUpdate)"

                Write-Host "`n--- Upgrading Windows ---"
                Install-WindowsUpdate -AcceptAll
            }
        } elseif ($PSVersionTable.OS.Contains("Ubuntu") -or $PSVersionTable.OS.Contains("Debian")) {
            Write-Host "Updating Debian/Ubuntu..."
            Write-Host "`n--- Updating ---"
            sudo apt-get update

            Write-Host "`n--- Upgrading Packages ---"
            sudo apt-get full-upgrade -y

            Write-Host "`n--- Upgrading OS ---"
            sudo apt-get dist-upgrade -y

            Write-Host "`n--- Cleaning Up ---"
            sudo apt-get autoremove -y
        }

        # Update PowerShell Modules
        Write-Host "Updating PS Modules..."
        foreach ($module in $Modules) {
            $localVersion = $(Get-InstalledModule $module).version
            $url = "https://www.powershellgallery.com/packages/$module/?dummy=$(Get-Random)"
            $request = [System.Net.WebRequest]::Create($url)
            $request.AllowAutoRedirect=$false

            try {
                $response = $request.GetResponse()
                $remoteVersion = $response.GetResponseHeader("Location").Split("/")[-1] -as [Version]
            } catch {
                Write-Warning "Could not retrieve latest version.`nSkipping update for $module."
                $remoteVersion = $localVersion
            }

            if ($remoteVersion -ne $localVersion) {
                Write-Host "Updating $module from $localVersion to $remoteVersion"
                Update-Module -AcceptLicense -Name $module
            }

            $response.Close()
            $response.Dispose()
        }
    }
    Write-Host "Update Time: $($UpdateTime.Minutes)m $($UpdateTime.Seconds)s $($UpdateTime.Milliseconds)ms"
}

## Theme
Set-PoshPrompt -Theme fish
Enable-PoshTransientPrompt

## Aliases
Set-Alias -Name "update" -Value Update-All

Function Show-All { Get-ChildItem -Attributes ReadOnly,Hidden,System,Directory,Archive,Device,Normal,Temporary,SparseFile,ReparsePoint,Compressed,Offline,NotContentIndexed,Encrypted,IntegrityStream,NoScrubData $args }
Set-Alias -Name "ll" -Value Show-All

Function Update-Repo { git submodule update --init --recursive; git fetch; git pull --ff-only; git submodule foreach git fetch; git submodule foreach git pull --ff-only }
Set-Alias -Name "git-update" -Value Update-Repo

Function Reset-Repo { git add .; git reset --hard; git fetch -a; git pull --ff-only; git submodule deinit --all --force; git submodule update --init --recursive; git submodule sync }
Set-Alias -Name "git-refresh" -Value Reset-Repo

Function Get-CurrentDatetime { Get-Date -UFormat "%Y%m%dT%H%M%SZ" }
Set-Alias -Name "datetime" -Value Get-CurrentDatetime
