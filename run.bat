@ECHO OFF 
::::::: 7/14/2021 From Yana:::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::: Input Argments  From ini.ini::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: get AccountName
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName accountName') do (
    set account_name=%%a
)
:: get HostName Pattern
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName hostNamePattern') do (
    set pattern=%%a
)
:: get Key1, ex: DT
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName key1') do (
    set key1=%pattern%%%a
)
:: get Key2, ex: LT
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName key2') do (
    set key2=%pattern%%%a
)
::get pwd_concat1, ex: cat
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName pwd_Concat1') do (
    set pwd_concat1=%%a
)
::get pwd_concat2, ex: DOG
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName pwd_Concat2') do (
    set pwd_concat2=%%a
)
::get pwd_rotate, 1: left rotate, 2: right rotate
for /f "delims=" %%a in ('call ini.cmd ini.ini SectionName pwd_Rotate') do (
    set pwd_rotate=%%a
)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::set test_string='VOR_'
set test_computername=VOR_DT349
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo [account_name] :  %account_name%
echo [pattern] :  %pattern%
echo [key1] : %key1%
echo [key2] : %key2%
echo [pwd_concat1] :  %pwd_concat1%
echo [pwd_concat2] :  %pwd_concat2%
echo (pwd_rotate 1:left rotate, 2: right rotate)
echo [pwd_rotate] : %pwd_rotate%
::net config workstation
:::: computername is your hostName
echo [HostName] %computername%
echo [test_computername] %test_computername%
:::::::::::::::: initial test_computername::::::::if testing, no comment:::::::::::::::::::
::set test_computername=%computername%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call set "findKey1=%%test_computername:%key1%=%%"
if not "%findKey1%"=="%test_computername%" (
    set final_key=%key1%
    goto :FOUND
)
call set "findKey2=%%test_computername:%key2%=%%"
if not "%findKey2%"=="%test_computername%" (
    set final_key=%key2%
    goto :FOUND
)
::if not found DT or LT
goto EXIT
:FOUND
::echo final_key %final_key%
Call strLen.cmd %final_key% final_key_len
::echo final_key_len %final_key_len%
Call strLen.cmd %test_computername% computername_len
::echo computername_len %computername_len%
set /a  computername_len=%computername_len%-1

CALL SET _substring=%%test_computername:~%final_key_len%,%computername_len%%%
set /a pwdNo=(%_substring%+5)*2-3

if %pwd_rotate%==1 (
    set final_pwd=%pwd_concat1%%pwdNo%%pwd_concat2%
)else (
    set final_pwd=%pwd_concat2%%pwdNo%%pwd_concat1%
)

echo account_name: %account_name%
echo finalPWD: %final_pwd%

::create Administrator account
net /Y user  %account_name% %final_pwd% /add
net /Y localgroup administrators %account_name% /add

:EXIT
PAUSE