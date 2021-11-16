### PowerShell User Configuration File ###

## Themes ##
# If theme is not working on fresh install, ensure to first run
#  Install-Module oh-my-posh -Scope CurrentUser

Import-Module oh-my-posh
Update-Module oh-my-posh
Set-PoshPrompt -Theme fish
Enable-PoshTransientPrompt
Enable-PoshTooltips

## Aliases
Function Show-All { Get-ChildItem -Attributes ReadOnly,Hidden,System,Directory,Archive,Device,Normal,Temporary,SparseFile,ReparsePoint,Compressed,Offline,NotContentIndexed,Encrypted,IntegrityStream,NoScrubData $args }
Set-Alias -Name "ll" -Value Show-All

Function Update-Repo { git submodule update --init --recursive; git fetch; git pull --ff-only; git submodule foreach git fetch }
Set-Alias -Name "git-update" -Value Update-Repo

Function Reset-Repo { git add .; git reset --hard; git fetch -a; git pull --ff-only; git submodule deinit --all --force; git submodule update --init --recursive; git submodule sync }
Set-Alias -Name "git-refresh" -Value Reset-Repo
