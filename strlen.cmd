@echo off
Setlocal EnableDelayedExpansion
:: strLen String [RtnVar]
::             -- String  The string to be measured, surround in quotes if it contains spaces.
::             -- RtnVar  An optional variable to be used to return the string length.
Set "s=#%~1"
Set "len=0"
For %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
  if "!s:~%%N,1!" neq "" (
    set /a "len+=%%N"
    set "s=!s:~%%N!"
  )
)
Endlocal&if "%~2" neq "" (set %~2=%len%) else echo %len%
Exit /b