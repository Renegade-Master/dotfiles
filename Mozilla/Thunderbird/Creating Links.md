# How to Create the Correct Links

## Symbolic Links

```pwsh
New-Item -Type SymbolicLink -Path "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_1>\ImapMail\imap.gmail.com\msgFilterRules.dat" -Target "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail1.dat"

New-Item -Type SymbolicLink -Path "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_2>\ImapMail\imap.gmail.com\msgFilterRules.dat" -Target "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail2.dat"
```

## Copying

It seems that Thunderbird just overrwrites the files during startup/shutdown so Links are replaced.
Copying the file is just as good in this case:

```pwsh
Copy-Item -Path "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail1.dat" -Destination "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_1>\ImapMail\imap.gmail.com\msgFilterRules.dat"

Copy-Item -Path "$(pwd)\Mozilla\Thunderbird\msgFilterRules-gmail2.dat" -Destination "$($env:APPDATA)\Thunderbird\Profiles\<PROFILE_2>\ImapMail\imap.gmail.com\msgFilterRules.dat"
```
