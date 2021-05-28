# powershell-tips-and-tricks

My personal notes of tips and tricks with Powershell. 

This is mostly written from the perspective of a Software Engineer and C++ / C# / Python / Scheme programmer, and being frequently surprised by the differences in design philosophy behind powershell.

## Automation

### Error Logging

In general, your build automation scripts (whether invoked by -Command or -File) should start with the following to ensure a non-zero exit code on failure:

```powershell
$ErrorActionPreference = 'Stop'
trap { throw $_ }
```

This ensures that Powershell errors are terminating, and that even non-failure terminating errors will result in a non-zero exit code when re-raised by throw `$_`. Oddly, this does not mess up line numbers either -- it shows the inner most error record available.

Special thanks to Friedrich Weinmann for this tip!

**Do**
- Default to treating all failures as terminating
- Exit with non-zero if your script has failed
- Check $LASTEXITCODE after invoking other programs

**Don't**
- Treat stderr as error. Many programs write diagnostic info (like warnings, or verbose details) to stderr. This is normal, and should not be treated as an error

**Example**

```powershell
function Get-GitStatus { 
    $ErrorActionPreference = 'Continue'
    git.exe status *>&1 | Write-Host
    if (-not $? -or $LastErrorCode) { throw "Git failed with $LastErrorCode" }
}
```

### Launching Powershell

Always use the following command line parameters to ensure a relatively consistent
powershell environment

```powershell
powershell.exe -noni -nop -ex Bypass -f YourScript.ps1
```

**Why?**

noni/NonInteractive: by default, powershell will prompt the user for any missing
arguments to the script. This default will hang in your build lab. Instead, 
NonInteractive will exit the script with an appropriate error.

nop/NoProfile: This disables loading the user configured profile into the 
powershell session. 

Unfortunately, even the built in system user profiles 
can affect things line Json serialization and produce inconsistent results
between different machines, or even different OS versions (Win 10 vs Windows
Server 2019). Just avoid the whole mess by skipping user profile.

ex/ExecutionPolicy: constrols whether powershell will run your script. System
administrators may have opted into an execution policy that's incompatible with
your script, e.g. out of a misguided attempt to "secure" the machine. This command
line option instead tells this powershell host to ignore all execution policies 
and run your script.

### Self-documenting Scripts

This snippet enables help support for your script without having to first open
a powershell command prompt:

```powershell
if (($args | ? { ($_ -match '^(-h|-\?|--help|/h|/\?)$') }).Count -gt 0) {
    Get-Help $MyInvocation.ScriptName
    exit 1
}
```

## Powershell as cmd script

If you start a cmd script with the following three lines, you can write the rest of the script as a powershell script, with most language features intact.

This can be handy for scripts you'd like to be able to put on the search path, as .ps1 scripts are not executable out-of-the-box, but .cmd scripts are.

```batch
<# ::
@powershell -noni -nop -ex Bypass -Command "$a=@([Environment]::GetCommandLineArgs() | %% { if ($on) { $_ } else { $on = $_ -eq '###' } }); & (iex ('{' + (Get-Content -Raw '%~f0')+'}')) @a" ### %* & goto :eof
#>
param($name)
echo "Hello, $name!"
```

Note that you should get full commandlet binding in your script.

For more details, see [./examples/embed.cmd](./examples/embed.cmd)

