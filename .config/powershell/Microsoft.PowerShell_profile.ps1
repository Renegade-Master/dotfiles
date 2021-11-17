### PowerShell User Configuration File ###

## Modules

### Install Modules by adding their names to this list
[String[]] $Modules = @("oh-my-posh")

## Install Modules
$InstallTime = Measure-Command {
    ForEach ($module in $Modules) {
        if ( -Not(Get-Module -ListAvailable -Name $module)) {
            Install-Module $module -Scope CurrentUser
        }
    }
}
Write-Host "Install Time: $($InstallTime.Milliseconds) ms"

### Import Modules
$ImportTime = Measure-Command {
    ForEach ($module in $Modules) {
        Import-Module $module
    }
}
Write-Host "Import Time: $($ImportTime.Milliseconds) ms"

### Update Modules
$UpdateTime = Measure-Command {
    ForEach ($module in $Modules) {
        $url = "https://www.powershellgallery.com/packages/$module/?dummy=$(Get-Random)"
        $request = [System.Net.WebRequest]::Create($url)
        $request.AllowAutoRedirect=$false
        $response = $request.GetResponse()
        $remoteVersion = $response.GetResponseHeader("Location").Split("/")[-1] -as [Version]
        $localVersion = $(Get-InstalledModule $module).version

        if ($remoteVersion -ne $localVersion) {
            Write-Host "Updating $module from $localVersion to $remoteVersion"
            Update-Module $module
        }

        $response.Close()
        $response.Dispose()
    }
}
Write-Host "Update Time: $($UpdateTime.Milliseconds) ms"

## Theme
Set-PoshPrompt -Theme fish
Enable-PoshTransientPrompt

## Aliases
Function Show-All { Get-ChildItem -Attributes ReadOnly,Hidden,System,Directory,Archive,Device,Normal,Temporary,SparseFile,ReparsePoint,Compressed,Offline,NotContentIndexed,Encrypted,IntegrityStream,NoScrubData $args }
Set-Alias -Name "ll" -Value Show-All

Function Update-Repo { git submodule update --init --recursive; git fetch; git pull --ff-only; git submodule foreach git fetch }
Set-Alias -Name "git-update" -Value Update-Repo

Function Reset-Repo { git add .; git reset --hard; git fetch -a; git pull --ff-only; git submodule deinit --all --force; git submodule update --init --recursive; git submodule sync }
Set-Alias -Name "git-refresh" -Value Reset-Repo
