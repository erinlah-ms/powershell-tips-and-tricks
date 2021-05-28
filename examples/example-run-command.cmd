<# :: 
@echo off
::
:: Self contained script

setlocal
:argsloop
if "%~1" == "" goto :argsdone
set _arg=%~1
set _arg=%_arg:"="""%
set _arg=%_arg:`=``%
set _arg=%_arg:$=`$%
set _args=%_args% "%_arg%"
shift
goto :argsloop
:argsdone
echo %_args%
::powershell -noni -nop -ex Bypass -Command "& (iex ('{ ' + (Get-Content -Raw '%~f0') + '}')) %_args% "
::powershell -noni -nop -ex Bypass -Command "& (iex """{ $(Get-Content -Raw '%~f0') }""") %_args% "
::powershell -noni -nop -ex Bypass -Command "echo (iex ('{ ' + (Get-Content -Raw '%~f0') + '}'))"
goto :eof
#>
echo "`$args.count=$($args.count)"
for ($i = 0; $i -lt $args.count; $i++) {
    "`$args[$i]=$($args[$i])"
}
