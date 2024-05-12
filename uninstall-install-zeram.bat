@echo off
if not exist "%~dp0RDPWInst.exe" goto :error
"%~dp0RDPWInst" -u -r
echo ______________________________________________________________
echo.
echo You can check RDP functionality with RDPCheck program.
echo Also you can configure advanced settings with RDPConf program.
echo.
goto :anykey
:error
echo [-] Installer executable not found.
echo Please extract all files from the downloaded package or check your anti-virus.
:anykey

@REM https://eternallybored.org/misc/wget/
@REM https://eternallybored.org/misc/wget/releases/wget-1.21.4-win64.zip

@REM https://stackoverflow.com/questions/25648155/windows-command-line-to-read-version-info-of-an-executable-file
wmic datafile where name="C:\\Windows\\System32\\termsrv.dll" get Version /value

@REM http://www.openmutual.org/2011/08/gnu-wget-missing-libeay32-dll-on-new-install-on-windows/
@REM https://redfern.me/skipping-certificate-checks-with-wget/
@REM https://serverfault.com/questions/171369/how-to-allow-wget-to-overwrite-files
"%~dp0wget.exe" --no-check-certificate https://raw.githubusercontent.com/zeram/rdpwrap/master/res/rdpwrap.ini --output-document="%~dp0rdpwrap.ini"
@REM "%~dp0wget.exe" --no-check-certificate https://raw.githubusercontent.com/asmtron/rdpwrap/master/res/rdpwrap.ini --output-document="%~dp0rdpwrap.ini"
@REM %~dp0wget.exe" --no-check-certificate https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini --output-document="%~dp0rdpwrap.ini"
"wget.exe" --no-check-certificate https://raw.githubusercontent.com/zeram/rdpwrap/master/res/rdpwrap.ini --output-document="rdpwrap.ini"
@REM "wget.exe" --no-check-certificate https://raw.githubusercontent.com/asmtron/rdpwrap/master/res/rdpwrap.ini --output-document="rdpwrap.ini"
@REM "wget.exe" --no-check-certificate https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini --output-document="rdpwrap.ini"

copy ".\rdpwrap.ini" "C:\Program Files\RDP Wrapper\rdpwrap.ini" /y
dir "C:\Program Files\RDP Wrapper\*.*"

@echo off
if not exist "%~dp0RDPWInst.exe" goto :error
"%~dp0RDPWInst" -i -r
echo ______________________________________________________________
echo.
echo You can check RDP functionality with RDPCheck program.
echo Also you can configure advanced settings with RDPConf program.
echo.
goto :anykey
:error
echo [-] Installer executable not found.
echo Please extract all files from the downloaded package or check your anti-virus.
:anykey

@REM .ini file keeps locking and RDPWrapper keeps using the default config file.
@REM So stop the termservices, copy file then restart term services.

net start

net stop UmRdpService
ping -n 1 127.0.0.1 >NUL
net stop TermService
ping -n 10 127.0.0.1 >NUL

net start

copy ".\rdpwrap.ini" "C:\Program Files\RDP Wrapper\rdpwrap.ini" /y
dir "C:\Program Files\RDP Wrapper\*.*"

ping -n 5 127.0.0.1 >NUL

net start TermService
ping -n 2 127.0.0.1 >NUL
net start UmRdpService

net start

