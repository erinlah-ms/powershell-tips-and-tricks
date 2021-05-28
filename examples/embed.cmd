<# ::
@powershell -noni -nop -ex Bypass -Command "$a=@([Environment]::GetCommandLineArgs() | %% { if ($on) { $_ } else { $on = $_ -eq '###' } }); & (iex ('{' + (Get-Content -Raw '%~f0')+'}')) @a" ### %* & goto :eof
::
:: Example of embedding powershell in a batch script, so the powershell
:: script may be added on the path in a shell environment.
::
:: To try this out, from windows prompt, type:
::
::   embed "It's `its`, not `it's`"
::
:: this should properly echo exactly one arg:
::   
::   argcount=1
::   arg0=It's `its`, not `it's
::
:: Compare/contrast with https://stackoverflow.com/a/29881143
#>

echo "argcount=$($args.count)"
for ($i = 0; $i -lt $args.count; $i++) {
    "args$i=$($args[$i])"
}
