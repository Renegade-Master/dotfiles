# install-shortcuts.nu
# Nushell: create symlinks for config files (uses mklink on Windows)

# -----------------------------
# Usage:
#   nu install-shortcuts.nu --dry-run    # show what would run
#   nu install-shortcuts.nu               # actually run
# -----------------------------

def main [
    --dry-run
    --force
] {
    let dry = $dry_run || false
    let force = $force || false

    let config = {
        Fleet: {
            Main: $"($env.PWD)/editors/fleet/settings.json"
            Windows: $"($env.USERPROFILE)/.fleet/settings.json"
            Linux: $"($env.HOME)/.fleet/settings.json"
        }
        GitConfig: {
            Main: $"($env.PWD)/.gitconfig"
            Windows: $"($env.USERPROFILE)/.gitconfig"
            Linux: $"($env.HOME)/.gitconfig"
        }
        GitIgnore: {
            Main: $"($env.PWD)/.gitignore"
            Windows: $"($env.USERPROFILE)/.gitignore"
            Linux: $"($env.HOME)/.gitignore"
        }
        HTOP: {
            Main: $"($env.PWD)/.config/htop/htoprc"
            Windows: "NOT_APPLICABLE"
            Linux: $"($env.HOME)/.config/htop/htoprc"
        }
        NuShellConfig: {
            Main: $"($env.PWD)/.config/nushell/config.nu"
            Windows: $"($env.APPDATA)/nushell/config.nu"
            Linux: "NOT_APPLICABLE"
        }
        NuShellEnv: {
            Main: $"($env.PWD)/.config/nushell/env.nu"
            Windows: $"($env.APPDATA)/nushell/env.nu"
            Linux: "NOT_APPLICABLE"
        }
        NVIM: {
            Main: $"($env.PWD)/editors/nvim/"
            Windows: $"($env.LOCALAPPDATA)/nvim/"
            Linux: $"($env.HOME)/.config/nvim/"
        }
        PowerShell: {
            Main: $"($env.PWD)/.config/powershell/Microsoft.PowerShell_profile.ps1"
            Windows: $env.PROFILE
            Linux: $env.PROFILE
        }
        Tmux: {
            Main: $"($env.PWD)/.tmux.conf"
            Windows: "NOT_APPLICABLE"
            Linux: $"($env.HOME)/.tmux.conf"
        }
        UserConfig: {
            Main: $"($env.PWD)/.usrrc"
            Windows: "NOT_APPLICABLE"
            Linux: $"($env.HOME)/.usrrc"
        }
        Vim: {
            Main: $"($env.PWD)/.vimrc"
            Windows: $"($env.USERPROFILE)/.vimrc"
            Linux: $"($env.HOME)/.vimrc"
        }
        VSCodium: {
            Main: $"($env.PWD)/editors/vscodium/settings.json"
            Windows: $"($env.APPDATA)/VSCodium/User/settings.json"
            Linux: $"($env.HOME)/.config/VSCodium/User/settings.json"
        }
        WindowsTerminal: {
            Main: $"($env.PWD)/terminals/windows-terminal/settings.json"
            Windows: $"($env.LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
            Linux: "NOT_APPLICABLE"
        }
        WindowsTerminalPreview: {
            Main: $"($env.PWD)/terminals/windows-terminal/settings.json"
            Windows: $"($env.LOCALAPPDATA)/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
            Linux: "NOT_APPLICABLE"
        }
        Winget: {
            Main: $"($env.PWD)/package-managers/winget/settings.json"
            Windows: $"($env.LOCALAPPDATA)/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState/settings.json"
            Linux: "NOT_APPLICABLE"
        }
    }

    let os = detect-os

    print $"Linking config files for: ($os)"
    for entry in ($config | transpose key value) {
        let name = $entry.key
        let paths = $entry.value

        if ($paths | get $os) == "NOT_APPLICABLE" {
            continue
        }

        let linkfile = ($paths | get $os)
        let targetfile = ($paths | get Main)

        print $""
        print $"Item: ($name)"
        print $"  Link:   ($linkfile)"
        print $"  Target: ($targetfile)"

        # create parent dir for link if missing (Windows needs parent dir to exist)
        let parent = (path dirname $linkfile)
        if not (path exists $parent) {
            if $dry {
                print $"(Dry-run) Would create parent directory: ($parent)"
            } else {
                print $"Creating parent directory: ($parent)"
                mkdir -p $parent
            }
        }

        let res = new-config-file $linkfile $targetfile $dry $force $os

        if ($res.err?) != null {
            print $"Error: ($res.err?)"
            let retry = input "That didn't appear to work. Attempt to force the operation? (Y/N): "
            if $retry in ["Y" "y"] {
                new-config-file $linkfile $targetfile $dry true $os
            }
        }
    }
}

# -----------------------------
# Detect OS
# -----------------------------
def detect-os [] {
    if ($nu.os-info.name | str to-lower | str contains "windows") {
        "Windows"
    } else if ($nu.os-info.name | str to-lower | str contains "linux") {
        "Linux"
    } else if ($nu.os-info.name | str to-lower | str contains "darwin" || $nu.os-info.name | str to-lower | str contains "mac") {
        "Linux" # treat macos as unix-like for ln
    } else {
        error make { msg: "Host OS indeterminate: ($nu.os-info.name)" }
    }
}

# -----------------------------
# Create symlink: Windows uses mklink, others use ln -s
# params:
#   linkfile targetfile dryrun force os
# returns: { ok: true } or { err: <error> }
# -----------------------------
def new-config-file [
    linkfile: string
    targetfile: string
    dryrun: bool
    force: bool
    os: string
] {
    # Heuristic: treat as directory link if target ends with separator or looks like a directory path
    let is_dir_by_suffix = ($targetfile | str ends-with "/" ) || ($targetfile | str ends-with "\\" )

    # If the target exists and is a directory, treat as dir
    let is_dir_by_fs = false
    try {
        if (path exists $targetfile) {
            let ttype = (path type $targetfile) # returns "File" or "Dir"
            if $ttype == "Dir" { let is_dir_by_fs = true } else { let is_dir_by_fs = false }
        }
    } catch { } # ignore stat errors

    let is_dir = $is_dir_by_suffix || $is_dir_by_fs

    if $dryrun {
        if $os == "Windows" {
            if $is_dir {
                print $"(Dry-run) cmd /c mklink /D \"($linkfile)\" \"($targetfile)\""
            } else {
                print $"(Dry-run) cmd /c mklink \"($linkfile)\" \"($targetfile)\""
            }
        } else {
            print $"(Dry-run) ln -s \"($targetfile)\" \"($linkfile)\""
        }
        return { ok: true }
    }

    # If forcing, remove existing link/file first
    if $force {
        if (path exists $linkfile) {
            print $"Removing existing path: ($linkfile)"
            try {
                # Remove files or directories (be careful)
                rm -r -f $linkfile
            } catch err {
                return { err: $err }
            }
        }
    }

    try {
        if $os == "Windows" {
            # Build mklink command; mklink <link> <target> but we run via cmd /c
            if $is_dir {
                let cmd = $"cmd /c mklink /D \"{($linkfile)}\" \"{($targetfile)}\""
            } else {
                let cmd = $"cmd /c mklink \"{($linkfile)}\" \"{($targetfile)}\""
            }
            print $"Running: ($cmd)"
            # run the command through cmd /c so mklink works
            let exit = (cmd | run)
            # run returns pipeline output; check exit code? If mklink fails it prints text and returns non-zero, but run will throw on non-zero; we'll capture with try/catch
        } else {
            # Unix-like
            let cmd = $"ln -s \"{($targetfile)}\" \"{($linkfile)}\""
            print $"Running: ($cmd)"
            let _ = (run -p ln -s $targetfile $linkfile) # use run with args to avoid shell quoting problems
        }
        { ok: true }
    } catch err {
        { err: $err }
    }
}

