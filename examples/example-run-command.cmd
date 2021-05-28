<# :: 
@echo off
setlocal
set _args=%*
::set _args=%_args:"="""%
::set _args=%_args:`=``%
::set _args=%_args:$=`$%
powershell -noni -nop -ex Bypass -Command "& (iex ('{ ' + (Get-Content -Raw '%~f0') + '}')) %_args% "
::powershell -noni -nop -ex Bypass -Command "& (iex ('{ ' + (Get-Content -Raw '%~f0') + '}')) %_args% "
::powershell -noni -nop -ex Bypass -Command "echo (iex ('{ ' + (Get-Content -Raw '%~f0') + '}'))"
goto :eof
#>
echo "`$args.count=$($args.count)"
for ($i = 0; $i -lt $args.count; $i++) {
    "`$args[$i]=$($args[$i])"
}
