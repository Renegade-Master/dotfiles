# How to Create the Correct Links

## Symbolic Links

```pwsh
New-Item -Type SymbolicLink -Path "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_1>\ImapMail\imap.gmail.com\msgFilterRules.dat" -Target "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail1.dat"

New-Item -Type SymbolicLink -Path "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_2>\ImapMail\imap.gmail.com\msgFilterRules.dat" -Target "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail2.dat"
```