<# :: 
@echo off
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
setlocal
set "_cmd=$_args=[Environment]::GetCommandLineArgs()"
set "_cmd=%_cmd%; $_args = $_args | Select-Object -Skip ($_args.IndexOf('###')+1)"
set "_cmd=%_cmd%; & (iex ('{' + (Get-Content -Raw '%~f0')+'}')) @_args"
powershell -noni -nop -ex Bypass -Command ^
  "%_cmd%" ^
  ### %*

goto :eof
#>
echo "argcount=$($args.count)"
for ($i = 0; $i -lt $args.count; $i++) {
    "args$i=$($args[$i])"
}
